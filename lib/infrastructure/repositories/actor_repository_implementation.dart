import 'package:cinemapedia/domain/datasources/actors_datasources.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorRepositoryImplementation extends ActorsRepository {
  final ActorsDataSource dataSource;

  ActorRepositoryImplementation(this.dataSource);

  @override
  Future<List<Actor>> getActorByMovie(String movideId) {
    return dataSource.getActorByMovie(movideId);
  }
}
