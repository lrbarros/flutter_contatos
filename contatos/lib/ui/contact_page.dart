import 'dart:io';

import 'package:contatos/helper/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _userEdited = false;
  Contact? _editedContact;

  final _focusName = FocusNode();

  @override
  void initState() {
      super.initState();

      if(widget.contact == null){
        _editedContact = Contact();
      }else{
        //duplica o contato (copia) 
        _editedContact = Contact.fromMap( widget.contact!.toMap());

        //inicializa campos da tela com valores recebidos
        _nameController.text =  _editedContact!.name.toString();
        _emailController.text = _editedContact!.email.toString();
        _phoneController.text = _editedContact!.phone.toString();
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
        onPressed: (){
          //verifica nulo e vazio
          if(_editedContact!.name !=null &&  _editedContact!.name!.isNotEmpty ){
              Navigator.pop(context,_editedContact);
          }else{
            //focus no campo inputText
            FocusScope.of(context).requestFocus(_focusName);
          }
        },
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
                _userEdited = true;
                setState(() {
                  _editedContact!.name = text;
                });
              },
              focusNode: _focusName,
              controller: _nameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (text){
                _userEdited = true;
                _editedContact!.email = text;
              },
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Telefone"),
              onChanged: (text){
                _userEdited = true;
                _editedContact!.phone = text;
              },
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            )
          ],
        )
        ,
      ),
    );

  }


}
