import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/tmdb_service.dart';
import '../../domain/models/movie.dart';

// Provider pour le service TMDB
final tmdbServiceProvider = Provider<TmdbService>((ref) {
  return TmdbService();
});

// Provider pour les films populaires
final popularMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final tmdbService = ref.read(tmdbServiceProvider);
  final response = await tmdbService.getPopularMovies();
  return response.results;
});

// Provider pour les films les mieux notés
final topRatedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final tmdbService = ref.read(tmdbServiceProvider);
  final response = await tmdbService.getTopRatedMovies();
  return response.results;
});

// Provider pour les films actuellement au cinéma
final nowPlayingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final tmdbService = ref.read(tmdbServiceProvider);
  final response = await tmdbService.getNowPlayingMovies();
  return response.results;
});

// Provider pour les films à venir
final upcomingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final tmdbService = ref.read(tmdbServiceProvider);
  final response = await tmdbService.getUpcomingMovies();
  return response.results;
});

// Provider pour la recherche de films
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) {
    return [];
  }
  
  final tmdbService = ref.read(tmdbServiceProvider);
  final response = await tmdbService.searchMovies(query);
  return response.results;
});

// Provider pour la catégorie sélectionnée
enum MovieCategory { popular, topRated, nowPlaying, upcoming }

final selectedCategoryProvider = StateProvider<MovieCategory>((ref) => MovieCategory.popular);

// Provider pour les films selon la catégorie sélectionnée
final moviesProvider = FutureProvider<List<Movie>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  final tmdbService = ref.read(tmdbServiceProvider);
  
  late MoviesResponse response;
  switch (category) {
    case MovieCategory.popular:
      response = await tmdbService.getPopularMovies();
      break;
    case MovieCategory.topRated:
      response = await tmdbService.getTopRatedMovies();
      break;
    case MovieCategory.nowPlaying:
      response = await tmdbService.getNowPlayingMovies();
      break;
    case MovieCategory.upcoming:
      response = await tmdbService.getUpcomingMovies();
      break;
  }
  
  return response.results;
});
