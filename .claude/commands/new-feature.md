Создай новую фичу "$ARGUMENTS" для Flutter ride-sharing driver app.

## Порядок создания

### 1. Модель (если фича работает с API)
- Посмотри эндпоинты в `api-1.yaml`, связанные с этой фичей
- Создай freezed-модель в `lib/core/models/` (или `lib/features/$ARGUMENTS/models/` если модель специфична для фичи)
- Используй `abstract class` (Freezed 3.x), `@JsonKey(name:)` для snake_case
- Добавь `fromJson` factory

### 2. Сервис (если фича работает с API)
- Abstract класс в `lib/core/services/<feature>_service.dart`
- Реализация в `lib/core/services/<feature>_service_impl.dart`
- `@LazySingleton(as: FeatureService)` на реализации
- Методы ловят `DioException` → `mapDioException()`

### 3. Cubit + State
- State: `lib/features/$ARGUMENTS/cubit/<feature>_state.dart` — freezed с status enum
- Cubit: `lib/features/$ARGUMENTS/cubit/<feature>_cubit.dart` — `@injectable`, зависит от абстракции сервиса
- Проверяй `connectivityService.isConnected` перед API-вызовами

### 4. Экраны и виджеты
- Экран: `lib/features/$ARGUMENTS/screens/<feature>_screen.dart`
- Виджеты: `lib/features/$ARGUMENTS/widgets/` — отдельные классы, не `_build` методы
- Используй компоненты из `lib/core/widgets/` (AppButton, AppTextField, AppCard и т.д.)
- Следуй `docs/DESIGN_SYSTEM.md` для стилей
- Обработай все состояния: initial, loading, loaded/success, error, empty

### 5. Роут
- Добавь path-константу в `AppRoutes` в `app/router/app_router.dart`
- Добавь `GoRoute` в нужное место (под ShellRoute если таб, или верхний уровень)
- Оберни экран в `BlocProvider(create: (_) => getIt<FeatureCubit>())`

### 6. Кодогенерация
- Запусти `dart run build_runner build --delete-conflicting-outputs`
- Проверь что `flutter analyze` проходит без ошибок

## Обязательные правила
- Следуй CLAUDE.md: SOLID, DRY, KISS, YAGNI
- `const` конструкторы, `final` по умолчанию
- Никаких `dynamic`, `!`, `print()`, хардкод-значений
- Именование: файлы snake_case, классы PascalCase
- Импорты: `package:driver/...` (не относительные)
