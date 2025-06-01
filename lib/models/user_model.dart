import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/constantes_globais.dart';
import 'package:loja_virtual/datas/usuario.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:scoped_model/scoped_model.dart';

// Definindo o tipo de função que retorna uma String
typedef StringCallback = String Function(String);

class UserModel extends Model {
  final _storage = const FlutterSecureStorage();
  late final IHttpService _httpService;
  static const String CHAVE_EMAIL = 'EMAIL_KEY';
  static const String CHAVE_SENHA = 'PASSWORD_KEY';
  static const String CHAVE_ID_USER = 'ID_USER_KEY';

  Usuario? usuarioObj;

  bool isLoading = false;

  static UserModel of(BuildContext context) {
    return ScopedModel.of<UserModel>(context);
  }

  UserModel() {
    _httpService = GetIt.instance<IHttpService>(instanceName: ConstantesGlobais.SQLITE_INJECTION);
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  Future<bool> signUp({
    required Usuario usuario,
    required VoidCallback onSuccess,
    required StringCallback onFail,
  }) async {
    configuraIsLoading(true);

    bool isContaCriadaComSucesso = false;

    await _httpService.criarConta(user: usuario).then((user) async {
      usuarioObj = usuario;

      onSuccess();
      configuraIsLoading(false);

      _storage.write(key: CHAVE_EMAIL, value: usuario.email);
      _storage.write(key: CHAVE_SENHA, value: usuario.password);
      _storage.write(key: CHAVE_ID_USER, value: usuario.id);
      isContaCriadaComSucesso = true;
    }).catchError((ex) {
      onFail(ex.message);
      configuraIsLoading(false);
      isContaCriadaComSucesso = false;
    });

    return isContaCriadaComSucesso;
  }

  void signIn({
    required Usuario usuario,
    required VoidCallback onSuccess,
    required StringCallback onFail,
  }) async {
    configuraIsLoading(true);
    await _httpService.logar(user: usuario).then((user) async {
      usuarioObj = usuario;
      await _loadCurrentUser();

      _storage.write(key: CHAVE_EMAIL, value: usuario.email);
      _storage.write(key: CHAVE_SENHA, value: usuario.password);
      _storage.write(key: CHAVE_ID_USER, value: usuario.id);
      onSuccess();
      configuraIsLoading(false);
    }).catchError((ex) {
      onFail(ex.message);
      configuraIsLoading(false);
    });
  }

  Future<void> recoverPass(String email) async {
    await _httpService.recoverPass(email: email);
  }

  bool isLoggedIn() {
    return usuarioObj != null && usuarioObj?.id != null;
  }

  void configuraIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void signOut() async {
    await _httpService.signOut();
    usuarioObj = null;

    _storage.write(key: CHAVE_EMAIL, value: '');
    _storage.write(key: CHAVE_SENHA, value: '');
    _storage.write(key: CHAVE_ID_USER, value: '');

    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    if (usuarioObj != null && usuarioObj!.name.isEmpty) {
      var obj = await _httpService.loadCurrentUser(userId: usuarioObj!.id!);
      usuarioObj = obj;
    } else {
      var userCache = await _gertUserNoCache();

      if (userCache != null) {
        var obj = await _httpService.loadCurrentUser(userId: userCache.id!);

        usuarioObj = obj;
      }
    }

    notifyListeners();
  }

  Future<Usuario?> _gertUserNoCache() async {
    var emailCache = await _storage.read(key: CHAVE_EMAIL) ?? '';
    var senhaCache = await _storage.read(key: CHAVE_SENHA) ?? '';
    var idUserCache = await _storage.read(key: CHAVE_ID_USER) ?? '';

    if (emailCache.isEmpty || senhaCache.isEmpty || idUserCache.isEmpty) {
      return null;
    } else {
      return Usuario(
          email: emailCache,
          password: senhaCache,
          id: idUserCache,
          name: '',
          address: '');
    }
  }
}
