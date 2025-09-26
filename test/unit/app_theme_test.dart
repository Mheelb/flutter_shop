import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/app/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme should have correct primary color', () {
      final theme = AppTheme.light();

      expect(theme.colorScheme.primary, const Color(0xFF4CAF50));
      expect(theme.colorScheme.secondary, const Color(0xFF66BB6A));
    });

    test('light theme should have Material 3 enabled', () {
      final theme = AppTheme.light();

      expect(theme.useMaterial3, true);
    });

    test('light theme should have correct scaffold background color', () {
      final theme = AppTheme.light();

      expect(theme.scaffoldBackgroundColor, const Color(0xFFF5F5F5));
    });

    test('app bar theme should have correct configuration', () {
      final theme = AppTheme.light();

      expect(theme.appBarTheme.elevation, 0);
      expect(theme.appBarTheme.centerTitle, true);
      expect(theme.appBarTheme.backgroundColor, Colors.white);
      expect(theme.appBarTheme.foregroundColor, Colors.black);
    });

    test('elevated button theme should have correct colors and shape', () {
      final theme = AppTheme.light();
      final buttonStyle = theme.elevatedButtonTheme.style!;

      expect(buttonStyle.backgroundColor?.resolve({}), const Color(0xFF4CAF50));
      expect(buttonStyle.foregroundColor?.resolve({}), Colors.white);
      expect(buttonStyle.elevation?.resolve({}), 0);
    });

    test('card theme should have correct elevation and shape', () {
      final theme = AppTheme.light();

      expect(theme.cardTheme.elevation, 2);
      expect(theme.cardTheme.color, Colors.white);
    });

    test('bottom navigation bar theme should have correct colors', () {
      final theme = AppTheme.light();

      expect(theme.bottomNavigationBarTheme.selectedItemColor,
          const Color(0xFF4CAF50));
      expect(theme.bottomNavigationBarTheme.unselectedItemColor, Colors.grey);
      expect(theme.bottomNavigationBarTheme.backgroundColor, Colors.white);
      expect(
          theme.bottomNavigationBarTheme.type, BottomNavigationBarType.fixed);
    });
  });
}
