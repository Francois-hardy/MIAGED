import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PagePanier extends StatefulWidget {
  PagePanier({Key? key, required this.login}) : super(key: key);

  final String login;
  int prixTotal = 0;
  Map<String, int> listePanier = {};

  @override
  _PagePanierState createState() => _PagePanierState();
}

class _PagePanierState extends State<PagePanier> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.login).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = {};
          if (snapshot.data != null) {
            data = snapshot.data!.data() as Map<String, dynamic>;
            try {
              if (data["panier"].isEmpty || data["panier"] == null) {
                print("Panier vide");
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("MIAGED"),
                  ),
                  body: Center(
                    child: Container(
                      height: 120,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text(
                          'Cliquez pour actualiser',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }
            } catch (e) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("MIAGED"),
                ),
                body: Center(
                  child: Container(
                    height: 120,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text(
                        'Cliquez pour actualiser',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }
          }

          return NotificationListener<ScrollNotification>(
              child: Scaffold(
            appBar: AppBar(
              title: const Text("MIAGED"),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: FloatingActionButton.extended(
                onPressed: () {},
                label: _buildPrixTotal(context),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () {
                return Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Page actualisée'),
                      ),
                    );
                  },
                );
              },
              child: GridView.count(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(data['panier'].length, (index) {
                  return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 15.0),
                            blurRadius: 20.0,
                          ),
                        ],
                      ),
                      child: Column(children: <Widget>[
                        const SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: Text(
                            data['panier'][index],
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        _buildEachVetements(context, data['panier'][index]),
                        _buildTailleVetements(context, data['panier'][index]),
                        _buildPrixVetements(context, data['panier'][index]),
                        TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDeleteItem(
                                        context,
                                        data['panier'][index],
                                        widget.listePanier[data['panier']
                                            [index]]),
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.pink,
                            ),
                            label: const Text("Supprimer")),
                      ]));
                }),
              ),
            ),
          ));
        }

        return Column(children: <Widget>[
          const SizedBox(
            width: 600,
            height: 300,
          ),
          Container(
            color: Colors.grey[300],
            width: 70.0,
            height: 70.0,
            alignment: Alignment.center,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ]);
      },
    );
  }

  Widget _buildPrixTotal(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.login).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        var prix = 0;
        Map<String, dynamic> data = {};
        if (snapshot.data != null) {
          data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['prixPanier'] != null) {
            prix = data['prixPanier'];
          }
        }
        return Text(
          "Total : ${prix} €",
          textScaleFactor: 1.7,
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
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        String prix = "Inconnu";
        Map<String, dynamic> data = {};
        if (snapshot.data != null) {
          data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['prix'] != null) {
            prix = data['prix'];
            widget.listePanier.putIfAbsent(vetement, () => int.parse(prix));
            prix = data['prix'] + " €";
          }
        }

        return Text(
          "Prix : $prix",
          style: Theme.of(context).textTheme.headline5,
          textScaleFactor: 0.5,
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
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
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
          textScaleFactor: 0.5,
        );
      },
    );
  }

  Widget _buildEachVetements(BuildContext context, String vetement) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Vetements');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(vetement).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
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

        return Expanded(
            child: Image.network(
          image,
          fit: BoxFit.fitWidth,
        ));
      },
    );
  }

  Widget _buildPopupDeleteItem(
      BuildContext context, String vetementTitre, int? prix) {
    return AlertDialog(
      title: const Text('Attention'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Voulez-vous supprimer cet article ?"),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {});
            FirebaseFirestore.instance
                .collection("Users")
                .doc(widget.login)
                .update({
              'panier': FieldValue.arrayRemove([vetementTitre])
            });
            int prixInt = 0;
            if (prix != null) {
              prixInt = prix;
            }
            print(prixInt.toSigned(10));

            FirebaseFirestore.instance
                .collection("Users")
                .doc(widget.login)
                .update({'prixPanier': FieldValue.increment(-prixInt)});
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Oui'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Non'),
        ),
      ],
    );
  }
}
