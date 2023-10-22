import 'package:currencyexchangemehdinathani/configuration/config.dart';
import 'package:currencyexchangemehdinathani/services/google_sheets_service.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<List<List<String>>?> fetchData() async {
    final apikey = GoogleApiConfig.apiKey;
    final SpreadsheetID = "1pXPOPkZBS_2_8H6Q1vpsOy4ppMAR0kOKghJT15IeuQQ";
    final range = 'A:K';

    // Call the fetchGoogleSheetData function from the other file with the dynamic range.
    final data = await fetchGoogleSheetData(range, apikey, SpreadsheetID);
    if (data != null && data.isNotEmpty) {
      print('Fetched ${data.length} rows of data.');
      print(data.toString());
    } else {
      print('No data available.');
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("BankWise")),
      ),
      body: FutureBuilder<List<List<String>>?>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            final data = snapshot.data!;
            // Create a ListView or another suitable widget to display the data.
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final rowData = data[index];
                return ListTile(
                  title: Text('Date: ${rowData[0]}'),
                  // Add more rows for other currencies as needed.
                );
              },
            );
          }
        },
      ),
    );
  }
}
