import 'package:McDonalds/game/burger_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final TabController tabController; // Recibe el TabController
  final ValueNotifier<int>
  currentIndexNotifier; // Recibe el notificador del índice

  const GameScreen({
    super.key,
    required this.tabController,
    required this.currentIndexNotifier,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final ValueNotifier<bool> _showModalNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showModalNotifier.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: GameWidget(
              game: BurgerGame(), // Embed the FlameGame here
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _showModalNotifier,
            builder: (context, showModal, child) {
              if (!showModal) return SizedBox.shrink();
              return Center(
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/game_hud/dpad.png',
                            height: 100,
                          ),
                          const Text(
                            'Este control te permite moverte por el mapa.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/game_hud/grab.png',
                            height: 100,
                          ),
                          const Text(
                            'Este control te permite agarrar y soltar la basura cerca tuyo.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _showModalNotifier.value = false;
                      },
                      child: const Text('¡Iniciemos!'),
                    ),
                  ],
                ),
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: BurgerGame.showResetButtonNotifier,
            builder: (context, showButton, child) {
              if (!showButton) return SizedBox.shrink();
              return Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    BurgerGame.instance?.reset();
                  },
                  icon: Icon(Icons.autorenew),
                  label: Text('Reiniciar'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
