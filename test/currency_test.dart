import 'package:flutter_test/flutter_test.dart';
import 'package:tcmb_api/src/models/models.dart';

void main() {
  group('Currency', () {
    group('fromJson', () {
      test('returns a Currency object', () {
        expect(
            Currency.fromJson(<String, dynamic>{
              "_CrossOrder": "0",
              "_Kod": "USD",
              "_CurrencyCode": "USD",
              "Unit": "1",
              "Isim": "ABD DOLARI",
              "CurrencyName": "US DOLLAR",
              "ForexBuying": "32.1534",
              "ForexSelling": "32.2113",
              "BanknoteBuying": "32.1309",
              "BanknoteSelling": "32.2596",
              "CrossRateUSD": "",
              "CrossRateOther": ""
            }),
            isA<Currency>());
      });

      test('returns a Currency object with correct properties', () {
        expect(
          Currency.fromJson(<String, dynamic>{
            "_CrossOrder": "0",
            "_Kod": "USD",
            "_CurrencyCode": "USD",
            "Unit": "1",
            "Isim": "ABD DOLARI",
            "CurrencyName": "US DOLLAR",
            "ForexBuying": "32.1534",
            "ForexSelling": "32.2113",
            "BanknoteBuying": "32.1309",
            "BanknoteSelling": "32.2596",
            "CrossRateUSD": "",
            "CrossRateOther": ""
          }),
          isA<Currency>()
              .having((c) => c.code, 'code', 'USD')
              .having((c) => c.unit, 'unit', 1)
              .having((c) => c.name, 'name', 'US DOLLAR')
              .having((c) => c.nameInTurkish, 'isim', 'ABD DOLARI')
              .having((c) => c.forexBuying, 'forexBuying', 32.1534),
        );
      });
    });
  });
}
