import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';

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
          'My Profile',
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
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
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
                            'Jaydon Mango',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'jay_don64@gmail.com',
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
              _buildSectionTitle('ACCOUNT SETTINGS'),
              const SizedBox(height: 16),

              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Personal Information',
                onTap: () {},
              ),

              _buildMenuItem(
                icon: Icons.payment_outlined,
                title: 'My Payment Options',
                onTap: () {},
              ),

              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications Preferences',
                onTap: () {},
              ),

              _buildMenuItem(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Account Limits',
                onTap: () {},
              ),

              const SizedBox(height: 30),

              // Others Section
              _buildSectionTitle('OTHERS'),
              const SizedBox(height: 16),

              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'FAQ and Support',
                onTap: () {},
              ),

              _buildMenuItem(
                icon: Icons.book_outlined,
                title: 'Our Handbook',
                onTap: () {},
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
                    'Log Out',
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
                            'Êtes-vous sûr de vouloir vous déconnecter ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Annuler'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              ref.read(authServiceProvider).signOut();
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
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
