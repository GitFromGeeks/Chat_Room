import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection("chating");

class FirestoreDatabase {
  // GET ALL CHATROOM AVAILABLE
  static Stream<QuerySnapshot> allchatrooms() {
    return _mainCollection.snapshots();
  }

  // GET ALL CHATING MESSAGES
  static Stream<QuerySnapshot> getChating({required String docId}) {
    return _mainCollection
        .doc(docId)
        .collection("chat")
        .orderBy('createAt')
        .snapshots();
  }

  // POST MESSAGE
  static Future<void> sendMessage(
      {required String docId, required message}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user = pref.getString('user');
    DocumentReference documentReference =
        _mainCollection.doc(docId).collection("chat").doc();
    Map<String, dynamic> data = {
      'user': user,
      'message': message,
      'createAt': DateTime.now()
    };
    await documentReference
        .set(data)
        // ignore: avoid_print
        .whenComplete(() => print(" DONE"))
        // ignore: avoid_print
        .catchError((e) => print(e));
  }
}
