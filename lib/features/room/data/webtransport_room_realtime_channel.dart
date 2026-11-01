export 'webtransport_room_realtime_channel_io.dart'
    if (dart.library.js_interop) 'webtransport_room_realtime_channel_web.dart'
    show isWebTransportSupported, webTransportChannelFactory;
