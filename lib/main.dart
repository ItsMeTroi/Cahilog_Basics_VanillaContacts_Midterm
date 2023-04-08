import 'package:flutter/material.dart';

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
  final String name;
  const Contact({
    required this.name,
  });
}

class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contact> _contacts = [];

  int get length => _contacts.length;

  void add({required Contact contact}){
     _contacts.add(contact);
  }

  void remove({required Contact contact}){
     _contacts.remove(contact);
  }

  Contact? contact({required int atIndex}) =>
     _contacts.length > atIndex ? _contacts[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ListView.builder(
        itemCount: contactBook.length,
        itemBuilder: (context, index){
          final contact = contactBook.contact(atIndex: index)!; 
          return ListTile(
            title: Text(contact.name),
          );
        },
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

