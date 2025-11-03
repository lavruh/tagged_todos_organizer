// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags_aliases_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TagsAliases)
const tagsAliasesProvider = TagsAliasesProvider._();

final class TagsAliasesProvider
    extends $NotifierProvider<TagsAliases, Map<String, TagsAlias>> {
  const TagsAliasesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tagsAliasesProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tagsAliasesHash();

  @$internal
  @override
  TagsAliases create() => TagsAliases();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, TagsAlias> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, TagsAlias>>(value),
    );
  }
}

String _$tagsAliasesHash() => r'8c226b47601df8225b7ed475545a7f8bb90cc1da';

abstract class _$TagsAliases extends $Notifier<Map<String, TagsAlias>> {
  Map<String, TagsAlias> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Map<String, TagsAlias>, Map<String, TagsAlias>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<String, TagsAlias>, Map<String, TagsAlias>>,
        Map<String, TagsAlias>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
