import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/views/widget/signout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);
    final profileAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Accueil"), actions: [SignoutWidget()]),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: userAsync.when(
                data: (user) {
                  return profileAsync.when(
                    data: (profile) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Bienvenue, email !",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(color: Colors.blueAccent),
                          ),
                          const SizedBox(height: 32),

                          if (profile != null) ...[
                            Text(
                              "Votre profil",
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Nom d’utilisateur : profile",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Bio : bio bio bio",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                          ],

                          ElevatedButton.icon(
                            icon: const Icon(Icons.person),
                            label: const Text("Voir / Modifier Profil"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed:
                                () => Navigator.pushNamed(context, '/profile'),
                          ),

                          const SizedBox(height: 16),

                          ElevatedButton.icon(
                            icon: const Icon(Icons.bar_chart),
                            label: const Text("Gérer mes tensors"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed:
                                () => Navigator.pushNamed(context, '/items'),
                          ),
                        ],
                      );
                    },
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text("Erreur profil : $e")),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Erreur utilisateur : $e")),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Déconnexion"),
            content: const Text("Voulez-vous vraiment vous déconnecter ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text("Annuler"),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text("Oui"),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await ref.read(authServiceProvider).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
      body: Center(child: Text("Bienvenue 👋")),
    );
  }
}*/
