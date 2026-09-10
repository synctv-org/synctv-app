import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/image/local_image_picker.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

import 'fixtures/image_picker_fixture.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FilePickerPlatform.instance = FixtureImagePicker(
    await createImagePickerFixture(),
  );
  runApp(
    MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const _ImageEditorShowcase(),
    ),
  );
}

class _ImageEditorShowcase extends StatefulWidget {
  const _ImageEditorShowcase();

  @override
  State<_ImageEditorShowcase> createState() => _ImageEditorShowcaseState();
}

class _ImageEditorShowcaseState extends State<_ImageEditorShowcase> {
  PickedLocalImage? _result;
  bool _opened = false;

  Future<void> _editSample({bool invalid = false, bool gif = false}) async {
    final previous = FilePickerPlatform.instance as FixtureImagePicker;
    FilePickerPlatform.instance = FixtureImagePicker(
      invalid
          ? base64Decode('AQID')
          : gif
          ? base64Decode(
              'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7',
            )
          : previous.bytes,
    );
    try {
      final result = await pickLocalImageUpload(context, aspectRatio: 16 / 9);
      if (!mounted) return;
      setState(() {
        _opened = true;
        _result = result;
      });
    } finally {
      FilePickerPlatform.instance = previous;
    }
  }

  Future<void> _reviewDelayedSelection({required bool reading}) async {
    final previous = FilePickerPlatform.instance as FixtureImagePicker;
    final gate = Completer<void>();
    FilePickerPlatform.instance = FixtureImagePicker(
      previous.bytes,
      selectionGate: reading ? null : gate.future,
      readGate: reading ? gate.future : null,
    );
    final pending = pickLocalImageUpload(context, aspectRatio: 16 / 9);
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;
    unawaited(
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Another page')),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () {
                      if (!gate.isCompleted) gate.complete();
                    },
                    child: const Text('Release pending image'),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<PickedLocalImage?>(
                    future: pending,
                    builder: (_, snapshot) => Text(
                      snapshot.connectionState != ConnectionState.done
                          ? 'Image operation pending'
                          : snapshot.data == null
                          ? 'Pending image discarded'
                          : 'Image returned',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await pending;
    FilePickerPlatform.instance = previous;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Image editor review')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        FilledButton(
          onPressed: _editSample,
          child: const Text('Edit sample image'),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => _editSample(invalid: true),
          child: const Text('Edit invalid image'),
        ),
        OutlinedButton(
          onPressed: () => _editSample(gif: true),
          child: const Text('Edit GIF image'),
        ),
        OutlinedButton(
          onPressed: () => _reviewDelayedSelection(reading: false),
          child: const Text('Select image then open another page'),
        ),
        OutlinedButton(
          onPressed: () => _reviewDelayedSelection(reading: true),
          child: const Text('Read image then open another page'),
        ),
        const SizedBox(height: 16),
        Text(
          _result == null
              ? (_opened ? 'Editor cancelled' : 'Ready to edit')
              : 'Prepared ${_result!.upload.width} x ${_result!.upload.height} · ${_result!.upload.mimeType}',
        ),
        if (_result case final result?) ...[
          const SizedBox(height: 16),
          Image.memory(result.previewBytes, height: 240, fit: BoxFit.contain),
        ],
      ],
    ),
  );
}
