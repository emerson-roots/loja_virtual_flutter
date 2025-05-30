class Place {
  String id;
  String address;
  String image;
  String lat;
  String long;
  String phone;
  String title;

  Place({
    required this.id,
    required this.address,
    required this.image,
    required this.lat,
    required this.long,
    required this.phone,
    required this.title,
  });

  factory Place.empty() {
    return Place(
      id: '',
      address: '',
      image: '',
      lat: '',
      long: '',
      phone: '',
      title: '',
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      lat: json['lat'] is String ? json['lat'] : json['lat']?.toString() ?? '',
      long: json['long'] is String ? json['long'] : json['long']?.toString() ?? '',
      phone: json['phone'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'image': image,
      'lat': lat,
      'long': long,
      'phone': phone,
      'title': title,
    };
  }
}
