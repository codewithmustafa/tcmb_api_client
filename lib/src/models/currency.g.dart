// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency(
      code: json['_CurrencyCode'] as String,
      nameInTurkish: json['Isim'] as String,
      name: json['CurrencyName'] as String,
      unit: int.parse(json['Unit'] as String),
      forexBuying: double.tryParse(json['ForexBuying'] as String),
      forexSelling: double.tryParse(json['ForexSelling'] as String),
      bankNoteBuying: double.tryParse(json['BanknoteBuying'] as String),
      banknoteSelling: double.tryParse(json['BanknoteSelling'] as String),
      crossRateUSD: double.tryParse(json['CrossRateUSD'] as String),
      crossRateOther: double.tryParse(json['CrossRateOther'] as String),
    );
