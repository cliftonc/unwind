---
name: analyzing-api-layer
description: Use when analyzing REST/GraphQL API endpoints, contracts, authentication, and client-facing interfaces
---

# Analyzing API Layer

**Output:** `docs/unwind/layers/api.md` (or `api/` directory if large)

**Principles:** See `analysis-principles.md` - completeness, machine-readable, link to source, no commentary.

## Process

1. **Find all API artifacts:**
   - Controller/route classes
   - OpenAPI/Swagger specs
   - GraphQL schemas
   - Security configuration

2. **Document ALL endpoints:**
   - Include actual controller code
   - Extract OpenAPI spec if available
   - Link to source files

3. **Document authentication:**
   - Include actual security config
   - Show filter/middleware code

4. **If large:** Split by domain into `layers/api/{domain}.md`

## Output Format

```markdown
# API Layer

## Endpoints

### UserController

[UserController.java](https://github.com/owner/repo/blob/main/src/controller/UserController.java)

```java
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final UserMapper userMapper;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public UserResponse createUser(@Valid @RequestBody CreateUserRequest request) {
        User user = userService.createUser(request);
        return userMapper.toResponse(user);
    }

    @GetMapping("/me")
    @PreAuthorize("isAuthenticated()")
    public UserResponse getCurrentUser(@AuthenticationPrincipal UserDetails user) {
        return userMapper.toResponse(userService.getByEmail(user.getUsername()));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public UserResponse getUser(@PathVariable Long id) {
        return userMapper.toResponse(userService.getUser(id));
    }
}
```

[Continue for ALL controllers...]

## Endpoint Summary

| Method | Path | Auth | Handler |
|--------|------|------|---------|
| POST | /api/v1/users | None | UserController.createUser |
| GET | /api/v1/users/me | User | UserController.getCurrentUser |
| GET | /api/v1/users/{id} | Admin | UserController.getUser |
| POST | /api/v1/orders | User | OrderController.createOrder |

[List ALL endpoints...]

## OpenAPI Specification

```yaml
openapi: 3.0.0
info:
  title: User API
  version: 1.0.0
paths:
  /api/v1/users:
    post:
      operationId: createUser
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserResponse'
```

## Security Configuration

[SecurityConfig.java](https://github.com/owner/repo/blob/main/src/config/SecurityConfig.java)

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            .csrf(csrf -> csrf.disable())
            .sessionManagement(session -> session.sessionCreationPolicy(STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/auth/**").permitAll()
                .requestMatchers("/api/v1/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
            .build();
    }
}
```

## Error Responses

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(UserNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorResponse handleNotFound(UserNotFoundException ex) {
        return new ErrorResponse("USER_NOT_FOUND", ex.getMessage());
    }
}
```

## Unknowns

- [List anything unclear]
```

## Refresh Mode

If `api.md` exists, compare and add `## Changes Since Last Review` section.
