// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static const dbName = 'billing_system.db';
//   static const dbVersion = 1;
//   static const userTable = 'user_profile';
//   static const columnId = 'id';
//   static const userName = 'userName';
//   static const email = 'email';
//   static const token = 'token';

//   DatabaseHelper._privateConstuctor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstuctor();

//   late Database _db;

//   // THIS OPENS THE DATABASE (AND CREATES IT IF IT DOESN'T EXIST)
//   Future<void> database() async {
//     // _intiateDatabase;
//     final documentsDirectory = await getApplicationDocumentsDirectory();
//     final path = join(documentsDirectory.path, dbName);

//     _db = await openDatabase(
//       path,
//       version: dbVersion,
//       onCreate: _onCreate,
//     );
//   }

//   _onCreate(Database db, int version) async {
//     // USED TO CREATE A NEW TABLE
//     await db.execute('''
//       CREATE TABLE $userTable (
//         $columnId INTEGER PRIMARY KEY,
//       $userName INTEGER NOT NULL,
//       $email INTEGER NOT NULL,
//       $token TEXT NOT NULL,
      
//       )

//       ''');
//   }

//   Future<int> insert(tableName, Map<String, dynamic> row) async {
//     // Database db = database as Database;
//     await database();

//     return await _db.insert(tableName, row);
//   }

//   Future<List<Map<String, dynamic>>> queryWithCondition(
//       tableName, email) async {
//     await database();
//     return await _db
//         .rawQuery('SELECT * FROM $tableName WHERE email=?', ['$email']);
//   }

//   Future<int> update(tableName, Map<String, dynamic> row) async {
//     // Database db = await instance.database;
//     await database();
//     int id = row[columnId];
//     return await _db
//         .update(tableName, row, where: '$columnId = ?', whereArgs: [id]);
//   }
// }
