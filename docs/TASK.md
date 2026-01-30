Я разрабатываю Flutter приложение для пассажиров междугороднего такси.

## ВАЖНО: UI-FIRST подход

Сейчас мы делаем ТОЛЬКО ВЁРСТКУ (UI) без логики:
- Все экраны с mock данными
- Без API интеграции
- Без state management
- После ревью UI - будем добавлять логику
- UI должен быть на английском языке (рынок США)

## Целевой рынок: США

- Валюта: USD ($)
- Телефон: +1 (XXX) XXX-XXXX
- Расстояние: miles
- Дата: MM/DD/YYYY
- Время: 12-hour (AM/PM)
- Города: NYC, Boston, LA, San Diego, Chicago, Miami

## Документация (ПРОЧИТАЙ СНАЧАЛА)

1. `docs/UI_UX_PLAN.md` - wireframes всех экранов
2. `docs/DESIGN_SYSTEM.md` - цвета (Teal), шрифты, компоненты
3. `docs/PROJECT_ROADMAP.md` - текущий статус и план
4. `api-1.json` - api

## Правила

1. Следуй дизайн-системе строго (основной цвет - Teal #009688)
2. Используй mock данные с американскими именами/адресами
3. НЕ указывай версии пакетов - устанавливай через `flutter pub add`
4. Пиши чистый Dart код
5. После задачи обнови PROJECT_ROADMAP.md (отметь ✅)

## Выполнено

- [x] Фаза 1.1: Подготовка (тема, компоненты, mock данные)
- [x] Фаза 1.2: Онбординг и Авторизация (Splash, Onboarding, PhoneInput, OTP)
- [x] Фаза 1.3: Регистрация пассажира (ProfileSetupScreen)

---

## Текущий этап

### Фаза 1.4-A: Навигация + Профиль (по API)

Делаем экраны которые соответствуют текущему API (`api-1.json`):

## Задача
- [x] MainShell (Bottom Navigation: Search, Trips, Chats, Profile)
- [x] ProfileScreen (GET /passenger/profile) - просмотр профиля
- [x] EditProfileScreen (PUT /passenger/profile) - редактирование (name, email, avatar)
- [x] SettingsScreen (logout, logout-all)

## API эндпоинты для этих экранов:
- `GET /api/v1/passenger/profile` - получить профиль
- `PUT /api/v1/passenger/profile` - обновить профиль (multipart: name, email, avatar)
- `POST /api/v1/auth/logout` - выход
- `POST /api/v1/auth/logout-all` - выход со всех устройств

## Навигация после регистрации:
ProfileSetupScreen → MainShell (вкладка Search/Home)
