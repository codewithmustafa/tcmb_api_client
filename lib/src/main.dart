import 'package:tcmb_api/tcmb_api.dart';

Future<void> main(List<String> args) async {
  final tcmbApiClient = TcmbApiClient();

  final result = await tcmbApiClient.getRates(date: DateTime(2024, 04, 22));
  for (final e in result) {
    print('${e.code}:\n$e\n');
  }

  try {
    final usd = await tcmbApiClient.getSingleRate(CurrencyCode.AUD, date: DateTime(2024, 04, 22));
    print(usd);
  } catch (e) {
    print(e);
  }
}
