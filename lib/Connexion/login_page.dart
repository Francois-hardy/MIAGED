import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet/Connexion/register_page.dart';
import '../Controller/controller.dart';

final databaseReference = FirebaseFirestore.instance;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "* Obligatoire";
    } else if (value.length < 6) {
      return "Le mot de passe doit contenir au moins 6 caractères";
    } else if (value.length > 15) {
      return "Le mot de passe ne doit pas dépasser 15 caractères";
    } else {
      return null;
    }
  }

  Widget _buildPopup(BuildContext context, String titre, String message) {
    return AlertDialog(
      title: Text(titre),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("MIAGED"),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          //check for validation while typing
          key: formkey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: 200,
                height: 110,
              ),
              const Text(
                "Connexion",
                textAlign: TextAlign.center,
                textScaleFactor: 3.0,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 200,
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Login',
                        hintText: 'Entrer un login valide'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Obligatoire"),
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mot de passe',
                        hintText: 'Enrer votre mot de passe'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Obligatoire"),
                      MinLengthValidator(6,
                          errorText:
                              "Le mot de passe doit contenir au moins 6 caractères"),
                      MaxLengthValidator(15,
                          errorText:
                              "Le mot de passe ne doit pas dépasser 15 caractères")
                    ])
                    //validatePassword,        //Function to check validation
                    ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopup(context, "Attention", "Cette fonctionnalitée n'est pas encore implémentée :)"),
                  );
                },
                child: const Text(
                  'Mot de passe oubié ?',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    databaseReference
                        .collection("Users")
                        .doc(_usernameController.text)
                        .snapshots()
                        .listen((event) {
                      try {
                        if (event.get("mdp") == _passwordController.text) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Accueil(login: _usernameController.text)),
                              ModalRoute.withName("/MyApp"));
                        }
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopup(context, "Erreur", "Les identifiants sont incorrects"),
                        );
                      }
                    });
                  },
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()));
                  },
                  child: const Text('Nouveau ? Créé ton compte')),
            ],
          ),
        ),
      ),
    );
  }
}
