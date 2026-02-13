# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter-based intercity ride-sharing passenger mobile app (iOS/Android). Minimalist Uber/Bolt-style UI with Material Design 3, Inter font via google_fonts.

- **Package**: `com.ridesharing.passenger`
- **Dart SDK**: ^3.10.7
- **API Base URL**: To be configured in `lib/core/network/api_client.dart`

## Documentation

| File | Description |
|------|-------------|
| `docs/DESIGN_SYSTEM.md` | Colors, typography, components, Flutter theme code (Russian) |
| `docs/UI_UX_PLAN.md` | Full UI/UX plan with user flows and screen layouts (Russian) |
| `api-1.yaml` | Backend API OpenAPI specification |

## Commands

```bash
# Development
flutter run                              # Run debug
flutter build apk                        # Build Android
flutter build ios                        # Build iOS
flutter analyze                          # Lint
flutter test                             # Run tests
flutter test test/widget_test.dart       # Run single test
flutter pub get                          # Get dependencies

# Code generation (run after changing models, DI, or routes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
dart run build_runner watch --delete-conflicting-outputs
```

## Design Principles

All code in this project MUST follow these principles. Apply them in this priority order:

1. **KISS (Keep It Simple, Stupid)** — choose the simplest solution that works. No clever tricks, no premature abstractions. If a junior developer can't understand the code in 30 seconds, it's too complex.
2. **YAGNI (You Aren't Gonna Need It)** — implement only what is needed RIGHT NOW. No "future-proof" abstractions, no unused parameters, no speculative generality.
3. **DRY (Don't Repeat Yourself)** — extract shared logic into reusable units, but only when duplication actually exists (rule of three). Premature abstraction is worse than duplication.
4. **SOLID**:
    - **Single Responsibility** — one class = one reason to change. Cubits handle state, services handle API, widgets handle UI.
    - **Open/Closed** — extend behavior without modifying existing code. Use abstract classes and interfaces.
    - **Liskov Substitution** — subtypes must be substitutable for their base types.
    - **Interface Segregation** — small, focused abstract classes. No god-interfaces.
    - **Dependency Inversion** — depend on abstractions (abstract service classes), not concretions. All services have abstract base classes; cubits depend on abstractions.

### Practical application:
- Before adding a new class/abstraction, ask: "Do I need this right now?"
- Before extracting a method, ask: "Is this duplicated in 3+ places?"
- Before adding a parameter, ask: "Is this used today?"
- Cubits should NOT know about Dio, HTTP, or storage — only about service abstractions
- Widgets should NOT know about services — only about cubits/state

## Tech Stack

```yaml
State Management: flutter_bloc (Cubits)
Navigation:       go_router (declarative, typed routes)
Network:          Dio with interceptors
DI:               get_it + injectable + injectable_generator
Models:           freezed + json_serializable (immutable, code-generated)
Storage:          flutter_secure_storage (tokens)
Images:           cached_network_image
Architecture:     Feature-based Clean Architecture with services + cubits
Code Generation:  build_runner (freezed, json_serializable, injectable, go_router)
```

## Architecture

### Dependency Injection (get_it + injectable)

DI is configured via `injectable` with code generation. No manual wiring in `main.dart`.

```
lib/
├── app/
│   └── di/
│       ├── injection.dart          # @InjectableInit, configureDependencies()
│       └── injection.config.dart   # Generated
```

Registration rules:
- Services: `@lazySingleton` on implementation, register as abstract type
- Cubits: `@injectable` (new instance per request)
- Dio client: `@module` with `RegisterModule` class
- FlutterSecureStorage: `@module`

```dart
// ✅ Service registration
@LazySingleton(as: AuthService)
class AuthServiceImpl implements AuthService { ... }

// ✅ Cubit registration
@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authService) : super(const AuthState());
  final AuthService _authService;
}

// ✅ Providing cubits in widget tree
BlocProvider(create: (_) => getIt<AuthCubit>())
```

### Project Structure (Feature-based Clean Architecture)

```
lib/
├── app/
│   ├── app.dart                    # MaterialApp.router with GoRouter
│   ├── di/                         # Injectable DI configuration
│   └── router/
│       ├── app_router.dart         # GoRouter configuration, route definitions
│       └── route_guards.dart       # Redirect logic (auth state)
├── core/
│   ├── constants/                  # AppSpacing, string keys
│   ├── extensions/                 # Dart/Flutter extension methods
│   ├── mixins/                     # ErrorHandlingMixin
│   ├── models/                     # Shared domain models (freezed)
│   ├── network/                    # ApiClient, AuthInterceptor, ApiExceptions
│   ├── services/                   # Abstract + implementation service classes
│   ├── theme/                      # AppColors, AppTextStyles, AppTheme (light + dark)
│   ├── utils/                      # Helpers, formatters, validators
│   └── widgets/                    # Shared reusable widgets
├── features/
│   ├── splash/                     # App startup, initial route determination
│   ├── onboarding/                 # 3-slide welcome carousel
│   ├── auth/                       # Phone OTP authentication
│   ├── registration/               # Profile setup (name, email, avatar)
│   ├── home/                       # MainShell (bottom nav) + home dashboard
│   ├── search/                     # Trip search
│   ├── trips/                      # Trips list + booking + details
│   ├── chats/                      # Chat list + conversation
│   └── profile/                    # Profile view/edit, settings
```

### Navigation (go_router)

Declarative routing with `GoRouter`. All routes defined in `app/router/app_router.dart`.

```dart
// Route paths as constants
abstract class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const phoneInput = '/phone-input';
  static const otp = '/otp';
  static const registration = '/registration';
  static const home = '/home';
  static const search = '/search';
  static const trips = '/trips';
  static const chats = '/chats';
  static const profile = '/profile';
// ...
}
```

Key routing logic:
- `redirect` callback handles auth state
- `ShellRoute` / `StatefulShellRoute.indexedStack` for bottom navigation (Home, Trips, Chats, Profile)
- Extra parameters passed via typed `$extra` — no `Map<String, dynamic>`

Route table:
- Startup: `/splash` → determines route
- New user: `/onboarding` → `/phone-input` → `/otp` → `/registration`
- Returning user: `/splash` → `/home`
- Main tabs: `/home`, `/trips`, `/chats`, `/profile`
- Profile: `/profile/edit`, `/profile/settings`

### State Management Pattern

All state is managed via **Cubits** (not full Blocs). States are **freezed** `abstract class`es with feature-specific status enums:

```dart
enum AuthStatus { initial, loading, otpSent, authenticated, unauthenticated, error }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    String? phoneNumber,
    String? errorMessage,
  }) = _AuthState;
}
```

Rules:
- No separate boolean flags (`isLoading`, `hasError`) — use status enum
- UI must show appropriate widget for each status (loading, success, error, empty)
- `copyWith()` for all state transitions — never mutate

### Models (freezed + json_serializable)

All models are immutable, code-generated. Freezed 3.x requires `abstract class`:

```dart
@freezed
abstract class User with _$User {
  const factory User({
    required String uuid,
    required String phone,
    String? firstName,
    String? lastName,
    String? email,
    String? avatarUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
```

Rules:
- `@JsonKey(name: 'field_name')` for snake_case ↔ camelCase mapping
- All models in `lib/core/models/` or feature-specific directories
- No hand-written `fromJson`/`toJson` — always generated
- Use `@Default()` for optional fields with defaults

### Network Layer (`lib/core/network/`)

- `ApiClient` — `createDioClient()` factory; exports `mapDioException()` for services
- `AuthInterceptor` — injects Bearer token from secure storage, handles 401
- `ApiExceptions` — hierarchy: `ApiException` (base) → `NetworkException`, `TimeoutException`, `UnauthorizedException`, `ValidationException` (422), `ConflictException` (409), `RateLimitException` (429), `ServerException` (5xx)
- `ConnectivityService` — cubits check connectivity before API calls

### Services (`lib/core/services/`)

Every service has an abstract class + implementation:

```dart
abstract class AuthService {
  Future<void> sendOtp(String phoneNumber);
  Future<AuthResult> verifyOtp(String phoneNumber, String code);
  Future<void> logout();
}

@LazySingleton(as: AuthService)
class AuthServiceImpl implements AuthService {
  AuthServiceImpl(this._dio);
  final Dio _dio;
// ...
}
```

All services catch `DioException` and rethrow via `mapDioException()`.

API endpoint groups (from `api-1.yaml`):
- `/api/v1/auth/*` — authentication
- `/api/v1/passengers/*` — passenger profile
- `/api/v1/devices/*` — push notification tokens

### Phone Number Handling
- Display format: `+1 (XXX) XXX-XXXX`
- API format: `+1XXXXXXXXXX`
- Custom `TextInputFormatter` in auth screens

## Coding Conventions

### Naming
- Files: `snake_case.dart`
- Classes, enums, typedefs: `PascalCase`
- Variables, methods, parameters: `camelCase`
- Constants: `camelCase` (Dart convention, NOT `SCREAMING_SNAKE`)
- Private members: `_prefixed`
- Boolean variables/getters: `is`/`has`/`can` prefix (`isLoading`, `hasError`, `canSubmit`)

### Dart Style
- `final` by default, `var` only when mutation is required
- `const` constructors everywhere possible
- No `dynamic` without explicit justification in a comment
- No bang operator (`!`) — use null checks, `??`, or pattern matching
- No `late` as a workaround — restructure code to avoid it
- No `as` casts without prior `is` check
- Prefer expression bodies for simple getters/methods
- Max function length: ~30 lines (guideline, not hard rule)
- Max class length: ~200 lines (extract if larger)
- Max 3-4 parameters per function — use object parameter if more

### Imports
Order (separated by blank lines):
1. Dart SDK (`dart:async`, `dart:io`)
2. Flutter (`package:flutter/material.dart`)
3. External packages (`package:dio/`, `package:flutter_bloc/`)
4. Project (`package:passenger/`)

No relative imports — always use `package:passenger/...`.

### Widgets
- **Separate widget classes** over private `_build` methods (Flutter can optimize rebuild)
- `StatelessWidget` by default, `StatefulWidget` only when `Ticker`, `TextEditingController`, or `ScrollController` is needed
- `const` constructors on all custom widgets
- Use `context.read<Cubit>()` for actions, `context.watch<Cubit>()` / `BlocBuilder` for reactive UI
- Max widget tree depth: 5-6 levels — extract sub-widgets if deeper

```dart
// ❌ Bad
Widget _buildHeader() => Container(...);

// ✅ Good
class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) => Container(...);
}
```

### Comments
- Only explain **WHY**, not **WHAT**
- `///` doc comments on all public APIs
- No commented-out code — delete it (Git has history)
- `// TODO(name): description #ticket` format for todos

## Error Handling

```
Service layer:    catches DioException → throws typed ApiException via mapDioException()
Cubit layer:      catches ApiException → emits state with status: failure + errorMessage
UI layer:         reads failure state → shows error via snackbar or error widget
```

Rules:
- Never swallow exceptions (empty `catch` blocks)
- Always check connectivity before API calls in cubits
- Use typed exceptions from `ApiExceptions` hierarchy
- `async/await` over `.then()` chains
- Always cancel `StreamSubscription` in `dispose()`/`close()`

## Adding a New Feature

Create the following structure:

```
lib/features/<feature_name>/
├── cubit/
│   ├── <feature>_cubit.dart        # @injectable
│   └── <feature>_state.dart        # @freezed
├── screens/
│   └── <feature>_screen.dart
└── widgets/
    └── <widget_name>.dart
```

**Strict rules:**
- ❌ NEVER place `*_screen.dart` files directly in the feature root — ALWAYS in `screens/`
- ❌ NEVER place reusable feature widgets directly in the feature root — ALWAYS in `widgets/`
- `cubit/`, `screens/` directories are created immediately with the feature
- `widgets/` directory is created when the feature has its first reusable widget

If the feature needs an API:
```
lib/core/services/
├── <feature>_service.dart          # Abstract class
└── <feature>_service_impl.dart     # @LazySingleton(as: FeatureService)
```

Then:
1. Add route to `app/router/app_router.dart`
2. Run `dart run build_runner build --delete-conflicting-outputs`
3. Register cubit via `BlocProvider` where needed in widget tree

## Testing

Patterns:
- Unit tests for cubits: all state transitions (initial → loading → success/failure)
- Mock services via `mocktail` (mock abstract service classes)
- Test file location mirrors source: `test/features/<feature>/cubit/<feature>_cubit_test.dart`
- Model tests: `fromJson`/`toJson` serialization
- No tests that depend on shared mutable state

Test helpers in `test/helpers/`:
- `mocks.dart` — `mocktail` mocks for all services
- `test_fixtures.dart` — factory functions for building test models
- `json_fixtures.dart` — raw JSON maps for testing `fromJson`

```bash
flutter test                             # All tests
flutter test test/features/auth/         # Feature tests
flutter test --coverage                  # With coverage report
```

## Git Commits

Format: `type: short description`

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`

Examples:
- `feat: add trip search screen`
- `fix: handle OTP timeout error`
- `refactor: migrate auth to injectable DI`

## DO NOT

- ❌ Use Riverpod or Provider — we use `flutter_bloc` (Cubits only)
- ❌ Use `Navigator.push`/`pushNamed` — we use `go_router` (`context.go()`, `context.push()`)
- ❌ Use `print()` for logging
- ❌ Add new packages without discussion
- ❌ Create `StatefulWidget` when `StatelessWidget` + Cubit works
- ❌ Hardcode strings, colors, or sizes — use `AppColors`, `AppSpacing`, theme
- ❌ Access navigation from cubits — cubits emit state, UI reacts with navigation
- ❌ Mutate state directly — only `emit(state.copyWith(...))`
- ❌ Write hand-written `fromJson`/`toJson` — use `freezed` + `json_serializable`
- ❌ Instantiate services/cubits manually — use `getIt<T>()`
- ❌ Write `_build` methods inside widgets — extract to separate widget classes
- ❌ Use `dynamic` without a comment explaining why
- ❌ Commit generated files (`*.g.dart`, `*.freezed.dart`) — they are in `.gitignore`
- ❌ Use local `StatefulWidget` state for async data — use Cubits

## Core Utilities

### Widgets (`lib/core/widgets/`)
Reusable components: `AppButton` (primary/secondary/text + loading), `AppTextField`, `AppCard`, `AvatarPicker`.

### Theme
- Colors: `AppColors` in `lib/core/theme/`
- Typography: `AppTextStyles` (Inter via google_fonts)
- Spacing: 4px base unit (`AppSpacing` in `lib/core/constants/app_spacing.dart`)
- Theme: `AppTheme` — full light + dark themes, `themeMode: ThemeMode.system`
- Images: use `CachedNetworkImage` for all network images
- Orientation: locked to portrait in `main.dart`

## Performance Guidelines

- `const` widgets wherever possible
- `ListView.builder` / `ListView.separated` for lists
- `CachedNetworkImage` for all network images
- `BlocSelector` for fine-grained state subscriptions
- No heavy computation in `build()`
- Debounce search inputs
- Paginate long lists

## Security

- API keys and secrets: NEVER in code — use `--dart-define` or `.env`
- Tokens: `flutter_secure_storage` only
- No sensitive data in logs
- Input validation on client + server

## Related Projects

- `../driver/` — Driver mobile app (reference implementation for architecture)
- `../../backend/` — Laravel/Filament backend services