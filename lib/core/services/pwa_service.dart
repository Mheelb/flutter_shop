import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class PWAService {
  static dynamic _deferredPrompt;
  static bool _isInstallable = false;

  static bool get isInstallable => _isInstallable;
  static bool get isPWASupported => kIsWeb;

  static void initialize() {
    if (!kIsWeb) return;

    // Écouter l'événement personnalisé depuis le JS
    html.window.addEventListener('pwa-installable', (html.Event e) {
      _isInstallable = true;
      print('PWA installable détectée !');
    });

    // Vérifier si l'app est déjà installée
    html.window.addEventListener('appinstalled', (html.Event e) {
      _isInstallable = false;
      _deferredPrompt = null;
      print('PWA installée avec succès !');
    });

    // Écouter beforeinstallprompt directement
    html.window.addEventListener('beforeinstallprompt', (html.Event e) {
      print('beforeinstallprompt event captured');
      e.preventDefault();
      _deferredPrompt = e;
      _isInstallable = true;
    });
  }

  static Future<bool> installPWA() async {
    if (!kIsWeb) return false;

    try {
      if (_deferredPrompt != null) {
        await _deferredPrompt.prompt();
        final result = await _deferredPrompt.userChoice;

        if (result['outcome'] == 'accepted') {
          _deferredPrompt = null;
          _isInstallable = false;
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Erreur installation PWA: $e');
      return false;
    }
  }

  static bool isRunningStandalone() {
    if (!kIsWeb) return false;
    try {
      return html.window.matchMedia('(display-mode: standalone)').matches;
    } catch (e) {
      return false;
    }
  }

  static void showInstallInstructions() {
    print('Instructions d\'installation PWA');
  }
}
