import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

Finder byAppTooltip(Pattern message) {
  bool matches(String value) => switch (message) {
    RegExp() => message.hasMatch(value),
    _ => value == message,
  };

  return find.byWidgetPredicate(
    (widget) => switch (widget) {
      AppTooltip(message: final value) => matches(value),
      Tooltip(message: final value?) => matches(value),
      _ => false,
    },
    description: 'app tooltip matching "$message"',
  );
}

Widget buildThemedTestApp(BuildContext context, Widget? child) {
  return child!;
}

provider_common.DiscoveredSource testDiscoveredMediaSource({
  String name = 'Test media',
}) => provider_common.DiscoveredSource(
  media: source_config.MediaSourceConfig(
    directUrl: source_config.DirectUrlMediaSourceConfig(
      medias: [
        source_config.DirectUrlMediaResourceConfig(
          name: name,
          url: 'https://media.example.test/video.mp4',
        ),
      ],
    ),
  ),
);

provider_common.DiscoveredSource testDiscoveredPlaylistSource() =>
    provider_common.DiscoveredSource(
      playlist: source_config.PlaylistSourceConfig(
        alist: source_config.AlistPlaylistSourceConfig(
          serverId: 'test-server',
          path: '/videos',
        ),
      ),
    );
