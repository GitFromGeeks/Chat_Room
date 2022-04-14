import 'package:chat_room/screens/chatroom.dart';
import 'package:chat_room/screens/loginScreen.dart';
import 'package:chat_room/utils/firestore_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  String? username;
  HomePage({Key? key, required this.username}) : super(key: key);

  Future<void> logout(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatrooms"),
        actions: [
          Row(
            children: [
              Text(username!),
              IconButton(
                  onPressed: () {
                    logout(context);
                  },
                  icon: const Icon(Icons.logout)),
            ],
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreDatabase.allchatrooms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chatroom(
                                docId: snapshot.data!.docs[index].id)));
                  },
                  child: ListTile(
                    title: Text(snapshot.data!.docs[index].id),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("EMPTY !"));
          }
        },
      ),
    );
  }
}
