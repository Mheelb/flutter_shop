import 'package:flutter_riverpod/flutter_riverpod.dart';

// State pour gérer la liste des favoris
class FavoritesState {
  final Set<int> favoriteIds;
  final bool isLoading;

  const FavoritesState({
    this.favoriteIds = const {},
    this.isLoading = false,
  });

  FavoritesState copyWith({
    Set<int>? favoriteIds,
    bool? isLoading,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Notifier pour gérer les favoris
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier() : super(const FavoritesState());

  void toggleFavorite(int productId) {
    final currentFavorites = Set<int>.from(state.favoriteIds);

    if (currentFavorites.contains(productId)) {
      currentFavorites.remove(productId);
    } else {
      currentFavorites.add(productId);
    }

    state = state.copyWith(favoriteIds: currentFavorites);
  }

  bool isFavorite(int productId) {
    return state.favoriteIds.contains(productId);
  }

  void clearFavorites() {
    state = state.copyWith(favoriteIds: {});
  }
}

// Provider pour les favoris
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>(
  (ref) => FavoritesNotifier(),
);
