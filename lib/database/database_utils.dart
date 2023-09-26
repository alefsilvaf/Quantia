import 'package:sqflite/sqflite.dart';

class DatabaseUtils {
  static Future<bool> tableExists(Database db, String tableName) async {
    final result = await db.query(
      'sqlite_master',
      where: 'type = ? AND name = ?',
      whereArgs: ['table', tableName],
    );
    return result.isNotEmpty;
  }
}
