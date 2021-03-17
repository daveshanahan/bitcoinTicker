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
  Future getCoinData() async {
    Uri url = Uri.https(
        "$kApiURL", "/v1/exchangerate/BTC/USD", {"apikey": "$kApiKey"});

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      // we use jsonDecode to parse the data and make it accessible
      var decodedData = jsonDecode(data);
      var lastPrice = decodedData['rate'];
      return lastPrice;
    } else {
      print(response.statusCode);
      throw 'Problem with the GET request';
    }
  }
}
