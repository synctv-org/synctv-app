import 'package:flutter/material.dart';
import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/services/opaque_authenticator_service.dart';
import 'package:synctv_app/services/oauth2_deep_link_service.dart';
import 'package:synctv_app/services/passkey_authenticator_service.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/user_agreement_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class HuaweiLoginPanel extends StatefulWidget {
  final VoidCallback? onOtherLogin;

  const HuaweiLoginPanel({super.key, this.onOtherLogin});

  @override
  State<HuaweiLoginPanel> createState() => _HuaweiLoginPanelState();
}

class _HuaweiLoginPanelState extends State<HuaweiLoginPanel>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _emailTokenRequested = false;
  bool _mfaEmailRequested = false;
  bool _passkeyAvailable = false;
  PublicSettingsInfo? _publicSettings;
  List<OAuth2ProviderOption> _oauth2Providers = const [];
  MfaChallengeInfo? _mfaChallenge;

  final _emailController = TextEditingController();
  final _emailTokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mfaTokenController = TextEditingController();
  final _guestRoomController = TextEditingController();
  late final OpaqueAuthenticatorService _opaqueAuthenticator;
  String? _oauthProvider;
  int _oauthAttempt = 0;

  bool get _isHarmony => Platform.operatingSystem.toLowerCase() == 'ohos';

  static const String _userAgreementContent = '''
# 看搭子APP用户服务协议

**更新日期：2026年03月16日**  
**生效日期：2026年03月16日**

> **重要提示：请您在使用本软件之前，仔细阅读并充分理解本协议内容，尤其是以加粗形式提示的条款。您使用本软件即视为已阅读、理解并同意接受本协议全部内容。**

---

# 一、关于我们

感谢您使用 **看搭子APP**。

看搭子APP是由 **唐政**（以下简称“我们”或“开发者”）开发的一款用于 **本地或私有服务器内容展示与播放的软件工具**。

**看搭子APP本身不提供公共内容服务器、不存储用户内容、不运营公共内容平台。**

本软件仅作为技术工具，帮助用户在 **自有服务器或本地设备** 上部署并展示多媒体内容。

---

# 二、协议范围及确认

本《看搭子APP用户服务协议》（以下简称“本协议”）是您与开发者之间关于您下载、安装和使用本软件所订立的法律协议。

当您：

- 下载本软件
- 安装本软件
- 注册或使用本软件
- 使用本软件连接您的服务器

即表示您已经 **阅读、理解并同意接受本协议的全部内容**。

如您不同意本协议的任何内容，请立即停止使用本软件。

---

# 三、软件性质说明

## 3.1 软件工具属性

看搭子APP是一款 **通用内容展示工具软件**，主要用于：

- 企业宣传视频播放
- 企业发展历史介绍
- 企业文化展示
- 展厅多媒体展示
- 私有媒体内容播放

---

## 3.2 私有服务器模式

本软件采用 **用户私有服务器架构**：

- 所有内容均存储于 **用户自有服务器或本地设备**
- 开发者 **不提供任何公共内容服务器**
- 开发者 **无法访问、控制或管理用户内容**

---

## 3.3 无内容运营

开发者：

- 不参与内容制作
- 不参与内容发布
- 不审核用户内容
- 不运营内容平台

**本软件仅提供技术工具服务。**

---

# 四、用户使用条件

您在使用本软件时应保证：

- 您具有完全民事行为能力；
- 您对所使用服务器及内容拥有合法使用权；
- 您拥有上传或展示内容的合法授权；
- 您的行为符合相关法律法规。

若您为未成年人，应在 **监护人指导下使用本软件**。

---

# 五、用户使用规则

您在使用本软件时应遵守以下规定：

## 5.1 合法使用

您不得利用本软件从事任何违法违规行为，包括但不限于：

- 发布违法信息
- 传播淫秽、暴力内容
- 发布虚假信息
- 侵犯他人知识产权
- 从事诈骗或非法活动

---

## 5.2 内容责任

**用户对其服务器中的全部内容承担全部法律责任。**

包括但不限于：

- 视频
- 音频
- 图片
- 文字
- 数据内容

开发者 **不对用户内容进行审核，也不承担相关责任。**

---

## 5.3 服务器管理

用户应自行负责：

- 服务器安全
- 数据备份
- 网络配置
- 内容管理

由于 **用户服务器问题造成的损失，开发者不承担责任。**

---

# 六、免责声明

## 6.1 技术工具免责

看搭子APP仅为 **技术工具软件**。

开发者 **不对用户内容的合法性、真实性、完整性承担任何责任**。

---

## 6.2 内容责任免责

由于本软件采用 **用户私有服务器架构**：

用户上传、存储或展示的内容 **完全由用户自行管理**。

如因用户内容涉及：

- 违法信息
- 侵权行为
- 不良信息传播

**相关法律责任由用户自行承担，与软件开发者无关。**

---

## 6.3 网络及系统免责

因以下原因导致服务异常或中断的，开发者不承担责任：

- 用户服务器故障
- 网络故障
- 系统维护
- 黑客攻击
- 病毒或恶意软件
- 电力或通信问题
- 不可抗力因素

开发者将 **尽力协助用户解决技术问题**。

---

# 七、用户禁止行为

用户不得利用本软件从事以下行为：

- 发布违反法律法规的信息
- 传播淫秽、色情、赌博、暴力内容
- 侵犯他人知识产权
- 发布诈骗或违法广告
- 从事危害国家安全或社会稳定的行为

如用户违反上述规定：

**用户应自行承担全部法律责任。**

若因此给开发者造成损失，开发者有权要求赔偿。

---

# 八、协议修改

开发者有权根据 **法律法规或产品变化** 对本协议进行更新。

更新后的协议将在 **软件或官网发布**。

若您继续使用本软件，即视为 **您同意修改后的协议**。

如您不同意修改内容，请停止使用本软件。

---

# 九、适用法律及管辖

本协议的订立、执行和解释 **适用中华人民共和国法律**。

若双方发生争议，应首先 **友好协商解决**。

协商不成的，任何一方可向 **开发者所在地人民法院** 提起诉讼。

---

# 十、软件性质与责任声明

## 1. 软件性质声明

本软件仅为 **技术工具软件**，不提供：

- 内容存储
- 内容审核
- 内容运营服务

本软件仅提供 **数据传输与播放功能**，不参与任何形式的 **内容制作与分发**。

---

## 2. 私有服务器声明

本软件采用 **用户私有服务器架构**。

所有内容均存储于：

- 用户自有服务器
- 本地设备

开发者 **无法访问、控制、修改或删除用户服务器中的任何数据**。

---

## 3. 内容责任声明

用户对其服务器中的全部内容承担 **全部法律责任**。

用户应确保：

- 内容符合相关法律法规
- 不侵犯任何第三方合法权益

因用户内容引发的任何法律纠纷：

**由用户自行承担，与软件开发者无关。**

---

## 4. 举报机制

如发现利用本软件 **传播违法违规内容**，欢迎向开发者举报。

开发者将 **积极配合相关部门进行调查取证**。

---

# 十一、联系我们

如您对本协议有任何疑问或需要举报违规行为，可通过以下方式联系我们：

**客服邮箱：**
  tang@lhht.cc
  ''';

  String? _maskedPhone;
  bool _agreedToTerms = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _opaqueAuthenticator = OpaqueAuthenticatorService();
    _loadAuthOptions();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: -4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
  }

  void _triggerReminderAnimation() {
    _shakeController.forward(from: 0.0);
    _scaleController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _scaleController.dispose();
    _emailController.dispose();
    _emailTokenController.dispose();
    _passwordController.dispose();
    _mfaTokenController.dispose();
    _guestRoomController.dispose();
    super.dispose();
  }

  bool _ensureTermsAccepted() {
    if (!_agreedToTerms) {
      _triggerReminderAnimation();
      return false;
    }
    return true;
  }

  Future<void> _loadAuthOptions() async {
    try {
      final results = await Future.wait<dynamic>([
        WatchTogetherService.getPublicSettings(),
        WatchTogetherService.listOAuth2Providers(),
        PasskeyAuthenticatorService.isSupported().catchError((_) => false),
      ]);
      if (!mounted) return;
      setState(() {
        _publicSettings = results[0] as PublicSettingsInfo;
        _oauth2Providers = results[1] as List<OAuth2ProviderOption>;
        _passkeyAvailable = results[2] as bool;
      });
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(context, '加载认证配置失败: $e');
      }
    }
  }

  Future<void> _withLoading(Future<void> Function() action) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await action();
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _completeAuthResult(AuthResult result) {
    if (!mounted) return;
    if (result.requiresMfa) {
      setState(() {
        _mfaChallenge = result.mfa;
        _mfaEmailRequested = false;
        _mfaTokenController.clear();
      });
      MessageUtils.showInfo(context, '需要完成多因素认证');
      return;
    }
    Navigator.pop(context, true);
  }

  Future<void> _requestEmailToken() async {
    if (!_ensureTermsAccepted()) return;
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱');
      return;
    }
    await _withLoading(() async {
      await WatchTogetherService.requestEmailLogin(email);
      if (mounted) {
        setState(() => _emailTokenRequested = true);
        MessageUtils.showSuccess(context, '验证码已发送');
      }
    });
  }

  Future<void> _submitEmailLogin() async {
    if (!_ensureTermsAccepted()) return;
    final email = _emailController.text.trim();
    final token = _emailTokenController.text.trim();
    if (email.isEmpty || token.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱和验证码');
      return;
    }
    await _withLoading(() async {
      final result =
          await WatchTogetherService.confirmEmailLoginResult(email, token);
      _completeAuthResult(result);
    });
  }

  Future<void> _submitOpaqueLogin() async {
    if (!_ensureTermsAccepted()) return;
    final identifier = _emailController.text.trim();
    final password = _passwordController.text;
    await _withLoading(() async {
      final result = await _opaqueAuthenticator.login(
        identifier: identifier,
        password: password,
      );
      _completeAuthResult(result);
    });
  }

  Future<void> _submitOpaqueRegistration() async {
    if (!_ensureTermsAccepted()) return;
    final usernameController = TextEditingController();
    final emailController =
        TextEditingController(text: _emailController.text.trim());
    final passwordController =
        TextEditingController(text: _passwordController.text);
    final registration =
        await showDialog<({String username, String email, String password})>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('注册账号'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '用户名',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '邮箱',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '密码',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final username = usernameController.text.trim();
              final email = emailController.text.trim();
              final password = passwordController.text;
              if (username.isEmpty || email.isEmpty || password.isEmpty) return;
              Navigator.pop(
                context,
                (username: username, email: email, password: password),
              );
            },
            child: const Text('注册'),
          ),
        ],
      ),
    );
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    if (registration == null) return;

    await _withLoading(() async {
      final result = await _opaqueAuthenticator.register(
        username: registration.username,
        email: registration.email,
        password: registration.password,
      );
      if (!mounted) return;
      if (result.user == null) {
        MessageUtils.showInfo(context, '注册申请已提交，等待管理员审核');
      } else {
        _completeAuthResult(result);
      }
    });
  }

  Future<void> _resetOpaquePassword() async {
    if (!_ensureTermsAccepted()) return;
    final reset =
        await showDialog<({String email, String token, String newPassword})>(
      context: context,
      builder: (context) => _LoginPasswordResetDialog(
        initialEmail: _emailController.text.trim(),
      ),
    );
    if (reset == null) return;

    await _withLoading(() async {
      await _opaqueAuthenticator.resetWithEmailToken(
        email: reset.email,
        token: reset.token,
        newPassword: reset.newPassword,
      );
      if (mounted) {
        _emailController.text = reset.email;
        MessageUtils.showSuccess(context, '密码已重置，请使用新密码登录');
      }
    });
  }

  Future<void> _submitPasskeyLogin() async {
    if (!_ensureTermsAccepted()) return;
    final identifier = _emailController.text.trim();
    await _withLoading(() async {
      final start = await WatchTogetherService.startPasskeyLogin(
        email: identifier.contains('@') ? identifier : '',
        username: identifier.contains('@') ? '' : identifier,
      );
      final credential = await PasskeyAuthenticatorService.getCredential(
        start.options,
      );
      final result = await WatchTogetherService.finishPasskeyLogin(
        sessionId: start.sessionId,
        credential: credential,
      );
      _completeAuthResult(result);
    });
  }

  Future<void> _submitPasskeyRegistration() async {
    if (!_ensureTermsAccepted()) return;
    final usernameController = TextEditingController();
    final emailController = TextEditingController(text: _emailController.text);
    final credentialNameController = TextEditingController();
    final registration =
        await showDialog<({String username, String email, String name})>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('注册 Passkey'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '用户名',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '邮箱',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: credentialNameController,
              decoration: const InputDecoration(
                labelText: 'Passkey 名称',
                hintText: '例如 MacBook、手机',
                prefixIcon: Icon(Icons.fingerprint_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final username = usernameController.text.trim();
              final email = emailController.text.trim();
              final name = credentialNameController.text.trim();
              if (username.isEmpty) return;
              Navigator.pop(
                context,
                (username: username, email: email, name: name),
              );
            },
            child: const Text('注册'),
          ),
        ],
      ),
    );
    usernameController.dispose();
    emailController.dispose();
    credentialNameController.dispose();
    if (registration == null) return;

    await _withLoading(() async {
      final start = await WatchTogetherService.startPasskeyRegistration(
        username: registration.username,
        email: registration.email,
        name: registration.name,
      );
      final credential = await PasskeyAuthenticatorService.createCredential(
        start.options,
      );
      final result = await WatchTogetherService.finishPasskeyRegistration(
        sessionId: start.sessionId,
        credential: credential,
      );
      if (!mounted) return;
      if (result.user == null) {
        MessageUtils.showInfo(context, '注册申请已提交，等待管理员审核');
      } else {
        _completeAuthResult(result);
      }
    });
  }

  Future<void> _requestMfaEmailToken() async {
    final challenge = _mfaChallenge;
    if (challenge == null) return;
    if (!challenge.supportsEmail) {
      MessageUtils.showWarning(context, '当前 MFA challenge 不支持邮箱验证');
      return;
    }
    await _withLoading(() async {
      await WatchTogetherService.requestMfaEmailCode(challenge.sessionId);
      if (mounted) {
        setState(() => _mfaEmailRequested = true);
        MessageUtils.showSuccess(context, '二次验证码已发送');
      }
    });
  }

  Future<void> _submitMfaEmailToken() async {
    final challenge = _mfaChallenge;
    final token = _mfaTokenController.text.trim();
    if (challenge == null || token.isEmpty) {
      MessageUtils.showWarning(context, '请输入二次验证码');
      return;
    }
    await _withLoading(() async {
      await WatchTogetherService.verifyMfaEmailCode(
        mfaSessionId: challenge.sessionId,
        emailToken: token,
      );
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _submitMfaPasskey() async {
    final challenge = _mfaChallenge;
    if (challenge == null) return;
    if (!challenge.supportsPasskey) {
      MessageUtils.showWarning(context, '当前账号没有可用的 Passkey');
      return;
    }
    await _withLoading(() async {
      final start = await WatchTogetherService.startMfaPasskey(
        challenge.sessionId,
      );
      final credential = await PasskeyAuthenticatorService.getCredential(
        start.options,
      );
      await WatchTogetherService.finishMfaPasskey(
        mfaSessionId: challenge.sessionId,
        passkeySessionId: start.passkeySessionId,
        credential: credential,
      );
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _submitGuest() async {
    if (!_ensureTermsAccepted()) return;
    final roomId = _guestRoomController.text.trim();
    if (roomId.isEmpty) {
      MessageUtils.showWarning(context, '请输入房间 ID');
      return;
    }
    await _withLoading(() async {
      await WatchTogetherService.createGuestToken(roomId);
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _startOAuth2(OAuth2ProviderOption provider) async {
    if (!_ensureTermsAccepted()) return;
    await _withLoading(() async {
      final callbackSession = await OAuth2DeepLinkService.createSession();
      final start = await WatchTogetherService.startOAuth2Login(
        provider.name,
        redirectUrl: callbackSession.redirectUrl,
      );
      try {
        setState(() {
          _oauthProvider = provider.name;
          _oauthAttempt++;
        });
        final attempt = _oauthAttempt;
        final uri = Uri.parse(start.authorizationUrl);
        final opened = await canLaunchUrl(uri) &&
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!opened) {
          throw StateError('无法打开授权页面');
        }
        if (mounted) MessageUtils.showInfo(context, '请在浏览器完成授权');
        final parsed = await callbackSession.waitForCallback(
          expectedState: start.state,
        );
        if (!mounted || attempt != _oauthAttempt) return;
        final result = await WatchTogetherService.finishOAuth2Login(
          provider: provider.name,
          code: parsed.code,
          state: parsed.state,
        );
        if (mounted) {
          if (result.registrationReviewRequired) {
            final suffix = result.registrationReviewId.isEmpty
                ? ''
                : '（${result.registrationReviewId}）';
            MessageUtils.showInfo(context, '注册申请已提交，等待管理员审核$suffix');
          } else {
            setState(() {
              _oauthProvider = null;
            });
            Navigator.pop(context, true);
          }
        }
      } finally {
        await callbackSession.close();
      }
    });
  }

  Future<void> _showUserAgreement() async {
    // Strip indentation from the source string
    final content =
        _userAgreementContent.split('\n').map((line) => line.trim()).join('\n');

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => UserAgreementDialog(
        agreementContent: content,
      ),
    );

    if (result != true) {
      if (mounted) {
        Navigator.pop(context); // Close panel
      }
    }
  }

  Future<void> _launchPrivacyPolicy() async {
    // 仅在鸿蒙系统处理隐私协议链接跳转
    if (!_isHarmony) return;

    const url =
        'https://agreement-drcn.hispace.dbankcloud.cn/index.html?lang=zh&agreementId=1907312466082150720';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        webViewConfiguration: const WebViewConfiguration(
          headers: {'harmony_browser_page': 'pages/BrowserPage'},
        ),
      );
    } else {
      if (mounted) {
        MessageUtils.showError(context, '无法打开隐私协议链接');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 华为设计规范要求半模态面板，我们这里构建面板的内容
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          // 包裹整个 Column，解决小屏溢出
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部横条（可选，通常用于指示可拖动，或者直接放取消按钮）
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 48), // 占位保持平衡
                ],
              ),

              const SizedBox(height: 16),

              // 应用图标
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark ? Colors.transparent : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/icon/robot_3.png',
                    width: 72,
                    height: 72,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 应用名称
              Text(
                '看搭子',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // 应用描述
              Text(
                '一起看视频吧',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade400 : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              if (_isHarmony) ...[
                if (_maskedPhone != null) ...[
                  Text(
                    _maskedPhone!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '华为帐号绑定的手机号',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ],
              _buildOAuth2Buttons(),
              if (_oauth2Providers.isNotEmpty) const SizedBox(height: 20),
              _buildAuthPolicyHints(isDark),
              if (_publicSettings?.authPolicyHints.isNotEmpty == true)
                const SizedBox(height: 20),
              _buildEmailForm(isDark),
              if (_mfaChallenge != null) ...[
                const SizedBox(height: 20),
                _buildMfaEmailForm(isDark),
              ],
              const SizedBox(height: 20),
              _buildGuestForm(isDark),

              const SizedBox(height: 24),

              // 底部协议文本
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _agreedToTerms = !_agreedToTerms;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: AnimatedBuilder(
                                animation: _scaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Icon(
                                      _agreedToTerms
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      size: 18,
                                      color: _agreedToTerms
                                          ? const Color(0xFFCF0A2C)
                                          : Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Text(
                              '我已阅读并同意',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _showUserAgreement,
                        child: Text(
                          '《用户协议》',
                          style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF7C7EFF)
                                  : const Color(0xFF5D5FEF)),
                        ),
                      ),
                      const Text(
                        '和',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: _launchPrivacyPolicy,
                        child: Text(
                          '《隐私政策》',
                          style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF7C7EFF)
                                  : const Color(0xFF5D5FEF)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 底部安全区域适配
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(bool isDark) {
    final emailEnabled = _publicSettings?.enableEmailSignup == true;
    final passwordSignupEnabled = _publicSettings?.enablePasswordSignup == true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildTextField(
            controller: _emailController,
            hintText: '邮箱或用户名',
            icon: Icons.mail_outline,
            isDark: isDark,
            enabled: !_isLoading,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            hintText: '密码',
            icon: Icons.lock_outline_rounded,
            isDark: isDark,
            enabled: !_isLoading,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _submitOpaqueLogin,
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('密码登录'),
                ),
              ),
              if (passwordSignupEnabled) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _submitOpaqueRegistration,
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: const Text('注册账号'),
                  ),
                ),
              ],
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _isLoading ? null : _resetOpaquePassword,
              icon: const Icon(Icons.lock_reset_rounded, size: 18),
              label: const Text('忘记密码'),
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailTokenController,
            hintText: _emailTokenRequested ? '邮箱验证码' : '先获取验证码',
            icon: Icons.pin_outlined,
            isDark: isDark,
            enabled: emailEnabled && !_isLoading,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      emailEnabled && !_isLoading ? _requestEmailToken : null,
                  child: const Text('获取验证码'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      emailEnabled && !_isLoading ? _submitEmailLogin : null,
                  child: const Text('邮箱登录'),
                ),
              ),
            ],
          ),
          if (_passkeyAvailable) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _isLoading ? null : _submitPasskeyLogin,
                    icon: const Icon(Icons.fingerprint_rounded),
                    label: const Text('Passkey 登录'),
                  ),
                ),
                if (_publicSettings?.enableWebauthnSignup == true) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _submitPasskeyRegistration,
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: const Text('Passkey 注册'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMfaEmailForm(bool isDark) {
    final challenge = _mfaChallenge;
    final emailSupported = challenge?.supportsEmail == true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              challenge?.maskedEmail.isNotEmpty == true
                  ? '二次验证 ${challenge!.maskedEmail}'
                  : '二次验证',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _mfaTokenController,
            hintText: _mfaEmailRequested ? '二次验证码' : '先获取二次验证码',
            icon: Icons.verified_user_outlined,
            isDark: isDark,
            enabled: emailSupported && !_isLoading,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: emailSupported && !_isLoading
                      ? _requestMfaEmailToken
                      : null,
                  child: const Text('获取二次验证码'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: emailSupported && !_isLoading
                      ? _submitMfaEmailToken
                      : null,
                  child: const Text('完成验证'),
                ),
              ),
            ],
          ),
          if (challenge?.supportsPasskey == true && _passkeyAvailable) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton.tonalIcon(
                onPressed: _isLoading ? null : _submitMfaPasskey,
                icon: const Icon(Icons.fingerprint_rounded),
                label: const Text('使用 Passkey 验证'),
              ),
            ),
          ] else if (challenge?.supportsPasskey == true) ...[
            const SizedBox(height: 10),
            Text(
              '当前设备不可使用 Passkey，可改用邮箱验证码。',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGuestForm(bool isDark) {
    final guestEnabled = _publicSettings?.enableGuest == true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildTextField(
            controller: _guestRoomController,
            hintText: guestEnabled ? '房间 ID，例如 room_xxx' : '访客访问未启用',
            icon: Icons.meeting_room_outlined,
            isDark: isDark,
            enabled: guestEnabled && !_isLoading,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: guestEnabled && !_isLoading ? _submitGuest : null,
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('访客进入房间'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOAuth2Buttons() {
    if (_oauth2Providers.isEmpty) return const SizedBox.shrink();
    final oauth2Available = OAuth2DeepLinkService.canCreateSession;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (final provider in _oauth2Providers) ...[
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isLoading || !oauth2Available
                    ? null
                    : () => _startOAuth2(provider),
                icon: const Icon(Icons.open_in_new),
                label: Text(
                  _oauth2ProviderLabel(provider),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (!oauth2Available) ...[
            Text(
              '当前构建未配置 OAuth2 App Link，无法在本设备完成授权回跳。',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
          if (_oauthProvider != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    '等待 $_oauthProvider 授权回跳',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  String _oauth2ProviderLabel(OAuth2ProviderOption provider) {
    final suffix = provider.signupNeedReview
        ? ' · 注册需审核'
        : provider.signupEnabled
            ? ''
            : ' · 仅登录';
    return '${provider.type} (${provider.name})$suffix';
  }

  Widget _buildAuthPolicyHints(bool isDark) {
    final hints = _publicSettings?.authPolicyHints ?? const <String>[];
    if (hints.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final hint in hints) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: isDark ? Colors.blue.shade200 : Colors.blueGrey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hint,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.blueGrey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              if (hint != hints.last) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isDark,
    bool enabled = true,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _LoginPasswordResetDialog extends StatefulWidget {
  final String initialEmail;

  const _LoginPasswordResetDialog({required this.initialEmail});

  @override
  State<_LoginPasswordResetDialog> createState() =>
      _LoginPasswordResetDialogState();
}

class _LoginPasswordResetDialogState extends State<_LoginPasswordResetDialog> {
  late final TextEditingController _emailController;
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _requesting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _requestResetEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱');
      return;
    }
    setState(() => _requesting = true);
    try {
      final message = await WatchTogetherService.requestPasswordReset(email);
      if (!mounted) return;
      MessageUtils.showSuccess(
        context,
        message.isEmpty ? '密码重置邮件已发送' : message,
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '发送重置邮件失败: $e');
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  void _submit() {
    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (email.isEmpty || token.isEmpty || newPassword.isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱、验证码和新密码');
      return;
    }
    if (newPassword != confirmPassword) {
      MessageUtils.showWarning(context, '两次输入的新密码不一致');
      return;
    }
    Navigator.pop(
      context,
      (email: email, token: token, newPassword: newPassword),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('重置密码'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: '邮箱',
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton(
                    onPressed: _requesting ? null : _requestResetEmail,
                    child: _requesting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('发送'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: '重置验证码',
                prefixIcon: Icon(Icons.mark_email_read_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '新密码',
                prefixIcon: Icon(Icons.lock_reset_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '确认新密码',
                prefixIcon: Icon(Icons.check_circle_outline_rounded),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('重置'),
        ),
      ],
    );
  }
}
