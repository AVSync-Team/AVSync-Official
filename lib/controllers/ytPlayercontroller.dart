import 'package:VideoSync/views/video%20players/YTPlayer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum LinkValidity {
  Valid,
  Invalid,
}

enum LinkType { YTLink, BrowserLink }

class YTStateController extends GetxController {
  var videoPosition = 0.0.obs;
  // var isYtUrlValid = 1.obs;
  var linkValidity = LinkValidity.Invalid.obs;
  var linkType = LinkType.YTLink.obs;

  Future<void> getInfo() async {
    // EventSource eventSource = EventSource(
    //     'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/-MSIYp9fC03ddmeMfGOO/timeStamp.json');
    // eventSource.addEventListener('text/event-stream', (event) {
    //   print(event);

    Stream loda;
    loda.listen((event) {
      print(event);
    });

    var response = await http.get(
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/-MSIdyAkrq0f_r7ymlCD/timeStamp.json',
        headers: {'type': 'text/event-stream'});
    print('response: ${response.body}');
  }

  void checkYotutTubeUrl({String ytURl}) {
    //String nadda = 'nadda';
    if (ytURl == '') {
      linkValidity.value = LinkValidity.Invalid;
    }
    RegExp regExp = new RegExp(
      r"(http://)?(www\.)?(youtube|yimg|youtu)\.([A-Za-z]{2,4}|[A-Za-z]{2}\.[A-Za-z]{2})/(watch\?v=)?[A-Za-z0-9\-_]{6,12}(&[A-Za-z0-9\-_]{1,}=[A-Za-z0-9\-_]{1,})*",
      caseSensitive: false,
      multiLine: false,
    );
    if (regExp.hasMatch(ytURl) == true) {
      print(regExp.hasMatch(ytURl));
      linkValidity.value = LinkValidity.Valid;
    }

    //isYtUrlValid.value = regExp.hasMatch(ytURl);
    // print("isUrlValid ${isYtUrlValid.value}");
  }

  void checkLinkValidty(String url) {
    RegExp regExpForYT = new RegExp(
      r"(http://)?(www\.)?(youtube|yimg|youtu)\.([A-Za-z]{2,4}|[A-Za-z]{2}\.[A-Za-z]{2})/(watch\?v=)?[A-Za-z0-9\-_]{6,12}(&[A-Za-z0-9\-_]{1,}=[A-Za-z0-9\-_]{1,})*",
      caseSensitive: false,
      multiLine: false,
    );
    RegExp regExpForBrowserLink = new RegExp(
      r"(https?|ftp)://([0-9]|\.|[a-z]|[A-Z]|_|/|,|=|\?){5,}\.mp4/g",
      caseSensitive: false,
      multiLine: false,
    );
    if (regExpForYT.hasMatch(url)) {
      print("it's a yt link");
      linkType.value = LinkType.YTLink;
    } else {
      print("it's not  a yt link");
      linkType.value = LinkType.BrowserLink;
    }
    if (regExpForYT.hasMatch(url) || url.endsWith(".mp4")) {
      linkValidity.value = LinkValidity.Valid;
    } else {
      linkValidity.value = LinkValidity.Invalid;
    }
  }

  // void checkIfBrowserLink(String url) {
  //   if (url == '') {
  //     linkValidity.value = LinkValidity.Invalid;
  //   }
  //   RegExp regExp = new RegExp(
  //     r"",
  //     caseSensitive: false,
  //     multiLine: false,
  //   );
  //   if (regExp.hasMatch(url) == true) {
  //     linkType.value = LinkType.BrowserLink;
  //   }
  // }
}
