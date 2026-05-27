> 模板版本: v0.0.1

<p align="center">
  <h1 align="center"> <code>audio_session</code> </h1>
</p>

本项目基于 [audio_session](https://pub.dev/packages/audio_session) 开发。

## 1. 安装与使用

### 1.1 安装方式

进入到工程目录并在 pubspec.yaml 中添加以下依赖：

<!-- tabs:start -->

#### pubspec.yaml

```yaml
---
dependencies:
  audio_session:
    git:
      url: https://gitcode.com/openharmony-sig/flutter_audio_session.git
```

执行命令

```bash
flutter pub get
```

<!-- tabs:end -->

### 1.2 使用案例

使用案例详见 [ohos/example](./example/lib/main.dart)

## 2. 约束与限制

### 2.1 兼容性

在以下版本中已测试通过

1. Flutter: 3.27.5-ohos-0.0.1; SDK: 5.0.0(12); IDE: DevEco Studio: 5.1.0.828; ROM: 5.1.0.130 SP8;

## 3. API

> [!TIP] "ohos Support"列为 yes 表示 ohos 平台支持该属性；no 则表示不支持；partially 表示部分支持。使用方法跨平台一致，效果对标 iOS 或 Android 的效果。

### OhosAudioManager 

| Name                           | Description                      | Type     | Input                                                    | Output                                    | ohos Support |
| ------------------------------ | -------------------------------- | -------- | -------------------------------------------------------- | ----------------------------------------- | ------------ |
| setAudioDevicesAddedListener   | 设置音频设备添加的监听器         | function | `OhosOnAudioDevicesChanged` listener                     | /                                         | yes          |
| setAudioDevicesRemovedListener | 设置音频设备移除的监听器         | function | `OhosOnAudioDevicesChanged` listener                     | /                                         | yes          |
| setInterruptionEventListener   | 设置中断事件监听器               | function | `OhosInterruptListernerRequest` listernerRequest         | /                                         | yes          |
| setActive                      | 设置音频会话是否激活             | function | `bool` active, {`AudioConcurrencyMode?` concurrencyMode} | `Future<bool>`                            | yes          |
| isVolumeUnadjustable           | 检查音量是否不可调整             | function | /                                                        | `Future<bool>`                            | yes          |
| getRingerMode                  | 获取铃声模式                     | function | /                                                        | `Future<AudioRingMode>`                   | yes          |
| getMaxVolume                   | 获取指定流类型的系统最大音量     | function | `AudioVolumeType` streamType                             | `Future<int>`                             | yes          |
| getMinVolume                   | 获取指定流类型的系统最小音量     | function | `AudioVolumeType` streamType                             | `Future<int>`                             | yes          |
| getVolume                      | 获取指定流类型的当前系统音量     | function | `AudioVolumeType` streamType                             | `Future<int>`                             | yes          |
| getSystemVolumeInDb            | 获取指定流类型在分贝中的系统音量 | function | `AudioVolumeType` streamType                             | `Future<int>`                             | yes          |
| isMute                         | 检查指定流类型是否静音           | function | `AudioVolumeType` streamType                             | `Future<bool>`                            | yes          |
| getDevices                     | 获取所有音频设备                 | function | `DevicesFlags` flags                                     | `Future<List<OhosAudioDeviceDescriptor>>` | yes          |
| setSpeakerphoneOn              | 设置扬声器是否开启               | function | `bool` enabled                                           | `Future<void>`                            | yes          |
| isSpeakerphoneOn               | 检查扬声器是否开启               | function | /                                                        | `Future<bool>`                            | yes          |
| setMicrophoneMute              | 设置麦克风是否静音               | function | `bool` enabled                                           | `Future<void>`                            | yes          |
| isMicrophoneMute               | 检查麦克风是否静音               | function | /                                                        | `Future<bool>`                            | yes          |
| getAudioScene                  | 获取当前音频场景                 | function | /                                                        | `Future<AudioScene>`                      | yes          |
| isMusicActive                  | 检查是否有音乐正在播放           | function | /                                                        | `Future<bool>`                            | yes          |
| setAudioParameter              | 设置音频参数                     | function | `String` parameters, `String` value                      | `Future<void>`                            | yes          |
| getAudioParameter              | 获取音频参数                     | function | `String` key                                             | `Future<String>`                          | yes          |

### OhosInterruptEvent API

| Name      | Description  | Type | Input | Output | ohos Support |
| --------- | ------------ | ---- | ----- | ------ | ------------ |
| eventType | 中断事件类型 | enum | /     | /      | yes          |
| forceType | 中断强制类型 | enum | /     | /      | yes          |
| hintType  | 中断提示类型 | enum | /     | /      | yes          |

### OhosInterruptType API

| Name               | Description | Type | Input | Output | ohos Support |
| ------------------ | ----------- | ---- | ----- | ------ | ------------ |
| interruptTypeBegin | 开始中断    | enum | /     | /      | yes          |
| interruptTypeEnd   | 结束中断    | enum | /     | /      | yes          |

### OhosInterruptForceType API

| Name           | Description | Type | Input | Output | ohos Support |
| -------------- | ----------- | ---- | ----- | ------ | ------------ |
| interruptForce | 强制中断    | enum | /     | /      | yes          |
| interruptShare | 共享中断    | enum | /     | /      | yes          |

### OhosInterruptHint API

| Name                | Description  | Type | Input | Output | ohos Support |
| ------------------- | ------------ | ---- | ----- | ------ | ------------ |
| interruptHintNone   | 无提示       | enum | /     | /      | yes          |
| interruptHintResume | 恢复提示     | enum | /     | /      | yes          |
| interruptHintPause  | 暂停提示     | enum | /     | /      | yes          |
| interruptHintStop   | 停止提示     | enum | /     | /      | yes          |
| interruptHintDuck   | 降低音量提示 | enum | /     | /      | yes          |
| interruptHintUnduck | 恢复音量提示 | enum | /     | /      | yes          |

### AudioRingMode API

| Name              | Description | Type | Input | Output | ohos Support |
| ----------------- | ----------- | ---- | ----- | ------ | ------------ |
| ringerModeSilent  | 静音模式    | enum | /     | /      | yes          |
| ringerModeVibrate | 振动模式    | enum | /     | /      | yes          |
| ringerModeNormal  | 正常模式    | enum | /     | /      | yes          |

### AudioScene API

| Name                | Description  | Type | Input | Output | ohos Support |
| ------------------- | ------------ | ---- | ----- | ------ | ------------ |
| audioSceneDefault   | 默认音频场景 | enum | /     | /      | yes          |
| audioSceneRinging   | 铃声场景     | enum | /     | /      | yes          |
| audioScenePhoneCall | 电话通话场景 | enum | /     | /      | yes          |
| audioSceneVoiceChat | 语音聊天场景 | enum | /     | /      | yes          |

### AudioSessionDeactivatedReason API

| Name                     | Description        | Type | Input | Output | ohos Support |
| ------------------------ | ------------------ | ---- | ----- | ------ | ------------ |
| deactivatedLowerPriority | 因为优先级低被停用 | enum | /     | /      | yes          |
| deactivatedTimeout       | 超时停用           | enum | /     | /      | yes          |

### OhosAudioDeviceDescriptor API

| Name          | Description        | Type              | Input | Output | ohos Support |
| ------------- | ------------------ | ----------------- | ----- | ------ | ------------ |
| deviceRole    | 设备角色           | DeviceRole        | /     | /      | yes          |
| deviceType    | 设备类型           | DeviceType        | /     | /      | yes          |
| id            | 设备 ID            | int               | /     | /      | yes          |
| name          | 设备名称           | String            | /     | /      | yes          |
| address       | 设备地址           | String            | /     | /      | yes          |
| sampleRates   | 支持的采样率列表   | List<int>         | /     | /      | yes          |
| channelCounts | 支持的声道数列表   | List<int>         | /     | /      | yes          |
| channelMasks  | 支持的声道掩码列表 | List<int>         | /     | /      | yes          |
| displayName   | 显示名称           | String            | /     | /      | yes          |
| encodingTypes | 支持的编码类型     | AudioEncodingType | /     | /      | yes          |

### AudioEncodingType API

| Name                | Description  | Type | Input | Output | ohos Support |
| ------------------- | ------------ | ---- | ----- | ------ | ------------ |
| encodingTypeInvalid | 无效编码类型 | enum | /     | /      | yes          |
| encodingTypeRaw     | 原始编码类型 | enum | /     | /      | yes          |

### DeviceRole API

| Name         | Description | Type | Input | Output | ohos Support |
| ------------ | ----------- | ---- | ----- | ------ | ------------ |
| inputDevice  | 输入设备    | enum | /     | /      | yes          |
| outputDevice | 输出设备    | enum | /     | /      | yes          |

### DeviceType API

| Name            | Description          | Type | Input | Output | ohos Support |
| --------------- | -------------------- | ---- | ----- | ------ | ------------ |
| invalid         | 无效设备             | enum | /     | /      | yes          |
| earpiece        | 听筒                 | enum | /     | /      | yes          |
| speaker         | 扬声器               | enum | /     | /      | yes          |
| wiredHeadset    | 有线耳机             | enum | /     | /      | yes          |
| wiredHeadphones | 有线耳机（带麦克风） | enum | /     | /      | yes          |
| bluetoothSco    | 蓝牙 SCO 连接        | enum | /     | /      | yes          |
| bluetoothA2dp   | 蓝牙 A2DP 连接       | enum | /     | /      | yes          |
| mic             | 麦克风               | enum | /     | /      | yes          |
| usbHeadset      | USB 耳机             | enum | /     | /      | yes          |
| defaultDevice   | 默认设备             | enum | /     | /      | yes          |

### AudioVolumeType API

| Name           | Description | Type | Input | Output | ohos Support |
| -------------- | ----------- | ---- | ----- | ------ | ------------ |
| voiceCall      | 语音通话    | enum | /     | /      | yes          |
| ringTone       | 铃声        | enum | /     | /      | yes          |
| media          | 媒体        | enum | /     | /      | yes          |
| alarm          | 闹钟        | enum | /     | /      | yes          |
| accessibility  | 辅助功能    | enum | /     | /      | yes          |
| voiceAssistant | 语音助手    | enum | /     | /      | yes          |
| ultraSonic     | 超声波      | enum | /     | /      | yes          |
| all            | 所有        | enum | /     | /      | yes          |

### OhosAudioAttributes API

| Name         | Description | Type              | Input | Output | ohos Support |
| ------------ | ----------- | ----------------- | ----- | ------ | ------------ |
| streamUsage  | 流使用      | StreamUsage       | /     | /      | yes          |
| samplingRate | 采样率      | AudioSamplingRate | /     | /      | yes          |
| channels     | 声道        | AudioChannel      | /     | /      | yes          |
| sampleFormat | 样本格式    | AudioSampleFormat | /     | /      | yes          |
| encodingType | 编码类型    | AudioEncodingType | /     | /      | yes          |

### StreamUsage API

| Name               | Description | Type | Input | Output | ohos Support |
| ------------------ | ----------- | ---- | ----- | ------ | ------------ |
| unknown            | 未知用途    | enum | /     | /      | yes          |
| music              | 音乐        | enum | /     | /      | yes          |
| voiceCommunication | 语音通信    | enum | /     | /      | yes          |
| voiceAssistant     | 语音助手    | enum | /     | /      | yes          |
| alarm              | 闹钟        | enum | /     | /      | yes          |
| voiceMessage       | 语音消息    | enum | /     | /      | yes          |
| ringTone           | 铃声        | enum | /     | /      | yes          |
| notification       | 通知        | enum | /     | /      | yes          |
| accessibility      | 辅助功能    | enum | /     | /      | yes          |
| movie              | 电影        | enum | /     | /      | yes          |
| game               | 游戏        | enum | /     | /      | yes          |
| audioBook          | 有声书      | enum | /     | /      | yes          |
| navigation         | 导航        | enum | /     | /      | yes          |

### OhosInterruptListernerRequest API

| Name                | Description          | Type                | Input | Output | ohos Support |
| ------------------- | -------------------- | ------------------- | ----- | ------ | ------------ |
| audioAttributes     | 音频属性             | OhosAudioAttributes | /     | /      | yes          |
| onAudioFocusChanged | 音频焦点变化回调函数 | function            | /     | /      | yes          |
| isOnListener        | 是否开启监听器       | bool                | /     | /      | yes          |

### AudioSamplingRate API

| Name            | Description    | Type | Input | Output | ohos Support |
| --------------- | -------------- | ---- | ----- | ------ | ------------ |
| sampleRate8000  | 8000Hz 采样率  | enum | /     | /      | yes          |
| sampleRate11025 | 11025Hz 采样率 | enum | /     | /      | yes          |
| sampleRate12000 | 12000Hz 采样率 | enum | /     | /      | yes          |
| sampleRate16000 | 16000Hz 采样率 | enum | /     | /      | yes          |
| sampleRate22050 | 22050Hz 采样率 | enum | /     | /      | yes          |
| sampleRate24000 | 24000Hz 采样率 | enum | /     | /      | yes          |
| sampleRate32000 | 32000Hz 采样率 | enum | /     | /      | yes          |
| sampleRate44100 | 44100Hz 采样率 | enum | /     | /      | yes          |
| sampleRate48000 | 48000Hz 采样率 | enum | /     | /      | yes          |
| sampleRate64000 | 64000Hz 采样率 | enum | /     | /      | yes          |
| sampleRate96000 | 96000Hz 采样率 | enum | /     | /      | yes          |

### AudioChannel API

| Name      | Description | Type | Input | Output | ohos Support |
| --------- | ----------- | ---- | ----- | ------ | ------------ |
| channel1  | 单声道      | enum | /     | /      | yes          |
| channel2  | 双声道      | enum | /     | /      | yes          |
| channel3  | 三声道      | enum | /     | /      | yes          |
| channel4  | 四声道      | enum | /     | /      | yes          |
| channel5  | 五声道      | enum | /     | /      | yes          |
| channel6  | 六声道      | enum | /     | /      | yes          |
| channel7  | 七声道      | enum | /     | /      | yes          |
| channel8  | 八声道      | enum | /     | /      | yes          |
| channel9  | 九声道      | enum | /     | /      | yes          |
| channel10 | 十声道      | enum | /     | /      | yes          |
| channel11 | 十一声道    | enum | /     | /      | yes          |
| channel12 | 十二声道    | enum | /     | /      | yes          |
| channel13 | 十三声道    | enum | /     | /      | yes          |
| channel14 | 十四声道    | enum | /     | /      | yes          |
| channel15 | 十五声道    | enum | /     | /      | yes          |
| channel16 | 十六声道    | enum | /     | /      | yes          |

### AudioSampleFormat API

| Name                | Description           | Type | Input | Output | ohos Support |
| ------------------- | --------------------- | ---- | ----- | ------ | ------------ |
| sampleFormatInvalid | 无效格式              | enum | /     | /      | yes          |
| sampleFormatU8      | 8 位无符号整型        | enum | /     | /      | yes          |
| sampleFormatS16LE   | 16 位有符号整型小端序 | enum | /     | /      | yes          |
| sampleFormatS24LE   | 24 位有符号整型小端序 | enum | /     | /      | yes          |
| sampleFormatS32LE   | 32 位有符号整型小端序 | enum | /     | /      | yes          |
| sampleFormatF32LE   | 32 位浮点型小端序     | enum | /     | /      | yes          |

### AudioConcurrencyMode API

| Name                     | Description  | Type | Input | Output | ohos Support |
| ------------------------ | ------------ | ---- | ----- | ------ | ------------ |
| concurrencyDefault       | 默认并发模式 | enum | /     | /      | yes          |
| concurrencyMixWithOthers | 与其它混合   | enum | /     | /      | yes          |
| concurrencyDuckOthers    | 让其它变弱   | enum | /     | /      | yes          |
| concurrencyPauseOthers   | 暂停其它     | enum | /     | /      | yes          |

## 4. 遗留问题

## 5. 其他

## 6. 开源协议

本项目基于 [The MIT License (MIT)](./LICENSE) ，请自由地享受和参与开源。
