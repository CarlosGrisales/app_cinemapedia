import 'package:app_cinemapedia/presentation/screens/providers/providers.dart';
import 'package:app_cinemapedia/presentation/screens/providers/theme_provider.dart';
import 'package:app_cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// **Pantalla de Inicio (`HomeScreen`).**
///
/// Esta pantalla sirve como la pantalla principal de la aplicación, proporcionando varias secciones de películas
/// como "RECOMMENDED FOR YOU", "TOP RATED", "POPULAR" y "UPCOMING".
///
/// **Propiedades:**
/// - `name`: Nombre de la ruta de la pantalla.
///
/// **Métodos:**
/// - `build`: Construye la interfaz de usuario de la pantalla.

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromARGB(255, 2, 87, 133), body: _HomeView());
  }
}

/// **Vista Principal de la Pantalla de Inicio (`_HomeView`).**
///
/// Esta clase maneja la lógica y el estado de la vista principal de la pantalla de inicio,
/// incluyendo la carga inicial de películas y la gestión del modo oscuro.
///
/// **Métodos:**
/// - `createState`: Crea el estado asociado con esta vista.

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

/// **Estado de la Vista Principal (`_HomeViewState`).**
///
/// Este estado maneja la lógica de carga de las películas y el renderizado de la interfaz de usuario
/// basada en el estado actual de la carga y el modo de tema.
///
/// **Atributos del Estado:**
/// - `initState`: Método llamado al inicializar el estado para cargar las películas iniciales.
/// - `build`: Construye la interfaz de usuario de la vista principal.
///
/// **Atributos Utilizados:**
/// - `initialLoadingProvider`: Proveedor que indica si las películas están en proceso de carga.
/// - `themeNotifierProvider`: Proveedor que maneja el estado del tema oscuro.
/// - `nowPlayingMoviesProvider`: Proveedor que maneja la lista de películas actualmente en cartelera.
/// - `topRatedMoviesProvider`: Proveedor que maneja la lista de películas mejor valoradas.
/// - `popularMoviesProvider`: Proveedor que maneja la lista de películas populares.
/// - `upcomingMoviesProvider`: Proveedor que maneja la lista de próximas películas.
///
/// **Widgets Adicionales Utilizados:**
/// - `FullScreenLoader`: Widget que muestra un indicador de carga en pantalla completa.
/// - `CustomAppbar`: Widget personalizado que muestra la barra de aplicaciones.
/// - `MovieHorizontalListview`: Widget personalizado que muestra una lista horizontal de películas.

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
    final isDarkmode = ref.watch( themeNotifierProvider ).isDarkmode;
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
            icon: Icon( isDarkmode ? Icons.dark_mode_outlined : Icons.light_mode_outlined ),
            onPressed: () {
              ref.read( themeNotifierProvider.notifier )
                .toggleDarkmode();

            })
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
