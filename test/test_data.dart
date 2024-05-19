const xmlResponseWithWithTwoCurrency = '''
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="isokur.xsl"?>
<Tarih_Date Tarih="22.04.2024" Date="04/22/2024"  Bulten_No="2024/76" >
	<Currency CrossOrder="0" Kod="USD" CurrencyCode="USD">
			<Unit>1</Unit>
			<Isim>ABD DOLARI</Isim>
			<CurrencyName>US DOLLAR</CurrencyName>
			<ForexBuying>32.5000</ForexBuying>
			<ForexSelling>32.5586</ForexSelling>
			<BanknoteBuying>32.4773</BanknoteBuying>
			<BanknoteSelling>32.6074</BanknoteSelling>
			<CrossRateUSD/>
			<CrossRateOther/>
	</Currency>
  <Currency CrossOrder="9" Kod="EUR" CurrencyCode="EUR">
			<Unit>1</Unit>
			<Isim>EURO</Isim>
			<CurrencyName>EURO</CurrencyName>
			<ForexBuying>34.6207</ForexBuying>
			<ForexSelling>34.6830</ForexSelling>
			<BanknoteBuying>34.5964</BanknoteBuying>
			<BanknoteSelling>34.7351</BanknoteSelling>
				<CrossRateUSD/>
				<CrossRateOther>1.0653</CrossRateOther>
		
	</Currency>
</Tarih_Date>
''';

const xmlResponseDoesNotContainTarihDate = '''
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="isokur.xsl"?>
<SomeTag></SomeTag>
''';

const xmlResponseDoesNotContainCurrency = '''
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="isokur.xsl"?>
<Tarih_Date Tarih="22.04.2024" Date="04/22/2024"  Bulten_No="2024/76" >
</Tarih_Date>
''';
