import 'package:cinemapedia/presentation/providers/movies/movies_respository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';

//! Proveeder que notifica cambios en el estado y esta controlado por MoviesNotifier
//* Peliculas en cartelera
final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

  // Retornamos el nuevo caso de uso
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});

//* Peliculas populares
final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;

  // Retornamos el nuevo caso de uso
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});

//* Peliculas con mejor calificacion
final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;

  // Retornamos el nuevo caso de uso
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});

//* Peliculas por estrenarse
final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;

  // Retornamos el nuevo caso de uso
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});

//! Definir el caso de uso
// Espeficiar el tipo de funcion que se espera
typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies,
  }) : super([]);

  //! Realizar modificacion al state para obtener la siguiente pagina
  Future<void> loadNextPage() async {
    // Evitar llamado de multiples peticiones a la vez en base al valor de isLoading
    if (isLoading) return;

    isLoading = true;

    // Aumentar el numero de pagina a cargar
    currentPage++;

    // Extraer la funcion que permite el paginado me diante la funcion definida
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    // Añadir los cambios al estado (cada pelicula)
    state = [...state, ...movies];
    // Retardar un poco el nuevo lladado de la funcion
    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
  }
}
