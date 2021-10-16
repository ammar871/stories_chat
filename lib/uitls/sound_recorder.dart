import 'dart:io';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const pathToSaveAudio = "_audio_example.aac";

class SoundRecorder {
  FlutterSoundRecorder? _audioRecord;
  bool _isRecordingInitlaize = false;

  bool get isRecording => _audioRecord!.isRecording;

  Future inIt() async {
    _audioRecord = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Permission not ");
    }
    await _audioRecord!.openAudioSession();
    _isRecordingInitlaize = true;
    print("init");
  }

  Future dispose() async {
    if (!_isRecordingInitlaize) return;
    await _audioRecord!.closeAudioSession();
    _audioRecord = null;
    _isRecordingInitlaize = false;
  }

  Future _record() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filepath = directory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';
    if (!_isRecordingInitlaize) return;
    await _audioRecord!.startRecorder(toFile: filepath).then((value){
      print("starting");
    });

  }

  Future _stop() async {
    if (!_isRecordingInitlaize) return;

    await _audioRecord!.stopRecorder();
    _audioRecord!.getRecordURL(path: pathToSaveAudio).then((value) {

      print(value);

    });

  }

  Future toggleRecording() async {
    print("toggleRecording");
    if (_audioRecord!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
