class Novidade {
  final String image;
  final int x;
  final int y;
  final int pos;

  Novidade(this.image, this.x, this.y, this.pos);

  Map<String, dynamic> toMap(){
    return {
      "image": image,
      "x": x,
      "y": y,
      "pos": pos
    };
  }

  factory Novidade.fromMap(Map<String, dynamic> map) {
    return Novidade(
      map['image'],
      map['x'],
      map['y'],
      map['pos'],
    );
  }
}
