import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final TabController tabController; // Recibe el TabController
  final ValueNotifier<int>
  currentIndexNotifier; // Recibe el notificador del índice

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
