---
name: analyzing-service-layer
description: Use when analyzing business logic, use cases, service orchestration, and data transformation including DTOs and mappers
---

# Analyzing Service Layer

**Output:** `docs/unwind/layers/service-layer.md` (or `service-layer/` directory if large)

**Principles:** See `analysis-principles.md` - completeness, machine-readable, link to source, no commentary.

## Process

1. **Find all service artifacts:**
   - Service classes
   - DTOs (request/response)
   - Mappers
   - External clients

2. **Document ALL services:**
   - Include actual method signatures
   - Show transaction boundaries
   - Link to source files

3. **Document ALL DTOs:**
   - Include actual class definitions
   - Show validation annotations

4. **If large:** Split by domain into `layers/service-layer/{domain}.md`

## Output Format

```markdown
# Service Layer

## Services

### UserService

[UserService.java](https://github.com/owner/repo/blob/main/src/service/UserService.java)

```java
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;

    @Transactional
    public User createUser(CreateUserRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new DuplicateEmailException(request.email());
        }
        User user = new User(request.email(), passwordEncoder.encode(request.password()));
        user = userRepository.save(user);
        emailService.sendWelcome(user);
        return user;
    }

    @Transactional(readOnly = true)
    public User getUser(Long id) {
        return userRepository.findById(id)
            .orElseThrow(() -> new UserNotFoundException(id));
    }
}
```

[Continue for ALL services...]

## DTOs

### CreateUserRequest

[CreateUserRequest.java](https://github.com/owner/repo/blob/main/src/dto/CreateUserRequest.java)

```java
public record CreateUserRequest(
    @NotBlank @Email String email,
    @NotBlank @Size(min = 8) String password,
    @NotBlank String name
) {}
```

### UserResponse

```java
public record UserResponse(
    Long id,
    String email,
    String name,
    UserStatus status,
    Instant createdAt
) {}
```

[Continue for ALL DTOs...]

## Mappers

### UserMapper

[UserMapper.java](https://github.com/owner/repo/blob/main/src/mapper/UserMapper.java)

```java
@Mapper(componentModel = "spring")
public interface UserMapper {
    UserResponse toResponse(User user);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "status", constant = "ACTIVE")
    User toEntity(CreateUserRequest request);
}
```

## External Clients

### StripeClient

[StripeClient.java](https://github.com/owner/repo/blob/main/src/client/StripeClient.java)

```java
@Component
public class StripeClient {
    @Retryable(maxAttempts = 3, backoff = @Backoff(delay = 1000))
    public PaymentResult charge(String token, Money amount) {
        // Stripe API call
    }
}
```

## Service Dependencies

```mermaid
graph TD
    UserService --> UserRepository
    UserService --> PasswordEncoder
    UserService --> EmailService
    OrderService --> OrderRepository
    OrderService --> UserService
    OrderService --> PaymentService
    PaymentService --> StripeClient
```

## Unknowns

- [List anything unclear]
```

## Additional Requirements

### Formula Documentation [MUST]

For every calculation or business formula:

1. **Document with exact source reference:**
```markdown
### Cost Calculation [MUST]

**Source:** `snapshot-operations.ts:186`

```typescript
total = periods[rate.interval] * rate.rate * fteBasis * allocation * holidayPercentage
```
```

2. **Document ALL edge cases and conditional logic:**
```markdown
### Rate Interval Edge Cases [MUST]

| Interval | Formula | Note |
|----------|---------|------|
| hours | workingDays * 8 * rate * fte * allocation | 8 hours/day hardcoded |
| days | workingDays * rate * fte * allocation | Standard |
| weeks | ceil(workingDays/5) * rate * fte * allocation | Rounds up |
| months | rate * fte * allocation | **NO period multiplier** |
| years | (workingDays/365) * rate * fte * allocation | Prorated |
```

3. **Document hardcoded constants:**
```markdown
### Constants [MUST]

| Constant | Value | Location |
|----------|-------|----------|
| hoursPerDay | 8 | builder.ts:185 |
| daysInYear | 365 | builder.ts:208 |
```

### Fallback/Resolution Logic [MUST]

Document any fallback chains or resolution hierarchies:
```markdown
### Rate Resolution Chain [MUST]

1. **Primary:** supplier + employmentType + roleLevel + calendar + branch
2. **Fallback:** supplier + calendar + branch (null employmentType/roleLevel)
3. **Missing:** Logged to missingRates array, uses 0
```

### Transaction Boundaries [SHOULD]

Note where transactions begin/end and any batch processing patterns.

## Refresh Mode

If `service-layer.md` exists, compare and add `## Changes Since Last Review` section.
