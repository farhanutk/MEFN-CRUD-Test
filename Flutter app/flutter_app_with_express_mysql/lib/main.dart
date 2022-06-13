import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Express MySQL CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Express MySQL CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textController = TextEditingController();
  late TextEditingController editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Form(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'TODO',
                  ),
                  controller: textController,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        putData(textController.text);
                        textController.clear();
                        FocusScope.of(context).unfocus();
                      });
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add TODO')),
              ]),
            )),
            FutureBuilder<List<dynamic>>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: (ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index]['text']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    editTextController.text =
                                        snapshot.data![index]['text'];
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Edit TODO"),
                                              content: TextFormField(
                                                autofocus: true,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'TODO',
                                                ),
                                                controller: editTextController,
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        updateData(
                                                            snapshot.data![
                                                                index]['id'],
                                                            editTextController
                                                                .text);
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: Text('Save changes'))
                                              ],
                                            ));
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      deleteData(snapshot.data![index]['id']);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        );
                      },
                      itemCount: snapshot.data!.length,
                    )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
              future: getData(),
            ),
          ],
        ));
  }
}

Future<List<dynamic>> getData() async {
  final response = await http.get(Uri.parse('http://172.20.10.3:3000/'));
  final List data = await jsonDecode(response.body.toString());
  return data;
}

putData(String text) async {
  await http.post(Uri.parse('http://172.20.10.3:3000/addtodo'),
      body: {'text': text, 'done': '0'});
}

deleteData(int id) async {
  await http
      .delete(Uri.parse('http://172.20.10.3:3000/deletetodo/' + id.toString()));
}

updateData(int id, String text) async {
  await http.put(Uri.parse('http://172.20.10.3:3000/updatetodo'),
      body: {'id': '$id', 'text': text});
}
