class User {
  final int? id;
  final String name;
  final String email;
  final String gender;
  final String status;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });
  // deserialize the JSON object to a User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      status: json['status'],
    );
  }
  // serialize the User object to a JSON object
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'gender': gender,
        'status': status,
      };
}
