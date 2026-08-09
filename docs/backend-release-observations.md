# Backend Release Observations

These observations describe backend behavior visible through the public client
contract. Environment-specific deployment details are intentionally omitted.

## WebRTC advertised address

When built-in STUN is enabled without an externally reachable address, the
server can advertise an internal address that clients cannot reach. Configure
an externally reachable IP address and port or a public DNS name before relying
on the built-in STUN service for remote WebRTC connections.

## Realtime permission snapshots

An administrator member override that explicitly adds
`view_playback_history` is persisted in `adminAddedPermissions`, while the
effective `self_room_member.permissions` snapshot can still omit that bit. The
other tested administrator overrides are reflected in the realtime snapshot.

## Kick and ban disconnect semantics

Room kicks and platform bans directly terminate the affected WebSocket
connection. The resulting close carries the same observable information as a
transport interruption, which makes immediate client-side classification
unreliable. The realtime protocol should send a terminal event or an
application-specific close code and reason before disconnecting the affected
session.
