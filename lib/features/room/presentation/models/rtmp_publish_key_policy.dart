import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

bool canGenerateRtmpPublishKey({
  required RoomMediaEntry entry,
  required String viewerId,
  required bool canManageLiveStreams,
}) {
  if (viewerId.isEmpty || !entry.id.startsWith('med_')) return false;
  if (entry.isProviderDynamicItem || !entry.isAvailable) return false;
  if (entry.sourceProvider != source_enum.SourceProvider.SOURCE_PROVIDER_RTMP) {
    return false;
  }
  return canManageLiveStreams || entry.creator == viewerId;
}
