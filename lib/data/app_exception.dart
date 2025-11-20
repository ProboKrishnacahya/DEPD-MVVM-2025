/// Kelas dasar untuk exception handling, menyimpan pesan dan prefix.
class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_message $_prefix';
  }
}

/// Dilempar saat gagal mengambil data dari server (timeout, format salah, dll.).
class FetchDataException implements Exception {
  final String message;
  FetchDataException(this.message);

  @override
  String toString() => 'FetchDataException: $message';
}

/// Dilempar saat tidak ada koneksi internet terdeteksi.
class NoInternetException implements Exception {
  final String message;
  NoInternetException(this.message);

  @override
  String toString() => 'NoInternetException: $message';
}

/// Dilempar saat permintaan tidak valid (400 / data input salah).
class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);

  @override
  String toString() => 'BadRequestException: $message';
}

/// Dilempar saat resource / endpoint tidak ditemukan (404).
class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Dilempar saat terjadi kesalahan internal server (500+).
class ServerErrorException implements Exception {
  final String message;
  ServerErrorException(this.message);

  @override
  String toString() => 'ServerErrorException: $message';
}
