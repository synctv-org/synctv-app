import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/models/rtmp_publish_key_policy.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  group('canGenerateRtmpPublishKey', () {
    RoomMediaEntry rtmp({
      String creator = 'usr_creator',
      client_enum.ResourceAvailability availability =
          client_enum.ResourceAvailability.RESOURCE_AVAILABILITY_AVAILABLE,
    }) => RoomMediaItem(
      id: 'med_Rtmp123',
      name: 'Studio stream',
      url: '',
      creator: creator,
      sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_RTMP,
      availability: availability,
    );

    test('allows the media creator without room-wide permission', () {
      expect(
        canGenerateRtmpPublishKey(
          entry: rtmp(),
          viewerId: 'usr_creator',
          canManageLiveStreams: false,
        ),
        isTrue,
      );
    });

    test('allows a live-stream manager for another creator media', () {
      expect(
        canGenerateRtmpPublishKey(
          entry: rtmp(),
          viewerId: 'usr_manager',
          canManageLiveStreams: true,
        ),
        isTrue,
      );
    });

    test('rejects unrelated viewers and unavailable or non-RTMP media', () {
      expect(
        canGenerateRtmpPublishKey(
          entry: rtmp(),
          viewerId: 'usr_member',
          canManageLiveStreams: false,
        ),
        isFalse,
      );
      expect(
        canGenerateRtmpPublishKey(
          entry: rtmp(
            availability: client_enum
                .ResourceAvailability
                .RESOURCE_AVAILABILITY_CREATOR_INACTIVE,
          ),
          viewerId: 'usr_creator',
          canManageLiveStreams: false,
        ),
        isFalse,
      );
      expect(
        canGenerateRtmpPublishKey(
          entry: RoomMediaItem(
            id: 'med_Direct123',
            name: 'Video',
            url: 'https://example.test/video.mp4',
            creator: 'usr_creator',
            sourceProvider:
                source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
          ),
          viewerId: 'usr_creator',
          canManageLiveStreams: true,
        ),
        isFalse,
      );
    });
  });
}
