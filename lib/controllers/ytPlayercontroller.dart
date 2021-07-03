import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class YTStateController extends GetxController {
  var videoPosition = 0.0.obs;
  var isYtUrlValid = 1.obs;

  Future<void> getInfo() async {
    // EventSource eventSource = EventSource(
    //     'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/-MSIYp9fC03ddmeMfGOO/timeStamp.json');
    // eventSource.addEventListener('text/event-stream', (event) {
    //   print(event);

    Stream loda;
    loda.listen((event) {
      print(event);
    });

    final response = await http.get(
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/-MSIdyAkrq0f_r7ymlCD/timeStamp.json',
        headers: {'type': 'text/event-stream'});
    print('response: ${response.body}');
  }

  void checkYotutTubeUrl({String ytURl}) {
    //String nadda = 'nadda';
    if (ytURl == '') {
      isYtUrlValid.value = 1;
    }
    RegExp regExp = new RegExp(
      r"http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?‌​=]*)?",
      caseSensitive: false,
      multiLine: false,
    );
    if (regExp.hasMatch(ytURl) == true) {
      isYtUrlValid.value = 2;
    }

    //isYtUrlValid.value = regExp.hasMatch(ytURl);
    print("isUrlValid ${isYtUrlValid.value}");
  }
}
