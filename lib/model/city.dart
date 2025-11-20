part of 'model.dart';

class City extends Equatable {
  final int? id;
  final String? name;
  final String? zipCode;

  const City({this.id, this.name, this.zipCode});

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json['id'] as int?,
    name: json['name'] as String?,
    zipCode: json['zip_code'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'zip_code': zipCode,
  };

  @override
  List<Object?> get props => [id, name, zipCode];
}
