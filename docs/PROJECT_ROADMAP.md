# Project Roadmap - Intercity Taxi Passenger App

> Системный план разработки приложения пассажира

## Подход к разработке

```
UI-FIRST: Вёрстка → Ревью → Логика
```

1. **Этап 1: Вёрстка** - создаём все экраны с mock данными
2. **Этап 2: Ревью** - показываем, получаем фидбек
3. **Этап 3: Логика** - подключаем API, state management

---

## Текущий статус

| Компонент | Статус |
|-----------|--------|
| UI/UX Plan | ✅ Готово |
| Design System | ✅ Готово |
| **UI Вёрстка** | 🔜 **Ожидает** |
| Логика/API | 🔜 После ревью UI |

---

## Этап 1: UI Вёрстка (без логики)

### Фаза 1.1: Подготовка ✅
- [x] Структура папок
- [x] Установка пакетов (UI only)
- [x] AppTheme (светлая + тёмная) - Teal
- [x] Базовые UI компоненты (кнопки, инпуты, карточки)
- [x] Mock данные для рынка USA

### Фаза 1.2: Онбординг и Авторизация
- [ ] SplashScreen
- [ ] OnboardingScreen (3 слайда)
- [ ] PhoneInputScreen
- [ ] OtpScreen

### Фаза 1.3: Регистрация пассажира
- [ ] ProfileSetupScreen (имя, email)

### Фаза 1.4: Главная и Поиск
- [ ] MainShell (Bottom Navigation)
- [ ] HomeScreen (поиск поездок)
- [ ] SearchResultsScreen
- [ ] FiltersScreen

### Фаза 1.5: Бронирование
- [ ] TripDetailsScreen (детали поездки водителя)
- [ ] BookingScreen (выбор мест, подтверждение)
- [ ] BookingConfirmationScreen

### Фаза 1.6: Мои поездки
- [ ] MyTripsScreen (активные, прошлые)
- [ ] TripStatusScreen (статус забронированной поездки)
- [ ] TripCompletedScreen (оценка водителя)

### Фаза 1.7: Чат
- [ ] ChatsListScreen
- [ ] ChatScreen

### Фаза 1.8: Профиль
- [ ] ProfileScreen
- [ ] EditProfileScreen
- [ ] SettingsScreen
- [ ] FavoritesScreen (сохранённые маршруты)

---

## Команды установки пакетов

```bash
# UI пакеты (для вёрстки)
flutter pub add google_fonts
flutter pub add flutter_svg
flutter pub add cached_network_image
flutter pub add shimmer
flutter pub add smooth_page_indicator
flutter pub add pinput
flutter pub add flutter_animate

# Навигация (нужна для переходов между экранами)
flutter pub add go_router

# Dev dependencies
flutter pub add --dev flutter_lints
```

**Пакеты для логики (установим позже):**
```bash
# После ревью UI
flutter pub add flutter_riverpod
flutter pub add dio
flutter pub add retrofit
flutter pub add shared_preferences
flutter pub add flutter_secure_storage
```

---

## Структура проекта (UI-first)

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── constants/
│   │   └── app_spacing.dart
│   ├── router/
│   │   └── app_router.dart
│   └── widgets/                    # Переиспользуемые UI компоненты
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── app_card.dart
│       └── ...
│
├── features/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── auth/
│   │   ├── phone_input_screen.dart
│   │   └── otp_screen.dart
│   ├── registration/
│   │   └── profile_setup_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── search/
│   │   ├── search_results_screen.dart
│   │   └── filters_screen.dart
│   ├── trips/
│   │   ├── trip_details_screen.dart
│   │   ├── my_trips_screen.dart
│   │   ├── trip_status_screen.dart
│   │   └── trip_completed_screen.dart
│   ├── bookings/
│   │   ├── booking_screen.dart
│   │   └── booking_confirmation_screen.dart
│   ├── chat/
│   │   ├── chats_list_screen.dart
│   │   └── chat_screen.dart
│   └── profile/
│       ├── profile_screen.dart
│       ├── edit_profile_screen.dart
│       ├── settings_screen.dart
│       └── favorites_screen.dart
│
└── shared/
    └── widgets/
        └── bottom_nav_shell.dart
```

---

## Mock данные (USA)

Для вёрстки используем статичные данные прямо в виджетах или в отдельных файлах:

```dart
// lib/core/mocks/mock_data.dart

class MockData {
  static const user = {
    'name': 'John Smith',
    'phone': '+1 (555) 123-4567',
    'email': 'john@example.com',
  };

  static const trips = [
    {
      'from': 'New York',
      'to': 'Boston',
      'date': 'January 30',
      'time': '2:00 PM',
      'driver': 'Mike Johnson',
      'rating': 4.85,
      'price': '\$45',
      'seats_available': 2,
    },
    {
      'from': 'Los Angeles',
      'to': 'San Diego',
      'date': 'February 1',
      'time': '10:00 AM',
      'driver': 'Sarah Williams',
      'rating': 4.92,
      'price': '\$35',
      'seats_available': 3,
    },
    // ...
  ];

  static const popularRoutes = [
    {
      'from': 'NYC',
      'to': 'Boston',
      'price_from': '\$35',
    },
    {
      'from': 'LA',
      'to': 'San Diego',
      'price_from': '\$25',
    },
    {
      'from': 'Miami',
      'to': 'Orlando',
      'price_from': '\$30',
    },
  ];
}
```

---

## Целевой рынок: USA

| Параметр | Значение |
|----------|----------|
| Язык интерфейса | English |
| Валюта | USD ($) |
| Формат телефона | +1 (XXX) XXX-XXXX |
| Расстояние | Miles |
| Формат даты | MM/DD/YYYY |
| Формат времени | 12-hour (AM/PM) |
| Города | NYC, Boston, LA, San Diego, Chicago, Miami |

---

## Отличия от Driver App

| Аспект | Driver | Passenger |
|--------|--------|-----------|
| Цвет | Blue (#1E88E5) | **Teal (#009688)** |
| Регистрация | Сложная (документы, авто) | **Простая (имя, email)** |
| Главный экран | Создание поездок | **Поиск поездок** |
| Навигация | 5 вкладок | **4 вкладки** |
| Верификация | Требуется (документы) | **Не требуется** |
| Фокус | Публикация маршрутов | **Бронирование мест** |

---

## Следующий шаг

**Фаза 1.2: Онбординг и Авторизация**

1. Создать SplashScreen
2. Создать OnboardingScreen (3 слайда для пассажира)
3. Создать PhoneInputScreen
4. Создать OtpScreen

---

## Промпт для нового чата

Используй файл `docs/CLAUDE_PROMPT.md` для продолжения работы в новых чатах.
