part of '../admin_settings_page.dart';

class AdminReviewTab extends StatefulWidget {
  const AdminReviewTab({super.key});

  @override
  State<AdminReviewTab> createState() => _AdminReviewTabState();
}

class _AdminReviewTabState extends State<AdminReviewTab> {
  AdminReviewKind _kind = AdminReviewKind.userRegistration;
  common_enum.ReviewStatus _status =
      common_enum.ReviewStatus.REVIEW_STATUS_PENDING;
  String _search = '';
  String _requestedBy = '';
  String _roomId = '';
  String _userId = '';
  int _page = 1;
  int _pageSize = 50;
  int _total = 0;
  bool _isLoading = true;
  int _loadGeneration = 0;
  List<AdminReviewItem> _reviews = const [];
  final _searchController = TextEditingController();
  final Set<(AdminReviewKind, String)> _deciding = {};

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
    final generation = ++_loadGeneration;
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
      if (!mounted || generation != _loadGeneration) return;
      final lastPage = math.max(1, (data.total + _pageSize - 1) ~/ _pageSize);
      if (_page > lastPage) {
        setState(() => _page = lastPage);
        await _loadReviews();
        return;
      }
      setState(() {
        _reviews = data.reviews;
        _total = data.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || generation != _loadGeneration) return;
      setState(() => _isLoading = false);
      AppNotifications.showError(context, context.l10n.loadReviewsFailed('$e'));
    }
  }

  Future<void> _approve(AdminReviewItem review) async {
    final key = (review.kind, review.id);
    if (!mounted || _deciding.contains(key)) return;
    setState(() => _deciding.add(key));
    try {
      await adminGateway.adminApproveReview(review.kind, review.id);
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.reviewApproved);
      await _loadReviews(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.operationFailed('$e'));
    } finally {
      if (mounted) setState(() => _deciding.remove(key));
    }
  }

  Future<void> _reject(AdminReviewItem review) async {
    final key = (review.kind, review.id);
    if (!mounted || _deciding.contains(key)) return;
    setState(() => _deciding.add(key));
    final l10n = context.l10n;
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    void submit() {
      if (formKey.currentState?.validate() == true) {
        Navigator.pop(context, true);
      }
    }

    var disposeScheduled = false;
    try {
      final confirmed = await AppDialogs.showStyledDialog<bool>(
        context: context,
        title: l10n.rejectReview,
        icon: const Icon(Icons.cancel_outlined, color: Colors.red),
        content: Builder(
          builder: (dialogContext) {
            if (!disposeScheduled) {
              disposeScheduled = true;
              _disposeControllersAfterRouteClose(dialogContext, [controller]);
            }
            return Form(
              key: formKey,
              child: AppTextField(
                label: l10n.reason,
                controller: controller,
                hintText: l10n.rejectionReasonHint,
                prefixIcon: Icons.edit_note_rounded,
                validator: (value) => value?.trim().isNotEmpty == true
                    ? null
                    : l10n.fieldRequired(l10n.reason),
                onSubmitted: (_) => submit(),
              ),
            );
          },
        ),
        actions: [
          AppDialogs.createCancelButton(context),
          const SizedBox(width: 8),
          AppDialogs.createConfirmButton(context, submit, text: l10n.reject),
        ],
      );
      if (confirmed != true || !mounted) return;
      await adminGateway.adminRejectReview(
        review.kind,
        review.id,
        reason: controller.text.trim(),
      );
      if (!mounted) return;
      AppNotifications.showSuccess(context, l10n.reviewRejected);
      await _loadReviews(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, l10n.operationFailed('$e'));
    } finally {
      if (!disposeScheduled) controller.dispose();
      if (mounted) setState(() => _deciding.remove(key));
    }
  }

  void _applySearch(String value) {
    final normalized = value.trim();
    setState(() {
      _search = normalized;
      _requestedBy =
          _kind == AdminReviewKind.roomCreation && normalized.startsWith('usr_')
          ? normalized
          : '';
      _roomId =
          _kind == AdminReviewKind.roomJoin && normalized.startsWith('room_')
          ? normalized
          : '';
      _userId =
          _kind == AdminReviewKind.roomJoin && normalized.startsWith('usr_')
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
    return _AdminPagedList(
      header: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppSegmentedControl<AdminReviewKind>(
                segments: [
                  ButtonSegment(
                    value: AdminReviewKind.userRegistration,
                    label: Text(context.l10n.registration),
                  ),
                  ButtonSegment(
                    value: AdminReviewKind.roomCreation,
                    label: Text(context.l10n.roomCreation),
                  ),
                  ButtonSegment(
                    value: AdminReviewKind.roomJoin,
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
              AppSelect<common_enum.ReviewStatus>(
                value: _status,
                options: {
                  context.l10n.pendingReview:
                      common_enum.ReviewStatus.REVIEW_STATUS_PENDING,
                  context.l10n.approved:
                      common_enum.ReviewStatus.REVIEW_STATUS_APPROVED,
                  context.l10n.rejected:
                      common_enum.ReviewStatus.REVIEW_STATUS_REJECTED,
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
      ],
      loading: _isLoading,
      itemCount: _reviews.length,
      emptyMessage: context.l10n.noReviewRecords,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        final pending =
            review.status == common_enum.ReviewStatus.REVIEW_STATUS_PENDING;
        return _AdminPanelCard(
          isDark: isDark,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            onPressed:
                                _deciding.contains((review.kind, review.id))
                                ? null
                                : () => _approve(review),
                          ),
                          AppIconButton(
                            tooltip: context.l10n.reject,
                            icon: Icons.cancel_outlined,
                            style: AppIconButtonStyle.destructive,
                            onPressed:
                                _deciding.contains((review.kind, review.id))
                                ? null
                                : () => _reject(review),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(_reviewStatusText(context, review.status)),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewSummary(AdminReviewItem review, ThemeData theme) {
    final meta = [
      review.id,
      _formatTimestamp(review.requestedAt),
      if (review.reviewedBy case final reviewedBy?)
        context.l10n.reviewedBy(reviewedBy),
      if (review.reviewedAt case final reviewedAt?)
        context.l10n.reviewedAt(_formatTimestamp(reviewedAt)),
    ];
    final details = switch (review) {
      AdminRoomJoinReview() => [
        if (review.subtitle.isNotEmpty) review.subtitle,
        if (review.roomId.isNotEmpty)
          '${context.l10n.roomId}: ${review.roomId}',
        if (review.userId.isNotEmpty)
          '${context.l10n.userId}: ${review.userId}',
        if (review.roomId.isEmpty && review.userId.isEmpty)
          ...review.details.isEmpty ? [review.detail] : review.details,
        '${context.l10n.role}: ${_roomMemberRoleText(context, review.requestedRole)}',
      ],
      _ =>
        review.details.isEmpty
            ? [review.subtitle, review.detail]
            : review.details,
    };
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
        if (review.rejectionReason case final rejectionReason?) ...[
          const SizedBox(height: 8),
          Text(
            rejectionReason,
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
