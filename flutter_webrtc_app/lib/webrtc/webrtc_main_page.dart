import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_app/webrtc/models/webrtc_controller.dart';
import 'package:flutter_webrtc_app/webrtc/webrtc_page.dart';

class WebRTCMainPage extends StatefulWidget {
  const WebRTCMainPage({super.key});

  @override
  State<WebRTCMainPage> createState() => _WebRTCMainPageState();
}

class _WebRTCMainPageState extends State<WebRTCMainPage> {
  final WebRTCController _controller = WebRTCController();

  @override
  void initState() {
    super.initState();
    _controller.initHandler();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: _controller.screenNotifier,
        builder: (_, screenState, context) {
          late Widget body;
          switch (screenState) {
            case ScreenState.loading:
              body = const Center(
                child: Text("loading..."),
              );
              break;
            case ScreenState.initDone:
              body = _initDone();
              break;
            case ScreenState.receivedCalling:
              body = _receivedCalling();
              break;
          }
          return Scaffold(
            appBar: screenState == ScreenState.initDone ? AppBar(
                title: const Text('Online User list')) : null,
            body: body,
            floatingActionButton: screenState == ScreenState.initDone
                ? FloatingActionButton(onPressed: () async {
              await _controller.sendOffer();
              _moveToVideoView();
            }, child: const Icon(Icons.call),)
                : null
          );
        });
  }

  Widget _initDone() {
    return SafeArea(child: ValueListenableBuilder<List<String>>(
      valueListenable: _controller.userListNotifier,
      builder: (_, list, context) {
        return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              String userId = list[index];
              return ListTile(
                leading: Text('${index + 1}'),
                title: Text(
                    userId,
                    style: TextStyle(
                      color: _controller.to == userId ? Colors.red : null,
                    )
                ),
                onTap: () {
                  setState(() {
                    _controller.to = userId;
                  });
                },
              );
            });
      },

    ));
  }

  Widget _receivedCalling() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ValueListenableBuilder(valueListenable: _controller.localVideoNotifier, builder: (_, value , context) {
          return value
              ? RTCVideoView(
          _controller.localRenderer!,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          )
              : const Center(child: Icon(Icons.person_off),);
        }),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _controller.sendAnswer();
                    _moveToVideoView();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                      child: Icon(Icons.call),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    _controller.refuseOffer();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.close),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
  void _moveToVideoView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WebRTCPage(
        controller: _controller
      ))
    ).whenComplete(() {
      _controller.screenNotifier.value = ScreenState.initDone;
    });
  }
}
