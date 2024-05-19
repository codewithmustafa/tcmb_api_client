import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:tcmb_api_client/tcmb_api_client.dart';
import 'package:xml2json/xml2json.dart';

/// {@template tcmb_api_client}
/// A dart client for TCMB(Central Bank of the Republic of Türkiye) rate of exchanges API: `https://www.tcmb.gov.tr/kurlar/{date}.xml`, examples of date: `today`, `202404/22042024`.
/// TCMB is the acronym used in Turkish for our central bank, that's why it used in [TcmbAPiClient] class name (for convenience purposes)
/// {@endtemplate}
class TcmbApiClient {
  /// {@macro tcmb_api_client}
  TcmbApiClient({http.Client? httpClient, Xml2Json? xmlTransformer})
      : _httpClient = httpClient ?? http.Client(),
        _xmlTransformer = xmlTransformer ?? Xml2Json();
  final _baseUrl = 'tcmb.gov.tr';
  final _path = '/kurlar/';
  final http.Client _httpClient;

  /// Response will be in xml format, [Xml2Json] is needed to convert it to json
  final Xml2Json _xmlTransformer;

  /// Fetches the exchange rates from the TCMB API.
  ///
  /// This method sends a GET request to the TCMB API and retrieves the exchange rates. The rates are returned as a list of `Currency` objects.
  ///
  /// The `date` parameter is optional. If provided, the method fetches the rates for the specified date. If not provided, the method fetches the rates for the current day.
  ///
  /// The method throws a `RatesRequestFailure` exception if the HTTP request fails. The exception includes the HTTP status code.
  ///
  /// The method throws a `RatesNotFound` exception in the following cases:
  /// - The 'Tarih_Date' key is not present in the response body.
  /// - The 'Currency' key is not present in the 'Tarih_Date' map.
  /// - The 'Currency' list is empty.
  ///
  /// Other exceptions can also be thrown if an error occurs during the processing of the response. These exceptions should be caught and handled by the caller.
  ///
  /// Example usage:
  /// ```dart
  /// try {
  ///   final rates = await tcmbApiClient.getRates();
  ///   // Use the rates...
  /// } catch (e) {
  ///   // Handle the error...
  /// }
  /// ```
  ///
  /// Returns a `Future` that completes with a list of `Currency` objects representing the exchange rates.
  Future<List<Currency>> getRates({DateTime? date}) async {
    final request = Uri.https(_baseUrl, '$_path${date != null ? getPathForDate(date) : 'today'}.xml');

    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw RatesRequestFailure(statusCode: response.statusCode);
    }

    final body = utf8.decode(response.bodyBytes);

    final bodyJson = xmlToJson(body);

    final bodyMap = jsonDecode(bodyJson) as Map<String, dynamic>;
    if (!bodyMap.containsKey('Tarih_Date')) throw RatesNotFoundFailure();

    final dateMap = bodyMap['Tarih_Date'] as Map<String, dynamic>;
    if (!dateMap.containsKey('Currency')) throw RatesNotFoundFailure();

    final currenciesMap = dateMap['Currency'] as List;
    if (currenciesMap.isEmpty) throw RatesNotFoundFailure();

    return currenciesMap.map((cMap) => Currency.fromJson(cMap as Map<String, dynamic>)).toList();
  }

  /// Fetches the exchange rate for a single currency from the TCMB API.
  ///
  /// This method uses the `getRates` method to fetch all exchange rates, and then filters the list to find the rate for the specified currency.
  ///
  /// The `currencyCode` parameter specifies the currency to fetch the rate for. It must be a value from the `CurrencyCode` enum.
  ///
  /// The `date` parameter is optional. If provided, the method fetches the rate for the specified date. If not provided, the method fetches the rate for the current day.
  ///
  /// If the specified currency is not found in the list of rates, the method returns `null`.
  ///
  /// Example usage:
  /// ```dart
  /// try {
  ///   final rate = await tcmbApiClient.getSingleRate(CurrencyCode.USD);
  ///   if (rate != null) {
  ///     // Use the rate...
  ///   } else {
  ///     // Handle the case where the rate is not found...
  ///   }
  /// } catch (e) {
  ///   // Handle the error...
  /// }
  /// ```
  ///
  /// Returns a `Future` that completes with a `Currency` object representing the exchange rate for the specified currency, or `null` if the rate is not found.
  /// Note: Must be called with try-catch to handle these errors
  Future<Currency?> getSingleRate(CurrencyCode currencyCode, {DateTime? date}) async {
    final all = await getRates(date: date);
    return all.firstWhereOrNull((c) => c.code == currencyCode.name);
  }

  /// Internal private method that converts `xml` string passed as a parameter to json format
  String xmlToJson(String xml) {
    _xmlTransformer.parse(xml);
    return _xmlTransformer.toParkerWithAttrs();
  }

  /// Internal private method that constructs the part required for endpoint when requesting rates for days other than today
  String getPathForDate(DateTime dateTime) {
    return '${dateTime.year}${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}${dateTime.month.toString().padLeft(2, '0')}${dateTime.year}';
  }

  void dispose() {
    _httpClient.close();
  }
}
