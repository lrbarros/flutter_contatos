import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String phoneColumn = "phoneColumn";
final String emailColumn = "emailColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db;
  }

}

Future<Database> initDb() async {
  final dataBasePath = await getDatabasesPath();
  final path = join(dataBasePath, "contacts.bd");
  return openDatabase(
      path, version: 1, onCreate: (Database db, int newerVersion) async {
    await db.execute(
        "CREATE TABLE $contactTable( $idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn"
            " $phoneColumn TEXT, $imgColumn TEXT)"
    );
  });

}

class Contact {

  int? id;
  String? name;
  String? phone;
  String? email;
  String? img;

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    phone = map[phoneColumn];
    email = map[emailColumn];
    img = map[imgColumn];
  }

  Map toMap(Contact c) {
    Map map = Map();
    map[nameColumn] = name;
    map[phoneColumn] = phone;
    map[emailColumn] = email;
    map[imgColumn] = img;
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "id: $id , name: $name, phone: $phone, email: $email, img: $img";
  }
}