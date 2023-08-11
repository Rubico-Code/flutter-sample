class Session {
  Session({required this.tokenType, required this.accessToken});

  final String tokenType;
  final String accessToken;

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        tokenType: json['token_type'], accessToken: json['access_token']);
  }

  String get authToken => '$tokenType $accessToken';
}
