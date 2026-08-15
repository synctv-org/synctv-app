# Playback Route Policy

Each provider owns playback-route decisions. The client obtains a
`PlaybackProxyPolicy` for the concrete discovered source and renders only the
returned `supported_modes`.

## Provider Contract

- Resolve policy from the exact media or dynamic-playlist source. A provider
  returns the current selection, supported modes, and automatic behavior for
  every media variant.
- Generate playback for the selected mode. Route generation happens before the
  playback result is built, so selected routes are the only upstream resources
  used.
- Name each generated mode for its provider-owned media variant and delivery
  route. For example, Bilibili can expose `h264`, `hevc`, `h264_proxy`, and
  `hevc_proxy`; a codec mode contains one MPD whose adaptive tracks provide
  its available qualities.
- Keep credential-bearing headers, cookies, authorization values, signed URLs,
  and provider sessions behind a proxy by default. Public resources may use a
  direct default.
- Report every automatic decision through `auto_policies`. The client displays
  the provider's variant, effective mode, and disclosure reason.

## Route Modes

| Mode | Generated routes |
| --- | --- |
| Automatic | Provider-selected routes for each media variant. |
| Prefer proxy | Direct and proxy routes, with proxy selected first. |
| Proxy only | Proxy routes only. |
| Prefer direct | Direct and proxy routes, with direct selected first. |
| Direct only | Direct routes only. |

Providers expose only modes they can honor for the concrete source. For
example, a provider can omit direct modes for a server-session media variant.

## Client Rules

- Query the policy after previewing a list and query it again after selecting a
  media entry. The selected entry takes precedence over the list source.
- Use the returned mode set directly and treat the provider response as the
  source of default behavior.
- Apply the chosen mode to the source submitted for a selected media entry or
  the current dynamic playlist.
- Clear selections when account, path, search, collection, or preview state
  changes. A policy must always correspond to an entry currently displayed.
- Surface policy-loading and policy-unavailable states. The unavailable state
  leaves the source in its provider-controlled automatic mode.

`withPlaybackProxyMode` supports every configurable source type:
Direct URL; AList; Bilibili; Emby; Cloudreve; FNOS; Nextcloud; QNAP; Seafile;
Synology; and TrueNAS. Fixed-route providers keep their source configuration
unchanged.
