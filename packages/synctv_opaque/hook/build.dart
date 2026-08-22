import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

const assetName = 'synctv_opaque';
const assetIdName = 'src/synctv_opaque_native.dart';

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
    } else if (code.targetOS == OS.android) {
      _configureAndroidToolchain(code, target, env);
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

void _configureAndroidToolchain(
  CodeConfig code,
  String rustTarget,
  Map<String, String> environment,
) {
  final ndkRoot = _findAndroidNdk(environment);
  final toolchainBin = _findNdkToolchainBin(ndkRoot);
  final api = code.android.targetNdkApi;
  final clangTarget = switch (code.targetArchitecture) {
    Architecture.arm64 => 'aarch64-linux-android',
    Architecture.arm => 'armv7a-linux-androideabi',
    Architecture.x64 => 'x86_64-linux-android',
    Architecture.ia32 => 'i686-linux-android',
    _ => throw UnsupportedError(
      'Unsupported Android architecture: ${code.targetArchitecture}',
    ),
  };
  final linker = _findTool(toolchainBin, '$clangTarget$api-clang');
  final archiver = _findTool(toolchainBin, 'llvm-ar');
  final cargoTarget = rustTarget.replaceAll('-', '_').toUpperCase();
  final ccTarget = rustTarget.replaceAll('-', '_');

  environment['CARGO_TARGET_${cargoTarget}_LINKER'] = linker.path;
  environment['CC_$ccTarget'] = linker.path;
  environment['AR_$ccTarget'] = archiver.path;
}

Directory _findAndroidNdk(Map<String, String> environment) {
  final candidates = <Directory>[];
  for (final name in const [
    'ANDROID_NDK_HOME',
    'ANDROID_NDK_ROOT',
    'ANDROID_NDK',
    'ANDROID_NDK_LATEST_HOME',
  ]) {
    final path = environment[name];
    if (path != null && path.isNotEmpty) candidates.add(Directory(path));
  }

  final sdkRoots = <Directory>[];
  final androidHome = environment['ANDROID_HOME'];
  if (androidHome != null && androidHome.isNotEmpty) {
    sdkRoots.add(Directory(androidHome));
  }
  final home = environment['HOME'] ?? environment['USERPROFILE'];
  if (home != null && home.isNotEmpty) {
    sdkRoots.addAll([
      Directory(_joinPath([home, 'Library', 'Android', 'sdk'])),
      Directory(_joinPath([home, 'Android', 'Sdk'])),
      Directory(_joinPath([home, 'AppData', 'Local', 'Android', 'Sdk'])),
    ]);
  }

  for (final sdkRoot in sdkRoots) {
    candidates.add(Directory(_joinPath([sdkRoot.path, 'ndk-bundle'])));
    final sideBySide = Directory(_joinPath([sdkRoot.path, 'ndk']));
    if (sideBySide.existsSync()) {
      final versions =
          sideBySide
              .listSync(followLinks: false)
              .whereType<Directory>()
              .toList()
            ..sort((left, right) => _compareNdkVersions(right, left));
      candidates.addAll(versions);
    }
  }

  for (final candidate in candidates) {
    if (_tryFindNdkToolchainBin(candidate) != null) return candidate;
  }
  throw StateError(
    'Android NDK LLVM toolchain was not found. Install the Android NDK or set '
    'ANDROID_NDK_HOME/ANDROID_HOME to its SDK location.',
  );
}

Directory _findNdkToolchainBin(Directory ndkRoot) {
  final result = _tryFindNdkToolchainBin(ndkRoot);
  if (result != null) return result;
  throw StateError(
    'Android NDK LLVM toolchain is missing under ${ndkRoot.path}.',
  );
}

Directory? _tryFindNdkToolchainBin(Directory ndkRoot) {
  final prebuilt = Directory(
    _joinPath([ndkRoot.path, 'toolchains', 'llvm', 'prebuilt']),
  );
  if (!prebuilt.existsSync()) return null;
  for (final entry in prebuilt.listSync(followLinks: false)) {
    if (entry is Directory) {
      final bin = Directory(_joinPath([entry.path, 'bin']));
      if (bin.existsSync()) return bin;
    }
  }
  return null;
}

File _findTool(Directory bin, String name) {
  for (final suffix in const ['', '.cmd', '.exe']) {
    final tool = File(_joinPath([bin.path, '$name$suffix']));
    if (tool.existsSync()) return tool;
  }
  throw StateError('Android NDK tool $name was not found in ${bin.path}.');
}

int _compareNdkVersions(Directory left, Directory right) {
  final leftVersion = _versionComponents(left);
  final rightVersion = _versionComponents(right);
  final length = leftVersion.length > rightVersion.length
      ? leftVersion.length
      : rightVersion.length;
  for (var index = 0; index < length; index++) {
    final leftPart = index < leftVersion.length ? leftVersion[index] : 0;
    final rightPart = index < rightVersion.length ? rightVersion[index] : 0;
    final comparison = leftPart.compareTo(rightPart);
    if (comparison != 0) return comparison;
  }
  return left.path.compareTo(right.path);
}

List<int> _versionComponents(Directory directory) => directory.path
    .split(Platform.pathSeparator)
    .last
    .split('.')
    .map((part) => int.tryParse(part) ?? 0)
    .toList();

String _joinPath(List<String> components) =>
    components.join(Platform.pathSeparator);

String _rustTarget(CodeConfig code) => rustTargetFor(
  code.targetOS,
  code.targetArchitecture,
  targetIOSSdk: code.targetOS == OS.iOS ? code.iOS.targetSdk : null,
);

String rustTargetFor(
  OS targetOS,
  Architecture targetArchitecture, {
  IOSSdk? targetIOSSdk,
}) {
  switch ((targetOS, targetArchitecture)) {
    case (OS.macOS, Architecture.arm64):
      return 'aarch64-apple-darwin';
    case (OS.macOS, Architecture.x64):
      return 'x86_64-apple-darwin';
    case (OS.iOS, Architecture.arm64):
      return targetIOSSdk == IOSSdk.iPhoneSimulator
          ? 'aarch64-apple-ios-sim'
          : 'aarch64-apple-ios';
    case (OS.iOS, Architecture.x64) when targetIOSSdk == IOSSdk.iPhoneSimulator:
      return 'x86_64-apple-ios';
    case (OS.linux, Architecture.x64):
      return 'x86_64-unknown-linux-gnu';
    case (OS.linux, Architecture.arm64):
      return 'aarch64-unknown-linux-gnu';
    case (OS.windows, Architecture.x64):
      return 'x86_64-pc-windows-msvc';
    case (OS.windows, Architecture.arm64):
      return 'aarch64-pc-windows-msvc';
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
        'Unsupported synctv_opaque target: $targetOS $targetArchitecture',
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
