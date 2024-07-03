import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';

import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: "Nome completo"),
              validator: (text) {
                if (text!.isEmpty) {
                  return "Campo obrigatório.";
                }
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
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
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()));
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
      ),
    );
  }
}
