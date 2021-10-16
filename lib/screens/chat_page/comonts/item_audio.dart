
import 'package:audioplayers/audioplayers.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart'as prefix;
import 'package:intl/intl.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/text_message_entity.dart';
import 'package:stories_chat/helper/constans.dart';

class ItemAudio extends StatefulWidget {
  final TextMessageEntity message;
  final String userUid;
  final String senderUid;

  ItemAudio(
      {required this.message, required this.userUid, required this.senderUid});

  @override
  State<ItemAudio> createState() => _ItemAudioState();
}

class _ItemAudioState extends State<ItemAudio> {

  bool isPlay = false;

  /// Compulsory
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;


  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;

  /// Optional
  Widget slider() {
    return Container(
    
      child: Slider.adaptive(

        activeColor: greenColor,

          value: timeProgress.toDouble(),
          max: audioDuration.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }
  /// Compulsory
  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }
  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer
        .seek(newPos); // Jumps to the given position within the audio file
  }

  /// Optional
  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  /// Compulsory
  playMusic() async {
    // Add the parameter "isLocal: true" if you want to access a local file
   // await audioPlayer.play(url);
  }

  /// Compulsory
  pauseMusic() async {
    await audioPlayer.pause();
  }
  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      setState(() {
        audioPlayerState = state;
        if(state==AudioPlayerState.COMPLETED){
          timeProgress = 0;

        }
      });
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration position) async {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 1,
          bottom: 3,
          left: ((widget.message.sederUID == widget.senderUid) ? 64 : 10),
          right: ((widget.message.sederUID == widget.senderUid) ? 10 : 64)),
      child: Container(
height: 60,
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.symmetric(horizontal: 5),


        child: Bubble(
          color: (widget.message.sederUID == widget.userUid)
              ? Colors.lightGreen[400]
              : Colors.white,
          nip: widget.message.sederUID == widget.senderUid?BubbleNip.rightTop:BubbleNip.leftTop,
          child: Stack(

            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    audioPlayerState == AudioPlayerState.PLAYING
                        ? IconButton(

                        onPressed: () {
                          print("okkk");
                          audioPlayer.pause();

                        },
                        icon: Icon(Icons.pause))
                        : IconButton(
                        onPressed: () {
                          print("wwwww");
                          audioPlayer.play(widget.message.message);
                          setState(() {
                            isPlay = true;
                          });
                        },
                        icon: Icon(Icons.play_arrow)),
                   Expanded(child: slider()),
                    Text(
                      getTimeString(timeProgress),
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  DateFormat('hh:mm a').format(widget.message.time.toDate()),
                  style: TextStyle(fontSize: 10),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}