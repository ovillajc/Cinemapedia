import 'package:cinemapedia/domain/entities/movie.dart';

// Aqui se definen los metodos que se deben de tener para traer la data
abstract class MovieDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
