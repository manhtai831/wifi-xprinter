import 'package:json_annotation/json_annotation.dart';

part 'bluetooth_print_model.g.dart';

@JsonSerializable(includeIfNull: false)
class BluetoothDevice {
  BluetoothDevice();

  String? name;
  String? address;
  int? type = 0;
  bool? connected = false;

  factory BluetoothDevice.fromJson(Map<String, dynamic> json) =>
      _$BluetoothDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$BluetoothDeviceToJson(this);
}

@JsonSerializable(includeIfNull: false)
class LineText {
  LineText(
      {this.type, //text,barcode,qrcode,image(base64 string)
        this.content,
        this.size = 0,
        this.align = ALIGN_LEFT,
        this.weight = 0, //0,1
        this.width = 0, //0,1
        this.height = 0, //0,1
        this.underline = 0, //0,1
        this.linefeed = 0, //0,1
        this.x = 0,
        this.y = 0,
        this.font_type = "0",
        this.rotation = 0,
        this.x_multification = 1,
        this.y_multification = 1});

  static const String TYPE_TEXT = 'text';
  static const String TYPE_BARCODE = 'barcode';
  static const String TYPE_QRCODE = 'qrcode';
  static const String TYPE_IMAGE = 'image';
    static const String TYPE_CUT = 'cut';
  static const String TYPE_SELF_TEST = 'selfTest';
  static const String TYPE_SOUND = 'sound';
  static const int ALIGN_LEFT = 0;
  static const int ALIGN_CENTER = 1;
  static const int ALIGN_RIGHT = 2;

  final String? type;
  final String? content;
  final int? size;
  final int? align;
  final int? weight;
  final int? width;
  final int? height;
  final int? underline;
  final int? linefeed;
  final int? x;
  final int? y;
  final String? font_type;
  final int? rotation;
  final int? x_multification;
  final int? y_multification;

  factory LineText.fromJson(Map<String, dynamic> json) =>
      _$LineTextFromJson(json);
  Map<String, dynamic> toJson() => _$LineTextToJson(this);
}
