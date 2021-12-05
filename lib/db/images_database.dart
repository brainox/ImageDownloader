import 'package:flutter/cupertino.dart';
import 'package:persiting_image/model/image_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ImagesDatabase {
  static final ImagesDatabase instance = ImagesDatabase._init();

  static Database? _database;

  ImagesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('images.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tablesImages (
      ${ImageFields.id} $idType,
      ${ImageFields.urlString} $textType,
      ${ImageFields.imageNumber} $integerType
    )
    ''');
  }

  Future<ImageModel> insert(ImageModel imageModel) async {
    final db = await instance.database;

    final id = await db.insert(tablesImages, imageModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return imageModel.copy(id: id);
  }

  Future<List<ImageModel>> readAllImages() async {
    final db = await instance.database;

    final orderBy = '${ImageFields.imageNumber} DESC';

    final result = await db.query(tablesImages, orderBy: orderBy);
    if (result.isEmpty) {
      print("empty database");
      return [];
    }
    print("Data base is not empty");
    return result.map((json) => ImageModel.fromJson(json)).toList();
  }

  Future<int> countImages() async {
    final db = await instance.database;

    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tablesImages'));
    print('count images: $count');
    return count!;
  }
  // int count = Sqflite.firstIntValue()

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
