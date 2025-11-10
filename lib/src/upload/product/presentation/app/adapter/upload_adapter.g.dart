// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_adapter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$uploadAdapterHash() => r'e7bc6545b07c9f21f2dda9639db604bb22df0a04';

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

abstract class _$UploadAdapter
    extends BuildlessAutoDisposeNotifier<UploadState> {
  late final GlobalKey<State<StatefulWidget>>? familyKey;

  UploadState build([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]);
}

/// See also [UploadAdapter].
@ProviderFor(UploadAdapter)
const uploadAdapterProvider = UploadAdapterFamily();

/// See also [UploadAdapter].
class UploadAdapterFamily extends Family<UploadState> {
  /// See also [UploadAdapter].
  const UploadAdapterFamily();

  /// See also [UploadAdapter].
  UploadAdapterProvider call([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) {
    return UploadAdapterProvider(
      familyKey,
    );
  }

  @override
  UploadAdapterProvider getProviderOverride(
    covariant UploadAdapterProvider provider,
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
  String? get name => r'uploadAdapterProvider';
}

/// See also [UploadAdapter].
class UploadAdapterProvider
    extends AutoDisposeNotifierProviderImpl<UploadAdapter, UploadState> {
  /// See also [UploadAdapter].
  UploadAdapterProvider([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) : this._internal(
          () => UploadAdapter()..familyKey = familyKey,
          from: uploadAdapterProvider,
          name: r'uploadAdapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$uploadAdapterHash,
          dependencies: UploadAdapterFamily._dependencies,
          allTransitiveDependencies:
              UploadAdapterFamily._allTransitiveDependencies,
          familyKey: familyKey,
        );

  UploadAdapterProvider._internal(
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
  UploadState runNotifierBuild(
    covariant UploadAdapter notifier,
  ) {
    return notifier.build(
      familyKey,
    );
  }

  @override
  Override overrideWith(UploadAdapter Function() create) {
    return ProviderOverride(
      origin: this,
      override: UploadAdapterProvider._internal(
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
  AutoDisposeNotifierProviderElement<UploadAdapter, UploadState>
      createElement() {
    return _UploadAdapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UploadAdapterProvider && other.familyKey == familyKey;
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
mixin UploadAdapterRef on AutoDisposeNotifierProviderRef<UploadState> {
  /// The parameter `familyKey` of this provider.
  GlobalKey<State<StatefulWidget>>? get familyKey;
}

class _UploadAdapterProviderElement
    extends AutoDisposeNotifierProviderElement<UploadAdapter, UploadState>
    with UploadAdapterRef {
  _UploadAdapterProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>>? get familyKey =>
      (origin as UploadAdapterProvider).familyKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
