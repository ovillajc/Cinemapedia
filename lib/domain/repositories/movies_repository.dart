import 'package:cinemapedia/domain/entities/movie.dart';

// Los repositorios son los que se encargan de llamar al datasource
abstract class MoviesRespository {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<List<Movie>> searchMovies(String query);
}
