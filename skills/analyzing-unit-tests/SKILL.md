---
name: analyzing-unit-tests
description: Use when analyzing unit test coverage, patterns, and test code for isolated component testing
---

# Analyzing Unit Tests

**Output:** `docs/unwind/layers/unit-tests.md` (or `unit-tests/` directory if large)

**Principles:** See `analysis-principles.md` - completeness, machine-readable, link to source, no commentary.

## Process

1. **Find all unit test artifacts:**
   - Test files (`*Test.java`, `*.test.ts`, `test_*.py`)
   - Test configuration
   - Mock/stub definitions
   - Test utilities

2. **Document ALL test classes:**
   - Include actual test code
   - Show what is being tested
   - Link to source files

3. **Map coverage:**
   - Which classes/functions have tests
   - Which do not

4. **If large:** Split by domain into `layers/unit-tests/{domain}.md`

## Output Format

```markdown
# Unit Tests

## Configuration

[pom.xml test dependencies](https://github.com/owner/repo/blob/main/pom.xml#L50-L70)

```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.9.0</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>5.0.0</version>
    <scope>test</scope>
</dependency>
```

## Test Summary

| Layer | Classes | Tested | Coverage |
|-------|---------|--------|----------|
| Service | 12 | 10 | 83% |
| Domain | 8 | 8 | 100% |
| Repository | 6 | 4 | 67% |

## Service Tests

### UserServiceTest

[UserServiceTest.java](https://github.com/owner/repo/blob/main/src/test/java/service/UserServiceTest.java)

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private UserService userService;

    @Test
    void createUser_success() {
        CreateUserRequest request = new CreateUserRequest("test@example.com", "password", "Test");
        when(userRepository.existsByEmail(request.email())).thenReturn(false);
        when(passwordEncoder.encode(request.password())).thenReturn("encoded");
        when(userRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        User result = userService.createUser(request);

        assertThat(result.getEmail()).isEqualTo("test@example.com");
        verify(userRepository).save(any());
    }

    @Test
    void createUser_duplicateEmail_throws() {
        CreateUserRequest request = new CreateUserRequest("existing@example.com", "password", "Test");
        when(userRepository.existsByEmail(request.email())).thenReturn(true);

        assertThrows(DuplicateEmailException.class, () -> userService.createUser(request));
    }
}
```

Tests: `createUser_success`, `createUser_duplicateEmail_throws`, `getUser_success`, `getUser_notFound_throws`

[Continue for ALL test classes...]

## Domain Tests

### UserTest

[UserTest.java](https://github.com/owner/repo/blob/main/src/test/java/domain/UserTest.java)

```java
class UserTest {

    @Test
    void suspend_activeUser_setsSuspended() {
        User user = new User("test@example.com", "hash");
        user.setStatus(UserStatus.ACTIVE);

        user.suspend();

        assertThat(user.getStatus()).isEqualTo(UserStatus.SUSPENDED);
    }

    @Test
    void suspend_deletedUser_throws() {
        User user = new User("test@example.com", "hash");
        user.setStatus(UserStatus.DELETED);

        assertThrows(IllegalStateException.class, () -> user.suspend());
    }
}
```

## Test Utilities

### TestDataFactory

[TestDataFactory.java](https://github.com/owner/repo/blob/main/src/test/java/util/TestDataFactory.java)

```java
public class TestDataFactory {
    public static User createUser() {
        return new User("test@example.com", "encodedPassword");
    }

    public static Order createOrder(User user) {
        Order order = new Order(user);
        order.addItem(createProduct(), 2);
        return order;
    }
}
```

## Coverage Gaps

Classes without unit tests:
- `PaymentService`
- `NotificationService`
- `LegacyOrderAdapter`

## Unknowns

- [List anything unclear]
```

## Refresh Mode

If `unit-tests.md` exists, compare and add `## Changes Since Last Review` section.
