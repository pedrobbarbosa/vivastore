import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecommerce_app/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserScreen extends StatefulWidget {
  static const String routeName = '/user';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => UserScreen(),
    );
  }

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Future<void> _signInWithGoogle() async {
    try {
      // TODO: Implementar a lógica de login com o Google
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao fazer login com o Google';
      });
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        // Login bem-sucedido, redirecionar para a próxima tela
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao fazer login: $e';
      });
    }
  }

  Future<void> _createAccountWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        // Conta criada com sucesso, redirecionar para a próxima tela
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao criar conta: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tela do usuario',
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: hexToColor('#EB690A'),
              ),
              onPressed: _signInWithEmailAndPassword,
              child: Text('Entrar'),
            ),
            ElevatedButton(
              onPressed: _createAccountWithEmailAndPassword,
              child: Text('Criar Conta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: hexToColor('#EB690A'),
              ),
            ),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: Text('Entrar com Google'),
            ),
          ],
        ),
      ),
    );
  }
}
