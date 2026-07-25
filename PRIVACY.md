# SyncTV Privacy Policy / SyncTV 隐私政策

Effective date: July 25, 2026  
生效日期：2026 年 7 月 25 日

## English

### Scope

This policy covers the official SyncTV client distributed from this repository and through supported app stores. SyncTV is a client for user-selected SyncTV servers. Store releases do not contain a default server unless a distributor explicitly supplies one at build time. The operator of each server is responsible for its own privacy practices and retention policy.

### Data handled by the app

SyncTV may process the following data when you use the corresponding feature:

- Server addresses, account identifiers, optional email addresses, authentication tokens, preferences, room memberships, favorites, playlists, playback state and playback history.
- Messages, danmaku, media URLs, provider configuration and other content you choose to send to a server or share in a room.
- Microphone and camera data during voice or video communication. WebRTC may send media directly to other room participants and may expose participants' network addresses to one another.
- Media segments and network metrics when media P2P is enabled. Peers in the same server-authorized room swarm may exchange cached media data and observe peer network addresses.
- Device and app information required for protocol compatibility, native Passkey association, security checks and troubleshooting.

Passwords are processed through the selected server's authentication protocol. Passkey private keys remain in the operating system authenticator and are not available to SyncTV.

### Local storage

The app stores server-specific credentials, preferences and cached content on your device. Server data is isolated by normalized server address. Short-lived media P2P cache entries are managed by the configured size limit and expiration policy. You can remove a server from the app or clear application data through the operating system.

### Developer collection

The official client contains no advertising SDK, cross-app tracking, centralized analytics or automatic crash-reporting service. The SyncTV developers do not receive data sent only to a server you selected. GitHub and app stores may independently process download, purchase and diagnostic information under their own policies.

### Servers and third-party providers

A SyncTV server may store account data, room content, messages, playback history and operational logs according to its configuration. Media providers and websites you connect may receive your network address, request headers, account credentials or provider tokens. Review the policies of your server operator and each provider before connecting them.

### Permissions

SyncTV requests camera, microphone, local network and user-selected file access only for features that require them. You can manage these permissions in system settings. Disabling a permission disables the related feature.

### Security and retention

SyncTV supports encrypted transport and platform security features when the selected server and media source provide them. Self-hosted administrators control server security, access policy, backups and retention. Local cached data expires or is evicted according to app settings; account and room data follow the selected server's policy.

### Children

SyncTV is a general-purpose media synchronization tool and is not directed to children under 13. Server operators and users are responsible for complying with local age and content requirements.

### Contact and changes

Report privacy questions or security concerns through the [SyncTV issue tracker](https://github.com/synctv-org/synctv/issues). Material changes to this policy will be published in this document with a new effective date.

## 中文

### 适用范围

本政策适用于通过本仓库和受支持应用商店分发的官方 SyncTV 客户端。SyncTV 客户端连接由用户选择的 SyncTV 服务器。应用商店构建默认不包含服务器地址；发行方可在构建时明确提供默认服务器。每个服务器的运营方负责其自身的隐私实践和数据保留政策。

### 应用处理的数据

使用对应功能时，SyncTV 可能处理以下数据：

- 服务器地址、账号标识、可选邮箱、认证令牌、偏好设置、房间成员关系、收藏、播放列表、播放状态和播放历史。
- 你选择发送到服务器或在房间中共享的消息、弹幕、媒体 URL、Provider 配置及其他内容。
- 语音或视频通信期间的麦克风和摄像头数据。WebRTC 可将媒体直接发送给房间内其他参与者，并可能让参与者获知彼此的网络地址。
- 启用媒体 P2P 后的媒体分片和网络指标。同一服务器授权房间 Swarm 内的 Peer 可以交换缓存媒体，并可能获知 Peer 的网络地址。
- 协议兼容、原生 Passkey 关联、安全检查和故障排查所需的设备与应用信息。

密码通过所选服务器的认证协议处理。Passkey 私钥保存在操作系统认证器中，SyncTV 无法读取该私钥。

### 本地存储

应用会在设备上保存按服务器隔离的凭据、偏好设置和缓存内容。服务器数据以规范化服务器地址为隔离边界。短期媒体 P2P 缓存由配置的容量限制和过期策略管理。你可以从应用中移除服务器，也可以通过操作系统清除应用数据。

### 开发者收集

官方客户端不包含广告 SDK、跨应用跟踪、集中式分析或自动崩溃上报服务。仅发送到用户所选服务器的数据不会提供给 SyncTV 开发者。GitHub 和应用商店可能依据各自政策处理下载、购买和诊断信息。

### 服务器与第三方 Provider

SyncTV 服务器可依据其配置存储账号数据、房间内容、消息、播放历史和运行日志。你连接的媒体 Provider 与网站可能收到网络地址、请求 Header、账号凭据或 Provider Token。连接前请阅读服务器运营方和对应 Provider 的政策。

### 系统权限

SyncTV 仅在对应功能需要时请求摄像头、麦克风、本地网络和用户选择文件的访问权限。你可以在系统设置中管理这些权限；关闭权限会停用相关功能。

### 安全与保留

所选服务器和媒体源提供相应能力时，SyncTV 支持加密传输与平台安全功能。自托管管理员负责服务器安全、访问策略、备份和保留周期。本地缓存依据应用设置过期或淘汰；账号和房间数据遵循所选服务器的政策。

### 未成年人

SyncTV 是通用媒体同步工具，产品目标用户不包括 13 岁以下儿童。服务器运营方和用户负责遵守当地年龄与内容要求。

### 联系与变更

隐私问题或安全问题可通过 [SyncTV Issue Tracker](https://github.com/synctv-org/synctv/issues) 提交。本政策发生重大变更时，本文件会更新生效日期并公开发布。
