import 'package:animate_do/animate_do.dart';
import 'package:app_cinemapedia/presentation/screens/providers/providers.dart';
import 'package:app_cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoriresViewState createState() => FavoriresViewState();
}

class FavoriresViewState extends ConsumerState<FavoritesView> {
  bool isLoading = false;
  bool isLastpage = false;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastpage) return;

    isLoading = true;
    final movie =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;
    if (movie.isEmpty) {
      isLastpage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();

    if (favoritesMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => context.go('/home/0'),
                  icon: Icon(
                    Icons.favorite_outline_sharp,
                    size: 60,
                    color: colors.primary,
                  ),
                ),
                Text(
                  'Ohhh no!!',
                  style: TextStyle(fontSize: 30, color: colors.primary),
                ),
                const Text(
                  'No tienes películas favoritas',
                  style: TextStyle(fontSize: 20, color: Colors.white54),
                )
              ]),
        ),
      );
    }
    return Scaffold(
        body:
            MovieMasonry(loadNextPage: loadNextPage, movies: favoritesMovies));
  }
}
