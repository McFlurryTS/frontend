import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print("Mensaje recibido en segundo plano: ${message.messageId}");
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notificaciones importantes',
    description: 'Canal para notificaciones importantes de McDonald\'s',
    importance: Importance.high,
  );

  static Future<void> init() async {
    // Solicitar permisos para notificaciones
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permisos de notificación concedidos');
    }

    // Crear el canal de notificaciones en Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Configurar las opciones de inicialización
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    // Inicializar con el manejador de notificaciones
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notificación tocada: ${response.notificationResponseType}');
        if (response.payload != null) {
          print('Payload: ${response.payload}');
        }
      },
    );

    // Verificar si la app fue abierta por una notificación
    final notificationAppLaunchDetails =
        await _localNotifications.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      if (notificationAppLaunchDetails?.notificationResponse?.payload != null) {
        print(
          'Payload de lanzamiento: ${notificationAppLaunchDetails?.notificationResponse?.payload}',
        );
      }
    }

    // Configurar manejadores de mensajes
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Obtener el token FCM
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            importance: channel.importance,
            priority: Priority.high,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  static Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    print('Notificación abierta: ${message.messageId}');
  }

  static Future<void> subscribeToTopic(String topic) async {
    if (topic.isEmpty) return;
    final sanitizedTopic = topic.replaceAll(' ', '_').toLowerCase();
    await _firebaseMessaging.subscribeToTopic(sanitizedTopic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    if (topic.isEmpty) return;
    final sanitizedTopic = topic.replaceAll(' ', '_').toLowerCase();
    await _firebaseMessaging.unsubscribeFromTopic(sanitizedTopic);
  }

  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  static List<String> getFavoriteProducts() {
    return [
      'Big Mac',
      'McNuggets',
      'Cuarto de libra',
      'McPollo',
      'Ensalada',
      'Papas grandes',
    ];
  }
}
