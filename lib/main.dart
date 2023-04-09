// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/new-contact':(context) => NewContactView(),
      },
    ),
  );
}

class Contact {
  final String id;
  final String name;
  Contact({
    required this.name,
  }) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>>{
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  int get length => value.length;

  void add({required Contact contact}){
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  void remove({required Contact contact}){
    final contacts = value;
    if (contacts.contains(contact)){
      contacts.remove(contact);
      notifyListeners();
    }
  }

  Contact? contact({required int atIndex}) =>
     value.length > atIndex ? value[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (contact, value, child){
          // ignore: unnecessary_cast
          final contacts = value as List<Contact>;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index){
              final contact = contacts[index]; 
              return Dismissible(
                onDismissed: (direction){
                  ContactBook().remove(contact: contact);
                },
                key: ValueKey(contact.id),
                  child: Material(
                    color: Colors.white,
                    elevation: 6.0,
                    child: ListTile(
                     title: Text(contact.name),
                    ),
                  ),
                );
            },
          );
        }
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            await Navigator.of(context).pushNamed('/new-contact');
          }, 
          child: const Icon(Icons.add),
        ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class NewContactView extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _NewContactViewState createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {

  late final TextEditingController _controller;

  @override
  void initState(){
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new contact'),
        ),
        body: 
          Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Enter a new contact name here',
                ),
              ),
              TextButton(onPressed: (){
                  final contact = Contact(name: _controller.text);
                  ContactBook().add(contact: contact);
                  Navigator.of(context).pop();
              },
               child: const Text('Add Contact'),
              )
            ],
          ),
    );
  }
}

