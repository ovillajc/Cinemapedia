import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

typedef SearchMovieCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  // Funcion para buscar peliculas
  final SearchMovieCallBack searchMovies;
  List<Movie> initialMovies;

  // Stream que se encarga de escuchar al input del search
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  // Emitir el valor cuando la persona deja de escribir
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  }) : super(
          // Cambiar el input del search con super
          searchFieldLabel: 'Buscar Peliculas',
        );

  // Cerrar el stream
  void clearStreams() {
    debouncedMovies.close();
  }

  //! Debounce manual para controlar las peticiones http que se realizan y evitar multiples
  // Funcion que tienen un timer que se esta reiniciando cada vez que se escribe
  void _onQueryChange(String query) {
    // cambiar el valor del stream cuando la persona comienze a escribir
    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(
      const Duration(milliseconds: 500),
      // Callback que realizar la peticion http
      () async {
        // if (query.isEmpty) {
        //   debouncedMovies.add([]);
        //   return;
        // }

        final movies = await searchMovies(query);
        // Evitar la doble peticion al buscar una pelicula y obtener resultados
        initialMovies = movies;
        debouncedMovies.add(movies);

        // Detener el stream del icono una vez tengamos las peliculas
        isLoadingStream.add(false);
      },
    );
  }

  Widget buildResultsAndSuggestions() {
    // Llamar la peticion para obtener las peliculas
    // return FutureBuilder(
    return StreamBuilder(
      // future: searchMovies(query)
      // Subscriptor del broadcast que escucha sus cambios
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }

  // Cambiar el texto del input search
  // @override
  // String get searchFieldLabel => 'Buscar película';

  // Metodo que sirve para agregar acciones en el aldo derecho del appBar del search
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // Cambiar el icono en base a un stream
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          // Verificamos que el stram tenga datos para cambiar el icono en base a ello
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 10),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),

      // FadeIn(
      //   animate: query.isNotEmpty,
      //   child: IconButton(
      //     onPressed: () => query = '',
      //     icon: const Icon(Icons.clear),
      //   ),
      // ),
    ];
  }

  // Metodo que sirve para agregar acciones en el lado izquierdo appBar del search
  @override
  Widget? buildLeading(BuildContext context) {
    // Cerrar el searchDelegate
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  // Constuye los resultados del searchDelegate al escribir algo
  @override
  Widget buildSuggestions(BuildContext context) {
    // Siempre que se toque alguna tecla entrara en esta funcion
    _onQueryChange(query);

    return buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () {
          onMovieSelected(context, movie);
        },
        child: Row(
          children: [
            // Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Description
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),
                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded,
                          color: Colors.yellow.shade800),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!
                            .copyWith(color: Colors.yellow.shade900),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
