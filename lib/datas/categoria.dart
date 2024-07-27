class Categoria {
  final String id;
  final String title;
  final String icon;

  Categoria(
    this.id,
    this.title,
    this.icon,
  );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "icon": icon,
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      map['id'],
      map['title'],
      map['icon'],
    );
  }
}
