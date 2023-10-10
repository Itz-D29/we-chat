import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:shout/repository/server/response_model/get_feed_list_model/get_feed_list_model.dart';
import 'package:shout/screens/video_screen/controls_overlay.dart';
import 'package:shout/screens/wave_form.dart';
import 'package:shout/utils/colors.dart';
import 'package:video_player/video_player.dart';

class VideoDesignScreen extends StatefulWidget {
  final String feedId;
  final String fileId;
  final Record? singleFeedRecordData;
  final String? postedTimeAgo;
  const VideoDesignScreen({required this.feedId, required this.fileId, this.singleFeedRecordData, this.postedTimeAgo,  Key? key}) : super(key: key);

  @override
  State<VideoDesignScreen> createState() => _VideoDesignScreenState();
}

class _VideoDesignScreenState extends State<VideoDesignScreen> {
  late VideoPlayerController _controllerVideo;
  late PlayerController _controllerAudio;
  late StreamSubscription<PlayerState> playerStateSubscription;

  @override
  void initState() {

    // controller for video
    if(widget.singleFeedRecordData?.videoLink != null){
      _controllerVideo = VideoPlayerController.network(widget.singleFeedRecordData!.videoLink!);
    }

    _controllerVideo.addListener(() {
      setState(() {});
    });
    _controllerVideo.setLooping(true);
    _controllerVideo.initialize().then((_) => setState(() {}));
    _controllerVideo.setVolume(0.0);
    _controllerVideo.pause();

    // controller for audio
    _controllerAudio = PlayerController();
    playerStateSubscription = _controllerAudio.onPlayerStateChanged.listen((_) {
      print("player state is: ${_controllerAudio.playerState}");
      setState(() {});
    });


    super.initState();
  }


  @override
  void dispose(){
    _controllerVideo.dispose();
    _controllerAudio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          //aspectRatio: _controller.value.aspectRatio,
          width: double.infinity,
          height: 300,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              VideoPlayer(_controllerVideo),
              ControlsOverlay(controller: _controllerVideo),
              VideoProgressIndicator(_controllerVideo, allowScrubbing: true),
            ],
          ),
        ),

        /*Container(
                                 width: double.infinity,
                                 height: 300,
                                 color: AppColors.kTextBackground,
                                 child: Align(
                                     alignment: Alignment.center,
                                     child: Image.asset("assets/images/shout_image.png",height: 190,width: 200,))
                             ),*/

        Padding(
          padding: EdgeInsets.only(left:20, right: 20, bottom: 15.0),
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.kAudioBackgroundContainer,
                borderRadius: BorderRadius.circular(12.0)
            ),
            child: WaveBubble((){},
              path: widget.singleFeedRecordData?.audioLink,
              waveStyle: "feed_list_audio_waveStyle",
              controller: _controllerAudio,
              recordDuration: widget.singleFeedRecordData?.audioDuration,
              fileId: widget.fileId,
            ),
          ),
        ),
      ],
    );
  }
}
