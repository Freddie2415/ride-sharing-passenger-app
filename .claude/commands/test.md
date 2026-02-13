Напиши тесты для $ARGUMENTS.

Определи тип по пути:
- `lib/core/models/` → тесты модели (fromJson/toJson)
- `lib/features/*/cubit/` → тесты кубита (state transitions)
- `lib/core/services/` → тесты сервиса (API mapping)
- `lib/core/network/` → тесты network layer
- Иное → определи лучший тип тестов

## Паттерны тестирования проекта

### Моки (test/helpers/mocks.dart)
Используй существующие моки из `test/helpers/mocks.dart`. Если нужен новый мок — добавь в этот файл:
```dart
class MockFeatureService extends Mock implements FeatureService {}
```

### Фикстуры (test/helpers/)
- `test_fixtures.dart` — factory-функции: `createTestUser()`, `createTestDriverProfile()` и т.д.
- `json_fixtures.dart` — сырые JSON-мапы для тестирования `fromJson`
- Добавляй новые фикстуры в эти файлы, не создавай отдельные

### Тесты моделей
```dart
group('FeatureModel', () {
  test('should create from JSON', () {
    final json = createFeatureModelJson();
    final model = FeatureModel.fromJson(json);
    expect(model.field, expectedValue);
  });

  test('should handle missing optional fields', () { ... });
  test('should serialize to JSON', () { ... });
});
```

### Тесты кубитов
```dart
void main() {
  late FeatureCubit cubit;
  late MockFeatureService mockService;
  late MockConnectivityService mockConnectivity;

  setUp(() {
    mockService = MockFeatureService();
    mockConnectivity = MockConnectivityService();
    cubit = FeatureCubit(mockService, mockConnectivity);
  });

  tearDown(() => cubit.close());

  group('loadData', () {
    test('should emit loading then loaded on success', () async {
      when(() => mockConnectivity.isConnected).thenReturn(true);
      when(() => mockService.getData()).thenAnswer((_) async => testData);

      await cubit.loadData();

      expect(cubit.state.status, FeatureStatus.loaded);
      expect(cubit.state.data, testData);
    });

    test('should emit error when no connectivity', () async {
      when(() => mockConnectivity.isConnected).thenReturn(false);

      await cubit.loadData();

      expect(cubit.state.status, FeatureStatus.error);
    });

    test('should emit error on service exception', () async {
      when(() => mockConnectivity.isConnected).thenReturn(true);
      when(() => mockService.getData()).thenThrow(NetworkException('No connection'));

      await cubit.loadData();

      expect(cubit.state.status, FeatureStatus.error);
    });
  });
}
```

### Тесты сервисов
Тестируй маппинг `DioException` → typed `ApiException` через `mapDioException()`.

## Правила
- Файл тестов зеркалит путь исходника: `lib/features/auth/cubit/auth_cubit.dart` → `test/features/auth/cubit/auth_cubit_test.dart`
- Каждый `test()` — изолированный, без зависимости от других тестов
- Тестируй happy path + error cases + edge cases
- Используй `group()` для логической группировки
- После написания запусти `flutter test <path>` и убедись что всё зелёное
