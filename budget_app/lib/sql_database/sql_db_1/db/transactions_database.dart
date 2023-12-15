import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/transaction.dart';

class TransactionXsDatabase {
  static final TransactionXsDatabase instance = TransactionXsDatabase._init();

  static Database? _database;

  TransactionXsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Transaction04.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableTransactionXs ( 
  ${TransactionXFields.id} $idType, 
  ${TransactionXFields.isImportant} $boolType,
  ${TransactionXFields.amount} $textType,
  ${TransactionXFields.account} $textType,
  ${TransactionXFields.description} $textType,
  ${TransactionXFields.time} $textType,
  ${TransactionXFields.category} $textType,
  ${TransactionXFields.transfertto} $textType,
  ${TransactionXFields.type} $textType
  )
''');
    print("_____________db_Created____________");
  }

  Future<TransactionX> create(TransactionX TransactionX) async {
    final db = await instance.database;

    // final json = TransactionX.toJson();
    // final columns =
    //     '${TransactionXFields.title}, ${TransactionXFields.description}, ${TransactionXFields.time}';
    // final values =
    //     '${json[TransactionXFields.title]}, ${json[TransactionXFields.description]}, ${json[TransactionXFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableTransactionXs, TransactionX.toJson());

    return TransactionX.copy(id: id);
  }

  Future<TransactionX> readTransactionX(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTransactionXs,
      columns: TransactionXFields.values,
      where: '${TransactionXFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TransactionX.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<TransactionX>> readAllTransactionXs() async {
    final db = await instance.database;

    const orderBy = '${TransactionXFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableTransactionXs ORDER BY $orderBy');

    final result = await db.query(tableTransactionXs, orderBy: orderBy);
    List re = result.reversed.toList();

    return re.map((json) => TransactionX.fromJson(json)).toList();
    //return result.map((json) => TransactionX.fromJson(json)).toList();
  }

  Future<int> update(TransactionX TransactionX) async {
    final db = await instance.database;

    return db.update(
      tableTransactionXs,
      TransactionX.toJson(),
      where: '${TransactionXFields.id} = ?',
      whereArgs: [TransactionX.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTransactionXs,
      where: '${TransactionXFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future deleteTable() async {
    final db = await instance.database;
    await db.execute("DROP TABLE IF EXISTS $tableTransactionXs");
  }

  Future deleteDB() async {
    final dbPath = await getDatabasesPath();
    await databaseFactory.deleteDatabase(dbPath);
  }
}
