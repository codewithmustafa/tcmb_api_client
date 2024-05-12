import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:tcmb_api/tcmb_api.dart';
import 'package:xml2json/xml2json.dart';

/// {@template tcmb_api_client}
/// A dart client for TCMB rate of exchanges API: `https://www.tcmb.gov.tr/kurlar/{date}.xml`, example of date: `today`,
/// {@endtemplate}
class TcmbApiClient {
  /// {@macro tcmb_api_client}
  TcmbApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();
  final _baseUrl = 'tcmb.gov.tr';
  final _path = '/kurlar/';
  final http.Client _httpClient;

  /// Response will be in xml format, [Xml2Json] is needed to convert it to json
  final xmlTransformer = Xml2Json();

  /// The method will return all rate of exchanges that TCMB provides
  /// Can throw [RatesRequestFailure] and [RatesNotFound]
  /// Must be called with try-catch to handle these errors
  Future<List<Currency>> getRates({DateTime? date}) async {
    final request = Uri.https(_baseUrl, '$_path${date != null ? _getPathForDate(date) : 'today'}.xml');
    print(request.path);
    print(request);
    try {
      final response = await _httpClient.get(request);

      if (response.statusCode != 200) {
        throw RatesRequestFailure(statusCode: response.statusCode);
      }

      final body = utf8.decode(response.bodyBytes);

      final bodyJson = _xmlToJson(body);

      final bodyMap = jsonDecode(bodyJson) as Map<String, dynamic>;
      final dateMap = bodyMap['Tarih_Date'] as Map<String, dynamic>;
      final currenciesMap = dateMap['Currency'] as List;

      return currenciesMap.map((cMap) => Currency.fromJson(cMap as Map<String, dynamic>)).toList();
    } catch (e) {
      throw RatesNotFound(error: e.toString());
    }
  }

  /// The method will return single rate of exchange that TCMB provides and defined via [CurrencyCode]
  /// `currencyCode` parameter should be passed
  /// Can throw [RatesRequestFailure] and [RatesNotFound]
  /// Must be called with try-catch to handle these errors
  Future<Currency?> getSingleRate(CurrencyCode currencyCode, {DateTime? date}) async {
    final all = await getRates(date: date);

    return all.firstWhereOrNull((c) => c.code == currencyCode.name);
  }

  /// Internal private method that converts `xml` string passed as a parameter to json format
  String _xmlToJson(String xml) {
    xmlTransformer.parse(xml);
    return xmlTransformer.toParkerWithAttrs();
  }

  String _getPathForDate(DateTime dateTime) {
    return '${dateTime.year}${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}${dateTime.month.toString().padLeft(2, '0')}${dateTime.year}';
  }
}
