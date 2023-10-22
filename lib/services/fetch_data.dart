import 'package:currencyexchangemehdinathani/configuration/config.dart';
import 'package:currencyexchangemehdinathani/services/google_sheets_service.dart';
import 'package:flutter/foundation.dart';

List<List<String>>? sheetData;
late Future<List<List<String>>?> fetchDataFuture;

Future<List<List<String>>?> fetchData() async {
  final apiKey = GoogleApiConfig.apiKey;
  final spreadsheetId = '1pXPOPkZBS_2_8H6Q1vpsOy4ppMAR0kOKghJT15IeuQQ';
  final range = 'A:K';

  final data = await fetchGoogleSheetData(range, apiKey, spreadsheetId);
  if (data != null && data.isNotEmpty) {
    sheetData = data;

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
        if (kDebugMode) {
          print(row[columnIndex].toString());
        }
        return row[columnIndex];
      }
    }
  }

  return 'Value not found';
}
