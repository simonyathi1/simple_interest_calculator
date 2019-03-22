import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Simple Interest Calculator",
      home: SICForm(),
      theme: ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.amber,
          primaryColorDark: Colors.redAccent,
          primaryColorLight: Colors.yellowAccent),
    ));

class SICForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppScreen();
  }
}

class AppScreen extends State<SICForm> {
  final _minimumPadding = 8.0;
  var _currencies = ["Rands", "Dollars", "Pounds", "Others"];
  var _currentItemSelected = "";
  var _displayText = "";
  TextStyle appliedTextStyle;
  BuildContext _buildContext;

  var _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController _principalController = TextEditingController();
  TextEditingController _interestController = TextEditingController();
  TextEditingController _termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    appliedTextStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minimumPadding),
          child: ListView(
            children: <Widget>[
              getImageAsset(),
              getNumberTextFieldWidget("Principal", "Enter Principal e.g 12000",
                  _principalController),
              getNumberTextFieldWidget(
                  "Rate of interest", "In percent", _interestController),
              getCombinedWidget(_termController),
              getButtonRow(),
              getTextViewWidget(_displayText)
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage moneyConverterImage = AssetImage("images/money.png");
    Image image = Image(
      image: moneyConverterImage,
      width: 125,
      height: 125,
    );

    return Container(
      margin: EdgeInsets.all(_minimumPadding * 6),
      child: image,
    );
  }

  Widget getNumberTextFieldWidget(
      String label, String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(_minimumPadding),
      child: TextFormField(
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: true),
        style: appliedTextStyle,
        controller: controller,
        validator: (String value) {
          if (value.isEmpty) {
            return "Please enter $label value";
          }
        },
        decoration: InputDecoration(
            labelText: label,
            labelStyle: appliedTextStyle,
            errorStyle: TextStyle(fontSize: 15),
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );
  }

  Widget getExpandedNumberTextFieldWidget(
      String label, String hint, TextEditingController controller) {
    return Expanded(
        child: TextFormField(
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: true),
      style: appliedTextStyle,
      controller: controller,
      validator: (String value) {
        if (value.isEmpty) {
          return "Please enter $label value";
        }
      },
      decoration: InputDecoration(
          labelText: label,
          labelStyle: appliedTextStyle,
          errorStyle: TextStyle(fontSize: 15),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    ));
  }

  Widget getCombinedWidget(TextEditingController controller) {
    return Padding(
        padding: EdgeInsets.all(_minimumPadding),
        child: Row(
          children: <Widget>[
            getExpandedNumberTextFieldWidget(
                "Term", "Time in years", controller),
            Container(
              width: _minimumPadding * 4,
            ),
            getDropDownWidget()
          ],
        ));
  }

  Widget getDropDownWidget() {
    return Expanded(
        child: DropdownButton<String>(
      items: _currencies.map((String dropdownStringItem) {
        return DropdownMenuItem<String>(
          value: dropdownStringItem,
          child: Text(dropdownStringItem),
        );
      }).toList(),
      onChanged: (String newValueSelected) {
        _onDropDownItemSelected(newValueSelected);
      },
      value: _currentItemSelected,
    ));
  }

  Widget getButtonRow() {
    return Padding(
      padding: EdgeInsets.all(_minimumPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
                color: Theme.of(_buildContext).accentColor,
                textColor: Theme.of(_buildContext).primaryColorDark,
                child: Text(
                  "Calculate",
                  textScaleFactor: 1.5,
                ),
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      _displayText = _calculateTotalReturns();
                    }
                  });
                }),
          ),
          Expanded(
            child: RaisedButton(
                color: Theme.of(_buildContext).primaryColorDark,
                textColor: Theme.of(_buildContext).primaryColorLight,
                child: Text(
                  "Reset",
                  textScaleFactor: 1.5,
                ),
                onPressed: () {
                  setState(() {
                    _reset();
                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget getTextViewWidget(String text) {
    return Padding(
        padding: EdgeInsets.all(_minimumPadding),
        child: Text(
          text,
          style: appliedTextStyle,
        ));
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
      if (_displayText.length > 0) {
        _displayText = _calculateTotalReturns();
      }
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(_principalController.text);
    double interest = double.parse(_interestController.text);
    double term = double.parse(_termController.text);

    double returns = principal + (principal * interest * term) / 100;
    return "After $term years, your investment will be worth $returns $_currentItemSelected";
  }

  void _reset() {
    _principalController.text = "";
    _interestController.text = "";
    _termController.text = "";
    _displayText = "";
    _currentItemSelected = _currencies[0];
  }
}
