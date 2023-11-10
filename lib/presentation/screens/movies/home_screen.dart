import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/views/views.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  // final Widget childView;
  final int pageIndex;

  const HomeScreen({
    super.key,
    required this.pageIndex,
    // required this.childView,
  });

  // Determinar la vista a ver en base al index recibido
  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      // body: Center(
      //   // Alternar vista basado en go_router
      //   // child: childView,
      //   child: HomeView(),
      // ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: pageIndex),
    );
  }
}
