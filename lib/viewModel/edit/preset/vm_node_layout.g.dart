// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_node_layout.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nodeLayoutElementControllerHash() =>
    r'1a632683bfb87abd084efe78d3a4aba6dec98780';

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

/// See also [nodeLayoutElementController].
@ProviderFor(nodeLayoutElementController)
const nodeLayoutElementControllerProvider = NodeLayoutElementControllerFamily();

/// See also [nodeLayoutElementController].
class NodeLayoutElementControllerFamily extends Family<TextEditingController> {
  /// See also [nodeLayoutElementController].
  const NodeLayoutElementControllerFamily();

  /// See also [nodeLayoutElementController].
  NodeLayoutElementControllerProvider call({
    required String position,
    required String type,
  }) {
    return NodeLayoutElementControllerProvider(
      position: position,
      type: type,
    );
  }

  @override
  NodeLayoutElementControllerProvider getProviderOverride(
    covariant NodeLayoutElementControllerProvider provider,
  ) {
    return call(
      position: provider.position,
      type: provider.type,
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
  String? get name => r'nodeLayoutElementControllerProvider';
}

/// See also [nodeLayoutElementController].
class NodeLayoutElementControllerProvider
    extends AutoDisposeProvider<TextEditingController> {
  /// See also [nodeLayoutElementController].
  NodeLayoutElementControllerProvider({
    required String position,
    required String type,
  }) : this._internal(
          (ref) => nodeLayoutElementController(
            ref as NodeLayoutElementControllerRef,
            position: position,
            type: type,
          ),
          from: nodeLayoutElementControllerProvider,
          name: r'nodeLayoutElementControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nodeLayoutElementControllerHash,
          dependencies: NodeLayoutElementControllerFamily._dependencies,
          allTransitiveDependencies:
              NodeLayoutElementControllerFamily._allTransitiveDependencies,
          position: position,
          type: type,
        );

  NodeLayoutElementControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.position,
    required this.type,
  }) : super.internal();

  final String position;
  final String type;

  @override
  Override overrideWith(
    TextEditingController Function(NodeLayoutElementControllerRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NodeLayoutElementControllerProvider._internal(
        (ref) => create(ref as NodeLayoutElementControllerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        position: position,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<TextEditingController> createElement() {
    return _NodeLayoutElementControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NodeLayoutElementControllerProvider &&
        other.position == position &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NodeLayoutElementControllerRef
    on AutoDisposeProviderRef<TextEditingController> {
  /// The parameter `position` of this provider.
  String get position;

  /// The parameter `type` of this provider.
  String get type;
}

class _NodeLayoutElementControllerProviderElement
    extends AutoDisposeProviderElement<TextEditingController>
    with NodeLayoutElementControllerRef {
  _NodeLayoutElementControllerProviderElement(super.provider);

  @override
  String get position =>
      (origin as NodeLayoutElementControllerProvider).position;
  @override
  String get type => (origin as NodeLayoutElementControllerProvider).type;
}

String _$currentNodeLayoutElementIndexHash() =>
    r'558139276f4d8b59ff3c311c5adf8725765b8f16';

/// See also [CurrentNodeLayoutElementIndex].
@ProviderFor(CurrentNodeLayoutElementIndex)
final currentNodeLayoutElementIndexProvider =
    AutoDisposeNotifierProvider<CurrentNodeLayoutElementIndex, int?>.internal(
  CurrentNodeLayoutElementIndex.new,
  name: r'currentNodeLayoutElementIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentNodeLayoutElementIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentNodeLayoutElementIndex = AutoDisposeNotifier<int?>;
String _$layoutElementIndexHash() =>
    r'e086cffb053f9a76962ad788bf580fa905113bae';

/// See also [LayoutElementIndex].
@ProviderFor(LayoutElementIndex)
final layoutElementIndexProvider =
    AutoDisposeNotifierProvider<LayoutElementIndex, int?>.internal(
  LayoutElementIndex.new,
  name: r'layoutElementIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$layoutElementIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LayoutElementIndex = AutoDisposeNotifier<int?>;
String _$nodeLayoutResponsiveSizeOptionHash() =>
    r'95bc70c95902d1d3dd433bd500346af60b095fbc';

abstract class _$NodeLayoutResponsiveSizeOption
    extends BuildlessAutoDisposeNotifier<ResponsiveSizeOption> {
  late final String position;

  ResponsiveSizeOption build({
    required String position,
  });
}

/// See also [NodeLayoutResponsiveSizeOption].
@ProviderFor(NodeLayoutResponsiveSizeOption)
const nodeLayoutResponsiveSizeOptionProvider =
    NodeLayoutResponsiveSizeOptionFamily();

/// See also [NodeLayoutResponsiveSizeOption].
class NodeLayoutResponsiveSizeOptionFamily
    extends Family<ResponsiveSizeOption> {
  /// See also [NodeLayoutResponsiveSizeOption].
  const NodeLayoutResponsiveSizeOptionFamily();

  /// See also [NodeLayoutResponsiveSizeOption].
  NodeLayoutResponsiveSizeOptionProvider call({
    required String position,
  }) {
    return NodeLayoutResponsiveSizeOptionProvider(
      position: position,
    );
  }

  @override
  NodeLayoutResponsiveSizeOptionProvider getProviderOverride(
    covariant NodeLayoutResponsiveSizeOptionProvider provider,
  ) {
    return call(
      position: provider.position,
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
  String? get name => r'nodeLayoutResponsiveSizeOptionProvider';
}

/// See also [NodeLayoutResponsiveSizeOption].
class NodeLayoutResponsiveSizeOptionProvider
    extends AutoDisposeNotifierProviderImpl<NodeLayoutResponsiveSizeOption,
        ResponsiveSizeOption> {
  /// See also [NodeLayoutResponsiveSizeOption].
  NodeLayoutResponsiveSizeOptionProvider({
    required String position,
  }) : this._internal(
          () => NodeLayoutResponsiveSizeOption()..position = position,
          from: nodeLayoutResponsiveSizeOptionProvider,
          name: r'nodeLayoutResponsiveSizeOptionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nodeLayoutResponsiveSizeOptionHash,
          dependencies: NodeLayoutResponsiveSizeOptionFamily._dependencies,
          allTransitiveDependencies:
              NodeLayoutResponsiveSizeOptionFamily._allTransitiveDependencies,
          position: position,
        );

  NodeLayoutResponsiveSizeOptionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.position,
  }) : super.internal();

  final String position;

  @override
  ResponsiveSizeOption runNotifierBuild(
    covariant NodeLayoutResponsiveSizeOption notifier,
  ) {
    return notifier.build(
      position: position,
    );
  }

  @override
  Override overrideWith(NodeLayoutResponsiveSizeOption Function() create) {
    return ProviderOverride(
      origin: this,
      override: NodeLayoutResponsiveSizeOptionProvider._internal(
        () => create()..position = position,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        position: position,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<NodeLayoutResponsiveSizeOption,
      ResponsiveSizeOption> createElement() {
    return _NodeLayoutResponsiveSizeOptionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NodeLayoutResponsiveSizeOptionProvider &&
        other.position == position;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NodeLayoutResponsiveSizeOptionRef
    on AutoDisposeNotifierProviderRef<ResponsiveSizeOption> {
  /// The parameter `position` of this provider.
  String get position;
}

class _NodeLayoutResponsiveSizeOptionProviderElement
    extends AutoDisposeNotifierProviderElement<NodeLayoutResponsiveSizeOption,
        ResponsiveSizeOption> with NodeLayoutResponsiveSizeOptionRef {
  _NodeLayoutResponsiveSizeOptionProviderElement(super.provider);

  @override
  String get position =>
      (origin as NodeLayoutResponsiveSizeOptionProvider).position;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
