class Wishlist {
  final String detail;

  Wishlist({
    required this.detail
  });
  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(detail: json['detail'] as String);
  }
}

