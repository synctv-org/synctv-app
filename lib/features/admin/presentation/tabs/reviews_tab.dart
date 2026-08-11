part of '../admin_settings_page.dart';

class AdminReviewTab extends StatefulWidget {
  const AdminReviewTab({super.key});

  @override
  State<AdminReviewTab> createState() => _AdminReviewTabState();
}

class _AdminReviewTabState extends State<AdminReviewTab> {
  String _kind = 'user';
  int _status = common_enum.ReviewStatus.REVIEW_STATUS_PENDING.value;
  String _search = '';
  String _requestedBy = '';
  String _roomId = '';
  String _userId = '';
  int _page = 1;
  int _pageSize = 50;
  int _total = 0;
  bool _isLoading = true;
  List<AdminReviewItem> _reviews = const [];
  final _searchController = TextEditingController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadReviews();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await adminGateway.adminListReviewsPage(
        kind: _kind,
        page: _page,
        pageSize: _pageSize,
        status: _status,
        search: _search,
        requestedBy: _requestedBy,
        roomId: _roomId,
        userId: _userId,
      );
      if (!mounted) return;
      setState(() {
        _reviews = data.reviews;
        _total = data.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AppNotifications.showError(context, context.l10n.loadReviewsFailed('$e'));
    }
  }

  Future<void> _approve(AdminReviewItem review) async {
    try {
      await adminGateway.adminApproveReview(_kind, review.id);
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.reviewApproved);
      _loadReviews(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.operationFailed('$e'));
    }
  }

  Future<void> _reject(AdminReviewItem review) async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: l10n.rejectReview,
      icon: const Icon(Icons.cancel_outlined, color: Colors.red),
      content: AppDialogs.createFormField(
        context: context,
        label: l10n.reason,
        controller: controller,
        hintText: l10n.rejectionReasonHint,
        prefixIcon: Icons.edit_note_rounded,
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.reject,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await adminGateway.adminRejectReview(
        _kind,
        review.id,
        reason: controller.text.trim(),
      );
      if (!mounted) return;
      AppNotifications.showSuccess(context, l10n.reviewRejected);
      _loadReviews(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, l10n.operationFailed('$e'));
    }
  }

  void _applySearch(String value) {
    final normalized = value.trim();
    setState(() {
      _search = normalized;
      _requestedBy = _kind == 'room' && normalized.startsWith('usr_')
          ? normalized
          : '';
      _roomId = _kind == 'join' && normalized.startsWith('room_')
          ? normalized
          : '';
      _userId = _kind == 'join' && normalized.startsWith('usr_')
          ? normalized
          : '';
      _page = 1;
    });
    _loadReviews();
  }

  int get _pageCount {
    if (_total <= 0) return 1;
    return ((_total + _pageSize - 1) ~/ _pageSize).clamp(1, 1 << 31);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppSegmentedControl<String>(
                segments: [
                  ButtonSegment(
                    value: 'user',
                    label: Text(context.l10n.registration),
                  ),
                  ButtonSegment(
                    value: 'room',
                    label: Text(context.l10n.roomCreation),
                  ),
                  ButtonSegment(
                    value: 'join',
                    label: Text(context.l10n.joinRequest),
                  ),
                ],
                value: _kind,
                onChanged: (value) {
                  setState(() {
                    _kind = value;
                    _page = 1;
                    _requestedBy = '';
                    _roomId = '';
                    _userId = '';
                  });
                  _loadReviews();
                },
              ),
              AppSelect<int>(
                value: _status,
                options: {
                  context.l10n.pendingReview:
                      common_enum.ReviewStatus.REVIEW_STATUS_PENDING.value,
                  context.l10n.approved:
                      common_enum.ReviewStatus.REVIEW_STATUS_APPROVED.value,
                  context.l10n.rejected:
                      common_enum.ReviewStatus.REVIEW_STATUS_REJECTED.value,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _status = value;
                    _page = 1;
                  });
                  _loadReviews();
                },
              ),
              AppSelect<int>(
                value: _pageSize,
                options: {
                  context.l10n.itemsPerPage(20): 20,
                  context.l10n.itemsPerPage(50): 50,
                  context.l10n.itemsPerPage(100): 100,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _pageSize = value;
                    _page = 1;
                  });
                  _loadReviews();
                },
              ),
              SizedBox(
                width: 260,
                child: AppSearchField(
                  controller: _searchController,
                  hintText: context.l10n.searchReviewHint,
                  onChanged: (value) {
                    if (value.isEmpty && _search.isNotEmpty) _applySearch('');
                  },
                  onSubmitted: _applySearch,
                ),
              ),
              AppIconButton(
                tooltip: context.l10n.refresh,
                icon: Icons.refresh_rounded,
                onPressed: () => _loadReviews(silent: true),
              ),
            ],
          ),
        ),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadReviews();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadReviews();
                },
        ),
        Expanded(
          child: _isLoading
              ? const AppLoadingIndicator()
              : _reviews.isEmpty
              ? Center(
                  child: Text(
                    context.l10n.noReviewRecords,
                    style: TextStyle(color: theme.hintColor),
                  ),
                )
              : AppListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    final pending =
                        review.status ==
                        common_enum.ReviewStatus.REVIEW_STATUS_PENDING.value;
                    return _AdminPanelCard(
                      isDark: isDark,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildReviewSummary(review, theme)),
                            const SizedBox(width: 8),
                            pending
                                ? Wrap(
                                    spacing: 4,
                                    children: [
                                      AppIconButton(
                                        tooltip: context.l10n.approve,
                                        icon: Icons.check_circle_outline,
                                        onPressed: () => _approve(review),
                                      ),
                                      AppIconButton(
                                        tooltip: context.l10n.reject,
                                        icon: Icons.cancel_outlined,
                                        style: AppIconButtonStyle.destructive,
                                        onPressed: () => _reject(review),
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      _reviewStatusText(context, review.status),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildReviewSummary(AdminReviewItem review, ThemeData theme) {
    final meta = [
      review.id,
      _formatTimestamp(review.requestedAt),
      if (review.reviewedBy.isNotEmpty)
        context.l10n.reviewedBy(review.reviewedBy),
      if (review.reviewedAt > 0)
        context.l10n.reviewedAt(_formatTimestamp(review.reviewedAt)),
    ];
    final details = review.details.isEmpty
        ? [review.subtitle, review.detail]
        : review.details;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          review.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          meta.where((value) => value.isNotEmpty).join(' · '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: theme.hintColor),
        ),
        if (details.any((value) => value.isNotEmpty)) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final detail in details.where((value) => value.isNotEmpty))
                _ReviewInfoChip(label: detail),
            ],
          ),
        ],
        if (review.rejectionReason.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            review.rejectionReason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }
}

class _ReviewInfoChip extends StatelessWidget {
  const _ReviewInfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBadge(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.7,
      ),
      color: theme.colorScheme.onSurface,
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.08)),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

class _ProviderTypeSelector extends StatelessWidget {
  const _ProviderTypeSelector({
    required this.selectedProviders,
    required this.options,
    required this.onChanged,
    this.hasError = false,
  });

  final Set<String> selectedProviders;
  final List<String> options;
  final void Function(String provider, bool selected) onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: hasError
            ? theme.colorScheme.error
            : theme.colorScheme.outlineVariant.withValues(alpha: 0.72),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.category_outlined,
                size: 18,
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.providerTypes,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: hasError ? theme.colorScheme.error : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final provider in options)
                Builder(
                  builder: (context) {
                    final brand = mediaProviderBrand(provider);
                    return AppChip(
                      label: Text(brand.label),
                      avatar: Icon(brand.icon, size: 16, color: brand.color),
                      selected: selectedProviders.contains(provider),
                      onSelected: (selected) => onChanged(provider, selected),
                      showCheckmark: true,
                    );
                  },
                ),
              if (options.isEmpty)
                Text(
                  context.l10n.noProviderTypes,
                  style: TextStyle(color: theme.hintColor),
                ),
            ],
          ),
          if (hasError) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.selectAtLeastOneProviderType,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
