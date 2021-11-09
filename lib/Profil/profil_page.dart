import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projet/Connexion/login_page.dart';

class PageProfil extends StatefulWidget {
  const PageProfil({Key? key, required this.login}) : super(key: key);

  final String login;

  @override
  _PageProfilState createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  final TextEditingController _addrController = TextEditingController();
  final TextEditingController _annivController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.login).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          _villeController.text = data['ville'];
          _cpController.text = data['cp'];
          _mdpController.text = data['mdp'];
          _annivController.text = data['anniv'];
          _addrController.text = data['addr'];
          return Scaffold(
            appBar: AppBar(
              title: const Text("MIAGED"),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: Column(children: <Widget>[
                TextFormField(
                  initialValue: data['login'],
                  readOnly: true,
                  decoration: const InputDecoration(
                      labelText: "Login",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextFormField(
                  controller: _mdpController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextFormField(
                  controller: _annivController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                      labelText: 'Anniversaire',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () async{
                        DateTime date = DateTime(1900);
                        FocusScope.of(context).requestFocus(FocusNode());

                        date = (await showDatePicker(
                            context: context,
                            initialDate:DateTime.now(),
                            firstDate:DateTime(1900),
                            lastDate: DateTime(2025)))!;

                        _annivController.text = date.toIso8601String().substring(0, 10);}
                ),
                TextFormField(
                  controller: _addrController,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                      labelText: 'Adresse',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextFormField(
                  controller: _cpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Code postal',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextFormField(
                  controller: _villeController,
                  decoration: const InputDecoration(
                      labelText: 'Ville',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
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
                    onPressed: () {
                      databaseReference
                          .collection("Users")
                          .doc(widget.login).update({
                        'login': widget.login,
                        'mdp': _mdpController.text,
                        'ville': _villeController.text,
                        'cp': _cpController.text,
                        'anniv': _annivController.text,
                        'addr': _addrController.text
                      });

                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupValidProfil(context),
                      );
                    },
                    child: const Text(
                      'Valider',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
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
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const Login()),
                          ModalRoute.withName("/LoginFormValidation"));
                    },
                    child: const Text(
                      'Se déconnecter',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ]),
            ),
          );
        }

        return const Text("loading");
      },
    );
  }

  Widget _buildPopupValidProfil(BuildContext context) {
    return AlertDialog(
      title: const Text('Validé'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Vos informations sont enregistrées"),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
