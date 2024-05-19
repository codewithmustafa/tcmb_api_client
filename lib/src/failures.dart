/// When request to API fails this exception will be thrown
class RatesRequestFailure implements Exception {
  RatesRequestFailure({this.statusCode, this.error});
  final int? statusCode;
  final String? error;
}

/// When request has been made successfully but rates not found this exception will be thrown
class RatesNotFoundFailure implements Exception {
  RatesNotFoundFailure({this.statusCode, this.error});
  final int? statusCode;
  final String? error;
}
