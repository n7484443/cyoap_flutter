// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_choice_node.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contentsQuillHash() => r'b6ea3ae4b5c24cea15d6cfd1b8d85915f94bba0a';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
