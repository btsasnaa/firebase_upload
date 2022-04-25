class ExamUser {
  final String uid;
  String email;
  String name;

  ExamUser({
    required this.uid,
    this.email = '',
    this.name = '',
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['name'] = this.name;
    return data;
  }
}
