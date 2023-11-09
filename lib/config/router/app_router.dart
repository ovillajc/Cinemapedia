import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart';

// Definicion de rutas de la aplicacion
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      // Rutas hijas
      routes: [
        // Ruta con argumentos en el path
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(movieId: movieId);
          },
        ),
      ],
    ),
  ],
);
