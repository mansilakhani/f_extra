import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/helpers/cloud_firestore_helper.dart';
import 'package:firebase_app/helpers/firebase_auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  /// Update Controller ...
  TextEditingController update_nameController = TextEditingController();
  TextEditingController update_ageController = TextEditingController();
  TextEditingController update_cityController = TextEditingController();

  String? name;
  int? age;
  String? city;

  @override
  Widget build(BuildContext context) {
    User? data = ModalRoute.of(context)!.settings.arguments as User?;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/firebaselogo.png",
              scale: 13,
            ),
            const SizedBox(width: 10),
            const Text(
              "Firebase App",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 24),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.signOut();

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login_page', (route) => false);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.7),
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            CircleAvatar(
              radius: 60,
              // backgroundImage: NetworkImage("${data!.photoURL}"),
              backgroundImage: (data!.photoURL != null)
                  ? NetworkImage("${data!.photoURL}")
                  : null,
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
              color: Colors.grey,
            ),
            (data!.displayName != null)
                ? Text("Name: ${data!.displayName}")
                : const Text("Name: ---"),
            (data!.email != null)
                ? Text("Email: ${data!.email}")
                : const Text("Email: ---"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          validateandInsert();

          // CloudFirestoreHelper.cloudFirestoreHelper.insertRecord();
        },
      ),
      // body: Container(
      //   alignment: Alignment.center,
      //   child: const Text(
      //     "Welcome to HomePage 🙂 ...",
      //     style: TextStyle(
      //         color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
      //   ),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectRecords(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;
            List<QueryDocumentSnapshot> documents = data!.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, i) {
                  ///
                  // Map<String, dynamic> data =
                  //     documents[i].data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Text("${i + 1}"),

                        /// Original id print ...
                        //leading: Text("${documents[i].id}"),

                        title: Text("${documents[i]['name']}"),

                        subtitle: Text(
                            "${documents[i]['city']}\n ${documents[i]['age']}"),

                        //trailing: Text("Age : ${documents[i]['age']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  await CloudFirestoreHelper
                                      .cloudFirestoreHelper
                                      .deleteRecord(id: documents[i].id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  validateandInsert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          ElevatedButton(
              onPressed: () {
                if (insertFormKey.currentState!.validate()) {
                  insertFormKey.currentState!.save();

                  Map<String, dynamic> records = {
                    'name': name,
                    'age': age,
                    'city': city,
                  };

                  CloudFirestoreHelper.cloudFirestoreHelper
                      .insertRecord(data: records);
                }
                nameController.clear();
                ageController.clear();
                cityController.clear();

                setState(() {
                  name = null;
                  age = null;
                  city = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Add") //Insert,
              ),
          ElevatedButton(
            onPressed: () {
              nameController.clear();
              ageController.clear();
              cityController.clear();

              setState(() {
                name = null;
                age = null;
                city = null;
              });
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          )
        ],
        title: const Center(child: Text("Insert Record")),
        content: Form(
          key: insertFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                validator: (val) => (val!.isEmpty) ? "Enter name first" : null,
                onSaved: (val) {
                  setState(() {
                    name != val;
                  });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter name here...",
                    labelText: "Name"),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: ageController,
                validator: (val) => (val!.isEmpty) ? "Enter age first" : null,
                onSaved: (val) {
                  setState(() {
                    age != val;
                  });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter age here...",
                    labelText: "Age"),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: cityController,
                validator: (val) => (val!.isEmpty) ? "Enter city first" : null,
                onSaved: (val) {
                  setState(() {
                    city != val;
                  });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter city here...",
                    labelText: "City"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateData() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Update Record"),
              content: Form(
                key: updateFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: update_nameController,
                      validator: (val) =>
                          (val!.isEmpty) ? "Enter name first" : null,
                      onSaved: (val) {
                        setState(() {
                          // name != val;
                        });
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter name here...",
                          labelText: "Name"),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: update_ageController,
                      validator: (val) =>
                          (val!.isEmpty) ? "Enter age first" : null,
                      onSaved: (val) {
                        setState(() {
                          // age != val;
                        });
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter age here...",
                          labelText: "Age"),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: update_cityController,
                      validator: (val) =>
                          (val!.isEmpty) ? "Enter city first" : null,
                      onSaved: (val) {
                        setState(() {
                          // city != val;
                        });
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter city here...",
                          labelText: "City"),
                    ),
                  ],
                ),
              ),
            ));
  }
}
