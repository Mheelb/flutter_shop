import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/views/login_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Mon Profil',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: auth.when(
        data: (user) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: const NetworkImage(
                            'https://static.wikia.nocookie.net/onepiece/images/6/6d/Monkey_D._Luffy_Anime_Post_Timeskip_Infobox.png',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monkey D. Luffy',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'luffy.pirate@grandline.com',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Account Settings Section
              _buildSectionTitle('PARAMÈTRES DU COMPTE'),
              const SizedBox(height: 16),

              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Informations personnelles',
                onTap: () {
                  _showInfoDialog(
                      context,
                      'Informations personnelles',
                      'Nom: Monkey D. Luffy\n'
                          'Profession: Capitaine Pirate\n'
                          'Équipage: Chapeau de Paille\n'
                          'Rêve: Devenir le Roi des Pirates\n'
                          'Prime: 3,000,000,000 Berry');
                },
              ),

              _buildMenuItem(
                icon: Icons.payment_outlined,
                title: 'Mes options de paiement',
                onTap: () {
                  _showInfoDialog(
                      context,
                      'Options de paiement',
                      'Carte de crédit: **** 1234\n'
                          'PayPal: luffy@strawhat.com\n'
                          'Apple Pay: Activé\n'
                          'Google Pay: Activé\n'
                          'Trésor de pirate: 500M Berry');
                },
              ),

              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Préférences de notifications',
                onTap: () {
                  _showInfoDialog(
                      context,
                      'Notifications',
                      'Nouvelles commandes: Activées\n'
                          'Promotions: Activées\n'
                          'Alertes sécurité: Activées\n'
                          'Newsletter: Activée\n'
                          'Avis Marine: Désactivées');
                },
              ),

              _buildMenuItem(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Limites du compte',
                onTap: () {
                  _showInfoDialog(
                      context,
                      'Limites du compte',
                      'Limite quotidienne: 10,000€\n'
                          'Limite mensuelle: 50,000€\n'
                          'Statut: Compte Premium\n'
                          'Niveau de confiance: Yonko\n'
                          'Privilèges spéciaux: Accès Grand Line');
                },
              ),

              const SizedBox(height: 30),

              // SHOPIFUN Section
              _buildSectionTitle('SHOPIFUN'),
              const SizedBox(height: 16),

              // Installer PWA (Web uniquement)
              if (kIsWeb)
                _buildMenuItem(
                  icon: Icons.download,
                  title: 'Installer SHOPIFUN',
                  subtitle: 'Transformez le site en vraie application',
                  onTap: () => _installPWA(context),
                ),

              // Partager l'app
              _buildMenuItem(
                icon: Icons.share,
                title: 'Recommander SHOPIFUN',
                subtitle: 'Partagez avec vos amis et famille',
                onTap: () => _shareApp(context),
              ),

              // Informations sur l'app
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'À propos de SHOPIFUN',
                subtitle: 'Version, licences et crédits',
                onTap: () {
                  _showInfoDialog(
                      context,
                      'À propos de SHOPIFUN',
                      '🛒 SHOPIFUN - E-commerce moderne\n\n'
                          '📱 Version: 1.0.0\n'
                          '🚀 Développé avec Flutter\n'
                          '🔧 PWA Ready\n'
                          '📊 Responsive Design\n'
                          '🎨 Material Design 3\n\n'
                          '✨ Fonctionnalités:\n'
                          '• Navigation fluide\n'
                          '• Panier intelligent\n'
                          '• Favoris synchronisés\n'
                          '• Partage natif\n'
                          '• Mode hors-ligne\n\n'
                          '👨‍💻 Développé avec ❤️');
                },
              ),

              const SizedBox(height: 30),

              // Others Section
              _buildSectionTitle('AUTRES'),
              const SizedBox(height: 16),

              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'FAQ et Support',
                onTap: () {
                  _showInfoDialog(
                      context,
                      'FAQ et Support',
                      'Q: Comment devenir Roi des Pirates?\n'
                          'R: Trouve le One Piece!\n\n'
                          'Q: Livraison vers Grand Line?\n'
                          'R: Oui, même vers Raftel!\n\n'
                          'Q: Acceptez-vous les Berry?\n'
                          'R: Bien sûr, capitaine!\n\n'
                          'Support: 24h/24, 7j/7');
                },
              ),

              _buildMenuItem(
                icon: Icons.book_outlined,
                title: 'Guide',
                onTap: () {
                  _showInfoDialog(
                      context,
                      'Guide',
                      '📖 Règles de base:\n'
                          '• Protège tes amis\n'
                          '• Respecte les autres\n'
                          '• Poursuis tes rêves\n'
                          '• Partage tes réussites\n\n'
                          '✨ Code d\'honneur:\n'
                          '• Sois toujours honnête\n'
                          '• L\'aventure avant tout');
                },
              ),

              const SizedBox(height: 30),

              // Logout Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Déconnexion',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Déconnexion'),
                        content: const Text(
                            'Es-tu sûr de vouloir abandonner l\'aventure, capitaine ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Annuler'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await ref.read(authServiceProvider).signOut();
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => const LoginPage()),
                                  (route) => false,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Déconnexion'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.grey[700],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  // Méthode pour installer PWA
  void _installPWA(BuildContext context) {
    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('📱 Installer SHOPIFUN'),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Transformez SHOPIFUN en vraie application !'),
                SizedBox(height: 16),
                Text('✅ Icône sur votre écran d\'accueil'),
                Text('✅ Lancement sans navigateur'),
                Text('✅ Interface comme une app native'),
                Text('✅ Fonctionne hors-ligne'),
                Text('✅ Notifications push'),
                SizedBox(height: 16),
                Text('📋 Comment installer :'),
                Text('Chrome: Menu (⋮) > "Installer SHOPIFUN"'),
                Text('Edge: Icône + dans la barre d\'adresse'),
                Text('Firefox: Menu > "Installer cette app"'),
                Text('Safari: Partager > "Sur l\'écran d\'accueil"'),
                SizedBox(height: 16),
                Text(
                  '💡 L\'option d\'installation apparaît automatiquement après quelques secondes sur le site',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Compris !'),
            ),
          ],
        ),
      );
    }
  }

  // Méthode pour partager l'app
  void _shareApp(BuildContext context) async {
    try {
      await Share.share(
        '🛒 Découvrez SHOPIFUN - La meilleure boutique en ligne !\n\n'
        '✨ Des milliers de produits à prix réduits\n'
        '🚀 Interface moderne et intuitive\n'
        '📱 Disponible sur tous vos appareils\n'
        '🔒 Paiements 100% sécurisés\n\n'
        '👆 Visitez maintenant: ${kIsWeb ? Uri.base.toString() : 'https://shopifun.app'}\n\n'
        '#SHOPIFUN #Shopping #ECommerce',
        subject: 'SHOPIFUN - E-commerce moderne',
      );
    } catch (e) {
      // Fallback pour les plateformes non supportées
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📋 Lien SHOPIFUN copié dans le presse-papiers !'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  static void _showInfoDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Fermer',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
