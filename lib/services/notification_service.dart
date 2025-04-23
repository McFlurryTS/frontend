import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'cart_channel',
    'Carrito de compras',
    description: 'Notificaciones relacionadas con el carrito de compras',
    importance: Importance.high,
  );

  static Future<void> init() async {
    try {
      await _initPlatformSpecifics();
      await _requestPermissions();
      await _setupFirebaseMessaging();
    } catch (e) {
      debugPrint('Error inicializando notificaciones: $e');
    }
  }

  static Future<void> _initPlatformSpecifics() async {
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static Future<void> _setupFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        'Recibido mensaje en foreground: ${message.notification?.title}',
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
        'Aplicación abierta desde notificación: ${message.notification?.title}',
      );
    });
  }

  static void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      debugPrint('Notificación tocada: ${response.payload}');
    }
  }

  static Future<List<String>> getFavoriteProducts() async {
    try {
      return [
        'Big Mac',
        'McNuggets',
        'McFlurry',
        'Papas Fritas',
        'Hamburguesa con Queso',
        'McPollo',
      ];
    } catch (e) {
      debugPrint('Error obteniendo productos favoritos: $e');
      return [];
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      final formattedTopic = topic.replaceAll(' ', '_').toLowerCase();
      await _firebaseMessaging.subscribeToTopic(formattedTopic);
      debugPrint('Suscrito al tópico: $formattedTopic');
    } catch (e) {
      debugPrint('Error al suscribirse al tópico: $e');
      throw Exception('No se pudo suscribir al tópico: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      final formattedTopic = topic.replaceAll(' ', '_').toLowerCase();
      await _firebaseMessaging.unsubscribeFromTopic(formattedTopic);
      debugPrint('Desuscrito del tópico: $formattedTopic');
    } catch (e) {
      debugPrint('Error al desuscribirse del tópico: $e');
      throw Exception('No se pudo desuscribir del tópico: $e');
    }
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      final zonedScheduleTime = tz.TZDateTime.from(scheduledDate, tz.local);

      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        zonedScheduleTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.high,
            enableLights: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error programando notificación: $e');
      throw Exception('No se pudo programar la notificación: $e');
    }
  }

  static Future<void> showCartExpirationWarning() async {
    try {
      await _localNotifications.show(
        1,
        'Tu carrito está por expirar',
        'Los productos en tu carrito expirarán pronto. ¡Completa tu compra!',
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error mostrando notificación de expiración: $e');
    }
  }

  static Future<void> cancelCartNotifications() async {
    try {
      await _localNotifications.cancel(1);
    } catch (e) {
      debugPrint('Error cancelando notificaciones del carrito: $e');
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
    } catch (e) {
      debugPrint('Error cancelando todas las notificaciones: $e');
    }
  }
}
