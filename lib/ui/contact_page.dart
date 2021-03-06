import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_contatos/helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final picker = ImagePicker();

  Contact _editedContact;

  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPhone =  TextEditingController();

  final _focusName = FocusNode();

  bool _editation = false;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _controllerEmail.text = _editedContact.email;
      _controllerName.text = _editedContact.name;
      _controllerPhone.text = _editedContact.phone;
    }


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _request_pop,
      child: Scaffold(
        appBar: AppBar(
            title: Text(_editedContact.name ?? "Novo Contato"),
            backgroundColor: Colors.red,
            centerTitle: true),
        floatingActionButton: FloatingActionButton(
            onPressed: (){
              if(_editedContact.name != null && _editedContact.name.isNotEmpty){
                Navigator.pop(context,_editedContact);
              }else{
                FocusScope.of(context).requestFocus(_focusName);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child:     Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact.img != null
                                ? FileImage(File(_editedContact.img))
                                : AssetImage("images/person.png"),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  onTap: (){
                    picker.getImage(source: ImageSource.camera).then((value) {
                      if(value == null){
                        return null;
                      }else
                        {
                          setState(() {
                            _editedContact.img = value.path;
                            _editation=true;
                          });
                        }
                    } );
                  },
                ),
                TextField(
                  focusNode: _focusName,
                  controller: _controllerName,
                  onChanged: (value){
                    setState(() {
                      _editation = true;
                      _editedContact.name = value;
                    });

                  },
                  decoration: InputDecoration(
                      labelText: "Nome"
                  ),
                ),
                TextField(
                    controller: _controllerEmail,
                    onChanged: (value){
                      _editation = true;
                      _editedContact.email = value;
                    },
                    decoration: InputDecoration(
                        labelText: "Email"
                    ),
                    keyboardType: TextInputType.emailAddress
                ),
                TextField(
                    controller: _controllerPhone,
                    onChanged: (value){
                      _editation = true;
                      _editedContact.phone = value;
                    },
                    decoration: InputDecoration(
                        labelText: "Phone"
                    ),
                    keyboardType: TextInputType.phone
                )
              ],
            )
        ),
      ),
    );
  }

  Future<bool> _request_pop(){
    if(_editation){
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            content: Text("Se sair as alterações serão perdidas"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }
}
