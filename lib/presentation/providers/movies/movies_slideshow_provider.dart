import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

// Controlar las peliculas paginadas en el swiper
final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  // Buscar el provider que muestra las peliculas en cartelera
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);

  if (nowPlayingMovies.isEmpty) return [];

  return nowPlayingMovies.sublist(0, 6);
});
