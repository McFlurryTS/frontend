import 'package:demo/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart'; // Import Flame package

class MyFlameGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    // Add your game initialization logic here
    super.onLoad();
  }
}

class GameScreen extends StatelessWidget {
  final TabController tabController; // Recibe el TabController
  final ValueNotifier<int> currentIndexNotifier; // Recibe el notificador del índice

  const GameScreen({
    super.key,
    required this.tabController,
    required this.currentIndexNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Game Screen', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Expanded(
              child: GameWidget(
                game: MyFlameGame(), // Embed the FlameGame here
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                tabController.animateTo(0); // Cambia al índice de HomeScreen
                currentIndexNotifier.value =
                    0; // Actualiza el índice del CurvedNavigationBar
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
