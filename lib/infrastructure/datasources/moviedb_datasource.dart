import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/themoviedb_response.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

// Datasource para interactuar con el api y enviar peticiones
class MovidedbDatasource extends MoviesDatasource {
  // Gestor de peticiones http dio
  // Configurar cliente de peticiones HTTP para interactuar con el api
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  // Funcion que retorna un listado de peliculas en base a la peticion solicitada
  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    // Procesar respuesta en base al modelo
    final movieDBResponse = MovieDbResponse.fromJson(json);
    // Listado de peliculas
    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        // Mapeamos los resultados en base al Mapper ya establecido
        .map((moviedb) => MovieMapper.movideDBToEntity(moviedb))
        // Convertimos a lista
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    // Implementacion de la peticion
    // Obtener peliculas en cartelera
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {
        'page': page,
      },
    );

    // Procesar respuesta en base al modelo y devolver el listado de peliculas
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    // Implementacion de la peticion
    // Obtener peliculas en cartelera
    final response = await dio.get(
      '/movie/popular',
      queryParameters: {
        'page': page,
      },
    );

    // Procesar respuesta en base al modelo y devolver el listado de peliculas
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    // Implementacion de la peticion
    // Obtener peliculas en cartelera
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {
        'page': page,
      },
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    // Implementacion de la peticion
    // Obtener peliculas en cartelera
    final response = await dio.get(
      '/movie/upcoming',
      queryParameters: {
        'page': page,
      },
    );

    return _jsonToMovies(response.data);
  }
}
