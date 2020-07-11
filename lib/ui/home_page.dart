import 'package:flutter/material.dart';
import 'package:flutter_contatos/helpers/contact_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  /* Contact c = Contact();
    c.name = "Wellington";
    c.email="welligton@gmail.com";
    c.phone = "1194443655";
    c.img = "imgteste";
    helper.saveContact(c);
   print(c);*/
   helper.getAllContacts().then( (lsita) {
     print('teste!!!!');
     print(lsita);
   });

  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white);
  }
}
