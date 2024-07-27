import 'package:loja_virtual/datas/novidade.dart';

abstract class IHttpService {
  Future<List<Novidade>> getNovidades();
}