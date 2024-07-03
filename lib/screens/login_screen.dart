import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  // permite o acesso ao formulário atraves do botao de entrar
  // utilizado para validar os campos preenchidos de formulario
  final _formKey = GlobalKey<FormState>();

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
          TextButton(
            onPressed: () {},
            child: const Text(
              "CRIAR CONTA",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerRight),
                onPressed: () {},
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
                if (_formKey.currentState!.validate()) {}
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
      ),
    );
  }
}
