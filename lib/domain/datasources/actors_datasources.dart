import 'package:cinemapedia/domain/entities/actor.dart';

// Clase que dictamina como debe de lucir el repositorio
abstract class ActorsDataSource {
  Future<List<Actor>> getActorByMovie(String movideId);
}
