class UserModel3 {
  String p1;
  String uid;

  UserModel3({
     required this.p1,
    required this.uid,
  });

  // from map
  factory UserModel3.fromMap(Map<String, dynamic> map) {
    return UserModel3(
      p1: map['p1'] ?? '',
      uid: map['uid'] ?? '',
     );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "p1": p1,
      "uid": uid,
    };
  }
}
