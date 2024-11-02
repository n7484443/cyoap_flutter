// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_choice_node_preset.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$choiceNodePresetDistanceHash() =>
    r'5cf2b52b528c0358d11621efbff4521ab4c48082';

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

/// See also [choiceNodePresetDistance].
@ProviderFor(choiceNodePresetDistance)
const choiceNodePresetDistanceProvider = ChoiceNodePresetDistanceFamily();

/// See also [choiceNodePresetDistance].
class ChoiceNodePresetDistanceFamily extends Family<TextEditingController> {
  /// See also [choiceNodePresetDistance].
  const ChoiceNodePresetDistanceFamily();

  /// See also [choiceNodePresetDistance].
  ChoiceNodePresetDistanceProvider call({
    required String position,
  }) {
    return ChoiceNodePresetDistanceProvider(
      position: position,
    );
  }

  @override
  ChoiceNodePresetDistanceProvider getProviderOverride(
    covariant ChoiceNodePresetDistanceProvider provider,
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
  String? get name => r'choiceNodePresetDistanceProvider';
}

/// See also [choiceNodePresetDistance].
class ChoiceNodePresetDistanceProvider
    extends AutoDisposeProvider<TextEditingController> {
  /// See also [choiceNodePresetDistance].
  ChoiceNodePresetDistanceProvider({
    required String position,
  }) : this._internal(
          (ref) => choiceNodePresetDistance(
            ref as ChoiceNodePresetDistanceRef,
            position: position,
          ),
          from: choiceNodePresetDistanceProvider,
          name: r'choiceNodePresetDistanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$choiceNodePresetDistanceHash,
          dependencies: ChoiceNodePresetDistanceFamily._dependencies,
          allTransitiveDependencies:
              ChoiceNodePresetDistanceFamily._allTransitiveDependencies,
          position: position,
        );

  ChoiceNodePresetDistanceProvider._internal(
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
    TextEditingController Function(ChoiceNodePresetDistanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChoiceNodePresetDistanceProvider._internal(
        (ref) => create(ref as ChoiceNodePresetDistanceRef),
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
    return _ChoiceNodePresetDistanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChoiceNodePresetDistanceProvider &&
        other.position == position;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChoiceNodePresetDistanceRef
    on AutoDisposeProviderRef<TextEditingController> {
  /// The parameter `position` of this provider.
  String get position;
}

class _ChoiceNodePresetDistanceProviderElement
    extends AutoDisposeProviderElement<TextEditingController>
    with ChoiceNodePresetDistanceRef {
  _ChoiceNodePresetDistanceProviderElement(super.provider);

  @override
  String get position => (origin as ChoiceNodePresetDistanceProvider).position;
}

String _$choiceNodePresetRoundHash() =>
    r'68d04b92188b6c281e217b61aa165ac62309179e';

/// See also [choiceNodePresetRound].
@ProviderFor(choiceNodePresetRound)
const choiceNodePresetRoundProvider = ChoiceNodePresetRoundFamily();

/// See also [choiceNodePresetRound].
class ChoiceNodePresetRoundFamily extends Family<TextEditingController> {
  /// See also [choiceNodePresetRound].
  const ChoiceNodePresetRoundFamily();

  /// See also [choiceNodePresetRound].
  ChoiceNodePresetRoundProvider call({
    required String position,
  }) {
    return ChoiceNodePresetRoundProvider(
      position: position,
    );
  }

  @override
  ChoiceNodePresetRoundProvider getProviderOverride(
    covariant ChoiceNodePresetRoundProvider provider,
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
  String? get name => r'choiceNodePresetRoundProvider';
}

/// See also [choiceNodePresetRound].
class ChoiceNodePresetRoundProvider
    extends AutoDisposeProvider<TextEditingController> {
  /// See also [choiceNodePresetRound].
  ChoiceNodePresetRoundProvider({
    required String position,
  }) : this._internal(
          (ref) => choiceNodePresetRound(
            ref as ChoiceNodePresetRoundRef,
            position: position,
          ),
          from: choiceNodePresetRoundProvider,
          name: r'choiceNodePresetRoundProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$choiceNodePresetRoundHash,
          dependencies: ChoiceNodePresetRoundFamily._dependencies,
          allTransitiveDependencies:
              ChoiceNodePresetRoundFamily._allTransitiveDependencies,
          position: position,
        );

  ChoiceNodePresetRoundProvider._internal(
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
    TextEditingController Function(ChoiceNodePresetRoundRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChoiceNodePresetRoundProvider._internal(
        (ref) => create(ref as ChoiceNodePresetRoundRef),
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
    return _ChoiceNodePresetRoundProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChoiceNodePresetRoundProvider && other.position == position;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChoiceNodePresetRoundRef
    on AutoDisposeProviderRef<TextEditingController> {
  /// The parameter `position` of this provider.
  String get position;
}

class _ChoiceNodePresetRoundProviderElement
    extends AutoDisposeProviderElement<TextEditingController>
    with ChoiceNodePresetRoundRef {
  _ChoiceNodePresetRoundProviderElement(super.provider);

  @override
  String get position => (origin as ChoiceNodePresetRoundProvider).position;
}

String _$choiceNodePresetOutlineDistanceHash() =>
    r'9e36d43d5afa4354b02bafda4b8256a7ca80402f';

/// See also [choiceNodePresetOutlineDistance].
@ProviderFor(choiceNodePresetOutlineDistance)
const choiceNodePresetOutlineDistanceProvider =
    ChoiceNodePresetOutlineDistanceFamily();

/// See also [choiceNodePresetOutlineDistance].
class ChoiceNodePresetOutlineDistanceFamily
    extends Family<TextEditingController> {
  /// See also [choiceNodePresetOutlineDistance].
  const ChoiceNodePresetOutlineDistanceFamily();

  /// See also [choiceNodePresetOutlineDistance].
  ChoiceNodePresetOutlineDistanceProvider call({
    required String position,
    required bool isSelected,
  }) {
    return ChoiceNodePresetOutlineDistanceProvider(
      position: position,
      isSelected: isSelected,
    );
  }

  @override
  ChoiceNodePresetOutlineDistanceProvider getProviderOverride(
    covariant ChoiceNodePresetOutlineDistanceProvider provider,
  ) {
    return call(
      position: provider.position,
      isSelected: provider.isSelected,
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
  String? get name => r'choiceNodePresetOutlineDistanceProvider';
}

/// See also [choiceNodePresetOutlineDistance].
class ChoiceNodePresetOutlineDistanceProvider
    extends AutoDisposeProvider<TextEditingController> {
  /// See also [choiceNodePresetOutlineDistance].
  ChoiceNodePresetOutlineDistanceProvider({
    required String position,
    required bool isSelected,
  }) : this._internal(
          (ref) => choiceNodePresetOutlineDistance(
            ref as ChoiceNodePresetOutlineDistanceRef,
            position: position,
            isSelected: isSelected,
          ),
          from: choiceNodePresetOutlineDistanceProvider,
          name: r'choiceNodePresetOutlineDistanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$choiceNodePresetOutlineDistanceHash,
          dependencies: ChoiceNodePresetOutlineDistanceFamily._dependencies,
          allTransitiveDependencies:
              ChoiceNodePresetOutlineDistanceFamily._allTransitiveDependencies,
          position: position,
          isSelected: isSelected,
        );

  ChoiceNodePresetOutlineDistanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.position,
    required this.isSelected,
  }) : super.internal();

  final String position;
  final bool isSelected;

  @override
  Override overrideWith(
    TextEditingController Function(ChoiceNodePresetOutlineDistanceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChoiceNodePresetOutlineDistanceProvider._internal(
        (ref) => create(ref as ChoiceNodePresetOutlineDistanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        position: position,
        isSelected: isSelected,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<TextEditingController> createElement() {
    return _ChoiceNodePresetOutlineDistanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChoiceNodePresetOutlineDistanceProvider &&
        other.position == position &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);
    hash = _SystemHash.combine(hash, isSelected.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChoiceNodePresetOutlineDistanceRef
    on AutoDisposeProviderRef<TextEditingController> {
  /// The parameter `position` of this provider.
  String get position;

  /// The parameter `isSelected` of this provider.
  bool get isSelected;
}

class _ChoiceNodePresetOutlineDistanceProviderElement
    extends AutoDisposeProviderElement<TextEditingController>
    with ChoiceNodePresetOutlineDistanceRef {
  _ChoiceNodePresetOutlineDistanceProviderElement(super.provider);

  @override
  String get position =>
      (origin as ChoiceNodePresetOutlineDistanceProvider).position;
  @override
  bool get isSelected =>
      (origin as ChoiceNodePresetOutlineDistanceProvider).isSelected;
}

String _$choiceNodePresetOutlineRoundHash() =>
    r'710c8a6256c40ed4acbee5f955599e3fd4a78be9';

/// See also [choiceNodePresetOutlineRound].
@ProviderFor(choiceNodePresetOutlineRound)
const choiceNodePresetOutlineRoundProvider =
    ChoiceNodePresetOutlineRoundFamily();

/// See also [choiceNodePresetOutlineRound].
class ChoiceNodePresetOutlineRoundFamily extends Family<TextEditingController> {
  /// See also [choiceNodePresetOutlineRound].
  const ChoiceNodePresetOutlineRoundFamily();

  /// See also [choiceNodePresetOutlineRound].
  ChoiceNodePresetOutlineRoundProvider call({
    required String position,
    required bool isSelected,
  }) {
    return ChoiceNodePresetOutlineRoundProvider(
      position: position,
      isSelected: isSelected,
    );
  }

  @override
  ChoiceNodePresetOutlineRoundProvider getProviderOverride(
    covariant ChoiceNodePresetOutlineRoundProvider provider,
  ) {
    return call(
      position: provider.position,
      isSelected: provider.isSelected,
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
  String? get name => r'choiceNodePresetOutlineRoundProvider';
}

/// See also [choiceNodePresetOutlineRound].
class ChoiceNodePresetOutlineRoundProvider
    extends AutoDisposeProvider<TextEditingController> {
  /// See also [choiceNodePresetOutlineRound].
  ChoiceNodePresetOutlineRoundProvider({
    required String position,
    required bool isSelected,
  }) : this._internal(
          (ref) => choiceNodePresetOutlineRound(
            ref as ChoiceNodePresetOutlineRoundRef,
            position: position,
            isSelected: isSelected,
          ),
          from: choiceNodePresetOutlineRoundProvider,
          name: r'choiceNodePresetOutlineRoundProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$choiceNodePresetOutlineRoundHash,
          dependencies: ChoiceNodePresetOutlineRoundFamily._dependencies,
          allTransitiveDependencies:
              ChoiceNodePresetOutlineRoundFamily._allTransitiveDependencies,
          position: position,
          isSelected: isSelected,
        );

  ChoiceNodePresetOutlineRoundProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.position,
    required this.isSelected,
  }) : super.internal();

  final String position;
  final bool isSelected;

  @override
  Override overrideWith(
    TextEditingController Function(ChoiceNodePresetOutlineRoundRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChoiceNodePresetOutlineRoundProvider._internal(
        (ref) => create(ref as ChoiceNodePresetOutlineRoundRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        position: position,
        isSelected: isSelected,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<TextEditingController> createElement() {
    return _ChoiceNodePresetOutlineRoundProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChoiceNodePresetOutlineRoundProvider &&
        other.position == position &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);
    hash = _SystemHash.combine(hash, isSelected.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChoiceNodePresetOutlineRoundRef
    on AutoDisposeProviderRef<TextEditingController> {
  /// The parameter `position` of this provider.
  String get position;

  /// The parameter `isSelected` of this provider.
  bool get isSelected;
}

class _ChoiceNodePresetOutlineRoundProviderElement
    extends AutoDisposeProviderElement<TextEditingController>
    with ChoiceNodePresetOutlineRoundRef {
  _ChoiceNodePresetOutlineRoundProviderElement(super.provider);

  @override
  String get position =>
      (origin as ChoiceNodePresetOutlineRoundProvider).position;
  @override
  bool get isSelected =>
      (origin as ChoiceNodePresetOutlineRoundProvider).isSelected;
}

String _$choiceNodePresetImageMaxHeightRatioHash() =>
    r'09d6f97f4255e4e1cc8e6df123bb8e1253c6e9e7';

/// See also [choiceNodePresetImageMaxHeightRatio].
@ProviderFor(choiceNodePresetImageMaxHeightRatio)
final choiceNodePresetImageMaxHeightRatioProvider =
    AutoDisposeProvider<TextEditingController>.internal(
  choiceNodePresetImageMaxHeightRatio,
  name: r'choiceNodePresetImageMaxHeightRatioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$choiceNodePresetImageMaxHeightRatioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChoiceNodePresetImageMaxHeightRatioRef
    = AutoDisposeProviderRef<TextEditingController>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
