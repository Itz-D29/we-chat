import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:wechat/screens/splash_screen.dart';
import 'firebase_options.dart';


 late  Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((value){
  _intializeFirebase();
      runApp(const MyApp());
 // });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'We Chat',
      theme: ThemeData(
        // tested with just a hot reload.
     appBarTheme: const AppBarTheme(
       iconTheme: IconThemeData(color: Colors.white),
       elevation: 1,
       centerTitle: true,
     titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 22),),
        //primarySwatch: Colors.cyan,
      ),
        home: const SplashScreen(),
      );

  }
}

_intializeFirebase() async{
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats');
    print('Notification-Channel-Result $result');
}

