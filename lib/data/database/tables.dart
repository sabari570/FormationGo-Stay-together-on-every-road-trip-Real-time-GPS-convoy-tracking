import 'package:drift/drift.dart';

class DeviceProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatarColor => text().withLength(min: 7, max: 7)(); // #RRGGBB
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Journeys extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get hostId => text()();
  TextColumn get passCode => text()();
  TextColumn get status => text()(); // e.g. "active", "ended"
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get sourceName => text().nullable()();
  RealColumn get sourceLat => real().nullable()();
  RealColumn get sourceLng => real().nullable()();
  TextColumn get destinationName => text().nullable()();
  RealColumn get destinationLat => real().nullable()();
  RealColumn get destinationLng => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class JourneyMembers extends Table {
  TextColumn get id => text()();
  TextColumn get journeyId => text()();
  TextColumn get deviceId => text()();
  TextColumn get role => text()(); // "host" or "member"
  DateTimeColumn get joinTime => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class MemberLocations extends Table {
  TextColumn get id => text()();
  TextColumn get memberId => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get speed => real()();
  RealColumn get heading => real()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  RealColumn get accuracy => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class Checkpoints extends Table {
  TextColumn get id => text()();
  TextColumn get journeyId => text()();
  TextColumn get name => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get radius => real()();
  TextColumn get type => text()(); // e.g. "meetup", "fuel", "rest"

  @override
  Set<Column> get primaryKey => {id};
}

class CheckpointArrivals extends Table {
  TextColumn get id => text()();
  TextColumn get checkpointId => text()();
  TextColumn get memberId => text()();
  DateTimeColumn get arrivalTime => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class RoutePois extends Table {
  TextColumn get id => text()();
  TextColumn get journeyId => text()();
  TextColumn get name => text()();
  TextColumn get category => text()(); // "restaurant", "rest_area", "nature", "fuel"
  TextColumn get tags => text()();     // JSON string: {"cuisine":"vegetarian","rating":4.5}
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get rating => real().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get source => text()(); // "google_places" or "openstreetmap"
  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class ChatMessages extends Table {
  TextColumn get id => text()();
  TextColumn get journeyId => text()();
  TextColumn get role => text()(); // "user" or "assistant"
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
