// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_choice_node_preset.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$choiceNodePresetDefaultOutlineDistanceHash() =>
    r'09d93661bb74e5e3a16d16cc9fd506ea2815ca32';

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

/// See also [choiceNodePresetDefaultOutlineDistance].
@ProviderFor(choiceNodePresetDefaultOutlineDistance)
const choiceNodePresetDefaultOutlineDistanceProvider =
    ChoiceNodePresetDefaultOutlineDistanceFamily();

/// See also [choiceNodePresetDefaultOutlineDistance].
class ChoiceNodePresetDefaultOutlineDistanceFamily
    extends Family<TextEditingController> {
  /// See also [choiceNodePresetDefaultOutlineDistance].
  const ChoiceNodePresetDefaultOutlineDistanceFamily();

  /// See also [choiceNodePresetDefaultOutlineDistance].
  ChoiceNodePresetDefaultOutlineDistanceProvider call(
    String position,
  ) {
    return ChoiceNodePresetDefaultOutlineDistanceProvider(
      position,
    );
  }

  @override
  ChoiceNodePresetDefaultOutlineDistanceProvider getProviderOverride(
    covariant ChoiceNodePresetDefaultOutlineDistanceProvider provider,
  ) {
    return call(
      provider.position,
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
  String? get name => r'choiceNodePresetDefaultOutlineDistanceProvider';
}

/// See also [choiceNodePresetDefaultOutlineDistance].
class ChoiceNodePresetDefaultOutlineDistanceProvider
    extends AutoDisposeProvider<TextEditingController> {
  /// See also [choiceNodePresetDefaultOutlineDistance].
  ChoiceNodePresetDefaultOutlineDistanceProvider(
    String position,
  ) : this._internal(
          (ref) => choiceNodePresetDefaultOutlineDistance(
            ref as ChoiceNodePresetDefaultOutlineDistanceRef,
            position,
          ),
          from: choiceNodePresetDefaultOutlineDistanceProvider,
          name: r'choiceNodePresetDefaultOutlineDistanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$choiceNodePresetDefaultOutlineDistanceHash,
          dependencies:
              ChoiceNodePresetDefaultOutlineDistanceFamily._dependencies,
          allTransitiveDependencies:
              ChoiceNodePresetDefaultOutlineDistanceFamily
                  ._allTransitiveDependencies,
          position: position,
        );

  ChoiceNodePresetDefaultOutlineDistanceProvider._internal(
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
  Override overrideWith(
    TextEditingController Function(
            ChoiceNodePresetDefaultOutlineDistanceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChoiceNodePresetDefaultOutlineDistanceProvider._internal(
        (ref) => create(ref as ChoiceNodePresetDefaultOutlineDistanceRef),
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
  AutoDisposeProviderElement<TextEditingController> createElement() {
    return _ChoiceNodePresetDefaultOutlineDistanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChoiceNodePresetDefaultOutlineDistanceProvider &&
        other.position == position;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChoiceNodePresetDefaultOutlineDistanceRef
    on AutoDisposeProviderRef<TextEditingController> {
  /// The parameter `position` of this provider.
  String get position;
}

class _ChoiceNodePresetDefaultOutlineDistanceProviderElement
    extends AutoDisposeProviderElement<TextEditingController>
    with ChoiceNodePresetDefaultOutlineDistanceRef {
  _ChoiceNodePresetDefaultOutlineDistanceProviderElement(super.provider);

  @override
  String get position =>
      (origin as ChoiceNodePresetDefaultOutlineDistanceProvider).position;
}

String _$choiceNodePresetSelectedOutlineDistanceHash() =>
    r'3fb491440c96d164c25296105b0663b032566949';

/// See also [choiceNodePresetSelectedOutlineDistance].
@ProviderFor(choiceNodePresetSelectedOutlineDistance)
const choiceNodePresetSelectedOutlineDistanceProvider =
    ChoiceNodePresetSelectedOutlineDistanceFamily();

/// See also [choiceNodePresetSelectedOutlineDistance].
class ChoiceNodePresetSelectedOutlineDistanceFamily
    extends Family<TextEditingController> {
  /// See also [choiceNodePresetSelectedOutlineDistance].
  const ChoiceNodePresetSelectedOutlineDistanceFamily();

  /// See also [choiceNodePresetSelectedOutlineDistance].
  ChoiceNodePresetSelectedOutlineDistanceProvider call(
    String position,
  ) {
    return ChoiceNodePresetSelectedOutlineDistanceProvider(
      position,
    );
  }

  @override
  ChoiceNodePresetSelectedOutlineDistanceProvider getProviderOverride(
    covariant ChoiceNodePresetSelectedOutlineDistanceProvider provider,
  ) {
    return call(
      provider.position,
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
  String? get name => r'choiceNodePresetSelectedOutlineDistanceProvider';
}

/// See also [choiceNodePresetSelectedOutlineDistance].
class ChoiceNodePresetSelectedOutlineDistanceProvider
    extends AutoDisposeProvider<TextEditingController> {
  /// See also [choiceNodePresetSelectedOutlineDistance].
  ChoiceNodePresetSelectedOutlineDistanceProvider(
    String position,
  ) : this._internal(
          (ref) => choiceNodePresetSelectedOutlineDistance(
            ref as ChoiceNodePresetSelectedOutlineDistanceRef,
            position,
          ),
          from: choiceNodePresetSelectedOutlineDistanceProvider,
          name: r'choiceNodePresetSelectedOutlineDistanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$choiceNodePresetSelectedOutlineDistanceHash,
          dependencies:
              ChoiceNodePresetSelectedOutlineDistanceFamily._dependencies,
          allTransitiveDependencies:
              ChoiceNodePresetSelectedOutlineDistanceFamily
                  ._allTransitiveDependencies,
          position: position,
        );

  ChoiceNodePresetSelectedOutlineDistanceProvider._internal(
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
  Override overrideWith(
    TextEditingController Function(
            ChoiceNodePresetSelectedOutlineDistanceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChoiceNodePresetSelectedOutlineDistanceProvider._internal(
        (ref) => create(ref as ChoiceNodePresetSelectedOutlineDistanceRef),
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
  AutoDisposeProviderElement<TextEditingController> createElement() {
    return _ChoiceNodePresetSelectedOutlineDistanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChoiceNodePresetSelectedOutlineDistanceProvider &&
        other.position == position;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChoiceNodePresetSelectedOutlineDistanceRef
    on AutoDisposeProviderRef<TextEditingController> {
  /// The parameter `position` of this provider.
  String get position;
}

class _ChoiceNodePresetSelectedOutlineDistanceProviderElement
    extends AutoDisposeProviderElement<TextEditingController>
    with ChoiceNodePresetSelectedOutlineDistanceRef {
  _ChoiceNodePresetSelectedOutlineDistanceProviderElement(super.provider);

  @override
  String get position =>
      (origin as ChoiceNodePresetSelectedOutlineDistanceProvider).position;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
