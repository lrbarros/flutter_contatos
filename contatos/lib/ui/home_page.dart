import 'dart:io';

import 'package:contatos/helper/contact_helper.dart';
import 'package:contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderAz, orderZa }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contatos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) {
              return <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem(
                  child: Text("Ordenar de A-Z"),
                  value: OrderOptions.orderAz,
                ),
                const PopupMenuItem(
                  child: Text("Ordenar de Z-A"),
                  value: OrderOptions.orderZa,
                ),
              ];
            },
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showContactPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img!.toString()))
                        : AssetImage("images/person.png") as ImageProvider,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contacts[index].name ?? "",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    contacts[index].email ?? "",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    contacts[index].phone ?? "",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (contacts[index].phone != null &&
                              contacts[index].phone!.isNotEmpty) {
                            launch("tel:" + contacts[index].phone!);
                            Navigator.pop(context);
                          } else {
                            _alertPhone();
                          }
                        },
                        child: Text(
                          "Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                        ),
                        onPressed: () {
                          helper.deleteContact(contacts[index].id!);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _alertPhone() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nenhum telefone cadastrado!!"),
          content: Text("Por favor cadastre um telefone"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Fechar")),
          ],
        );
      },
    );
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAz:
        setState(() {
          contacts.sort((a, b) {
            return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
          });
        });
        break;
      case OrderOptions.orderZa:
        setState(() {
          contacts.sort((a, b) {
            return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
          });
        });
        break;
    }
  }
}
