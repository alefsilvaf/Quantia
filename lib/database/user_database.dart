import 'database_helper.dart';
import 'database_utils.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._privateConstructor();
  static final String tableName = 'users';

  UserDatabase._privateConstructor();

  Future<void> createUserTableIfNotExists() async {
    final db = await DatabaseHelper.instance.database;
    final tableExists = await DatabaseUtils.tableExists(db, tableName);

    if (!tableExists) {
      await DatabaseHelper.instance.createTable(tableName, [
        'id INTEGER PRIMARY KEY',
        'username TEXT NOT NULL',
        'email TEXT NOT NULL',
        'password TEXT NOT NULL'
      ]);
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    createUserTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final users = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return users.isNotEmpty ? users.first : null;
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await DatabaseHelper.instance.database;
    return await db
        .update(tableName, user, where: 'id = ?', whereArgs: [user['id']]);
  }

  Future<int> deleteUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
