import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
  final String id;
  final String name;
  Contact({
    required this.name,
  }): id =  Uuid().v4();

  
  
}
class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contact> _contacts = [];

  int get length => value.length;

  void add({required Contact contact}) {
    final contacts = value;
    contacts.add(contact);
    notifyListeners(); // Notify listeners when the list changes
  }

  void remove({required Contact contact}) {
    final contacts = value;
    if (contacts.contains(contact)){
      contacts.remove(contact);
      notifyListeners();
    }
     // Notify listeners when the list changes
  }

  Contact? contact({required int atIndex}) =>
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
    //final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          final contacts = value as List<Contact>;
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {
          final contact = contacts[index];
          return  Dismissible(
            onDismissed: (direction) {
              contacts.remove(contact);
            },
            key: ValueKey(contact.id),
            child: Material(
              color: Colors.white,
              elevation: 6.0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: ListTile(
                  title: Text(contact.name),
                ),
              ),
            ),
          );
         },
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
    // ignore: no_leading_underscores_for_local_identifiers
    late final TextEditingController _controller = TextEditingController();
  
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
