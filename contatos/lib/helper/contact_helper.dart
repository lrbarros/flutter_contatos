import 'package:sqflite/sqflite.dart';

final String idColumn ="idColumn";
final String nameColumn ="nameColumn";
final String phoneColumn ="phoneColumn";
final String emailColumn = "emailColumn";
final String imgColumn ="imgColumn";


class ContactHelper{

}

class Contact{

  int? id;
  String? name;
  String? phone;
  String? email;
  String? img;

  Contact();

  Contact.fromMap(Map map){
    id= map[idColumn];
    name = map[nameColumn];
    phone = map[phoneColumn];
    email = map[emailColumn];
    img = map[imgColumn];
  }

  Map toMap(Contact c){
    Map map = Map();
    map[nameColumn] = name;
    map[phoneColumn] = phone;
    map[emailColumn] = email;
    map[imgColumn] = img;
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return   "id: $id , name: $name, phone: $phone, email: $email, img: $img";
  }
}