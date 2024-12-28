class ServerInfo {
  final String server;
  final String? title;
  final int? ads;
  final String? url;
  final bool? allowMobile;
  final String? code;

  ServerInfo({
    required this.server,
    this.title,
    this.ads,
    this.url,
    this.allowMobile,
    this.code,
  });

  factory ServerInfo.fromJson(Map<dynamic, dynamic> json) {
    return ServerInfo(
      server: json['server'] ?? '',
      title: json['title'],
      ads: json['ads'],
      url: json['url'],
      allowMobile: json['allow_mobile'],
      code: json['code'],
    );
  }

  // Método para convertir una instancia a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'server': server,
      'title': title,
      'ads': ads,
      'url': url,
      'allow_mobile': allowMobile,
      'code': code,
    };
  }
}
