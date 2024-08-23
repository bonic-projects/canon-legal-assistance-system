class Chat {
  final String id;
  final String name;
  final List<String> members;
  final DateTime createdAt;
  int rating;

  Chat({
    required this.id,
    required this.name,
    required this.members,
    required this.createdAt,
    required this.rating,
  });

  static Chat fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      rating: json['rating'] ?? 0,
      members: List<String>.from(json['members']),
      createdAt: json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'createdAt': createdAt,
      'rating': rating,
    };
  }

  static Chat create(
    String name,
    List<String> members,
  ) {
    return Chat(
      id: '',
      name: name,
      members: members,
      rating: 0,
      createdAt: DateTime.now(),
    );
  }
}
