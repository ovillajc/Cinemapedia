import 'package:isar/isar.dart';

import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  // Utilizar el esquema de datos (obtener referencia a la db)
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    // Obtener direcotrio de la db
    final dir = await getApplicationDocumentsDirectory();

    // Verificamos que las instancias de los esquemas de la db esten vacios
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        // Modelo de la tabla de la base de datos
        [MovieSchema],
        // Permite tener un servicio para poder analizar la db en el phone
        inspector: true,
        // Directorio donde esta ubicada la base de datos
        directory: dir.path,
      );
    }

    // Regresamos la instancia de la tabla de la base de datos
    return Future.value(Isar.getInstance());
  }

  // ! Verificar si la pelicula ya esta en favoritos
  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final Movie? isFavoriteMovie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();

    return isFavoriteMovie != null;
  }

  // ! Cargar las peliculas favoritas
  @override
  Future<List<Movie>> loadMovie({int limit = 10, offset = 0}) async {
    final isar = await db;

    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  // ! Guardar peliculas en la base de datos
  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    if (favoriteMovie != null) {
      // Borrar
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      return;
    }

    // Insertar
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
