// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_choice_line.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lineDesignPresetHash() => r'68d0b43703c3982a329fce458c1863fecd649766';

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

/// See also [lineDesignPreset].
@ProviderFor(lineDesignPreset)
const lineDesignPresetProvider = LineDesignPresetFamily();

/// See also [lineDesignPreset].
class LineDesignPresetFamily extends Family<ChoiceLineDesignPreset> {
  /// See also [lineDesignPreset].
  const LineDesignPresetFamily();

  /// See also [lineDesignPreset].
  LineDesignPresetProvider call({
    required Pos pos,
  }) {
    return LineDesignPresetProvider(
      pos: pos,
    );
  }

  @override
  LineDesignPresetProvider getProviderOverride(
    covariant LineDesignPresetProvider provider,
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
  String? get name => r'lineDesignPresetProvider';
}

/// See also [lineDesignPreset].
class LineDesignPresetProvider
    extends AutoDisposeProvider<ChoiceLineDesignPreset> {
  /// See also [lineDesignPreset].
  LineDesignPresetProvider({
    required Pos pos,
  }) : this._internal(
          (ref) => lineDesignPreset(
            ref as LineDesignPresetRef,
            pos: pos,
          ),
          from: lineDesignPresetProvider,
          name: r'lineDesignPresetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lineDesignPresetHash,
          dependencies: LineDesignPresetFamily._dependencies,
          allTransitiveDependencies:
              LineDesignPresetFamily._allTransitiveDependencies,
          pos: pos,
        );

  LineDesignPresetProvider._internal(
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
    ChoiceLineDesignPreset Function(LineDesignPresetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LineDesignPresetProvider._internal(
        (ref) => create(ref as LineDesignPresetRef),
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
  AutoDisposeProviderElement<ChoiceLineDesignPreset> createElement() {
    return _LineDesignPresetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LineDesignPresetProvider && other.pos == pos;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pos.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LineDesignPresetRef on AutoDisposeProviderRef<ChoiceLineDesignPreset> {
  /// The parameter `pos` of this provider.
  Pos get pos;
}

class _LineDesignPresetProviderElement
    extends AutoDisposeProviderElement<ChoiceLineDesignPreset>
    with LineDesignPresetRef {
  _LineDesignPresetProviderElement(super.provider);

  @override
  Pos get pos => (origin as LineDesignPresetProvider).pos;
}

String _$lineOptionHash() => r'14d67fc53fd65d2c266b17b303cecafb1469b682';

abstract class _$LineOption
    extends BuildlessAutoDisposeNotifier<ChoiceLineOption> {
  late final Pos pos;

  ChoiceLineOption build({
    required Pos pos,
  });
}

/// See also [LineOption].
@ProviderFor(LineOption)
const lineOptionProvider = LineOptionFamily();

/// See also [LineOption].
class LineOptionFamily extends Family<ChoiceLineOption> {
  /// See also [LineOption].
  const LineOptionFamily();

  /// See also [LineOption].
  LineOptionProvider call({
    required Pos pos,
  }) {
    return LineOptionProvider(
      pos: pos,
    );
  }

  @override
  LineOptionProvider getProviderOverride(
    covariant LineOptionProvider provider,
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
  String? get name => r'lineOptionProvider';
}

/// See also [LineOption].
class LineOptionProvider
    extends AutoDisposeNotifierProviderImpl<LineOption, ChoiceLineOption> {
  /// See also [LineOption].
  LineOptionProvider({
    required Pos pos,
  }) : this._internal(
          () => LineOption()..pos = pos,
          from: lineOptionProvider,
          name: r'lineOptionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lineOptionHash,
          dependencies: LineOptionFamily._dependencies,
          allTransitiveDependencies:
              LineOptionFamily._allTransitiveDependencies,
          pos: pos,
        );

  LineOptionProvider._internal(
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
  ChoiceLineOption runNotifierBuild(
    covariant LineOption notifier,
  ) {
    return notifier.build(
      pos: pos,
    );
  }

  @override
  Override overrideWith(LineOption Function() create) {
    return ProviderOverride(
      origin: this,
      override: LineOptionProvider._internal(
        () => create()..pos = pos,
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
  AutoDisposeNotifierProviderElement<LineOption, ChoiceLineOption>
      createElement() {
    return _LineOptionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LineOptionProvider && other.pos == pos;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pos.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LineOptionRef on AutoDisposeNotifierProviderRef<ChoiceLineOption> {
  /// The parameter `pos` of this provider.
  Pos get pos;
}

class _LineOptionProviderElement
    extends AutoDisposeNotifierProviderElement<LineOption, ChoiceLineOption>
    with LineOptionRef {
  _LineOptionProviderElement(super.provider);

  @override
  Pos get pos => (origin as LineOptionProvider).pos;
}

String _$lineFoldHash() => r'78a1d8fdcc1b6d6ebfde7843ea1731ee128a175b';

abstract class _$LineFold extends BuildlessAutoDisposeNotifier<bool> {
  late final Pos pos;

  bool build({
    required Pos pos,
  });
}

/// See also [LineFold].
@ProviderFor(LineFold)
const lineFoldProvider = LineFoldFamily();

/// See also [LineFold].
class LineFoldFamily extends Family<bool> {
  /// See also [LineFold].
  const LineFoldFamily();

  /// See also [LineFold].
  LineFoldProvider call({
    required Pos pos,
  }) {
    return LineFoldProvider(
      pos: pos,
    );
  }

  @override
  LineFoldProvider getProviderOverride(
    covariant LineFoldProvider provider,
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
  String? get name => r'lineFoldProvider';
}

/// See also [LineFold].
class LineFoldProvider extends AutoDisposeNotifierProviderImpl<LineFold, bool> {
  /// See also [LineFold].
  LineFoldProvider({
    required Pos pos,
  }) : this._internal(
          () => LineFold()..pos = pos,
          from: lineFoldProvider,
          name: r'lineFoldProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lineFoldHash,
          dependencies: LineFoldFamily._dependencies,
          allTransitiveDependencies: LineFoldFamily._allTransitiveDependencies,
          pos: pos,
        );

  LineFoldProvider._internal(
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
  bool runNotifierBuild(
    covariant LineFold notifier,
  ) {
    return notifier.build(
      pos: pos,
    );
  }

  @override
  Override overrideWith(LineFold Function() create) {
    return ProviderOverride(
      origin: this,
      override: LineFoldProvider._internal(
        () => create()..pos = pos,
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
  AutoDisposeNotifierProviderElement<LineFold, bool> createElement() {
    return _LineFoldProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LineFoldProvider && other.pos == pos;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pos.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LineFoldRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `pos` of this provider.
  Pos get pos;
}

class _LineFoldProviderElement
    extends AutoDisposeNotifierProviderElement<LineFold, bool>
    with LineFoldRef {
  _LineFoldProviderElement(super.provider);

  @override
  Pos get pos => (origin as LineFoldProvider).pos;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
