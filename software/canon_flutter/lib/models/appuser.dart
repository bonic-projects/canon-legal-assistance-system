class AppUser {
  final String id;
  final String fullName;
  // final String token;
  final DateTime registeredOn;
  final String email;
  // final int age;
  // final String gender;
  final String userRole;
  final String specialization;
  final List<int> ratings;

  AppUser({
    required this.id,
    required this.fullName,
    // required this.token,
    required this.registeredOn,
    required this.email,
    // required this.age,
    // required this.gender,
    required this.userRole,
    required this.specialization,
    required this.ratings,
  });

  AppUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        // token = data['token'] ?? "",
        registeredOn = data['tokenTime'] != null
            ? data['tokenTime'].toDate()
            : DateTime(2022),
        email = data['email'],
        // age = data['age'],
        // gender = data['gender'],
        userRole = data['userRole'] ?? "user",
        specialization = data['specialization'] ?? "",
        ratings =
            data['ratings'] != null ? data['ratings'].cast<int>() : <int>[];

  Map<String, dynamic> toJson(keyword) {
    return {
      'id': id,
      'fullName': fullName,
      // 'token': token,
      'tokenTime': registeredOn,
      'keyword': keyword,
      'email': email,
      // 'age': age,
      // 'gender': gender,
      'userRole': userRole,
      'ratings': [],
    };
  }
}
