import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/constantes_globais.dart';
import 'package:loja_virtual/helpers/console_helper.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtual/services/db_session_service.dart';
import 'package:loja_virtual/services/firebase_db_impl.dart';
import 'package:loja_virtual/services/sqlite_db_service.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/user_model.dart';

void main() async {
  registraDependencias();

  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // exibe no console
      FlutterError.presentError(details);
    }

    ConsoleHelper.printError(
      'Erro no Flutter capturado pelo handler global: ${details.exception}',
    );
  };

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      runApp(
        MultiProvider(
          providers: [
            // dependencias
            Provider<IHttpService>(
              create: (_) => GetIt.instance<IHttpService>(instanceName: ConstantesGlobais.FIREBASE_INJECTION),
            ),
          ],
          child: MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      ConsoleHelper.printError(
        'Erro no Dart capturado pelo handler global: $error | StackTrace: $stackTrace',
      );
    },
  );
}

void registraDependencias() {
  GetIt.instance.registerLazySingleton<IHttpService>(() => FirebaseDbimpl(), instanceName: ConstantesGlobais.FIREBASE_INJECTION);
  GetIt.instance.registerLazySingleton<IHttpService>(() => SQLiteDbService(), instanceName: ConstantesGlobais.SQLITE_INJECTION);

  GetIt.instance.registerLazySingleton<DbSessionService>(() => DbSessionService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: "Flutter's Clothing",
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 4, 125, 141),
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
