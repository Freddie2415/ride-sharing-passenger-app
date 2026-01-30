# Дизайн-система - Ride Sharing Passenger

> Визуальный язык и компоненты для приложения пассажира

## Содержание

1. [Принципы дизайна](#принципы-дизайна)
2. [Цветовая палитра](#цветовая-палитра)
3. [Типографика](#типографика)
4. [Spacing система](#spacing-система)
5. [Компоненты](#компоненты)
6. [Flutter реализация](#flutter-реализация)

---

## Принципы дизайна

### Стиль: Минимализм
- Чистые интерфейсы с большим количеством белого пространства
- Фокус на контенте и действиях
- Минимум декоративных элементов
- Ясная визуальная иерархия

### Ключевые принципы
1. **Простота** - убираем всё лишнее
2. **Читаемость** - крупный текст, контрастные цвета
3. **Доступность** - минимум WCAG AA контраст
4. **Консистентность** - единообразные компоненты

---

## Цветовая палитра

### Primary (Teal)

| Название | HEX | Использование |
|----------|-----|---------------|
| Primary 50 | `#E0F2F1` | Фоны, hover состояния |
| Primary 100 | `#B2DFDB` | Легкие акценты |
| Primary 200 | `#80CBC4` | Второстепенные элементы |
| Primary 300 | `#4DB6AC` | - |
| Primary 400 | `#26A69A` | - |
| **Primary 500** | **`#009688`** | **Основной цвет** |
| Primary 600 | `#00897B` | Кнопки, ссылки |
| Primary 700 | `#00796B` | Hover на кнопках |
| Primary 800 | `#00695C` | Pressed состояние |
| Primary 900 | `#004D40` | Тёмные акценты |

### Семантические цвета

| Тип | Light Theme | Dark Theme | Использование |
|-----|-------------|------------|---------------|
| **Success** | `#4CAF50` | `#66BB6A` | Успех, подтверждение |
| Success Background | `#E8F5E9` | `#1B5E20` | Фон успеха |
| **Error** | `#F44336` | `#EF5350` | Ошибки, удаление |
| Error Background | `#FFEBEE` | `#B71C1C` | Фон ошибки |
| **Warning** | `#FF9800` | `#FFB74D` | Предупреждения |
| Warning Background | `#FFF3E0` | `#E65100` | Фон предупреждения |
| **Info** | `#2196F3` | `#42A5F5` | Информация |
| Info Background | `#E3F2FD` | `#0D47A1` | Фон информации |

### Нейтральные цвета (Gray Scale)

| Название | HEX | Использование |
|----------|-----|---------------|
| Gray 50 | `#FAFAFA` | Фоны светлой темы |
| Gray 100 | `#F5F5F5` | Карточки, секции |
| Gray 200 | `#EEEEEE` | Разделители |
| Gray 300 | `#E0E0E0` | Границы |
| Gray 400 | `#BDBDBD` | Неактивные элементы |
| Gray 500 | `#9E9E9E` | Плейсхолдеры |
| Gray 600 | `#757575` | Второстепенный текст |
| Gray 700 | `#616161` | - |
| Gray 800 | `#424242` | Основной текст (dark) |
| Gray 900 | `#212121` | Основной текст (light) |

### Светлая тема

```
Background:       #FFFFFF
Surface:          #FFFFFF
Surface Variant:  #F5F5F5
On Background:    #212121
On Surface:       #212121
On Surface Var:   #757575
Outline:          #E0E0E0
```

### Тёмная тема

```
Background:       #121212
Surface:          #1E1E1E
Surface Variant:  #2C2C2C
On Background:    #FFFFFF
On Surface:       #FFFFFF
On Surface Var:   #BDBDBD
Outline:          #424242
```

---

## Типографика

### Шрифт: Inter

**Подключение в Flutter:**
```yaml
# pubspec.yaml
dependencies:
  google_fonts: ^6.1.0
```

### Иерархия текста

| Стиль | Размер | Weight | Использование |
|-------|--------|--------|---------------|
| **Headline Large** | 32px | 600 | Заголовки экранов |
| **Headline Medium** | 28px | 600 | Секции |
| **Headline Small** | 24px | 600 | Подзаголовки |
| **Title Large** | 22px | 500 | Заголовки карточек |
| **Title Medium** | 16px | 500 | Списки |
| **Body Large** | 16px | 400 | Основной текст |
| **Body Medium** | 14px | 400 | Описания |
| **Body Small** | 12px | 400 | Мелкий текст |
| **Label Large** | 14px | 500 | Кнопки |
| **Label Medium** | 12px | 500 | Чипы, теги |

---

## Spacing система

### Базовый юнит: 4px

| Название | Значение | Использование |
|----------|----------|---------------|
| `space-xs` | 4px | Минимальный отступ |
| `space-sm` | 8px | Между элементами в группе |
| `space-md` | 12px | Внутренние отступы компонентов |
| `space-lg` | 16px | Стандартные отступы |
| `space-xl` | 24px | Между секциями |
| `space-2xl` | 32px | Большие отступы |
| `space-3xl` | 48px | Между блоками |

---

## Компоненты

### Border Radius

| Компонент | Радиус |
|-----------|--------|
| Кнопки | 12px |
| Карточки | 12px |
| Input поля | 12px |
| Чипы/Теги | 20px (pill) |
| Аватары | 50% (круг) |

### Кнопки

#### Primary Button
```
Background: Primary 600 (#00897B)
Text: White (#FFFFFF)
Height: 52px
Padding: 16px 24px
Border Radius: 12px

Hover: Primary 700 (#00796B)
Pressed: Primary 800 (#00695C)
Disabled: Gray 300, text Gray 500
```

#### Secondary Button (Outlined)
```
Background: Transparent
Border: 1px Primary 600
Text: Primary 600
Height: 52px
Border Radius: 12px
```

### Карточки (Cards)

```
Background: Surface (#FFFFFF / #1E1E1E)
Border Radius: 12px
Padding: 16px
Shadow: Elevation 1 (light) / none (dark)
```

### Input поля

```
Height: 56px
Background: Surface Variant
Border: 1px Outline (unfocused)
Border: 2px Primary 600 (focused)
Border Radius: 12px
```

### Bottom Navigation

```
Height: 80px (с safe area)
Background: Surface
Border Top: 1px Outline
Icon Size: 24px

Active: Primary 600
Inactive: Gray 500
```

---

## Flutter реализация

### Настройка темы

```dart
// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - TEAL
  static const Color primaryColor = Color(0xFF00897B);
  static const Color primaryLight = Color(0xFFE0F2F1);
  static const Color primaryDark = Color(0xFF00695C);

  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryLight,
      secondary: Color(0xFF757575),
      surface: Colors.white,
      background: Colors.white,
      error: errorColor,
      outline: Color(0xFFE0E0E0),
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF212121),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF212121),
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF212121),
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF212121),
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF212121),
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF212121),
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF212121),
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF757575),
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF9E9E9E),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4DB6AC),
      onPrimary: Colors.black,
      primaryContainer: Color(0xFF004D40),
      secondary: Color(0xFFBDBDBD),
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: Color(0xFFEF5350),
      outline: Color(0xFF424242),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF424242)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFF4DB6AC),
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF4DB6AC),
          width: 2,
        ),
      ),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(0xFF4DB6AC),
      unselectedItemColor: Color(0xFF9E9E9E),
      type: BottomNavigationBarType.fixed,
    ),
  );
}
```

---

## Сравнение с Driver App

| Элемент | Driver (Blue) | Passenger (Teal) |
|---------|---------------|------------------|
| Primary 500 | `#2196F3` | `#009688` |
| Primary 600 | `#1E88E5` | `#00897B` |
| Primary 700 | `#1976D2` | `#00796B` |
| Dark Primary | `#42A5F5` | `#4DB6AC` |

---

*Документ создан: 30.01.2026*
*Версия: 1.0*
