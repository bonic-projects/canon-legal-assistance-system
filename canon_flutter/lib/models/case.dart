class CaseModel {
  String id; // Document ID
  String name;
  String caseClass;
  String caseType;
  String jurisdiction;
  List<String> partiesInvolved;
  String language;
  List<String> statutesInvolved;
  String fileLink;
  String format;
  DateTime date;

  CaseModel({
    required this.id,
    required this.name,
    required this.caseClass,
    required this.caseType,
    required this.jurisdiction,
    required this.partiesInvolved,
    required this.language,
    required this.statutesInvolved,
    required this.fileLink,
    required this.format,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'caseClass': caseClass,
      'caseType': caseType,
      'jurisdiction': jurisdiction,
      'partiesInvolved': partiesInvolved,
      'language': language,
      'statutesInvolved': statutesInvolved,
      'fileLink': fileLink,
      'format': format,
      'date': date,
    };
  }

  factory CaseModel.fromMap(Map<String, dynamic> map) {
    return CaseModel(
      id: map['id'],
      name: map['name'],
      caseClass: map['caseClass'],
      caseType: map['caseType'],
      jurisdiction: map['jurisdiction'],
      partiesInvolved: List<String>.from(map['partiesInvolved']),
      language: map['language'],
      statutesInvolved: List<String>.from(map['statutesInvolved']),
      fileLink: map['fileLink'],
      format: map['format'],
      date: map['date'] != null ? map['date'].toDate() : DateTime(2022),
    );
  }
}
