// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_choice_node.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$choiceNodeDesignSettingHash() =>
    r'3bcbc44af07552ccd20278b83dc3643e7cc7d545';

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

/// See also [choiceNodeDesignSetting].
@ProviderFor(choiceNodeDesignSetting)
const choiceNodeDesignSettingProvider = ChoiceNodeDesignSettingFamily();

/// See also [choiceNodeDesignSetting].
class ChoiceNodeDesignSettingFamily extends Family<ChoiceNodeOption> {
  /// See also [choiceNodeDesignSetting].
  const ChoiceNodeDesignSettingFamily();

  /// See also [choiceNodeDesignSetting].
  ChoiceNodeDesignSettingProvider call({
    required Pos pos,
  }) {
    return ChoiceNodeDesignSettingProvider(
      pos: pos,
    );
  }

  @override
  ChoiceNodeDesignSettingProvider getProviderOverride(
    covariant ChoiceNodeDesignSettingProvider provider,
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
  String? get name => r'choiceNodeDesignSettingProvider';
}

/// See also [choiceNodeDesignSetting].
class ChoiceNodeDesignSettingProvider
    extends AutoDisposeProvider<ChoiceNodeOption> {
  /// See also [choiceNodeDesignSetting].
  ChoiceNodeDesignSettingProvider({
    required Pos pos,
  }) : this._internal(
          (ref) => choiceNodeDesignSetting(
            ref as ChoiceNodeDesignSettingRef,
            pos: pos,
          ),
          from: choiceNodeDesignSettingProvider,
          name: r'choiceNodeDesignSettingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$choiceNodeDesignSettingHash,
          dependencies: ChoiceNodeDesignSettingFamily._dependencies,
          allTransitiveDependencies:
              ChoiceNodeDesignSettingFamily._allTransitiveDependencies,
          pos: pos,
        );

  ChoiceNodeDesignSettingProvider._internal(
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
    ChoiceNodeOption Function(ChoiceNodeDesignSettingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChoiceNodeDesignSettingProvider._internal(
        (ref) => create(ref as ChoiceNodeDesignSettingRef),
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
  AutoDisposeProviderElement<ChoiceNodeOption> createElement() {
    return _ChoiceNodeDesignSettingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChoiceNodeDesignSettingProvider && other.pos == pos;
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
mixin ChoiceNodeDesignSettingRef on AutoDisposeProviderRef<ChoiceNodeOption> {
  /// The parameter `pos` of this provider.
  Pos get pos;
}

class _ChoiceNodeDesignSettingProviderElement
    extends AutoDisposeProviderElement<ChoiceNodeOption>
    with ChoiceNodeDesignSettingRef {
  _ChoiceNodeDesignSettingProviderElement(super.provider);

  @override
  Pos get pos => (origin as ChoiceNodeDesignSettingProvider).pos;
}

String _$imageStringHash() => r'ca88e39c8da7f81b5116910f73894f1f1513ee1d';

/// See also [imageString].
@ProviderFor(imageString)
const imageStringProvider = ImageStringFamily();

/// See also [imageString].
class ImageStringFamily extends Family<String> {
  /// See also [imageString].
  const ImageStringFamily();

  /// See also [imageString].
  ImageStringProvider call({
    required Pos pos,
  }) {
    return ImageStringProvider(
      pos: pos,
    );
  }

  @override
  ImageStringProvider getProviderOverride(
    covariant ImageStringProvider provider,
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
  String? get name => r'imageStringProvider';
}

/// See also [imageString].
class ImageStringProvider extends AutoDisposeProvider<String> {
  /// See also [imageString].
  ImageStringProvider({
    required Pos pos,
  }) : this._internal(
          (ref) => imageString(
            ref as ImageStringRef,
            pos: pos,
          ),
          from: imageStringProvider,
          name: r'imageStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$imageStringHash,
          dependencies: ImageStringFamily._dependencies,
          allTransitiveDependencies:
              ImageStringFamily._allTransitiveDependencies,
          pos: pos,
        );

  ImageStringProvider._internal(
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
    String Function(ImageStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ImageStringProvider._internal(
        (ref) => create(ref as ImageStringRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _ImageStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ImageStringProvider && other.pos == pos;
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
mixin ImageStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `pos` of this provider.
  Pos get pos;
}

class _ImageStringProviderElement extends AutoDisposeProviderElement<String>
    with ImageStringRef {
  _ImageStringProviderElement(super.provider);

  @override
  Pos get pos => (origin as ImageStringProvider).pos;
}

String _$contentsQuillHash() => r'b6ea3ae4b5c24cea15d6cfd1b8d85915f94bba0a';

/// See also [contentsQuill].
@ProviderFor(contentsQuill)
const contentsQuillProvider = ContentsQuillFamily();

/// See also [contentsQuill].
class ContentsQuillFamily extends Family<String?> {
  /// See also [contentsQuill].
  const ContentsQuillFamily();

  /// See also [contentsQuill].
  ContentsQuillProvider call({
    required Pos pos,
  }) {
    return ContentsQuillProvider(
      pos: pos,
    );
  }

  @override
  ContentsQuillProvider getProviderOverride(
    covariant ContentsQuillProvider provider,
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
  String? get name => r'contentsQuillProvider';
}

/// See also [contentsQuill].
class ContentsQuillProvider extends AutoDisposeProvider<String?> {
  /// See also [contentsQuill].
  ContentsQuillProvider({
    required Pos pos,
  }) : this._internal(
          (ref) => contentsQuill(
            ref as ContentsQuillRef,
            pos: pos,
          ),
          from: contentsQuillProvider,
          name: r'contentsQuillProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$contentsQuillHash,
          dependencies: ContentsQuillFamily._dependencies,
          allTransitiveDependencies:
              ContentsQuillFamily._allTransitiveDependencies,
          pos: pos,
        );

  ContentsQuillProvider._internal(
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
    String? Function(ContentsQuillRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ContentsQuillProvider._internal(
        (ref) => create(ref as ContentsQuillRef),
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
  AutoDisposeProviderElement<String?> createElement() {
    return _ContentsQuillProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContentsQuillProvider && other.pos == pos;
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
mixin ContentsQuillRef on AutoDisposeProviderRef<String?> {
  /// The parameter `pos` of this provider.
  Pos get pos;
}

class _ContentsQuillProviderElement extends AutoDisposeProviderElement<String?>
    with ContentsQuillRef {
  _ContentsQuillProviderElement(super.provider);

  @override
  Pos get pos => (origin as ContentsQuillProvider).pos;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
