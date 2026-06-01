String playbackLoadErrorMessage(Object error) {
  final text = error.toString();
  final lower = text.toLowerCase();

  if (_containsStatus(lower, 401)) {
    return '目标媒体站点要求登录。请检查链接是否公开可访问，或重新添加带有效凭据的媒体。';
  }
  if (_containsStatus(lower, 403)) {
    return '目标媒体站点拒绝访问此视频。请检查链接权限、来源限制或直链请求头。';
  }
  if (_containsStatus(lower, 404) || lower.contains('not found')) {
    return '视频地址不存在或已经失效。请检查链接后重新添加。';
  }
  if (_containsStatus(lower, 429) || lower.contains('rate limit')) {
    return '目标媒体站点请求过于频繁。请稍后重试或更换可访问的资源。';
  }
  if (lower.contains('unsupported') ||
      lower.contains('format') ||
      lower.contains('codec') ||
      lower.contains('decode')) {
    return '当前设备无法播放此视频格式。请更换 MP4/HLS 等常见格式资源。';
  }
  if (lower.contains('timed out') ||
      lower.contains('timeout') ||
      lower.contains('network') ||
      lower.contains('connection') ||
      lower.contains('failed host lookup')) {
    return '视频连接失败。请检查网络、代理设置或目标站点可用性。';
  }

  return '视频加载失败。请确认链接可公开访问，且当前设备支持此视频格式。';
}

bool _containsStatus(String text, int status) {
  final value = status.toString();
  return text.contains('http $value') ||
      text.contains('http status $value') ||
      text.contains('statuscode: $value') ||
      text.contains('status code $value') ||
      text.contains('status=$value') ||
      text.contains('response code: $value') ||
      text.contains('server returned $value');
}
