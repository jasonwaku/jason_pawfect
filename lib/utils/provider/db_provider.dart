

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pawfect/models/users/country_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'pb_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {

      //create country table
          await db.execute('CREATE TABLE Country('
              'id INTEGER PRIMARY KEY,'
              'email TEXT,'
              'firstName TEXT,'
              'lastName TEXT,'
              'avatar TEXT'
              ')');
          //
      //create ...
        });
  }

  // Insert country on database
  createCountry(CountryModel newCountry) async {
    await deleteAllCountries();
    final db = await database;
    final res = await db.insert('Country', newCountry.toJson());

    return res;
  }

  // Delete all countries
  Future<int> deleteAllCountries() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Country');

    return res;
  }

  Future<List<CountryModel>> getAllCountries() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM COUNTRY");

    List<CountryModel> countryList =
    res.isNotEmpty ? res.map((c) => CountryModel.fromJson(c)).toList() : [];

    return countryList;
  }
}