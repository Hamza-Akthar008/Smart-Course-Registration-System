import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../responsive.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../main/components/side_menu.dart';

class AddNewBatch extends StatefulWidget {
  @override
  _AddNewBatchState createState() => _AddNewBatchState();
}

class _AddNewBatchState extends State<AddNewBatch> {
  final TextEditingController batchIdController = TextEditingController();
  final TextEditingController batchNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isBatchIdValidated = false;
  bool isBatchNameValidated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardScreen(parameter: "Add New Batch"),
                      SizedBox(height: 20),
                      _buildAddBatchForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBatchForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildValidatedTextField(
            controller: batchIdController,
            labelText: 'Batch ID',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Batch ID';
              }
              return null;
            },
            prefixIcon: Icons.business,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: batchNameController,
            labelText: 'Batch Name',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Batch Name';
              }
              return null;
            },
            prefixIcon: Icons.business,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                sendDataToServer();
              }
            },
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all<Color>(Color(0xFF334155)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Square-shaped button
                ),
              ),
            ),
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.yellowAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.black)
            : null,
        suffixIcon: _buildValidationIcon(controller.text, validator),
      ),
      keyboardType: keyboardType,
      onChanged: (value) {
        setState(() {});
      },
      validator: validator,
    );
  }

  Widget _buildValidationIcon(
      String text, String? Function(String?)? validator) {
    if (text.isEmpty) {
      return SizedBox.shrink();
    }
    return Icon(
      validator?.call(text) == null ? Icons.check : Icons.clear,
      color: validator?.call(text) == null ? Colors.green : Colors.red,
    );
  }

  Future<void> sendDataToServer() async {
    final url = 'http://localhost:5000/managebatch/addnewbatch'; // Replace with your server API endpoint

    // Prepare data to send
    final data = {
      'batch_id': batchIdController.text,
      'batch_name': batchNameController.text,
    };

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final Map<String, String> headers = {
        'Authorization': '${token}',
        'Content-Type': 'application/json', // Add any other headers you need
      };
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        // Successful response from the server
        showSuccessToast('Batch added successfully');
        Navigator.pushNamed(context, '/add_new_batch');
        // Optionally, you can navigate to a new screen or show a success message
      } else {
        // Handle other response statuses
        showErrorToast('Failed to add Batch. Status code: ${response.statusCode}');
        Navigator.pushNamed(context, '/add_new_batch');
      }
    } catch (error) {
      // Handle errors
      showErrorToast('$error');
      Navigator.pushNamed(context, '/add_new_batch');
    }
  }

  void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green, // Green color for success
      textColor: Colors.white,
      timeInSecForIosWeb: 3,
    );
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red, // Red color for failure
      textColor: Colors.white,
      timeInSecForIosWeb: 3,
    );
  }
}
