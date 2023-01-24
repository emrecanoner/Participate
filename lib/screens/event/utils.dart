import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:participate/screens/sign_up/utils.dart';

late DatabaseReference dbRef;

class Chat {
  final String chat_uid;
  final String chat_name;
  final String chat_photo;
  final String user_id;

  Chat(this.chat_uid, this.chat_name, this.chat_photo, this.user_id);
}

Future<String> getChatUID(String chatName, String useruid) async {
  List<Chat> chat = await getUserChats(useruid);
  String chatUID = '';
  try {
    for (var element in chat) {
      if (element.chat_name == chatName) {
        chatUID = element.chat_uid;
        break;
      } else {
        continue;
      }
    }
    return chatUID;
  } on TypeError catch (e) {
    print('chatUID: ${e.toString()}');
    return '';
  } catch (e) {
    print('chatUID: ${e.toString()}');
    return '';
  }
}

Future<List<Chat>> getUserChats(String useruid) async {
  List<Chat> chatInfo = [];
  final snapshot = await DBref.child('Chats').child(useruid).get();

  try {
    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map;
      data.forEach((key, value) {
        chatInfo.add(Chat(
            key, value['chat_name'], value['chat_photo'], value['user_uid']));
      });
      return chatInfo;
    } else {
      return [];
    }
  } on TypeError catch (e) {
    if (e.toString() == "type 'Null' is not a subtype of type 'Uint8list'") {
      print('chats: ${e.toString()}');
      return [];
    }
    return [];
  } catch (e) {
    print('chats: ${e.toString()}');
    return [];
  }
}

DateTime selectedDateAtBar = DateTime.now();

DatePickerController dateControl = DatePickerController();
