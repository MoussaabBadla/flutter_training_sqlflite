import 'package:flutter/material.dart';

import 'controller/person_contreller.dart';
import 'modules/person.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController idController;

  PersonController personController = PersonController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    idController = TextEditingController();
    getPersons();

    super.initState();
  }

  List<Person> persons = [];

  void getPersons() async {
    persons = await personController.getAll();
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sqlite'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Invalid name';
                  }
                },
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Invalid email';
                  }
                },
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: idController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Invalid id';
                  }
                },
                decoration: InputDecoration(labelText: 'ID'),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Person person = Person(
                            id: int.parse(idController.text),
                            name: nameController.text,
                            email: emailController.text,
                          );
                          await personController.create(person);
                        }
                      },
                      child: const Text("Insert")),
                  ElevatedButton(
                      onPressed: () {
                        getPersons();
                      },
                      child: Text("Get Persons"))
                ],
              ),
              if (persons.isNotEmpty)
                Column(
                  children: List.generate(persons.length,
                      (index) => Text(persons[index].toString())),
                )
            ],
          ),
        ));
  }
}


// Transition Animation

// class Page2 extends StatelessWidget {
//   const Page2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Text("Page 2 "),
//       ),
//     );
//   }
// }



// Route _createRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(1.0, 0.0);
//       const end = Offset(0.0, 0.0);
//       const curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }
