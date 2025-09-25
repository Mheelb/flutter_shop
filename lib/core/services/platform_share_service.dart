import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show Platform;

class PlatformShareService {
  static Future<void> shareProduct({
    required String productName,
    required String productPrice,
    required String productImage,
    String? productId,
  }) async {
    final String shareText = 'Découvrez ce produit sur SHOPIFUN !\n\n'
        '$productName\n'
        'Prix: $productPrice\n\n'
        'Téléchargez SHOPIFUN pour plus de produits !';

    if (kIsWeb) {
      await _shareOnWeb(shareText, productImage);
    } else {
      await _shareOnMobile(shareText, productImage);
    }
  }

  static Future<void> shareApp() async {
    const String shareText =
        'Découvrez SHOPIFUN - La meilleure application de shopping !\n\n'
        'Des milliers de produits à des prix incroyables.\n'
        'Téléchargez maintenant !';

    if (kIsWeb) {
      await _shareOnWeb(shareText, null);
    } else {
      await _shareOnMobile(shareText, null);
    }
  }

  static Future<void> _shareOnWeb(String text, String? imageUrl) async {
    if (kIsWeb) {
      try {
        // Utiliser l'API Web Share si disponible
        await Share.share(text);
      } catch (e) {
        // Fallback: copier dans le presse-papiers
        print('Web Share API non disponible: $e');
      }
    }
  }

  static Future<void> _shareOnMobile(String text, String? imageUrl) async {
    try {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Partager avec image si possible
        await Share.share(text);
      } else {
        await Share.share(text);
      }
    } catch (e) {
      print('Erreur lors du partage: $e');
    }
  }

  static bool get canShare {
    if (kIsWeb) {
      // Web Share API support check serait ici
      return true;
    }

    if (kIsWeb == false) {
      try {
        return Platform.isAndroid || Platform.isIOS;
      } catch (e) {
        return false;
      }
    }

    return false;
  }
}
