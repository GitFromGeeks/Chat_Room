import 'package:chat_room/constants.dart';
import 'package:chat_room/providers/emojiProviders.dart';
import 'package:chat_room/screens/homePage.dart';
import 'package:chat_room/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('user');
  usern = user;
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => IsEmoji())],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: user == null
            ? const LoginScreen()
            : HomePage(
                username: prefs.getString('user'),
              )),
  ));
}













// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   Future<bool> checkStatus() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var user = pref.getString('user');
//     if (user != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<bool> loggedin=checkStatus();
//     return const MaterialApp(
//       title: "Chatroom",
//       debugShowCheckedModeBanner: false,
//       home: ,
//     );
//   }
// }