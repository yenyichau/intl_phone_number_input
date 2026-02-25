import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intlphonenumberinputtest/app_phone_form_field.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Number Input Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: PhoneNumberPage(),
    );
  }
}

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'MY');
  // ignore: unused_field
  bool _isPhoneValid = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Phone Number Input'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Column(
          children: [
            AppPhoneFormField(
              labelText: 'Contact Phone',
              hintText: 'Enter contact phone',
              labelIsRequired: true,
              initPhoneNumber: _phoneNumber,
              onChecking: (isValid) {
                _isPhoneValid = isValid;
              },
              onChanged: (phone) {
                _phoneNumber = phone;
              },
            ),
          ],
        ));
  }
}
