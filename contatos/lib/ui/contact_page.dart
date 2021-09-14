import 'dart:io';

import 'package:contatos/helper/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact? _editedContact;

  @override
  void initState() {
      super.initState();

      if(widget.contact == null){
        _editedContact = Contact();
      }else{
        //duplica o contato (copia) 
        _editedContact = Contact.fromMap( widget.contact!.toMap());
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact!.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editedContact!.img != null
                        ? FileImage(File(_editedContact!.img.toString()))
                        : AssetImage("images/person.png") as ImageProvider,
                  ),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Nome" ),
              onChanged: (text){

              },
            ),

          ],
        )
        ,
      ),
    );

  }


}
