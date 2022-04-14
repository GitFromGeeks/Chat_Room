import 'package:flutter/widgets.dart';

class IsEmoji extends ChangeNotifier {
  bool isEmojiUp = false;
  double width = 0;
  void changeIsEmojiUp(bool isit) {
    isEmojiUp = isit;
    notifyListeners();
  }
}
