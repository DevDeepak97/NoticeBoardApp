import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var firestoredb =
      FirebaseFirestore.instance.collection("MyData").snapshots(); 
  late TextEditingController nameinput = new TextEditingController();
  late TextEditingController titleinput = new TextEditingController();
  late TextEditingController descinput = new TextEditingController();

  @override
  void initState() {
    super.initState();
    nameinput = new TextEditingController();
    titleinput = new TextEditingController();
    descinput = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("BORAD DATA"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialogox(context);
          },
          child: Icon(Icons.edit),
        ),
        body: StreamBuilder(
          stream: firestoredb,
          builder: (context, AsyncSnapshot snapshot) {
            if (!(snapshot.hasData)) {
              return CircularProgressIndicator();
            } else {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, int index) {
                    return CustomCard(snapshot: snapshot.data, index: index);
                  });
            }
          },
        ));
  }

  showDialogox(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(12),
        content: Column(
          children: [
            Text("ENTER THE REQUIRED FEILDS"),
            Expanded(
                child: TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(labelText: "Your Name"),
              controller: nameinput, 
            )),
            Expanded(
                child: TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(labelText: "Title"),
              controller: titleinput,
            )),
            Expanded(
                child: TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(labelText: "Description: "),
              controller: descinput,
            ))
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                nameinput.clear();
                titleinput.clear();
                descinput.clear();
                Navigator.pop(context);
              },
              child: Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                if (nameinput.text.isNotEmpty &&
                    titleinput.text.isNotEmpty &&
                    descinput.text.isNotEmpty) {
                  FirebaseFirestore.instance.collection("MyData").add({
                    "name": nameinput.text,
                    "Description": descinput.text,
                    "Title": titleinput.text,
                    "timestamp": new DateTime.now()
                  }).then((response) {
                    print(response.id);
                    var docid = response.id;
                    Navigator.pop(context);
                    nameinput.clear();
                    titleinput.clear();
                    descinput.clear();
                  }).catchError((error) => print(error));
                }
              },
              child: Text("Save"))
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final int index;
  final QuerySnapshot snapshot;
  const CustomCard({Key? key, required this.snapshot, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var docId = snapshot.docs[index].id;
    var td = DateTime.fromMillisecondsSinceEpoch(
        snapshot.docs[index]["timestamp"].seconds * 1000);
    var dateformat = new DateFormat("EEEE,MMM,d,y").format(td);

    late TextEditingController nameinput =
        new TextEditingController(text: snapshot.docs[index]["name"]);
    late TextEditingController titleinput =
        new TextEditingController(text: snapshot.docs[index]["Title"]);
    late TextEditingController descinput =
        new TextEditingController(text: snapshot.docs[index]["Description"]);

    return Container(
      height: 170,
      child: Card(
        elevation: 10,
        child: Column(
          children: [
            ListTile(
              title: Text(snapshot.docs[index]["Title"]),
              subtitle: Text(snapshot.docs[index]["Description"]),
              leading: CircleAvatar(
                radius: 35,
                child: Text(
                    snapshot.docs[index]["Title"].toString()[0].toUpperCase()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("BY: ${snapshot.docs[index]["name"]}  "),
                  Text(dateformat),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          contentPadding: EdgeInsets.all(10),
                          content: Column(
                            children: [
                              Text("UPADTE THE CURRENT RECORD"),
                              Expanded(
                                  child: TextField(
                                autofocus: true,
                                autocorrect: true,
                                decoration:
                                    InputDecoration(labelText: "Your Name"),
                                controller: nameinput, 
                              )),
                              Expanded(
                                  child: TextField(
                                autofocus: true,
                                autocorrect: true,
                                decoration: InputDecoration(labelText: "Title"),
                                controller: titleinput,
                              )),
                              Expanded(
                                  child: TextField(
                                autofocus: true,
                                autocorrect: true,
                                decoration:
                                    InputDecoration(labelText: "Description: "),
                                controller: descinput,
                              ))
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  nameinput.clear();
                                  titleinput.clear();
                                  descinput.clear();
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")),
                            ElevatedButton(
                                onPressed: () {
                                  if (nameinput.text.isNotEmpty &&
                                      titleinput.text.isNotEmpty &&
                                      descinput.text.isNotEmpty) {
                                    FirebaseFirestore.instance
                                        .collection("MyData")
                                        .doc(docId)
                                        .update({
                                      "name": nameinput.text,
                                      "Description": descinput.text,
                                      "Title": titleinput.text,
                                      "timestamp": new DateTime.now()
                                    }).then((response) {
                                      Navigator.pop(context);
                                      nameinput.clear();
                                      titleinput.clear();
                                      descinput.clear();
                                    }).catchError((error) => print(error));
                                  }
                                },
                                child: Text("UPDATE"))
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit_location_outlined,
                      size: 20,
                    )),
                IconButton(
                    onPressed: () async {
                      var fbOb =
                          FirebaseFirestore.instance.collection("MyData");
                      await fbOb.doc(docId).delete();
                      print("ID : $docId");
                    },
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      size: 20,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
