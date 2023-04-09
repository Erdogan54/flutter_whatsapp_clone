import 'package:http/http.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';
import 'package:http/http.dart' as http;

class SendingNotificationsService {
  Future<bool> sendNotification(MessageModel sendingNotification, UserModel? senderUser, String? token) async {
   // String url = "https://fcm.googleapis.com/fcm/send";
    var uri = Uri.https('fcm.googleapis.com', 'fcm/send');

    String firebaseKey =
        "AAAA4zSJ77I:APA91bHv_Y6P4Hiiltn1smOoTYex9uxyAzcwGV3G5S40yanJoQDH7Jx31c-yoQ-zHZBinKTmVdGX6xq2AgOZZAI9sEtAhC1KK12Lpu3pnvvvLAYaFpu8_Cgq6c2X6bwMAuXCHKrkhr8Z";

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firebaseKey",
    };

    String json = '''{
          "to": "$token",
          "data":{
                  "title":"${senderUser?.userName}",
                  "message":"${sendingNotification.message}",
                  "photo-url":"${senderUser?.photoUrl}",
                  "senderUserId":"${senderUser?.userId}",
                 }
        }''';

    Response response = await http.post(uri, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("bildirim gönderme işlemi başarılı");
    } else {
      print("bildirin gönderme başarısız ${response.statusCode}");
      print("json $json");
    }

    return true;
  }
}
