import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/movie.dart';

class TmdbService {
  static const String _accessToken = 
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYjE0ZGY5MGVkMDQ1YzM0MDFjMDVkNTVkNDc4Y2E1MCIsIm5iZiI6MTc0NTIxOTI4NC40MjgsInN1YiI6IjY4MDVlZWQ0MDU5ZmJjZWNmNmFhYjcyYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.njKeRB_ZNnJ1mbHAeT5E2EAglFAMmJUZBOAI1lSdXBU';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  final http.Client _client;

  TmdbService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      };

  Future<MoviesResponse> getPopularMovies({int page = 1}) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/movie/popular?page=$page&language=fr-FR'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MoviesResponse.fromJson(data);
      } else {
        throw Exception('Erreur lors du chargement des films populaires: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<MoviesResponse> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/movie/top_rated?page=$page&language=fr-FR'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MoviesResponse.fromJson(data);
      } else {
        throw Exception('Erreur lors du chargement des films les mieux notés: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<MoviesResponse> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/movie/now_playing?page=$page&language=fr-FR'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MoviesResponse.fromJson(data);
      } else {
        throw Exception('Erreur lors du chargement des films actuellement au cinéma: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<MoviesResponse> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/movie/upcoming?page=$page&language=fr-FR'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MoviesResponse.fromJson(data);
      } else {
        throw Exception('Erreur lors du chargement des films à venir: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<MoviesResponse> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) {
      return MoviesResponse(page: 1, results: [], totalPages: 0, totalResults: 0);
    }

    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/search/movie?query=${Uri.encodeComponent(query)}&page=$page&language=fr-FR'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MoviesResponse.fromJson(data);
      } else {
        throw Exception('Erreur lors de la recherche: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/movie/$movieId?language=fr-FR'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Movie.fromJson(data);
      } else {
        throw Exception('Erreur lors du chargement des détails du film: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
