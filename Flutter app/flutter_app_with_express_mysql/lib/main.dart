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
                      });
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add new TODO')),
              ]),
            )),
            FutureBuilder<List<dynamic>>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return Expanded(
                    child: (ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index]['text']),
                          // trailing: Row(
                          //   children: [
                          //     IconButton(
                          //         onPressed: () {}, icon: Icon(Icons.edit))
                          //   ],
                          // ),
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

// class Todo {
//   final int id;
//   final String text;
//   final int done;

//   const Todo({
//     required this.id,
//     required this.text,
//     required this.done,
//   });

//   factory Todo.fromJson(List json) {
//     return Todo(
//       id: json[0]['id'],
//       text: json[0]['text'],
//       done: json[0]['done'],
//     );
//   }
// }

Future<List<dynamic>> getData() async {
  final response = await http.get(Uri.parse('http://172.20.10.3:3000/'));
  // final response =
  // await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
  // print(response.body);
  final List data = await jsonDecode(response.body.toString());
  // final dataObj = Todo.fromJson(data);
  // print(dataObj);
  // print(dataObj.text);
  return data;
}

putData(String text) async {
  await http.post(Uri.parse('http://172.20.10.3:3000/addtodo'),
      body: {'text': text, 'done': '0'});
}
