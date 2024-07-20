import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // controladores para recuperar infos digitadas na tela
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Criar Conta",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(hintText: "Nome completo"),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Campo obrigatório.";
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
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
                    controller: _passController,
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
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(hintText: "Endereço"),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Campo obrigatório.";
                      }
                    },
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
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> userData = {
                          "name": _nameController.text,
                          "email": _emailController.text,
                          "address": _addressController.text
                        };

                        var isContaCriadaComSucesso = model.signUp(
                            userData: userData,
                            pass: _passController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail);

                        if (isContaCriadaComSucesso) {
                          _limparCampos();
                        }
                        /* Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));*/
                      }
                    },
                    child: const Text(
                      "Criar conta",
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

  void _limparCampos() {
    _nameController.clear();
    _emailController.clear();
    _passController.clear();
    _addressController.clear();
  }

  void _onSuccess() {
    int tempoRedirectHomeAndDuracaoMensagem = 2;
    final snackBar = _snackBarMessage(
      mensagem: 'Usuário criado com sucesso.',
      corSnackBar: Theme.of(context).primaryColor,
      tempoDuracaoMensagem: tempoRedirectHomeAndDuracaoMensagem,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Future.delayed(Duration(seconds: tempoRedirectHomeAndDuracaoMensagem))
        .then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  String _onFail(String exMessage) {
    final snackBar = _snackBarMessage(
        mensagem: 'Falha ao criar usuário. ${exMessage}',
        corSnackBar: Colors.redAccent,
        tempoDuracaoMensagem: 4);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return exMessage;
  }

  SnackBar _snackBarMessage({
    required String mensagem,
    required Color corSnackBar,
    required int tempoDuracaoMensagem,
  }) {
    return SnackBar(
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
  }
}
