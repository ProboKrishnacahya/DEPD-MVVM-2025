/// Kelas abstrak sebagai kontrak layer jaringan yang kemudian diimplementasi oleh kelas turunan.
abstract class BaseApiServices {
  /// Melakukan request GET ke endpoint dan mengembalikan respon dinamis.
  /// Berjalan secara asinkron dan tipe datanya bisa apapun (json map, list, dll).
  Future<dynamic> getApiResponse(String endpoint);

  /// Melakukan request POST ke URL dengan payload data dan mengembalikan respon dinamis.
  Future<dynamic> postApiResponse(String url, dynamic data);
}
