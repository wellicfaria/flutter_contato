import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contatos/helpers/contact_helper.dart';
import 'package:flutter_contatos/ui/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz,orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> list_contact = List();

  @override
  void initState() {
    super.initState();
    helper.getAllContacts().then((lista) {
      setState(() {
        list_contact = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Contatos"),
            backgroundColor: Colors.red,
            centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(child: Text("Ordenar de A a Z"), value: OrderOptions.orderaz),
                  const PopupMenuItem<OrderOptions>(child: Text("Ordenar de Z a A"), value: OrderOptions.orderza)
                ],
              onSelected: _orderList,
            )
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showContactPage();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.red),
        body: ListView.builder(
            itemBuilder: (context, index) {
              return _contactCard(context, index);
            },
            padding: EdgeInsets.all(10),
            itemCount: list_contact.length));
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: list_contact[index].img != null
                            ? FileImage(File(list_contact[index].img))
                            : AssetImage("images/person.png"),
                      fit: BoxFit.cover
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(list_contact[index].name ?? "", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(list_contact[index].email ?? "", style: TextStyle(fontSize: 18)),
                    Text(list_contact[index].phone ?? "", style: TextStyle(fontSize: 18))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
       // _showContactPage(contact: list_contact[index]);

        _showOptions(context,index);
      },
    );
  }

  void   _showOptions(context,index){
    showModalBottomSheet(context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text("Ligar",style: TextStyle(color: Colors.red,fontSize: 20)),
                        onPressed: (){
                          launch("tel:${list_contact[index].phone}");
                          Navigator.pop(context);
                        },
                      )
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: FlatButton(
                          child: Text("Editar",style: TextStyle(color: Colors.red,fontSize: 20)),
                          onPressed: (){
                            Navigator.pop(context);
                            _showContactPage(contact:list_contact[index]);
                          },
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: FlatButton(
                          child: Text("Excluir",style: TextStyle(color: Colors.red,fontSize: 20)),
                          onPressed: (){
                            helper.deleteContact(list_contact[index].id);
                            setState(() {
                              list_contact.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                        )
                    )
                  ]
                ),
              );
            }
          );
        }
    );
  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:

        list_contact.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        list_contact.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;

    }
    setState(() {

    });
  }

  void _showContactPage({Contact contact}) async  {
   final contact_from_page = await Navigator.push(context, MaterialPageRoute(
     builder: (context) => ContactPage(contact: contact)
   ));
   if(contact_from_page != null){
     if (contact != null){
       await helper.updateContact(contact_from_page);
     }else{
       await helper.saveContact(contact_from_page);
     }
   }

   helper.getAllContacts().then((lista) {
     setState(() {
       list_contact = lista;
     });
   });

  }
}
