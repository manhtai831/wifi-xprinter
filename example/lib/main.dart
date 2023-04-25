import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:bluetooth_print_example/order_paint.dart';
import 'package:bluetooth_x_print/bluetooth_print.dart';
import 'package:bluetooth_x_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  bool isLoading = false;
  BluetoothDevice _device;
  String tips = 'no device connect';
  Uint8List image;
  String link;
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      print('cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BluetoothXPrint example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (isLoading) CircularProgressIndicator(),
              Divider(),
              Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    OutlinedButton(
                      child: Text('print selftest'),
                      onPressed: () async {
                        isLoading = true;
                        setState(() {});
                        try {
                          Socket socket = await Socket.connect('192.168.1.222', 9100);

                          print(socket);
                          //   socket.destroy();

                          // var result = await bluetoothPrint.netConnect('192.168.1.222');
                          // print(result);
                          // bool b = result['code'] == 0;
                          // if (!b) {
                          //   isLoading = false;
                          //   setState(() {});
                          // }

                          // if (b) {
                          Map<String, dynamic> config = {};
                          config['width'] = 58;
                          config['height'] = 40;
                          // config['qty'] = 3;
                          List<LineText> list = [];
                          // list.add(LineText(type: LineText.TYPE_TEXT, content: 'Bàn 09 - Trong Nhà Text Tiếng Việt', x: 10, y: 30));
                          // list.add(LineText(type: LineText.TYPE_TEXT, content: 'Trà sữa trân trâu - M', x: 20, y: 20));
                          // list.add(LineText(type: LineText.TYPE_TEXT, content: 'Bàn 09 - Trong Nhà', x: 30, y: 30));
                          // list.add(LineText(type: LineText.TYPE_TEXT, content: 'Bàn 09 - Trong Nhà', x: 40, y: 40));
                          // list.add(LineText(type: LineText.TYPE_TEXT, content: 'Bàn 09 - Trong Nhà', x: 50, y: 50));
                          // list.add(LineText(type: LineText.TYPE_TEXT, content: 'Bàn 09 - Trong Nhà', x: 60, y: 60));
                          List<String> links = [];
                          Uint8List image = await OrderPaint()
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .drawText('Bàn 09 - Trong Nhà Dòng này dài lắm không')
                              .build();

                          final tempDir = await getTemporaryDirectory();
                          File file = await File('${tempDir.path}/image.png').create();
                          file.writeAsBytesSync(image);
                          links.add(file.path);

                          File file2 = await File('${tempDir.path}/image2.png').create();
                          file2.writeAsBytesSync(image);
                          links.add(file2.path);

                          list.add(LineText(type: LineText.TYPE_IMAGE, content: file.path, x: 10, y: 80));
                          // list.add(LineText(type: LineText.TYPE_IMAGE, content: file2.path, x: 15, y: 40));

                          // var resultOK = await bluetoothPrint.printAll(config, list);
                          // print(resultOK);
                          // var resultOK = await bluetoothPrint.printAll(
                          //     config, [LineText(type: LineText.TYPE_TEXT, content: ' file2.path file2.path file2.path file2.path', x: 0, y: 0)]);
                          var resultOk = await bluetoothPrint.getBytes(config, list);
                          for (var element in resultOk) {
                            socket.add(element);
                          }

                          print(resultOk);
                          socket.destroy();
                          // bluetoothPrint.disconnect();
                          // bluetoothPrint.netPrintTest();
                          isLoading = false;
                          setState(() {});
                        } catch (e) {
                          isLoading = false;
                          setState(() {});
                        }
                        // }
                      },
                    )
                  ],
                ),
              ),
              if (link != null) Image.file(File(link))
            ],
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: bluetoothPrint.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => bluetoothPrint.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(child: Icon(Icons.search), onPressed: () => bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }
}
