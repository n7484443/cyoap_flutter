// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_choice_node_preset.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$choiceNodePresetOutlineDistanceHash() =>
    r'66caa571048d6bb38b81dafe9534ec853cb02cab';

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
    r'264c1c8333b1da99d872760cbc5282e3a107c008';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
