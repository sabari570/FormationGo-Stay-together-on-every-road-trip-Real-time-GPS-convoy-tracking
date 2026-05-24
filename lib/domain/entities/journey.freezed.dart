// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JourneyEntity _$JourneyEntityFromJson(Map<String, dynamic> json) {
  return _JourneyEntity.fromJson(json);
}

/// @nodoc
mixin _$JourneyEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  String get passCode => throw _privateConstructorUsedError;
  JourneyStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get sourceName => throw _privateConstructorUsedError;
  double? get sourceLat => throw _privateConstructorUsedError;
  double? get sourceLng => throw _privateConstructorUsedError;
  String? get destinationName => throw _privateConstructorUsedError;
  double? get destinationLat => throw _privateConstructorUsedError;
  double? get destinationLng => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JourneyEntityCopyWith<JourneyEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JourneyEntityCopyWith<$Res> {
  factory $JourneyEntityCopyWith(
          JourneyEntity value, $Res Function(JourneyEntity) then) =
      _$JourneyEntityCopyWithImpl<$Res, JourneyEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String hostId,
      String passCode,
      JourneyStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      String? sourceName,
      double? sourceLat,
      double? sourceLng,
      String? destinationName,
      double? destinationLat,
      double? destinationLng});
}

/// @nodoc
class _$JourneyEntityCopyWithImpl<$Res, $Val extends JourneyEntity>
    implements $JourneyEntityCopyWith<$Res> {
  _$JourneyEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? hostId = null,
    Object? passCode = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sourceName = freezed,
    Object? sourceLat = freezed,
    Object? sourceLng = freezed,
    Object? destinationName = freezed,
    Object? destinationLat = freezed,
    Object? destinationLng = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      passCode: null == passCode
          ? _value.passCode
          : passCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JourneyStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sourceName: freezed == sourceName
          ? _value.sourceName
          : sourceName // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceLat: freezed == sourceLat
          ? _value.sourceLat
          : sourceLat // ignore: cast_nullable_to_non_nullable
              as double?,
      sourceLng: freezed == sourceLng
          ? _value.sourceLng
          : sourceLng // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationName: freezed == destinationName
          ? _value.destinationName
          : destinationName // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationLat: freezed == destinationLat
          ? _value.destinationLat
          : destinationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationLng: freezed == destinationLng
          ? _value.destinationLng
          : destinationLng // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JourneyEntityImplCopyWith<$Res>
    implements $JourneyEntityCopyWith<$Res> {
  factory _$$JourneyEntityImplCopyWith(
          _$JourneyEntityImpl value, $Res Function(_$JourneyEntityImpl) then) =
      __$$JourneyEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String hostId,
      String passCode,
      JourneyStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      String? sourceName,
      double? sourceLat,
      double? sourceLng,
      String? destinationName,
      double? destinationLat,
      double? destinationLng});
}

/// @nodoc
class __$$JourneyEntityImplCopyWithImpl<$Res>
    extends _$JourneyEntityCopyWithImpl<$Res, _$JourneyEntityImpl>
    implements _$$JourneyEntityImplCopyWith<$Res> {
  __$$JourneyEntityImplCopyWithImpl(
      _$JourneyEntityImpl _value, $Res Function(_$JourneyEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? hostId = null,
    Object? passCode = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sourceName = freezed,
    Object? sourceLat = freezed,
    Object? sourceLng = freezed,
    Object? destinationName = freezed,
    Object? destinationLat = freezed,
    Object? destinationLng = freezed,
  }) {
    return _then(_$JourneyEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      passCode: null == passCode
          ? _value.passCode
          : passCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JourneyStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sourceName: freezed == sourceName
          ? _value.sourceName
          : sourceName // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceLat: freezed == sourceLat
          ? _value.sourceLat
          : sourceLat // ignore: cast_nullable_to_non_nullable
              as double?,
      sourceLng: freezed == sourceLng
          ? _value.sourceLng
          : sourceLng // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationName: freezed == destinationName
          ? _value.destinationName
          : destinationName // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationLat: freezed == destinationLat
          ? _value.destinationLat
          : destinationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationLng: freezed == destinationLng
          ? _value.destinationLng
          : destinationLng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JourneyEntityImpl implements _JourneyEntity {
  const _$JourneyEntityImpl(
      {required this.id,
      required this.name,
      required this.hostId,
      required this.passCode,
      this.status = JourneyStatus.active,
      required this.createdAt,
      required this.updatedAt,
      this.sourceName,
      this.sourceLat,
      this.sourceLng,
      this.destinationName,
      this.destinationLat,
      this.destinationLng});

  factory _$JourneyEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$JourneyEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String hostId;
  @override
  final String passCode;
  @override
  @JsonKey()
  final JourneyStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? sourceName;
  @override
  final double? sourceLat;
  @override
  final double? sourceLng;
  @override
  final String? destinationName;
  @override
  final double? destinationLat;
  @override
  final double? destinationLng;

  @override
  String toString() {
    return 'JourneyEntity(id: $id, name: $name, hostId: $hostId, passCode: $passCode, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, sourceName: $sourceName, sourceLat: $sourceLat, sourceLng: $sourceLng, destinationName: $destinationName, destinationLat: $destinationLat, destinationLng: $destinationLng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JourneyEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.passCode, passCode) ||
                other.passCode == passCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.sourceName, sourceName) ||
                other.sourceName == sourceName) &&
            (identical(other.sourceLat, sourceLat) ||
                other.sourceLat == sourceLat) &&
            (identical(other.sourceLng, sourceLng) ||
                other.sourceLng == sourceLng) &&
            (identical(other.destinationName, destinationName) ||
                other.destinationName == destinationName) &&
            (identical(other.destinationLat, destinationLat) ||
                other.destinationLat == destinationLat) &&
            (identical(other.destinationLng, destinationLng) ||
                other.destinationLng == destinationLng));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      hostId,
      passCode,
      status,
      createdAt,
      updatedAt,
      sourceName,
      sourceLat,
      sourceLng,
      destinationName,
      destinationLat,
      destinationLng);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JourneyEntityImplCopyWith<_$JourneyEntityImpl> get copyWith =>
      __$$JourneyEntityImplCopyWithImpl<_$JourneyEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JourneyEntityImplToJson(
      this,
    );
  }
}

abstract class _JourneyEntity implements JourneyEntity {
  const factory _JourneyEntity(
      {required final String id,
      required final String name,
      required final String hostId,
      required final String passCode,
      final JourneyStatus status,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? sourceName,
      final double? sourceLat,
      final double? sourceLng,
      final String? destinationName,
      final double? destinationLat,
      final double? destinationLng}) = _$JourneyEntityImpl;

  factory _JourneyEntity.fromJson(Map<String, dynamic> json) =
      _$JourneyEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get hostId;
  @override
  String get passCode;
  @override
  JourneyStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get sourceName;
  @override
  double? get sourceLat;
  @override
  double? get sourceLng;
  @override
  String? get destinationName;
  @override
  double? get destinationLat;
  @override
  double? get destinationLng;
  @override
  @JsonKey(ignore: true)
  _$$JourneyEntityImplCopyWith<_$JourneyEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
