// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DeviceProfilesTable extends DeviceProfiles
    with TableInfo<$DeviceProfilesTable, DeviceProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarColorMeta =
      const VerificationMeta('avatarColor');
  @override
  late final GeneratedColumn<String> avatarColor = GeneratedColumn<String>(
      'avatar_color', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 7, maxTextLength: 7),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, avatarColor, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<DeviceProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_color')) {
      context.handle(
          _avatarColorMeta,
          avatarColor.isAcceptableOrUnknown(
              data['avatar_color']!, _avatarColorMeta));
    } else if (isInserting) {
      context.missing(_avatarColorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatarColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_color'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DeviceProfilesTable createAlias(String alias) {
    return $DeviceProfilesTable(attachedDatabase, alias);
  }
}

class DeviceProfile extends DataClass implements Insertable<DeviceProfile> {
  final String id;
  final String name;
  final String avatarColor;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DeviceProfile(
      {required this.id,
      required this.name,
      required this.avatarColor,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['avatar_color'] = Variable<String>(avatarColor);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DeviceProfilesCompanion toCompanion(bool nullToAbsent) {
    return DeviceProfilesCompanion(
      id: Value(id),
      name: Value(name),
      avatarColor: Value(avatarColor),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DeviceProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceProfile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarColor: serializer.fromJson<String>(json['avatarColor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatarColor': serializer.toJson<String>(avatarColor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DeviceProfile copyWith(
          {String? id,
          String? name,
          String? avatarColor,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DeviceProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarColor: avatarColor ?? this.avatarColor,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DeviceProfile copyWithCompanion(DeviceProfilesCompanion data) {
    return DeviceProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarColor:
          data.avatarColor.present ? data.avatarColor.value : this.avatarColor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarColor: $avatarColor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, avatarColor, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarColor == this.avatarColor &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DeviceProfilesCompanion extends UpdateCompanion<DeviceProfile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> avatarColor;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DeviceProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarColor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceProfilesCompanion.insert({
    required String id,
    required String name,
    required String avatarColor,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        avatarColor = Value(avatarColor);
  static Insertable<DeviceProfile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatarColor,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarColor != null) 'avatar_color': avatarColor,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? avatarColor,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DeviceProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarColor: avatarColor ?? this.avatarColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarColor.present) {
      map['avatar_color'] = Variable<String>(avatarColor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarColor: $avatarColor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JourneysTable extends Journeys with TableInfo<$JourneysTable, Journey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JourneysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hostIdMeta = const VerificationMeta('hostId');
  @override
  late final GeneratedColumn<String> hostId = GeneratedColumn<String>(
      'host_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passCodeMeta =
      const VerificationMeta('passCode');
  @override
  late final GeneratedColumn<String> passCode = GeneratedColumn<String>(
      'pass_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _sourceNameMeta =
      const VerificationMeta('sourceName');
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
      'source_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceLatMeta =
      const VerificationMeta('sourceLat');
  @override
  late final GeneratedColumn<double> sourceLat = GeneratedColumn<double>(
      'source_lat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _sourceLngMeta =
      const VerificationMeta('sourceLng');
  @override
  late final GeneratedColumn<double> sourceLng = GeneratedColumn<double>(
      'source_lng', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _destinationNameMeta =
      const VerificationMeta('destinationName');
  @override
  late final GeneratedColumn<String> destinationName = GeneratedColumn<String>(
      'destination_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _destinationLatMeta =
      const VerificationMeta('destinationLat');
  @override
  late final GeneratedColumn<double> destinationLat = GeneratedColumn<double>(
      'destination_lat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _destinationLngMeta =
      const VerificationMeta('destinationLng');
  @override
  late final GeneratedColumn<double> destinationLng = GeneratedColumn<double>(
      'destination_lng', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
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
        destinationLng
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journeys';
  @override
  VerificationContext validateIntegrity(Insertable<Journey> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('host_id')) {
      context.handle(_hostIdMeta,
          hostId.isAcceptableOrUnknown(data['host_id']!, _hostIdMeta));
    } else if (isInserting) {
      context.missing(_hostIdMeta);
    }
    if (data.containsKey('pass_code')) {
      context.handle(_passCodeMeta,
          passCode.isAcceptableOrUnknown(data['pass_code']!, _passCodeMeta));
    } else if (isInserting) {
      context.missing(_passCodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('source_name')) {
      context.handle(
          _sourceNameMeta,
          sourceName.isAcceptableOrUnknown(
              data['source_name']!, _sourceNameMeta));
    }
    if (data.containsKey('source_lat')) {
      context.handle(_sourceLatMeta,
          sourceLat.isAcceptableOrUnknown(data['source_lat']!, _sourceLatMeta));
    }
    if (data.containsKey('source_lng')) {
      context.handle(_sourceLngMeta,
          sourceLng.isAcceptableOrUnknown(data['source_lng']!, _sourceLngMeta));
    }
    if (data.containsKey('destination_name')) {
      context.handle(
          _destinationNameMeta,
          destinationName.isAcceptableOrUnknown(
              data['destination_name']!, _destinationNameMeta));
    }
    if (data.containsKey('destination_lat')) {
      context.handle(
          _destinationLatMeta,
          destinationLat.isAcceptableOrUnknown(
              data['destination_lat']!, _destinationLatMeta));
    }
    if (data.containsKey('destination_lng')) {
      context.handle(
          _destinationLngMeta,
          destinationLng.isAcceptableOrUnknown(
              data['destination_lng']!, _destinationLngMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Journey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Journey(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      hostId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}host_id'])!,
      passCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pass_code'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      sourceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_name']),
      sourceLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}source_lat']),
      sourceLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}source_lng']),
      destinationName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}destination_name']),
      destinationLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}destination_lat']),
      destinationLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}destination_lng']),
    );
  }

  @override
  $JourneysTable createAlias(String alias) {
    return $JourneysTable(attachedDatabase, alias);
  }
}

class Journey extends DataClass implements Insertable<Journey> {
  final String id;
  final String name;
  final String hostId;
  final String passCode;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? sourceName;
  final double? sourceLat;
  final double? sourceLng;
  final String? destinationName;
  final double? destinationLat;
  final double? destinationLng;
  const Journey(
      {required this.id,
      required this.name,
      required this.hostId,
      required this.passCode,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.sourceName,
      this.sourceLat,
      this.sourceLng,
      this.destinationName,
      this.destinationLat,
      this.destinationLng});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['host_id'] = Variable<String>(hostId);
    map['pass_code'] = Variable<String>(passCode);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || sourceName != null) {
      map['source_name'] = Variable<String>(sourceName);
    }
    if (!nullToAbsent || sourceLat != null) {
      map['source_lat'] = Variable<double>(sourceLat);
    }
    if (!nullToAbsent || sourceLng != null) {
      map['source_lng'] = Variable<double>(sourceLng);
    }
    if (!nullToAbsent || destinationName != null) {
      map['destination_name'] = Variable<String>(destinationName);
    }
    if (!nullToAbsent || destinationLat != null) {
      map['destination_lat'] = Variable<double>(destinationLat);
    }
    if (!nullToAbsent || destinationLng != null) {
      map['destination_lng'] = Variable<double>(destinationLng);
    }
    return map;
  }

  JourneysCompanion toCompanion(bool nullToAbsent) {
    return JourneysCompanion(
      id: Value(id),
      name: Value(name),
      hostId: Value(hostId),
      passCode: Value(passCode),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sourceName: sourceName == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceName),
      sourceLat: sourceLat == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLat),
      sourceLng: sourceLng == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLng),
      destinationName: destinationName == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationName),
      destinationLat: destinationLat == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationLat),
      destinationLng: destinationLng == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationLng),
    );
  }

  factory Journey.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Journey(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      hostId: serializer.fromJson<String>(json['hostId']),
      passCode: serializer.fromJson<String>(json['passCode']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sourceName: serializer.fromJson<String?>(json['sourceName']),
      sourceLat: serializer.fromJson<double?>(json['sourceLat']),
      sourceLng: serializer.fromJson<double?>(json['sourceLng']),
      destinationName: serializer.fromJson<String?>(json['destinationName']),
      destinationLat: serializer.fromJson<double?>(json['destinationLat']),
      destinationLng: serializer.fromJson<double?>(json['destinationLng']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'hostId': serializer.toJson<String>(hostId),
      'passCode': serializer.toJson<String>(passCode),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sourceName': serializer.toJson<String?>(sourceName),
      'sourceLat': serializer.toJson<double?>(sourceLat),
      'sourceLng': serializer.toJson<double?>(sourceLng),
      'destinationName': serializer.toJson<String?>(destinationName),
      'destinationLat': serializer.toJson<double?>(destinationLat),
      'destinationLng': serializer.toJson<double?>(destinationLng),
    };
  }

  Journey copyWith(
          {String? id,
          String? name,
          String? hostId,
          String? passCode,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<String?> sourceName = const Value.absent(),
          Value<double?> sourceLat = const Value.absent(),
          Value<double?> sourceLng = const Value.absent(),
          Value<String?> destinationName = const Value.absent(),
          Value<double?> destinationLat = const Value.absent(),
          Value<double?> destinationLng = const Value.absent()}) =>
      Journey(
        id: id ?? this.id,
        name: name ?? this.name,
        hostId: hostId ?? this.hostId,
        passCode: passCode ?? this.passCode,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sourceName: sourceName.present ? sourceName.value : this.sourceName,
        sourceLat: sourceLat.present ? sourceLat.value : this.sourceLat,
        sourceLng: sourceLng.present ? sourceLng.value : this.sourceLng,
        destinationName: destinationName.present
            ? destinationName.value
            : this.destinationName,
        destinationLat:
            destinationLat.present ? destinationLat.value : this.destinationLat,
        destinationLng:
            destinationLng.present ? destinationLng.value : this.destinationLng,
      );
  Journey copyWithCompanion(JourneysCompanion data) {
    return Journey(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      hostId: data.hostId.present ? data.hostId.value : this.hostId,
      passCode: data.passCode.present ? data.passCode.value : this.passCode,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sourceName:
          data.sourceName.present ? data.sourceName.value : this.sourceName,
      sourceLat: data.sourceLat.present ? data.sourceLat.value : this.sourceLat,
      sourceLng: data.sourceLng.present ? data.sourceLng.value : this.sourceLng,
      destinationName: data.destinationName.present
          ? data.destinationName.value
          : this.destinationName,
      destinationLat: data.destinationLat.present
          ? data.destinationLat.value
          : this.destinationLat,
      destinationLng: data.destinationLng.present
          ? data.destinationLng.value
          : this.destinationLng,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Journey(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hostId: $hostId, ')
          ..write('passCode: $passCode, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceLat: $sourceLat, ')
          ..write('sourceLng: $sourceLng, ')
          ..write('destinationName: $destinationName, ')
          ..write('destinationLat: $destinationLat, ')
          ..write('destinationLng: $destinationLng')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Journey &&
          other.id == this.id &&
          other.name == this.name &&
          other.hostId == this.hostId &&
          other.passCode == this.passCode &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sourceName == this.sourceName &&
          other.sourceLat == this.sourceLat &&
          other.sourceLng == this.sourceLng &&
          other.destinationName == this.destinationName &&
          other.destinationLat == this.destinationLat &&
          other.destinationLng == this.destinationLng);
}

class JourneysCompanion extends UpdateCompanion<Journey> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> hostId;
  final Value<String> passCode;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> sourceName;
  final Value<double?> sourceLat;
  final Value<double?> sourceLng;
  final Value<String?> destinationName;
  final Value<double?> destinationLat;
  final Value<double?> destinationLng;
  final Value<int> rowid;
  const JourneysCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hostId = const Value.absent(),
    this.passCode = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.sourceLat = const Value.absent(),
    this.sourceLng = const Value.absent(),
    this.destinationName = const Value.absent(),
    this.destinationLat = const Value.absent(),
    this.destinationLng = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JourneysCompanion.insert({
    required String id,
    required String name,
    required String hostId,
    required String passCode,
    required String status,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.sourceLat = const Value.absent(),
    this.sourceLng = const Value.absent(),
    this.destinationName = const Value.absent(),
    this.destinationLat = const Value.absent(),
    this.destinationLng = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        hostId = Value(hostId),
        passCode = Value(passCode),
        status = Value(status);
  static Insertable<Journey> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? hostId,
    Expression<String>? passCode,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? sourceName,
    Expression<double>? sourceLat,
    Expression<double>? sourceLng,
    Expression<String>? destinationName,
    Expression<double>? destinationLat,
    Expression<double>? destinationLng,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hostId != null) 'host_id': hostId,
      if (passCode != null) 'pass_code': passCode,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sourceName != null) 'source_name': sourceName,
      if (sourceLat != null) 'source_lat': sourceLat,
      if (sourceLng != null) 'source_lng': sourceLng,
      if (destinationName != null) 'destination_name': destinationName,
      if (destinationLat != null) 'destination_lat': destinationLat,
      if (destinationLng != null) 'destination_lng': destinationLng,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JourneysCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? hostId,
      Value<String>? passCode,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? sourceName,
      Value<double?>? sourceLat,
      Value<double?>? sourceLng,
      Value<String?>? destinationName,
      Value<double?>? destinationLat,
      Value<double?>? destinationLng,
      Value<int>? rowid}) {
    return JourneysCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hostId: hostId ?? this.hostId,
      passCode: passCode ?? this.passCode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sourceName: sourceName ?? this.sourceName,
      sourceLat: sourceLat ?? this.sourceLat,
      sourceLng: sourceLng ?? this.sourceLng,
      destinationName: destinationName ?? this.destinationName,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLng: destinationLng ?? this.destinationLng,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hostId.present) {
      map['host_id'] = Variable<String>(hostId.value);
    }
    if (passCode.present) {
      map['pass_code'] = Variable<String>(passCode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (sourceLat.present) {
      map['source_lat'] = Variable<double>(sourceLat.value);
    }
    if (sourceLng.present) {
      map['source_lng'] = Variable<double>(sourceLng.value);
    }
    if (destinationName.present) {
      map['destination_name'] = Variable<String>(destinationName.value);
    }
    if (destinationLat.present) {
      map['destination_lat'] = Variable<double>(destinationLat.value);
    }
    if (destinationLng.present) {
      map['destination_lng'] = Variable<double>(destinationLng.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JourneysCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hostId: $hostId, ')
          ..write('passCode: $passCode, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceLat: $sourceLat, ')
          ..write('sourceLng: $sourceLng, ')
          ..write('destinationName: $destinationName, ')
          ..write('destinationLat: $destinationLat, ')
          ..write('destinationLng: $destinationLng, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JourneyMembersTable extends JourneyMembers
    with TableInfo<$JourneyMembersTable, JourneyMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JourneyMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _journeyIdMeta =
      const VerificationMeta('journeyId');
  @override
  late final GeneratedColumn<String> journeyId = GeneratedColumn<String>(
      'journey_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _joinTimeMeta =
      const VerificationMeta('joinTime');
  @override
  late final GeneratedColumn<DateTime> joinTime = GeneratedColumn<DateTime>(
      'join_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, journeyId, deviceId, role, joinTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journey_members';
  @override
  VerificationContext validateIntegrity(Insertable<JourneyMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('journey_id')) {
      context.handle(_journeyIdMeta,
          journeyId.isAcceptableOrUnknown(data['journey_id']!, _journeyIdMeta));
    } else if (isInserting) {
      context.missing(_journeyIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('join_time')) {
      context.handle(_joinTimeMeta,
          joinTime.isAcceptableOrUnknown(data['join_time']!, _joinTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JourneyMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JourneyMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      journeyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}journey_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      joinTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}join_time'])!,
    );
  }

  @override
  $JourneyMembersTable createAlias(String alias) {
    return $JourneyMembersTable(attachedDatabase, alias);
  }
}

class JourneyMember extends DataClass implements Insertable<JourneyMember> {
  final String id;
  final String journeyId;
  final String deviceId;
  final String role;
  final DateTime joinTime;
  const JourneyMember(
      {required this.id,
      required this.journeyId,
      required this.deviceId,
      required this.role,
      required this.joinTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['journey_id'] = Variable<String>(journeyId);
    map['device_id'] = Variable<String>(deviceId);
    map['role'] = Variable<String>(role);
    map['join_time'] = Variable<DateTime>(joinTime);
    return map;
  }

  JourneyMembersCompanion toCompanion(bool nullToAbsent) {
    return JourneyMembersCompanion(
      id: Value(id),
      journeyId: Value(journeyId),
      deviceId: Value(deviceId),
      role: Value(role),
      joinTime: Value(joinTime),
    );
  }

  factory JourneyMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JourneyMember(
      id: serializer.fromJson<String>(json['id']),
      journeyId: serializer.fromJson<String>(json['journeyId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      role: serializer.fromJson<String>(json['role']),
      joinTime: serializer.fromJson<DateTime>(json['joinTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'journeyId': serializer.toJson<String>(journeyId),
      'deviceId': serializer.toJson<String>(deviceId),
      'role': serializer.toJson<String>(role),
      'joinTime': serializer.toJson<DateTime>(joinTime),
    };
  }

  JourneyMember copyWith(
          {String? id,
          String? journeyId,
          String? deviceId,
          String? role,
          DateTime? joinTime}) =>
      JourneyMember(
        id: id ?? this.id,
        journeyId: journeyId ?? this.journeyId,
        deviceId: deviceId ?? this.deviceId,
        role: role ?? this.role,
        joinTime: joinTime ?? this.joinTime,
      );
  JourneyMember copyWithCompanion(JourneyMembersCompanion data) {
    return JourneyMember(
      id: data.id.present ? data.id.value : this.id,
      journeyId: data.journeyId.present ? data.journeyId.value : this.journeyId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      role: data.role.present ? data.role.value : this.role,
      joinTime: data.joinTime.present ? data.joinTime.value : this.joinTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JourneyMember(')
          ..write('id: $id, ')
          ..write('journeyId: $journeyId, ')
          ..write('deviceId: $deviceId, ')
          ..write('role: $role, ')
          ..write('joinTime: $joinTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, journeyId, deviceId, role, joinTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JourneyMember &&
          other.id == this.id &&
          other.journeyId == this.journeyId &&
          other.deviceId == this.deviceId &&
          other.role == this.role &&
          other.joinTime == this.joinTime);
}

class JourneyMembersCompanion extends UpdateCompanion<JourneyMember> {
  final Value<String> id;
  final Value<String> journeyId;
  final Value<String> deviceId;
  final Value<String> role;
  final Value<DateTime> joinTime;
  final Value<int> rowid;
  const JourneyMembersCompanion({
    this.id = const Value.absent(),
    this.journeyId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.role = const Value.absent(),
    this.joinTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JourneyMembersCompanion.insert({
    required String id,
    required String journeyId,
    required String deviceId,
    required String role,
    this.joinTime = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        journeyId = Value(journeyId),
        deviceId = Value(deviceId),
        role = Value(role);
  static Insertable<JourneyMember> custom({
    Expression<String>? id,
    Expression<String>? journeyId,
    Expression<String>? deviceId,
    Expression<String>? role,
    Expression<DateTime>? joinTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journeyId != null) 'journey_id': journeyId,
      if (deviceId != null) 'device_id': deviceId,
      if (role != null) 'role': role,
      if (joinTime != null) 'join_time': joinTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JourneyMembersCompanion copyWith(
      {Value<String>? id,
      Value<String>? journeyId,
      Value<String>? deviceId,
      Value<String>? role,
      Value<DateTime>? joinTime,
      Value<int>? rowid}) {
    return JourneyMembersCompanion(
      id: id ?? this.id,
      journeyId: journeyId ?? this.journeyId,
      deviceId: deviceId ?? this.deviceId,
      role: role ?? this.role,
      joinTime: joinTime ?? this.joinTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (journeyId.present) {
      map['journey_id'] = Variable<String>(journeyId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (joinTime.present) {
      map['join_time'] = Variable<DateTime>(joinTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JourneyMembersCompanion(')
          ..write('id: $id, ')
          ..write('journeyId: $journeyId, ')
          ..write('deviceId: $deviceId, ')
          ..write('role: $role, ')
          ..write('joinTime: $joinTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberLocationsTable extends MemberLocations
    with TableInfo<$MemberLocationsTable, MemberLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memberIdMeta =
      const VerificationMeta('memberId');
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
      'member_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
      'speed', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _headingMeta =
      const VerificationMeta('heading');
  @override
  late final GeneratedColumn<double> heading = GeneratedColumn<double>(
      'heading', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, memberId, latitude, longitude, speed, heading, timestamp, accuracy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_locations';
  @override
  VerificationContext validateIntegrity(Insertable<MemberLocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(_memberIdMeta,
          memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta));
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
          _speedMeta, speed.isAcceptableOrUnknown(data['speed']!, _speedMeta));
    } else if (isInserting) {
      context.missing(_speedMeta);
    }
    if (data.containsKey('heading')) {
      context.handle(_headingMeta,
          heading.isAcceptableOrUnknown(data['heading']!, _headingMeta));
    } else if (isInserting) {
      context.missing(_headingMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberLocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      memberId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}member_id'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      speed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}speed'])!,
      heading: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}heading'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy'])!,
    );
  }

  @override
  $MemberLocationsTable createAlias(String alias) {
    return $MemberLocationsTable(attachedDatabase, alias);
  }
}

class MemberLocation extends DataClass implements Insertable<MemberLocation> {
  final String id;
  final String memberId;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final DateTime timestamp;
  final double accuracy;
  const MemberLocation(
      {required this.id,
      required this.memberId,
      required this.latitude,
      required this.longitude,
      required this.speed,
      required this.heading,
      required this.timestamp,
      required this.accuracy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['speed'] = Variable<double>(speed);
    map['heading'] = Variable<double>(heading);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['accuracy'] = Variable<double>(accuracy);
    return map;
  }

  MemberLocationsCompanion toCompanion(bool nullToAbsent) {
    return MemberLocationsCompanion(
      id: Value(id),
      memberId: Value(memberId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      speed: Value(speed),
      heading: Value(heading),
      timestamp: Value(timestamp),
      accuracy: Value(accuracy),
    );
  }

  factory MemberLocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberLocation(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      speed: serializer.fromJson<double>(json['speed']),
      heading: serializer.fromJson<double>(json['heading']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'speed': serializer.toJson<double>(speed),
      'heading': serializer.toJson<double>(heading),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'accuracy': serializer.toJson<double>(accuracy),
    };
  }

  MemberLocation copyWith(
          {String? id,
          String? memberId,
          double? latitude,
          double? longitude,
          double? speed,
          double? heading,
          DateTime? timestamp,
          double? accuracy}) =>
      MemberLocation(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        speed: speed ?? this.speed,
        heading: heading ?? this.heading,
        timestamp: timestamp ?? this.timestamp,
        accuracy: accuracy ?? this.accuracy,
      );
  MemberLocation copyWithCompanion(MemberLocationsCompanion data) {
    return MemberLocation(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      speed: data.speed.present ? data.speed.value : this.speed,
      heading: data.heading.present ? data.heading.value : this.heading,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberLocation(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('speed: $speed, ')
          ..write('heading: $heading, ')
          ..write('timestamp: $timestamp, ')
          ..write('accuracy: $accuracy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, memberId, latitude, longitude, speed, heading, timestamp, accuracy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberLocation &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.speed == this.speed &&
          other.heading == this.heading &&
          other.timestamp == this.timestamp &&
          other.accuracy == this.accuracy);
}

class MemberLocationsCompanion extends UpdateCompanion<MemberLocation> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> speed;
  final Value<double> heading;
  final Value<DateTime> timestamp;
  final Value<double> accuracy;
  final Value<int> rowid;
  const MemberLocationsCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.speed = const Value.absent(),
    this.heading = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberLocationsCompanion.insert({
    required String id,
    required String memberId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
    this.timestamp = const Value.absent(),
    required double accuracy,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        memberId = Value(memberId),
        latitude = Value(latitude),
        longitude = Value(longitude),
        speed = Value(speed),
        heading = Value(heading),
        accuracy = Value(accuracy);
  static Insertable<MemberLocation> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? speed,
    Expression<double>? heading,
    Expression<DateTime>? timestamp,
    Expression<double>? accuracy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (speed != null) 'speed': speed,
      if (heading != null) 'heading': heading,
      if (timestamp != null) 'timestamp': timestamp,
      if (accuracy != null) 'accuracy': accuracy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberLocationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? memberId,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<double>? speed,
      Value<double>? heading,
      Value<DateTime>? timestamp,
      Value<double>? accuracy,
      Value<int>? rowid}) {
    return MemberLocationsCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (heading.present) {
      map['heading'] = Variable<double>(heading.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberLocationsCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('speed: $speed, ')
          ..write('heading: $heading, ')
          ..write('timestamp: $timestamp, ')
          ..write('accuracy: $accuracy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckpointsTable extends Checkpoints
    with TableInfo<$CheckpointsTable, Checkpoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckpointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _journeyIdMeta =
      const VerificationMeta('journeyId');
  @override
  late final GeneratedColumn<String> journeyId = GeneratedColumn<String>(
      'journey_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _radiusMeta = const VerificationMeta('radius');
  @override
  late final GeneratedColumn<double> radius = GeneratedColumn<double>(
      'radius', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, journeyId, name, latitude, longitude, radius, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checkpoints';
  @override
  VerificationContext validateIntegrity(Insertable<Checkpoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('journey_id')) {
      context.handle(_journeyIdMeta,
          journeyId.isAcceptableOrUnknown(data['journey_id']!, _journeyIdMeta));
    } else if (isInserting) {
      context.missing(_journeyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('radius')) {
      context.handle(_radiusMeta,
          radius.isAcceptableOrUnknown(data['radius']!, _radiusMeta));
    } else if (isInserting) {
      context.missing(_radiusMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Checkpoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Checkpoint(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      journeyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}journey_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      radius: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}radius'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
    );
  }

  @override
  $CheckpointsTable createAlias(String alias) {
    return $CheckpointsTable(attachedDatabase, alias);
  }
}

class Checkpoint extends DataClass implements Insertable<Checkpoint> {
  final String id;
  final String journeyId;
  final String name;
  final double latitude;
  final double longitude;
  final double radius;
  final String type;
  const Checkpoint(
      {required this.id,
      required this.journeyId,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.radius,
      required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['journey_id'] = Variable<String>(journeyId);
    map['name'] = Variable<String>(name);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['radius'] = Variable<double>(radius);
    map['type'] = Variable<String>(type);
    return map;
  }

  CheckpointsCompanion toCompanion(bool nullToAbsent) {
    return CheckpointsCompanion(
      id: Value(id),
      journeyId: Value(journeyId),
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      radius: Value(radius),
      type: Value(type),
    );
  }

  factory Checkpoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Checkpoint(
      id: serializer.fromJson<String>(json['id']),
      journeyId: serializer.fromJson<String>(json['journeyId']),
      name: serializer.fromJson<String>(json['name']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      radius: serializer.fromJson<double>(json['radius']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'journeyId': serializer.toJson<String>(journeyId),
      'name': serializer.toJson<String>(name),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'radius': serializer.toJson<double>(radius),
      'type': serializer.toJson<String>(type),
    };
  }

  Checkpoint copyWith(
          {String? id,
          String? journeyId,
          String? name,
          double? latitude,
          double? longitude,
          double? radius,
          String? type}) =>
      Checkpoint(
        id: id ?? this.id,
        journeyId: journeyId ?? this.journeyId,
        name: name ?? this.name,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        radius: radius ?? this.radius,
        type: type ?? this.type,
      );
  Checkpoint copyWithCompanion(CheckpointsCompanion data) {
    return Checkpoint(
      id: data.id.present ? data.id.value : this.id,
      journeyId: data.journeyId.present ? data.journeyId.value : this.journeyId,
      name: data.name.present ? data.name.value : this.name,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      radius: data.radius.present ? data.radius.value : this.radius,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Checkpoint(')
          ..write('id: $id, ')
          ..write('journeyId: $journeyId, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radius: $radius, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, journeyId, name, latitude, longitude, radius, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Checkpoint &&
          other.id == this.id &&
          other.journeyId == this.journeyId &&
          other.name == this.name &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.radius == this.radius &&
          other.type == this.type);
}

class CheckpointsCompanion extends UpdateCompanion<Checkpoint> {
  final Value<String> id;
  final Value<String> journeyId;
  final Value<String> name;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> radius;
  final Value<String> type;
  final Value<int> rowid;
  const CheckpointsCompanion({
    this.id = const Value.absent(),
    this.journeyId = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.radius = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckpointsCompanion.insert({
    required String id,
    required String journeyId,
    required String name,
    required double latitude,
    required double longitude,
    required double radius,
    required String type,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        journeyId = Value(journeyId),
        name = Value(name),
        latitude = Value(latitude),
        longitude = Value(longitude),
        radius = Value(radius),
        type = Value(type);
  static Insertable<Checkpoint> custom({
    Expression<String>? id,
    Expression<String>? journeyId,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? radius,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journeyId != null) 'journey_id': journeyId,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (radius != null) 'radius': radius,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckpointsCompanion copyWith(
      {Value<String>? id,
      Value<String>? journeyId,
      Value<String>? name,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<double>? radius,
      Value<String>? type,
      Value<int>? rowid}) {
    return CheckpointsCompanion(
      id: id ?? this.id,
      journeyId: journeyId ?? this.journeyId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (journeyId.present) {
      map['journey_id'] = Variable<String>(journeyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (radius.present) {
      map['radius'] = Variable<double>(radius.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckpointsCompanion(')
          ..write('id: $id, ')
          ..write('journeyId: $journeyId, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radius: $radius, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckpointArrivalsTable extends CheckpointArrivals
    with TableInfo<$CheckpointArrivalsTable, CheckpointArrival> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckpointArrivalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _checkpointIdMeta =
      const VerificationMeta('checkpointId');
  @override
  late final GeneratedColumn<String> checkpointId = GeneratedColumn<String>(
      'checkpoint_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memberIdMeta =
      const VerificationMeta('memberId');
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
      'member_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _arrivalTimeMeta =
      const VerificationMeta('arrivalTime');
  @override
  late final GeneratedColumn<DateTime> arrivalTime = GeneratedColumn<DateTime>(
      'arrival_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, checkpointId, memberId, arrivalTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checkpoint_arrivals';
  @override
  VerificationContext validateIntegrity(Insertable<CheckpointArrival> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('checkpoint_id')) {
      context.handle(
          _checkpointIdMeta,
          checkpointId.isAcceptableOrUnknown(
              data['checkpoint_id']!, _checkpointIdMeta));
    } else if (isInserting) {
      context.missing(_checkpointIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(_memberIdMeta,
          memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta));
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('arrival_time')) {
      context.handle(
          _arrivalTimeMeta,
          arrivalTime.isAcceptableOrUnknown(
              data['arrival_time']!, _arrivalTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CheckpointArrival map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckpointArrival(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      checkpointId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checkpoint_id'])!,
      memberId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}member_id'])!,
      arrivalTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}arrival_time'])!,
    );
  }

  @override
  $CheckpointArrivalsTable createAlias(String alias) {
    return $CheckpointArrivalsTable(attachedDatabase, alias);
  }
}

class CheckpointArrival extends DataClass
    implements Insertable<CheckpointArrival> {
  final String id;
  final String checkpointId;
  final String memberId;
  final DateTime arrivalTime;
  const CheckpointArrival(
      {required this.id,
      required this.checkpointId,
      required this.memberId,
      required this.arrivalTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['checkpoint_id'] = Variable<String>(checkpointId);
    map['member_id'] = Variable<String>(memberId);
    map['arrival_time'] = Variable<DateTime>(arrivalTime);
    return map;
  }

  CheckpointArrivalsCompanion toCompanion(bool nullToAbsent) {
    return CheckpointArrivalsCompanion(
      id: Value(id),
      checkpointId: Value(checkpointId),
      memberId: Value(memberId),
      arrivalTime: Value(arrivalTime),
    );
  }

  factory CheckpointArrival.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckpointArrival(
      id: serializer.fromJson<String>(json['id']),
      checkpointId: serializer.fromJson<String>(json['checkpointId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      arrivalTime: serializer.fromJson<DateTime>(json['arrivalTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checkpointId': serializer.toJson<String>(checkpointId),
      'memberId': serializer.toJson<String>(memberId),
      'arrivalTime': serializer.toJson<DateTime>(arrivalTime),
    };
  }

  CheckpointArrival copyWith(
          {String? id,
          String? checkpointId,
          String? memberId,
          DateTime? arrivalTime}) =>
      CheckpointArrival(
        id: id ?? this.id,
        checkpointId: checkpointId ?? this.checkpointId,
        memberId: memberId ?? this.memberId,
        arrivalTime: arrivalTime ?? this.arrivalTime,
      );
  CheckpointArrival copyWithCompanion(CheckpointArrivalsCompanion data) {
    return CheckpointArrival(
      id: data.id.present ? data.id.value : this.id,
      checkpointId: data.checkpointId.present
          ? data.checkpointId.value
          : this.checkpointId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      arrivalTime:
          data.arrivalTime.present ? data.arrivalTime.value : this.arrivalTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckpointArrival(')
          ..write('id: $id, ')
          ..write('checkpointId: $checkpointId, ')
          ..write('memberId: $memberId, ')
          ..write('arrivalTime: $arrivalTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, checkpointId, memberId, arrivalTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckpointArrival &&
          other.id == this.id &&
          other.checkpointId == this.checkpointId &&
          other.memberId == this.memberId &&
          other.arrivalTime == this.arrivalTime);
}

class CheckpointArrivalsCompanion extends UpdateCompanion<CheckpointArrival> {
  final Value<String> id;
  final Value<String> checkpointId;
  final Value<String> memberId;
  final Value<DateTime> arrivalTime;
  final Value<int> rowid;
  const CheckpointArrivalsCompanion({
    this.id = const Value.absent(),
    this.checkpointId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.arrivalTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckpointArrivalsCompanion.insert({
    required String id,
    required String checkpointId,
    required String memberId,
    this.arrivalTime = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        checkpointId = Value(checkpointId),
        memberId = Value(memberId);
  static Insertable<CheckpointArrival> custom({
    Expression<String>? id,
    Expression<String>? checkpointId,
    Expression<String>? memberId,
    Expression<DateTime>? arrivalTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checkpointId != null) 'checkpoint_id': checkpointId,
      if (memberId != null) 'member_id': memberId,
      if (arrivalTime != null) 'arrival_time': arrivalTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckpointArrivalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? checkpointId,
      Value<String>? memberId,
      Value<DateTime>? arrivalTime,
      Value<int>? rowid}) {
    return CheckpointArrivalsCompanion(
      id: id ?? this.id,
      checkpointId: checkpointId ?? this.checkpointId,
      memberId: memberId ?? this.memberId,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checkpointId.present) {
      map['checkpoint_id'] = Variable<String>(checkpointId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (arrivalTime.present) {
      map['arrival_time'] = Variable<DateTime>(arrivalTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckpointArrivalsCompanion(')
          ..write('id: $id, ')
          ..write('checkpointId: $checkpointId, ')
          ..write('memberId: $memberId, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DeviceProfilesTable deviceProfiles = $DeviceProfilesTable(this);
  late final $JourneysTable journeys = $JourneysTable(this);
  late final $JourneyMembersTable journeyMembers = $JourneyMembersTable(this);
  late final $MemberLocationsTable memberLocations =
      $MemberLocationsTable(this);
  late final $CheckpointsTable checkpoints = $CheckpointsTable(this);
  late final $CheckpointArrivalsTable checkpointArrivals =
      $CheckpointArrivalsTable(this);
  late final DeviceProfileDao deviceProfileDao =
      DeviceProfileDao(this as AppDatabase);
  late final JourneyDao journeyDao = JourneyDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        deviceProfiles,
        journeys,
        journeyMembers,
        memberLocations,
        checkpoints,
        checkpointArrivals
      ];
}

typedef $$DeviceProfilesTableCreateCompanionBuilder = DeviceProfilesCompanion
    Function({
  required String id,
  required String name,
  required String avatarColor,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$DeviceProfilesTableUpdateCompanionBuilder = DeviceProfilesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> avatarColor,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DeviceProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DeviceProfilesTable,
    DeviceProfile,
    $$DeviceProfilesTableFilterComposer,
    $$DeviceProfilesTableOrderingComposer,
    $$DeviceProfilesTableCreateCompanionBuilder,
    $$DeviceProfilesTableUpdateCompanionBuilder> {
  $$DeviceProfilesTableTableManager(
      _$AppDatabase db, $DeviceProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DeviceProfilesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DeviceProfilesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> avatarColor = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DeviceProfilesCompanion(
            id: id,
            name: name,
            avatarColor: avatarColor,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String avatarColor,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DeviceProfilesCompanion.insert(
            id: id,
            name: name,
            avatarColor: avatarColor,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$DeviceProfilesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DeviceProfilesTable> {
  $$DeviceProfilesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get avatarColor => $state.composableBuilder(
      column: $state.table.avatarColor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$DeviceProfilesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DeviceProfilesTable> {
  $$DeviceProfilesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get avatarColor => $state.composableBuilder(
      column: $state.table.avatarColor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$JourneysTableCreateCompanionBuilder = JourneysCompanion Function({
  required String id,
  required String name,
  required String hostId,
  required String passCode,
  required String status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> sourceName,
  Value<double?> sourceLat,
  Value<double?> sourceLng,
  Value<String?> destinationName,
  Value<double?> destinationLat,
  Value<double?> destinationLng,
  Value<int> rowid,
});
typedef $$JourneysTableUpdateCompanionBuilder = JourneysCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> hostId,
  Value<String> passCode,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> sourceName,
  Value<double?> sourceLat,
  Value<double?> sourceLng,
  Value<String?> destinationName,
  Value<double?> destinationLat,
  Value<double?> destinationLng,
  Value<int> rowid,
});

class $$JourneysTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JourneysTable,
    Journey,
    $$JourneysTableFilterComposer,
    $$JourneysTableOrderingComposer,
    $$JourneysTableCreateCompanionBuilder,
    $$JourneysTableUpdateCompanionBuilder> {
  $$JourneysTableTableManager(_$AppDatabase db, $JourneysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$JourneysTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$JourneysTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> hostId = const Value.absent(),
            Value<String> passCode = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> sourceName = const Value.absent(),
            Value<double?> sourceLat = const Value.absent(),
            Value<double?> sourceLng = const Value.absent(),
            Value<String?> destinationName = const Value.absent(),
            Value<double?> destinationLat = const Value.absent(),
            Value<double?> destinationLng = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JourneysCompanion(
            id: id,
            name: name,
            hostId: hostId,
            passCode: passCode,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sourceName: sourceName,
            sourceLat: sourceLat,
            sourceLng: sourceLng,
            destinationName: destinationName,
            destinationLat: destinationLat,
            destinationLng: destinationLng,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String hostId,
            required String passCode,
            required String status,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> sourceName = const Value.absent(),
            Value<double?> sourceLat = const Value.absent(),
            Value<double?> sourceLng = const Value.absent(),
            Value<String?> destinationName = const Value.absent(),
            Value<double?> destinationLat = const Value.absent(),
            Value<double?> destinationLng = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JourneysCompanion.insert(
            id: id,
            name: name,
            hostId: hostId,
            passCode: passCode,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sourceName: sourceName,
            sourceLat: sourceLat,
            sourceLng: sourceLng,
            destinationName: destinationName,
            destinationLat: destinationLat,
            destinationLng: destinationLng,
            rowid: rowid,
          ),
        ));
}

class $$JourneysTableFilterComposer
    extends FilterComposer<_$AppDatabase, $JourneysTable> {
  $$JourneysTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get hostId => $state.composableBuilder(
      column: $state.table.hostId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get passCode => $state.composableBuilder(
      column: $state.table.passCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sourceName => $state.composableBuilder(
      column: $state.table.sourceName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get sourceLat => $state.composableBuilder(
      column: $state.table.sourceLat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get sourceLng => $state.composableBuilder(
      column: $state.table.sourceLng,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get destinationName => $state.composableBuilder(
      column: $state.table.destinationName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get destinationLat => $state.composableBuilder(
      column: $state.table.destinationLat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get destinationLng => $state.composableBuilder(
      column: $state.table.destinationLng,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$JourneysTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $JourneysTable> {
  $$JourneysTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get hostId => $state.composableBuilder(
      column: $state.table.hostId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get passCode => $state.composableBuilder(
      column: $state.table.passCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sourceName => $state.composableBuilder(
      column: $state.table.sourceName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get sourceLat => $state.composableBuilder(
      column: $state.table.sourceLat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get sourceLng => $state.composableBuilder(
      column: $state.table.sourceLng,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get destinationName => $state.composableBuilder(
      column: $state.table.destinationName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get destinationLat => $state.composableBuilder(
      column: $state.table.destinationLat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get destinationLng => $state.composableBuilder(
      column: $state.table.destinationLng,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$JourneyMembersTableCreateCompanionBuilder = JourneyMembersCompanion
    Function({
  required String id,
  required String journeyId,
  required String deviceId,
  required String role,
  Value<DateTime> joinTime,
  Value<int> rowid,
});
typedef $$JourneyMembersTableUpdateCompanionBuilder = JourneyMembersCompanion
    Function({
  Value<String> id,
  Value<String> journeyId,
  Value<String> deviceId,
  Value<String> role,
  Value<DateTime> joinTime,
  Value<int> rowid,
});

class $$JourneyMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JourneyMembersTable,
    JourneyMember,
    $$JourneyMembersTableFilterComposer,
    $$JourneyMembersTableOrderingComposer,
    $$JourneyMembersTableCreateCompanionBuilder,
    $$JourneyMembersTableUpdateCompanionBuilder> {
  $$JourneyMembersTableTableManager(
      _$AppDatabase db, $JourneyMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$JourneyMembersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$JourneyMembersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> journeyId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<DateTime> joinTime = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JourneyMembersCompanion(
            id: id,
            journeyId: journeyId,
            deviceId: deviceId,
            role: role,
            joinTime: joinTime,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String journeyId,
            required String deviceId,
            required String role,
            Value<DateTime> joinTime = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JourneyMembersCompanion.insert(
            id: id,
            journeyId: journeyId,
            deviceId: deviceId,
            role: role,
            joinTime: joinTime,
            rowid: rowid,
          ),
        ));
}

class $$JourneyMembersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $JourneyMembersTable> {
  $$JourneyMembersTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get journeyId => $state.composableBuilder(
      column: $state.table.journeyId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deviceId => $state.composableBuilder(
      column: $state.table.deviceId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get role => $state.composableBuilder(
      column: $state.table.role,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get joinTime => $state.composableBuilder(
      column: $state.table.joinTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$JourneyMembersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $JourneyMembersTable> {
  $$JourneyMembersTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get journeyId => $state.composableBuilder(
      column: $state.table.journeyId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deviceId => $state.composableBuilder(
      column: $state.table.deviceId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get role => $state.composableBuilder(
      column: $state.table.role,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get joinTime => $state.composableBuilder(
      column: $state.table.joinTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$MemberLocationsTableCreateCompanionBuilder = MemberLocationsCompanion
    Function({
  required String id,
  required String memberId,
  required double latitude,
  required double longitude,
  required double speed,
  required double heading,
  Value<DateTime> timestamp,
  required double accuracy,
  Value<int> rowid,
});
typedef $$MemberLocationsTableUpdateCompanionBuilder = MemberLocationsCompanion
    Function({
  Value<String> id,
  Value<String> memberId,
  Value<double> latitude,
  Value<double> longitude,
  Value<double> speed,
  Value<double> heading,
  Value<DateTime> timestamp,
  Value<double> accuracy,
  Value<int> rowid,
});

class $$MemberLocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MemberLocationsTable,
    MemberLocation,
    $$MemberLocationsTableFilterComposer,
    $$MemberLocationsTableOrderingComposer,
    $$MemberLocationsTableCreateCompanionBuilder,
    $$MemberLocationsTableUpdateCompanionBuilder> {
  $$MemberLocationsTableTableManager(
      _$AppDatabase db, $MemberLocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MemberLocationsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MemberLocationsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> memberId = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<double> speed = const Value.absent(),
            Value<double> heading = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<double> accuracy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MemberLocationsCompanion(
            id: id,
            memberId: memberId,
            latitude: latitude,
            longitude: longitude,
            speed: speed,
            heading: heading,
            timestamp: timestamp,
            accuracy: accuracy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String memberId,
            required double latitude,
            required double longitude,
            required double speed,
            required double heading,
            Value<DateTime> timestamp = const Value.absent(),
            required double accuracy,
            Value<int> rowid = const Value.absent(),
          }) =>
              MemberLocationsCompanion.insert(
            id: id,
            memberId: memberId,
            latitude: latitude,
            longitude: longitude,
            speed: speed,
            heading: heading,
            timestamp: timestamp,
            accuracy: accuracy,
            rowid: rowid,
          ),
        ));
}

class $$MemberLocationsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MemberLocationsTable> {
  $$MemberLocationsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get memberId => $state.composableBuilder(
      column: $state.table.memberId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get speed => $state.composableBuilder(
      column: $state.table.speed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get heading => $state.composableBuilder(
      column: $state.table.heading,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get accuracy => $state.composableBuilder(
      column: $state.table.accuracy,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$MemberLocationsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MemberLocationsTable> {
  $$MemberLocationsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get memberId => $state.composableBuilder(
      column: $state.table.memberId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get speed => $state.composableBuilder(
      column: $state.table.speed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get heading => $state.composableBuilder(
      column: $state.table.heading,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get accuracy => $state.composableBuilder(
      column: $state.table.accuracy,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CheckpointsTableCreateCompanionBuilder = CheckpointsCompanion
    Function({
  required String id,
  required String journeyId,
  required String name,
  required double latitude,
  required double longitude,
  required double radius,
  required String type,
  Value<int> rowid,
});
typedef $$CheckpointsTableUpdateCompanionBuilder = CheckpointsCompanion
    Function({
  Value<String> id,
  Value<String> journeyId,
  Value<String> name,
  Value<double> latitude,
  Value<double> longitude,
  Value<double> radius,
  Value<String> type,
  Value<int> rowid,
});

class $$CheckpointsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CheckpointsTable,
    Checkpoint,
    $$CheckpointsTableFilterComposer,
    $$CheckpointsTableOrderingComposer,
    $$CheckpointsTableCreateCompanionBuilder,
    $$CheckpointsTableUpdateCompanionBuilder> {
  $$CheckpointsTableTableManager(_$AppDatabase db, $CheckpointsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CheckpointsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CheckpointsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> journeyId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<double> radius = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CheckpointsCompanion(
            id: id,
            journeyId: journeyId,
            name: name,
            latitude: latitude,
            longitude: longitude,
            radius: radius,
            type: type,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String journeyId,
            required String name,
            required double latitude,
            required double longitude,
            required double radius,
            required String type,
            Value<int> rowid = const Value.absent(),
          }) =>
              CheckpointsCompanion.insert(
            id: id,
            journeyId: journeyId,
            name: name,
            latitude: latitude,
            longitude: longitude,
            radius: radius,
            type: type,
            rowid: rowid,
          ),
        ));
}

class $$CheckpointsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CheckpointsTable> {
  $$CheckpointsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get journeyId => $state.composableBuilder(
      column: $state.table.journeyId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get radius => $state.composableBuilder(
      column: $state.table.radius,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CheckpointsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CheckpointsTable> {
  $$CheckpointsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get journeyId => $state.composableBuilder(
      column: $state.table.journeyId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get radius => $state.composableBuilder(
      column: $state.table.radius,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CheckpointArrivalsTableCreateCompanionBuilder
    = CheckpointArrivalsCompanion Function({
  required String id,
  required String checkpointId,
  required String memberId,
  Value<DateTime> arrivalTime,
  Value<int> rowid,
});
typedef $$CheckpointArrivalsTableUpdateCompanionBuilder
    = CheckpointArrivalsCompanion Function({
  Value<String> id,
  Value<String> checkpointId,
  Value<String> memberId,
  Value<DateTime> arrivalTime,
  Value<int> rowid,
});

class $$CheckpointArrivalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CheckpointArrivalsTable,
    CheckpointArrival,
    $$CheckpointArrivalsTableFilterComposer,
    $$CheckpointArrivalsTableOrderingComposer,
    $$CheckpointArrivalsTableCreateCompanionBuilder,
    $$CheckpointArrivalsTableUpdateCompanionBuilder> {
  $$CheckpointArrivalsTableTableManager(
      _$AppDatabase db, $CheckpointArrivalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CheckpointArrivalsTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$CheckpointArrivalsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> checkpointId = const Value.absent(),
            Value<String> memberId = const Value.absent(),
            Value<DateTime> arrivalTime = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CheckpointArrivalsCompanion(
            id: id,
            checkpointId: checkpointId,
            memberId: memberId,
            arrivalTime: arrivalTime,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String checkpointId,
            required String memberId,
            Value<DateTime> arrivalTime = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CheckpointArrivalsCompanion.insert(
            id: id,
            checkpointId: checkpointId,
            memberId: memberId,
            arrivalTime: arrivalTime,
            rowid: rowid,
          ),
        ));
}

class $$CheckpointArrivalsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CheckpointArrivalsTable> {
  $$CheckpointArrivalsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get checkpointId => $state.composableBuilder(
      column: $state.table.checkpointId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get memberId => $state.composableBuilder(
      column: $state.table.memberId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get arrivalTime => $state.composableBuilder(
      column: $state.table.arrivalTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CheckpointArrivalsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CheckpointArrivalsTable> {
  $$CheckpointArrivalsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get checkpointId => $state.composableBuilder(
      column: $state.table.checkpointId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get memberId => $state.composableBuilder(
      column: $state.table.memberId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get arrivalTime => $state.composableBuilder(
      column: $state.table.arrivalTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DeviceProfilesTableTableManager get deviceProfiles =>
      $$DeviceProfilesTableTableManager(_db, _db.deviceProfiles);
  $$JourneysTableTableManager get journeys =>
      $$JourneysTableTableManager(_db, _db.journeys);
  $$JourneyMembersTableTableManager get journeyMembers =>
      $$JourneyMembersTableTableManager(_db, _db.journeyMembers);
  $$MemberLocationsTableTableManager get memberLocations =>
      $$MemberLocationsTableTableManager(_db, _db.memberLocations);
  $$CheckpointsTableTableManager get checkpoints =>
      $$CheckpointsTableTableManager(_db, _db.checkpoints);
  $$CheckpointArrivalsTableTableManager get checkpointArrivals =>
      $$CheckpointArrivalsTableTableManager(_db, _db.checkpointArrivals);
}
