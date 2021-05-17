import 'dart:async';

import 'package:dsi_app/view/word_pair_view.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

///TPC-5 (branch_wordPairs5):
/// Persistência dos dados com o Firebase.
/// Veja os ajustes feitos em: pubspec.yaml,
/// Acesse:
/// https://firebase.flutter.dev/docs/overview/
/// https://firebase.flutter.dev/docs/installation/android/
///
/// ATENÇÃO:
/// -Configure o plugin no pubspec.yaml
/// -Adicione o android/app/google-services.json no projeto (gerar no Firebase Console)
/// -atualize o android/build.gradle com as informações dos serviços do google
/// -atualize o android/app/build.gradle
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DSIApp());
}

///Classe principal que representa o App.
///O uso do widget do tipo Stateful evita a reinicialização do Firebase
///cada vez que o App é reconstruído.
class DSIApp extends StatefulWidget {
  ///Cria o estado do app.
  @override
  _DSIAppState createState() => _DSIAppState();
}

///O estado do app.
class _DSIAppState extends State<DSIApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  ///Constrói o App a partir do FutureBuilder, após o carregamento do Firebase.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildError(context);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return _buildApp(context);
        }

        return _buildLoading(context);
      },
    );
  }

  ///Constroi o componente que apresenta o erro no carregamento do Firebase.
  Widget _buildError(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Text(
          'Erro ao carregar os dados do App.\n'
          'Tente novamente mais tarde.',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  ///Constrói o componente de load.
  Widget _buildLoading(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              'carregando...',
              style: TextStyle(
                color: Colors.pink,
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Constrói o App e suas configurações.
  Widget _buildApp(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DSI App (BSI UFRPE)',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      initialRoute: HomePage.routeName,
      routes: _buildRoutes(context),
    );
  }

  ///Método utilizado para configurar as rotas.
  Map<String, WidgetBuilder> _buildRoutes(BuildContext context) {
    return {
      WordPairUpdatePage.routeName: (context) => WordPairUpdatePage(),
    };
  }
}
