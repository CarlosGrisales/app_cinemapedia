import 'package:app_cinemapedia/presentation/views/movies/popular_view.dart';
import 'package:app_cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';


import '../../views/movies/favorites_view.dart';
import '../../views/movies/home_view.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({
    super.key, 
    required this.pageIndex
  });

  final viewRoutes =  const <Widget>[
    HomeView(),
    PopularView(), // <--- categorias View
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation( currentIndex: pageIndex ),
    );
  }
}