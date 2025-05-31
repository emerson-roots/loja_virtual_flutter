import 'package:loja_virtual/datas/query_sqlite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbSessionService{

  static final DbSessionService _instance = DbSessionService._internal();
  factory DbSessionService() => _instance;
  DbSessionService._internal();


  bool _createdDatabase = false;

  Database? _db;
  Future<Database?> get db async {
    if (_createdDatabase) {
      return _db;
    } else {
      _db = await _initDatabase();
      return _db;
    }
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'loja_flutter.db3');

    Database dbOpen = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate
    );
    return dbOpen;
  }

  Future<void> _onCreate(Database db, int version) async {
    /// cria tabelas
    await db.execute(QuerySqlite.createTableHome);

    /// insere dados iniciais básicos
    await db.execute(QuerySqlite.insertsHome);

  }

}