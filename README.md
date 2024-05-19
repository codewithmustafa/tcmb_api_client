<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# TCMB API CLIENT

This Dart package provides a simple and efficient way to interact with the Central Bank of the Republic of Türkiye (TCMB) API. It allows you to fetch exchange rates and other related data.

## Demo

![Demo](https://github.com/codewithmustafa/tcmb_api/raw/main/demo/demo.png)

## Features

- Fetch exchange rate for current date
- Fetch exchange rates for a specific date
- Fetch a single rate for a specific currency and date
- Easy to use with a clean and simple API

## Getting Started

To use this package, add `tcmb_api` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

```yaml
dependencies:
  tcmb_apı: ^0.0.1
```

## Usage

Here's a simple example of using `TcmbApiClient` to fetch exchange rates:

```dart
import 'package:tcmb_api/tcmb_api.dart';

Future<List<Currency>> fetchRates() async {
    try {
      return await _apiClient.getRates();
    } catch (e) {
      debugPrint('Error fetching rates: $e');
      rethrow;
    }
  }

Future<Currency?> fetchUsdRate() async {
    try {
      return await _apiClient.getSingleRate(CurrencyCode.USD);
    } catch (e) {
      debugPrint('Error fetching rates: $e');
      rethrow;
    }
}
```

## Testing and Coverage

This package includes a comprehensive suite of unit tests, which ensures the reliability and correctness of the package's functionality.
(Cov report added as an image just for now, will connect to a service later)
![Code Coverage Report](https://github.com/codewithmustafa/tcmb_api/raw/main/demo/cov.png)

## Disclaimer

Please note that this package is not affiliated with, officially connected to, or endorsed by the Central Bank of the Republic of Türkiye (TCMB). The package is developed and maintained independently. The official TCMB website can be found at [https://www.tcmb.gov.tr](https://www.tcmb.gov.tr). The name TCMB as well as related names, marks, emblems and images are registered trademarks of their respective owners.
