> Template version: v0.0.1

<p align="center">
  <h1 align="center"> <code>audio_session</code> </h1>
</p>

This project is based on [audio_session](https://pub.dev/packages/audio_session).

## 1. Installation and Usage

### 1.1 Installation

Go to the project directory and add the following dependencies in pubspec.yaml

<!-- tabs:start -->

#### pubspec.yaml

```yaml
---
dependencies:
  audio_session:
    git:
      url: https://gitcode.com/openharmony-sig/flutter_audio_session.git
```

Execute Command

```bash
flutter pub get
```

<!-- tabs:end -->

### 1.2 Usage

For use cases [ohos/example](./example/lib/main.dart)

## 2. Constraints

### 2.1 Compatibility

This document is verified based on the following versions:

1. Flutter: 3.27.5-ohos-0.0.1; SDK: 5.0.0(12); IDE: DevEco Studio: 5.1.0.828; ROM: 5.1.0.130 SP8;

## 3. API

> [!TIP] If the value of **ohos Support** is **yes**, it means that the ohos platform supports this property; **no** means the opposite; **partially** means some capabilities of this property are supported. The usage method is the same on different platforms and the effect is the same as that of iOS or Android.

### OhosAudioManager API

| Name                           | Description                                              | Type     | Input                                                    | Output                                    | ohos Support |
| ------------------------------ | -------------------------------------------------------- | -------- | -------------------------------------------------------- | ----------------------------------------- | ------------ |
| setAudioDevicesAddedListener   | Sets a listener for audio devices added                  | function | `OhosOnAudioDevicesChanged` listener                     | /                                         | yes          |
| setAudioDevicesRemovedListener | Sets a listener for audio devices removed                | function | `OhosOnAudioDevicesChanged` listener                     | /                                         | yes          |
| setInterruptionEventListener   | Sets a listener for interruption events                  | function | `OhosInterruptListernerRequest` listernerRequest         | /                                         | yes          |
| setActive                      | Sets whether the audio session is active                 | function | `bool` active, {`AudioConcurrencyMode?` concurrencyMode} | `Future<bool>`                            | yes          |
| isVolumeUnadjustable           | Checks if the volume is unadjustable                     | function | /                                                        | `Future<bool>`                            | yes          |
| getRingerMode                  | Gets the ringer mode                                     | function | /                                                        | `Future<AudioRingMode>`                   | yes          |
| getMaxVolume                   | Gets the maximum system volume for specified stream type | function | `AudioVolumeType` streamType                             | `Future<int>`                             | yes          |
| getMinVolume                   | Gets the minimum system volume for specified stream type | function | `AudioVolumeType` streamType                             | `Future<int>`                             | yes          |
| getVolume                      | Gets current system volume for specified stream type     | function | `AudioVolumeType` streamType                             | `Future<int>`                             | yes          |
| getSystemVolumeInDb            | Gets system volume in decibels for stream type           | function | `AudioVolumeType` streamType                             | `Future<int>`                             | yes          |
| isMute                         | Checks if specified stream type is muted                 | function | `AudioVolumeType` streamType                             | `Future<bool>`                            | yes          |
| getDevices                     | Gets all audio devices                                   | function | `DevicesFlags` flags                                     | `Future<List<OhosAudioDeviceDescriptor>>` | yes          |
| setSpeakerphoneOn              | Sets whether speakerphone is on                          | function | `bool` enabled                                           | `Future<void>`                            | yes          |
| isSpeakerphoneOn               | Checks if speakerphone is on                             | function | /                                                        | `Future<bool>`                            | yes          |
| setMicrophoneMute              | Sets whether microphone is muted                         | function | `bool` enabled                                           | `Future<void>`                            | yes          |
| isMicrophoneMute               | Checks if microphone is muted                            | function | /                                                        | `Future<bool>`                            | yes          |
| getAudioScene                  | Gets current audio scene                                 | function | /                                                        | `Future<AudioScene>`                      | yes          |
| isMusicActive                  | Checks if music is currently playing                     | function | /                                                        | `Future<bool>`                            | yes          |
| setAudioParameter              | Sets audio parameters                                    | function | `String` parameters, `String` value                      | `Future<void>`                            | yes          |
| getAudioParameter              | Gets audio parameters                                    | function | `String` key                                             | `Future<String>`                          | yes          |

### OhosInterruptEvent API

| Name      | Description             | Type | Input | Output | ohos Support |
| --------- | ----------------------- | ---- | ----- | ------ | ------------ |
| eventType | Type of interrupt event | enum | /     | /      | yes          |
| forceType | Type of interrupt force | enum | /     | /      | yes          |
| hintType  | Type of interrupt hint  | enum | /     | /      | yes          |

### OhosInterruptType API

| Name               | Description          | Type | Input | Output | ohos Support |
| ------------------ | -------------------- | ---- | ----- | ------ | ------------ |
| interruptTypeBegin | Begins the interrupt | enum | /     | /      | yes          |
| interruptTypeEnd   | Ends the interrupt   | enum | /     | /      | yes          |

### OhosInterruptForceType API

| Name           | Description        | Type | Input | Output | ohos Support |
| -------------- | ------------------ | ---- | ----- | ------ | ------------ |
| interruptForce | Forceful interrupt | enum | /     | /      | yes          |
| interruptShare | Shared interrupt   | enum | /     | /      | yes          |

### OhosInterruptHint API

| Name                | Description | Type | Input | Output | ohos Support |
| ------------------- | ----------- | ---- | ----- | ------ | ------------ |
| interruptHintNone   | No hint     | enum | /     | /      | yes          |
| interruptHintResume | Resume hint | enum | /     | /      | yes          |
| interruptHintPause  | Pause hint  | enum | /     | /      | yes          |
| interruptHintStop   | Stop hint   | enum | /     | /      | yes          |
| interruptHintDuck   | Duck hint   | enum | /     | /      | yes          |
| interruptHintUnduck | Unduck hint | enum | /     | /      | yes          |

### AudioRingMode API

| Name              | Description         | Type | Input | Output | ohos Support |
| ----------------- | ------------------- | ---- | ----- | ------ | ------------ |
| ringerModeSilent  | Silent ringer mode  | enum | /     | /      | yes          |
| ringerModeVibrate | Vibrate ringer mode | enum | /     | /      | yes          |
| ringerModeNormal  | Normal ringer mode  | enum | /     | /      | yes          |

### AudioScene API

| Name                | Description            | Type | Input | Output | ohos Support |
| ------------------- | ---------------------- | ---- | ----- | ------ | ------------ |
| audioSceneDefault   | Default audio scene    | enum | /     | /      | yes          |
| audioSceneRinging   | Ringing audio scene    | enum | /     | /      | yes          |
| audioScenePhoneCall | Phone call audio scene | enum | /     | /      | yes          |
| audioSceneVoiceChat | Voice chat audio scene | enum | /     | /      | yes          |

### AudioSessionDeactivatedReason API

| Name                     | Description                       | Type | Input | Output | ohos Support |
| ------------------------ | --------------------------------- | ---- | ----- | ------ | ------------ |
| deactivatedLowerPriority | Deactivated due to lower priority | enum | /     | /      | yes          |
| deactivatedTimeout       | Deactivated due to timeout        | enum | /     | /      | yes          |

### OhosAudioDeviceDescriptor API

| Name          | Description                      | Type              | Input | Output | ohos Support |
| ------------- | -------------------------------- | ----------------- | ----- | ------ | ------------ |
| deviceRole    | Device role                      | DeviceRole        | /     | /      | yes          |
| deviceType    | Device type                      | DeviceType        | /     | /      | yes          |
| id            | Device ID                        | int               | /     | /      | yes          |
| name          | Device name                      | String            | /     | /      | yes          |
| address       | Device address                   | String            | /     | /      | yes          |
| sampleRates   | List of supported sample rates   | List<int>         | /     | /      | yes          |
| channelCounts | List of supported channel counts | List<int>         | /     | /      | yes          |
| channelMasks  | List of supported channel masks  | List<int>         | /     | /      | yes          |
| displayName   | Display name                     | String            | /     | /      | yes          |
| encodingTypes | Supported encoding types         | AudioEncodingType | /     | /      | yes          |

### AudioEncodingType API

| Name                | Description           | Type | Input | Output | ohos Support |
| ------------------- | --------------------- | ---- | ----- | ------ | ------------ |
| encodingTypeInvalid | Invalid encoding type | enum | /     | /      | yes          |
| encodingTypeRaw     | Raw encoding type     | enum | /     | /      | yes          |

### DeviceRole API

| Name         | Description   | Type | Input | Output | ohos Support |
| ------------ | ------------- | ---- | ----- | ------ | ------------ |
| inputDevice  | Input device  | enum | /     | /      | yes          |
| outputDevice | Output device | enum | /     | /      | yes          |

### DeviceType API

| Name            | Description                      | Type | Input | Output | ohos Support |
| --------------- | -------------------------------- | ---- | ----- | ------ | ------------ |
| invalid         | Invalid device                   | enum | /     | /      | yes          |
| earpiece        | Earpiece                         | enum | /     | /      | yes          |
| speaker         | Speaker                          | enum | /     | /      | yes          |
| wiredHeadset    | Wired headset                    | enum | /     | /      | yes          |
| wiredHeadphones | Wired headphones with microphone | enum | /     | /      | yes          |
| bluetoothSco    | Bluetooth SCO connection         | enum | /     | /      | yes          |
| bluetoothA2dp   | Bluetooth A2DP connection        | enum | /     | /      | yes          |
| mic             | Microphone                       | enum | /     | /      | yes          |
| usbHeadset      | USB headset                      | enum | /     | /      | yes          |
| defaultDevice   | Default device                   | enum | /     | /      | yes          |

### AudioVolumeType API

| Name           | Description     | Type | Input | Output | ohos Support |
| -------------- | --------------- | ---- | ----- | ------ | ------------ |
| voiceCall      | Voice call      | enum | /     | /      | yes          |
| ringTone       | Ringtone        | enum | /     | /      | yes          |
| media          | Media           | enum | /     | /      | yes          |
| alarm          | Alarm           | enum | /     | /      | yes          |
| accessibility  | Accessibility   | enum | /     | /      | yes          |
| voiceAssistant | Voice assistant | enum | /     | /      | yes          |
| ultraSonic     | Ultrasound      | enum | /     | /      | yes          |
| all            | All             | enum | /     | /      | yes          |

### OhosAudioAttributes API

| Name         | Description   | Type              | Input | Output | ohos Support |
| ------------ | ------------- | ----------------- | ----- | ------ | ------------ |
| streamUsage  | Stream usage  | StreamUsage       | /     | /      | yes          |
| samplingRate | Sampling rate | AudioSamplingRate | /     | /      | yes          |
| channels     | Channels      | AudioChannel      | /     | /      | yes          |
| sampleFormat | Sample format | AudioSampleFormat | /     | /      | yes          |
| encodingType | Encoding type | AudioEncodingType | /     | /      | yes          |

### StreamUsage API

| Name               | Description         | Type | Input | Output | ohos Support |
| ------------------ | ------------------- | ---- | ----- | ------ | ------------ |
| unknown            | Unknown usage       | enum | /     | /      | yes          |
| music              | Music               | enum | /     | /      | yes          |
| voiceCommunication | Voice communication | enum | /     | /      | yes          |
| voiceAssistant     | Voice assistant     | enum | /     | /      | yes          |
| alarm              | Alarm               | enum | /     | /      | yes          |
| voiceMessage       | Voice message       | enum | /     | /      | yes          |
| ringTone           | Ringtone            | enum | /     | /      | yes          |
| notification       | Notification        | enum | /     | /      | yes          |
| accessibility      | Accessibility       | enum | /     | /      | yes          |
| movie              | Movie               | enum | /     | /      | yes          |
| game               | Game                | enum | /     | /      | yes          |
| audioBook          | Audiobook           | enum | /     | /      | yes          |
| navigation         | Navigation          | enum | /     | /      | yes          |

### OhosInterruptListernerRequest API

| Name                | Description                      | Type                | Input | Output | ohos Support |
| ------------------- | -------------------------------- | ------------------- | ----- | ------ | ------------ |
| audioAttributes     | Audio attributes                 | OhosAudioAttributes | /     | /      | yes          |
| onAudioFocusChanged | Callback for audio focus changes | function            | /     | /      | yes          |
| isOnListener        | Whether the listener is on       | bool                | /     | /      | yes          |

### AudioSamplingRate API

| Name            | Description           | Type | Input | Output | ohos Support |
| --------------- | --------------------- | ---- | ----- | ------ | ------------ |
| sampleRate8000  | 8000Hz sampling rate  | enum | /     | /      | yes          |
| sampleRate11025 | 11025Hz sampling rate | enum | /     | /      | yes          |
| sampleRate12000 | 12000Hz sampling rate | enum | /     | /      | yes          |
| sampleRate16000 | 16000Hz sampling rate | enum | /     | /      | yes          |
| sampleRate22050 | 22050Hz sampling rate | enum | /     | /      | yes          |
| sampleRate24000 | 24000Hz sampling rate | enum | /     | /      | yes          |
| sampleRate32000 | 32000Hz sampling rate | enum | /     | /      | yes          |
| sampleRate44100 | 44100Hz sampling rate | enum | /     | /      | yes          |
| sampleRate48000 | 48000Hz sampling rate | enum | /     | /      | yes          |
| sampleRate64000 | 64000Hz sampling rate | enum | /     | /      | yes          |
| sampleRate96000 | 96000Hz sampling rate | enum | /     | /      | yes          |

### AudioChannel API

| Name      | Description    | Type | Input | Output | ohos Support |
| --------- | -------------- | ---- | ----- | ------ | ------------ |
| channel1  | Mono channel   | enum | /     | /      | yes          |
| channel2  | Stereo channel | enum | /     | /      | yes          |
| channel3  | 3-channel      | enum | /     | /      | yes          |
| channel4  | 4-channel      | enum | /     | /      | yes          |
| channel5  | 5-channel      | enum | /     | /      | yes          |
| channel6  | 6-channel      | enum | /     | /      | yes          |
| channel7  | 7-channel      | enum | /     | /      | yes          |
| channel8  | 8-channel      | enum | /     | /      | yes          |
| channel9  | 9-channel      | enum | /     | /      | yes          |
| channel10 | 10-channel     | enum | /     | /      | yes          |
| channel11 | 11-channel     | enum | /     | /      | yes          |
| channel12 | 12-channel     | enum | /     | /      | yes          |
| channel13 | 13-channel     | enum | /     | /      | yes          |
| channel14 | 14-channel     | enum | /     | /      | yes          |
| channel15 | 15-channel     | enum | /     | /      | yes          |
| channel16 | 16-channel     | enum | /     | /      | yes          |

### AudioSampleFormat API

| Name                | Description                         | Type | Input | Output | ohos Support |
| ------------------- | ----------------------------------- | ---- | ----- | ------ | ------------ |
| sampleFormatInvalid | Invalid format                      | enum | /     | /      | yes          |
| sampleFormatU8      | 8-bit unsigned integer              | enum | /     | /      | yes          |
| sampleFormatS16LE   | 16-bit signed integer little endian | enum | /     | /      | yes          |
| sampleFormatS24LE   | 24-bit signed integer little endian | enum | /     | /      | yes          |
| sampleFormatS32LE   | 32-bit signed integer little endian | enum | /     | /      | yes          |
| sampleFormatF32LE   | 32-bit floating point little endian | enum | /     | /      | yes          |

### AudioConcurrencyMode API

| Name                     | Description              | Type | Input | Output | ohos Support |
| ------------------------ | ------------------------ | ---- | ----- | ------ | ------------ |
| concurrencyDefault       | Default concurrency mode | enum | /     | /      | yes          |
| concurrencyMixWithOthers | Mix with others          | enum | /     | /      | yes          |
| concurrencyDuckOthers    | Duck others              | enum | /     | /      | yes          |
| concurrencyPauseOthers   | Pause others             | enum | /     | /      | yes          |

## 4. Known Issues

## 5. Others

## 6. License

This project is licensed under [The MIT License (MIT)](./LICENSE).
