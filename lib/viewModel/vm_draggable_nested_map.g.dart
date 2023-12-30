// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_draggable_nested_map.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getChildrenHash() => r'd44260e93af8c1447ccbc65e34f10d6e6525ecf4';

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

/// See also [getChildren].
@ProviderFor(getChildren)
const getChildrenProvider = GetChildrenFamily();

/// See also [getChildren].
class GetChildrenFamily extends Family<List<Choice>> {
  /// See also [getChildren].
  const GetChildrenFamily();

  /// See also [getChildren].
  GetChildrenProvider call({
    required Pos pos,
  }) {
    return GetChildrenProvider(
      pos: pos,
    );
  }

  @override
  GetChildrenProvider getProviderOverride(
    covariant GetChildrenProvider provider,
  ) {
    return call(
      pos: provider.pos,
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
  String? get name => r'getChildrenProvider';
}

/// See also [getChildren].
class GetChildrenProvider extends AutoDisposeProvider<List<Choice>> {
  /// See also [getChildren].
  GetChildrenProvider({
    required Pos pos,
  }) : this._internal(
          (ref) => getChildren(
            ref as GetChildrenRef,
            pos: pos,
          ),
          from: getChildrenProvider,
          name: r'getChildrenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getChildrenHash,
          dependencies: GetChildrenFamily._dependencies,
          allTransitiveDependencies:
              GetChildrenFamily._allTransitiveDependencies,
          pos: pos,
        );

  GetChildrenProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pos,
  }) : super.internal();

  final Pos pos;

  @override
  Override overrideWith(
    List<Choice> Function(GetChildrenRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetChildrenProvider._internal(
        (ref) => create(ref as GetChildrenRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pos: pos,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Choice>> createElement() {
    return _GetChildrenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetChildrenProvider && other.pos == pos;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pos.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetChildrenRef on AutoDisposeProviderRef<List<Choice>> {
  /// The parameter `pos` of this provider.
  Pos get pos;
}

class _GetChildrenProviderElement
    extends AutoDisposeProviderElement<List<Choice>> with GetChildrenRef {
  _GetChildrenProviderElement(super.provider);

  @override
  Pos get pos => (origin as GetChildrenProvider).pos;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
