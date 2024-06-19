class Resident {
  //Account Detail
  String name, email, phoneno;
  //Resident Detail
  String residentname, block, floor;
  int houseno;

  Resident(
      {required this.name,
      required this.email,
      required this.phoneno,
      required this.residentname,
      required this.block,
      required this.floor,
      required this.houseno});

  Resident.defaultConstructor()
      : name = '',
        email = '',
        phoneno = '',
        residentname = '',
        block = '',
        floor = '',
        houseno = 0;

  // Getters
  String get getname => name;
  String get getemail => email;
  String get getphoneno => phoneno;
  String get getresidentname => residentname;
  String get getblock => block;
  String get getfloor => floor;
  int get gethouseno => houseno;

  // Setters
  set setName(String newName) {
    name = newName;
  }

  set setEmail(String newEmail) {
    email = newEmail;
  }

  set setPhoneno(String newPhoneno) {
    phoneno = newPhoneno;
  }

  set setresidentname(String newresidentname) {
    residentname = newresidentname;
  }

  set setblock(String newblock) {
    block = newblock;
  }

  set setfloor(String newfloor) {
    floor = newfloor;
  }

  set sethouseno(int newhouseno) {
    houseno = houseno;
  }

  static Resident fromMap(Map<String, dynamic> map) {
    return Resident(
      name: map['name'],
      email: map['email'],
      phoneno: map['phoneno'],
      residentname: map['residentname'],
      block: map['block'],
      floor: map['floor'],
      houseno: map['housenumber'],
    );
  }
}
