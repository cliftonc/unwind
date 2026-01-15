---
name: analyzing-frontend-layer
description: Use when analyzing frontend/UI layer including components, state management, routing, and API integration (optional - skip if no frontend exists)
---

# Analyzing Frontend Layer

**Output:** `docs/unwind/layers/frontend.md` (or `frontend/` directory if large)

**Principles:** See `analysis-principles.md` - completeness, machine-readable, link to source, no commentary.

## Process

1. **Find all frontend artifacts:**
   - Component files
   - State management (store, slices, atoms)
   - Route definitions
   - API client/hooks

2. **Document ALL components:**
   - Include actual component code
   - Show props/types
   - Link to source files

3. **Document state management:**
   - Include actual store definitions
   - Show all slices/reducers/atoms

4. **If large:** Split by feature into `layers/frontend/{feature}.md`

## Output Format

```markdown
# Frontend Layer

## Technology Stack

```json
{
  "framework": "react",
  "version": "18.2.0",
  "language": "typescript",
  "stateManagement": "redux-toolkit",
  "routing": "react-router-dom",
  "styling": "tailwind",
  "build": "vite"
}
```

Source: [package.json](https://github.com/owner/repo/blob/main/package.json)

## Routes

[routes.tsx](https://github.com/owner/repo/blob/main/src/router/routes.tsx)

```tsx
export const routes: RouteObject[] = [
  { path: '/', element: <HomePage /> },
  { path: '/login', element: <LoginPage /> },
  {
    path: '/dashboard',
    element: <ProtectedRoute><DashboardLayout /></ProtectedRoute>,
    children: [
      { index: true, element: <DashboardHome /> },
      { path: 'orders', element: <OrdersPage /> },
      { path: 'orders/:id', element: <OrderDetailPage /> },
    ]
  },
  { path: '*', element: <NotFoundPage /> }
];
```

## Components

### UserDashboard

[UserDashboard.tsx](https://github.com/owner/repo/blob/main/src/pages/Dashboard/UserDashboard.tsx)

```tsx
export function UserDashboard() {
  const { user } = useAuth();
  const { data: orders, isLoading } = useOrders();

  if (isLoading) return <Spinner />;

  return (
    <div className="p-6">
      <h1>Welcome, {user.name}</h1>
      <OrdersTable orders={orders} />
    </div>
  );
}
```

[Continue for ALL components...]

## State Management

### Store Configuration

[store.ts](https://github.com/owner/repo/blob/main/src/store/store.ts)

```tsx
export const store = configureStore({
  reducer: {
    auth: authReducer,
    ui: uiReducer,
    [api.reducerPath]: api.reducer,
  },
  middleware: (getDefault) => getDefault().concat(api.middleware),
});
```

### Auth Slice

[authSlice.ts](https://github.com/owner/repo/blob/main/src/store/authSlice.ts)

```tsx
interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
}

const authSlice = createSlice({
  name: 'auth',
  initialState: { user: null, token: null, isAuthenticated: false },
  reducers: {
    setCredentials: (state, action: PayloadAction<{ user: User; token: string }>) => {
      state.user = action.payload.user;
      state.token = action.payload.token;
      state.isAuthenticated = true;
    },
    logout: (state) => {
      state.user = null;
      state.token = null;
      state.isAuthenticated = false;
    },
  },
});
```

[Continue for ALL slices...]

## API Hooks

[api.ts](https://github.com/owner/repo/blob/main/src/api/api.ts)

```tsx
export const api = createApi({
  baseQuery: fetchBaseQuery({
    baseUrl: '/api/v1',
    prepareHeaders: (headers, { getState }) => {
      const token = (getState() as RootState).auth.token;
      if (token) headers.set('authorization', `Bearer ${token}`);
      return headers;
    },
  }),
  endpoints: (builder) => ({
    getUser: builder.query<User, void>({
      query: () => '/users/me',
    }),
    getOrders: builder.query<Order[], void>({
      query: () => '/orders',
    }),
    createOrder: builder.mutation<Order, CreateOrderRequest>({
      query: (body) => ({ url: '/orders', method: 'POST', body }),
    }),
  }),
});

export const { useGetUserQuery, useGetOrdersQuery, useCreateOrderMutation } = api;
```

## Component Tree

```mermaid
graph TD
    App --> Router
    Router --> HomePage
    Router --> LoginPage
    Router --> DashboardLayout
    DashboardLayout --> Sidebar
    DashboardLayout --> DashboardHome
    DashboardLayout --> OrdersPage
    DashboardLayout --> OrderDetailPage
```

## Unknowns

- [List anything unclear]
```

## Additional Requirements

### Focus on WHAT, not HOW

The goal is to enable rebuild in ANY framework. Prioritize documenting functionality over implementation.

### MUST Document (Essential for Feature Parity)

| Category | What to Document | Example |
|----------|------------------|---------|
| **User Flows** | What users can do, step by step | "User creates budget → selects calendar → adds positions → publishes" |
| **Page Purposes** | What each page accomplishes | "BudgetViewPage: View, edit, compare budgets" |
| **State Persistence** | What state survives refresh | "Auth token, selected org, theme preference" |
| **Permission Gates** | What requires authorization | "Budget publish requires admin role" |
| **API Interactions** | What data is fetched/mutated | "Page fetches /api/budgets on mount" |

### SHOULD Document (Valuable Patterns)

| Category | What to Document |
|----------|------------------|
| Component hierarchy | Parent-child relationships |
| Route structure | URL patterns and nesting |
| Error boundaries | How errors are caught and displayed |
| Loading states | What users see during fetches |

### DON'T Document (Tech-Specific)

| Category | Why to Omit |
|----------|-------------|
| CSS class names | Framework-specific (Tailwind, etc.) |
| React hook implementations | Can use different state management |
| Component library usage | DaisyUI, MUI, etc. are choices |
| Build configuration | Vite, Webpack are tools |

### Page Documentation Format

```markdown
### BudgetViewPage [MUST]

**Purpose:** View and edit budget allocations with comparison to snapshots

**User Flow:**
1. Select calendar and period filters
2. View position-team allocation grid
3. Edit allocations (if draft status)
4. Compare to snapshot (optional)
5. Publish budget (admin only)

**Permissions:**
- View: manager, admin, owner
- Edit: admin, owner (draft only)
- Publish: admin, owner

**API Dependencies:**
- GET /api/budgets/:id
- PUT /api/budgets/:id
- GET /api/snapshots (for comparison)
```

## Refresh Mode

If `frontend.md` exists, compare and add `## Changes Since Last Review` section.
