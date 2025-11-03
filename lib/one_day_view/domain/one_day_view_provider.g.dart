// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_day_view_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OneDayView)
const oneDayViewProvider = OneDayViewProvider._();

final class OneDayViewProvider
    extends $NotifierProvider<OneDayView, List<Widget>> {
  const OneDayViewProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'oneDayViewProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$oneDayViewHash();

  @$internal
  @override
  OneDayView create() => OneDayView();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Widget> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Widget>>(value),
    );
  }
}

String _$oneDayViewHash() => r'36e9fc91395e2bc31f471fed0ee99440793af563';

abstract class _$OneDayView extends $Notifier<List<Widget>> {
  List<Widget> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Widget>, List<Widget>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<Widget>, List<Widget>>,
        List<Widget>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
