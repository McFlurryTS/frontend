import 'package:flutter/material.dart';
import 'package:McDonalds/utils/rocket_theme.dart';

class CartConfirmationDialog extends StatelessWidget {
  final TabController? tabController;
  final ValueNotifier<int>? currentIndexNotifier;

  const CartConfirmationDialog({
    super.key,
    this.tabController,
    this.currentIndexNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          constraints: BoxConstraints(maxWidth: 400, minWidth: 280),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    '¡Producto agregado al carrito!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    if (isSmallScreen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCancelButton(context),
          const SizedBox(height: 12),
          _buildConfirmButton(context),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _buildCancelButton(context)),
        const SizedBox(width: 12),
        Expanded(child: _buildConfirmButton(context)),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        'Seguir comprando',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        if (tabController != null) {
          currentIndexNotifier?.value = 2;
          tabController?.animateTo(2);
        } else {
          Navigator.of(context).pushNamed('/cart');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: RocketColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Ir al carrito',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }
}
