import 'dart:typed_data';

class Blog {
  final int id; // Ajout de l'identifiant
  final String titre;
  final String description;
  final String lieu;
  final String image;
  final String date;
  final double prix;

  Blog({
    required this.id,
    required this.titre,
    required this.description,
    required this.lieu,
    required this.image,
    required this.date,
    required this.prix,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] != null ? json['id'] as int : 0,
      titre: json['titre'] != null ? json['titre'] as String : '',
      description: json['description'] != null ? json['description'] as String : '',
      lieu: json['lieu'] != null ? json['lieu'] as String : '',
      image: json['image'] != null ? json['image'] as String : '',
      date: json['date'] != null ? json['date'] as String : '',
      prix: (json['prix'] != null ? (json['prix'] as num).toDouble() : 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'lieu': lieu,
      'image': image,
      'date': date,
      'prix': prix,
    };
  }
}
