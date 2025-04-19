import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:McDonalds/services/image_cache_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OptimizedImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget Function(BuildContext, dynamic)? errorWidget;
  final bool useMemoryCache;
  final int? cacheWidth;
  final int? cacheHeight;
  final Duration fadeInDuration;
  final bool preload;
  final bool enableBlur;
  final double? borderRadius;
  final bool highPriority;
  final bool useSkeletonizer;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.useMemoryCache = true,
    this.cacheWidth,
    this.cacheHeight,
    this.fadeInDuration = const Duration(milliseconds: 200),
    this.preload = true,
    this.enableBlur = false,
    this.borderRadius,
    this.highPriority = false,
    this.useSkeletonizer = false,
  });

  @override
  State<OptimizedImage> createState() => _OptimizedImageState();
}

class _OptimizedImageState extends State<OptimizedImage> {
  bool _isLoading = true;
  Uint8List? _imageBytes;
  String? _cachedPath;

  @override
  void initState() {
    super.initState();
    if (widget.highPriority) {
      // Cargar inmediatamente con alta prioridad
      _loadHighPriorityImage();
    } else if (widget.preload) {
      // Cargar normalmente
      _loadImage();
    }
  }

  Future<void> _loadHighPriorityImage() async {
    try {
      // Intentar obtener bytes desde la memoria caché primero (es más rápido)
      _imageBytes = await ImageCacheService.getCachedImageBytesFast(
        widget.imageUrl,
      );

      if (_imageBytes != null && mounted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Si no está en caché, obtener la ruta del archivo
      _cachedPath = await ImageCacheService.getCachedImagePath(widget.imageUrl);

      if (_cachedPath != null && mounted) {
        setState(() {
          _isLoading = false;
        });
      } else {
        // Caer de nuevo a CachedNetworkImage si no está disponible localmente
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error cargando imagen de alta prioridad: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadImage() async {
    // Método regular para cargar imágenes no prioritarias
    try {
      _cachedPath = await ImageCacheService.getCachedImagePath(widget.imageUrl);

      if (_cachedPath != null && mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error cargando imagen: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_isLoading) {
      if (widget.useSkeletonizer) {
        imageWidget = Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius:
                widget.borderRadius != null
                    ? BorderRadius.circular(widget.borderRadius!)
                    : null,
          ),
          child: Skeletonizer(
            enabled: true,
            containersColor: Colors.grey[300],
            effect: ShimmerEffect(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
            ),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      } else {
        imageWidget =
            widget.placeholder ??
            Container(
              color: Colors.grey[200],
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.grey[400]!,
                    ),
                  ),
                ),
              ),
            );
      }
    } else if (_imageBytes != null) {
      // Si tenemos bytes en memoria, usarlos (opción más rápida)
      imageWidget = Image.memory(
        _imageBytes!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        cacheWidth: widget.cacheWidth,
        cacheHeight: widget.cacheHeight,
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget?.call(context, error) ??
              const Icon(Icons.error);
        },
      );
    } else if (_cachedPath != null) {
      // Si tenemos la imagen en caché local, usarla
      imageWidget = Image.file(
        File(_cachedPath!),
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        cacheWidth: widget.cacheWidth,
        cacheHeight: widget.cacheHeight,
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget?.call(context, error) ??
              const Icon(Icons.error);
        },
      );
    } else {
      // Caer de nuevo a CachedNetworkImage si no está disponible localmente
      imageWidget = CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        memCacheWidth: widget.cacheWidth,
        memCacheHeight: widget.cacheHeight,
        fadeInDuration: widget.fadeInDuration,
        placeholder:
            (context, url) =>
                widget.placeholder ??
                Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey[400]!,
                        ),
                      ),
                    ),
                  ),
                ),
        errorWidget:
            (context, url, error) =>
                widget.errorWidget?.call(context, error) ??
                const Icon(Icons.error),
      );
    }

    // Aplicar bordes redondeados si se especificaron
    if (widget.borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
