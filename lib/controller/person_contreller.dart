import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modules/person.dart';

abstract class TController<T> {
  Future<List<T>> getAll();
  Future<bool> create(T person);
  Future<T> update(T person);
  Future<bool> delete(int id);
}

class DataBase {
  static dynamic database;

  static init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'person_database.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE person(id INTEGER PRIMARY KEY, name TEXT, email TEXT)');
      },
      version: 1,
    );

    return database;
  }
}

class PersonController implements TController<Person> {
  @override
  Future<bool> create(person) async {
    final db = await DataBase.init();

    try {
      await db.insert(
        'person',
        person.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> delete(int id) async {
    final db = await DataBase.init();

    try {
      await db.delete(
        'person',
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List<Person>> getAll() async {
    try {
      final db = await DataBase.init();

      final List<Map<String, dynamic>> maps = await db.query('person');

      return List.generate(maps.length, (i) {
        return Person(
          id: maps[i]['id'],
          name: maps[i]['name'],
          email: maps[i]['email'],
        );
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<Person> update(person) async {
    final db = await DataBase.init();
    try {
      await db.update(
        'person',
        person.toMap(),
        where: 'id = ?',
        whereArgs: [person.id],
      );
      return person;
    } catch (e) {
      print(e);
      return Person(id: 0, name: '', email: '');
    }
  }
}
