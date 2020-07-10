import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
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

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contact.db");
    return openDatabase(
        path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $nameTableContact($idColumm INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColum TEXT)")
    });
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact.fromMap(Map map) {
    id = map["idColumn"];
    name = map["nameColumn"];
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
    if (map[idColumm] != null) {
      map[idColumm] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email:$email, phone:$phone, img:$img)";
  }
}
