class ProviderDistributionPolicy {
  const ProviderDistributionPolicy({required this.includesThirdPartyProviders});

  static const current = ProviderDistributionPolicy(
    includesThirdPartyProviders: bool.fromEnvironment(
      'SYNCTV_INCLUDE_THIRD_PARTY_PROVIDERS',
      defaultValue: true,
    ),
  );

  static const thirdPartyProviderTypes = <String>{
    'acfun',
    'bilibili',
    'cctv',
    'douyin',
    'douyu',
    'huya',
    'tiktok',
    'twitch',
    'youtube',
  };

  final bool includesThirdPartyProviders;

  // OAuth2 is an account authentication method. The store media restriction
  // applies to content providers and leaves configured account login options.
  bool get allowsOAuth2 => true;

  bool allowsProvider(String providerType) {
    return includesThirdPartyProviders ||
        !thirdPartyProviderTypes.contains(providerType.toLowerCase());
  }
}
