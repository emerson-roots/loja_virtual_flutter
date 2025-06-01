import 'package:loja_virtual/datas/query_sqlite.dart';
import 'package:loja_virtual/helpers/console_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbSessionService {
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

    Database dbOpen = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dbOpen;
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      /// cria tabelas
      await db.execute(QuerySqlite.createTableHome);
      await db.execute(QuerySqlite.createTableCategoryProduto);
      await db.execute(QuerySqlite.createTablePlaces);
      await db.execute(QuerySqlite.createTableUsers);
      await db.execute(QuerySqlite.createTableProducts);
      await db.execute(QuerySqlite.createTableProductImages);
      await db.execute(QuerySqlite.createTableProductSizes);

      await db.execute(QuerySqlite.createTableCartProducts);

      /// insere dados iniciais básicos
      await db.execute(QuerySqlite.insertsHome);
      await db.execute(QuerySqlite.insertsProductsCategory);
      await db.execute(QuerySqlite.insertsPlaces);
      await db.execute(QuerySqlite.insertsUser);
      await db.execute(QuerySqlite.insertsProducts);
      await db.execute(QuerySqlite.insertsProductImages);
      await db.execute(QuerySqlite.insertsProducSizes);
    } catch (ex, stack) {
      ConsoleHelper.printError('Erro: $ex | Stack: $stack');
      rethrow;
    }
  }
}
