import 'package:flutter_test/flutter_test.dart';
import 'package:tcmb_api/src/models/models.dart';

void main() {
  const map = <String, dynamic>{
    '_CrossOrder': '0',
    '_Kod': 'USD',
    '_CurrencyCode': 'USD',
    'Unit': '1',
    'Isim': 'ABD DOLARI',
    'CurrencyName': 'US DOLLAR',
    'ForexBuying': '32.1534',
    'ForexSelling': '32.2113',
    'BanknoteBuying': '32.1309',
    'BanknoteSelling': '32.2596',
    'CrossRateUSD': '',
    'CrossRateOther': '',
  };

  final usdCurrency = Currency(
    code: 'USD',
    nameInTurkish: 'ABD DOLARI',
    name: 'US DOLLAR',
    unit: 1,
    forexBuying: 32.1534,
    forexSelling: 32.2113,
    bankNoteBuying: 32.1309,
    banknoteSelling: 32.2596,
  );
  group('Currency', () {
    group('fromJson', () {
      test('returns a Currency object', () {
        expect(
          Currency.fromJson(map),
          isA<Currency>(),
        );
      });

      test('returns a Currency object with correct properties', () {
        expect(
          Currency.fromJson(map),
          isA<Currency>()
              .having((c) => c.code, 'code', 'USD')
              .having((c) => c.unit, 'unit', 1)
              .having((c) => c.name, 'name', 'US DOLLAR')
              .having((c) => c.nameInTurkish, 'isim', 'ABD DOLARI')
              .having((c) => c.forexBuying, 'forexBuying', 32.1534),
        );
      });
    });

    test('toString()', () {
      expect(
        usdCurrency.toString(),
        'Currency(code: USD, unit: 1, nameInTurkish: ABD DOLARI, name: US DOLLAR, forexBuying: 32.1534, forexSelling: 32.2113, banknoteBuying: 32.1309, banknoteSelling: 32.2596, crossRateUSD: null, crossRateOther: null)',
      );
    });
  });
}
