import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/credits_response.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasources.dart';
import 'package:cinemapedia/domain/entities/actor.dart';

class ActorMovieDbDataSource extends ActorsDataSource {
  // Configuracion de dio para peticiones http
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  @override
  Future<List<Actor>> getActorByMovie(String movieId) async {
    // Obtener listado de actores de la pelicula
    final response = await dio.get('/movie/$movieId/credits');

    // Procesar respuesta en base al modelo
    // Objeto que contiene los actores de la pelicula
    final castResponse = CreditsResponse.fromJson(response.data);

    // Listado de actores obtenido
    final List<Actor> actors = castResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();

    return actors;
  }
}
