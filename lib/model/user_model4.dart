class UserModel4 {
  String bankname;
  String branch;
  String accountnumber;
  String ifsc;
  String bankstmt;
  String uid;

  UserModel4({
    required this.bankname,
    required this.branch,
    required this.accountnumber,
    required this.ifsc,
    required this.bankstmt,
    required this.uid,
  });

  // from map
  factory UserModel4.fromMap(Map<String, dynamic> map) {
    return UserModel4(
      bankname: map['bankname'] ?? '',
      branch: map['branch'] ?? '',
      accountnumber: map['accountnumber'] ?? '',
      ifsc: map['ifsc'] ?? '',
      bankstmt: map['bankstmt'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "bankname": bankname,
      "branch": branch,
      "accountnumber": accountnumber,
      "ifsc": ifsc,
      "bankstmt": bankstmt,
      "uid": uid,
    };
  }
}
