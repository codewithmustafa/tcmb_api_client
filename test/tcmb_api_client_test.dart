import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:tcmb_api_client/tcmb_api_client.dart';
import 'package:test/test.dart';
import 'package:xml2json/xml2json.dart';

import 'test_data.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class MockXml2Json extends Mock implements Xml2Json {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('TcmbApiClient', () {
    late http.Client httpClient;
    late TcmbApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = TcmbApiClient(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient and a xmlTransformer', () {
        expect(TcmbApiClient(), isNotNull);
      });
    });

    group('getRates', () {
      final date = DateTime(2024, 5, 14);

      test('makes correct http request when date parameter is NOT specified', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.bodyBytes).thenReturn(Uint8List(0));
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.getRates();
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https(
              'tcmb.gov.tr',
              '/kurlar/today.xml',
            ),
          ),
        ).called(1);
      });
      test('makes correct http request when date parameter specified', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.getRates(date: date);
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https(
              'tcmb.gov.tr',
              '/kurlar/202405/14052024.xml',
            ),
          ),
        ).called(1);
      });

      test('throws RatesRequestFailure on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.getRates(),
          throwsA(isA<RatesRequestFailure>()),
        );
      });

      test('throws RatesNotFoundFailure on response that does not contain Currency tag', () async {
        final response = MockResponse();
        final transformer = MockXml2Json();
        //TODO Note: Is ot not required to mock some of methods of transformer below?
        when(() => response.statusCode).thenReturn(200);
        when(() => response.bodyBytes).thenReturn(Uint8List.fromList(utf8.encode(xmlResponseDoesNotContainCurrency)));
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.getRates(),
          throwsA(isA<RatesNotFoundFailure>()),
        );
      });

      test('throws RatesNotFoundFailure on response that does not contain Tarih_Date tag', () async {
        final response = MockResponse();
        final transformer = MockXml2Json();
        //TODO Note: Is ot not required to mock some of methods of transformer below?
        when(() => response.statusCode).thenReturn(200);
        when(() => response.bodyBytes).thenReturn(Uint8List.fromList(utf8.encode(xmlResponseDoesNotContainTarihDate)));
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.getRates(),
          throwsA(isA<RatesNotFoundFailure>()),
        );
      });

      test('returns List<Currency> on valid response', () async {
        final response = MockResponse();
        final transformer = MockXml2Json();
        //TODO Note: Is ot not required to mock some of methods of transformer below?
        when(() => response.statusCode).thenReturn(200);
        when(() => response.bodyBytes).thenReturn(Uint8List.fromList(utf8.encode(xmlResponseWithWithTwoCurrency)));
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual = await apiClient.getRates();
        expect(
          actual,
          isA<List<Currency>>(),
        );
      });
    });

    group(
      'getSingleRate',
      () => {
        test('returns a Currency object with the correct properties on valid response', () async {
          final response = MockResponse();
          final transformer = MockXml2Json();
          //TODO Note: Is ot not required to mock some of methods of transformer below?
          when(() => response.statusCode).thenReturn(200);
          when(() => response.bodyBytes).thenReturn(Uint8List.fromList(utf8.encode(xmlResponseWithWithTwoCurrency)));
          when(() => httpClient.get(any())).thenAnswer((_) async => response);
          final actual = await apiClient.getSingleRate(CurrencyCode.USD);
          expect(
            actual,
            isA<Currency>().having((c) => c.code, 'Currency code', 'USD'),
          );
        }),
      },
    );

    test('dispose resources', () {
      apiClient.dispose();
      verify(() => httpClient.close()).called(1);
    });
  });
}
