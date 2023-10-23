import 'package:cinemapedia/domain/entities/movie.dart';

// Los repositorios son los que se encargan de llamar al datasource
abstract class MovieRespository {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
