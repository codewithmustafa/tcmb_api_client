import 'package:tcmb_api_client/tcmb_api_client.dart';

/// A dart example for quick test purposes for the [tcmb_api] package and [TcmbApiClient]
Future<void> main(List<String> args) async {
  final tcmbApiClient = TcmbApiClient();

  try {
    final result = await tcmbApiClient.getRates(date: DateTime(2024, 04, 22));
    for (final e in result) {
      print('${e.code}:\n$e\n');
    }
  } catch (e) {
    print(e);
  }

  try {
    final usd = await tcmbApiClient.getSingleRate(CurrencyCode.AUD, date: DateTime(2024, 04, 22));
    print(usd);
  } catch (e) {
    print(e);
  }
}
