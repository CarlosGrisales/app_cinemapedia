import 'package:app_cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [
         GoRoute(
      path: 'movie/:id',
      name: MovieScreen.name,
      builder: (context, state) {
        final movieid = state.pathParameters['id'] ?? 'no-id';
        return  MovieScreen(
          movieId: movieid,
        );
      })
      ]
      ),
 
]);
