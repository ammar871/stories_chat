import 'dart:convert';
import 'package:http/http.dart' as http;
class CallNotification{


 static Future<void> sendPushMessage(
      {required String token, required String title, required String body,required String userPhone}) async {

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key = AAAARWFZ2zQ:APA91bEJ7wT0KO9MdhfYDkkC4RI_kPsy4SKduQr0N_a_LURCeoEOTuRDybZs6cnG-0rgr5_3XS1vSPseDdZW8CeOqJuMhYFEQTlOKgxbLCtvIAUf5Q8wTaqH6s7nC-eX8EBiUwpAHg-L'
    };
    var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to":token,
      "notification": {
        "body": body,
        "title": title,

      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sound": "default",
        "status": "done",
        "userphone":userPhone,
        "screen": "chatPage"
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }



/*
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization":'key = AAAARWFZ2zQ:APA91bEJ7wT0KO9MdhfYDkkC4RI_kPsy4SKduQr0N_a_LURCeoEOTuRDybZs6cnG-0rgr5_3XS1vSPseDdZW8CeOqJuMhYFEQTlOKgxbLCtvIAUf5Q8wTaqH6s7nC-eX8EBiUwpAHg-L'
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }*/
  }
}