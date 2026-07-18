import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations_en.dart';
import 'package:synctv_app/l10n/app_localizations_zh.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/models/synctv_models.dart';

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
        'View media list',
        'View member list',
        'View chat history',
        'WebRTC calls',
      ],
    );
    expect(
      RoomMemberPermissions.values
          .map(chinese.roomMemberPermissionLabel)
          .toList(),
      ['发送聊天/弹幕', '添加媒体', '查看媒体列表', '查看成员列表', '查看聊天历史', 'WebRTC 通话'],
    );
  });
}
