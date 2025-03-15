// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_ide.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ideControllerHash() => r'9f2ea719e19c1262853ead4d0281ce7c9796ac08';

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

/// See also [ideController].
@ProviderFor(ideController)
const ideControllerProvider = IdeControllerFamily();

/// See also [ideController].
class IdeControllerFamily extends Family<QuillController> {
  /// See also [ideController].
  const IdeControllerFamily();

  /// See also [ideController].
  IdeControllerProvider call(
    ChoiceType type,
  ) {
    return IdeControllerProvider(
      type,
    );
  }

  @override
  IdeControllerProvider getProviderOverride(
    covariant IdeControllerProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'ideControllerProvider';
}

/// See also [ideController].
class IdeControllerProvider extends AutoDisposeProvider<QuillController> {
  /// See also [ideController].
  IdeControllerProvider(
    ChoiceType type,
  ) : this._internal(
          (ref) => ideController(
            ref as IdeControllerRef,
            type,
          ),
          from: ideControllerProvider,
          name: r'ideControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ideControllerHash,
          dependencies: IdeControllerFamily._dependencies,
          allTransitiveDependencies:
              IdeControllerFamily._allTransitiveDependencies,
          type: type,
        );

  IdeControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final ChoiceType type;

  @override
  Override overrideWith(
    QuillController Function(IdeControllerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IdeControllerProvider._internal(
        (ref) => create(ref as IdeControllerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<QuillController> createElement() {
    return _IdeControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IdeControllerProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IdeControllerRef on AutoDisposeProviderRef<QuillController> {
  /// The parameter `type` of this provider.
  ChoiceType get type;
}

class _IdeControllerProviderElement
    extends AutoDisposeProviderElement<QuillController> with IdeControllerRef {
  _IdeControllerProviderElement(super.provider);

  @override
  ChoiceType get type => (origin as IdeControllerProvider).type;
}

String _$simpleCodesIdeHash() => r'4a730c1dec49b57caa9f943404b6fd96d338c691';

abstract class _$SimpleCodesIde
    extends BuildlessAutoDisposeNotifier<SimpleCodes?> {
  late final CodeActivationType type;

  SimpleCodes? build(
    CodeActivationType type,
  );
}

/// See also [SimpleCodesIde].
@ProviderFor(SimpleCodesIde)
const simpleCodesIdeProvider = SimpleCodesIdeFamily();

/// See also [SimpleCodesIde].
class SimpleCodesIdeFamily extends Family<SimpleCodes?> {
  /// See also [SimpleCodesIde].
  const SimpleCodesIdeFamily();

  /// See also [SimpleCodesIde].
  SimpleCodesIdeProvider call(
    CodeActivationType type,
  ) {
    return SimpleCodesIdeProvider(
      type,
    );
  }

  @override
  SimpleCodesIdeProvider getProviderOverride(
    covariant SimpleCodesIdeProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'simpleCodesIdeProvider';
}

/// See also [SimpleCodesIde].
class SimpleCodesIdeProvider
    extends AutoDisposeNotifierProviderImpl<SimpleCodesIde, SimpleCodes?> {
  /// See also [SimpleCodesIde].
  SimpleCodesIdeProvider(
    CodeActivationType type,
  ) : this._internal(
          () => SimpleCodesIde()..type = type,
          from: simpleCodesIdeProvider,
          name: r'simpleCodesIdeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$simpleCodesIdeHash,
          dependencies: SimpleCodesIdeFamily._dependencies,
          allTransitiveDependencies:
              SimpleCodesIdeFamily._allTransitiveDependencies,
          type: type,
        );

  SimpleCodesIdeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final CodeActivationType type;

  @override
  SimpleCodes? runNotifierBuild(
    covariant SimpleCodesIde notifier,
  ) {
    return notifier.build(
      type,
    );
  }

  @override
  Override overrideWith(SimpleCodesIde Function() create) {
    return ProviderOverride(
      origin: this,
      override: SimpleCodesIdeProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SimpleCodesIde, SimpleCodes?>
      createElement() {
    return _SimpleCodesIdeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SimpleCodesIdeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SimpleCodesIdeRef on AutoDisposeNotifierProviderRef<SimpleCodes?> {
  /// The parameter `type` of this provider.
  CodeActivationType get type;
}

class _SimpleCodesIdeProviderElement
    extends AutoDisposeNotifierProviderElement<SimpleCodesIde, SimpleCodes?>
    with SimpleCodesIdeRef {
  _SimpleCodesIdeProviderElement(super.provider);

  @override
  CodeActivationType get type => (origin as SimpleCodesIdeProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
