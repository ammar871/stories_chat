import 'dart:async';

import 'package:flutter/cupertino.dart';

class TimeController extends ValueNotifier<bool>{
  TimeController({bool isPlaying = false}) : super(isPlaying);

  void startTimer() => value=true;
  void stopTimer() => value =false;

}

class TextTimer extends StatefulWidget {

 final TimeController timeController;


 TextTimer(this.timeController);

  @override
  State<TextTimer> createState() => _TextTimerState();
}

class _TextTimerState extends State<TextTimer> {
  Duration duration = Duration();
  Timer? timer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.timeController.addListener(() {
      if(widget.timeController.value){
        startTimer();
      }else{
        stopTimer();
      }
    });
  }
  void rest() => duration = Duration();
  final secondsvalue =1;
  void addTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool rests = true}) {
    if (!mounted) return;
    if (rests) {
      rest();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());

    print(duration.inSeconds);
  }
  void stopTimer({bool rests = true}) {
    if (!mounted) return;
    if (rests) {
      rest();
    }
    setState(() {
      timer?.cancel();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '${duration.inSeconds}'
      ),
    );
  }
}
