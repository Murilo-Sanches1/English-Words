import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var theme = Theme.of(context);

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('Sem favoritos ainda.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('Você tem '
              '${appState.favorites.length} favoritos:'),
        ),
        // ListView(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(20),
        //       child: Text('Você tem '
        //           '${appState.favorites.length} favoritos:'),
        //     ),
        //     for (var pair in appState.favorites)
        //       ListTile(
        //         leading: TextButton(
        //           child: Icon(Icons.delete),
        //           onPressed: () {},
        //         ),
        //         title: Text(pair.asLowerCase),
        //       ),
        //   ],
        // ),
        Expanded(
            child: GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400, childAspectRatio: 400 / 80),
          children: [
            for (var pair in appState.favorites)
              ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    semanticLabel: 'Excluír',
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    appState.removeFavorite(pair);
                  },
                ),
                title: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              )
          ],
        )),
      ],
    );
  }
}
