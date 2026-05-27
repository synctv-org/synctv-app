/*
 * Copyright (c) 2025 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:async';

import 'package:audio_session/src/util.dart';
import 'package:flutter/services.dart';

class OhosAudioManager {
  static const MethodChannel _channel =
      MethodChannel('com.ryanheise.ohos_audio_manager');
  static OhosAudioManager? _instance;

  OhosOnAudioDevicesChanged? _onAudioDevicesAdded;
  OhosOnAudioDevicesChanged? _onAudioDevicesRemoved;
  OhosOnAudioFocusChanged? _onAudioFocusChanged;

  factory OhosAudioManager() {
    return _instance ??= OhosAudioManager._();
  }

  void setAudioDevicesAddedListener(OhosOnAudioDevicesChanged listener) {
    _onAudioDevicesAdded = listener;
  }

  void setAudioDevicesRemovedListener(OhosOnAudioDevicesChanged listener) {
    _onAudioDevicesRemoved = listener;
  }

  OhosAudioManager._() {
    _channel.setMethodCallHandler((MethodCall call) async {
      final args = call.arguments as List<dynamic>;
      switch (call.method) {
        case 'onAudioDevicesAdded':
          if (_onAudioDevicesAdded != null) {
            _onAudioDevicesAdded!(_decodeAudioDevices(args[0]));
          }
          break;
        case 'onAudioDevicesRemoved':
          if (_onAudioDevicesRemoved != null) {
            _onAudioDevicesRemoved!(_decodeAudioDevices(args[0]));
          }
          break;
        case 'onScoAudioStateUpdated':
          break;
        case 'onAudioInterrupt':
          if (_onAudioFocusChanged != null) {
            _onAudioFocusChanged!(decodeEnum(
                AudioSessionDeactivatedReason.values, args[0] as int?,
                defaultValue:
                    AudioSessionDeactivatedReason.deactivatedLowerPriority));
          }
          break;
      }
    });
  }

  Future<bool> setInterruptionEventListener(
      OhosInterruptListernerRequest listernerRequest) async {
    _onAudioFocusChanged = listernerRequest.onAudioFocusChanged;
    return (await _channel.invokeMethod<bool>(
        'setInterruptionEventListener', [listernerRequest.toJson()]))!;
  }

  Future<bool> setActive(bool active,
          {AudioConcurrencyMode? concurrencyMode}) async =>
      (await _channel
          .invokeMethod<bool>('setActive', [active, concurrencyMode?.index]))!;

  Future<bool> isVolumeUnadjustable() async {
    return (await _channel.invokeMethod<bool>('isVolumeUnadjustable'))!;
  }

  Future<AudioRingMode> getRingerMode() async {
    return decodeEnum<AudioRingMode>(AudioRingMode.values,
        (await _channel.invokeMethod<int>('getRingerMode')),
        defaultValue: AudioRingMode.ringerModeNormal);
  }

  Future<int> getMaxVolume(AudioVolumeType streamType) async {
    return (await _channel.invokeMethod<int>(
        'getMaxVolume', streamType.value))!;
  }

  Future<int> getMinVolume(AudioVolumeType streamType) async {
    return (await _channel.invokeMethod<int>(
        'getMinVolume', streamType.value))!;
  }

  Future<int> getVolume(AudioVolumeType streamType) async {
    return (await _channel.invokeMethod<int>('getVolume', streamType.value))!;
  }

  Future<int> getSystemVolumeInDb(AudioVolumeType streamType) async {
    return (await _channel.invokeMethod<int>(
        'getSystemVolumeInDb', streamType.value))!;
  }

  Future<bool> isMute(AudioVolumeType streamType) async {
    return (await _channel.invokeMethod<bool>('isMute', streamType.value))!;
  }

  Future<List<OhosAudioDeviceDescriptor>> getDevices(DevicesFlags flags) async {
    return _decodeAudioDevices(
        (await _channel.invokeMethod<dynamic>('getDevices', [flags.value]))!);
  }

  Future<void> setSpeakerphoneOn(bool enabled) async {
    await _channel.invokeMethod('setSpeakerphoneOn', [enabled]);
  }

  Future<bool> isSpeakerphoneOn() async {
    return (await _channel.invokeMethod<bool>('isSpeakerphoneOn'))!;
  }

  Future<void> setMicrophoneMute(bool enabled) async {
    await _channel.invokeMethod<bool>('setMicrophoneMute', [enabled]);
  }

  Future<bool> isMicrophoneMute() async {
    return (await _channel.invokeMethod<bool>('isMicrophoneMute'))!;
  }

  Future<AudioScene> getAudioScene() async {
    return decodeEnum<AudioScene>(
        AudioScene.values, (await _channel.invokeMethod<int>('getAudioScene')),
        defaultValue: AudioScene.audioSceneDefault);
  }

  Future<bool> isMusicActive() async {
    return (await _channel.invokeMethod<bool>('isMusicActive'))!;
  }

  Future<void> setAudioParameter(String parameters, String value) async {
    await _channel.invokeMethod('setAudioParameter', [parameters, value]);
  }

  Future<String> getAudioParameter(String key) async {
    return (await _channel.invokeMethod<String>('getAudioParameter', [key]))!;
  }

  List<OhosAudioDeviceDescriptor> _decodeAudioDevices(dynamic rawList) {
    return (rawList as List<dynamic>).map(_decodeAudioDevice).toList();
  }

  OhosAudioDeviceDescriptor _decodeAudioDevice(dynamic raw) {
    return OhosAudioDeviceDescriptor(
        deviceRole: DeviceRoleExtension.getEnum(raw['deviceRole'] as int),
        deviceType: DeviceTypeExtension.getEnum(raw['deviceType'] as int),
        id: raw['id'] as int,
        name: raw['name'] as String,
        address: raw['address'] as String,
        sampleRates: (raw['sampleRates'] as List<dynamic>).cast<int>(),
        channelCounts: (raw['channelCounts'] as List<dynamic>).cast<int>(),
        channelMasks: (raw['channelMasks'] as List<dynamic>).cast<int>(),
        displayName: raw['displayName'] as String);
  }
}

typedef OhosOnAudioFocusChanged = void Function(
    AudioSessionDeactivatedReason focus);
typedef OhosOnAudioDevicesChanged = void Function(
    List<OhosAudioDeviceDescriptor> devices);

class OhosInterruptEvent {
  final OhosInterruptType eventType;
  final OhosInterruptForceType forceType;
  final OhosInterruptHint hintType;

  OhosInterruptEvent({
    required this.eventType,
    required this.forceType,
    required this.hintType,
  });
}

class OhosInterruptType {
  static const interruptTypeBegin = OhosInterruptType._(1);
  static const interruptTypeEnd = OhosInterruptType._(2);
  static const values = {
    1: interruptTypeBegin,
    2: interruptTypeEnd,
  };
  final int index;
  const OhosInterruptType._(this.index);
}

extension OhosInterruptTypeExtension on OhosInterruptType {
  int get value => [1, 2][index];
}

enum OhosInterruptForceType {
  interruptForce,
  interruptShare,
}

enum InterruptMode {
  shareMode,
  indepentMode,
}

enum OhosInterruptHint {
  interruptHintNone,
  interruptHintResume,
  interruptHintPause,
  interruptHintStop,
  interruptHintDuck,
  interruptHintUnduck,
}

enum AudioRingMode {
  ringerModeSilent,
  ringerModeVibrate,
  ringerModeNormal,
}

enum AudioScene {
  audioSceneDefault,
  audioSceneRinging,
  audioScenePhoneCall,
  audioSceneVoiceChat,
}

enum AudioSessionDeactivatedReason {
  deactivatedLowerPriority,
  deactivatedTimeout
}

class DevicesFlags {
  static const DevicesFlags noneDevicesFlag = DevicesFlags(0);
  static const DevicesFlags outputDevicesFlag = DevicesFlags(1);
  static const DevicesFlags inputDevicesFlag = DevicesFlags(2);
  static const DevicesFlags allDevicesFlag = DevicesFlags(3);
  static const DevicesFlags distributedOutputDevicesFlag = DevicesFlags(4);
  static const DevicesFlags distributedInputDevicesFlag = DevicesFlags(8);
  static const DevicesFlags addDistributedDevicesFlag = DevicesFlags(12);

  final int value;

  const DevicesFlags(this.value);

  DevicesFlags operator |(DevicesFlags flag) =>
      DevicesFlags(value | flag.value);

  DevicesFlags operator &(DevicesFlags flag) =>
      DevicesFlags(value & flag.value);

  bool contains(DevicesFlags flags) => flags.value & value == flags.value;

  @override
  bool operator ==(Object other) =>
      other is DevicesFlags && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class OhosAudioDeviceDescriptor {
  final DeviceRole deviceRole;
  final DeviceType deviceType;
  final int id;
  final String name;
  final String address;
  final List<int> sampleRates;
  final List<int> channelCounts;
  final List<int> channelMasks;
  final String displayName;
  final AudioEncodingType? encodingTypes;

  OhosAudioDeviceDescriptor({
    required this.deviceRole,
    required this.deviceType,
    required this.id,
    required this.name,
    required this.address,
    required this.sampleRates,
    required this.channelCounts,
    required this.channelMasks,
    required this.displayName,
    this.encodingTypes,
  });
}

class AudioEncodingType {
  static const encodingTypeInvalid = AudioEncodingType._(-1);
  static const encodingTypeRaw = AudioEncodingType._(0);
  static const values = {
    -1: encodingTypeInvalid,
    0: encodingTypeRaw,
  };
  final int value;
  const AudioEncodingType._(this.value);
  @override
  bool operator ==(Object other) =>
      other is AudioEncodingType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

enum DeviceRole {
  inputDevice,
  outputDevice,
}

extension DeviceRoleExtension on DeviceRole {
  static DeviceRole getEnum(int value) {
    switch (value) {
      case 1:
        return DeviceRole.inputDevice;
      case 2:
        return DeviceRole.outputDevice;
      default:
        return DeviceRole.inputDevice;
    }
  }
}

enum DeviceType {
  invalid,
  earpiece,
  speaker,
  wiredHeadset,
  wiredHeadphones,
  bluetoothSco,
  bluetoothA2dp,
  mic,
  usbHeadset,
  defaultDevice,
}

extension DeviceTypeExtension on DeviceType {
  int get value => [0, 1, 2, 3, 4, 7, 8, 15, 22, 1000][index];
  static DeviceType getEnum(int value) {
    switch (value) {
      case 0:
        return DeviceType.invalid;
      case 1:
        return DeviceType.earpiece;
      case 2:
        return DeviceType.speaker;
      case 3:
        return DeviceType.wiredHeadset;
      case 4:
        return DeviceType.wiredHeadphones;
      case 7:
        return DeviceType.bluetoothSco;
      case 8:
        return DeviceType.bluetoothA2dp;
      case 15:
        return DeviceType.mic;
      case 22:
        return DeviceType.usbHeadset;
      case 1000:
        return DeviceType.defaultDevice;
      default:
        return DeviceType.defaultDevice;
    }
  }
}

enum AudioVolumeType {
  voiceCall,
  ringTone,
  media,
  alarm,
  accessibility,
  voiceAssistant,
  ultraSonic,
  all
}

extension AudioVolumeTypeExtension on AudioVolumeType {
  int get value => [0, 2, 3, 4, 5, 9, 10, 100][index];
}

class OhosAudioAttributes {
  final StreamUsage streamUsage;
  final AudioSamplingRate samplingRate;
  final AudioChannel channels;
  final AudioSampleFormat sampleFormat;
  final AudioEncodingType encodingType;

  const OhosAudioAttributes({
    this.streamUsage = StreamUsage.unknown,
    this.samplingRate = AudioSamplingRate.sampleRate48000,
    this.channels = AudioChannel.channel2,
    this.sampleFormat = AudioSampleFormat.sampleFormatS16LE,
    this.encodingType = AudioEncodingType.encodingTypeRaw,
  });

  OhosAudioAttributes.fromJson(Map<String, dynamic> data)
      : this(
            streamUsage: decodeMapEnum(
                StreamUsage.values, data['streamUsage'] as int?,
                defaultValue: StreamUsage.unknown),
            samplingRate: decodeMapEnum(
                AudioSamplingRate.values, data['samplingRate'] as int?,
                defaultValue: AudioSamplingRate.sampleRate48000),
            channels: decodeMapEnum(
                AudioChannel.values, data['channels'] as int?,
                defaultValue: AudioChannel.channel2),
            sampleFormat: decodeMapEnum(
                AudioSampleFormat.values, data['sampleFormat'] as int?,
                defaultValue: AudioSampleFormat.sampleFormatS16LE),
            encodingType: decodeMapEnum(
                AudioEncodingType.values, data['encodingType'] as int?,
                defaultValue: AudioEncodingType.encodingTypeRaw));

  Map<String, dynamic> toJson() => {
        'streamUsage': streamUsage.value,
        'samplingRate': samplingRate.value,
        'channels': channels.value,
        'sampleFormat': sampleFormat.value,
        'encodingType': encodingType.value,
      };
}

class StreamUsage {
  static const unknown = StreamUsage._(0);
  static const music = StreamUsage._(1);
  static const voiceCommunication = StreamUsage._(2);
  static const voiceAssistant = StreamUsage._(3);
  static const alarm = StreamUsage._(4);
  static const voiceMessage = StreamUsage._(5);
  static const ringTone = StreamUsage._(6);
  static const notification = StreamUsage._(7);
  static const accessibility = StreamUsage._(8);
  static const movie = StreamUsage._(10);
  static const game = StreamUsage._(11);
  static const audioBook = StreamUsage._(12);
  static const navigation = StreamUsage._(13);
  static const values = {
    0: unknown,
    1: music,
    2: voiceCommunication,
    3: voiceAssistant,
    4: alarm,
    5: voiceMessage,
    6: ringTone,
    7: notification,
    8: accessibility,
    10: movie,
    11: game,
    12: audioBook,
    13: navigation,
  };
  final int value;
  const StreamUsage._(this.value);
  @override
  bool operator ==(Object other) =>
      other is StreamUsage && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class OhosInterruptListernerRequest {
  final OhosAudioAttributes? audioAttributes;
  final OhosOnAudioFocusChanged onAudioFocusChanged;
  final bool isOnListener;

  const OhosInterruptListernerRequest({
    this.audioAttributes,
    required this.onAudioFocusChanged,
    required this.isOnListener,
  });
  Map<String, dynamic> toJson() => {
        'audioAttributes': audioAttributes?.toJson(),
        'isOnListener': isOnListener,
      };
}

class AudioSamplingRate {
  static const sampleRate8000 = AudioSamplingRate._(8000);
  static const sampleRate11025 = AudioSamplingRate._(11024);
  static const sampleRate12000 = AudioSamplingRate._(12000);
  static const sampleRate16000 = AudioSamplingRate._(16000);
  static const sampleRate22050 = AudioSamplingRate._(22050);
  static const sampleRate24000 = AudioSamplingRate._(24000);
  static const sampleRate32000 = AudioSamplingRate._(32000);
  static const sampleRate44100 = AudioSamplingRate._(44100);
  static const sampleRate48000 = AudioSamplingRate._(48000);
  static const sampleRate64000 = AudioSamplingRate._(64000);
  static const sampleRate96000 = AudioSamplingRate._(96000);

  static const values = {
    8000: sampleRate8000,
    11024: sampleRate11025,
    12000: sampleRate12000,
    16000: sampleRate16000,
    22050: sampleRate22050,
    24000: sampleRate24000,
    32000: sampleRate32000,
    44100: sampleRate44100,
    48000: sampleRate48000,
    64000: sampleRate64000,
    96000: sampleRate96000,
  };
  final int value;
  const AudioSamplingRate._(this.value);
  @override
  bool operator ==(Object other) =>
      other is AudioSamplingRate && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class AudioChannel {
  static const channel1 = AudioChannel._(1);
  static const channel2 = AudioChannel._(2);
  static const channel3 = AudioChannel._(3);
  static const channel4 = AudioChannel._(4);
  static const channel5 = AudioChannel._(5);
  static const channel6 = AudioChannel._(6);
  static const channel7 = AudioChannel._(7);
  static const channel8 = AudioChannel._(8);
  static const channel9 = AudioChannel._(9);
  static const channel10 = AudioChannel._(10);
  static const channel11 = AudioChannel._(11);
  static const channel12 = AudioChannel._(12);
  static const channel13 = AudioChannel._(13);
  static const channel14 = AudioChannel._(14);
  static const channel15 = AudioChannel._(15);
  static const channel16 = AudioChannel._(16);
  static const values = {
    1: channel1,
    2: channel2,
    3: channel3,
    4: channel4,
    5: channel5,
    6: channel6,
    7: channel7,
    8: channel8,
    9: channel9,
    10: channel10,
    11: channel11,
    12: channel12,
    13: channel13,
    14: channel14,
    15: channel15,
    16: channel16,
  };
  final int value;
  const AudioChannel._(this.value);

  @override
  bool operator ==(Object other) =>
      other is AudioChannel && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class AudioSampleFormat {
  static const sampleFormatInvalid = AudioSampleFormat._(-1);
  static const sampleFormatU8 = AudioSampleFormat._(0);
  static const sampleFormatS16LE = AudioSampleFormat._(1);
  static const sampleFormatS24LE = AudioSampleFormat._(2);
  static const sampleFormatS32LE = AudioSampleFormat._(3);
  static const sampleFormatF32LE = AudioSampleFormat._(4);
  static const values = {
    -1: sampleFormatInvalid,
    0: sampleFormatU8,
    1: sampleFormatS16LE,
    2: sampleFormatS24LE,
    3: sampleFormatS32LE,
    4: sampleFormatF32LE,
  };
  final int value;
  const AudioSampleFormat._(this.value);
  @override
  bool operator ==(Object other) =>
      other is AudioSampleFormat && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

enum AudioConcurrencyMode {
  concurrencyDefault,
  concurrencyMixWithOthers,
  concurrencyDuckOthers,
  concurrencyPauseOthers,
}
