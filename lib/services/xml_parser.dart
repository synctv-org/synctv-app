import 'dart:math';

import 'package:xml/xml.dart';

abstract class PlayType {
  String get protocolInfo;
}

enum MediaMime implements PlayType {
  none('');

  @override
  final String protocolInfo;
  const MediaMime(this.protocolInfo);
}

enum VideoMime implements PlayType {
  mpeg('http-get:*:video/mpeg:*'),
  mp4('http-get:*:video/mp4:*'),
  xMatroska('http-get:*:video/x-matroska:*'), // MKV
  quicktime('http-get:*:video/quicktime:*'), // MOV
  xMsWmv('http-get:*:video/x-ms-wmv:*'), // WMV
  avi('http-get:*:video/avi:*'), // AVI
  flv('http-get:*:video/flv:*'),
  ts('http-get:*:video/mp2t:*'), // TS

  // 流媒体播放列表
  hls('http-get:*:application/vnd.apple.mpegurl:*'), // 标准的HLS MIME Type

  any('http-get:*:*:*');

  @override
  final String protocolInfo;
  const VideoMime(this.protocolInfo);
}

enum AudioMime implements PlayType {
  mp3('http-get:*:audio/mp3:*'),
  mp4('http-get:*:audio/mp4:*'),
  mpeg('http-get:*:audio/mpeg:*'),
  xFlac('http-get:*:audio/x-flac:*'),
  mpegurl('http-get:*:audio/mpegurl:*'),
  wav('http-get:*:audio/wav:*'),
  wma('http-get:*:audio/wma:*'),
  xMatroska('http-get:*:audio/x-matroska:*'),
  xApe('http-get:*:audio/x-ape:*'),
  any('http-get:*:*:*');

  @override
  final String protocolInfo;
  const AudioMime(this.protocolInfo);
}

enum ImageMime implements PlayType {
  jpeg('http-get:*:image/jpeg:*'),
  png('http-get:*:image/png:*'),
  tiff('http-get:*:image/tiff:*'),
  gif('http-get:*:image/gif:*'),
  any('http-get:*:*:*');

  @override
  final String protocolInfo;
  const ImageMime(this.protocolInfo);
}

extension XmlExtension on XmlNode {
  String tagVal(String name) {
    return findAllElements(name).first.innerText;
  }
}

class DeviceInfo {
  final String urlBase;
  final String deviceType;
  final String friendlyName;
  final List<dynamic> serviceList;
  DeviceInfo(
    this.urlBase,
    this.deviceType,
    this.friendlyName,
    this.serviceList,
  );
}

class PositionParser {
  String trackDuration = "00:00:00"; // 总时长
  String trackUri = "";
  String relTime = "00:00:00"; // 当前播放时间点
  String absTime = "00:00:00";

  int get trackDurationSeconds => toInt(trackDuration);

  int get relTimeSeconds => toInt(relTime);

  PositionParser(String text) {
    if (text.isEmpty) {
      return;
    }
    final doc = XmlDocument.parse(text);
    final duration = doc.tagVal('TrackDuration');
    final rel = doc.tagVal('RelTime');
    final abs = doc.tagVal('AbsTime');
    if (duration.isNotEmpty) {
      trackDuration = duration;
    }
    if (rel.isNotEmpty) {
      relTime = rel;
    }
    if (abs.isNotEmpty) {
      absTime = abs;
    }
    trackUri = doc.tagVal('TrackURI');
  }

  String seek(int n) {
    final total = trackDurationSeconds;
    var x = relTimeSeconds + n;
    if (x > total) {
      x = total;
    } else if (x < 0) {
      x = 0;
    }
    return toStr(x);
  }

  static int toInt(String str) {
    final arr = str.split(':');
    var sum = 0;
    for (var i = 0; i < arr.length; i++) {
      sum += int.parse(arr[i]) * (pow(60, arr.length - i - 1) as int);
    }
    return sum;
  }

  static String toStr(int time) {
    final h = (time / 3600).floor();
    final m = ((time - 3600 * h) / 60).floor();
    final s = time - 3600 * h - 60 * m;
    final str = "${z(h)}:${z(m)}:${z(s)}";
    return str;
  }

  static String z(int n) {
    if (n > 9) {
      return n.toString();
    }
    return "0$n";
  }
}

class VolumeParser {
  int current = 0;
  VolumeParser(String text) {
    final doc = XmlDocument.parse(text);
    final v = doc.tagVal('CurrentVolume');
    current = int.parse(v);
  }

  int change(int v) {
    int target = current + v;
    if (target > 100) {
      target = 100;
    }
    if (target < 0) {
      target = 0;
    }
    return target;
  }
}

class MuteParser {
  bool muted = false;
  MuteParser(String text) {
    final doc = XmlDocument.parse(text);
    muted = doc.tagVal('CurrentMute') == '1';
  }
}

class TransportInfoParser {
  String currentTransportState = '';
  String currentTransportStatus = '';
  TransportInfoParser(String text) {
    final doc = XmlDocument.parse(text);
    currentTransportState = doc.tagVal('CurrentTransportState');
    currentTransportStatus = doc.tagVal('CurrentTransportStatus');
  }
}

class MediaInfoParser {
  String mediaDuration = '00:00';
  String currentUri = '';
  String nextUri = '';

  int get mediaDurationSeconds => PositionParser.toInt(mediaDuration);

  MediaInfoParser(String text) {
    final doc = XmlDocument.parse(text);
    mediaDuration = doc.tagVal('MediaDuration');
    currentUri = doc.tagVal('CurrentURI');
    nextUri = doc.tagVal('NextURI');
  }
}

class DeviceInfoParser {
  final String text;
  final XmlDocument doc;
  DeviceInfoParser(this.text) : doc = XmlDocument.parse(text);
  DeviceInfo parse(Uri uri) {
    String urlBase = "";
    try {
      urlBase = doc.tagVal('URLBase');
    } catch (e) {
      urlBase = uri.origin;
    }
    final deviceType = doc.tagVal('deviceType');
    final friendlyName = doc.tagVal('friendlyName');
    final serviceList =
        doc.findAllElements('serviceList').first.findAllElements('service');
    final serviceListItems = [];
    for (final service in serviceList) {
      final serviceType = service.tagVal('serviceType');
      final serviceId = service.tagVal('serviceId');
      final controlURL = service.tagVal('controlURL');
      serviceListItems.add({
        "serviceType": serviceType,
        "serviceId": serviceId,
        "controlURL": controlURL,
      });
    }
    return DeviceInfo(urlBase, deviceType, friendlyName, serviceListItems);
  }
}
