class Token {
  final String token;
  final String ref_token;


  const Token({required this.token,required this.ref_token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(token: json['access'] as String, ref_token: json['refresh'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'access': token,
      'refresh': ref_token,

    };
  }
}
