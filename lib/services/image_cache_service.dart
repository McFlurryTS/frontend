import 'dart:io';
import 'dart:async';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ImageCacheService {
  static const String _boxName = 'image_cache';
  static Box<String>? _box;
  static DefaultCacheManager? _cacheManager;
  static final Map<String, Uint8List> _memoryCache = {};
  static final Map<String, Completer<Uint8List?>> _loadingImages = {};
  static const int _maxMemoryCacheSize =
      300; // Incrementado para mejor rendimiento
  static final Set<String> _priorityUrls = {}; // Imágenes prioritarias

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<String>(_boxName);
    }
    _cacheManager = DefaultCacheManager();

    // Inicializar inmediatamente
    _cleanOldCache();
    _warmUpCache();
  }

  // Método para cargar imágenes de alta prioridad al inicio
  static Future<void> preloadHomeImages(List<String> urls) async {
    // Registrar estas URLs como prioritarias
    _priorityUrls.addAll(urls);

    // Realizar precarga en paralelo
    await Future.wait(
      urls.map((url) async {
        try {
          // Intentar obtener de caché primero
          final file = await _cacheManager?.getSingleFile(url);
          if (file != null) {
            final bytes = await file.readAsBytes();
            _addToMemoryCache(url, bytes);
          }
        } catch (e) {
          debugPrint('Error precargando imagen prioritaria: $e');
        }
      }),
    );
  }

  static Future<void> _warmUpCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFiles = cacheDir.listSync();

      await Future.wait(
        cacheFiles.map((file) async {
          if (file is File) {
            try {
              final fileName = file.path.split('/').last;
              if (_priorityUrls.contains(fileName)) {
                // Cargar primero las imágenes prioritarias
                final bytes = await file.readAsBytes();
                _memoryCache[fileName] = bytes;
              } else if (_memoryCache.length < _maxMemoryCacheSize) {
                // Cargar otras imágenes si hay espacio
                final bytes = await file.readAsBytes();
                _memoryCache[fileName] = bytes;
              }
            } catch (e) {
              // Ignorar errores individuales
            }
          }
        }),
      );
    } catch (e) {
      debugPrint('Error precargando caché: $e');
    }
  }

  static Future<void> _cleanOldCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFiles = cacheDir.listSync();
      final now = DateTime.now();

      for (var file in cacheFiles) {
        if (file is File) {
          final lastModified = file.lastModifiedSync();
          if (now.difference(lastModified).inDays > 7) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Error limpiando caché: $e');
    }
  }

  // Versión rápida para obtener bytes de imágenes (prioriza memoria)
  static Future<Uint8List?> getCachedImageBytesFast(String url) async {
    // Verificar caché en memoria primero (más rápido)
    if (_memoryCache.containsKey(url)) {
      return _memoryCache[url];
    }

    // Si está cargando, esperar resultado
    if (_loadingImages.containsKey(url)) {
      return await _loadingImages[url]!.future;
    }

    // Intentar cargar de manera rápida
    final completer = Completer<Uint8List?>();
    _loadingImages[url] = completer;

    try {
      // Comprobar si existe un archivo en caché
      final file = await _cacheManager?.getFileFromCache(url);
      if (file != null) {
        // Si ya está en caché, leer bytes
        final bytes = await file.file.readAsBytes();
        _addToMemoryCache(url, bytes);
        completer.complete(bytes);
        _loadingImages.remove(url);
        return bytes;
      }

      // Si no está en caché, recuperarlo
      final downloadedFile = await _cacheManager?.getSingleFile(url);
      if (downloadedFile != null) {
        final bytes = await downloadedFile.readAsBytes();
        _addToMemoryCache(url, bytes);
        completer.complete(bytes);
        _loadingImages.remove(url);
        return bytes;
      }
    } catch (e) {
      debugPrint('Error obteniendo bytes de imagen rápida: $e');
      completer.complete(null);
      _loadingImages.remove(url);
    }

    return null;
  }

  // Método existente para compatibilidad
  static Future<Uint8List?> getCachedImageBytes(String url) async {
    return getCachedImageBytesFast(url);
  }

  static void _addToMemoryCache(String url, Uint8List bytes) {
    if (_memoryCache.length >= _maxMemoryCacheSize) {
      // Si es una imagen prioritaria, eliminar una no prioritaria
      if (_priorityUrls.contains(url)) {
        final nonPriorityKey = _memoryCache.keys.firstWhere(
          (k) => !_priorityUrls.contains(k),
          orElse: () => _memoryCache.keys.first,
        );
        _memoryCache.remove(nonPriorityKey);
      } else {
        // Si no es prioritaria y no hay espacio, no agregarla
        return;
      }
    }
    _memoryCache[url] = bytes;
  }

  static Future<String?> getCachedImagePath(String url) async {
    try {
      final String? cachedPath = _box?.get(url);
      if (cachedPath != null && File(cachedPath).existsSync()) {
        return cachedPath;
      }

      final file = await _cacheManager?.getSingleFile(url);
      if (file != null) {
        await _box?.put(url, file.path);
        // Precarga en memoria si es prioritaria o hay espacio
        if (_priorityUrls.contains(url) ||
            _memoryCache.length < _maxMemoryCacheSize) {
          final bytes = await file.readAsBytes();
          _addToMemoryCache(url, bytes);
        }
        return file.path;
      }
    } catch (e) {
      debugPrint('Error obteniendo path de imagen: $e');
    }
    return null;
  }

  static Future<void> preloadImages(List<String> urls) async {
    final futures = urls.map((url) async {
      if (_memoryCache.containsKey(url)) return;
      try {
        final bytes = await getCachedImageBytesFast(url);
        if (bytes != null) {
          _addToMemoryCache(url, bytes);
        }
      } catch (e) {
        debugPrint('Error precargando imagen $url: $e');
      }
    });

    await Future.wait(futures);
  }

  static Future<void> clearCache() async {
    try {
      await _cacheManager?.emptyCache();
      await _box?.clear();
      _memoryCache.clear();
      _loadingImages.clear();
    } catch (e) {
      debugPrint('Error limpiando caché: $e');
    }
  }
}
