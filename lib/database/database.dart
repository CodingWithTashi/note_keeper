import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Note extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().named('description')();
  IntColumn get priority => integer().nullable()();
  IntColumn get color => integer().nullable()();
  TextColumn get date => text()();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Note])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  //GET ALL THE NOTES FROM DB
  Future<List<NoteData>> getNoteList() async {
    return await select(note).get();
  }

  //INSERT NEW NOTE IN DB
  Future<int> insertNote(NoteCompanion noteCompanion) async {
    return await into(note).insert(noteCompanion);
  }

  //DELETE FROM DATABASE
  Future<int> deleteNote(NoteData noteData) async {
    return await delete(note).delete(noteData);
  }

  // UPDATE NOTES
  Future<bool> updateNote(NoteData noteData) async {
    return await update(note).replace(noteData);
  }
}
