import 'package:depd_mvvm_2025/data/network/network_api_service.dart';
import 'package:depd_mvvm_2025/model/model.dart';

// Repository untuk menangani logika bisnis terkait data ongkir
class HomeRepository {
  final _apiServices = NetworkApiServices();

  // Mengambil daftar provinsi dari API
  Future<List<Province>> fetchProvinceList() async {
    final response = await _apiServices.getApiResponse('destination/province');

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data provinsi
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Province.fromJson(e)).toList();
  }

  // Mengambil daftar kota berdasarkan ID provinsi
  Future<List<City>> fetchCityList(var provId) async {
    final response = await _apiServices.getApiResponse(
      'destination/city/$provId',
    );

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data kota
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => City.fromJson(e)).toList();
  }

  // Menghitung biaya pengiriman berdasarkan parameter yang diberikan
  Future<List<Costs>> checkShipmentCost(
    String origin,
    String originType,
    String destination,
    String destinationType,
    int weight,
    String courier,
  ) async {
    // Kirim request POST untuk kalkulasi ongkir
    final response = await _apiServices
        .postApiResponse('calculate/district/domestic-cost', {
          "origin": origin,
          "destination": destination,
          "weight": weight.toString(),
          "courier": courier,
        });

    // Validasi response meta
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parse data biaya pengiriman
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Costs.fromJson(e)).toList();
  }
}
