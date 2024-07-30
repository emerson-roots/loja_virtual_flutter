import 'package:loja_virtual/datas/Produto.dart';
import 'package:loja_virtual/datas/categoria.dart';
import 'package:loja_virtual/datas/novidade.dart';

abstract class IHttpService {
  Future<List<Novidade>> getNovidades();
  Future<List<Categoria>> getAllCategorias();
  Future<List<Produto>> getProdutosByCategoriaId(String id);
}