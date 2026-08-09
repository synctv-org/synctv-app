import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations_en.dart';
import 'package:synctv_app/l10n/app_localizations_zh.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

void main() {
  test('room permission labels follow the active localization', () {
    final english = AppLocalizationsEn();
    final chinese = AppLocalizationsZh();

    expect(
      RoomMemberPermissions.values
          .map(english.roomMemberPermissionLabel)
          .toList(),
      [
        'Send chat and danmaku',
        'Add media',
        'Browse library',
        'View member list',
        'View chat history',
        'Voice chat',
        'P2P media delivery',
      ],
    );
    expect(
      RoomMemberPermissions.values
          .map(chinese.roomMemberPermissionLabel)
          .toList(),
      ['发送聊天/弹幕', '添加媒体', '浏览媒体库', '查看成员列表', '查看聊天历史', '语音聊天', 'P2P 媒体传输'],
    );
  });

  test('administrator permission labels cover the administrator bitspace', () {
    final english = AppLocalizationsEn();

    final labels = RoomAdminPermissions.values
        .map(english.roomAdminPermissionLabel)
        .toList();

    expect(labels, hasLength(21));
    expect(
      labels,
      containsAll(['Delete media', 'Playback control', 'P2P media delivery']),
    );
    expect(
      labels,
      isNot(contains(RoomAdminPermissions.useP2pMedia.toString())),
    );
    expect(RoomAdminPermissions.deleteMedia, RoomMemberPermissions.useP2pMedia);
    expect(
      RoomAdminPermissions.useP2pMedia,
      RoomEffectivePermissions.useP2pMedia,
    );
  });
}
