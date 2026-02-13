Создай интеграцию с API для $ARGUMENTS.

## Шаги

### 1. Найди эндпоинт
- Открой `api-1.yaml` и найди эндпоинт(ы), связанные с "$ARGUMENTS"
- Определи: метод (GET/POST/PUT/PATCH/DELETE), путь, request body, response body
- Если эндпоинт не найден — спроси у меня

### 2. Создай/обнови модель
- Создай freezed-модель по response schema
- `abstract class` (Freezed 3.x), `@JsonKey(name:)` для snake_case полей
- Если request body сложный — создай отдельный Request DTO
- Размести в `lib/core/models/` (или `lib/features/<feature>/models/` если специфична)

### 3. Создай/обнови сервис
- Добавь метод в abstract сервис
- Реализуй в impl: вызов Dio, парсинг через `ApiResponse<T>`, `mapDioException()`
- Если сервиса ещё нет — создай пару abstract + impl с `@LazySingleton`

### 4. Кодогенерация
- Запусти `dart run build_runner build --delete-conflicting-outputs`

### 5. Тесты
- Добавь JSON-фикстуру в `test/helpers/json_fixtures.dart`
- Добавь factory-функцию в `test/helpers/test_fixtures.dart`
- Напиши тест модели: `fromJson`, `toJson`, optional fields
- Напиши тест сервиса если нужно

## Паттерн сервиса
```dart
// Abstract
abstract class FeatureService {
  Future<List<Item>> getItems({int page = 1, int perPage = 20});
  Future<Item> getItem(String id);
}

// Implementation
@LazySingleton(as: FeatureService)
class FeatureServiceImpl implements FeatureService {
  FeatureServiceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<Item>> getItems({int page = 1, int perPage = 20}) async {
    try {
      final response = await _dio.get(
        '/items',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data as List<dynamic>,
      );
      return apiResponse.data!
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
```

## Обязательно
- Следуй паттернам из CLAUDE.md
- Проверь что `flutter analyze` проходит
- Проверь что тесты проходят
