import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projet/Acheter/vetement_page.dart';


class PageAcheter extends StatefulWidget {
  const PageAcheter({Key? key, required this.login}) : super(key: key);

  final String login;

  @override
  _PageAcheterState createState() => _PageAcheterState();
}

class _PageAcheterState extends State<PageAcheter> {
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
          return const Text("Document does not exist");
        }

        String prix = "Inconnu";
        Map<String, dynamic> data = {};
        if (snapshot.data != null) {
          data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['prix'] != null) {
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
          return const Text("Erreur de connexion");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
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
          return const Text("Erreur de connexion");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
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

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Vetements');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc("Liste").get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Erreur de connexion");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        List<String> listeTous = [];
        List<String> listeHaut = [];
        List<String> listeBas = [];

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = {};
          if (snapshot.data != null) {
            data = snapshot.data!.data() as Map<String, dynamic>;

            for (int i = 0; i < data.length; i++) {
              listeTous.add(data[i.toString()].split(':')[0].trim());
            }

            for (int i = 0; i < data.length; i++) {
              if (data[i.toString()].split(':')[1].trim() == "Haut") {
                listeHaut.add(data[i.toString()].split(':')[0].trim());
              }
            }

            for (int i = 0; i < data.length; i++) {
              if (data[i.toString()].split(':')[1].trim() == "Bas") {
                listeBas.add(data[i.toString()].split(':')[0].trim());
              }
            }
          }
          final _formKey = GlobalKey<FormState>();
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Positioned(
                                  right: -40.0,
                                  top: -40.0,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const CircleAvatar(
                                      child: Icon(Icons.close),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Nom du vetement'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Taille'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Prix'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Marque'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Photo (URL)'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: const Text("Vaider"),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                            }
                                          },
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: const Icon(Icons.add),
                ),
              ),
              appBar: AppBar(
                title: const Text("MIAGED"),
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: "Tous",
                    ),
                    Tab(
                      text: "Haut",
                    ),
                    Tab(
                      text: "Bas",
                    ),
                  ],
                ),
                elevation: 0,
              ),
              body: TabBarView(
                children: [
                  NotificationListener<ScrollNotification>(
                    child: Scaffold(
                      body: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: List.generate(listeTous.length, (index) {
                          return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17.0),
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
                                _buildEachVetements(context, listeTous[index]),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Vetement(
                                                  login: widget.login,
                                                  vetementTitre:
                                                      listeTous[index])));
                                    },
                                    child: Text(
                                      listeTous[index],
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                ),
                                _buildTailleVetements(
                                    context, listeTous[index]),
                                _buildPrixVetements(context, listeTous[index]),
                              ]));
                        }),
                      ),
                    ),
                  ),
                  NotificationListener<ScrollNotification>(
                    child: Scaffold(
                      body: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: List.generate(listeHaut.length, (index) {
                          return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17.0),
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
                                _buildEachVetements(context, listeHaut[index]),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Vetement(
                                                  login: widget.login,
                                                  vetementTitre:
                                                      listeHaut[index])));
                                    },
                                    child: Text(
                                      listeHaut[index],
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                ),
                                _buildTailleVetements(
                                    context, listeHaut[index]),
                                _buildPrixVetements(context, listeHaut[index]),
                              ]));
                        }),
                      ),
                    ),
                  ),
                  NotificationListener<ScrollNotification>(
                    child: Scaffold(
                      body: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: List.generate(listeBas.length, (index) {
                          return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17.0),
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
                                _buildEachVetements(context, listeBas[index]),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Vetement(
                                                  login: widget.login,
                                                  vetementTitre:
                                                      listeBas[index])));
                                    },
                                    child: Text(
                                      listeBas[index],
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                ),
                                _buildTailleVetements(context, listeBas[index]),
                                _buildPrixVetements(context, listeBas[index]),
                              ]));
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
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
}
