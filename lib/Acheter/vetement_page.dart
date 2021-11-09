import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Vetement extends StatelessWidget {
  Vetement({Key? key, required this.login, required this.vetementTitre})
      : super(key: key);

  final String login;
  final String vetementTitre;

  int prixVetement = 0;

  Widget _buildMarqueVetements(BuildContext context, String vetement) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Vetements');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(vetement).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Erreur de connexion");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Le document n'existe pas");
        }

        String marque = "Inconnu";
        Map<String, dynamic> data = {};
        if (snapshot.data != null) {
          data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['marque'] != null) {
            marque = data['marque'];
          }
        }

        return Text(
          "Marque : $marque",
          style: Theme.of(context).textTheme.headline5,
          textScaleFactor: 1.5,
        );
      },
    );
  }

  Widget _buildPrixVetements(BuildContext context, String vetement) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Vetements');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(vetement).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Erreur de connexion");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Le document n'existe pas");
        }

        String prix = "Inconnu";
        Map<String, dynamic> data = {};
        if (snapshot.data != null) {
          data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['prix'] != null) {
            prix = data['prix'] + " €";
            prixVetement = int.parse(data['prix']);
          }
        }

        return Text(
          "Prix : $prix",
          style: Theme.of(context).textTheme.headline5,
          textScaleFactor: 1.5,
        );
      },
    );
  }

  Widget _buildTailleVetements(BuildContext context, String vetement) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Vetements');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(vetement).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Erreur de connexion");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Le document n'existe pas");
        }

        String taille = "Inconnu";
        Map<String, dynamic> data = {};
        if (snapshot.data != null) {
          data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['taille'] != null) {
            taille = data['taille'];
          }
        }

        return Text(
          "Taille : $taille",
          style: Theme.of(context).textTheme.headline5,
          textScaleFactor: 1.5,
        );
      },
    );
  }

  Widget _buildButtonAjouterPanier(BuildContext context, String vetement) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(login).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Erreur de connexion");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Le document n'existe pas");
        }

        Color enabledColor = Colors.blue;
        String contenuButton = "Ajouter au panier";
        bool dispo = true;


        Map<String, dynamic> data = {};
        if (snapshot.data != null) {
          data = snapshot.data!.data() as Map<String, dynamic>;
          try{
            if (data['panier'].length != 0) {
              for (int i = 0; i < data['panier']!.length; i++) {
                if (data['panier']![i] == vetementTitre) {
                  i = data['panier']!.length;
                  enabledColor = Colors.grey;
                  contenuButton = "Déjà au panier";
                  dispo = false;
                }
              }
            }
          }
          catch (e){
            return const Text("Erreur");
          }
        }

        return Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
              color: enabledColor, borderRadius: BorderRadius.circular(20)),
          child: TextButton(
            onPressed: () {
              if (dispo) {
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(login)
                    .update({
                  'panier': FieldValue.arrayUnion([vetementTitre])
                });
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(login)
                    .update({'prixPanier': FieldValue.increment(prixVetement)});

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Ajouté au panier!'),
                  /*action: SnackBarAction(
                    label: 'Annuler',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),*/
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Déjà au panier!'),
                ));
              }
            },
            child: Text(
              contenuButton,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Vetements');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(vetementTitre).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Erreur de connexion");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Le document n'existe pas");
        }

        String image =
            "https://cdn.dribbble.com/users/1186261/screenshots/3718681/_______.gif";
        Map<String, dynamic> data = {};
        if (snapshot.data != null) {
          data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['image'] != null) {
            image = data['image'];
          }
        }

        return Scaffold(
            appBar: AppBar(
              title: Text('MIAGED - $vetementTitre'),
              elevation: 0,
            ),
            body: Center(
                child: Column(children: <Widget>[
              SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.network(
                    image,
                    fit: BoxFit.fitWidth,
                  )),
              const SizedBox(
                height: 25,
              ),
              _buildTailleVetements(context, vetementTitre),
              _buildPrixVetements(context, vetementTitre),
              _buildMarqueVetements(context, vetementTitre),
              const SizedBox(
                height: 25,
              ),
              _buildButtonAjouterPanier(context, login)
            ])));
      },
    );
  }
}
