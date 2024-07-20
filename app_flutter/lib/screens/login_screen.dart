import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // permite o acesso ao formulário atraves do botao de entrar
  // utilizado para validar os campos preenchidos de formulario
  final _formKey = GlobalKey<FormState>();

  // controladores para capturar informacoes de binding da tela
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Entrar",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          ScopedModelDescendant<UserModel>(builder: (context, child, model) {
            return TextButton(
              onPressed: !model.isLoading
                  ? () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    }
                  : null,
              child: const Text(
                "CRIAR CONTA",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Carregando...",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      // o validator deve ser usado em conjunto com o _formKey instanciado no inicio da classe
                      // o _formKey deve ser setado na propriedade "key" do widget Form
                      if (text!.isEmpty || !text.contains("@")) {
                        return "E-mail inválido.";
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: "Senha"),
                    obscureText: true,
                    validator: (text) {
                      // o validator deve ser usado em conjunto com o _formKey instanciado no inicio da classe
                      // o _formKey deve ser setado na propriedade "key" do widget Form
                      int qtdMaximaCaracteres = 6;
                      if (text!.isEmpty) {
                        return "Campo obrigatório.";
                      } else if (text.length < qtdMaximaCaracteres) {
                        return "Deve ser maior que ${qtdMaximaCaracteres} caracteres.";
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerRight),
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          _showSnackBarMessage(
                              mensagem: "Insira seu e-mail para recuperação.",
                              corSnackBar: Colors.redAccent,
                              tempoDuracaoMensagem: 3);
                        } else{
                          model.recoverPass(_emailController.text);

                          _showSnackBarMessage(
                              mensagem: "Verifique seu e-mail.",
                              corSnackBar: Colors.blue.shade600,
                              tempoDuracaoMensagem: 3);
                        }
                      },
                      child: const Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: false
                          ? const StadiumBorder()
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                    ),
                    onPressed: () {
                      /*if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    }*/

                      model.signIn(
                          email: _emailController.text,
                          pass: _passwordController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail);
                    },
                    child: const Text(
                      "ENTRAR",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  String _onFail(String exMessage) {
    _showSnackBarMessage(
        mensagem: 'Falha ao entrar. ${exMessage}',
        corSnackBar: Colors.redAccent,
        tempoDuracaoMensagem: 4);


    return exMessage;
  }

  void _showSnackBarMessage({
    required String mensagem,
    required Color corSnackBar,
    required int tempoDuracaoMensagem,
  }) {
    var snackBar =  SnackBar(

      content: Text(mensagem),
      backgroundColor: corSnackBar,
      duration: Duration(seconds: tempoDuracaoMensagem),
      action: SnackBarAction(
        label: 'FECHAR',
        textColor: Colors.white,
        onPressed: () {
          // Alguma ação opcional
        },
      ),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
