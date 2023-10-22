import 'package:currencyexchangemehdinathani/components/custom_text_field.dart';
import 'package:currencyexchangemehdinathani/configuration/config.dart';
import 'package:currencyexchangemehdinathani/services/converted_amount_function.dart';
import 'package:currencyexchangemehdinathani/services/fetch_data.dart';
import 'package:currencyexchangemehdinathani/services/google_sheets_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CurrencyConvertor extends StatefulWidget {
  const CurrencyConvertor({super.key});

  @override
  State<CurrencyConvertor> createState() => _CurrencyConvertorState();
}

class _CurrencyConvertorState extends State<CurrencyConvertor> {
  String selectedDate = '';
  String selectedFromCurrency = '';
  String selectedToCurrency = '';
  List<String> dateOptions = [];
  List<String> currencyOptions = [];
  String selectedFromCurrencyValue = "";
  String selectedToCurrencyValue = "";
  final TextEditingController _convertingAmount = TextEditingController();
  num convertedAmount = 0;

  final apiKey = GoogleApiConfig.apiKey;
  final spreadsheetId = GoogleApiConfig.SpreadsheetID;
  List<List<String>>? sheetData;
  late Future<List<List<String>>?> fetchDataFuture;
  final customSizedBox = const SizedBox(height: 20);

  @override
  void initState() {
    super.initState();
    fetchDateOptions();
    fetchCurrencyOptions();
    fetchDataFuture = fetchData();
  }

  Future<void> fetchDateOptions() async {
    final range = 'A:A';
    final data = await fetchGoogleSheetData(range, apiKey, spreadsheetId);
    if (data != null && data.isNotEmpty) {
      dateOptions = data.map((row) => row[0]).toList();
      if (dateOptions.isNotEmpty) {
        selectedDate = dateOptions[0];
      }
      setState(() {});
    }
  }

  Future<void> fetchCurrencyOptions() async {
    final range = '6:6';
    final data = await fetchGoogleSheetData(range, apiKey, spreadsheetId);
    if (data != null && data.isNotEmpty && data[0].isNotEmpty) {
      currencyOptions = data[0].sublist(1);
      currencyOptions.add("PKR");
      if (currencyOptions.isNotEmpty) {
        selectedFromCurrency = currencyOptions[0];
        selectedToCurrency = currencyOptions[0];
      }
      setState(() {});
    }
  }

  void updateValues() async {
    if (selectedFromCurrency == "PKR") {
      selectedFromCurrencyValue = "1";
    } else {
      selectedFromCurrencyValue =
          await getCurrencyValue(selectedDate, selectedFromCurrency);
      print(selectedFromCurrencyValue.toString());
    }

    if (selectedToCurrency == "PKR") {
      selectedToCurrencyValue = "1";
    } else {
      selectedToCurrencyValue =
          await getCurrencyValue(selectedDate, selectedToCurrency);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedDate,
            onChanged: (value) {
              setState(() {
                selectedDate = value!;
                if (kDebugMode) {
                  print(selectedDate);
                }
              });
            },
            items: dateOptions.map((date) {
              return DropdownMenuItem(
                value: date,
                child: Text(date),
              );
            }).toList(),
          ),
          customSizedBox,
          DropdownButton<String>(
            value: selectedFromCurrency,
            onChanged: (value) {
              setState(() {
                selectedFromCurrency = value!;
                if (kDebugMode) {
                  print(selectedFromCurrency);
                }
              });
            },
            items: currencyOptions.map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Text(currency),
              );
            }).toList(),
          ),
          customSizedBox,
          DropdownButton<String>(
            value: selectedToCurrency,
            onChanged: (value) {
              setState(() {
                selectedToCurrency = value!;
                if (kDebugMode) {
                  print(selectedToCurrency);
                }
              });
            },
            items: currencyOptions.map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Text(currency),
              );
            }).toList(),
          ),
          customSizedBox,
          CustomTextField(
            controller: _convertingAmount,
            hintText: "Your Amount",
          ),
          customSizedBox,
          Text(convertedAmount.toStringAsFixed(4)),
          customSizedBox,

          //elevated button
          ElevatedButton(
            onPressed: () async {
              // updateValues();
// again for debug
              if (selectedFromCurrency == "PKR") {
                selectedFromCurrencyValue = "1";
              } else {
                selectedFromCurrencyValue =
                    await getCurrencyValue(selectedDate, selectedFromCurrency);
                print(selectedFromCurrencyValue.toString());
              }

              if (selectedToCurrency == "PKR") {
                selectedToCurrencyValue = "1";
              } else {
                selectedToCurrencyValue =
                    await getCurrencyValue(selectedDate, selectedToCurrency);
              }
// above again for debugg
              convertedAmount = getConvertedAmount(
                selectedFromCurrencyValue,
                selectedToCurrencyValue,
                _convertingAmount.text,
              );
              if (kDebugMode) {
                print(convertedAmount.toStringAsFixed(4));
              }
              setState(() {});
            },
            child: const Text("Convert"),
          ),
        ],
      ),
    );
  }
}
