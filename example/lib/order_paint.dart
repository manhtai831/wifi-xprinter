import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderPaint implements OrderPaintBuilder {
  final ui.PictureRecorder _recorder = ui.PictureRecorder();
  final Paint _paint = Paint();

  double _maxWidth = 400;
  double _minWidth = 400;
  final double _qWidth = 50;
  final double _tWidth = 100;
  double _height = 0;
  double _fontSize = 20;
  FontWeight _fontWeight = FontWeight.w400;

 Canvas canvas;
  String _fontFamily;
  TextSpan span = const TextSpan();
  TextPainter _tp = TextPainter();

  OrderPaint({double width}) {
    if (width != null) {
      _minWidth = width;
      _maxWidth = width;
    }
    canvas = Canvas(_recorder, Rect.fromCenter(center: const Offset(0, 0), width: _minWidth, height: 400));
    canvas.drawColor(Colors.white, BlendMode.src);
  }

  @override
  OrderPaintBuilder incrementHeight({double h}) {
    _height = _height + (h ?? _tp.height);
    return this;
  }

  @override
  OrderPaintBuilder drawBox({double width, double height = 0, Color color}) {
    if (color != null) _paint.color = color;
    canvas.drawRect(Rect.fromLTWH(0, _height, width ?? 0, height), _paint);
    incrementHeight(h: height);
    return this;
  }

  @override
  OrderPaintBuilder drawText(
    String text, {
    BoxConstraints layout,
    double dX,
    double fontSize,
    FontWeight fontWeight,
    TextAlign align = TextAlign.start,
    int maxLines,
    bool isNextLine = true,
  }) {
    span = TextSpan(
        style: TextStyle(color: Colors.black, fontSize: fontSize ?? _fontSize, fontWeight: fontWeight ?? _fontWeight, fontFamily: _fontFamily),
        text: text);

    _tp = TextPainter(text: span, textAlign: align, maxLines: maxLines, textDirection: TextDirection.ltr);
    _tp.layout(minWidth: layout?.maxWidth ?? _minWidth, maxWidth: layout?.maxWidth ?? _maxWidth);
    _tp.paint(canvas, Offset(dX ?? 0.0, _height));
    if (isNextLine) incrementHeight();
    return this;
  }

  @override
  OrderPaintBuilder drawSeparate({String charset, bool isBold = false}) {
    FontWeight fontWeight = isBold ? FontWeight.w700 : FontWeight.normal;
    drawText((charset ?? '=') * 90, maxLines: 1, fontWeight: fontWeight);
    return this;
  }


  @override
  OrderPaintBuilder drawBoldText({String title, String value, bool isBold = false}) {
    FontWeight fontWeight = isBold ? FontWeight.w700 : _fontWeight;
    drawText(title, fontWeight: fontWeight, fontSize: isBold ? _fontSize + 4 : _fontSize, isNextLine: false);
    drawText(value, fontWeight: fontWeight, fontSize: isBold ? _fontSize + 4 : _fontSize, align: TextAlign.end);
    return this;
  }

  @override
  Future<Uint8List> build() {
    Map<String, dynamic> data = {'recorder': _recorder, 'maxWidth': _maxWidth, 'height': _height};
    return _completeImageHandle(data);
  }

  @override
  OrderPaintBuilder setFontFamily(String fontFamily) {
    _fontFamily = fontFamily;
    return this;
  }

  @override
  OrderPaintBuilder setDefaultFontSize(double fontSize) {
    if (fontSize != null) _fontSize = fontSize;
    return this;
  }

  @override
  OrderPaintBuilder setDefaultFontWeight(ui.FontWeight fontWeight) {
    if (fontWeight != null) _fontWeight = fontWeight;
    return this;
  }

  @override
  OrderPaintBuilder drawImage({ui.Image image}) {
    if (image != null) {
      canvas.drawImage(image, Offset((_maxWidth / 2) - (image.width / 2), _height), _paint);
      incrementHeight(h: image.height.toDouble());
    }

    return this;
  }
}

Future<Uint8List> _completeImageHandle(Map<String, dynamic> data) async {
  ui.PictureRecorder recorder = data['recorder'];
  double maxWidth = data['maxWidth'];
  double height = data['height'];

  final picture = recorder.endRecording();

  ui.Image img = await picture.toImage(maxWidth.toInt(), height.toInt());
  print('img.height: ${img.height}');
  final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

  return pngBytes.buffer.asUint8List(pngBytes.offsetInBytes, pngBytes.lengthInBytes);
}

abstract class OrderPaintBuilder {
  OrderPaintBuilder drawBoldText({String title, String value, bool isBold = false});


  OrderPaintBuilder drawSeparate({String charset, bool isBold = false});

  OrderPaintBuilder drawText(
    String text, {
    BoxConstraints layout,
    double dX,
    double fontSize = 20,
    FontWeight fontWeight,
    TextAlign align = TextAlign.start,
    int maxLines,
    bool isNextLine = true,
  });

  OrderPaintBuilder drawImage({ui.Image image});

  OrderPaintBuilder drawBox({double width, double height = 0, Color color});

  OrderPaintBuilder incrementHeight({double h});

  OrderPaintBuilder setFontFamily(String fontFamily);

  OrderPaintBuilder setDefaultFontSize(double fontSize);

  OrderPaintBuilder setDefaultFontWeight(FontWeight fontWeight);

  Future<Uint8List> build();
}
