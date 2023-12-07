import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../controllers/MenuAppController.dart';
import '../../../responsive.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../main/components/side_menu.dart';

class addnewhod extends StatefulWidget {
  @override
  _AddNewHODState createState() => _AddNewHODState();
}

class _AddNewHODState extends State<addnewhod> {
  final TextEditingController hodIdController = TextEditingController();
  final TextEditingController departIdController = TextEditingController();
  final TextEditingController hodNameController = TextEditingController();
  final TextEditingController hodEmailController = TextEditingController();
  final TextEditingController hodContactController = TextEditingController();
  final TextEditingController hodPasswordController = TextEditingController();
  String? selectedDepartment;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isHodIdValidated = false;
  bool isHodNameValidated = false;
  bool isHodEmailValidated = false;
  bool isHodContactValidated = false;
  bool isHodPasswordValidated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context
          .read<MenuAppController>()
          .scaffoldKey,
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
                      DashboardScreen(parameter: "Add New HOD"),
                      SizedBox(height: 20),
                      _buildAddHodForm(),
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

  Widget _buildAddHodForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildValidatedTextField(
            controller: hodIdController,
            labelText: 'HOD ID',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter HOD ID';
              }
              return null;
            },
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 16),
          _buildDropdownButton(
            label: 'Department ID',
            controller: departIdController,
            defaultValue: selectedDepartment ?? 'Select Department',
            prefixIcon: Icons.business,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: hodNameController,
            labelText: 'HOD Name',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter HOD Name';
              }
              return null;
            },
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: hodEmailController,
            labelText: 'HOD Email',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter HOD Email';
              } else if (!RegExp(
                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            prefixIcon: Icons.email,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: hodContactController,
            labelText: 'HOD Contact',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter HOD Contact';
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            prefixIcon: Icons.phone,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: hodPasswordController,
            labelText: 'HOD Password',
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter HOD Password';
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
            prefixIcon: Icons.lock,
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

  Widget _buildDropdownButton({
    required String label,
    required TextEditingController controller,
    String defaultValue = '',
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (prefixIcon != null)
              Icon(prefixIcon, color: Colors.black),
            Text(label, style: TextStyle(color: Colors.black)),
          ],
        ),
        DropdownButtonFormField<String>(
          value: selectedDepartment,
          onChanged: (value) {
            setState(() {
              selectedDepartment = value;
              controller.text = value ?? '';
            });
          },
          items: [
            DropdownMenuItem(
              value: '101',
              child: Row(
                children: [
                  if (prefixIcon != null)
                    Icon(prefixIcon, color: Colors.black),
                  Text('Department 101', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: '102',
              child: Row(
                children: [
                  if (prefixIcon != null)
                    Icon(prefixIcon, color: Colors.black),
                  Text('Department 102', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: defaultValue,
            hintStyle: TextStyle(color: Colors.black),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value == 'Select Department') {
              return 'Please select a department';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
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
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
        suffixIcon: _buildValidationIcon(controller.text, validator),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: (value) {
        setState(() {});
      },
      validator: validator,
    );
  }

  Widget _buildValidationIcon(String text, String? Function(String?)? validator) {
    if (text.isEmpty) {
      return SizedBox.shrink();
    }
    return Icon(
      validator?.call(text) == null ? Icons.check : Icons.clear,
      color: validator?.call(text) == null ? Colors.green : Colors.red,
    );
  }

  Future<void> sendDataToServer() async {
    final url = 'http://localhost:5000/managehod/add_new_hod'; // Replace with your server API endpoint

    // Prepare data to send

    final data = {
      'HODID': hodIdController.text,
      'depart_id': departIdController.text,
      'Hod_name': hodNameController.text,
      'hod_email': hodEmailController.text,
      'hod_contact': hodContactController.text,
      'hod_password': hodPasswordController.text,
    };

    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        // Successful response from the server

        showLoginSuccessToast('HOD added successfully');
        Navigator.pushNamed(context, '/add_new_hod');
        // Optionally, you can navigate to a new screen or show a success message
      } else {
        // Handle other response statuses
        showLoginFailedToast('Failed to add HOD. Status code: ${response.statusCode}');
        Navigator.pushNamed(context, '/add_new_hod');
      }
    } catch (error) {
      // Handle errors
      showLoginFailedToast('$error');
      Navigator.pushNamed(context, '/add_new_hod');
    }
  }
  void showLoginFailedToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red, // Red color for failure
      textColor: Colors.white,
      timeInSecForIosWeb: 3,
    );
  }

  void showLoginSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green, // Green color for success
      textColor: Colors.white,
      timeInSecForIosWeb: 3,
    );
  }
}
