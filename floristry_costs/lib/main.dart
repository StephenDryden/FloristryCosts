import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Floristry Costs',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromRGBO(0, 255, 0, 1.0)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      case 2:
        page = CalculatorPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calculate),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  int _quantity = 1;
  double _price = 0.0;
  double _vat = 20.0;
  double _markup = 20.0;
  double _multiply = 2.0;
  double _final = 20.0;

  double _totalPrice = 0.0;

  void _updateTotalPrice() {
    setState(() {
      _totalPrice = _quantity * _price;
    });
  }

  void _updateFinalPrice() {
    setState(() {
      _final = _quantity *
          _price *
          (1 + _vat / 100) *
          (1 + _markup / 100) *
          _multiply;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 5.0),
            Expanded(
              // Item
              child: Text("Item"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Quantiy
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 30.0,
                    child: Text("QTY"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: Text("Cost"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                      width: 50.0, // Adjust width as needed
                      child: Text("Total")),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 5.0),
            Expanded(
              // Item
              child: TextField(
                decoration: InputDecoration(hintText: "Enter Item Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Quantiy
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 30.0,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller:
                          TextEditingController(text: _quantity.toString()),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _quantity = int.parse(value);
                          _updateTotalPrice();
                          _updateFinalPrice();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller:
                          TextEditingController(text: _price.toString()),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _price = double.parse(value);
                          _updateTotalPrice();
                          _updateFinalPrice();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                      width: 50.0, // Adjust width as needed
                      child: Text(_totalPrice.toStringAsFixed(2))),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 5.0),
            Text("VAT: "),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: TextEditingController(text: _vat.toString()),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _vat = double.parse(value);
                          _updateFinalPrice();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 5.0),
            Text("Markup: "),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller:
                          TextEditingController(text: _markup.toString()),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _vat = double.parse(value);
                          _updateFinalPrice();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 5.0),
            Text("Multiply: "),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller:
                          TextEditingController(text: _multiply.toString()),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _vat = double.parse(value);
                          _updateFinalPrice();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 5.0),
            Text("Total Cost: "),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: Text(_final.toStringAsFixed(2)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
