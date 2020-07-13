import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String nameTableContact = "ContactTable";
final String idColumm = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColum = "phoneColum";
final String imgColum = "imgColum";

class ContactHelper {
  static final ContactHelper _instace = ContactHelper.internal();

  factory ContactHelper() => _instace;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async{
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Contact> saveContact(Contact contact) async{
    Database dbContact = await db;
    contact.id = await dbContact.insert(nameTableContact, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async{
    Database dbContact = await db;

    List<Map> maps = await dbContact.query(nameTableContact,
    columns: [idColumm,nameColumn,emailColumn,phoneColum,imgColum],
      where: "$idColumm = ?",
      whereArgs: [id]
    );
    if(maps.length>0){
      return Contact.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<int> deleteContact(int id) async{

    Database dbContact = await db;
    return await dbContact.delete(nameTableContact,where: "$idColumm = ?",whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async{
    Database dbContact = await db;
    return await dbContact.update(nameTableContact, contact.toMap(),where: "$idColumm = ?",whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async{
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $nameTableContact");
    List<Contact> listContact  = List();
    for(Map m in listMap){
      Contact contact = Contact.fromMap(m);
      listContact.add(contact);
    }
    return listContact;
  }

  Future<int> getNumber() async{
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $nameTableContact"));
  }

  Future close() async{
    Database dbContact = await db;
    dbContact.close();
  }

   Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contact.db");
    return openDatabase(
        path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $nameTableContact($idColumm INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColum TEXT, $imgColum TEXT)");
    });
  }

  Future deleteTable() async{
    Database dbContact = await db;
    return dbContact.execute("DROP TABLE IF EXISTS $nameTableContact");
  }

  Future createTable() async{
    Database dbContact = await db;
    return dbContact.execute("CREATE TABLE $nameTableContact($idColumm INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColum TEXT, $imgColum TEXT)");
  }


}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map["idColumn"];
    name = map["nameColumn"];
    email = map["emailColumn"];
    phone = map["phoneColum"];
    img = map["imgColum"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColum: phone,
      imgColum: img
    };
    if (id != null) {
      map[idColumm] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email:$email, phone:$phone, img:$img)";
  }
}
