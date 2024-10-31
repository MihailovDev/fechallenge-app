class Airport {
  final String? name;
  final String? iata;
  final String? lat;
  final String? lon;
  final String? iso;
  final String? continent;
  final String? type;
  final String? size;
  final num? status;

  Airport({
    required this.name,
    required this.iata,
    required this.lat,
    required this.lon,
    required this.iso,
    required this.continent,
    required this.type,
    required this.size,
    required this.status,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      name: json['name'],
      iata: json['iata'],
      lat: json['lat'],
      lon: json['lon'],
      iso: json['iso'],
      continent: json['continent'],
      type: json['type'],
      size: json['size'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iata': iata,
      'lat': lat,
      'lon': lon,
      'iso': iso,
      'continent': continent,
      'type': type,
      'size': size,
      'status': status,
    };
  }
}
