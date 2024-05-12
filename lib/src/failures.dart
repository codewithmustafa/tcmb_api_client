class RatesRequestFailure implements Exception {
  RatesRequestFailure({this.statusCode, this.error});
  final int? statusCode;
  final String? error;
}

class RatesNotFound implements Exception {
  RatesNotFound({this.statusCode, this.error});
  final int? statusCode;
  final String? error;
}
