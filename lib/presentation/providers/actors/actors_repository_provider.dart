import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/infrastructure/datasources/actor_movidedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_implementation.dart';

/* 
  Este repositorio es inmutable su objetivo es proporcionar informacion a todos
  los providers la informacion necesaria para que puedan consultar la misma
  al MovieRepositoryImplementation
*/
// Asignamos la info obtenida de la peticion al estado global de la app
final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImplementation(ActorMovieDbDataSource());
});
