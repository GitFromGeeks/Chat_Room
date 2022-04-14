import 'package:chat_room/constants.dart';
import 'package:chat_room/providers/emojiProviders.dart';
import 'package:chat_room/utils/firestore_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chatroom extends StatelessWidget {
  String? docId;
  Chatroom({Key? key, required this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    bool isEmojiUp = Provider.of<IsEmoji>(context).isEmojiUp;
    return Scaffold(
      appBar: AppBar(
        title: Text(docId!),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.83,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreDatabase.getChating(docId: docId!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return (snapshot.data!.docs[index]['user'] != usern)
                            ? ListTile(
                                leading: CircleAvatar(
                                    child: Text(
                                  snapshot.data!.docs[index]['user'],
                                  style: const TextStyle(fontSize: 12),
                                )),
                                title: Card(
                                    color: const Color.fromARGB(
                                        255, 202, 198, 198),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(snapshot.data!.docs[index]
                                          ['message']),
                                    )),
                              )
                            : sendingCard(snapshot.data!.docs[index]['user'],
                                snapshot.data!.docs[index]['message']);
                      },
                    ),
                  );
                } else {
                  return const Text("EMPTY ");
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 65),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(30.0)),
                // width: 250,
                width: (isEmojiUp) ? 275 : 0,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        emojiButton(context, isEmojiUp, docId!, "😃"),
                        emojiButton(context, isEmojiUp, docId!, "😡"),
                        emojiButton(context, isEmojiUp, docId!, "😍"),
                        emojiButton(context, isEmojiUp, docId!, "🤣"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.grey,
              height: MediaQuery.of(context).size.height * 0.07,
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Provider.of<IsEmoji>(context, listen: false)
                              .changeIsEmojiUp(!isEmojiUp);
                        },
                        icon: const Icon(Icons.emoji_emotions)),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextFormField(
                              controller: messageController,
                              keyboardType: TextInputType.streetAddress,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "                   Message"),
                            ),
                          ),
                        )),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          FirestoreDatabase.sendMessage(
                              docId: docId!, message: messageController.text);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.blueAccent,
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget sendingCard(String user, message) {
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              color: const Color.fromARGB(255, 202, 198, 198),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message),
              )),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: CircleAvatar(
            child: Text(
          user,
          style: const TextStyle(fontSize: 12),
        )),
      ),
    ],
  );
}

Widget emojiButton(context, isItup, String docId, msg) {
  return TextButton(
    onPressed: () {
      FirestoreDatabase.sendMessage(docId: docId, message: msg);
      Provider.of<IsEmoji>(context, listen: false).changeIsEmojiUp(!isItup);
    },
    child: Text(
      msg,
      style: const TextStyle(fontSize: 30),
    ),
  );
}
