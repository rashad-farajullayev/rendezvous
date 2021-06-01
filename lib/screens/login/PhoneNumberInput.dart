import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:rendezvous/constants.dart';
import 'package:rendezvous/models/Country.dart';
import 'package:rendezvous/screens/login/CodeVerificationScreen.dart';
import 'package:rendezvous/services/CountriesService.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rendezvous/widgets/buttons/PrimaryButton.dart';

class PhoneNumberInput extends StatefulWidget {
  final AuthenticationAction authenticationAction;

  PhoneNumberInput(this.authenticationAction);

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  Country _currentCountry;
  TextEditingController _countryCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String _formattedPhoneNumber = "";
  String _rawPhoneNumber = "";
  bool _isValid = false;

  @override
  void initState() {
    FlutterLibphonenumber().init();
    super.initState();
  }

  void phoneNumberChanged(Country newCountry, String newNumber) async {
    bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
        phoneNumber: newNumber,
        isoCode: newCountry == null ? "US" : newCountry.code);

    String normalizedNumber = isValid
        ? await PhoneNumberUtil.normalizePhoneNumber(
            phoneNumber: newNumber,
            isoCode: newCountry == null ? "US" : newCountry.code)
        : newNumber;

    FlutterLibphonenumber()
        .format(normalizedNumber,
            _currentCountry == null ? "US" : _currentCountry.code)
        .then((value) {
      setState(() {
        _countryCodeController.value = new TextEditingValue(
            text: newCountry == null ? "+1" : newCountry.dialCode.toString());
        _formattedPhoneNumber = value.entries.first.value;
        _rawPhoneNumber = newNumber;
        _currentCountry = newCountry;
        _isValid = isValid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var countriesFuture = CountriesService.fetchCountryData(
        context, StringConstants.COUNTRIES_LIST_ASSET);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _countryCodeController,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  onTap: () {
                    showMaterialModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return Material(
                            child: CupertinoPageScaffold(
                              navigationBar: CupertinoNavigationBar(
                                middle: Text(
                                  "Select your country",
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.grey[900]
                                          : Colors.white),
                                ),
                                brightness: Theme.of(context).brightness,
                                backgroundColor:
                                    Theme.of(context).appBarTheme.color,
                              ),
                              child: SafeArea(
                                bottom: false,
                                child: FutureBuilder<List<Country>>(
                                    future: countriesFuture,
                                    builder: (BuildContext bctx,
                                        AsyncSnapshot<List<Country>> snapshot) {
                                      if (!snapshot.hasData)
                                        return Text("Could not load countries");

                                      return ListView(
                                        shrinkWrap: true,
                                        controller:
                                            ModalScrollController.of(ctx),
                                        physics: ClampingScrollPhysics(),
                                        children: ListTile.divideTiles(
                                            context: context,
                                            tiles: List.generate(
                                              snapshot.data.length,
                                              (index) => ListTile(
                                                  title: Text(snapshot
                                                      .data[index].name),
                                                  trailing: Text(snapshot
                                                      .data[index].dialCode),
                                                  onTap: () {
                                                    setState(() {
                                                      phoneNumberChanged(
                                                          snapshot.data[index],
                                                          _rawPhoneNumber);
                                                    });
                                                    Navigator.of(ctx).pop();
                                                  }),
                                            )).toList(),
                                      );
                                    }),
                              ),
                            ),
                          );
                        });
                  },
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down), hintText: "+1"),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please provide phone number";

                      return (this._isValid ? null : "Phone number is invalid");
                    },
                    decoration: this._isValid
                        ? InputDecoration(
                            hintText: "Phone number",
                            suffixIcon: Icon(Icons.done, color: Colors.green))
                        : (_phoneNumberController.text.isEmpty
                            ? InputDecoration(hintText: "Phone number")
                            : InputDecoration(
                                hintText: "Phone number",
                                suffixIcon: InkWell(
                                  child: Icon(Icons.cancel_outlined,
                                      color: Colors.grey[600]),
                                  onTap: () {
                                    _phoneNumberController.clear();
                                    setState(() {
                                      _formattedPhoneNumber = "";
                                      _rawPhoneNumber = "";
                                      _isValid = false;
                                    });
                                  },
                                ),
                              )),
                    inputFormatters: [_PhoneNumberFormatter()],
                    onChanged: (value) {
                      phoneNumberChanged(_currentCountry, value);
                    },
                  ))
            ],
          ),
        ),
        Padding(
          child: (_formattedPhoneNumber == null || _formattedPhoneNumber.isEmpty
              ? Container()
              : Text(
                  _isValid
                      ? "SMS will be sent to: $_formattedPhoneNumber"
                      : "Invalid phone number: $_formattedPhoneNumber",
                  style: TextStyle(fontSize: 14),
                )),
          padding: EdgeInsets.only(
            bottom: 50,
          ),
        ),
        PrimaryButton(
          onPressed: !_isValid
              ? null
              : () {
                  Navigator.of(context).pushNamed(
                      CodeVerificationScreen.ROUTE_PATH,
                      arguments: CodeVerificationArgs(
                          mode: CodeVerificationMode.SMS,
                          authenticationAction: widget.authenticationAction,
                          destinationAddress: _formattedPhoneNumber));
                },
        ),
      ],
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String content = newValue.text;
    int baseOffset = newValue.selection.baseOffset;

    var digits = <String>['0', '1', '2', '3', '4', '5', '6', '7', '9'];
    String newContent = "";
    int newOffset = 0;

    // removing unneeded characters
    for (var i = 0; i < content.length; i++) {
      if (digits.contains(content[i])) {
        newContent += content[i];
        if (i < baseOffset) newOffset++;
      }
    }

    return new TextEditingValue(
        text: newContent,
        selection: TextSelection.collapsed(offset: newOffset));
  }
}
