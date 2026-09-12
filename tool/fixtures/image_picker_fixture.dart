import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';

Future<Uint8List> createImagePickerFixture() async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  canvas.drawPaint(ui.Paint()..color = const ui.Color(0xff244477));
  canvas.drawRect(
    const ui.Rect.fromLTWH(80, 40, 240, 280),
    ui.Paint()..color = const ui.Color(0xff73daca),
  );
  canvas.drawCircle(
    const ui.Offset(440, 180),
    100,
    ui.Paint()..color = const ui.Color(0xffffcb6b),
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(640, 360);
  try {
    return (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer
        .asUint8List();
  } finally {
    image.dispose();
    picture.dispose();
  }
}

class FixtureImagePicker extends FilePickerPlatform {
  FixtureImagePicker(this.bytes, {this.selectionGate, this.readGate});

  final Uint8List bytes;
  final Future<void>? selectionGate;
  final Future<void>? readGate;

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    await selectionGate;
    return _FixtureImageFile(bytes, readGate);
  }
}

final class _FixtureImageFile extends PlatformFile {
  _FixtureImageFile(this.bytes, this.readGate);

  final Uint8List bytes;
  final Future<void>? readGate;

  @override
  String get name => 'crop-sample.png';

  @override
  Uri get uri => Uri.parse('memory:crop-sample.png');

  @override
  int lengthSync() => bytes.length;

  @override
  Future<int> length() async => bytes.length;

  @override
  Future<Uint8List> readAsBytes() async {
    await readGate;
    return bytes;
  }

  @override
  Stream<Uint8List> readAsByteStream() => Stream.value(bytes);

  // The editor consumes name and bytes; unsupported platform APIs fail loudly.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
