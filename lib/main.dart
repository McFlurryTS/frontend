import 'package:demo/providers/recipes_provider.dart';
import 'package:demo/screens/game_screen.dart';
import 'package:demo/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RecipesProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rocket demo',
        home: const RecipeBook(),
      ),
    );
  }
}

class RecipeBook extends StatefulWidget {
  const RecipeBook({super.key});

  @override
  _RocketUiState createState() => _RocketUiState();
}

class _RocketUiState extends State<RecipeBook>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(
    0,
  ); // Notificador para el índice actual

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _currentIndexNotifier.value) {
        _currentIndexNotifier.value =
            _tabController.index; // Sincroniza el índice actual
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _currentIndexNotifier.dispose(); // Libera el notificador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Rocket UI', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _currentIndexNotifier,
          builder: (context, currentIndex, child) {
            return CurvedNavigationBar(
              animationDuration: Duration(milliseconds: 500),
              backgroundColor: Colors.white,
              color: Colors.orange,
              buttonBackgroundColor: Colors.orange,
              height: 60,
              index: currentIndex,
              items: <Widget>[
                Icon(Icons.home, size: 30, color: Colors.white),
                Icon(Icons.auto_fix_normal, size: 30, color: Colors.white),
                Icon(Icons.gamepad, size: 30, color: Colors.white),
                Icon(Icons.delivery_dining, size: 30, color: Colors.white),
                Icon(Icons.person, size: 30, color: Colors.white),
              ],
              onTap: (index) {
                _tabController.index = index; // Cambia directamente el índice
                _currentIndexNotifier.value =
                    index; // Actualiza el índice actual
              },
            );
          },
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(),
            Center(child: Text('Formulario IA')),
            GameScreen(
              tabController: _tabController,
              currentIndexNotifier: _currentIndexNotifier,
            ), // Pasa el notificador
            Center(child: Text('Pedidos')),
            Center(child: Text('Mis Cuenta')),
          ],
        ),
      ),
    );
  }
}
