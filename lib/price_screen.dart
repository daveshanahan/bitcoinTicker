import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
// the IO package contains the platform class which lets us check if we are running on IOS or Android
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  // for Android
  DropdownButton<String> getAndroidDropDown() {
    // loop for creating currencies drop down
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
// this value is default value you see when page loads - to update this when another currency selected,
// we need to create the selectedCurrency variable inside the page's state
// when they change the currency in the drop down the displayed value will get updated in the onChanged
// wrap the assignment in the onChanged in set state to have the value update finally
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  // for IOS
  CupertinoPicker getIOSPicker() {
    // loop to get menu items
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  // create string to hold coin price in USD
  String bitcoinPriceInUSD = '?';

  // create getData async method to get coin data in a try and catch block to handle errors
  void getData() async {
    try {
      double data = await CoinData().getCoinData();
      // can't set state when using await - have to do it separately
      setState(() {
        bitcoinPriceInUSD = data.toStringAsFixed(0);
      });
      // catch the error
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // we can't call CoinData().getCoinData directly here because we can't make initState async
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $bitcoinPriceInUSD USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // use ternary operator to tap into platform.isIOS or .isAndroid to choose which picker to display
            child: Platform.isIOS ? getIOSPicker() : getAndroidDropDown(),
          ),
        ],
      ),
    );
  }
}
