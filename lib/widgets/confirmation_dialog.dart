import 'package:flutter/material.dart';
import 'package:McDonalds/utils/rocket_theme.dart';

class ConfirmationDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final Color iconColor;
  final bool isLoadingAction;

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.confirmText,
    this.cancelText = 'Cancelar',
    required this.icon,
    required this.iconColor,
    this.isLoadingAction = false,
  });

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: widget.iconColor, size: 48),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.subtitle!,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () => Navigator.of(context).pop(false),
                  child: Text(
                    widget.cancelText,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () async {
                            if (widget.isLoadingAction) {
                              setState(() => _isLoading = true);
                              await Future.delayed(
                                const Duration(milliseconds: 300),
                              );
                              if (mounted) {
                                Navigator.of(context).pop(true);
                              }
                            } else {
                              Navigator.of(context).pop(true);
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RocketColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            widget.confirmText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showContinueDialog(
  BuildContext context, {
  String title = '¿Desea continuar?',
  String? subtitle,
  String confirmText = 'Continuar',
  String cancelText = 'Finalizar',
  bool barrierDismissible = false,
  bool isLoadingAction = true,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder:
        (context) => ConfirmationDialog(
          title: title,
          subtitle: subtitle,
          confirmText: confirmText,
          cancelText: cancelText,
          icon: Icons.help_outline,
          iconColor: RocketColors.primary,
          isLoadingAction: isLoadingAction,
        ),
  ).then((value) => value ?? false);
}
