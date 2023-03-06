import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'layout/favorite_page.dart';
import 'layout/generator_page.dart';

class AppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState;
    animatedList.insertItem(0);

    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }

    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);

    notifyListeners();
  }

  GlobalKey? historyListKey;
  var history = <WordPair>[];
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Widget mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    // return LayoutBuilder(builder: (context, constraints) {
    //   return Scaffold(
    //     body: Row(
    //       children: [
    //         SafeArea(
    //           child: NavigationRail(
    //             extended: constraints.maxWidth >= 600,
    //             destinations: [
    //               NavigationRailDestination(
    //                 icon: Icon(Icons.home),
    //                 label: Text('Home'),
    //               ),
    //               NavigationRailDestination(
    //                 icon: Icon(Icons.favorite),
    //                 label: Text('Favoritos'),
    //               ),
    //             ],
    //             selectedIndex: selectedIndex,
    //             onDestinationSelected: (value) {
    //               setState(() {
    //                 selectedIndex = value;
    //               });
    //             },
    //           ),
    //         ),
    //         Expanded(
    //           child: Container(
    //             color: Theme.of(context).colorScheme.primaryContainer,
    //             child: page,
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // });

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return Column(
            children: [
              Expanded(child: mainArea),
              SafeArea(
                  child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite), label: 'Favoritos')
                ],
                currentIndex: selectedIndex,
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ))
            ],
          );
        } else {
          return Row(
            children: [
              SafeArea(
                  child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(Icons.home), label: Text('Home')),
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite), label: Text('Favoritos'))
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              )),
              Expanded(child: mainArea)
            ],
          );
        }
      }),
    );
  }
}
