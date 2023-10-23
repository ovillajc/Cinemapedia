import 'package:flutter_dotenv/flutter_dotenv.dart';

// Variables retuilizables const y static
class Environment {
  static String theMovieDbKey =
      dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay api key';
}
