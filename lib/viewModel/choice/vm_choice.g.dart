// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_choice.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isEditableHash() => r'3619fbac4ae0c9e5cba05bdbf31e1345b0b56a64';

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

/// See also [isEditable].
@ProviderFor(isEditable)
const isEditableProvider = IsEditableFamily();

/// See also [isEditable].
class IsEditableFamily extends Family<bool> {
  /// See also [isEditable].
  const IsEditableFamily();

  /// See also [isEditable].
  IsEditableProvider call({
    required Pos pos,
  }) {
    return IsEditableProvider(
      pos: pos,
    );
  }

  @override
  IsEditableProvider getProviderOverride(
    covariant IsEditableProvider provider,
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
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'isEditableProvider';
}

/// See also [isEditable].
class IsEditableProvider extends AutoDisposeProvider<bool> {
  /// See also [isEditable].
  IsEditableProvider({
    required Pos pos,
  }) : this._internal(
          (ref) => isEditable(
            ref as IsEditableRef,
            pos: pos,
          ),
          from: isEditableProvider,
          name: r'isEditableProvider',
          debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$isEditableHash,
          dependencies: IsEditableFamily._dependencies,
          allTransitiveDependencies: IsEditableFamily._allTransitiveDependencies,
          pos: pos,
        );

  IsEditableProvider._internal(
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
    bool Function(IsEditableRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsEditableProvider._internal(
        (ref) => create(ref as IsEditableRef),
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
  AutoDisposeProviderElement<bool> createElement() {
    return _IsEditableProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsEditableProvider && other.pos == pos;
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
mixin IsEditableRef on AutoDisposeProviderRef<bool> {
  /// The parameter `pos` of this provider.
  Pos get pos;
}

class _IsEditableProviderElement extends AutoDisposeProviderElement<bool> with IsEditableRef {
  _IsEditableProviderElement(super.provider);

  @override
  Pos get pos => (origin as IsEditableProvider).pos;
}

String _$currentChoicePageHash() => r'003ac8515eccc0256082707b068b20c41e61dd88';

/// See also [CurrentChoicePage].
@ProviderFor(CurrentChoicePage)
final currentChoicePageProvider = AutoDisposeNotifierProvider<CurrentChoicePage, Pos>.internal(
  CurrentChoicePage.new,
  name: r'currentChoicePageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$currentChoicePageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentChoicePage = AutoDisposeNotifier<Pos>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
