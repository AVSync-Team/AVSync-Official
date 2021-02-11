// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:get/get.dart';

// class SoundController extends GetxController {
//   FlutterSoundPlayer _mplayer = FlutterSoundPlayer();
//   var _mPlayerIsInited = false.obs;

//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     _mplayer.openAudioSession().then((value) {});
//     _mPlayerIsInited.value = true;
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _mplayer.closeAudioSession();
//     _mplayer = null;
//   }

//   void play() async {
//     if (_mPlayerIsInited.value) {
//       await _mplayer.startPlayer(
//         fromURI: 'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3',
//         codec: Codec.mp3,
//         whenFinished: () {
//           stopPlayer();
//         },
//       );
//     }
//     // print(_mPlayerIsInited.value);
//   }

//   void stopPlayer() async {
//     if (_mplayer != null) {
//       await _mplayer.stopPlayer();
//     }
//   }
// }
