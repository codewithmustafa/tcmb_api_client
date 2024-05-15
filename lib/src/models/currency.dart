import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

/// The model that we use to convert raw data from API to dart objects
/// Some properties are nullable for now, most of them must be coming from API all the time
@JsonSerializable()
class Currency {
  Currency({
    required this.code,
    required this.nameInTurkish,
    required this.name,
    this.unit,
    this.forexBuying,
    this.forexSelling,
    this.bankNoteBuying,
    this.banknoteSelling,
    this.crossRateUSD,
    this.crossRateOther,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);
  @JsonKey(name: '_CurrencyCode')
  final String code;
  @JsonKey(name: 'Unit', fromJson: int.parse)
  final int? unit;
  @JsonKey(name: 'Isim')
  final String nameInTurkish;
  @JsonKey(name: 'CurrencyName')
  final String name;
  @JsonKey(name: 'ForexBuying', fromJson: double.tryParse)
  final double? forexBuying;
  @JsonKey(name: 'ForexSelling', fromJson: double.tryParse)
  final double? forexSelling;
  @JsonKey(name: 'BanknoteBuying', fromJson: double.tryParse)
  final double? bankNoteBuying;
  @JsonKey(name: 'BanknoteSelling', fromJson: double.tryParse)
  final double? banknoteSelling;
  @JsonKey(name: 'CrossRateUSD', fromJson: double.tryParse)
  final double? crossRateUSD;
  @JsonKey(name: 'CrossRateOther', fromJson: double.tryParse)
  final double? crossRateOther;

  @override
  String toString() {
    return 'Currency(code: "$code", unit: $unit, nameInTurkish: "$nameInTurkish", name: "$name", forexBuying: $forexBuying, forexSelling: $forexSelling, banknoteBuying: $bankNoteBuying, banknoteSelling: $banknoteSelling, crossRateUSD: $crossRateUSD, crossRateOther: $crossRateOther)';
  }
}
