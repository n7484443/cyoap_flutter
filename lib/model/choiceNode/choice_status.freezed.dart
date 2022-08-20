// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'choice_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ChoiceStatus {
  SelectableStatus get status => throw _privateConstructorUsedError;
  bool get visible => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChoiceStatusCopyWith<ChoiceStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChoiceStatusCopyWith<$Res> {
  factory $ChoiceStatusCopyWith(
          ChoiceStatus value, $Res Function(ChoiceStatus) then) =
      _$ChoiceStatusCopyWithImpl<$Res>;
  $Res call({SelectableStatus status, bool visible});
}

/// @nodoc
class _$ChoiceStatusCopyWithImpl<$Res> implements $ChoiceStatusCopyWith<$Res> {
  _$ChoiceStatusCopyWithImpl(this._value, this._then);

  final ChoiceStatus _value;
  // ignore: unused_field
  final $Res Function(ChoiceStatus) _then;

  @override
  $Res call({
    Object? status = freezed,
    Object? visible = freezed,
  }) {
    return _then(_value.copyWith(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SelectableStatus,
      visible: visible == freezed
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_ChoiceStatusCopyWith<$Res>
    implements $ChoiceStatusCopyWith<$Res> {
  factory _$$_ChoiceStatusCopyWith(
          _$_ChoiceStatus value, $Res Function(_$_ChoiceStatus) then) =
      __$$_ChoiceStatusCopyWithImpl<$Res>;
  @override
  $Res call({SelectableStatus status, bool visible});
}

/// @nodoc
class __$$_ChoiceStatusCopyWithImpl<$Res>
    extends _$ChoiceStatusCopyWithImpl<$Res>
    implements _$$_ChoiceStatusCopyWith<$Res> {
  __$$_ChoiceStatusCopyWithImpl(
      _$_ChoiceStatus _value, $Res Function(_$_ChoiceStatus) _then)
      : super(_value, (v) => _then(v as _$_ChoiceStatus));

  @override
  _$_ChoiceStatus get _value => super._value as _$_ChoiceStatus;

  @override
  $Res call({
    Object? status = freezed,
    Object? visible = freezed,
  }) {
    return _then(_$_ChoiceStatus(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SelectableStatus,
      visible: visible == freezed
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ChoiceStatus extends _ChoiceStatus {
  _$_ChoiceStatus({this.status = SelectableStatus.open, this.visible = true})
      : super._();

  @override
  @JsonKey()
  final SelectableStatus status;
  @override
  @JsonKey()
  final bool visible;

  @override
  String toString() {
    return 'ChoiceStatus(status: $status, visible: $visible)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChoiceStatus &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.visible, visible));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(visible));

  @JsonKey(ignore: true)
  @override
  _$$_ChoiceStatusCopyWith<_$_ChoiceStatus> get copyWith =>
      __$$_ChoiceStatusCopyWithImpl<_$_ChoiceStatus>(this, _$identity);
}

abstract class _ChoiceStatus extends ChoiceStatus {
  factory _ChoiceStatus({final SelectableStatus status, final bool visible}) =
      _$_ChoiceStatus;
  _ChoiceStatus._() : super._();

  @override
  SelectableStatus get status;
  @override
  bool get visible;
  @override
  @JsonKey(ignore: true)
  _$$_ChoiceStatusCopyWith<_$_ChoiceStatus> get copyWith =>
      throw _privateConstructorUsedError;
}
