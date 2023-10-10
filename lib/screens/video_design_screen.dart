import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat/models/Message.dart';
import '../controllers/controls_overlay.dart';

class VideoDesignScreen extends StatefulWidget {
final Message message;
  const VideoDesignScreen({Key? key, required this.message}) : super(key: key);

  @override
  State<VideoDesignScreen> createState() => _VideoDesignScreenState();
}

class _VideoDesignScreenState extends State<VideoDesignScreen> {
  late VideoPlayerController _controllerVideo;

  @override
  void initState() {

    // controller for video
    if(widget.message.msg != null){
      _controllerVideo = VideoPlayerController.networkUrl(Uri.parse(widget.message.msg));
    }

    _controllerVideo.addListener(() {
      setState(() {});
    });
    _controllerVideo.setLooping(true);
    _controllerVideo.initialize().then((_) => setState(() {}));
    _controllerVideo.pause();

    super.initState();
  }


  @override
  void dispose(){
    _controllerVideo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
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
      ],
    );
  }
}
