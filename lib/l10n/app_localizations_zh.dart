// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'SyncTV';

  @override
  String get appTagline => '让距离不再是距离';

  @override
  String get language => '语言';

  @override
  String get languageSettingsTitle => '显示语言';

  @override
  String get languageSettingsDescription => '选择 SyncTV 界面使用的语言。';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageChineseSimplified => '简体中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get server => '服务器';

  @override
  String get serverSettings => '服务器设置';

  @override
  String get openServerSettings => '打开服务器设置';

  @override
  String get joinRoom => '加入房间';

  @override
  String get createRoom => '创建房间';

  @override
  String get login => '登录';

  @override
  String get accountMenu => '账号菜单';

  @override
  String get accountCenter => '账号中心';

  @override
  String get adminSettings => '管理员设置';

  @override
  String get logout => '退出登录';

  @override
  String get capsLockOn => '大写锁定已开启';

  @override
  String get done => '完成';

  @override
  String get add => '添加';

  @override
  String get builtInLabel => '内置';

  @override
  String get switchServer => '切换';

  @override
  String get remove => '移除';

  @override
  String get processing => '正在处理';

  @override
  String get serverAddressRequired => '请输入服务器地址';

  @override
  String serverConnected(String serverName) {
    return '已连接 $serverName';
  }

  @override
  String serverConnectFailed(String error) {
    return '无法连接服务器：$error';
  }

  @override
  String serverSwitched(String serverName) {
    return '已切换到 $serverName';
  }

  @override
  String serverSwitchFailed(String error) {
    return '切换服务器失败：$error';
  }

  @override
  String get builtInServerCannotRemove => '内置服务器属于应用配置，无法移除';

  @override
  String get serverRemoved => '服务器已移除';

  @override
  String serverRemoveFailed(String error) {
    return '移除服务器失败：$error';
  }

  @override
  String get serverAddress => '服务器地址';

  @override
  String get serverAddressExample => '例如：https://tv.example.com';

  @override
  String get serverAutoDiscoverDescription =>
      '每个地址都会保存为独立服务器，账号、会话和缓存数据均按地址隔离。';

  @override
  String get serverAddressIdentityDescription =>
      '上方地址是本设备识别该服务器的身份；下方 ID 由服务器自行声明，其他地址也可能声明相同 ID。';

  @override
  String serverDeclaredId(String serverId) {
    return '服务器声明 ID：$serverId';
  }

  @override
  String get savedServers => '已保存服务器';

  @override
  String get noSavedServers => '还没有保存的服务器。添加服务器后即可登录和浏览公开房间。';

  @override
  String get currentServer => '当前服务器';

  @override
  String serverInfoFailed(String error) {
    return '服务器信息读取失败：$error';
  }

  @override
  String get refreshServerInfo => '刷新服务器信息';

  @override
  String openRoomFailed(String error) {
    return '打开房间失败：$error';
  }

  @override
  String loadRoomsFailed(String error) {
    return '加载房间列表失败：$error';
  }

  @override
  String get filterLabels => '筛选标签';

  @override
  String get noLabelsAvailable => '暂无可用标签';

  @override
  String get noLabelsForCategory => '当前分类下暂无标签';

  @override
  String get clear => '清空';

  @override
  String get apply => '应用';

  @override
  String get roomIdRequired => '请输入房间 ID';

  @override
  String get roomNotFound => '房间不存在';

  @override
  String get roomUnavailable => '房间暂不可用';

  @override
  String findRoomFailed(String error) {
    return '查找房间失败：$error';
  }

  @override
  String get logoutConfirmMessage => '确定要退出当前账号吗？';

  @override
  String get logoutAction => '退出';

  @override
  String get loggedOut => '已退出登录';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String joinRoomFailed(String error) {
    return '加入房间失败：$error';
  }

  @override
  String get deleteRoom => '删除房间';

  @override
  String deleteRoomConfirm(String roomName) {
    return '确定要删除房间“$roomName”吗？此操作无法撤销。';
  }

  @override
  String get delete => '删除';

  @override
  String get roomDeleted => '房间已删除';

  @override
  String deleteFailed(String error) {
    return '删除房间失败：$error';
  }

  @override
  String updateFavoriteFailed(String error) {
    return '更新收藏失败：$error';
  }

  @override
  String roomsPageSummary(int total, int page, int pageCount) {
    return '共 $total 个房间 · 第 $page / $pageCount 页';
  }

  @override
  String get searchRooms => '搜索房间';

  @override
  String get allCategories => '全部分类';

  @override
  String get labels => '标签';

  @override
  String selectedLabels(int count) {
    return '标签 $count';
  }

  @override
  String get clearRoomTaxonomyFilters => '清除分类和标签筛选';

  @override
  String get refresh => '刷新';

  @override
  String get addServerToStart => '添加服务器后开始使用';

  @override
  String get noRooms => '暂无房间';

  @override
  String get addServerDescription => '输入服务器地址即可浏览公开房间、登录账号和加入观影房间。';

  @override
  String get filteredRoomsEmptyDescription => '当前筛选下没有可显示的房间';

  @override
  String get addServer => '添加服务器';

  @override
  String get joinRoomSubtitle => '输入房间 ID，或粘贴邀请链接';

  @override
  String get inviteLinkServerHint => '邀请链接会自动识别服务器；本地存在多个匹配地址时，可在下一步选择。';

  @override
  String get roomIdOrInviteLink => '房间 ID 或邀请链接';

  @override
  String get roomIdOrInviteLinkHint => 'room_xxx 或 https://...';

  @override
  String get searching => '查找中';

  @override
  String get continueAction => '继续';

  @override
  String get enterRoomPassword => '输入房间密码';

  @override
  String get roomPassword => '房间密码';

  @override
  String get roomPasswordJoinHint => '输入密码后加入房间';

  @override
  String get incorrectRoomPassword => '房间密码错误';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get roomCreationDisabled => '服务器当前已关闭房间创建';

  @override
  String get roomSubmittedForReview => '房间已提交审核';

  @override
  String get roomCreated => '房间创建成功';

  @override
  String createRoomFailed(String error) {
    return '创建房间失败：$error';
  }

  @override
  String get roomNameRequired => '请输入房间名称';

  @override
  String roomNameTooLong(int maxLength) {
    return '房间名称不能超过 $maxLength 个字符';
  }

  @override
  String get roomPasswordRequired => '请输入房间密码';

  @override
  String get createPolicyLoadFailed => '无法读取服务器创建策略，请稍后重试。';

  @override
  String get roomCreationDisabledBanner => '服务器当前已关闭房间创建。';

  @override
  String get roomReviewRequiredBanner => '新房间需要审核。通过前仅管理员可以处理，普通用户暂时无法访问。';

  @override
  String get basicInformation => '基础信息';

  @override
  String get roomName => '房间名称';

  @override
  String get roomNameHint => '例如：周末电影夜';

  @override
  String get roomDescription => '房间简介';

  @override
  String get roomDescriptionHint => '可选，帮助成员理解这个房间的用途';

  @override
  String get accessMethod => '访问方式';

  @override
  String get roomVisibility => '房间可见性';

  @override
  String get publicRoomVisibilityDescription => '显示在公开列表中；开启访客加入后，匿名访客可访问';

  @override
  String get privateRoomVisibilityDescription => '不显示在公开列表中，匿名访客无法访问';

  @override
  String get passwordProtection => '密码保护';

  @override
  String get noRoomPassword => '无密码';

  @override
  String get noRoomPasswordJoinHint => '符合条件的成员无需密码即可加入';

  @override
  String get serverRequiresPassword => '服务器要求设置密码';

  @override
  String get membersEnterPassword => '成员加入时需要输入';

  @override
  String get creating => '创建中';

  @override
  String get roomCategory => '房间分类';

  @override
  String get taxonomyLoadFailedCreateAllowed => '分类信息读取失败，仍可继续创建房间。';

  @override
  String get noCategory => '不设置分类';

  @override
  String get roomLabels => '房间标签';

  @override
  String get loadingCreationPolicy => '正在读取服务器创建策略';

  @override
  String get creationPolicyUnavailable => '创建策略不可用';

  @override
  String get serverDisallowsNewRooms => '当前服务器不允许创建新房间';

  @override
  String get roomWillBeReviewed => '创建后将提交审核';

  @override
  String get passwordRoomAccessHint => '密码房间只允许知道密码的成员加入';

  @override
  String get publicRoomAccessHint => '公开房间可被允许访问的成员加入';

  @override
  String get privateRoomAccessHint => '此房间不会显示在公开列表中，匿名访客无法访问';

  @override
  String get createRoomSubtitle => '设置房间名称、可见性和密码保护';

  @override
  String get publicRoom => '公开房间';

  @override
  String get publicRoomJoinHint => '成员可直接申请或加入';

  @override
  String get passwordRoom => '密码房间';

  @override
  String get serverForbidsPassword => '服务器禁止设置密码';

  @override
  String get passwordRoomJoinHint => '成员需要密码才能进入';

  @override
  String get roomBanned => '已封禁';

  @override
  String get roomUnavailableShort => '不可用';

  @override
  String get roomJoinable => '可加入';

  @override
  String get roomGuestAccess => '游客可进入';

  @override
  String get featuredRooms => '精选房间';

  @override
  String get featuredRoomsDescription => '正在活跃的同步观影空间';

  @override
  String get continueWatchingRooms => '继续观看';

  @override
  String get continueWatchingRoomsDescription => '快速回到你已经加入的房间';

  @override
  String get popularRooms => '热门房间';

  @override
  String get popularRoomsDescription => '按在线热度、成员规模和近期活跃排序';

  @override
  String get roomJoined => '已加入';

  @override
  String get passwordRequiredShort => '需要密码';

  @override
  String get roomApprovalRequired => '需要审核';

  @override
  String get roomApprovalPending => '等待审核';

  @override
  String get roomJoinRequestSubmitted => '加入申请已提交，等待管理员审核';

  @override
  String get signInToJoin => '登录后加入';

  @override
  String get roomInvitationOnly => '仅限邀请';

  @override
  String get roomFull => '人数已满';

  @override
  String get roomJoinCooldown => '暂时无法加入';

  @override
  String roomPresenceSummary(int onlineMembers, int onlineGuests) {
    return '在线：成员 $onlineMembers · 游客 $onlineGuests';
  }

  @override
  String roomOnlineTotal(int count) {
    return '在线：$count';
  }

  @override
  String roomPresenceWithMembers(
    int onlineMembers,
    int onlineGuests,
    int memberCount,
  ) {
    return '在线成员 $onlineMembers · 在线游客 $onlineGuests · 共 $memberCount 名成员';
  }

  @override
  String roomConnections(int count) {
    return '$count 个连接';
  }

  @override
  String get removeFavorite => '取消收藏';

  @override
  String get favoriteRoom => '收藏房间';

  @override
  String get noDescription => '暂无简介';

  @override
  String get password => '密码';

  @override
  String get hidden => '隐藏';

  @override
  String get unknownCreator => '未知创建者';

  @override
  String get userAgreement => '用户使用协议';

  @override
  String get readAgreementToEnd => '请阅读到底部以继续';

  @override
  String get declineAndExit => '不同意并退出';

  @override
  String get agree => '同意';

  @override
  String authConfigLoadFailed(String error) {
    return '加载认证配置失败：$error';
  }

  @override
  String get acceptTermsFirst => '请先阅读并同意用户协议和隐私政策';

  @override
  String get registrationSubmitted => '注册申请已提交，等待管理员审核';

  @override
  String registrationSubmittedWithId(String reviewId) {
    return '注册申请已提交，等待管理员审核（$reviewId）';
  }

  @override
  String get emailRequired => '请输入邮箱';

  @override
  String get verificationCodeSent => '验证码已发送';

  @override
  String get emailAndCodeRequired => '请输入邮箱和验证码';

  @override
  String get emailOrUsernameRequired => '请输入邮箱或用户名';

  @override
  String get enterIdentifierFirst => '请先输入用户名或邮箱';

  @override
  String get usernameRequired => '请输入用户名';

  @override
  String get usernameAndEmailRequired => '请输入用户名和邮箱';

  @override
  String get registrationCodeSent => '注册验证码已发送';

  @override
  String get codeAndPasswordRequired => '请输入验证码和密码';

  @override
  String get authorizationPageOpenFailed => '无法打开授权页面';

  @override
  String get mfaEmailUnsupported => '当前账号不支持邮箱二次验证';

  @override
  String get mfaCodeSent => '二次验证码已发送';

  @override
  String get mfaCodeRequired => '请输入二次验证码';

  @override
  String get mfaPasskeyUnavailable => '当前账号没有可用的 Passkey';

  @override
  String get noLoginMethodAvailable => '当前账号在此设备上没有可用的登录方式';

  @override
  String get passwordResetSuccess => '密码已重置，请使用新密码登录';

  @override
  String get connectToSyncTv => '连接 SyncTV';

  @override
  String get noServerConnected => '未连接服务器';

  @override
  String get register => '注册';

  @override
  String get guest => '访客';

  @override
  String get emailOrUsername => '邮箱或用户名';

  @override
  String get verificationCode => '验证码';

  @override
  String waitingForAuthorization(String provider) {
    return '等待 $provider 授权完成';
  }

  @override
  String get registrationDisabled => '当前服务器未开放账号注册';

  @override
  String get emailRegistrationDisabled => '当前服务器未开放邮箱注册';

  @override
  String get forgotPassword => '忘记密码';

  @override
  String get getCodeFirst => '先获取验证码';

  @override
  String get send => '发送';

  @override
  String get emailCodeLogin => '验证码登录';

  @override
  String get passkeyLogin => '使用 Passkey 登录';

  @override
  String get passwordLogin => '密码登录';

  @override
  String get thirdPartyRegistration => '第三方注册';

  @override
  String get accountRegistration => '账号注册';

  @override
  String get usernameOrEmail => '用户名或邮箱';

  @override
  String get username => '用户名';

  @override
  String get includeEmail => '同时填写邮箱';

  @override
  String get includeEmailDescription => '可使用邮箱验证码完成注册。';

  @override
  String get email => '邮箱';

  @override
  String get createAccount => '创建账号';

  @override
  String get emailCodeRegistration => '邮箱验证码注册';

  @override
  String get createAccountWithEmailCode => '使用邮箱验证码创建账号';

  @override
  String get passkeyRegistration => 'Passkey 注册';

  @override
  String get registrationMethod => '注册方式';

  @override
  String get deviceNameHint => '设备名称，例如 MacBook 或手机';

  @override
  String get createPasskeyAccount => '创建 Passkey 账号';

  @override
  String get edit => '修改';

  @override
  String get guestAccessDescription =>
      '访客仅用于进入指定房间。公开房间列表无需登录，创建房间、账号中心和管理功能需要账号。';

  @override
  String get roomId => '房间 ID';

  @override
  String get guestAccessDisabled => '服务器未开放访客访问';

  @override
  String get enterAsGuest => '以访客身份进入';

  @override
  String get twoFactorVerification => '二次验证';

  @override
  String get additionalVerificationRequired => '当前账号需要额外验证。';

  @override
  String codeSentTo(String email) {
    return '验证码将发送到 $email';
  }

  @override
  String get getMfaCodeFirst => '先获取二次验证码';

  @override
  String get completeVerification => '完成验证';

  @override
  String get verifyWithPasskey => '使用 Passkey 验证';

  @override
  String get thirdPartyLogin => '第三方登录';

  @override
  String continueWithProvider(String provider) {
    return '使用 $provider 继续';
  }

  @override
  String get oauthCallbackUnavailable => '当前构建需要配置 App Link 或桌面回跳才能使用 OAuth2。';

  @override
  String get oauthAuthorizationTimedOut => '授权等待超时，请重试。';

  @override
  String providerReviewRequired(String provider) {
    return '$provider（注册需审核）';
  }

  @override
  String providerLoginOnly(String provider) {
    return '$provider（仅登录）';
  }

  @override
  String get acceptTermsSemantics => '同意用户协议和隐私政策';

  @override
  String get termsPrefix => '我已阅读并同意';

  @override
  String get userAgreementLink => '《用户协议》';

  @override
  String get and => '和';

  @override
  String get privacyPolicyLink => '《隐私政策》';

  @override
  String get passwordResetEmailSent => '密码重置邮件已发送';

  @override
  String passwordResetEmailFailed(String error) {
    return '发送重置邮件失败：$error';
  }

  @override
  String get resetFieldsRequired => '请输入邮箱、验证码和新密码';

  @override
  String get newPasswordsMismatch => '两次输入的新密码不一致';

  @override
  String get resetPassword => '重置密码';

  @override
  String get resetCode => '重置验证码';

  @override
  String get newPassword => '新密码';

  @override
  String get confirmNewPassword => '确认新密码';

  @override
  String get reset => '重置';

  @override
  String get agreementContent =>
      '# SyncTV 用户服务协议与隐私政策\n\n本应用是连接用户自有 SyncTV 服务器的客户端工具，不提供公共内容服务器，不存储、审核或运营用户服务器中的内容。\n\n用户应确保接入的服务器、房间和媒体内容具备合法授权，并自行承担服务器安全、账号安全、内容合规和数据备份责任。\n\n使用本应用登录、注册、访客访问或连接服务器，即表示你同意遵守相关法律法规，不利用本应用传播违法、有害、侵权或未授权内容。\n\n应用可能在本地保存服务器地址、登录令牌、访客令牌和基础偏好，用于保持登录状态与多服务器切换。这些数据仅存储在当前设备上。\n\nOAuth2 登录将跳转到浏览器或系统授权页面，并通过 App Link 或桌面本地回跳完成授权；应用不会要求用户手动填写回调地址或授权码。\n\n如不同意以上条款，请停止使用本应用。';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String get previousPage => '上一页';

  @override
  String get nextPage => '下一页';

  @override
  String get previousRooms => '上一组房间';

  @override
  String get nextRooms => '下一组房间';

  @override
  String get confirm => '确定';

  @override
  String get undo => '撤销';

  @override
  String get playlistEmpty => '播放列表为空';

  @override
  String get playlistEmptyDescription => '添加影片后即可同步观看';

  @override
  String get addMedia => '添加媒体';

  @override
  String get loadingVideo => '正在加载视频';

  @override
  String get waitingForPlayback => '等待播放';

  @override
  String get messageReadDetails => '消息阅读详情';

  @override
  String readCount(int count) {
    return '$count 已读';
  }

  @override
  String unreadCount(int count) {
    return '$count 未读';
  }

  @override
  String reactionMembers(String reaction) {
    return '$reaction 回应成员';
  }

  @override
  String memberCount(int count) {
    return '共 $count 人';
  }

  @override
  String get reactingMembers => '回应成员';

  @override
  String get loadMore => '加载更多';

  @override
  String get serverRequiredForInvite => '需要添加服务器';

  @override
  String get serverRequiredForInviteDescription =>
      '这个邀请来自另一个 SyncTV 服务器。请先添加该服务器地址，客户端会自动识别身份后继续加入房间。';

  @override
  String get chooseServerEndpoint => '选择访问地址';

  @override
  String get roomIdOrInviteRequired => '请输入房间 ID 或邀请链接';

  @override
  String processInviteFailed(String error) {
    return '处理邀请失败：$error';
  }

  @override
  String get editImage => '编辑图片';

  @override
  String imageCropFailed(String error) {
    return '图片裁剪失败：$error';
  }

  @override
  String get cropForPurpose => '按用途裁剪';

  @override
  String get squareCrop => '方形裁剪';

  @override
  String get uploadOriginalImage => '上传原图';

  @override
  String get useEditedImage => '使用编辑';

  @override
  String get imageSelectedDescription => '已选择图片，输入描述后发送';

  @override
  String get cancelImage => '取消图片';

  @override
  String get message => '消息';

  @override
  String get describeImage => '请描述图片...';

  @override
  String get enterMessage => '输入消息...';

  @override
  String get chooseImage => '选择图片';

  @override
  String get switchToVoice => '切换语音';

  @override
  String get releaseToCancel => '松开手指，取消发送';

  @override
  String get releaseToSendSwipeToCancel => '松开发送，上滑取消';

  @override
  String get holdToTalk => '按住说话';

  @override
  String get switchToText => '切换文字';

  @override
  String get noRealtimeEvents => '暂无实时事件';

  @override
  String get realtimeEventsCopied => '实时事件已复制';

  @override
  String get retentionCount => '保留条数';

  @override
  String get recentEventCount => '最近事件数量';

  @override
  String get eventCountRange => '范围 20-2000';

  @override
  String get save => '保存';

  @override
  String retainEvents(int count) {
    return '保留 $count 条';
  }

  @override
  String get customValue => '自定义...';

  @override
  String get viewChronologically => '按时间查看';

  @override
  String get groupByType => '按类型分组';

  @override
  String eventCount(int count) {
    return '$count 条事件';
  }

  @override
  String itemCount(int count) {
    return '$count 条';
  }

  @override
  String get copyEvents => '复制事件';

  @override
  String get clearEvents => '清空事件';

  @override
  String get moreActions => '更多操作';

  @override
  String get filterEventTypes => '筛选事件类型';

  @override
  String get eventTypeFilter => '事件类型过滤';

  @override
  String selectionCount(int selected, int total) {
    return '已选择 $selected / $total';
  }

  @override
  String get selectAll => '全选';

  @override
  String get allTypes => '全部类型';

  @override
  String filteredEventCount(int visible, int total) {
    return '$visible/$total 条';
  }

  @override
  String get realtimeEvents => '实时事件';

  @override
  String groupedEventCount(int groups, String events) {
    return '$groups 组 / $events';
  }

  @override
  String get copy => '复制';

  @override
  String get noFilteredRealtimeEvents => '当前过滤条件下暂无实时事件';

  @override
  String get sent => '发出';

  @override
  String get received => '收到';

  @override
  String latestAt(String time) {
    return '最新 $time';
  }

  @override
  String byteCount(int count) {
    return '$count bytes';
  }

  @override
  String get brightness => '亮度';

  @override
  String get volume => '音量';

  @override
  String brightnessPercent(int value) {
    return '亮度 $value%';
  }

  @override
  String volumePercent(int value) {
    return '音量 $value%';
  }

  @override
  String get unmute => '取消静音';

  @override
  String get mute => '静音';

  @override
  String get muted => '静音';

  @override
  String get chooseSubtitles => '选择字幕';

  @override
  String get disableSubtitles => '关闭字幕';

  @override
  String get danmaku => '弹幕';

  @override
  String get videoDanmaku => '视频弹幕';

  @override
  String get chatDanmaku => '聊天弹幕';

  @override
  String get danmakuHint => '发个弹幕见证当下...';

  @override
  String get pause => '暂停';

  @override
  String get play => '播放';

  @override
  String get info => '信息';

  @override
  String get live => '直播';

  @override
  String get playbackProgress => '播放进度';

  @override
  String get subtitles => '字幕';

  @override
  String get disableVideoDanmaku => '关闭视频弹幕';

  @override
  String get enableVideoDanmaku => '开启视频弹幕';

  @override
  String get disableChatDanmaku => '关闭聊天弹幕';

  @override
  String get enableChatDanmaku => '开启聊天弹幕';

  @override
  String get overlaySettings => '字幕与弹幕设置';

  @override
  String get subtitleSettings => '字幕设置';

  @override
  String get videoDanmakuSettings => '视频弹幕设置';

  @override
  String get chatDanmakuSettings => '聊天弹幕设置';

  @override
  String get subtitleStyle => '字幕样式';

  @override
  String get subtitleSize => '字幕大小';

  @override
  String get subtitleOpacity => '字幕透明度';

  @override
  String get subtitleBackground => '字幕背景';

  @override
  String get subtitlePosition => '字幕位置';

  @override
  String get subtitleColor => '字幕颜色';

  @override
  String get subtitleBackgroundColor => '字幕背景颜色';

  @override
  String get subtitleOutline => '字幕描边';

  @override
  String get videoDanmakuStyle => '视频弹幕样式';

  @override
  String get chatDanmakuStyle => '聊天弹幕样式';

  @override
  String get danmakuSize => '弹幕大小';

  @override
  String get danmakuOpacity => '弹幕透明度';

  @override
  String get danmakuSpeed => '弹幕速度';

  @override
  String get danmakuArea => '弹幕区域';

  @override
  String get danmakuOutline => '弹幕描边';

  @override
  String get danmakuMassiveMode => '海量弹幕';

  @override
  String get danmakuTop => '顶部弹幕';

  @override
  String get danmakuBottom => '底部弹幕';

  @override
  String get danmakuScroll => '滚动弹幕';

  @override
  String get resetOverlaySettings => '恢复默认样式';

  @override
  String get reload => '重新加载';

  @override
  String get sync => '同步';

  @override
  String get sendDanmaku => '发送弹幕';

  @override
  String get exitFullscreen => '退出全屏';

  @override
  String get fullscreen => '全屏';

  @override
  String get pictureInPicture => '画中画';

  @override
  String get exitPictureInPicture => '返回房间';

  @override
  String get loopPlayback => '循环播放';

  @override
  String get shufflePlayback => '随机播放';

  @override
  String get sequentialPlayback => '顺序播放';

  @override
  String get syncPlayback => '同步到房间进度';

  @override
  String get reloadLivePlayback => '重新加载直播';

  @override
  String get reloadPlaybackSource => '重新加载播放源';

  @override
  String get copyPlaybackDebugInfo => '复制调试信息';

  @override
  String get playbackDebugInfoCopied => '已复制播放器调试信息';

  @override
  String get detailedPlaybackStatistics => '详细播放统计';

  @override
  String playbackModeUpdated(String mode) {
    return '播放顺序：$mode';
  }

  @override
  String updatePlaybackModeFailed(String error) {
    return '更新播放顺序失败：$error';
  }

  @override
  String get playerResource => '资源';

  @override
  String get playerProvider => '提供方';

  @override
  String get playerPlaybackRoute => '播放线路';

  @override
  String get playerFormat => '格式';

  @override
  String get playerViewportVideo => '视口 / 视频';

  @override
  String get playerPlaybackState => '播放状态';

  @override
  String get playerBufferHealth => '缓冲余量';

  @override
  String get playerSpeedVolume => '速度 / 音量';

  @override
  String get playerSynchronization => '同步状态';

  @override
  String get playerThroughput => '吞吐 / 总量';

  @override
  String get playerP2pDelivery => 'P2P 分发';

  @override
  String get playerCache => '缓存 / 命中率';

  @override
  String get playerError => '播放器错误';

  @override
  String get playerStatePlaying => '播放中';

  @override
  String get playerStatePaused => '已暂停';

  @override
  String get playerStateBuffering => '缓冲中';

  @override
  String playerLatencyMilliseconds(int value) {
    return '延迟 $value 毫秒';
  }

  @override
  String playerDeviationMilliseconds(int value) {
    return '偏差 $value 毫秒';
  }

  @override
  String playerBufferRangeCount(int count) {
    return '$count 段';
  }

  @override
  String playerConnectedPeerCount(int count) {
    return '$count 个节点';
  }

  @override
  String get unknown => '未知';

  @override
  String get playbackSpeed => '倍速';

  @override
  String playbackSpeedValue(String speed) {
    return '倍速 ${speed}x';
  }

  @override
  String loadMediaBindingsFailed(String error) {
    return '获取媒体源绑定失败：$error';
  }

  @override
  String get directLink => '直链';

  @override
  String get rtmpPublishing => 'RTMP 推流';

  @override
  String get livePull => '直播拉流';

  @override
  String get alistStorage => 'AList 网盘';

  @override
  String get embyLibrary => 'Emby 媒体库';

  @override
  String get generatePublishingAddress => '生成推流地址';

  @override
  String get bilibiliLinkParsing => 'BV / 链接解析';

  @override
  String get mountedDirectoryResources => '挂载目录资源';

  @override
  String get personalMediaServer => '个人媒体服务器';

  @override
  String get source => '来源';

  @override
  String connectedMediaSources(int count) {
    return '已连接 $count 个媒体源';
  }

  @override
  String get mediaSource => '媒体源';

  @override
  String get playbackKind => '播放类型';

  @override
  String get onDemand => '点播';

  @override
  String get videoLinks => '视频链接';

  @override
  String get videoLinksHint => '每行一个 HTTP / HTTPS / HLS 地址';

  @override
  String get optionalVideoName => '视频名称（单条可选）';

  @override
  String get defaultsToFileName => '默认为文件名';

  @override
  String get playbackProxyMode => '播放线路';

  @override
  String get playbackProxyAuto => '自动';

  @override
  String get playbackProxyPrefer => '优先代理';

  @override
  String get playbackProxyOnly => '仅代理';

  @override
  String get playbackProxyDirectPrefer => '优先直连';

  @override
  String get playbackProxyDirectOnly => '仅直连';

  @override
  String get playbackProxyAutoDescription => '沿用媒体源的默认播放线路';

  @override
  String get playbackProxyPreferDescription => '同时保留直连与代理线路，并默认选择代理';

  @override
  String get playbackProxyOnlyDescription => '仅保留可由 SyncTV 服务端代理的播放线路';

  @override
  String get playbackProxyDirectPreferDescription => '同时保留直连与代理线路，默认使用直连';

  @override
  String get playbackProxyDirectOnlyDescription => '仅保留直连播放线路';

  @override
  String get playbackProxyDirectRisk =>
      '直连播放可能向房间成员暴露上游地址、签名链接、Token、Cookie 或授权请求头。请仅在可信房间和受控网络中启用。';

  @override
  String playbackProxyAutoEffective(
    Object mode,
    Object reason,
    Object variant,
  ) {
    return '$variant：$mode（$reason）';
  }

  @override
  String get playbackProxyReasonPublicResource => '公开资源';

  @override
  String get playbackProxyReasonRequestCredentials => '请求需要认证信息';

  @override
  String get playbackProxyReasonSignedResource => '签名资源';

  @override
  String get playbackProxyReasonProviderSession => 'provider 会话';

  @override
  String get playbackProxyReasonServerTransport => '服务端传输';

  @override
  String playbackProxyPolicyUnavailable(Object error) {
    return '播放线路策略暂时不可用：$error';
  }

  @override
  String get playbackProxyNoCompatibleMode => '此媒体源当前没有兼容的播放线路。';

  @override
  String get addToPlaylist => '添加到播放列表';

  @override
  String get requestHeaders => '请求头';

  @override
  String get noExtraRequestHeaders => '默认不发送额外请求头。';

  @override
  String get name => '名称';

  @override
  String get value => '值';

  @override
  String get removeRequestHeader => '移除请求头';

  @override
  String get liveName => '直播名称';

  @override
  String get liveNameHint => '例如 摄像机、OBS 推流';

  @override
  String get streamMode => '流模式';

  @override
  String get publishKeyType => '发布密钥类型';

  @override
  String get singleUsePublishKey => '一次性密钥';

  @override
  String get expiringPublishKey => '到期前可重复使用';

  @override
  String get permanentPublishKey => '永不过期';

  @override
  String get permanentPublishKeyDescription => '持有此密钥的用户可持续发布，直到服务端 JWT 密钥变更。';

  @override
  String get noExpiration => '永不过期';

  @override
  String get publishKeyExpirationMustBeFuture => '过期时间必须晚于当前时间。';

  @override
  String get audioAndVideo => '音频和视频';

  @override
  String get videoOnly => '仅视频';

  @override
  String get audioOnly => '仅音频';

  @override
  String get publishAddressGeneratedDescription => '创建后会生成推流地址和 Stream Key';

  @override
  String get copyToStreamingToolDescription => '复制到 OBS 或其他推流工具即可开始直播。';

  @override
  String get createPublishingEntry => '创建推流入口';

  @override
  String get sourceAddress => '源地址';

  @override
  String get liveSourceAddressHint => '请输入与所选协议匹配的地址';

  @override
  String get rtspTransport => 'RTSP 传输方式';

  @override
  String get videoTrack => '视频轨道';

  @override
  String get audioTrack => '音频轨道';

  @override
  String get firstCompatibleTrack => '首个兼容轨道';

  @override
  String get trackIndex => '轨道索引';

  @override
  String get optionalLiveName => '直播名称（可选）';

  @override
  String get optionalLiveNameHint => '例如 上游直播、赛事源';

  @override
  String get serverPullsUpstreamLiveSource => 'SyncTV 服务端会拉取上游直播源';

  @override
  String get livePullSupportDescription => '支持 RTMP、RTSP 和 HTTP-FLV 直播源。';

  @override
  String get addLivePull => '添加直播拉流';

  @override
  String get unknownTitle => '未知标题';

  @override
  String get bilibiliAccount => 'Bilibili 账号';

  @override
  String get bilibiliVideoLink => '视频链接 / BV号';

  @override
  String get bilibiliVideoLinkHint => '粘贴链接自动解析';

  @override
  String get parseBilibiliLink => '解析 Bilibili 链接';

  @override
  String get pasteBilibiliLink => '粘贴 Bilibili 链接';

  @override
  String get bilibiliSupportedLinks => '支持 BV 号、视频链接和直播间链接。';

  @override
  String get noFiles => '暂无文件';

  @override
  String get noMediaInDirectory => '当前目录没有可添加的媒体资源。';

  @override
  String get addAsDynamicPlaylist => '添加为动态播放列表';

  @override
  String addSelectedItems(int count) {
    return '添加选中的 $count 项';
  }

  @override
  String get noMedia => '暂无媒体';

  @override
  String get noMediaLibraryItems => '当前媒体库目录没有可添加的项目。';

  @override
  String get parentDirectory => '上级目录';

  @override
  String get parentPlaylist => '上级播放列表';

  @override
  String get mediaSourceAccount => '媒体源账号';

  @override
  String get searchCurrentDirectory => '搜索当前目录';

  @override
  String get directoryPassword => '目录密码';

  @override
  String get clearDirectoryPassword => '清除目录密码';

  @override
  String get searchMediaLibrary => '搜索媒体库';

  @override
  String videoNumber(int number) {
    return '视频 $number';
  }

  @override
  String liveRoomNumber(int number) {
    return '直播间 $number';
  }

  @override
  String get selectMedia => '选择媒体';

  @override
  String providerNotBound(String provider) {
    return '未绑定 $provider';
  }

  @override
  String get bindAccountToAccessResources => '请先绑定账号以访问资源';

  @override
  String bindProviderNow(String provider) {
    return '立即绑定 $provider';
  }

  @override
  String get localInstance => '本地实例';

  @override
  String get directLinkVideo => '直链视频';

  @override
  String get completeBlankRequestHeader => '请先填写当前空白请求头';

  @override
  String get completeRequestHeaderNameAndValue => '请填写完整的请求头名称和值';

  @override
  String duplicateRequestHeader(String name) {
    return '请求头 $name 重复';
  }

  @override
  String get discardCurrentEdits => '放弃当前编辑？';

  @override
  String get discardMediaDraftDescription => '已填写的媒体链接、直播源、名称或请求头会被清空。';

  @override
  String get continueEditing => '继续编辑';

  @override
  String get discard => '放弃';

  @override
  String get addedSuccessfully => '添加成功';

  @override
  String itemsAdded(int count) {
    return '已添加 $count 项';
  }

  @override
  String addFailed(String error) {
    return '添加失败：$error';
  }

  @override
  String get confirmAdd => '确认添加';

  @override
  String get enterHttpLinks => '请输入 http/https 链接';

  @override
  String get rtmpLive => 'RTMP 直播';

  @override
  String createPublishingEntryFailed(String error) {
    return '创建推流入口失败：$error';
  }

  @override
  String addLivePullFailed(String error) {
    return '添加直播拉流失败：$error';
  }

  @override
  String get enterLiveSourceAddress => '请输入直播源地址';

  @override
  String get enterValidLiveSourceAddress => '请输入有效的直播源地址';

  @override
  String get livePullUrlSupport => '地址需要匹配所选的 RTMP、RTSP 或 HTTP-FLV 协议';

  @override
  String get selectRtspTrack => '请至少启用一条 RTSP 轨道';

  @override
  String get enterValidTrackIndex => '请输入有效的轨道索引';

  @override
  String get publishingAddress => '推流地址';

  @override
  String get publishingHost => '发布主机';

  @override
  String get tsDisguise => 'TS 伪装';

  @override
  String get pngDisguiseEnabled => '启用 PNG 伪装';

  @override
  String get disabled => '未启用';

  @override
  String get expirationTime => '过期时间';

  @override
  String get currentStatus => '当前状态';

  @override
  String get active => '活跃';

  @override
  String get inactive => '未活跃';

  @override
  String get useServerPublishingHost => '使用服务端默认发布主机';

  @override
  String get liveSegmentsAsPng => '直播切片会以 PNG 形式分发';

  @override
  String get liveSegmentsAsTs => '直播切片按 TS 形式分发';

  @override
  String get copied => '已复制';

  @override
  String parseFailed(String error) {
    return '解析失败：$error';
  }

  @override
  String get bilibiliVideoInfoUnavailable => '无法获取 Bilibili 视频信息';

  @override
  String get bilibiliLiveRoomIdUnavailable => '无法获取 Bilibili 直播间 ID';

  @override
  String get bilibiliCidUnavailable => '无法获取 Bilibili CID';

  @override
  String get bilibiliIdentifiersUnavailable => '无法获取 BVID 或 CID';

  @override
  String loadFailed(String error) {
    return '加载失败：$error';
  }

  @override
  String get chooseBoundAlistAccount => '请选择已绑定的 AList 账号';

  @override
  String get dynamicPlaylistAdded => '已添加动态播放列表';

  @override
  String batchAddFailed(String error) {
    return '批量添加失败：$error';
  }

  @override
  String get chooseBoundEmbyAccount => '请选择已绑定的 Emby 账号';

  @override
  String get embyMediaIdUnavailable => '无法获取 Emby 媒体 ID';

  @override
  String get embyDirectoryIdUnavailable => '无法获取 Emby 目录 ID';

  @override
  String get manageConnections => '连接管理';

  @override
  String get bilibiliBound => 'Bilibili 已绑定';

  @override
  String loadProviderBindingsFailed(String provider, String error) {
    return '获取 $provider 绑定失败：$error';
  }

  @override
  String get confirmUnbind => '确认解绑';

  @override
  String confirmUnbindProvider(String provider) {
    return '确定要解除此 $provider 账号绑定吗？';
  }

  @override
  String get unbind => '解绑';

  @override
  String get unboundSuccessfully => '解绑成功';

  @override
  String unbindFailed(String error) {
    return '解绑失败：$error';
  }

  @override
  String bindProvider(String provider) {
    return '绑定 $provider';
  }

  @override
  String providerDetails(String provider) {
    return '$provider 详情';
  }

  @override
  String loadDetailsFailed(String error) {
    return '获取详情失败：$error';
  }

  @override
  String get rootDirectory => '根目录';

  @override
  String get mediaLibraryRoot => '媒体库根级';

  @override
  String get userId => '用户 ID';

  @override
  String get instance => '实例';

  @override
  String get loginStatus => '登录状态';

  @override
  String get loggedIn => '已登录';

  @override
  String get loggedOutStatus => '未登录';

  @override
  String get bilibiliVip => '大会员';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get bilibiliNotBound => '尚未绑定 Bilibili';

  @override
  String noBoundProviderAccounts(String provider) {
    return '暂无绑定的 $provider 账号';
  }

  @override
  String get details => '详情';

  @override
  String rebindProvider(String provider) {
    return '重新绑定 $provider';
  }

  @override
  String providerAccount(String provider, String serverId) {
    return '$provider 账号 $serverId';
  }

  @override
  String get bilibiliBoundDescription => '当前账号已完成 Bilibili 绑定，可继续查看状态或重新绑定。';

  @override
  String get bilibiliBindingDescription => '绑定后可解析 Bilibili 视频、番剧和直播资源。';

  @override
  String get viewStatus => '查看状态';

  @override
  String get rebind => '重新绑定';

  @override
  String loadMediaSourceInstancesFailed(String error) {
    return '获取媒体源实例失败：$error';
  }

  @override
  String get completeAllFields => '请填写完整信息';

  @override
  String get boundSuccessfully => '绑定成功';

  @override
  String bindingFailed(String error) {
    return '绑定失败：$error';
  }

  @override
  String get alistVersionRequirement => '仅支持 AList 3.25.0 及以上版本';

  @override
  String get connectionTarget => '连接目标';

  @override
  String providerAddress(String provider) {
    return '$provider 地址';
  }

  @override
  String get providerAddressHint => '127.0.0.1 或 https://example.com';

  @override
  String get port => '端口';

  @override
  String get loginCredentials => '登录凭据';

  @override
  String get twoFactorAuthentication => '双因素验证';

  @override
  String get oneTimeCode => '一次性验证码';

  @override
  String get oneTimeCodeHint => '启用 2FA 时填写';

  @override
  String get totpSecretHint => '可选，用于后续自动刷新';

  @override
  String get creatingLoginLink => '正在创建登录链接...';

  @override
  String get completeBilibiliLogin => '请在浏览器或 Bilibili App 中完成登录';

  @override
  String createLoginLinkFailed(String error) {
    return '创建登录链接失败：$error';
  }

  @override
  String get loginLinkExpired => '登录链接已过期，请重新生成';

  @override
  String get qrScannedConfirmLogin => '已扫码，请在 Bilibili 中确认登录';

  @override
  String get waitingForQrScan => '等待扫码或打开链接登录';

  @override
  String get waitingForBilibiliStatus => '等待 Bilibili 返回登录状态';

  @override
  String get bilibiliStatusRateLimited => 'Bilibili 登录状态检查过于频繁，请稍后重新生成登录链接';

  @override
  String checkLoginStatusFailed(String error) {
    return '检查登录状态失败：$error';
  }

  @override
  String get openLoginLinkFailed => '无法打开登录链接';

  @override
  String get loginLinkCopied => '登录链接已复制';

  @override
  String get switchToQrPrompt => '切换到扫码页后生成登录二维码';

  @override
  String get qrCode => '扫码';

  @override
  String get copyLink => '复制链接';

  @override
  String get openLogin => '打开登录';

  @override
  String get regenerate => '重新生成';

  @override
  String get switchToCodePrompt => '切换到验证码页后准备安全验证';

  @override
  String get preparingSecurityVerification => '正在准备安全验证...';

  @override
  String get enterPhoneForSecurityVerification => '输入手机号后完成安全验证，即可发送短信验证码';

  @override
  String prepareSecurityVerificationFailed(String error) {
    return '安全验证准备失败：$error';
  }

  @override
  String get enterPhoneNumber => '请输入手机号';

  @override
  String get completeBilibiliSecurityVerification => '请完成 Bilibili 安全验证';

  @override
  String get smsCodeSent => '短信验证码已发送';

  @override
  String get verificationSessionExpired => '验证会话已失效，请重新开始短信登录';

  @override
  String sendSmsFailed(String error) {
    return '短信发送失败：$error';
  }

  @override
  String get sendSmsFirst => '请先发送短信验证码';

  @override
  String get enterSmsCode => '请输入短信验证码';

  @override
  String get completingBilibiliBinding => '正在完成 Bilibili 绑定...';

  @override
  String get loginSessionExpired => '登录会话已失效，请重新验证后发送短信';

  @override
  String get authenticationSessionExpired => '认证会话已失效，请重新开始。';

  @override
  String get phoneNumber => '手机号';

  @override
  String get bilibiliPhoneHint => '请输入 Bilibili 绑定手机号';

  @override
  String get smsVerificationCode => '短信验证码';

  @override
  String get enterReceivedCode => '请输入收到的验证码';

  @override
  String get enterCodeAfterSms => '发送短信后填写验证码';

  @override
  String get verifyAgain => '重新验证';

  @override
  String get sendSms => '发送短信';

  @override
  String get bind => '绑定';

  @override
  String get mediaSourceInstance => '媒体源实例';

  @override
  String get loginExpired => '登录已过期，请重新登录';

  @override
  String get connectionClosedRetry => '连接断开，请退出重试';

  @override
  String get playbackResource => '播放资源';

  @override
  String get playlist => '播放列表';

  @override
  String errorMessage(String message) {
    return '错误：$message';
  }

  @override
  String get messageDeleted => '消息已删除';

  @override
  String get imageMessage => '[图片]';

  @override
  String get genericMessage => '[消息]';

  @override
  String get quotedMessageUnavailable => '引用消息不在当前可查看范围';

  @override
  String loadQuotedContextFailed(String error) {
    return '加载引用上下文失败：$error';
  }

  @override
  String serverSnapshotMissing(String resource) {
    return '服务端未推送$resource快照';
  }

  @override
  String latencyValue(String value) {
    return '延迟 $value';
  }

  @override
  String get serverLatency => '服务器延迟';

  @override
  String deviationValue(String value) {
    return '偏差 $value';
  }

  @override
  String get playbackDeviation => '播放偏差';

  @override
  String get playbackUpdateFailed => '播放状态更新失败';

  @override
  String switchedToPlaybackRoute(String route) {
    return '已切换到 $route';
  }

  @override
  String get playbackRoute => '播放线路';

  @override
  String get route => '线路';

  @override
  String get qualityAndMediaLinks => '画质与媒体链接';

  @override
  String get manifestQualities => '清单内画质';

  @override
  String get automatic => '自动';

  @override
  String get selectPlaybackRoute => '选择线路';

  @override
  String get playbackRouteMain => '主线路';

  @override
  String playbackRouteBackup(int index) {
    return '备用线路 $index';
  }

  @override
  String get playbackRouteOriginal => '原始';

  @override
  String get playbackRouteProgressive => '普通视频';

  @override
  String get playbackRouteTranscoded => '转码';

  @override
  String get playbackRouteVideoHls => '视频 HLS';

  @override
  String get playbackRouteAudioHls => '音频 HLS';

  @override
  String qualityTrack(String id) {
    return '画质 $id';
  }

  @override
  String get back => '返回';

  @override
  String get freeModeSettings => '自由模式设置';

  @override
  String get stop => '停止';

  @override
  String get stopPlayback => '停止播放';

  @override
  String get roomManagement => '房间管理';

  @override
  String get unknownVideo => '未知影片';

  @override
  String get roomCollaboration => '房间协作';

  @override
  String peopleCount(int count) {
    return '$count 人';
  }

  @override
  String get copyInviteLink => '复制邀请链接';

  @override
  String get syncedToLatestProgress => '已同步到最新进度';

  @override
  String get playbackAddressReloaded => '已重新加载播放地址';

  @override
  String get reloadPlaybackAddressFailed => '重新加载播放地址失败';

  @override
  String secondsValue(String value) {
    return '$value 秒';
  }

  @override
  String get freeMode => '自由模式';

  @override
  String get freeModeDescription => '保持本地播放进度独立于房间实时纠偏，仍可使用手动同步';

  @override
  String get syncCorrectionThreshold => '房间同步纠偏阈值';

  @override
  String get manualSyncDriftThreshold => '手动同步触发误差';

  @override
  String get restoreDefaults => '恢复默认';

  @override
  String get freeModeSettingsSaved => '自由模式设置已保存';

  @override
  String get loadMemberListFailed => '成员列表加载失败';

  @override
  String sendDanmakuFailed(String error) {
    return '弹幕发送失败：$error';
  }

  @override
  String get chat => '聊天';

  @override
  String get list => '列表';

  @override
  String get members => '成员';

  @override
  String get realtime => '实时';

  @override
  String get realtimeEventsWebSocketDescription => '实时事件会在收发 WebSocket 消息后显示';

  @override
  String get scrollToBottom => '滚动到底部';

  @override
  String get pinned => '置顶';

  @override
  String get refreshPinnedMessages => '刷新置顶消息';

  @override
  String get unpin => '取消置顶';

  @override
  String replyingTo(String user) {
    return '回复 $user';
  }

  @override
  String get cancelReply => '取消回复';

  @override
  String get edited => '已编辑';

  @override
  String get mentionRead => '@ 已读';

  @override
  String get read => '已读';

  @override
  String readUnreadSummary(int read, int unread) {
    return '$read 已读 · $unread 未读';
  }

  @override
  String get viewMentionReadDetails => '查看 @ 已读详情';

  @override
  String get viewReadDetails => '查看阅读详情';

  @override
  String get mentionUnread => '@ 未读';

  @override
  String mentionReadUnreadSummary(int read, int unread) {
    return '@ $read 已读 · $unread 未读';
  }

  @override
  String loadReadDetailsFailed(String error) {
    return '加载已读详情失败：$error';
  }

  @override
  String get quotedMessage => '引用消息';

  @override
  String get loadingQuotedMessage => '正在加载引用消息...';

  @override
  String get jumpToQuotedMessage => '跳转到引用消息';

  @override
  String get reactionSelectedHint => '点击取消回应，长按查看成员';

  @override
  String get reactionUnselectedHint => '点击添加回应，长按查看成员';

  @override
  String get react => '表情回应';

  @override
  String get reply => '回复';

  @override
  String get pin => '置顶';

  @override
  String get report => '举报';

  @override
  String removeReaction(String reaction) {
    return '取消回应 $reaction';
  }

  @override
  String addReaction(String reaction) {
    return '回应 $reaction';
  }

  @override
  String get closeMessageActions => '关闭消息操作';

  @override
  String reactionFailed(String error) {
    return '表情回应失败：$error';
  }

  @override
  String get noCopyableMessageText => '这条消息没有可复制文本';

  @override
  String get messageCopied => '消息已复制';

  @override
  String get messageUnpinned => '已取消置顶';

  @override
  String get messagePinned => '消息已置顶';

  @override
  String unpinMessageFailed(String error) {
    return '取消置顶失败：$error';
  }

  @override
  String pinMessageFailed(String error) {
    return '置顶消息失败：$error';
  }

  @override
  String deleteMessageFailed(String error) {
    return '删除消息失败：$error';
  }

  @override
  String get reportMessage => '举报消息';

  @override
  String get reportMember => '举报成员';

  @override
  String get reportUser => '举报用户';

  @override
  String get reportReasonSpam => '垃圾广告';

  @override
  String get reportReasonAbuse => '辱骂骚扰';

  @override
  String get reportReasonIllegal => '违法违规';

  @override
  String get reportReasonSexual => '低俗色情';

  @override
  String get reportReasonOther => '其他问题';

  @override
  String get additionalDetails => '补充说明';

  @override
  String get describeIssue => '描述具体问题';

  @override
  String get submit => '提交';

  @override
  String get reportSubmitted => '举报已提交';

  @override
  String reportFailed(String error) {
    return '举报失败：$error';
  }

  @override
  String voiceConnected(int count) {
    return '语音已连接（$count 人）';
  }

  @override
  String voiceConnectedMuted(int count) {
    return '语音已连接（$count 人）（静音）';
  }

  @override
  String waitingToJoinVoice(int count) {
    return '等待加入...（$count 人）';
  }

  @override
  String waitingToJoinVoiceMuted(int count) {
    return '等待加入...（$count 人）（静音）';
  }

  @override
  String get voiceChat => '语音聊天';

  @override
  String get roomRealtimeFeatures => '实时通信';

  @override
  String get voiceChatRoomEnabledDescription => '允许成员在此房间加入语音通话';

  @override
  String get voiceChatDisabledByRoom => '房间管理员已关闭语音通话';

  @override
  String get p2pMedia => 'P2P 媒体传输';

  @override
  String get p2pMediaRoomEnabledDescription => '允许成员在此房间通过 Peer 共享媒体数据';

  @override
  String get p2pMediaDisabledByRoom => '房间管理员已关闭 P2P 媒体传输';

  @override
  String get p2pMediaDescription =>
      '与房间成员直连共享缓存媒体。Peer 可看到你的网络地址并使用上行带宽。Swarm ticket 用于隔离房间、用户和资源。';

  @override
  String get p2pCacheSize => '缓存容量';

  @override
  String get p2pCacheSizeDescription => '跨播放会话复用的持久化 LRU 缓存。条目连续 10 分钟未访问后过期。';

  @override
  String get p2pSecurityMode => 'Peer 数据校验';

  @override
  String get p2pSecurityStandard => '标准';

  @override
  String get p2pSecurityStandardDescription =>
      '检查传输帧、声明长度、大小上限与超时。安全校验本身不增加网络流量；调度仍可能并行竞速来源与 Peer。';

  @override
  String get p2pSecuritySampled => '来源抽样';

  @override
  String get p2pSecuritySampledDescription =>
      '使用 SHA-256 对比 10% 的 Peer 分片与来源数据，并在当前 swarm 会话隔离冲突 Peer。';

  @override
  String get p2pIntegrityChecks => '完整性检查';

  @override
  String get p2pIntegrityMismatches => '完整性冲突';

  @override
  String get p2pIntegrityUnavailable => '来源校验不可用';

  @override
  String get p2pMetrics => 'P2P 传输指标';

  @override
  String get totalDownload => '总下载';

  @override
  String get totalUpload => '总上传';

  @override
  String get httpDownload => 'HTTP 下载';

  @override
  String get p2pDownload => 'P2P 下载';

  @override
  String get p2pUpload => 'P2P 上传';

  @override
  String get connectedPeers => '已连接节点';

  @override
  String get p2pCache => '缓存数据';

  @override
  String get cacheHitRate => '缓存命中率';

  @override
  String get leaveVoice => '退出语音';

  @override
  String get joining => '加入中';

  @override
  String get join => '加入';

  @override
  String get joinVoiceTimeout => '加入语音超时，请检查麦克风权限';

  @override
  String joinVoiceFailed(String error) {
    return '加入语音失败：$error';
  }

  @override
  String get cancelSelection => '取消选择';

  @override
  String get batchManage => '批量管理';

  @override
  String get compactList => '紧凑列表';

  @override
  String get detailedList => '详细列表';

  @override
  String get grid => '网格';

  @override
  String get sourceType => '来源类型';

  @override
  String get sourcePath => '路径';

  @override
  String get sourceQuery => '查询';

  @override
  String get sharedSource => '共享来源';

  @override
  String get shareMyCredentials => '共享我的凭证';

  @override
  String get parseLink => '解析链接';

  @override
  String get preview => '预览';

  @override
  String get noItems => '暂无内容';

  @override
  String get addCurrentList => '添加当前列表';

  @override
  String addSelectedCount(int count) {
    return '添加选中项（$count）';
  }

  @override
  String selectItem(String name) {
    return '选择$name';
  }

  @override
  String get playlistName => '播放列表名称';

  @override
  String get providerInstance => 'Provider 实例';

  @override
  String get defaultMediaSource => '默认媒体源';

  @override
  String get defaultProviderInstance => '默认实例';

  @override
  String get video => '视频';

  @override
  String get videos => '视频';

  @override
  String get shorts => '短视频';

  @override
  String get posts => '作品';

  @override
  String get channel => '频道';

  @override
  String get search => '搜索';

  @override
  String get subscriptions => '订阅内容';

  @override
  String get likedVideos => '喜欢的视频';

  @override
  String get watchLater => '稍后再看';

  @override
  String get movie => '电影';

  @override
  String get movies => '电影';

  @override
  String get episode => '剧集';

  @override
  String get episodes => '剧集';

  @override
  String get audio => '音频';

  @override
  String get folder => '文件夹';

  @override
  String get series => '系列';

  @override
  String get bangumi => '番剧';

  @override
  String get vod => '回放';

  @override
  String get popular => '热门';

  @override
  String get recommended => '推荐';

  @override
  String get videoParts => '视频分P';

  @override
  String get creatorVideos => 'UP主投稿';

  @override
  String get favoriteVideos => '收藏夹视频';

  @override
  String get collectionVideos => '合集视频';

  @override
  String get seriesVideos => '系列视频';

  @override
  String get pgcSeason => '番剧季度';

  @override
  String get liveRecommended => '直播推荐';

  @override
  String get liveFollowed => '关注的直播';

  @override
  String get liveArea => '直播分区';

  @override
  String get history => '观看历史';

  @override
  String get pgcTimeline => '番剧时间表';

  @override
  String get pgcIndex => '番剧索引';

  @override
  String get followedAnime => '追番';

  @override
  String get followedCinema => '追剧';

  @override
  String get ongoing => '连载中';

  @override
  String get finished => '已完结';

  @override
  String get keyword => '关键词';

  @override
  String get liveCategory => '直播分区';

  @override
  String get liveSubcategory => '直播子分区';

  @override
  String get favoriteFolder => '收藏夹';

  @override
  String get privateLabel => '私密';

  @override
  String get continueWatching => '继续观看';

  @override
  String get nextUp => '下一集';

  @override
  String get recentlyAdded => '最近添加';

  @override
  String get favoritePeople => '收藏的演员';

  @override
  String get serverPlaylists => '服务器播放列表';

  @override
  String get collections => '合集';

  @override
  String get genres => '类型';

  @override
  String get files => '文件';

  @override
  String get mediaLibrary => '媒体库';

  @override
  String get favorites => '收藏';

  @override
  String get starred => '已加星标';

  @override
  String get libraries => '资料库';

  @override
  String get tvShows => '电视节目';

  @override
  String get homeVideos => '家庭视频';

  @override
  String get tvRecordings => '电视录制';

  @override
  String get mediaUrl => '媒体链接';

  @override
  String get channelArchive => '频道归档';

  @override
  String get followedLive => '关注的直播';

  @override
  String get categoryLive => '按分类浏览直播';

  @override
  String get searchLive => '搜索直播频道';

  @override
  String get highlights => '精彩片段';

  @override
  String get uploads => '上传内容';

  @override
  String get clips => '剪辑';

  @override
  String get loadCategories => '加载分类';

  @override
  String get noScheduledStreams => '暂无预定直播';

  @override
  String get videoUrlOrId => '视频链接或 ID';

  @override
  String get playlistUrlOrId => '播放列表链接或 ID';

  @override
  String get channelUrlOrId => '频道链接或 ID';

  @override
  String get searchQueryLabel => '搜索关键词';

  @override
  String get liveUrlOrId => '直播链接或 ID';

  @override
  String get authorIdentifier => '创作者标识';

  @override
  String get liveVodClipUrl => '直播、回放或剪辑链接';

  @override
  String get channelNameOrUrl => '频道名称或链接';

  @override
  String get channelSearch => '搜索频道';

  @override
  String get creatorSecUid => '创作者 sec_uid';

  @override
  String get usernameOrHandle => '用户名或 @账号';

  @override
  String get videoUrlShortLinkOrId => '视频链接、短链或 ID';

  @override
  String get liveUrlOrRoomId => '直播链接或房间 ID';

  @override
  String get noPosts => '暂无作品';

  @override
  String get noTwitchItems => '暂无 Twitch 内容';

  @override
  String get schedule => '直播日程';

  @override
  String get recurring => '定期直播';

  @override
  String get clip => '剪辑';

  @override
  String viewsCount(int count) {
    return '$count 次观看';
  }

  @override
  String viewersCount(int count) {
    return '$count 人观看';
  }

  @override
  String get previewSourceFirst => '请先预览来源';

  @override
  String get embyAccount => 'Emby 账号';

  @override
  String get listSourceToPreview => '列出来源后可预览内容';

  @override
  String get acfunUrl => 'AcFun 链接';

  @override
  String get cctvUrlOrVideoId => 'CCTV 链接或视频 ID';

  @override
  String get liveRoomOrVideoUrl => '直播间或视频链接';

  @override
  String get roomIdAliasOrUrl => '房间 ID、别名或链接';

  @override
  String get embyDiscoveryAndLists => '发现与列表';

  @override
  String get noPreparedLinks => '暂无已解析链接';

  @override
  String get fileStation => '文件管理';

  @override
  String get videoStation => '视频管理';

  @override
  String get library => '媒体库';

  @override
  String get selectLibraryFirst => '请先选择资料库';

  @override
  String unlockLibrary(String name) {
    return '解锁 $name';
  }

  @override
  String get libraryPassword => '资料库密码';

  @override
  String get unlock => '解锁';

  @override
  String get enterAtLeastThreeCharacters => '请输入至少 3 个字符';

  @override
  String get favorite => '收藏';

  @override
  String get markWatched => '标记为已观看';

  @override
  String get markUnwatched => '标记为未观看';

  @override
  String get encrypted => '已加密';

  @override
  String get openFolder => '打开文件夹';

  @override
  String get sharedFolders => '共享文件夹';

  @override
  String get shares => '共享目录';

  @override
  String get allFiles => '全部文件';

  @override
  String readyQualities(String qualities) {
    return '已就绪：$qualities';
  }

  @override
  String formatsCount(int count) {
    return '$count 种格式';
  }

  @override
  String subtitlesCount(int count) {
    return '$count 种字幕';
  }

  @override
  String variantsCount(int count) {
    return '$count 个媒体变体';
  }

  @override
  String qualitiesCount(int count) {
    return '$count 种清晰度';
  }

  @override
  String chaptersCount(int count) {
    return '$count 个章节';
  }

  @override
  String watermarkFreeCount(int count) {
    return '$count 个无水印变体';
  }

  @override
  String get storyboard => '故事板';

  @override
  String get hotLabel => '热门';

  @override
  String get anime => '番剧';

  @override
  String get cinema => '影视';

  @override
  String get guochuang => '国创';

  @override
  String get documentary => '纪录片';

  @override
  String get television => '电视剧';

  @override
  String get variety => '综艺';

  @override
  String get updated => '最近更新';

  @override
  String get plays => '播放量';

  @override
  String get followers => '追番人数';

  @override
  String get score => '评分';

  @override
  String get started => '开播时间';

  @override
  String get released => '上映时间';

  @override
  String get timeline => '时间表';

  @override
  String get daysBefore => '向前天数';

  @override
  String get daysAfter => '向后天数';

  @override
  String get sortOrder => '排序方式';

  @override
  String get statusLabel => '状态';

  @override
  String get area => '地区';

  @override
  String get yearOrRange => '年份或范围';

  @override
  String get styleId => '风格 ID';

  @override
  String get delayed => '延期';

  @override
  String get published => '已发布';

  @override
  String get videoBvid => '视频 BV 号';

  @override
  String get videoAidOptional => '视频 AV 号（可选）';

  @override
  String get creatorMid => '创作者 UID';

  @override
  String get seasonId => '季度 ID';

  @override
  String get collectionSeasonId => '合集 ID';

  @override
  String get seriesId => '系列 ID';

  @override
  String get multipleRoutes => '多线路';

  @override
  String get proxy => '代理';

  @override
  String get openable => '可进入';

  @override
  String get dynamicPlaylist => '动态播放列表';

  @override
  String get dynamicMedia => '动态媒体';

  @override
  String get media => '媒体';

  @override
  String onlineMembers(int count) {
    return '在线成员（$count）';
  }

  @override
  String get makeAdmin => '设为管理员';

  @override
  String get removeAdmin => '取消管理员';

  @override
  String get removeMember => '移除成员';

  @override
  String get me => '我';

  @override
  String get administrator => '管理员';

  @override
  String onlineConnections(int count) {
    return '在线 · $count 连接';
  }

  @override
  String offlineJoinedAt(String date) {
    return '离线 · 加入于 $date';
  }

  @override
  String get playlistSubscribeFailed => '播放列表订阅失败';

  @override
  String get playlistBrowseAccessDenied => '你没有权限浏览此播放列表';

  @override
  String get switchedAndPlaying => '已切换并播放';

  @override
  String switchFailed(String error) {
    return '切换失败：$error';
  }

  @override
  String get deleteEntries => '删除条目';

  @override
  String confirmDeleteMediaEntries(int count) {
    return '确定要删除选中的 $count 个媒体条目吗？';
  }

  @override
  String get dynamicPlaylistCannotDelete => '动态播放列表内容不能在房间内删除';

  @override
  String get deleted => '已删除';

  @override
  String deleteEntryFailed(String error) {
    return '删除失败：$error';
  }

  @override
  String get playbackStopped => '已停止播放';

  @override
  String stopPlaybackFailed(String error) {
    return '停止播放失败：$error';
  }

  @override
  String get roomManagersOnly => '仅房主和管理员可管理房间';

  @override
  String loadSettingsFailed(String error) {
    return '获取设置失败：$error';
  }

  @override
  String confirmMakeAdmin(String user) {
    return '确定要将 $user 设为管理员吗？\n管理员拥有踢人、管理成员等权限。';
  }

  @override
  String madeAdmin(String user) {
    return '已将 $user 设为管理员';
  }

  @override
  String settingFailed(String error) {
    return '设置失败：$error';
  }

  @override
  String confirmRemoveAdmin(String user) {
    return '确定要取消 $user 的管理员权限吗？';
  }

  @override
  String removedAdmin(String user) {
    return '已取消 $user 的管理员权限';
  }

  @override
  String cancelActionFailed(String error) {
    return '取消失败：$error';
  }

  @override
  String get memberKicked => '已踢出成员';

  @override
  String kickMemberFailed(String error) {
    return '踢出失败：$error';
  }

  @override
  String get kickMember => '踢出成员';

  @override
  String confirmKickMember(String user) {
    return '确定要踢出 $user，并设置重新加入冷却时间。';
  }

  @override
  String get cooldownSeconds => '冷却秒数';

  @override
  String get cooldownSecondsRange => '请输入 1 到 2592000 之间的秒数';

  @override
  String get kick => '踢出';

  @override
  String chooseImageFailed(String error) {
    return '选择图片失败：$error';
  }

  @override
  String sendFailed(String error) {
    return '发送失败：$error';
  }

  @override
  String get overview => '概览';

  @override
  String get profile => '资料';

  @override
  String get rooms => '房间';

  @override
  String get security => '安全';

  @override
  String get notifications => '通知';

  @override
  String get bindings => '绑定';

  @override
  String get accountPreferences => '账号偏好';

  @override
  String get accountPreferencesUnavailableImpact => '多因素认证状态、通知偏好和安全能力判断不可用。';

  @override
  String get notificationCenter => '通知中心';

  @override
  String get notificationsUnavailableImpact => '未读数量、通知列表、标记已读和删除通知不可用。';

  @override
  String get myRooms => '我的房间';

  @override
  String get myRoomsUnavailableImpact => '账号中心内的房间列表、房间搜索和房间管理不可用。';

  @override
  String get oauthAvailableAccounts => 'OAuth2 可绑定账号';

  @override
  String get oauthProvidersUnavailableImpact => '无法展示可绑定的第三方登录 Provider。';

  @override
  String get oauthLinkedAccounts => 'OAuth2 已绑定账号';

  @override
  String get oauthLinksUnavailableImpact => '无法查看或解除已经绑定的第三方登录账号。';

  @override
  String get passkeyCredentials => 'Passkey 凭据';

  @override
  String get passkeysUnavailableImpact => '无法查看、绑定或删除服务器上的 Passkey 凭据。';

  @override
  String get localPasskeyCapability => '本机 Passkey 能力';

  @override
  String get localPasskeyUnavailableImpact => '无法确认当前设备是否支持创建 Passkey。';

  @override
  String get serverPublicSettings => '服务器公开设置';

  @override
  String get publicSettingsUnavailableImpact => '无法判断邮箱和 Passkey 当前是否启用。';

  @override
  String get notBound => '未绑定';

  @override
  String get bound => '已绑定';

  @override
  String loadAccountFailed(String error) {
    return '加载账号信息失败：$error';
  }

  @override
  String get changeUsername => '修改用户名';

  @override
  String get changeUsernameDescription => '设置这个服务器上的公开用户名';

  @override
  String get usernameUpdated => '用户名已更新';

  @override
  String updateUsernameFailed(String error) {
    return '更新用户名失败：$error';
  }

  @override
  String get avatarUpdated => '头像已更新';

  @override
  String updateAvatarFailed(String error) {
    return '更新头像失败：$error';
  }

  @override
  String get removeAvatar => '移除头像';

  @override
  String get confirmRemoveAvatar => '确认移除当前头像吗？账号将恢复使用默认头像。';

  @override
  String get avatarRemoved => '头像已移除';

  @override
  String removeAvatarFailed(String error) {
    return '移除头像失败：$error';
  }

  @override
  String get notificationPreferencesSaved => '通知偏好已保存';

  @override
  String saveNotificationPreferencesFailed(String error) {
    return '保存通知偏好失败：$error';
  }

  @override
  String get mfaSettingsSaved => '多因素认证设置已保存';

  @override
  String saveMfaSettingsFailed(String error) {
    return '保存多因素认证设置失败：$error';
  }

  @override
  String get unbindEmail => '解绑邮箱';

  @override
  String get unbindEmailDescription => '解绑后将无法继续使用这个邮箱接收验证码、邮件通知或密码重置邮件。';

  @override
  String get emailUnbound => '邮箱已解绑';

  @override
  String unbindEmailFailed(String error) {
    return '解绑邮箱失败：$error';
  }

  @override
  String get emailBound => '邮箱已绑定';

  @override
  String get noPasswordVerificationMethod => '当前账号没有可用的密码验证方式';

  @override
  String get passwordUpdated => '密码已更新';

  @override
  String updatePasswordFailed(String error) {
    return '更新密码失败：$error';
  }

  @override
  String get accountHasNoEmail => '当前账号没有邮箱';

  @override
  String get passwordReset => '密码已重置';

  @override
  String resetPasswordFailed(String error) {
    return '重置密码失败：$error';
  }

  @override
  String get deletePasskey => '删除 Passkey';

  @override
  String confirmDeletePasskey(String name) {
    return '确定删除“$name”吗？删除后这台设备将不能继续使用该 Passkey 登录。';
  }

  @override
  String get passkeyDeleted => 'Passkey 已删除';

  @override
  String deletePasskeyFailed(String error) {
    return '删除 Passkey 失败：$error';
  }

  @override
  String get bindPasskey => '绑定 Passkey';

  @override
  String get bindPasskeyDescription => '为当前设备创建一个可识别的名称';

  @override
  String get deviceName => '设备名称';

  @override
  String get deviceNameExample => '例如 MacBook、手机';

  @override
  String get passkeyBound => 'Passkey 已绑定';

  @override
  String bindPasskeyFailed(String error) {
    return '绑定 Passkey 失败：$error';
  }

  @override
  String get allMarkedRead => '已全部标记为已读';

  @override
  String operationFailed(String error) {
    return '操作失败：$error';
  }

  @override
  String get selectedNotificationsMarked => '已标记所选通知';

  @override
  String markFailed(String error) {
    return '标记失败：$error';
  }

  @override
  String get readNotificationsDeleted => '已删除已读通知';

  @override
  String loadNotificationDetailsFailed(String error) {
    return '加载通知详情失败，显示列表内容：$error';
  }

  @override
  String loadNotificationsFailed(String error) {
    return '加载通知失败：$error';
  }

  @override
  String get openAuthorizationLinkFailed => '无法打开授权链接';

  @override
  String get completeAuthorizationInBrowser => '请在浏览器完成授权';

  @override
  String get oauthAccountBound => 'OAuth2 账号已绑定';

  @override
  String oauthBindingFailed(String error) {
    return 'OAuth2 绑定失败：$error';
  }

  @override
  String loadMyRoomsFailed(String error) {
    return '加载我的房间失败：$error';
  }

  @override
  String openRoomManagementFailed(String error) {
    return '打开房间管理失败：$error';
  }

  @override
  String get leaveRoom => '退出房间';

  @override
  String deleteOwnedRoomDescription(String name) {
    return '这会永久删除“$name”及其房间数据，所有成员都会失去访问权限。';
  }

  @override
  String leaveRoomDescription(String name) {
    return '确定退出“$name”吗？退出后需要重新加入才能访问。';
  }

  @override
  String actionCompleted(String action) {
    return '$action已完成';
  }

  @override
  String actionFailed(String action, String error) {
    return '$action失败：$error';
  }

  @override
  String get closeAccount => '注销账户';

  @override
  String get closeAccountDescription => '此操作会注销当前账户，并从服务器移除相关个人数据。';

  @override
  String enterCloseAccountToConfirm(String text) {
    return '输入 $text 确认';
  }

  @override
  String get confirmationTextMismatch => '确认文本不匹配';

  @override
  String get accountClosed => '账户已注销';

  @override
  String closeAccountFailed(String error) {
    return '注销账户失败：$error';
  }

  @override
  String get currentAccount => '当前账号';

  @override
  String get unreadNotifications => '未读通知';

  @override
  String get loginFactors => '登录因素';

  @override
  String get emailStatus => '邮箱状态';

  @override
  String get personalProfile => '个人资料';

  @override
  String get personalProfileDescription => '管理这个服务器上的公开身份和账号状态';

  @override
  String emailWithStatus(String status) {
    return '邮箱$status';
  }

  @override
  String get banned => '已封禁';

  @override
  String get emailNotBound => '未绑定邮箱';

  @override
  String get accountInformation => '账号信息';

  @override
  String get accountStatus => '账号状态';

  @override
  String get createdAt => '创建时间';

  @override
  String get updatedAt => '更新时间';

  @override
  String get onlineConnectionsLabel => '在线连接';

  @override
  String get banReason => '封禁原因';

  @override
  String get notificationPreferences => '通知偏好';

  @override
  String get notificationPreferencesDescription => '按场景控制站内通知和邮件通知';

  @override
  String get roomInviteInAppNotifications => '房间邀请站内通知';

  @override
  String get roomEventInAppNotifications => '房间事件站内通知';

  @override
  String get systemAnnouncementInAppNotifications => '系统公告站内通知';

  @override
  String get roomInviteEmailNotifications => '房间邀请邮件通知';

  @override
  String get roomEventEmailNotifications => '房间事件邮件通知';

  @override
  String get systemAnnouncementEmailNotifications => '系统公告邮件通知';

  @override
  String get notificationPreferencesUnavailable => '通知偏好不可用';

  @override
  String get myRoomsDescription => '管理你创建、加入或被授权的同步观影空间';

  @override
  String get searchRoomNameOrDescription => '搜索房间名称或描述';

  @override
  String get all => '全部';

  @override
  String get createdByMe => '我创建的';

  @override
  String get joinedByMe => '我加入的';

  @override
  String get recentActivity => '最近活跃';

  @override
  String get frequentlyVisited => '常访问';

  @override
  String get recentlyVisited => '最近访问';

  @override
  String get refreshRooms => '刷新房间';

  @override
  String pageRangeSummary(int page, int pages, int start, int end, int total) {
    return '第 $page / $pages 页 · $start-$end / $total';
  }

  @override
  String get myRoomsTemporarilyUnavailable => '我的房间暂时不可用';

  @override
  String get noMatchingRooms => '没有匹配的房间';

  @override
  String get localPasskey => '本机 Passkey';

  @override
  String get accountSecurity => '账号安全';

  @override
  String get accountSecurityDescription => '管理登录因素、设备凭据和高风险账号操作';

  @override
  String get loginProtection => '登录保护';

  @override
  String get loginProtectionDescription => '多因素认证会在密码之外要求额外验证因素';

  @override
  String get multiFactorAuthentication => '多因素认证';

  @override
  String availableFactors(String factors) {
    return '可用因素：$factors';
  }

  @override
  String get listSeparator => '、';

  @override
  String get bindEmailDescription => '绑定邮箱后可接收验证码、通知和密码重置邮件';

  @override
  String get loginPassword => '登录密码';

  @override
  String get opaquePasswordDescription => '通过 OPAQUE 协议更新账号密码';

  @override
  String get emailReset => '邮件重置';

  @override
  String get loginProtectionUnavailable => '登录保护信息不可用';

  @override
  String get passkeyManagementDescription => '使用系统凭据管理器完成无密码或多因素验证';

  @override
  String get noPasskeys => '暂无 Passkey';

  @override
  String get unnamedPasskey => '未命名 Passkey';

  @override
  String createdAtValue(String value) {
    return '创建 $value';
  }

  @override
  String lastUsedAt(String value) {
    return '最近使用 $value';
  }

  @override
  String get dangerousActions => '危险操作';

  @override
  String get dangerousActionsDescription => '这些操作会影响账号可用性或永久删除数据';

  @override
  String get closeAccountTileDescription => '注销当前账户，并清除本机登录状态';

  @override
  String unreadTotalSummary(int unread, int total) {
    return '未读 $unread / 总计 $total';
  }

  @override
  String selectedCount(int count) {
    return '已选 $count';
  }

  @override
  String get markSelectedUnreadNotifications => '标记所选未读通知';

  @override
  String get selectCurrentUnreadNotifications => '选择当前未读通知';

  @override
  String get markAllRead => '全部标记为已读';

  @override
  String get deleteReadNotifications => '删除已读通知';

  @override
  String get searchTitleOrContent => '搜索标题或内容';

  @override
  String get unread => '未读';

  @override
  String get notificationType => '通知类型';

  @override
  String get roomInvitation => '房间邀请';

  @override
  String get systemAnnouncement => '系统公告';

  @override
  String get roomEvent => '房间事件';

  @override
  String get passwordResetNotification => '密码重置';

  @override
  String get emailBinding => '邮箱绑定';

  @override
  String get title => '标题';

  @override
  String get descending => '降序';

  @override
  String get ascending => '升序';

  @override
  String notificationPageRange(int page, int pages, int start, int end) {
    return '第 $page / $pages 页 · $start-$end';
  }

  @override
  String get notificationsTemporarilyUnavailable => '通知暂时不可用';

  @override
  String get noNotifications => '暂无通知';

  @override
  String get selectNotification => '选择通知';

  @override
  String get viewDetails => '查看详情';

  @override
  String get markRead => '标记已读';

  @override
  String get mediaSourceAccounts => '媒体源账号';

  @override
  String get mediaSourceAccountsDescription =>
      '绑定个人媒体库账号后，可在添加影片时直接浏览 AList、Emby 和 Bilibili 资源。';

  @override
  String get alistAccountDescription => '个人网盘与目录资源';

  @override
  String get cloudreveAccountDescription => '连接 Cloudreve 账号并浏览云盘媒体';

  @override
  String get embyAccountDescription => '个人媒体库与影视资源';

  @override
  String get bilibiliAccountDescription => 'Bilibili 账号与收藏资源';

  @override
  String get twitchAccountDescription => '连接 Twitch 账号并播放直播、VOD 与 Clip';

  @override
  String get fnosAccountDescription => '连接 FNOS 文件与影视媒体库';

  @override
  String get qnapAccountDescription => '连接 QTS / QuTS hero File Station';

  @override
  String get synologyAccountDescription => '连接 File Station 与 Video Station';

  @override
  String get nextcloudAccountDescription => '连接 Nextcloud 文件、收藏与搜索媒体';

  @override
  String get seafileAccountDescription => '连接 Seafile 资料库、星标与搜索媒体';

  @override
  String get truenasAccountDescription => '连接 TrueNAS ZFS 文件系统媒体';

  @override
  String get youtubeAccountDescription =>
      '连接 Cookie、Visitor Data 或 PO Token 并播放视频、直播与动态列表';

  @override
  String get douyinAccountDescription => '连接 Cookie 并播放短视频、直播、弹幕与用户作品列表';

  @override
  String get tiktokAccountDescription => '连接 Cookie 并播放视频、直播、字幕与用户作品列表';

  @override
  String get linkedOAuth2 => '已绑定 OAuth2';

  @override
  String get bindNewAccount => '绑定新账号';

  @override
  String get oauthAppLinkUnavailable => '当前构建未配置 OAuth2 App Link，无法在本设备完成授权回跳。';

  @override
  String waitingForAuthorizationCallback(String provider) {
    return '等待 $provider 授权回跳';
  }

  @override
  String get cancelBinding => '取消绑定';

  @override
  String get role => '角色';

  @override
  String get viewProfile => '查看资料';

  @override
  String get enabled => '已启用';

  @override
  String get availableFactorsLabel => '可用因素';

  @override
  String get manageSecurity => '管理安全';

  @override
  String get recentRooms => '最近房间';

  @override
  String creatorName(String name) {
    return '创建者 $name';
  }

  @override
  String get manageRooms => '管理房间';

  @override
  String get user => '用户';

  @override
  String get normal => '正常';

  @override
  String get pendingReview => '待审核';

  @override
  String get closed => '已关闭';

  @override
  String get creator => '创建者';

  @override
  String get roomAdministrator => '房间管理员';

  @override
  String get member => '成员';

  @override
  String get none => '无';

  @override
  String get currentPassword => '当前密码';

  @override
  String get verifyWithCurrentPassword => '使用当前密码验证身份';

  @override
  String get verifyWithEmailCode => '使用邮箱收到的验证码验证身份';

  @override
  String get verifyWithSystemPasskey => '调用系统 Passkey 完成身份验证';

  @override
  String get changePassword => '修改密码';

  @override
  String get changePasswordDescription => '选择一种可用的验证方式，然后设置新的登录密码。';

  @override
  String get verificationMethod => '验证方式';

  @override
  String get identityVerification => '身份验证';

  @override
  String get emailVerificationCode => '邮箱验证码';

  @override
  String get passkeyVerification => 'Passkey 验证';

  @override
  String get passkeyPasswordUpdateDescription => '保存后会弹出系统验证窗口，验证通过后写入新密码。';

  @override
  String get savePassword => '保存密码';

  @override
  String get codeAndNewPasswordRequired => '请输入验证码和新密码';

  @override
  String get emailPasswordReset => '邮件重置密码';

  @override
  String get emailPasswordResetDescription => '向当前绑定邮箱发送一次性验证码，用验证码完成密码重置。';

  @override
  String get recipientEmail => '接收邮箱';

  @override
  String get sendVerificationCode => '发送验证码';

  @override
  String get bindingEmailSent => '绑定确认邮件已发送';

  @override
  String sendBindingEmailFailed(String error) {
    return '发送绑定邮件失败：$error';
  }

  @override
  String bindEmailFailed(String error) {
    return '绑定邮箱失败：$error';
  }

  @override
  String get bindEmail => '绑定邮箱';

  @override
  String get bindEmailBenefits => '邮箱绑定成功后可用于登录、找回密码和接收账号通知。';

  @override
  String get emailAddress => '邮箱地址';

  @override
  String get confirmationEmailSent => '确认邮件已发送';

  @override
  String get confirmBinding => '确认绑定';

  @override
  String get bindingCode => '绑定验证码';

  @override
  String initializeVerificationFailed(String error) {
    return '身份验证初始化失败：$error';
  }

  @override
  String sendCodeFailed(String error) {
    return '发送验证码失败：$error';
  }

  @override
  String get enterCurrentPassword => '请输入当前密码';

  @override
  String get enterEmailCode => '请输入邮箱验证码';

  @override
  String get passkeyChallengeMissing => '服务器未返回 Passkey 验证 challenge';

  @override
  String identityVerificationFailed(String error) {
    return '身份验证失败：$error';
  }

  @override
  String get identityVerificationDescription => '选择一种可用方式以继续账号安全操作。';

  @override
  String get noVerificationMethods => '没有可用验证方式';

  @override
  String get noVerificationMethodsDescription => '当前账号缺少密码、邮箱或 Passkey 验证能力。';

  @override
  String get verificationInformation => '验证信息';

  @override
  String get passkeyVerificationDescription => '点击验证后会弹出系统验证窗口。';

  @override
  String get resend => '重新发送';

  @override
  String get verify => '验证';

  @override
  String updatedAtValue(String value) {
    return '更新 $value';
  }

  @override
  String get data => '数据';

  @override
  String get someAccountModulesUnavailable => '部分账号模块暂时不可用';

  @override
  String get retryAll => '全部重试';

  @override
  String get retry => '重试';

  @override
  String get moduleCurrentlyUnavailable => '此模块当前无法加载。';

  @override
  String get moduleUnavailable => '模块不可用';

  @override
  String get review => '审核';

  @override
  String roomMemberUpdateSummary(int online, int members, String time) {
    return '在线 $online · 成员 $members · 更新 $time';
  }

  @override
  String get open => '打开';

  @override
  String get manage => '管理';

  @override
  String get leave => '退出';

  @override
  String get settings => '设置';

  @override
  String get reports => '举报';

  @override
  String get network => '网络';

  @override
  String get streaming => '推流';

  @override
  String get allSources => '全部来源';

  @override
  String get roomCoverUpdated => '房间封面已更新';

  @override
  String updateRoomCoverFailed(String error) {
    return '更新房间封面失败：$error';
  }

  @override
  String get roomCoverRemoved => '房间封面已移除';

  @override
  String removeRoomCoverFailed(String error) {
    return '移除房间封面失败：$error';
  }

  @override
  String get roomPasswordRemoved => '房间密码已移除';

  @override
  String get roomPasswordUpdated => '房间密码已更新';

  @override
  String updateRoomPasswordFailed(String error) {
    return '更新房间密码失败：$error';
  }

  @override
  String get removePassword => '移除密码';

  @override
  String get noActionNeeded => '无需操作';

  @override
  String get memberOnlineWatchFailed => '成员在线状态监听失败';

  @override
  String get roomSettingsSnapshotEmpty => '房间设置快照为空';

  @override
  String get roomSettingsWatchFailed => '房间设置监听失败';

  @override
  String get memberWatchFailed => '成员监听失败';

  @override
  String get mediaSnapshotEmpty => '媒体列表快照为空';

  @override
  String get mediaLibraryWatchFailed => '媒体库监听失败';

  @override
  String get chatWatchFailed => '聊天事件监听失败';

  @override
  String get maxMembersRange => '最大成员数必须在 0 到 10000 之间';

  @override
  String get settingsUpdated => '设置已更新';

  @override
  String get roomVisibilityUpdated => '房间可见性已更新';

  @override
  String get makeRoomPrivate => '将房间设为非公开？';

  @override
  String get makeRoomPrivateConfirmation => '房间将从公开列表中移除，当前匿名访客会断开连接。';

  @override
  String get makePrivate => '设为非公开';

  @override
  String updateFailed(String error) {
    return '更新失败：$error';
  }

  @override
  String loadActiveStreamsFailed(String error) {
    return '加载活跃流失败：$error';
  }

  @override
  String loadJoinReviewsFailed(String error) {
    return '加载加入审核失败：$error';
  }

  @override
  String loadMembersFailed(String error) {
    return '加载成员失败：$error';
  }

  @override
  String loadMediaLibraryFailed(String error) {
    return '加载媒体库失败：$error';
  }

  @override
  String get realtimeDiagnosticsCopied => '实时诊断数据已复制';

  @override
  String loadChatHistoryFailed(String error) {
    return '加载聊天历史失败：$error';
  }

  @override
  String searchChatHistoryFailed(String error) {
    return '搜索聊天历史失败：$error';
  }

  @override
  String loadIceConfigFailed(String error) {
    return '加载 ICE 配置失败：$error';
  }

  @override
  String get dynamicPlaylistCreatorOnly => '仅创建者可查看动态播放列表';

  @override
  String get streamDisconnected => '已断开推流';

  @override
  String disconnectStreamFailed(String error) {
    return '断开推流失败：$error';
  }

  @override
  String get status => '状态';

  @override
  String get publisher => '发布者';

  @override
  String get unknownPublisher => '未知发布者';

  @override
  String get startTime => '开始时间';

  @override
  String get mediaIdCopied => '媒体 ID 已复制';

  @override
  String get copyId => '复制 ID';

  @override
  String get disconnectStream => '断开推流';

  @override
  String loadStreamDetailsFailed(String error) {
    return '加载推流详情失败：$error';
  }

  @override
  String get requestApproved => '已通过申请';

  @override
  String reviewFailed(String error) {
    return '审核失败：$error';
  }

  @override
  String get requestRejected => '已拒绝申请';

  @override
  String get memberAdded => '成员已添加';

  @override
  String addMemberFailed(String error) {
    return '添加成员失败：$error';
  }

  @override
  String get memberRoleUpdated => '成员角色已更新';

  @override
  String updateRoleFailed(String error) {
    return '更新角色失败：$error';
  }

  @override
  String get memberPermissionsUpdated => '成员权限已更新';

  @override
  String updatePermissionsFailed(String error) {
    return '更新权限失败：$error';
  }

  @override
  String get remarkName => '备注名称';

  @override
  String get remarkNameUpdated => '备注名称已更新';

  @override
  String updateRemarkNameFailed(String error) {
    return '更新备注名称失败：$error';
  }

  @override
  String get displayLabel => '展示标签';

  @override
  String get displayLabelUpdated => '展示标签已更新';

  @override
  String updateDisplayLabelFailed(String error) {
    return '更新展示标签失败：$error';
  }

  @override
  String get transferOwnership => '转让房主';

  @override
  String confirmTransferOwnership(String user) {
    return '确认将房间所有权转让给 $user？';
  }

  @override
  String get transfer => '转让';

  @override
  String get ownershipTransferred => '房主已转让';

  @override
  String transferFailed(String error) {
    return '转让失败：$error';
  }

  @override
  String get memberRemoved => '成员已移出';

  @override
  String removeMemberFailed(String error) {
    return '移出成员失败：$error';
  }

  @override
  String confirmRemoveMember(String user) {
    return '确认将 $user 移出房间，并设置重新加入冷却时间。';
  }

  @override
  String get resetSettings => '重置设置';

  @override
  String get resetRoomSettingsDescription =>
      '确认将访问控制、消息开关、成员权限和访客权限恢复为服务端默认策略？当前未保存的房间策略会被覆盖。';

  @override
  String get settingsReset => '设置已重置';

  @override
  String resetFailed(String error) {
    return '重置失败：$error';
  }

  @override
  String confirmLeaveRoom(String room) {
    return '确认退出 $room？';
  }

  @override
  String get leftRoom => '已退出房间';

  @override
  String leaveRoomFailed(String error) {
    return '退出房间失败：$error';
  }

  @override
  String confirmPermanentRoomDeletion(String room) {
    return '确认永久删除 $room？此操作会移除房间、播放列表和相关房间数据。';
  }

  @override
  String get dynamicContentReadOnly => '动态来源内容只支持查看和打开';

  @override
  String get newPlaylist => '新建播放列表';

  @override
  String get playlistCreated => '播放列表已创建';

  @override
  String createPlaylistFailed(String error) {
    return '创建播放列表失败：$error';
  }

  @override
  String get clearMediaLibrary => '清空媒体库';

  @override
  String get clearPlaylist => '清空播放列表';

  @override
  String get confirmClearMediaLibrary => '确认清空媒体库根层级的媒体和播放列表？';

  @override
  String get confirmClearPlaylist => '确认清空当前播放列表下的媒体和子播放列表？播放列表本身会保留。';

  @override
  String get mediaLibraryCleared => '媒体库已清空';

  @override
  String clearFailed(String error) {
    return '清空失败：$error';
  }

  @override
  String get editPlaylist => '编辑播放列表';

  @override
  String get playlistBrowseAccess => '浏览权限';

  @override
  String get playlistBrowseAccessDescription =>
      '默认情况下，静态播放列表允许房间成员浏览，动态播放列表仅允许创建者浏览。';

  @override
  String get playlistBrowseAccessModeDefault => '默认';

  @override
  String get playlistBrowseAccessModeRoomMembers => '房间成员';

  @override
  String get playlistBrowseAccessModeCreatorOnly => '仅创建者';

  @override
  String get editMedia => '编辑媒体';

  @override
  String get nameUpdated => '名称已更新';

  @override
  String renameFailed(String error) {
    return '重命名失败：$error';
  }

  @override
  String confirmDeletePlaylist(String name) {
    return '确认删除播放列表 $name？其中的子播放列表和媒体也会从房间媒体库移除，成员会立即看到变更。';
  }

  @override
  String confirmDeleteMedia(String name) {
    return '确认删除媒体 $name？该条目会从房间媒体库移除，当前播放或成员播放列表会立即同步变更。';
  }

  @override
  String get entryDeleted => '条目已删除';

  @override
  String get type => '类型';

  @override
  String get liveMedia => '直播媒体';

  @override
  String get parent => '父级';

  @override
  String get description => '描述';

  @override
  String get thumbnail => '缩略图';

  @override
  String get childPlaylists => '子播放列表';

  @override
  String get mediaCount => '媒体数量';

  @override
  String get metadata => '元数据';

  @override
  String get sourceConfiguration => '来源配置';

  @override
  String get idCopied => 'ID 已复制';

  @override
  String get cover => '封面';

  @override
  String loadEntryDetailsFailed(String error) {
    return '加载条目详情失败：$error';
  }

  @override
  String get coverUpdated => '封面已更新';

  @override
  String updateCoverFailed(String error) {
    return '更新封面失败：$error';
  }

  @override
  String get coverRemoved => '封面已移除';

  @override
  String removeCoverFailed(String error) {
    return '移除封面失败：$error';
  }

  @override
  String get thumbnailUpdated => '缩略图已更新';

  @override
  String updateThumbnailFailed(String error) {
    return '更新缩略图失败：$error';
  }

  @override
  String get thumbnailRemoved => '缩略图已移除';

  @override
  String removeThumbnailFailed(String error) {
    return '移除缩略图失败：$error';
  }

  @override
  String get deletedMessageCannotEdit => '已删除的消息不能编辑';

  @override
  String get messageUpdated => '消息已更新';

  @override
  String editMessageFailed(String error) {
    return '编辑消息失败：$error';
  }

  @override
  String get editMessage => '编辑消息';

  @override
  String get deleteMessage => '删除消息';

  @override
  String get confirmDeleteChatMessage => '确认删除这条聊天消息？删除后所有成员的聊天历史都会同步移除该消息。';

  @override
  String roomReportManagement(String room) {
    return '$room 的举报管理';
  }

  @override
  String get reportRoom => '举报房间';

  @override
  String get messageContext => '消息上下文';

  @override
  String loadMessageContextFailed(String error) {
    return '加载消息上下文失败：$error';
  }

  @override
  String mediaItemsMoved(int count) {
    return '已移动 $count 个媒体';
  }

  @override
  String moveFailed(String error) {
    return '移动失败：$error';
  }

  @override
  String get playlistOrderUpdated => '播放列表顺序已更新';

  @override
  String reorderFailed(String error) {
    return '调整顺序失败：$error';
  }

  @override
  String get moveMedia => '移动媒体';

  @override
  String parentId(String id) {
    return '上级 $id';
  }

  @override
  String get rejectRequest => '拒绝申请';

  @override
  String get reason => '原因';

  @override
  String get reject => '拒绝';

  @override
  String get addMember => '添加成员';

  @override
  String get sendNotification => '发送通知';

  @override
  String get changeRole => '修改角色';

  @override
  String get permissionOverrides => '权限覆盖';

  @override
  String get clearOverrides => '清除覆盖';

  @override
  String get inherit => '继承';

  @override
  String get allow => '允许';

  @override
  String get deny => '拒绝';

  @override
  String get maximumMembers => '最大成员数';

  @override
  String get zeroMeansUnlimited => '0 表示不限制';

  @override
  String get accessControl => '访问控制';

  @override
  String get allowGuestJoin => '允许访客加入';

  @override
  String get guestTokenCurrentRoomOnly => '访客 token 只能访问当前房间';

  @override
  String get joinRequiresApproval => '加入需要审核';

  @override
  String get newMembersRequireApproval => '新成员申请需管理员批准';

  @override
  String get allowAutomaticJoin => '允许自动加入';

  @override
  String get automaticJoinDescription => '关闭后只能通过邀请或管理员添加成员';

  @override
  String get regularMemberPermissions => '普通成员权限';

  @override
  String get sendChatAndDanmaku => '发送聊天/弹幕';

  @override
  String get browseLibraryList => '浏览媒体库';

  @override
  String get viewMemberList => '查看成员列表';

  @override
  String get viewChatHistory => '查看聊天历史';

  @override
  String get webrtcCalls => 'WebRTC 通话';

  @override
  String get guestPermissions => '访客权限';

  @override
  String get settingsActions => '设置操作';

  @override
  String get savingSettings => '正在保存设置';

  @override
  String get saveRoomPolicyDescription => '保存访问控制、消息开关和权限策略';

  @override
  String get saveSettings => '保存设置';

  @override
  String get resetRoomSettings => '重置房间设置';

  @override
  String get restoreServerRoomPolicy => '恢复服务端默认房间策略';

  @override
  String get activeStreams => '活跃推流';

  @override
  String get mediaId => '媒体 ID';

  @override
  String get mediaIdAscending => '媒体 ID 升序';

  @override
  String get mediaIdDescending => '媒体 ID 降序';

  @override
  String pagedItemSummary(int page, int pageSize, int total) {
    return '第 $page 页 · 每页 $pageSize · 共 $total 条';
  }

  @override
  String get noActiveStreams => '当前没有活跃推流';

  @override
  String get joinRequests => '加入申请';

  @override
  String get approved => '已通过';

  @override
  String get rejected => '已拒绝';

  @override
  String get noJoinRequests => '当前没有加入申请';

  @override
  String get clearCurrentLevel => '清空当前层级';

  @override
  String get refreshDynamicList => '刷新动态列表';

  @override
  String get searchMediaOrPlaylist => '搜索媒体或播放列表';

  @override
  String get availability => '可用性';

  @override
  String get available => '可用';

  @override
  String get unavailable => '不可用';

  @override
  String get sort => '排序';

  @override
  String get position => '位置';

  @override
  String get addedAt => '添加时间';

  @override
  String get noMediaEntriesAtCurrentLevel => '当前层级没有媒体条目';

  @override
  String get realtimeDiagnostics => '实时诊断';

  @override
  String get copyDiagnostics => '复制诊断数据';

  @override
  String get resetWatches => '重置监听';

  @override
  String get resources => '资源';

  @override
  String get events => '事件';

  @override
  String get watchEventsDescription => '监听请求和资源事件会显示在这里';

  @override
  String get roomSettings => '房间设置';

  @override
  String get roomSettingsShort => '设置';

  @override
  String get watchingSettingChanges => '监听设置变更';

  @override
  String get memberList => '成员列表';

  @override
  String get refreshingMembers => '正在刷新成员';

  @override
  String onlineTotalSummary(int online, int total) {
    return '$online 在线 / $total 总数';
  }

  @override
  String get mediaList => '媒体列表';

  @override
  String get waitingForMediaSnapshot => '等待媒体快照';

  @override
  String playlistMediaSummary(int playlists, int media) {
    return '$playlists 播放列表 / $media 媒体';
  }

  @override
  String get chatEvents => '聊天事件';

  @override
  String get refreshingChatHistory => '正在刷新聊天历史';

  @override
  String chatHistoryCount(int count) {
    return '聊天历史 $count 条';
  }

  @override
  String get watchedResources => '监听资源';

  @override
  String get sentReceived => '发出 / 收到';

  @override
  String get errors => '异常';

  @override
  String get runtimeSnapshot => '运行快照';

  @override
  String get room => '房间';

  @override
  String get currentMediaLocation => '当前媒体位置';

  @override
  String get watchStatus => '监听状态';

  @override
  String get version => '版本';

  @override
  String get notProvided => '未提供';

  @override
  String get waiting => '等待';

  @override
  String get localItems => '本地条目';

  @override
  String get latestEvent => '最近事件';

  @override
  String get eventCounts => '事件计数';

  @override
  String get lastTime => '最后时间';

  @override
  String get error => '错误';

  @override
  String get observedWithChanges => '已观测，有变更';

  @override
  String get observedWithoutChanges => '已观测，无变更';

  @override
  String get snapshotPushed => '已推送快照';

  @override
  String get chatHistory => '聊天历史';

  @override
  String get searchChatContent => '搜索聊天内容';

  @override
  String searchQuery(String query) {
    return '搜索“$query”';
  }

  @override
  String get noMatchingChatMessages => '没有匹配的聊天消息';

  @override
  String get noChatHistory => '当前没有聊天历史';

  @override
  String get iceServers => 'ICE 服务器';

  @override
  String get noIceServers => '当前没有 ICE 服务器配置';

  @override
  String get roomMembers => '房间成员';

  @override
  String get usernameOrUserId => '用户名或用户 ID';

  @override
  String get allRoles => '全部角色';

  @override
  String get roomOwner => '房主';

  @override
  String get joinedAt => '加入时间';

  @override
  String get noMembers => '暂无成员';

  @override
  String onlineMemberSummary(int online, int members) {
    return '在线 $online / 成员 $members';
  }

  @override
  String get approve => '通过';

  @override
  String get mediaActions => '媒体操作';

  @override
  String get updateCover => '更新封面';

  @override
  String get removeCover => '移除封面';

  @override
  String get updateThumbnail => '更新缩略图';

  @override
  String get removeThumbnail => '移除缩略图';

  @override
  String get moveUp => '上移';

  @override
  String get moveDown => '下移';

  @override
  String get moveTo => '移动到...';

  @override
  String get imageMessagePlain => '图片消息';

  @override
  String get viewContext => '查看上下文';

  @override
  String get viewReports => '查看举报';

  @override
  String messageReports(String id) {
    return '消息 #$id 的举报';
  }

  @override
  String get tapToViewContext => '点击查看上下文';

  @override
  String get viewReactionMembers => '查看回应成员';

  @override
  String get anonymous => '匿名';

  @override
  String creatorOnlyMode(String mode) {
    return '$mode · 仅创建者可查看';
  }

  @override
  String dynamicMediaSize(int size) {
    String _temp0 = intl.Intl.pluralLogic(
      size,
      locale: localeName,
      other: '动态媒体 · $size bytes',
      zero: '动态媒体',
    );
    return '$_temp0';
  }

  @override
  String get online => '在线';

  @override
  String get offline => '离线';

  @override
  String joinedAtValue(String value) {
    return '加入 $value';
  }

  @override
  String get removeFromRoom => '移出房间';

  @override
  String get viewMemberReports => '查看成员举报';

  @override
  String memberReports(String user) {
    return '$user 的成员举报';
  }

  @override
  String get moreMemberActions => '更多成员操作';

  @override
  String get ownerAccount => '房主账号';

  @override
  String get roomInformation => '房间信息';

  @override
  String get configured => '已设置';

  @override
  String get notConfigured => '未设置';

  @override
  String get emptyRemovesRoomPassword => '留空提交会移除房间密码';

  @override
  String get roomCurrentlyRequiresPassword => '当前房间需要密码';

  @override
  String get roomCurrentlyNoPassword => '当前房间无需密码';

  @override
  String get roomActions => '房间操作';

  @override
  String get leaveRoomTileDescription => '退出后需要重新加入才能访问成员内容';

  @override
  String get unspecified => '未指定';

  @override
  String get unknownTime => '时间未知';

  @override
  String get waitingForEvent => '等待事件';

  @override
  String get messageContent => '消息内容';

  @override
  String get systemManagement => '系统管理';

  @override
  String get administrators => '管理员';

  @override
  String get categoriesAndLabels => '分类与标签';

  @override
  String get users => '用户';

  @override
  String get bans => '封禁';

  @override
  String loadOverviewFailed(String error) {
    return '加载总览失败：$error';
  }

  @override
  String get noStatistics => '暂无统计数据';

  @override
  String get activeUsers => '活跃用户';

  @override
  String get onlineMembersLabel => '在线成员';

  @override
  String get onlineGuestsLabel => '在线游客';

  @override
  String get bannedUsers => '封禁用户';

  @override
  String get activeRooms => '活跃房间';

  @override
  String get onlineRooms => '在线房间';

  @override
  String loadAdministratorsFailed(String error) {
    return '加载管理员失败：$error';
  }

  @override
  String get addAdministrator => '添加管理员';

  @override
  String get addAdministratorDescription => '创建新管理员，或提升已有用户。';

  @override
  String get promoteExistingUser => '提升已有用户';

  @override
  String get createAdministrator => '新建管理员';

  @override
  String get usernameAndPasswordRequired => '请输入用户名和密码';

  @override
  String get administratorAdded => '管理员已添加';

  @override
  String get existingUserIdRequired => '请输入已有用户 ID';

  @override
  String get promote => '提升';

  @override
  String get userIdRequired => '请输入用户 ID';

  @override
  String get removeAdministrator => '移除管理员';

  @override
  String get administratorRemoved => '管理员已移除';

  @override
  String removeFailed(String error) {
    return '移除管理员失败：$error';
  }

  @override
  String administratorCount(int count) {
    return '$count 位管理员';
  }

  @override
  String get searchAdministrators => '搜索管理员';

  @override
  String itemsPerPage(int count) {
    return '$count / 页';
  }

  @override
  String get noAdministrators => '暂无管理员';

  @override
  String pageOf(int page, int pageCount) {
    return '第 $page 页，共 $pageCount 页';
  }

  @override
  String get cannotRemoveCurrentAdministrator => '当前账号的管理员权限无法在这里移除';

  @override
  String get keepAtLeastOneAdministrator => '系统至少需要保留一位管理员';

  @override
  String get allStatuses => '全部状态';

  @override
  String get allBanStates => '全部封禁';

  @override
  String get bannedOnly => '仅封禁';

  @override
  String get notBanned => '未封禁';

  @override
  String get ban => '封禁';

  @override
  String get unban => '解封';

  @override
  String roomAction(String action) {
    return '$action房间';
  }

  @override
  String confirmRoomAction(String action, String roomName) {
    return '确定要$action房间“$roomName”吗？';
  }

  @override
  String permanentlyDeleteRoom(String roomName) {
    return '将永久删除房间“$roomName”。';
  }

  @override
  String get allMembersLoseAccess => '所有成员将失去房间访问权限。';

  @override
  String get roomDataWillBeCleared => '房间设置、媒体和关联数据将被清除。';

  @override
  String get watchingMembersWillExit => '正在观看的成员会立即退出。';

  @override
  String get batchBanRooms => '批量封禁房间';

  @override
  String roomsWillBeBanned(int count) {
    return '将封禁 $count 个房间。';
  }

  @override
  String get batchBanCompleted => '批量封禁完成';

  @override
  String batchBanFailed(String error) {
    return '批量封禁失败：$error';
  }

  @override
  String get batchDeleteRooms => '批量删除房间';

  @override
  String roomsWillBeDeleted(int count) {
    return '将永久删除 $count 个房间。';
  }

  @override
  String get relatedMembersLoseAccess => '相关成员将失去这些房间的访问权限。';

  @override
  String get batchDeleteBackupOnly => '删除的数据只能通过备份恢复。';

  @override
  String get batchDeleteCompleted => '批量删除完成';

  @override
  String batchDeleteFailed(String error) {
    return '批量删除失败：$error';
  }

  @override
  String batchResultSuccess(String title, int succeeded) {
    return '$title：成功 $succeeded 个';
  }

  @override
  String batchResultMixed(String title, int succeeded, int failed) {
    return '$title：成功 $succeeded 个，失败 $failed 个';
  }

  @override
  String get memberCountLabel => '成员数';

  @override
  String get creatorStatus => '创建者状态';

  @override
  String get resourceAvailability => '资源可用性';

  @override
  String get passwordAction => '密码操作';

  @override
  String get keepUnchanged => '保持不变';

  @override
  String get setNewPassword => '设置新密码';

  @override
  String get clearPassword => '清除密码';

  @override
  String get newPasswordRequired => '请输入新密码';

  @override
  String roomReports(String roomName) {
    return '$roomName 的举报';
  }

  @override
  String get reportRecords => '举报记录';

  @override
  String loadRoomDetailsFailed(String error) {
    return '加载房间详情失败：$error';
  }

  @override
  String get categoriesLabelsSaved => '分类与标签已保存';

  @override
  String saveCategoriesLabelsFailed(String error) {
    return '保存分类与标签失败：$error';
  }

  @override
  String get searchMembers => '搜索成员';

  @override
  String memberAdminSummary(int total, int online, int connections) {
    return '共 $total 位成员 · $online 位在线 · $connections 个连接';
  }

  @override
  String memberPageSummary(int total, int page, int pageCount) {
    return '共 $total 位成员 · 第 $page 页，共 $pageCount 页';
  }

  @override
  String get toggleAdministrator => '切换管理员角色';

  @override
  String get notifyMember => '通知成员';

  @override
  String get roomRole => '房间角色';

  @override
  String get roomSettingsReset => '房间设置已重置';

  @override
  String get roomSettingsSaved => '房间设置已保存';

  @override
  String saveRoomSettingsFailed(String error) {
    return '保存房间设置失败：$error';
  }

  @override
  String get selectCurrentPage => '选择当前页';

  @override
  String get selectRoom => '选择房间';

  @override
  String roomsSelected(int count) {
    return '已选择 $count 个房间';
  }

  @override
  String get roomCategories => '房间分类';

  @override
  String loadCategoriesLabelsFailed(String error) {
    return '加载分类与标签失败：$error';
  }

  @override
  String get categoryNotBound => '未绑定分类';

  @override
  String get unknownCategory => '未知分类';

  @override
  String get addCategory => '添加分类';

  @override
  String get editCategory => '编辑分类';

  @override
  String get identifier => '标识符';

  @override
  String get categoryIdentifierExample => '例如：movies';

  @override
  String get categoryNameExample => '例如：电影';

  @override
  String get lowerNumberFirst => '数值较小的项目优先展示';

  @override
  String get enableCategory => '启用分类';

  @override
  String get categoryIdAndNameRequired => '请输入分类标识符和名称';

  @override
  String get sortMustBeInteger => '排序值必须是整数';

  @override
  String get categorySaved => '分类已保存';

  @override
  String saveCategoryFailed(String error) {
    return '保存分类失败：$error';
  }

  @override
  String get deleteCategory => '删除分类';

  @override
  String permanentlyDeleteCategory(String category) {
    return '将永久删除分类“$category”。';
  }

  @override
  String get roomsLoseCategory => '使用此分类的房间将变为未分类。';

  @override
  String get categoryChangesImmediate => '分类变更会立即生效。';

  @override
  String get categoryDeleted => '分类已删除';

  @override
  String deleteCategoryFailed(String error) {
    return '删除分类失败：$error';
  }

  @override
  String get addLabel => '添加标签';

  @override
  String get editLabel => '编辑标签';

  @override
  String get labelIdentifierExample => '例如：sci-fi';

  @override
  String get labelNameExample => '例如：科幻';

  @override
  String get parentCategory => '所属分类';

  @override
  String get noCategoryBinding => '不绑定分类';

  @override
  String get color => '颜色';

  @override
  String get enableLabel => '启用标签';

  @override
  String get labelIdAndNameRequired => '请输入标签标识符和名称';

  @override
  String get colorFormatExample => '请输入十六进制颜色，例如 #5D5FEF';

  @override
  String get labelSaved => '标签已保存';

  @override
  String saveLabelFailed(String error) {
    return '保存标签失败：$error';
  }

  @override
  String get deleteLabel => '删除标签';

  @override
  String permanentlyDeleteLabel(String label) {
    return '将永久删除标签“$label”。';
  }

  @override
  String get roomsLoseLabel => '使用此标签的房间将失去该标签。';

  @override
  String get labelChangesImmediate => '标签变更会立即生效。';

  @override
  String get labelDeleted => '标签已删除';

  @override
  String deleteLabelFailed(String error) {
    return '删除标签失败：$error';
  }

  @override
  String get noCategories => '暂无分类';

  @override
  String get addCategoriesDescription => '添加分类来组织房间。';

  @override
  String get addLabelsDescription => '添加标签帮助成员发现房间。';

  @override
  String get defaultColor => '默认颜色';

  @override
  String loadUserDetailsFailed(String error) {
    return '加载用户详情失败：$error';
  }

  @override
  String get reportsAgainstUser => '被举报';

  @override
  String get reportsByUser => '发起举报';

  @override
  String get bannedAt => '封禁时间';

  @override
  String get bannedBy => '封禁操作者';

  @override
  String loadUserRoomsFailed(String error) {
    return '加载用户房间失败：$error';
  }

  @override
  String get preferencesUpdated => '偏好已更新';

  @override
  String savePreferencesFailed(String error) {
    return '保存偏好失败：$error';
  }

  @override
  String authenticationFactorsSummary(
    int count,
    String passwordStatus,
    String emailStatus,
    String passkeyStatus,
  ) {
    return '可用因子 $count 个：密码$passwordStatus，邮箱$emailStatus，Passkey $passkeyStatus';
  }

  @override
  String get roomInvitationInAppNotification => '房间邀请站内通知';

  @override
  String get roomEventInAppNotification => '房间事件站内通知';

  @override
  String get systemAnnouncementInAppNotification => '系统公告站内通知';

  @override
  String get roomInvitationEmail => '房间邀请邮件';

  @override
  String get roomEventEmail => '房间事件邮件';

  @override
  String get systemAnnouncementEmail => '系统公告邮件';

  @override
  String get searchUsers => '搜索用户';

  @override
  String get selectUser => '选择用户';

  @override
  String userListSummary(
    String id,
    String role,
    String status,
    String connectionStatus,
  ) {
    return 'ID：$id · $role · $status · $connectionStatus';
  }

  @override
  String connectionCount(int count) {
    return '$count 个连接';
  }

  @override
  String userReports(String username) {
    return '$username 的举报';
  }

  @override
  String get rename => '改名';

  @override
  String get removeAdministratorRole => '取消管理员';

  @override
  String get makeAdministrator => '设为管理员';

  @override
  String get deleteUser => '删除用户';

  @override
  String usersSelected(int count) {
    return '已选择 $count 个用户';
  }

  @override
  String get connected => '已连接';

  @override
  String get disconnected => '已断开';

  @override
  String get optional => '可选';

  @override
  String get operationSucceeded => '操作成功';

  @override
  String get category => '分类';

  @override
  String get requiresPassword => '需要密码';

  @override
  String loadUsersFailed(String error) {
    return '加载用户失败：$error';
  }

  @override
  String get addUser => '新增用户';

  @override
  String get userCreated => '用户创建成功';

  @override
  String createUserFailed(String error) {
    return '创建用户失败：$error';
  }

  @override
  String get create => '创建';

  @override
  String permanentlyDeleteUser(String username) {
    return '将永久删除用户“$username”。';
  }

  @override
  String get deleteUserClearsAccountData => '该用户的登录会话、第三方绑定和个人资料会被清除。';

  @override
  String get deleteUserAffectsRelatedData => '该用户关联的房间关系、聊天记录归属和权限状态会受到影响。';

  @override
  String get deleteUserRevokesOnlineAccess => '在线客户端会立即失去当前账号访问能力。';

  @override
  String get userDeleted => '用户已删除';

  @override
  String deleteUserFailed(String error) {
    return '删除用户失败：$error';
  }

  @override
  String get rootUserCannotBeDemoted => 'Root 用户无法在这里降级';

  @override
  String get changePermissions => '修改权限';

  @override
  String confirmUserRoleAction(String username, String action) {
    return '确定要对用户“$username”执行“$action”吗？';
  }

  @override
  String userAction(String action) {
    return '$action用户';
  }

  @override
  String confirmUserAction(String action, String username) {
    return '确定要$action用户“$username”吗？';
  }

  @override
  String get batchBanUsers => '批量封禁用户';

  @override
  String usersWillBeBanned(int count) {
    return '将封禁 $count 个用户。';
  }

  @override
  String get batchDeleteUsers => '批量删除用户';

  @override
  String usersWillBeDeleted(int count) {
    return '将永久删除 $count 个用户。';
  }

  @override
  String get batchDeleteUsersClearsAccountData => '相关用户的登录会话、第三方绑定和个人资料会被清除。';

  @override
  String get batchDeleteUsersAffectsRelatedData =>
      '这些用户关联的房间关系、聊天记录归属和权限状态会受到影响。';

  @override
  String get preferences => '偏好';

  @override
  String get newUsername => '新用户名';

  @override
  String get usernameLengthHint => '3-50 个字符';

  @override
  String changeUsernameFailed(String error) {
    return '修改用户名失败：$error';
  }

  @override
  String passwordMinimumLength(int count) {
    return '至少 $count 个字符';
  }

  @override
  String get auditReason => '审计原因';

  @override
  String loadReviewsFailed(String error) {
    return '加载审核失败：$error';
  }

  @override
  String get reviewApproved => '审核已通过';

  @override
  String get rejectReview => '拒绝审核';

  @override
  String get rejectionReasonHint => '填写拒绝原因';

  @override
  String get reviewRejected => '审核已拒绝';

  @override
  String get registration => '注册';

  @override
  String get roomCreation => '建房';

  @override
  String get roomDefaults => '房间默认设置';

  @override
  String get joinRequest => '加入';

  @override
  String get searchReviewHint => '搜索或输入 room_/usr_ ID';

  @override
  String get noReviewRecords => '暂无审核记录';

  @override
  String reviewedBy(String reviewer) {
    return '审核人 $reviewer';
  }

  @override
  String reviewedAt(String time) {
    return '审核 $time';
  }

  @override
  String get roomPasswordOptionalDescription => '创建房间时可自行决定是否设置密码。';

  @override
  String get roomPasswordRequiredDescription => '所有新房间都必须设置密码。';

  @override
  String get roomPasswordDisabledDescription => '新房间无法设置密码。';

  @override
  String get required => '必须';

  @override
  String get cors => '跨域';

  @override
  String get permissions => '权限';

  @override
  String get sendChat => '发送聊天';

  @override
  String get browseLibrary => '浏览媒体库';

  @override
  String get viewMembers => '查看成员';

  @override
  String get useWebRtc => '使用 WebRTC';

  @override
  String get deleteMedia => '删除媒体';

  @override
  String get reorderPlaylist => '调整播放列表';

  @override
  String get liveControl => '直播控制';

  @override
  String get playbackControl => '播放控制';

  @override
  String get roomPermissionNavigatePlayback => '切换播放内容';

  @override
  String get previousVideo => '上一个视频';

  @override
  String get nextVideo => '下一个视频';

  @override
  String get playbackHistory => '播放历史';

  @override
  String get playbackHistoryEmpty => '暂无播放历史';

  @override
  String get playHistoryEntry => '播放此记录';

  @override
  String get newestFirst => '最新优先';

  @override
  String get oldestFirst => '最早优先';

  @override
  String get deletePlaybackHistoryEntryTitle => '删除历史记录';

  @override
  String get deletePlaybackHistoryEntryConfirm => '从房间播放历史中删除这条记录？';

  @override
  String get deleteCurrentPlaybackHistoryEntryConfirm =>
      '从房间播放历史中删除当前记录？正在播放的内容会继续，上一项/下一项的历史导航会重置。';

  @override
  String get clearPlaybackHistoryTitle => '清空播放历史';

  @override
  String get clearPlaybackHistoryConfirm => '删除此房间的全部播放历史？正在播放的内容会继续，此操作无法撤销。';

  @override
  String get viewPlaybackHistory => '查看播放历史';

  @override
  String get playbackHistoryRetentionDays => '播放历史保留天数';

  @override
  String get playbackHistoryRetentionDaysDescription =>
      '播放历史的保留天数，设为 0 可关闭按时间清理。';

  @override
  String get playbackHistoryMaxEntries => '播放历史数量上限';

  @override
  String get playbackHistoryMaxEntriesDescription =>
      '每个房间最多保留的记录数，设为 0 可关闭按数量清理。';

  @override
  String get changePlaybackRate => '调整倍速';

  @override
  String get approveMember => '审批成员';

  @override
  String get setMemberPermissions => '设置成员权限';

  @override
  String get changeRoomSettings => '修改房间设置';

  @override
  String get deleteChat => '删除聊天';

  @override
  String get roomPermissionManageOwnMedia => '管理自己的媒体';

  @override
  String get roomPermissionReorderMedia => '调整媒体与播放列表顺序';

  @override
  String get roomPermissionClearMedia => '清空媒体队列';

  @override
  String get roomPermissionManageLiveStreams => '管理直播';

  @override
  String get roomPermissionReviewJoinRequests => '审核加入申请';

  @override
  String get roomPermissionRemoveMembers => '移除成员';

  @override
  String get roomPermissionManageMemberPermissions => '管理成员权限';

  @override
  String get roomPermissionAddMembers => '添加成员';

  @override
  String get roomPermissionManageRoomSettings => '管理房间设置';

  @override
  String get roomPermissionDeleteChatMessages => '删除聊天消息';

  @override
  String get defaultRoomMemberLimit => '默认房间成员上限';

  @override
  String get defaultRoomMemberLimitDescription => '新房间默认使用的成员上限。';

  @override
  String get roomChatSnapshotLimit => '房间聊天快照条数';

  @override
  String get roomChatSnapshotLimitDescription =>
      '新房间默认保留并推送给客户端的聊天消息上限，0 表示不限制。';

  @override
  String get allowRoomCreation => '允许创建房间';

  @override
  String get allowRoomCreationDescription => '控制普通用户是否可以创建新房间。';

  @override
  String get roomCreationRequiresReview => '创建房间需要审核';

  @override
  String get roomCreationRequiresReviewDescription => '新建房间进入审核流程，通过后可以正常使用。';

  @override
  String get roomPasswordPolicy => '房间密码策略';

  @override
  String get roomPasswordPolicyDescription => '统一约束新房间是否可以或必须设置密码。';

  @override
  String get maximumRoomsPerUser => '每个用户最多房间数';

  @override
  String get maximumRoomsPerUserDescription => '限制单个用户可拥有的房间数量。';

  @override
  String get allowPasswordSignup => '允许密码注册';

  @override
  String get allowPasswordSignupDescription => '用户可以使用用户名和密码注册账号。';

  @override
  String get passwordSignupRequiresReview => '密码注册需要审核';

  @override
  String get passwordSignupRequiresReviewDescription => '新账号注册后需要管理员审核。';

  @override
  String get allowEmailSignup => '允许邮箱注册';

  @override
  String get allowEmailSignupDescription => '用户可以通过邮箱验证码注册账号。';

  @override
  String get emailSignupRequiresReview => '邮箱注册需要审核';

  @override
  String get emailSignupRequiresReviewDescription => '邮箱注册完成后需要管理员审核。';

  @override
  String get allowPasskeySignup => '允许 Passkey 注册';

  @override
  String get allowPasskeySignupDescription => '用户可以使用系统 Passkey 创建账号。';

  @override
  String get passkeySignupRequiresReview => 'Passkey 注册需要审核';

  @override
  String get passkeySignupRequiresReviewDescription => 'Passkey 注册后需要管理员审核。';

  @override
  String get allowGuests => '允许游客';

  @override
  String get allowGuestsDescription => '未登录用户可以进入允许游客的房间。';

  @override
  String get allowGuestsWarning => '游客访问会降低房间访问门槛，请确认公开房间和默认权限配置符合预期。';

  @override
  String get externalLogin => '第三方登录';

  @override
  String get externalLoginDescription => '管理 OAuth2/OIDC 登录提供方、注册策略和回调配置。';

  @override
  String get externalLoginWarning =>
      'OAuth2 配置会影响登录入口，错误的回调地址、密钥或端点会导致第三方登录不可用。';

  @override
  String get rtmpPublishAddress => '推流发布地址';

  @override
  String get rtmpPublishAddressDescription => '覆盖对外展示的 RTMP 发布主机，留空使用服务端地址。';

  @override
  String get tsSegmentsAsPng => 'TS 分片伪装为 PNG';

  @override
  String get tsSegmentsAsPngDescription => '将 HLS TS 分片以 PNG 后缀暴露，用于部分网络环境兼容。';

  @override
  String get enableEmailService => '启用邮件服务';

  @override
  String get enableEmailServiceDescription => '允许服务端发送邮箱绑定、密码重置、MFA 和通知邮件。';

  @override
  String get enableEmailServiceWarning => '启用前请确认 SMTP 主机、发件地址和认证信息正确。';

  @override
  String get smtpHost => 'SMTP 主机';

  @override
  String get smtpHostDescription => '启用邮件发送时必填的邮件服务器地址。';

  @override
  String get smtpPort => 'SMTP 端口';

  @override
  String get smtpPortDescription => '常用端口为 587、465 或 25。';

  @override
  String get smtpAuthentication => 'SMTP 认证';

  @override
  String get smtpAuthenticationDescription => '服务器要求认证时配置 SMTP 用户名和密码。';

  @override
  String get smtpAuthenticationWarning => 'SMTP 密码属于敏感凭据，保存前请确认当前环境和管理员账号可信。';

  @override
  String get smtpProxy => 'SMTP 代理';

  @override
  String get smtpProxyDescription => '配置可选 SOCKS5 代理及代理认证。';

  @override
  String get smtpProxyWarning => '邮件流量和 SMTP 目标地址会经过代理服务器，请使用可信代理。';

  @override
  String get useTls => '使用 TLS';

  @override
  String get useTlsDescription => '启用 SMTP TLS/STARTTLS。';

  @override
  String get useTlsWarning => '关闭 TLS 可能导致邮件认证信息明文传输，请仅在受控网络或开发环境使用。';

  @override
  String get senderEmail => '发件邮箱';

  @override
  String get senderEmailDescription => '启用邮件发送时必填的合法 From 地址。';

  @override
  String get senderDisplayName => '发件人显示名';

  @override
  String get senderDisplayNameDescription => '用户收到邮件时看到的发件人名称。';

  @override
  String get enableEmailWhitelist => '启用邮箱白名单';

  @override
  String get enableEmailWhitelistDescription => '限制邮箱注册只能使用指定域名或邮箱。';

  @override
  String get emailWhitelist => '邮箱白名单';

  @override
  String get emailWhitelistDescription =>
      '每行一个邮箱或域名，域名可使用 example.com 或 @example.com。';

  @override
  String get externalIceServers => '外部 ICE 服务器';

  @override
  String get externalIceServersDescription => '向客户端下发的 STUN/TURN 服务器列表。';

  @override
  String get externalIceServersWarning => 'TURN 用户名和凭据会下发给客户端，请使用最小权限且可轮换的账号。';

  @override
  String get maxVoiceParticipantsPerRoom => '每房间语音人数上限';

  @override
  String get maxVoiceParticipantsPerRoomDescription =>
      '单个房间同时参与语音的人数上限。Mesh 语音允许 2 至 32，移动端推荐 8。';

  @override
  String get chatMessagesPerRoom => '每个房间保留聊天数';

  @override
  String get chatMessagesPerRoomDescription => '聊天消息按房间保留的数量上限，0 表示不限制。';

  @override
  String get chatRetentionDays => '聊天保留天数';

  @override
  String get chatRetentionDaysDescription => '聊天消息的最长保留时间。';

  @override
  String get allowedCorsOrigins => '允许跨域来源';

  @override
  String get allowedCorsOriginsDescription =>
      '允许访问代理接口的 Web Origin 列表，原生客户端通常无需配置。';

  @override
  String get allowedCorsOriginsWarning =>
      '宽泛的跨域来源会扩大浏览器访问面，请只添加明确可信的 HTTPS Origin。';

  @override
  String get adminDefaultPermissions => '管理员默认权限';

  @override
  String get adminDefaultPermissionsDescription => '房间管理员的默认权限集合。';

  @override
  String get memberDefaultPermissions => '成员默认权限';

  @override
  String get memberDefaultPermissionsDescription => '普通成员加入房间后的默认权限集合。';

  @override
  String get guestDefaultPermissions => '游客默认权限';

  @override
  String get guestDefaultPermissionsDescription => '游客进入房间后的服务端支持权限集合。';

  @override
  String get guestDefaultPermissionsWarning => '游客权限会影响未登录用户，请只授予查看和低风险操作权限。';

  @override
  String runtimeSectionDescription(String section) {
    return '$section运行时配置。';
  }

  @override
  String get noExternalLoginConfigured => '未配置第三方登录';

  @override
  String oauthProviderSummary(int total, int configured) {
    return '$total 个实例，$configured 个已填写 Client ID';
  }

  @override
  String get noIceServersConfigured => '未配置 ICE 服务器';

  @override
  String iceServerCount(int count) {
    return '$count 个 ICE 服务器';
  }

  @override
  String get authenticationDisabled => '未启用认证';

  @override
  String configuredUser(String username) {
    return '已配置用户 $username';
  }

  @override
  String get directConnection => '使用直连';

  @override
  String get emptyList => '空列表';

  @override
  String get noPermissions => '无权限';

  @override
  String get emptyObject => '空对象';

  @override
  String configurationCount(int count) {
    return '$count 项配置';
  }

  @override
  String configurableSettingsCount(int count) {
    return '$count 项可配置设置';
  }

  @override
  String get refreshCurrentSection => '刷新当前分区';

  @override
  String refreshSettingsFailed(String error) {
    return '刷新设置失败：$error';
  }

  @override
  String updateSettingsFailed(String error) {
    return '更新设置失败：$error';
  }

  @override
  String get deleteLoginProvider => '删除登录提供方';

  @override
  String confirmDeleteLoginProvider(String name) {
    return '确认删除 OAuth2 登录提供方“$name”？删除后用户将无法通过该入口登录。';
  }

  @override
  String get confirmChanges => '确认修改';

  @override
  String get sendTestEmail => '发送测试邮件';

  @override
  String get recipient => '收件人';

  @override
  String get testEmailSent => '测试邮件已发送';

  @override
  String sendTestEmailFailed(String error) {
    return '发送测试邮件失败：$error';
  }

  @override
  String get noSettings => '暂无设置';

  @override
  String get addLoginProvider => '添加登录提供方';

  @override
  String get runtimeSettings => '运行时设置';

  @override
  String get refreshAll => '刷新全部';

  @override
  String get content => '内容';

  @override
  String enterSettingValue(String setting) {
    return '请输入$setting';
  }

  @override
  String get enableSmtpAuthentication => '启用 SMTP 认证';

  @override
  String get enableSmtpAuthenticationDescription => '服务器要求登录时配置用户名和密码。';

  @override
  String get smtpUsernameRequired => '请输入 SMTP 用户名';

  @override
  String get emptyKeepsCurrentPassword => '留空保留现有密码';

  @override
  String get passwordRequiredForNewCredentials => '新认证或更换用户名时必须输入密码';

  @override
  String get enableSmtpProxy => '启用 SMTP 代理';

  @override
  String get enableSmtpProxyDescription => '邮件连接通过 SOCKS5 代理建立。';

  @override
  String get socks5ProxyAddress => 'SOCKS5 代理地址';

  @override
  String get socks5ProxyAddressRequired => '请输入 socks5:// 开头的代理地址';

  @override
  String get proxyRequiresAuthentication => '代理需要认证';

  @override
  String get proxyAuthenticationDescription => '配置 SOCKS5 用户名和密码。';

  @override
  String get proxyUsername => '代理用户名';

  @override
  String get proxyUsernameRequired => '请输入代理用户名';

  @override
  String get proxyPassword => '代理密码';

  @override
  String get providerTypes => 'Provider 类型';

  @override
  String get noProviderTypes => '暂无可选类型';

  @override
  String get selectAtLeastOneProviderType => '至少选择一个 Provider 类型';

  @override
  String loadProviderInstancesFailed(String error) {
    return '加载 Provider 实例失败：$error';
  }

  @override
  String get providerInstanceUpdated => '实例已更新';

  @override
  String get providerInstanceCreated => '实例已创建';

  @override
  String saveProviderInstanceFailed(String error) {
    return '保存 Provider 实例失败：$error';
  }

  @override
  String get deleteProvider => '删除 Provider';

  @override
  String confirmDeleteProvider(String name) {
    return '确定要删除 $name 吗？';
  }

  @override
  String get providerInstanceDeleted => '实例已删除';

  @override
  String deleteProviderFailed(String error) {
    return '删除 Provider 失败：$error';
  }

  @override
  String get reconnectStarted => '已发起重连';

  @override
  String reconnectFailed(String error) {
    return '重连失败：$error';
  }

  @override
  String get searchProviderInstances => '搜索名称或 Endpoint';

  @override
  String get allTlsStates => '全部 TLS';

  @override
  String get tlsEnabled => 'TLS 开启';

  @override
  String get tlsDisabled => 'TLS 关闭';

  @override
  String get sortByName => '按名称';

  @override
  String get sortByEndpoint => '按 Endpoint';

  @override
  String get sortByCreatedAt => '按创建时间';

  @override
  String get sortByUpdatedAt => '按更新时间';

  @override
  String get noProviderInstances => '暂无 Provider 实例';

  @override
  String get noAvailableBackends => '当前类型暂无可用 Backend';

  @override
  String get backendCopied => 'Backend 已复制';

  @override
  String get refreshBackends => '刷新 Backend';

  @override
  String get tlsUnverified => 'TLS 不校验';

  @override
  String get tlsVerified => 'TLS 校验';

  @override
  String providerInstanceTimes(String createdAt, String updatedAt) {
    return '创建 $createdAt · 更新 $updatedAt';
  }

  @override
  String get enableProviderInstance => '启用实例';

  @override
  String get reconnect => '重连';

  @override
  String get editProviderInstance => '编辑 Provider 实例';

  @override
  String get addProviderInstance => '新增 Provider 实例';

  @override
  String get configureProviderNode => '配置外部媒体 Provider 节点';

  @override
  String get instanceName => '实例名称';

  @override
  String get instanceNameRequired => '请输入实例名称';

  @override
  String get endpointRequired => '请输入 Endpoint';

  @override
  String get requestTimeout => '请求超时';

  @override
  String get secondsShort => '秒';

  @override
  String get positiveIntegerRequired => '请输入大于 0 的整数';

  @override
  String get capabilityTypes => '能力类型';

  @override
  String get capabilityTypesDescription => '一个实例可以同时承载多个 Provider 类型。';

  @override
  String get connectionSecurity => '连接安全';

  @override
  String get connectionSecurityDescription => '不安全 TLS 仅用于受控内网或测试环境。';

  @override
  String get enableTls => '启用 TLS';

  @override
  String get providerTlsConnection => '使用 HTTPS/TLS 连接 Provider';

  @override
  String get providerPlainConnection => '使用非 TLS 连接';

  @override
  String get allowInsecureTls => '允许不安全 TLS';

  @override
  String get allowInsecureTlsDescription => '跳过证书校验会增加中间人攻击风险。';

  @override
  String get emptyKeepsCurrentValue => '留空保留当前值';

  @override
  String get clearJwtSecret => '清除 JWT Secret';

  @override
  String get pemEmptyKeepsCurrent => 'PEM 内容，留空保留当前值';

  @override
  String get pemOptional => 'PEM 内容，可选';

  @override
  String get clearCustomCa => '清除 Custom CA';

  @override
  String get notes => '备注';

  @override
  String get providerNotesHint => '可选，用于标记部署位置、用途或维护信息';

  @override
  String get clearNotes => '清除备注';

  @override
  String get providerEditFooterHint => '仅提交已填写或明确清除的敏感字段';

  @override
  String get providerCreateFooterHint => '创建后可在列表中启停、重连或编辑';

  @override
  String get searchStreamsHint => '搜索或输入 room_/usr_/node_ ID';

  @override
  String get startedAt => '开始时间';

  @override
  String get node => '节点';

  @override
  String loadBanRecordsFailed(String error) {
    return '加载封禁记录失败：$error';
  }

  @override
  String get banRecordMissingTargetId => '封禁记录缺少目标 ID，无法解封';

  @override
  String get unbanUser => '解封用户';

  @override
  String get unbanRoom => '解封房间';

  @override
  String confirmUnban(String target) {
    return '确定要解除“$target”的封禁吗？';
  }

  @override
  String get unbanned => '已解除封禁';

  @override
  String unbanFailed(String error) {
    return '解封失败：$error';
  }

  @override
  String get allTargets => '全部对象';

  @override
  String get revokedOrExpired => '已撤销或过期';

  @override
  String get userOrRoomIdHint => '输入 usr_/room_ ID';

  @override
  String get noBanRecords => '暂无封禁记录';

  @override
  String banRecordSummary(String reason, String operator, String time) {
    return '$reason\n操作者：$operator · $time';
  }

  @override
  String get noReason => '无原因';

  @override
  String get ended => '已结束';

  @override
  String loadReportsFailed(String error) {
    return '加载举报记录失败：$error';
  }

  @override
  String get reportDetails => '举报详情';

  @override
  String get target => '目标';

  @override
  String get reporter => '举报人';

  @override
  String get reviewedByLabel => '处理人';

  @override
  String get reviewedAtLabel => '处理时间';

  @override
  String get resolutionNote => '处置说明';

  @override
  String get resolve => '处置';

  @override
  String get resolveReport => '处置举报';

  @override
  String get reviewing => '处理中';

  @override
  String get resolved => '已处理';

  @override
  String get dismissed => '已驳回';

  @override
  String get reportOpenStatus => '待处理';

  @override
  String resolveReportFailed(String error) {
    return '处置失败：$error';
  }

  @override
  String get reportStatusUpdated => '举报状态已更新';

  @override
  String get messages => '消息';

  @override
  String get searchReportsHint => '搜索原因、对象或 usr_/room_ ID';

  @override
  String get noReportRecords => '暂无举报记录';

  @override
  String reportListSummary(String reason, String reporter, String time) {
    return '$reason\n举报人：$reporter · $time';
  }

  @override
  String reporterFilter(String id) {
    return '举报人 $id';
  }

  @override
  String contextRoomFilter(String id) {
    return '上下文房间 $id';
  }

  @override
  String reportedRoomFilter(String id) {
    return '被举报房间 $id';
  }

  @override
  String reportedUserFilter(String id) {
    return '被举报用户 $id';
  }

  @override
  String memberRoomFilter(String id) {
    return '成员所在房间 $id';
  }

  @override
  String reportedMemberFilter(String id) {
    return '被举报成员 $id';
  }

  @override
  String messageFilter(int id) {
    return '消息 #$id';
  }

  @override
  String roomTarget(String target) {
    return '房间 $target';
  }

  @override
  String userTarget(String target) {
    return '用户 $target';
  }

  @override
  String memberTarget(String user, String room) {
    return '成员 $user · $room';
  }

  @override
  String chatMessageTarget(int id, String room) {
    return '聊天消息 #$id · $room';
  }

  @override
  String unknownTarget(String id) {
    return '未知对象 $id';
  }

  @override
  String get entry => '条目';

  @override
  String get enterEntry => '输入条目';

  @override
  String get valueRequired => '请输入数值';

  @override
  String get validNumberRequired => '请输入有效数值';

  @override
  String get noLoginProviders => '还没有第三方登录实例';

  @override
  String get noLoginProvidersDescription =>
      '添加 GitHub、Google、Logto 或通用 OIDC 实例后，登录页会展示对应入口。';

  @override
  String get addLoginProviderHint =>
      '使用添加按钮创建 GitHub、Google、Logto 或通用 OIDC 登录入口。';

  @override
  String loginProviderSummary(String providerType, String clientStatus) {
    return '$providerType · $clientStatus';
  }

  @override
  String get clientConfigured => '已配置客户端';

  @override
  String get clientIdMissing => '未填写 Client ID';

  @override
  String get signupAllowed => '允许注册';

  @override
  String get loginBindingOnly => '仅登录绑定';

  @override
  String get signupRequiresReview => '注册需审核';

  @override
  String get addExternalLogin => '添加第三方登录';

  @override
  String get editExternalLogin => '编辑第三方登录';

  @override
  String get externalLoginEditorDescription => '配置 OAuth2/OIDC 登录实例、回调地址和注册策略。';

  @override
  String get instanceNameFormatHint => '只能使用字母、数字、下划线和连字符';

  @override
  String get providerType => '提供方类型';

  @override
  String get clientSecretRequired => '请输入 Client Secret';

  @override
  String get callbackUrl => '回调地址';

  @override
  String get authorizationEndpoint => '授权端点';

  @override
  String get emptyUsesOidcDiscovery => '留空使用 OIDC Discovery';

  @override
  String get tokenEndpoint => 'Token 端点';

  @override
  String get userInfoEndpoint => 'UserInfo 端点';

  @override
  String get jwksEndpoint => 'JWKS 端点';

  @override
  String get allowProviderSignup => '允许用此提供方注册';

  @override
  String get allowProviderSignupDescription => '关闭后只允许已绑定的用户登录。';

  @override
  String get saveInstance => '保存实例';

  @override
  String fieldRequired(String field) {
    return '请输入$field';
  }

  @override
  String instanceNameTooLong(int maxLength) {
    return '实例名称不能超过 $maxLength 个字符';
  }

  @override
  String get instanceNameExists => '实例名称已存在';

  @override
  String get urlRequired => '请输入 URL';

  @override
  String get validUrlRequired => '请输入有效 URL';

  @override
  String get httpUrlRequired => '只允许 http 或 https 地址';

  @override
  String get noIceServersDescription => '添加 STUN 或 TURN 服务器后，客户端会优先使用这里的连接配置。';

  @override
  String get addIceServer => '添加 ICE 服务器';

  @override
  String iceServerNumber(int number) {
    return 'ICE 服务器 $number';
  }

  @override
  String get iceServerUrlsHint => '每行一个，例如 stun:host:3478 或 turns:host:5349';

  @override
  String get atLeastOneUrlRequired => '至少填写一个 URL';

  @override
  String get iceServerUrlSchemeRequired => '只支持 stun:/turn:/turns: URL';

  @override
  String get credential => '凭据';

  @override
  String pageSizeSummary(int page, int pageSize) {
    return '第 $page 页 · 每页 $pageSize 条';
  }

  @override
  String pageSizeTotalSummary(int page, int pageSize, int total) {
    return '第 $page 页 · 每页 $pageSize 条 · 共 $total 条';
  }

  @override
  String get messageHasNoCopyableContent => '这条消息没有可复制内容';

  @override
  String confirmDeleteUserMessage(String username) {
    return '删除 $username 的这条消息？';
  }

  @override
  String messagesLoaded(int count) {
    return '已加载 $count 条消息';
  }

  @override
  String get olderMessagesAvailable => '还有更早消息';

  @override
  String get loading => '加载中';

  @override
  String get loadOlderMessages => '加载更早消息';

  @override
  String get noChatMessages => '暂无聊天消息';

  @override
  String get deletedUser => '已删除用户';

  @override
  String messageAuthorTime(String author, String time) {
    return '$author · $time';
  }

  @override
  String get messageDeletedContent => '这条消息已删除';

  @override
  String get context => '上下文';

  @override
  String imageCount(int count) {
    return '[图片 $count]';
  }

  @override
  String get creatorUnavailable => '创建者不可用';

  @override
  String pageNumber(int page) {
    return '第 $page 页';
  }

  @override
  String pageTotalSummary(int page, int total) {
    return '第 $page 页 · 共 $total 条';
  }

  @override
  String get switchControl => '开关';

  @override
  String get selectOption => '请选择';

  @override
  String get inviteLinkCopied => '邀请链接已复制';

  @override
  String get playbackAuthenticationRequired =>
      '目标媒体站点要求登录。请检查链接是否公开可访问，或重新添加带有效凭据的媒体。';

  @override
  String get playbackAccessForbidden => '目标媒体站点拒绝访问此视频。请检查链接权限、来源限制或直链请求头。';

  @override
  String get playbackNotFound => '视频地址不存在或已经失效。请检查链接后重新添加。';

  @override
  String get playbackRateLimited => '目标媒体站点请求过于频繁。请稍后重试或更换可访问的资源。';

  @override
  String get playbackFormatUnsupported => '当前设备无法播放此视频格式。请更换 MP4/HLS 等常见格式资源。';

  @override
  String get playbackConnectionFailed => '视频连接失败。请检查网络、代理设置或目标站点可用性。';

  @override
  String get playbackLoadFailed => '视频加载失败。请确认链接可公开访问，且当前设备支持此视频格式。';

  @override
  String get image => '图片';

  @override
  String get enterAuthenticatorCode => '请输入认证器中的 6 位验证码';

  @override
  String get enterRecoveryCode => '请输入恢复码';

  @override
  String get authenticatorCode => '认证器验证码';

  @override
  String get verifyWithAuthenticator => '使用认证器验证';

  @override
  String get verifyWithEmail => '使用邮箱验证';

  @override
  String get recoveryCode => '恢复码';

  @override
  String get useRecoveryCode => '使用恢复码';

  @override
  String get backToVerificationMethods => '返回验证方式';

  @override
  String get verifyWithRecoveryCode => '使用恢复码验证';

  @override
  String get authenticatorApp => '认证器 App';

  @override
  String setupAuthenticatorFailed(String error) {
    return '设置认证器失败：$error';
  }

  @override
  String regenerateRecoveryCodesFailed(String error) {
    return '重新生成恢复码失败：$error';
  }

  @override
  String get removeAuthenticatorApp => '移除认证器 App';

  @override
  String get removeAuthenticatorAppConfirmation => '移除认证器 App 及其全部恢复码？';

  @override
  String get authenticatorAppRemoved => '认证器 App 已移除';

  @override
  String removeAuthenticatorFailed(String error) {
    return '移除认证器失败：$error';
  }

  @override
  String get authenticatorAppDescription => '使用标准认证器 App 生成的动态验证码完成多因素验证';

  @override
  String get authenticatorAppConfigured => '已配置';

  @override
  String get authenticatorAppNotConfigured => '未配置';

  @override
  String recoveryCodesRemaining(int count) {
    return '剩余 $count 个恢复码';
  }

  @override
  String get authenticatorAppSetupHint => '添加认证器 App 以增强账户安全';

  @override
  String get recoveryCodes => '恢复码';

  @override
  String get setup => '设置';

  @override
  String get setupAuthenticatorApp => '设置认证器 App';

  @override
  String get setupAuthenticatorAppDescription => '使用标准认证器 App 扫描二维码，或手动输入设置密钥。';

  @override
  String get manualSetupKey => '手动设置密钥';

  @override
  String get confirmSetup => '确认设置';

  @override
  String get saveRecoveryCodes => '保存恢复码';

  @override
  String get recoveryCodesShownOnce => '每个恢复码只能使用一次。请安全保存，本页面关闭后将无法再次查看。';

  @override
  String get copyAll => '全部复制';

  @override
  String get savedRecoveryCodes => '我已保存恢复码';

  @override
  String get sliceCache => '切片缓存';

  @override
  String get nodeId => '节点 ID';

  @override
  String get currentNode => '当前节点';

  @override
  String get allNodes => '全部节点';

  @override
  String loadSliceCacheFailed(String error) {
    return '加载切片缓存统计失败：$error';
  }

  @override
  String get nodeUnavailable => '节点不可用';

  @override
  String get noSliceCacheStats => '暂无切片缓存统计';

  @override
  String get evictExpiredSliceCache => '淘汰过期项';

  @override
  String get purgeSliceCache => '清空缓存';

  @override
  String get confirmPurgeSliceCache => '清空所选目标的全部切片缓存？正在播放的媒体可能需要重新拉取数据。';

  @override
  String sliceCacheEvictionCompleted(int count) {
    return '已移除 $count 个过期缓存项';
  }

  @override
  String sliceCachePurgeCompleted(int count, String size) {
    return '已移除 $count 个缓存项，释放 $size';
  }

  @override
  String get sliceCacheNodeOperationFailed => '此节点的缓存操作执行失败';

  @override
  String get sliceCacheUsage => '使用率';

  @override
  String get sliceCacheSize => '已存数据';

  @override
  String get sliceCacheEntries => '缓存项';

  @override
  String get sliceCacheUpdating => '更新中';

  @override
  String get sliceCacheLocks => '锁数量';

  @override
  String get sliceCacheBackend => '后端';

  @override
  String get sliceCacheDirectory => '目录';

  @override
  String get sliceCacheCapacity => '容量';

  @override
  String get sliceCacheSliceSize => '切片大小';

  @override
  String get sliceCacheSegmentTtl => '分片 TTL';

  @override
  String get sliceCacheStaleMaxAge => '陈旧数据上限';

  @override
  String get sliceCacheEvictionInterval => '淘汰间隔';

  @override
  String get staleWhileRevalidate => '后台刷新陈旧缓存';

  @override
  String get privacy => '隐私';

  @override
  String get blockedUsers => '已拉黑用户';

  @override
  String get blockedUsersDescription => '这些用户的消息将被隐藏，他们创建的房间也不会出现在首页发现中。';

  @override
  String get blockUser => '拉黑用户';

  @override
  String get unblockUser => '解除拉黑';

  @override
  String confirmBlockUser(String name) {
    return '拉黑 $name？其消息将立即消失，其创建的房间也会从首页发现中隐藏。已有房间关系仍会保留。';
  }

  @override
  String confirmUnblockUser(String name) {
    return '解除对 $name 的拉黑？其消息和房间将重新可见。';
  }

  @override
  String get userBlocked => '已拉黑用户';

  @override
  String get userUnblocked => '已解除拉黑';

  @override
  String blockUserFailed(String error) {
    return '拉黑用户失败：$error';
  }

  @override
  String unblockUserFailed(String error) {
    return '解除拉黑失败：$error';
  }

  @override
  String get noBlockedUsers => '暂无已拉黑用户';

  @override
  String get searchBlockedUsers => '搜索已拉黑用户';

  @override
  String blockedAt(String time) {
    return '拉黑于 $time';
  }

  @override
  String get blockedCreator => '创建者已拉黑';

  @override
  String get blockedUsersTemporarilyUnavailable => '暂时无法加载已拉黑用户';
}
