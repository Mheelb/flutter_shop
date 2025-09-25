import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/shop_app.dart';
import 'core/services/pwa_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialiser le service PWA pour le Web
  if (kIsWeb) {
    PWAService.initialize();
  }

  runApp(
    const ProviderScope(
      child: ShopApp(),
    ),
  );
}
