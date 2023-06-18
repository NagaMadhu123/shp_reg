class UserModel5 {
  String sname;
  String type;
  String supi;
  String sphn;
  String simg;
  String agent;
  String loc;

  UserModel5({
    required this.sname,
    required this.type,
    required this.supi,
    required this.sphn,
    required this.simg,
    required this.agent,
    required this.loc,
  });

  // from map
  factory UserModel5.fromMap(Map<String, dynamic> map) {
    return UserModel5(
      sname: map['sname'] ?? '',
      type: map['type'] ?? '',
      supi: map['supi'] ?? '',
      sphn: map['sphn'] ?? '',
      simg: map['simg'] ?? '',
      agent: map['agent'] ?? '',
      loc: map['loc'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "sname": sname,
      "type": type,
      "supi": supi,
      "sphn": sphn,
      "simg": simg,
      "agent": agent,
      "loc": loc,

    };
  }
}
