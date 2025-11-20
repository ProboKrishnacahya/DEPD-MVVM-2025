import 'package:depd_mvvm_2025/data/response/status.dart';

// Kelas generik untuk membungkus respon API: status, data, dan pesan
class ApiResponse<T> {
  // Menyimpan status permintaan
  Status? status;
  // Data hasil ketika permintaan berhasil
  T? data;
  // Pesan penjelasan atau error
  String? message;

  // Konstruktor fleksibel (dapat diisi manual)
  ApiResponse({this.status, this.data, this.message});

  // Menandai permintaan belum dimulai
  ApiResponse.notStarted() : status = Status.notStarted;
  // Menandai sedang memuat / proses
  ApiResponse.loading() : status = Status.loading;
  // Menandai selesai sukses dengan data
  ApiResponse.completed(this.data) : status = Status.completed;
  // Menandai terjadi error dengan pesan
  ApiResponse.error(this.message) : status = Status.error;

  // Untuk debug isi respons
  @override
  String toString() {
    return "Status: $status \nMessage : $message \nData : $data";
  }
}
