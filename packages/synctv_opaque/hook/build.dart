import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

const assetName = 'synctv_opaque';
const assetIdName = 'synctv_opaque.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    final code = input.config.code;
    if (code.linkModePreference == LinkModePreference.static) {
      throw UnsupportedError(
        'Static linking is not supported for synctv_opaque.',
      );
    }

    final target = _rustTarget(code);
    final extension = _libraryExtension(code.targetOS);
    final sourceDir = input.packageRoot.toFilePath();
    final buildDir = input.outputDirectory.resolve('cargo/').toFilePath();
    final cargoArgs = <String>[
      'build',
      '--release',
      '--target',
      target,
      '--target-dir',
      buildDir,
    ];

    final env = Map<String, String>.from(Platform.environment);
    if (code.targetOS == OS.iOS) {
      env['IPHONEOS_DEPLOYMENT_TARGET'] = code.iOS.targetVersion.toString();
      env.remove('MACOSX_DEPLOYMENT_TARGET');
    } else if (code.targetOS == OS.macOS) {
      env['MACOSX_DEPLOYMENT_TARGET'] = code.macOS.targetVersion.toString();
      env.remove('IPHONEOS_DEPLOYMENT_TARGET');
    }

    final result = await Process.run(
      'cargo',
      cargoArgs,
      workingDirectory: sourceDir,
      environment: env,
    );
    if (result.exitCode != 0) {
      stderr.writeln(result.stdout);
      stderr.writeln(result.stderr);
      throw Exception('cargo ${cargoArgs.join(' ')} failed');
    }

    final builtFile = File(
      '$buildDir/$target/release/${_libraryPrefix(code.targetOS)}$assetName.$extension',
    );
    if (!builtFile.existsSync()) {
      throw StateError(
        'Expected native library was not produced: ${builtFile.path}',
      );
    }

    final outputFile = File.fromUri(
      input.outputDirectory.resolve(
        '${_libraryPrefix(code.targetOS)}$assetName.$extension',
      ),
    );
    outputFile.parent.createSync(recursive: true);
    builtFile.copySync(outputFile.path);

    output.dependencies.addAll(
      [
        input.packageRoot.resolve('Cargo.toml'),
        input.packageRoot.resolve('Cargo.lock'),
        input.packageRoot.resolve('src/lib.rs'),
      ].where((uri) => File.fromUri(uri).existsSync()),
    );
    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: assetIdName,
        file: outputFile.uri,
        linkMode: DynamicLoadingBundled(),
      ),
    );
  });
}

String _rustTarget(CodeConfig code) {
  switch ((code.targetOS, code.targetArchitecture)) {
    case (OS.macOS, Architecture.arm64):
      return 'aarch64-apple-darwin';
    case (OS.macOS, Architecture.x64):
      return 'x86_64-apple-darwin';
    case (OS.iOS, Architecture.arm64):
      return 'aarch64-apple-ios';
    case (OS.linux, Architecture.x64):
      return 'x86_64-unknown-linux-gnu';
    case (OS.linux, Architecture.arm64):
      return 'aarch64-unknown-linux-gnu';
    case (OS.windows, Architecture.x64):
      return 'x86_64-pc-windows-msvc';
    case (OS.android, Architecture.arm64):
      return 'aarch64-linux-android';
    case (OS.android, Architecture.arm):
      return 'armv7-linux-androideabi';
    case (OS.android, Architecture.x64):
      return 'x86_64-linux-android';
    case (OS.android, Architecture.ia32):
      return 'i686-linux-android';
    default:
      throw UnsupportedError(
        'Unsupported synctv_opaque target: ${code.targetOS} ${code.targetArchitecture}',
      );
  }
}

String _libraryExtension(OS os) {
  return switch (os) {
    OS.macOS || OS.iOS => 'dylib',
    OS.windows => 'dll',
    _ => 'so',
  };
}

String _libraryPrefix(OS os) {
  return os == OS.windows ? '' : 'lib';
}
