import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

const appId2 = "33d6b0f5d1674f98b9854da131c9ab25";

class VideoCall extends StatefulWidget {
  ChatRoom chatRoom;

  VideoCall({Key? key, required this.chatRoom}) : super(key: key);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  int? _remoteUid;
  late RtcEngine _engine;
  bool muted = false;
  Widget localView = Container();
  bool frontCamera = true;
  bool isZoom = false;

  @override
  void initState() {
    super.initState();
    initAgora().then((value) {
      localView = RtcLocalView.SurfaceView();
      setState(() {});
    });
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
    //create the engine
    _engine = await RtcEngine.create(appId2);
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {},
        userJoined: (int uid, int elapsed) {
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(null, widget.chatRoom.id ?? '', null, 0);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#f2ad9f'),
      //Color(0xffffae88),
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        iconTheme: IconThemeData(color: Colors.black38),
        backgroundColor: Color(0xfffcf3f4),
        centerTitle: false,
        title: Text(
          widget.chatRoom.title ?? '',
          style: TextStyle(
            fontSize: 22.sp,
            color: Color(0xff6a515e),
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Stack(
        children: [
          isZoom == true ? showHalfScreen() : showFullScreen(),
          zoomButton(),
          _toolbar(),
        ],
      ),
    );
  }

  Widget showFullScreen() {
    return Stack(
      children: [
        Center(
          child: _remoteVideo(),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 150.w,
            height: 150.h,
            padding: EdgeInsets.only(top: 10.h, left: 10.h),
            child: Center(
              child: localView,
            ),
          ),
        ),
      ],
    );
  }

  Widget showHalfScreen() {
    return Container(
      height: MediaQuery.of(context).size.height - 50.h,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: localView,
            ),
          ),
          Expanded(
            child: Container(
              child: _remoteVideo(),
            ),
          ),
        ],
      ),
    );
  }

  Widget zoomButton() {
    if (isZoom==false) {
      return Align(
          alignment: Alignment.topRight,
          child: InkWell(
              onTap: () {
                isZoom = !isZoom;
                setState(() {});
              },
              child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.zoom_out_map,
                      size: 25,
                      color: Colors.black45,
                    ),
                  ))));
    } else {
      return Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              isZoom = !isZoom;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Container(
                  height: 25.h,
                    width: 25.w,
                    child: Image.asset('assets/icons/icon_zoom_in.png',color: Colors.black45,)),
              ),
            ),
          ));
    }
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid!);
    } else {
      return Center(
        child: Text(
          'Please wait for friend to join',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Container(
                height: 25.h,
                width: 25.w,
                child: Image.asset('assets/icons/icon_camera_roll.png')),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  /// Helper function to get list of native views
  Future<void> _onCallEnd(BuildContext context) async {
    await _engine.disableVideo();
    await _engine.leaveChannel();
    _engine.destroy();
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    //  _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _engine.destroy();
    super.dispose();
  }
}
