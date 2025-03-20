import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final localNotification = FlutterLocalNotificationsPlugin();

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print("title :${message.notification?.title}");
    print("body :${message.notification?.body}");
    print("data :${message.data}");
  }

  static Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;
    print("title :${message.notification?.title}");
    print("body :${message.notification?.body}");
    print("data :${message.data}");
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    final channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    final localNotification = FlutterLocalNotificationsPlugin();
    await localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    showFlutterNotification(message, localNotification, channel);
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    print('Handling a background message ${message.messageId}');
  }

  static void showFlutterNotification(
      RemoteMessage message,
      FlutterLocalNotificationsPlugin localNotification,
      AndroidNotificationChannel channel) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        final notification = event.notification;
        print("hola aqui llega");
        if (notification == null) return;
        print("hola aqui llega 1");
        localNotification.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    icon: "@mipmap/ic_launcher")),
            payload: jsonEncode(event.toMap()));
      },
    );
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      print("hola aqui llega 2");
      if (notification == null) return;
      print("hola aqui llega 3");
      localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  icon: "@mipmap/ic_launcher")),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future initLocations() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const setting = InitializationSettings(android: android);
    await localNotification.initialize(
      setting,
      onDidReceiveNotificationResponse: (details) {
        final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
        handleMessage(message);
      },
    );
    await localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
