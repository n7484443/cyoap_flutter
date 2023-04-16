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
  $Res call({List<CodeBlockBuild> codeBlocks});
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
  }) {
    return _then(_value.copyWith(
      codeBlocks: null == codeBlocks
          ? _value.codeBlocks
          : codeBlocks // ignore: cast_nullable_to_non_nullable
              as List<CodeBlockBuild>,
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
  $Res call({List<CodeBlockBuild> codeBlocks});
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
  }) {
    return _then(_$_CodeBlockSet(
      codeBlocks: null == codeBlocks
          ? _value.codeBlocks
          : codeBlocks // ignore: cast_nullable_to_non_nullable
              as List<CodeBlockBuild>,
    ));
  }
}

/// @nodoc

class _$_CodeBlockSet extends _CodeBlockSet {
  _$_CodeBlockSet({this.codeBlocks = const []}) : super._();

  @override
  @JsonKey()
  final List<CodeBlockBuild> codeBlocks;

  @override
  String toString() {
    return 'CodeBlockSet(codeBlocks: $codeBlocks)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CodeBlockSetCopyWith<_$_CodeBlockSet> get copyWith =>
      __$$_CodeBlockSetCopyWithImpl<_$_CodeBlockSet>(this, _$identity);
}

abstract class _CodeBlockSet extends CodeBlockSet {
  factory _CodeBlockSet({final List<CodeBlockBuild> codeBlocks}) =
      _$_CodeBlockSet;
  _CodeBlockSet._() : super._();

  @override
  List<CodeBlockBuild> get codeBlocks;
  @override
  @JsonKey(ignore: true)
  _$$_CodeBlockSetCopyWith<_$_CodeBlockSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CodeBlock {
  String get code => throw _privateConstructorUsedError;
  set code(String value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CodeBlockCopyWith<CodeBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CodeBlockCopyWith<$Res> {
  factory $CodeBlockCopyWith(CodeBlock value, $Res Function(CodeBlock) then) =
      _$CodeBlockCopyWithImpl<$Res, CodeBlock>;
  @useResult
  $Res call({String code});
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
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
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
  $Res call({String code});
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
  }) {
    return _then(_$_CodeBlock(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_CodeBlock extends _CodeBlock {
  _$_CodeBlock({this.code = ''}) : super._();

  @override
  @JsonKey()
  String code;

  @override
  String toString() {
    return 'CodeBlock(code: $code)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CodeBlockCopyWith<_$_CodeBlock> get copyWith =>
      __$$_CodeBlockCopyWithImpl<_$_CodeBlock>(this, _$identity);
}

abstract class _CodeBlock extends CodeBlock {
  factory _CodeBlock({String code}) = _$_CodeBlock;
  _CodeBlock._() : super._();

  @override
  String get code;
  set code(String value);
  @override
  @JsonKey(ignore: true)
  _$$_CodeBlockCopyWith<_$_CodeBlock> get copyWith =>
      throw _privateConstructorUsedError;
}
