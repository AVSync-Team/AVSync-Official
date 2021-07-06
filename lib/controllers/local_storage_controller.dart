import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageController extends GetxController {
  var userName = ''.obs;
  Rx<SharedPreferences> prefs;

  void setUserName({String name, SharedPreferences preferences}) {
    preferences.setString('userName', name);
  }

  void checkDataisThere(SharedPreferences preferences) {
    String value = preferences.getString('userName');
    print('SharedPrefs $value');
  }
}
