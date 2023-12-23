class Produit {
  final String nom;
  final String image;
  final double prix;
  final int quantiteEnStock;
  final String dateRecolte;
  final String proprietaire;

  Produit({
    required this.nom,
    required this.image,
    required this.prix,
    required this.quantiteEnStock,
    required this.dateRecolte,
    required this.proprietaire,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      nom: json['nom'],
      image: json['image'],
      prix: json['prix'].toDouble(),
      quantiteEnStock: json['quantiteEnStock'],
      dateRecolte: json['dateRecolte'],
      proprietaire: json['proprietaire'],
    );
  }
}
