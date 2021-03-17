import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }
  void _initConfig() async {
    this._socket = IO.io('http://192.168.1.5:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    // this._socket.on('nuevo-mensaje', (payload) {
    //   log('nuevo-mensaje:');
    //   log('nombre: ' + payload['nombre']);
    //   log('nombre: ' + payload['mensaje']);
    // });
  }
}
