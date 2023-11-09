import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvier =
    StateNotifierProvider<SearchedMovieNotifier, List<Movie>>(
  (ref) {
    // Llamaos al repositorio que ejecuta los metodos del datasource para obtener peliculas
    final movieRepository = ref.read(movieRepositoryProvider);

    // Llamaos a la clase que ejecuta el llamado de peliculas para el proveedor
    return SearchedMovieNotifier(
      // referenciamos la funcion del repositorio que busca las peliculas
      searchMovies: movieRepository.searchMovies,
      ref: ref,
    );
  },
);

//Funcion para buscar las peliculas
typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchedMovieNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallBack searchMovies;
  final Ref ref;

  SearchedMovieNotifier({
    required this.searchMovies,
    required this.ref,
  }) : super([]);

  Future<List<Movie>> searchMovieByQuery(String query) async {
    // Obtener las peliculas
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    // Sin operador spread ... por que no queremos mantener las peliculas anteriores, solo las ultimas
    state = movies;

    // Regresamos las pelicualas encontradas
    return movies;
  }
}
