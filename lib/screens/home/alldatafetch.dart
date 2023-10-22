import 'package:currencyexchangemehdinathani/configuration/config.dart';
import 'package:currencyexchangemehdinathani/services/google_sheets_service.dart';
import 'package:flutter/material.dart';

class AllDataTest extends StatefulWidget {
  const AllDataTest({Key? key}) : super(key: key);

  @override
  State<AllDataTest> createState() => _AllDataTestState();
}

class _AllDataTestState extends State<AllDataTest> {
  List<List<String>>? sheetData;
  late Future<List<List<String>>?> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<List<List<String>>?> fetchData() async {
    final apiKey = GoogleApiConfig.apiKey;
    final spreadsheetId = '1pXPOPkZBS_2_8H6Q1vpsOy4ppMAR0kOKghJT15IeuQQ';
    final range = 'A:K';

    final data = await fetchGoogleSheetData(range, apiKey, spreadsheetId);
    if (data != null && data.isNotEmpty) {
      setState(() {
        sheetData = data;
      });
      print('Fetched ${data.length} rows of data.');
    } else {
      print('No data available.');
    }
    return data;
  }

  Future<String> getCurrencyValue(String date, String currencyName) async {
    if (sheetData == null) {
      return 'Data not available';
    }

    for (final row in sheetData!) {
      if (row.isNotEmpty && row[0] == date) {
        final columnIndex =
            sheetData![5].indexWhere((cell) => cell == currencyName);
        if (columnIndex != -1) {
          return row[columnIndex];
        }
      }
    }

    return 'Value not found';
  }

  @override
  Widget build(BuildContext context) {
    final String selectedDate = "07-Oct-2021";
    final String selectedCurrency = "USD";
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Xchange Rate")),
      ),
      body: FutureBuilder<List<List<String>>?>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            return Center(
              child: FutureBuilder<String>(
                future: getCurrencyValue(selectedDate,
                    selectedCurrency), // Replace 'AED' with the currency you want
                builder: (context, currencySnapshot) {
                  if (currencySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return Text(
                      'Currency $selectedCurrency on $selectedDate: ${currencySnapshot.data}',
                      style:
                          TextStyle(fontSize: 24), // Adjust the style as needed
                    );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
