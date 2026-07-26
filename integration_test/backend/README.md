# Real backend contract tests

The default `flutter test` suite is deterministic and self-contained. Tests in
this group exercise HTTP, protobuf, authentication, WebSocket, playback, and
upload contracts against a separately running SyncTV server.

Start a disposable local server, then run the required contract scope:

```bash
fvm flutter test tool/local_backend_smoke.dart \
  --dart-define=SYNCTV_SMOKE_BASE_URL=http://127.0.0.1:8080 \
  --dart-define=SYNCTV_SMOKE_ROOT_PASSWORD='local-root-password'

fvm flutter test tool/local_backend_smoke_extended.dart \
  --dart-define=SYNCTV_SMOKE_BASE_URL=http://127.0.0.1:8080 \
  --dart-define=SYNCTV_SMOKE_ROOT_PASSWORD='local-root-password'

fvm flutter test tool/local_backend_deep_business_test.dart \
  --dart-define=SYNCTV_SMOKE_BASE_URL=http://127.0.0.1:8080 \
  --dart-define=SYNCTV_SMOKE_ROOT_PASSWORD='local-root-password'
```

These tests create and mutate users, rooms, media, and messages. Use an
ephemeral development database dedicated to the test run.
