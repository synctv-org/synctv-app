import 'package:flutter/foundation.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

@immutable
class RoomPlaybackControllerState {
  const RoomPlaybackControllerState({
    this.status,
    this.navigationInFlight = false,
  });

  final SyncTvPlaybackStatus? status;
  final bool navigationInFlight;

  RoomPlaybackControllerState copyWith({
    SyncTvPlaybackStatus? status,
    bool clearStatus = false,
    bool? navigationInFlight,
  }) {
    return RoomPlaybackControllerState(
      status: clearStatus ? null : status ?? this.status,
      navigationInFlight: navigationInFlight ?? this.navigationInFlight,
    );
  }
}

class RoomPlaybackController extends ChangeNotifier {
  RoomPlaybackControllerState _state = const RoomPlaybackControllerState();

  RoomPlaybackControllerState get state => _state;

  void setStatus(SyncTvPlaybackStatus? status) {
    if (identical(_state.status, status)) return;
    _state = _state.copyWith(status: status, clearStatus: status == null);
    notifyListeners();
  }

  void setNavigationInFlight(bool value) {
    if (_state.navigationInFlight == value) return;
    _state = _state.copyWith(navigationInFlight: value);
    notifyListeners();
  }
}
