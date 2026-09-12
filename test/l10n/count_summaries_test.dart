import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  for (final count in [0, 1, 2]) {
    test('English integer summaries handle count $count', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final member = count == 1 ? 'member' : 'members';
      final guest = count == 1 ? 'guest' : 'guests';
      final connection = count == 1 ? 'connection' : 'connections';
      final event = count == 1 ? 'event' : 'events';
      final character = count == 1 ? 'character' : 'characters';
      final factor = count == 1 ? 'factor' : 'factors';
      final provider = count == 1 ? 'provider' : 'providers';
      final byte = count == 1 ? 'byte' : 'bytes';
      final expectations = <String, String>{
        l10n.viewsCount(count): '$count ${count == 1 ? 'view' : 'views'}',
        l10n.viewersCount(count): '$count ${count == 1 ? 'viewer' : 'viewers'}',
        l10n.cdnRoutesCount(count): '$count ${count == 1 ? 'CDN' : 'CDNs'}',
        l10n.mediaStreamsCount(count):
            '$count ${count == 1 ? 'stream' : 'streams'}',
        l10n.formatsCount(count): '$count ${count == 1 ? 'format' : 'formats'}',
        l10n.subtitlesCount(count):
            '$count ${count == 1 ? 'subtitle' : 'subtitles'}',
        l10n.variantsCount(count):
            '$count ${count == 1 ? 'variant' : 'variants'}',
        l10n.qualitiesCount(count):
            '$count ${count == 1 ? 'quality' : 'qualities'}',
        l10n.chaptersCount(count):
            '$count ${count == 1 ? 'chapter' : 'chapters'}',
        l10n.byteCount(count): '$count ${count == 1 ? 'byte' : 'bytes'}',
        l10n.playerBufferRangeCount(count):
            '$count ${count == 1 ? 'range' : 'ranges'}',
        l10n.playerConnectedPeerCount(count):
            '$count ${count == 1 ? 'peer' : 'peers'}',
        l10n.retainEvents(count): 'Keep $count $event',
        l10n.filteredEventCount(0, count): '0 / $count $event',
        l10n.roomPresenceSummary(count, count):
            'Online: $count $member · $count $guest',
        l10n.roomPresenceWithMembers(
          count,
          count,
          count,
        ): '$count $member online · $count $guest online · $count $member total',
        l10n.onlineMemberSummary(0, count): '0 online / $count $member',
        l10n.memberAdminSummary(count, 0, count):
            '$count $member · 0 online · $count $connection',
        l10n.memberPageSummary(count, 1, 3): '$count $member · Page 1 of 3',
        l10n.authenticationFactorsSummary(count, 'on', 'off', 'on'):
            '$count available $factor: password on, email off, passkey on',
        l10n.oauthProviderSummary(count, 0):
            '$count $provider, 0 with a Client ID',
        l10n.passwordMinimumLength(count): 'At least $count $character',
        l10n.roomNameTooLong(count):
            'Room names can contain up to $count $character',
        l10n.instanceNameTooLong(count):
            'Instance names can contain up to $count $character',
        l10n.dynamicMediaSize(count): count == 0
            ? 'Dynamic media'
            : 'Dynamic media · $count $byte',
      };
      for (final expectation in expectations.entries) {
        expect(expectation.key, expectation.value);
      }
    });
  }

  test('summary plural branches use each independent count', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(l10n.roomPresenceSummary(1, 2), 'Online: 1 member · 2 guests');
    expect(
      l10n.roomPresenceWithMembers(0, 1, 2),
      '0 members online · 1 guest online · 2 members total',
    );
    expect(
      l10n.memberAdminSummary(2, 1, 1),
      '2 members · 1 online · 1 connection',
    );
  });

  test('Chinese count summaries retain numeric values', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('zh'));
    for (final count in [0, 1, 2]) {
      expect(l10n.qualitiesCount(count), '$count 种清晰度');
      expect(l10n.chaptersCount(count), '$count 个章节');
      expect(l10n.cdnRoutesCount(count), '$count 条 CDN 线路');
      expect(l10n.mediaStreamsCount(count), '$count 路媒体流');
    }
  });
}
