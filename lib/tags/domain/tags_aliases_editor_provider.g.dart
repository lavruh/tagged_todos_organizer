// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags_aliases_editor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TagsAliasesEditor)
const tagsAliasesEditorProvider = TagsAliasesEditorProvider._();

final class TagsAliasesEditorProvider
    extends $NotifierProvider<TagsAliasesEditor, TagsAlias> {
  const TagsAliasesEditorProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tagsAliasesEditorProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tagsAliasesEditorHash();

  @$internal
  @override
  TagsAliasesEditor create() => TagsAliasesEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TagsAlias value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TagsAlias>(value),
    );
  }
}

String _$tagsAliasesEditorHash() => r'c583487a7acd0b3b4675079673741e2fd4f56ce0';

abstract class _$TagsAliasesEditor extends $Notifier<TagsAlias> {
  TagsAlias build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TagsAlias, TagsAlias>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TagsAlias, TagsAlias>, TagsAlias, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
