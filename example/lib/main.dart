import 'package:flutter/material.dart';
import 'package:tcmb_api/tcmb_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCMB API Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TCMB API Demo'),
    );
  }
}

// The smallest example of using [TcmbApiClient] to fetch exchange rates from TCMB API
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _apiClient = TcmbApiClient();
  late Future<List<Currency>> _ratesFuture;

  @override
  void initState() {
    super.initState();

    _ratesFuture = _fetchRates();
  }

  Future<List<Currency>> _fetchRates() async {
    try {
      return await _apiClient.getRates();
    } catch (e) {
      // Handle or rethrow the error as appropriate for your app
      debugPrint('Error fetching rates: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: _ratesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final rates = snapshot.data;
              if (rates == null) {
                return const Center(child: Text('No data'));
              }
              return ListView.builder(
                itemCount: rates.length,
                itemBuilder: (context, index) {
                  final currency = rates[index];
                  return ListTile(
                    title: Text(currency.nameInTurkish),
                    subtitle: Text(currency.name),
                    trailing: Text(
                      currency.forexBuying.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                },
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }
}
