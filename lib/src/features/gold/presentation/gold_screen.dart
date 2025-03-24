import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_gold_rate/src/features/gold/data/fake_gold_api.dart';

class GoldScreen extends StatelessWidget {
  const GoldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              Text('Live Kurs:',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              // Hier kommt der StreamBuilder zum Einsatz, um den Goldpreis live anzuzeigen
              StreamBuilder<double>(
                stream: getGoldPriceStream(),
                builder: (context, snapshot) {
                  // Wenn der Stream gerade Daten lädt, zeigen wir einen Ladeindikator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  // Falls ein Fehler auftritt, geben wir eine Fehlermeldung aus
                  else if (snapshot.hasError) {
                    return const Text(
                      'Fehler beim Laden der Daten',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    );
                  }
                  // Falls wir gültige Daten haben, zeigen wir den aktuellen Goldpreis formatiert an
                  else if (snapshot.hasData) {
                    return Text(
                      NumberFormat.simpleCurrency(locale: 'de_DE')
                          .format(snapshot.data),
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary),
                    );
                  }
                  // Falls nichts verfügbar ist, geben wir eine neutrale Meldung aus
                  else {
                    return const Text('Keine Daten verfügbar');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Image(
          image: AssetImage('assets/bars.png'),
          width: 100,
        ),
        Text('Gold', style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }
}
