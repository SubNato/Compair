// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_upload_adapter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryUploadAdapterHash() =>
    r'ba545d9d13725488167afb1a7010521ab60b5107';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CategoryUploadAdapter
    extends BuildlessAutoDisposeNotifier<CategoryUploadState> {
  late final GlobalKey<State<StatefulWidget>>? familyKey;

  CategoryUploadState build([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]);
}

/// See also [CategoryUploadAdapter].
@ProviderFor(CategoryUploadAdapter)
const categoryUploadAdapterProvider = CategoryUploadAdapterFamily();

/// See also [CategoryUploadAdapter].
class CategoryUploadAdapterFamily extends Family<CategoryUploadState> {
  /// See also [CategoryUploadAdapter].
  const CategoryUploadAdapterFamily();

  /// See also [CategoryUploadAdapter].
  CategoryUploadAdapterProvider call([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) {
    return CategoryUploadAdapterProvider(
      familyKey,
    );
  }

  @override
  CategoryUploadAdapterProvider getProviderOverride(
    covariant CategoryUploadAdapterProvider provider,
  ) {
    return call(
      provider.familyKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryUploadAdapterProvider';
}

/// See also [CategoryUploadAdapter].
class CategoryUploadAdapterProvider extends AutoDisposeNotifierProviderImpl<
    CategoryUploadAdapter, CategoryUploadState> {
  /// See also [CategoryUploadAdapter].
  CategoryUploadAdapterProvider([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) : this._internal(
          () => CategoryUploadAdapter()..familyKey = familyKey,
          from: categoryUploadAdapterProvider,
          name: r'categoryUploadAdapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryUploadAdapterHash,
          dependencies: CategoryUploadAdapterFamily._dependencies,
          allTransitiveDependencies:
              CategoryUploadAdapterFamily._allTransitiveDependencies,
          familyKey: familyKey,
        );

  CategoryUploadAdapterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.familyKey,
  }) : super.internal();

  final GlobalKey<State<StatefulWidget>>? familyKey;

  @override
  CategoryUploadState runNotifierBuild(
    covariant CategoryUploadAdapter notifier,
  ) {
    return notifier.build(
      familyKey,
    );
  }

  @override
  Override overrideWith(CategoryUploadAdapter Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoryUploadAdapterProvider._internal(
        () => create()..familyKey = familyKey,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        familyKey: familyKey,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CategoryUploadAdapter, CategoryUploadState>
      createElement() {
    return _CategoryUploadAdapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryUploadAdapterProvider &&
        other.familyKey == familyKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, familyKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryUploadAdapterRef
    on AutoDisposeNotifierProviderRef<CategoryUploadState> {
  /// The parameter `familyKey` of this provider.
  GlobalKey<State<StatefulWidget>>? get familyKey;
}

class _CategoryUploadAdapterProviderElement
    extends AutoDisposeNotifierProviderElement<CategoryUploadAdapter,
        CategoryUploadState> with CategoryUploadAdapterRef {
  _CategoryUploadAdapterProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>>? get familyKey =>
      (origin as CategoryUploadAdapterProvider).familyKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
