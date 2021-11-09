import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home_page.dart';

final databaseReference = FirebaseFirestore.instance;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _Register createState() => _Register();
}

/// Classe pour l'inscription
class _Register extends State<Register> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _villeController = TextEditingController();
  final _cpController = TextEditingController();
  final _addrController = TextEditingController();
  final _annivController = TextEditingController();

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

  /// Build principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("MIAGED"), //titre du scaffold
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          //on regarde la validation pendant l'ecriture
          key: formkey,
          child: Column(
            //colonne de widget
            children: <Widget>[
              const SizedBox(
                //box vide
                width: 200,
                height: 20,
              ),
              const Text(
                //texte
                "Inscription",
                textAlign: TextAlign.center,
                textScaleFactor: 3.0,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                //box vide
                width: 200,
                height: 30,
              ),
              Padding(
                //login
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Login',
                        hintText: 'Entrer un login valide'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Obligatoire"), //champ obligatoire
                    ])),
              ),
              Padding(
                //mot de passe
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                    controller: _password1Controller,
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
              Padding(
                //adresse
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                    controller: _addrController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adresse',
                        hintText: 'Enrer votre adresse'),
                    validator: MultiValidator([
                      MaxLengthValidator(40,
                          errorText:
                              "L'adresse ne doit pas dépasser 40 caractères")
                    ])
                    //validatePassword,        //Function to check validation
                    ),
              ),
              Padding(
                //anniversaire
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                    controller: _annivController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date de naissance',
                        hintText: 'Enrer votre date de naissance'),
                    onTap: () async {
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(FocusNode());

                      date = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2025)))!;

                      _annivController.text =
                          date.toIso8601String().substring(0, 10);
                    }),
              ),
              Padding(
                //ville
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                    controller: _villeController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ville',
                        hintText: 'Enrer votre ville'),
                    validator: MultiValidator([
                      MaxLengthValidator(15,
                          errorText:
                              "La ville ne doit pas dépasser 15 caractères")
                    ])
                    //validatePassword,        //Function to check validation
                    ),
              ),
              Padding(
                //cp
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                    controller: _cpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Code postal',
                        hintText: 'Enrer votre code postal'),
                    validator: MultiValidator([
                      MaxLengthValidator(15,
                          errorText:
                              "Le mot de passe ne doit pas dépasser 10 caractères")
                    ])
                    //validatePassword,        //Function to check validation
                    ),
              ),
              const SizedBox(
                width: 200,
                height: 30,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    Map<String, dynamic> regionData = <String, dynamic>{};
                    if (_usernameController.text.isNotEmpty && _usernameController.text.length > 6){
                      regionData["login"] = _usernameController.text;

                      DocumentReference currentRegion = FirebaseFirestore.instance
                          .collection("Users")
                          .doc(_usernameController.text);

                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        transaction.set(currentRegion, regionData);
                      });
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(_usernameController.text)
                          .update({
                        'login': _usernameController.text,
                        "mdp": _password1Controller.text,
                        "addr": _addrController.text,
                        "anniv": _annivController.text,
                        "cp": _cpController.text,
                        "ville": _villeController.text,
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Accueil(login: _usernameController.text)),
                          ModalRoute.withName("/MyApp"));
                    }
                    else{
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopup(context, "Erreur", "Veuillez entrer un login et mot de passe valide"),
                      );

                    }

                  },
                  child: const Text(
                    'S' 'inscrire',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
