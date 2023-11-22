import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';

class WebRTCSocket {
  late io.Socket _socket;
  String? user;

  /// 소켓 연결이 완료되었을때 비동기 처리를 완료할 수 있도록 completer 를 사용
  Future<String?> connectSocket() {
    final Completer<String> completer = Completer<String>();
    _socket = io.io('http://192.168.100.187:9000', io.OptionBuilder().setTransports(['websocket']).build());
    _socket.onConnect((data) {
      user = _socket.id;
      completer.complete(user);
      debugPrint("[socket] connected: $user");
    });
    return completer.future;
  }

  void socketOn(String event, void Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void socketEmit(String event, dynamic data) {
    _socket.emit(event, data);
  }

  void disconnectSocket() {
    _socket.dispose();
  }
}