// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parish_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$parishNotifierHash() => r'67d678cdfea29dbbb10ddc505b84a23eea8aaa32';

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

abstract class _$ParishNotifier
    extends BuildlessAutoDisposeNotifier<JamaicanParishes?> {
  late final GlobalKey<State<StatefulWidget>>? familyKey;

  JamaicanParishes? build([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]);
}

/// See also [ParishNotifier].
@ProviderFor(ParishNotifier)
const parishNotifierProvider = ParishNotifierFamily();

/// See also [ParishNotifier].
class ParishNotifierFamily extends Family<JamaicanParishes?> {
  /// See also [ParishNotifier].
  const ParishNotifierFamily();

  /// See also [ParishNotifier].
  ParishNotifierProvider call([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) {
    return ParishNotifierProvider(
      familyKey,
    );
  }

  @override
  ParishNotifierProvider getProviderOverride(
    covariant ParishNotifierProvider provider,
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
  String? get name => r'parishNotifierProvider';
}

/// See also [ParishNotifier].
class ParishNotifierProvider
    extends AutoDisposeNotifierProviderImpl<ParishNotifier, JamaicanParishes?> {
  /// See also [ParishNotifier].
  ParishNotifierProvider([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) : this._internal(
          () => ParishNotifier()..familyKey = familyKey,
          from: parishNotifierProvider,
          name: r'parishNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$parishNotifierHash,
          dependencies: ParishNotifierFamily._dependencies,
          allTransitiveDependencies:
              ParishNotifierFamily._allTransitiveDependencies,
          familyKey: familyKey,
        );

  ParishNotifierProvider._internal(
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
  JamaicanParishes? runNotifierBuild(
    covariant ParishNotifier notifier,
  ) {
    return notifier.build(
      familyKey,
    );
  }

  @override
  Override overrideWith(ParishNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ParishNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<ParishNotifier, JamaicanParishes?>
      createElement() {
    return _ParishNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ParishNotifierProvider && other.familyKey == familyKey;
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
mixin ParishNotifierRef on AutoDisposeNotifierProviderRef<JamaicanParishes?> {
  /// The parameter `familyKey` of this provider.
  GlobalKey<State<StatefulWidget>>? get familyKey;
}

class _ParishNotifierProviderElement extends AutoDisposeNotifierProviderElement<
    ParishNotifier, JamaicanParishes?> with ParishNotifierRef {
  _ParishNotifierProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>>? get familyKey =>
      (origin as ParishNotifierProvider).familyKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
