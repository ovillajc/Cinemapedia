import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart';

// Definicion de rutas de la aplicacion
final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    //Ruta padre
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');

        // if (pageIndex > 2 || pageIndex < 0)

        return HomeScreen(pageIndex: pageIndex);
      },
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
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0',
    ),
  ],
);
