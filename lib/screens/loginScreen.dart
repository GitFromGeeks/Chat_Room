import 'package:chat_room/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> singin(context, String username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("user", username);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  username: pref.getString('user'),
                )));
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: username,
                decoration: const InputDecoration(
                  hintText: "Username",
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  if (username.text != "") {
                    singin(context, username.text);
                  }
                },
                child: const Text("SIGNIN"))
          ],
        ),
      ),
    );
  }
}
