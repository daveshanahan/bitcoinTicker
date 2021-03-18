import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const kApiKey = '377ABF0B-8814-49E8-96FB-A31E4FE1F861';
const kApiURL = 'rest.coinapi.io';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    //create map to store key value pairs of crypto currencies and their prices
    Map<String, String> cryptoPrices = {};
    //for loop to iterate over cryptoList and add entry to map with that crypto and its price
    for (String crypto in cryptoList) {
      Uri url = Uri.https("$kApiURL",
          "/v1/exchangerate/$crypto/$selectedCurrency", {"apikey": "$kApiKey"});

      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        // we use jsonDecode to parse the data and make it accessible
        var decodedData = jsonDecode(data);
        var lastPrice = decodedData['rate'];
        //here I am adding an entry to the map with the key as crypto from cryptoList and the value as the price in selected currency
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the GET request';
      }
    }
    return cryptoPrices;
  }
}
