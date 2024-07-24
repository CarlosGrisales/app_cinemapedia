import 'package:app_cinemapedia/presentation/screens/providers/providers.dart';
import 'package:app_cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromARGB(255, 2, 87, 133), body: _HomeView());
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoadin = ref.watch(initialLoadingProvider);
    if (initialLoadin) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    
    return CustomScrollView(slivers: [
      SliverAppBar(
          backgroundColor: const Color.fromARGB(255, 2, 87, 133),
          floating: true,
          toolbarHeight: 160,
          leading: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.shield_moon_outlined),
                onPressed: () {},
              ),
            ],
          ),
          flexibleSpace: const FlexibleSpaceBar(
            title: CustomAppbar(),
          )),
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            children: [
              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: 'RECOMMENDED FOR YOU',
                subTitle: 'See all',
              ),
              MovieHorizontalListview(
                movies: topRatedMovies,
                title: 'TOP RATED',
                subTitle: 'See all',
              ),
              MovieHorizontalListview(
                movies: popularMovies,
                title: 'POPULAR',
                subTitle: 'See all',
              ),
              MovieHorizontalListview(
                movies: upcomingMovies,
                title: 'UPCOMING',
                subTitle: 'See all',
              )
            ],
          ),
        );
      }, childCount: 1))
    ]);
  }
}
