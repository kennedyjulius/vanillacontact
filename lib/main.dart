import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:  ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class Contact {
  final String name;
  Contact({
    required this.name,
  });

  
  
}
class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;
  
  final List<Contact> _contacts = [];

  int get length => _contacts.length;

  void add({required Contact contact}) {
    _contacts.add(contact);
  }

  void remove({required Contact contact}) {
    _contacts.remove(contact);
  }

  Contact? contact ({required int atIndex}) =>
   _contacts.length > atIndex ? _contacts[atIndex] : null;
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: ListView.builder(
        itemCount: contactBook.length,
        itemBuilder: (BuildContext context, int index) {
          final contact = contactBook.contact(atIndex: index)!;
        return  ListTile(
          title: Text(contact.name),
        );
       },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewContactView(),));
        },
        child: Icon(Icons.add),
        ),
    );
  }
}



class NewContactView extends StatefulWidget {
  NewContactView({Key? key}) : super(key: key);

  @override
  _NewContactViewState createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  @override
  Widget build(BuildContext context) {
    late final TextEditingController _controller;
    
    @override
    void initState() { 
      super.initState();
      _controller = TextEditingController();
    }
    @override
    void dispose() { 
      _controller.dispose();
      super.dispose();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('add new contact'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Enter a New Contact name here"
            ),
          ),
          TextButton(onPressed: () {
           final contact = Contact(name: _controller.text);
            ContactBook().add(contact: contact);
            Navigator.of(context).pop();
            
          }, child: Text("add contact"))
        ],
      ),
    );
  }
}
