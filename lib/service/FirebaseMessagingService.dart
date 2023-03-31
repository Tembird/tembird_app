import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class FirebaseMessagingService extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  StreamSubscription? _firebaseMessagingSubscription;

  @override
  void onInit() async {
    // print(await _firebaseMessaging.getToken());
    await initialize();
    super.onInit();
  }

  @override
  void onClose() async {
    if (_firebaseMessagingSubscription == null) return;
    _firebaseMessagingSubscription!.cancel();
    _firebaseMessagingSubscription = null;
    super.onClose();
  }

  Future<void> initialize() async {
    await _reqPermission();

    // Handle messages when the app is in the foreground
    _firebaseMessagingSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
    });

    // Handle messages when the app is in the background or terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Request permission to get notification message
  Future<void> _reqPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission to receive notifications');
    } else {
      print('User did not grant permission to receive notifications');
    }
  }

  // Function to handle messages when the app is in the background or terminated
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Received message in background: ${message.notification?.title}');
  }

  Future<void> deleteFcmToken() async {
    await _firebaseMessaging.deleteToken();
  }

  // Future<void> fcmForegroundHandler(RemoteMessage message, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, AndroidNotificationChannel? channel) async {
  //   print('[FCM - Foreground] MESSAGE : ${message.data}');
  //
  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //     flutterLocalNotificationsPlugin.show(
  //         message.hashCode,
  //         message.notification?.title,
  //         message.notification?.body,
  //         NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               channel!.id,
  //               channel.name,
  //               channel.description,
  //               icon: '@mipmap/ic_launcher',
  //             ),
  //             iOS: const IOSNotificationDetails(
  //               badgeNumber: 1,
  //               subtitle: 'the subtitle',
  //               sound: 'slow_spring_board.aiff',
  //             )));
  //   }
  // }
  //
  // Future<void> setupInteractedMessage(FirebaseMessaging fcm) async {
  //   RemoteMessage? initialMessage = await fcm.getInitialMessage();
  //   // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
  //   if (initialMessage != null) clickMessageEvent(initialMessage);
  //   // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
  //   FirebaseMessaging.onMessageOpenedApp.listen(clickMessageEvent);
  // }
  // void clickMessageEvent(RemoteMessage message) {
  //   print('message : ${message.notification!.title}');
  //   Get.toNamed('/');
  // }
}