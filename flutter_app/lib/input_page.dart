import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Page'),
      ),
      body: InputForm(),
    );
  }
}

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  TextEditingController pregnanciesController = TextEditingController();
  TextEditingController glucoseController = TextEditingController();
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController skinThicknessController = TextEditingController();
  TextEditingController insulinController = TextEditingController();
  TextEditingController bmiController = TextEditingController();
  TextEditingController diabetesPedigreeFunctionController =
      TextEditingController();
  TextEditingController ageController = TextEditingController();

  String outcome = '';

  Future<void> submitForm() async {
    // Prepare data to send to API
    Map<String, dynamic> requestData = {
      "Pregnancies": int.tryParse(pregnanciesController.text) ?? 0,
      "Glucose": int.tryParse(glucoseController.text) ?? 0,
      "BloodPressure": int.tryParse(bloodPressureController.text) ?? 0,
      "SkinThickness": int.tryParse(skinThicknessController.text) ?? 0,
      "Insulin": int.tryParse(insulinController.text) ?? 0,
      "BMI": double.tryParse(bmiController.text) ?? 0,
      "DiabetesPedigreeFunction":
          double.tryParse(diabetesPedigreeFunctionController.text) ?? 0,
      "Age": int.tryParse(ageController.text) ?? 0,
      "Outcome": 1,
    };

    // Convert data to JSON
    String jsonData = json.encode(requestData);

    // Make POST request to API
    var response = await http.post(
      Uri.parse('https://server-mwct.onrender.com/query'),
      headers: {"Content-Type": "application/json"},
      body: jsonData,
    );
    print(response);

    // Handle response
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> predictionList = responseData['prediction_label'];
      print(predictionList);
      // Display prediction in the bottom field
      setState(() {
        outcome = 'Prediction: $predictionList';
      });
    } else {
      setState(() {
        outcome = 'Error: ${response.reasonPhrase}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: pregnanciesController,
              decoration: InputDecoration(labelText: 'Pregnancies'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: glucoseController,
              decoration: InputDecoration(labelText: 'Glucose'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: bloodPressureController,
              decoration: InputDecoration(labelText: 'Blood Pressure'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: skinThicknessController,
              decoration: InputDecoration(labelText: 'Skin Thickness'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: insulinController,
              decoration: InputDecoration(labelText: 'Insulin'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: bmiController,
              decoration: InputDecoration(labelText: 'BMI'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: diabetesPedigreeFunctionController,
              decoration: InputDecoration(labelText: 'Diabetes Pedigree Function'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20), // Add spacing between text fields and button
            ElevatedButton(
              onPressed: submitForm, // Call submitForm method when button is pressed
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Text(outcome),// Display outcome
          ],
        ),
      ),
    );
  }
}
