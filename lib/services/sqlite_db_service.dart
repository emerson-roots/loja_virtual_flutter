import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/Produto.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/categoria.dart';
import 'package:loja_virtual/datas/cupom.dart';
import 'package:loja_virtual/datas/novidade.dart';
import 'package:loja_virtual/datas/order.dart';
import 'package:loja_virtual/datas/place.dart';
import 'package:loja_virtual/datas/query_sqlite.dart';
import 'package:loja_virtual/datas/usuario.dart';
import 'package:loja_virtual/helpers/console_helper.dart';
import 'package:loja_virtual/helpers/exception_custom.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/services/db_session_service.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDbService implements IHttpService {
  late final DbSessionService _dbSession;

  SQLiteDbService() {
    _dbSession = GetIt.instance<DbSessionService>();
  }

  @override
  addCartItem(CartProduct cartProduct, String userId) async {
    final db = await _dbSession.db;

    var newId = await db!.rawInsert(
      '''
    INSERT INTO ${QuerySqlite.CART_PRODUCT_TABLE_NAME} (
      uid, pid, category, quantity, size, product_title, product_description, product_price
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''',
      [
        userId,
        cartProduct.pid,
        cartProduct.category,
        cartProduct.quantity,
        cartProduct.size,
        cartProduct.productData?.title,
        cartProduct.productData?.description,
        cartProduct.productData?.price,
      ],
    );

    cartProduct.cid = newId.toString();
  }

  @override
  Future<void> criarConta({required Usuario user}) async {
    Database? dbContact = await _dbSession.db;

    int? id = await dbContact?.insert('Users', user.toJson());
    user.id = id != null ? id.toString() : '0';
  }

  @override
  decrementProduct(CartProduct cartProduct, String userId) async {
    final db = await _dbSession.db;

    var result = await db!.rawUpdate(
      '''
    UPDATE ${QuerySqlite.CART_PRODUCT_TABLE_NAME} 
        SET quantity = quantity - 1 
      WHERE id = ? AND pid = ? AND quantity > 1
    ''',
      [cartProduct.cid, cartProduct.pid],
    );

    if (result <= 0) {
      throw ExceptionCustom('Falha ao tentar reduzir a quantidade do item no carrinho.');
    }
  }

  @override
  Future<List<Categoria>> getAllCategorias() async {
    Database? dbContact = await _dbSession.db;

    List listMap = await dbContact!
        .rawQuery("SELECT * FROM ${QuerySqlite.CATEGORY_TABLE_NAME}");
    List<Categoria> listObj = listMap.map((e) => Categoria.fromMap(e)).toList();
    return listObj;
  }

  @override
  Future<Cupom> getCupomDesconto(String nomeCupom) {
    // TODO: implement getCupomDesconto
    throw UnimplementedError();
  }

  @override
  Future<List<Novidade>> getNovidades() async {
    Database? dbContact = await _dbSession.db;

    List listMap = await dbContact!.rawQuery("SELECT * FROM Home");
    List<Novidade> novidades = listMap.map((e) => Novidade.fromMap(e)).toList();
    return novidades;
  }

  @override
  Future<List<OrderModel>> getPedidosByUserId(String userId) {
    // TODO: implement getPedidosByUserId
    throw UnimplementedError();
  }

  @override
  Future<List<Place>> getPlaces() async {
    Database? db = await _dbSession.db;

    List listMap = await db!.rawQuery("SELECT * FROM Places");
    List<Place> listObj = listMap.map((e) => Place.fromJson(e)).toList();
    return listObj;
  }

  @override
  Future<List<Produto>> getProdutosByCategoriaId(String id) async {
    try {
      Database? db = await _dbSession.db;

      final result = await db?.rawQuery('''
    SELECT 
      p.id,
      p.category,
      p.title,
      p.description,
      p.price,
      pi.image_url,
      ps.size
    FROM ${QuerySqlite.PRODUCT_TABLE_NAME} p
    LEFT JOIN ${QuerySqlite.PRODUCT_IMAGE_TABLE_NAME} pi ON p.id = pi.product_id
    LEFT JOIN ${QuerySqlite.PRODUCT_SIZE_TABLE_NAME} ps ON p.id = ps.product_id
    WHERE p.category = ?
    order by p.id asc, ps.id ASC
;
  ''', [id]);

      final Map<int, Produto> produtosMap = {};

      for (var row in result!) {
        final int productId = row['id'] as int;

        if (!produtosMap.containsKey(productId)) {
          produtosMap[productId] = Produto.fromJson(row);
        }

        final produto = produtosMap[productId]!;

        final imageUrl = row['image_url'] as String?;
        if (imageUrl != null) {
          produto.images ??= []; // Inicializa a lista se estiver nula
          if (!produto.images!.contains(imageUrl)) {
            produto.images!.add(imageUrl);
          }
        }

        final size = row['size'] as String?;
        if (size != null) {
          produto.sizes ??= []; // Inicializa a lista se estiver nula

          if (!produto.sizes!.contains(size)) {
            produto.sizes!.add(size);
          }
        }
      }

      return produtosMap.values.toList();
    } catch (ex, stack) {
      ConsoleHelper.printError('Erro: $ex | Stack: $stack');
      rethrow;
    }
  }

  @override
  incrementProduct(CartProduct cartProduct, String userId) async {
    final db = await _dbSession.db;

    var result = await db!.rawUpdate(
      '''
    UPDATE ${QuerySqlite.CART_PRODUCT_TABLE_NAME} 
        SET quantity = quantity + 1 
      WHERE id = ? AND pid = ?
    ''',
      [cartProduct.cid, cartProduct.pid],
    );
    
    if (result <= 0) {
      throw ExceptionCustom('Falha ao tentar incrementar a quantidade do item no carrinho.');
    }
  }

  @override
  Future<List<CartProduct>> loadCartItemsByUserId(String userId) async {
    final db = await _dbSession.db;

    final List<Map<String, dynamic>> maps = await db!.query(
      'CartProduct',
      where: 'uid = ?',
      whereArgs: [userId],
    );

    List<CartProduct> listRetorno = [];
    maps.forEach((map) async {
      var idProduto = map['pid'].toString();

      // recupera url das imagens do produto para mostrar a primeira img no carrinho
      List<Map<String, Object?>> imageMaps = await db!.query(
          QuerySqlite.PRODUCT_IMAGE_TABLE_NAME,
          where: "product_id = ?",
          whereArgs: [idProduto]);

      var cartProduct = CartProduct();
      var produto = Produto();

      var images = imageMaps.map((x) => x['image_url'] as String).toList();

      produto.id = idProduto;
      produto.title = map['product_title'];
      produto.description = map['product_description'];
      produto.price = map['product_price'];
      produto.images = images;

      cartProduct.cid = map['id'].toString();
      cartProduct.uid = map['uid'].toString();
      cartProduct.pid = idProduto;
      cartProduct.category = map['category'];
      cartProduct.quantity = map['quantity'];
      cartProduct.size = map['size'];
      cartProduct.productData = produto;

      listRetorno.add(cartProduct);
    });
    return listRetorno;
  }

  @override
  Future<Usuario> loadCurrentUser({required String userId}) async {
    Database? dbContact = await _dbSession.db;
    List<Map<String, Object?>> maps =
        await dbContact!.query('Users', where: "id = ?", whereArgs: [userId]);

    if (maps.isNotEmpty) {
      return Usuario.fromJson(maps.first);
    } else {
      throw Exception('Não foi possível carregar o usuário logado.');
    }
  }

  @override
  Future<void> logar({required Usuario user}) async {
    Database? dbContact = await _dbSession.db;
    List<Map<String, dynamic>> maps = await dbContact!.query('Users',
        where: "email = ? and password = ?",
        whereArgs: [user.email, user.password]);

    if (maps.isEmpty) {
      throw Exception('Usuário ou senha inválida.');
    } else {
      var obj = Usuario.fromJson(maps.first);
      user.id = obj.id;
    }
  }

  @override
  Future<String> postFinalizarPedido(List<CartProduct> products, String userId,
      double valorFrete, double valorTotalProdutos, double valorDesconto) {
    // TODO: implement postFinalizarPedido
    throw UnimplementedError();
  }

  @override
  Future<void> recoverPass({required String email}) async {
    ConsoleHelper.printAlert(
        '{recoverPass} em SQLiteDbService não possui ação!');
    throw ExceptionCustom(
        'Este app é somente de amostra/portifolio. Envio de e-mail para recuperação de senha está desativado.');
  }

  @override
  removeCartItem(CartProduct cartProduct, String userId) async {
    final db = await _dbSession.db;

    int result = await db!.delete(
      QuerySqlite.CART_PRODUCT_TABLE_NAME,
      where: 'id = ? AND pid = ?',
      whereArgs: [cartProduct.cid, cartProduct.pid],
    );
    
    if (result <= 0) {
      throw ExceptionCustom('Falha ao tentar remover item do carrinho. O item não foi removido.');
    }
  }

  @override
  Future<void> signOut() async {
    ConsoleHelper.printAlert('{signOut} em SQLiteDbService não possui ação!');
  }
}
