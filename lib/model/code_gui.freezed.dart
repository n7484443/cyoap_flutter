// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'code_gui.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CodeBlockSet {
  List<CodeBlockBuild> get codeBlocks => throw _privateConstructorUsedError;
  CodeBlockBuild? get parentCodeBlock => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CodeBlockSetCopyWith<CodeBlockSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CodeBlockSetCopyWith<$Res> {
  factory $CodeBlockSetCopyWith(
          CodeBlockSet value, $Res Function(CodeBlockSet) then) =
      _$CodeBlockSetCopyWithImpl<$Res, CodeBlockSet>;
  @useResult
  $Res call({List<CodeBlockBuild> codeBlocks, CodeBlockBuild? parentCodeBlock});
}

/// @nodoc
class _$CodeBlockSetCopyWithImpl<$Res, $Val extends CodeBlockSet>
    implements $CodeBlockSetCopyWith<$Res> {
  _$CodeBlockSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeBlocks = null,
    Object? parentCodeBlock = freezed,
  }) {
    return _then(_value.copyWith(
      codeBlocks: null == codeBlocks
          ? _value.codeBlocks
          : codeBlocks // ignore: cast_nullable_to_non_nullable
              as List<CodeBlockBuild>,
      parentCodeBlock: freezed == parentCodeBlock
          ? _value.parentCodeBlock
          : parentCodeBlock // ignore: cast_nullable_to_non_nullable
              as CodeBlockBuild?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CodeBlockSetCopyWith<$Res>
    implements $CodeBlockSetCopyWith<$Res> {
  factory _$$_CodeBlockSetCopyWith(
          _$_CodeBlockSet value, $Res Function(_$_CodeBlockSet) then) =
      __$$_CodeBlockSetCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CodeBlockBuild> codeBlocks, CodeBlockBuild? parentCodeBlock});
}

/// @nodoc
class __$$_CodeBlockSetCopyWithImpl<$Res>
    extends _$CodeBlockSetCopyWithImpl<$Res, _$_CodeBlockSet>
    implements _$$_CodeBlockSetCopyWith<$Res> {
  __$$_CodeBlockSetCopyWithImpl(
      _$_CodeBlockSet _value, $Res Function(_$_CodeBlockSet) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeBlocks = null,
    Object? parentCodeBlock = freezed,
  }) {
    return _then(_$_CodeBlockSet(
      codeBlocks: null == codeBlocks
          ? _value._codeBlocks
          : codeBlocks // ignore: cast_nullable_to_non_nullable
              as List<CodeBlockBuild>,
      parentCodeBlock: freezed == parentCodeBlock
          ? _value.parentCodeBlock
          : parentCodeBlock // ignore: cast_nullable_to_non_nullable
              as CodeBlockBuild?,
    ));
  }
}

/// @nodoc

class _$_CodeBlockSet extends _CodeBlockSet {
  const _$_CodeBlockSet(
      {final List<CodeBlockBuild> codeBlocks = const [],
      this.parentCodeBlock = null})
      : _codeBlocks = codeBlocks,
        super._();

  final List<CodeBlockBuild> _codeBlocks;
  @override
  @JsonKey()
  List<CodeBlockBuild> get codeBlocks {
    if (_codeBlocks is EqualUnmodifiableListView) return _codeBlocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_codeBlocks);
  }

  @override
  @JsonKey()
  final CodeBlockBuild? parentCodeBlock;

  @override
  String toString() {
    return 'CodeBlockSet(codeBlocks: $codeBlocks, parentCodeBlock: $parentCodeBlock)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CodeBlockSet &&
            const DeepCollectionEquality()
                .equals(other._codeBlocks, _codeBlocks) &&
            (identical(other.parentCodeBlock, parentCodeBlock) ||
                other.parentCodeBlock == parentCodeBlock));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_codeBlocks), parentCodeBlock);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CodeBlockSetCopyWith<_$_CodeBlockSet> get copyWith =>
      __$$_CodeBlockSetCopyWithImpl<_$_CodeBlockSet>(this, _$identity);
}

abstract class _CodeBlockSet extends CodeBlockSet {
  const factory _CodeBlockSet(
      {final List<CodeBlockBuild> codeBlocks,
      final CodeBlockBuild? parentCodeBlock}) = _$_CodeBlockSet;
  const _CodeBlockSet._() : super._();

  @override
  List<CodeBlockBuild> get codeBlocks;
  @override
  CodeBlockBuild? get parentCodeBlock;
  @override
  @JsonKey(ignore: true)
  _$$_CodeBlockSetCopyWith<_$_CodeBlockSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CodeBlock {
  String get code => throw _privateConstructorUsedError;
  CodeBlockBuild? get parentCodeBlock => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CodeBlockCopyWith<CodeBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CodeBlockCopyWith<$Res> {
  factory $CodeBlockCopyWith(CodeBlock value, $Res Function(CodeBlock) then) =
      _$CodeBlockCopyWithImpl<$Res, CodeBlock>;
  @useResult
  $Res call({String code, CodeBlockBuild? parentCodeBlock});
}

/// @nodoc
class _$CodeBlockCopyWithImpl<$Res, $Val extends CodeBlock>
    implements $CodeBlockCopyWith<$Res> {
  _$CodeBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? parentCodeBlock = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      parentCodeBlock: freezed == parentCodeBlock
          ? _value.parentCodeBlock
          : parentCodeBlock // ignore: cast_nullable_to_non_nullable
              as CodeBlockBuild?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CodeBlockCopyWith<$Res> implements $CodeBlockCopyWith<$Res> {
  factory _$$_CodeBlockCopyWith(
          _$_CodeBlock value, $Res Function(_$_CodeBlock) then) =
      __$$_CodeBlockCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, CodeBlockBuild? parentCodeBlock});
}

/// @nodoc
class __$$_CodeBlockCopyWithImpl<$Res>
    extends _$CodeBlockCopyWithImpl<$Res, _$_CodeBlock>
    implements _$$_CodeBlockCopyWith<$Res> {
  __$$_CodeBlockCopyWithImpl(
      _$_CodeBlock _value, $Res Function(_$_CodeBlock) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? parentCodeBlock = freezed,
  }) {
    return _then(_$_CodeBlock(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      parentCodeBlock: freezed == parentCodeBlock
          ? _value.parentCodeBlock
          : parentCodeBlock // ignore: cast_nullable_to_non_nullable
              as CodeBlockBuild?,
    ));
  }
}

/// @nodoc

class _$_CodeBlock extends _CodeBlock {
  const _$_CodeBlock({this.code = '', this.parentCodeBlock = null}) : super._();

  @override
  @JsonKey()
  final String code;
  @override
  @JsonKey()
  final CodeBlockBuild? parentCodeBlock;

  @override
  String toString() {
    return 'CodeBlock(code: $code, parentCodeBlock: $parentCodeBlock)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CodeBlock &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.parentCodeBlock, parentCodeBlock) ||
                other.parentCodeBlock == parentCodeBlock));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, parentCodeBlock);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CodeBlockCopyWith<_$_CodeBlock> get copyWith =>
      __$$_CodeBlockCopyWithImpl<_$_CodeBlock>(this, _$identity);
}

abstract class _CodeBlock extends CodeBlock {
  const factory _CodeBlock(
      {final String code,
      final CodeBlockBuild? parentCodeBlock}) = _$_CodeBlock;
  const _CodeBlock._() : super._();

  @override
  String get code;
  @override
  CodeBlockBuild? get parentCodeBlock;
  @override
  @JsonKey(ignore: true)
  _$$_CodeBlockCopyWith<_$_CodeBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CodeBlockIf {
  String get code => throw _privateConstructorUsedError;
  CodeBlockBuild? get parentCodeBlock => throw _privateConstructorUsedError;
  List<CodeBlockBuild> get childTrue => throw _privateConstructorUsedError;
  List<CodeBlockBuild> get childFalse => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CodeBlockIfCopyWith<CodeBlockIf> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CodeBlockIfCopyWith<$Res> {
  factory $CodeBlockIfCopyWith(
          CodeBlockIf value, $Res Function(CodeBlockIf) then) =
      _$CodeBlockIfCopyWithImpl<$Res, CodeBlockIf>;
  @useResult
  $Res call(
      {String code,
      CodeBlockBuild? parentCodeBlock,
      List<CodeBlockBuild> childTrue,
      List<CodeBlockBuild> childFalse});
}

/// @nodoc
class _$CodeBlockIfCopyWithImpl<$Res, $Val extends CodeBlockIf>
    implements $CodeBlockIfCopyWith<$Res> {
  _$CodeBlockIfCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? parentCodeBlock = freezed,
    Object? childTrue = null,
    Object? childFalse = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      parentCodeBlock: freezed == parentCodeBlock
          ? _value.parentCodeBlock
          : parentCodeBlock // ignore: cast_nullable_to_non_nullable
              as CodeBlockBuild?,
      childTrue: null == childTrue
          ? _value.childTrue
          : childTrue // ignore: cast_nullable_to_non_nullable
              as List<CodeBlockBuild>,
      childFalse: null == childFalse
          ? _value.childFalse
          : childFalse // ignore: cast_nullable_to_non_nullable
              as List<CodeBlockBuild>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CodeBlockIfCopyWith<$Res>
    implements $CodeBlockIfCopyWith<$Res> {
  factory _$$_CodeBlockIfCopyWith(
          _$_CodeBlockIf value, $Res Function(_$_CodeBlockIf) then) =
      __$$_CodeBlockIfCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      CodeBlockBuild? parentCodeBlock,
      List<CodeBlockBuild> childTrue,
      List<CodeBlockBuild> childFalse});
}

/// @nodoc
class __$$_CodeBlockIfCopyWithImpl<$Res>
    extends _$CodeBlockIfCopyWithImpl<$Res, _$_CodeBlockIf>
    implements _$$_CodeBlockIfCopyWith<$Res> {
  __$$_CodeBlockIfCopyWithImpl(
      _$_CodeBlockIf _value, $Res Function(_$_CodeBlockIf) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? parentCodeBlock = freezed,
    Object? childTrue = null,
    Object? childFalse = null,
  }) {
    return _then(_$_CodeBlockIf(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      parentCodeBlock: freezed == parentCodeBlock
          ? _value.parentCodeBlock
          : parentCodeBlock // ignore: cast_nullable_to_non_nullable
              as CodeBlockBuild?,
      childTrue: null == childTrue
          ? _value._childTrue
          : childTrue // ignore: cast_nullable_to_non_nullable
              as List<CodeBlockBuild>,
      childFalse: null == childFalse
          ? _value._childFalse
          : childFalse // ignore: cast_nullable_to_non_nullable
              as List<CodeBlockBuild>,
    ));
  }
}

/// @nodoc

class _$_CodeBlockIf extends _CodeBlockIf {
  const _$_CodeBlockIf(
      {this.code = '',
      this.parentCodeBlock = null,
      final List<CodeBlockBuild> childTrue = const [],
      final List<CodeBlockBuild> childFalse = const []})
      : _childTrue = childTrue,
        _childFalse = childFalse,
        super._();

  @override
  @JsonKey()
  final String code;
  @override
  @JsonKey()
  final CodeBlockBuild? parentCodeBlock;
  final List<CodeBlockBuild> _childTrue;
  @override
  @JsonKey()
  List<CodeBlockBuild> get childTrue {
    if (_childTrue is EqualUnmodifiableListView) return _childTrue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childTrue);
  }

  final List<CodeBlockBuild> _childFalse;
  @override
  @JsonKey()
  List<CodeBlockBuild> get childFalse {
    if (_childFalse is EqualUnmodifiableListView) return _childFalse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childFalse);
  }

  @override
  String toString() {
    return 'CodeBlockIf(code: $code, parentCodeBlock: $parentCodeBlock, childTrue: $childTrue, childFalse: $childFalse)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CodeBlockIf &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.parentCodeBlock, parentCodeBlock) ||
                other.parentCodeBlock == parentCodeBlock) &&
            const DeepCollectionEquality()
                .equals(other._childTrue, _childTrue) &&
            const DeepCollectionEquality()
                .equals(other._childFalse, _childFalse));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      code,
      parentCodeBlock,
      const DeepCollectionEquality().hash(_childTrue),
      const DeepCollectionEquality().hash(_childFalse));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CodeBlockIfCopyWith<_$_CodeBlockIf> get copyWith =>
      __$$_CodeBlockIfCopyWithImpl<_$_CodeBlockIf>(this, _$identity);
}

abstract class _CodeBlockIf extends CodeBlockIf {
  const factory _CodeBlockIf(
      {final String code,
      final CodeBlockBuild? parentCodeBlock,
      final List<CodeBlockBuild> childTrue,
      final List<CodeBlockBuild> childFalse}) = _$_CodeBlockIf;
  const _CodeBlockIf._() : super._();

  @override
  String get code;
  @override
  CodeBlockBuild? get parentCodeBlock;
  @override
  List<CodeBlockBuild> get childTrue;
  @override
  List<CodeBlockBuild> get childFalse;
  @override
  @JsonKey(ignore: true)
  _$$_CodeBlockIfCopyWith<_$_CodeBlockIf> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CodeBlockFor {
  String get code => throw _privateConstructorUsedError;
  String get range => throw _privateConstructorUsedError;
  CodeBlockBuild? get parentCodeBlock => throw _privateConstructorUsedError;
  List<CodeBlockBuild> get childFor => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CodeBlockForCopyWith<CodeBlockFor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CodeBlockForCopyWith<$Res> {
  factory $CodeBlockForCopyWith(
          CodeBlockFor value, $Res Function(CodeBlockFor) then) =
      _$CodeBlockForCopyWithImpl<$Res, CodeBlockFor>;
  @useResult
  $Res call(
      {String code,
      String range,
      CodeBlockBuild? parentCodeBlock,
      List<CodeBlockBuild> childFor});
}

/// @nodoc
class _$CodeBlockForCopyWithImpl<$Res, $Val extends CodeBlockFor>
    implements $CodeBlockForCopyWith<$Res> {
  _$CodeBlockForCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? range = null,
    Object? parentCodeBlock = freezed,
    Object? childFor = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      range: null == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as String,
      parentCodeBlock: freezed == parentCodeBlock
          ? _value.parentCodeBlock
          : parentCodeBlock // ignore: cast_nullable_to_non_nullable
              as CodeBlockBuild?,
      childFor: null == childFor
          ? _value.childFor
          : childFor // ignore: cast_nullable_to_non_nullable
              as List<CodeBlockBuild>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CodeBlockForCopyWith<$Res>
    implements $CodeBlockForCopyWith<$Res> {
  factory _$$_CodeBlockForCopyWith(
          _$_CodeBlockFor value, $Res Function(_$_CodeBlockFor) then) =
      __$$_CodeBlockForCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String range,
      CodeBlockBuild? parentCodeBlock,
      List<CodeBlockBuild> childFor});
}

/// @nodoc
class __$$_CodeBlockForCopyWithImpl<$Res>
    extends _$CodeBlockForCopyWithImpl<$Res, _$_CodeBlockFor>
    implements _$$_CodeBlockForCopyWith<$Res> {
  __$$_CodeBlockForCopyWithImpl(
      _$_CodeBlockFor _value, $Res Function(_$_CodeBlockFor) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? range = null,
    Object? parentCodeBlock = freezed,
    Object? childFor = null,
  }) {
    return _then(_$_CodeBlockFor(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      range: null == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as String,
      parentCodeBlock: freezed == parentCodeBlock
          ? _value.parentCodeBlock
          : parentCodeBlock // ignore: cast_nullable_to_non_nullable
              as CodeBlockBuild?,
      childFor: null == childFor
          ? _value._childFor
          : childFor // ignore: cast_nullable_to_non_nullable
              as List<CodeBlockBuild>,
    ));
  }
}

/// @nodoc

class _$_CodeBlockFor extends _CodeBlockFor {
  const _$_CodeBlockFor(
      {this.code = '',
      this.range = '',
      this.parentCodeBlock = null,
      final List<CodeBlockBuild> childFor = const []})
      : _childFor = childFor,
        super._();

  @override
  @JsonKey()
  final String code;
  @override
  @JsonKey()
  final String range;
  @override
  @JsonKey()
  final CodeBlockBuild? parentCodeBlock;
  final List<CodeBlockBuild> _childFor;
  @override
  @JsonKey()
  List<CodeBlockBuild> get childFor {
    if (_childFor is EqualUnmodifiableListView) return _childFor;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childFor);
  }

  @override
  String toString() {
    return 'CodeBlockFor(code: $code, range: $range, parentCodeBlock: $parentCodeBlock, childFor: $childFor)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CodeBlockFor &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.range, range) || other.range == range) &&
            (identical(other.parentCodeBlock, parentCodeBlock) ||
                other.parentCodeBlock == parentCodeBlock) &&
            const DeepCollectionEquality().equals(other._childFor, _childFor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, range, parentCodeBlock,
      const DeepCollectionEquality().hash(_childFor));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CodeBlockForCopyWith<_$_CodeBlockFor> get copyWith =>
      __$$_CodeBlockForCopyWithImpl<_$_CodeBlockFor>(this, _$identity);
}

abstract class _CodeBlockFor extends CodeBlockFor {
  const factory _CodeBlockFor(
      {final String code,
      final String range,
      final CodeBlockBuild? parentCodeBlock,
      final List<CodeBlockBuild> childFor}) = _$_CodeBlockFor;
  const _CodeBlockFor._() : super._();

  @override
  String get code;
  @override
  String get range;
  @override
  CodeBlockBuild? get parentCodeBlock;
  @override
  List<CodeBlockBuild> get childFor;
  @override
  @JsonKey(ignore: true)
  _$$_CodeBlockForCopyWith<_$_CodeBlockFor> get copyWith =>
      throw _privateConstructorUsedError;
}
