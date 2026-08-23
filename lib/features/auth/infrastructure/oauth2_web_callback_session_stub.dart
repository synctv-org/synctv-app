import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';

OAuth2CallbackSession createOAuth2WebCallbackSession({
  required Uri redirectUri,
  required Duration authorizationTimeout,
}) => throw UnsupportedError('Web OAuth2 is unavailable on this platform.');
