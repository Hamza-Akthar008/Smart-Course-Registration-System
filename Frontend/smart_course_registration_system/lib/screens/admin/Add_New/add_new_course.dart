import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../responsive.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../main/components/side_menu.dart';
class AddNewCourse extends StatefulWidget {
  @override
  _AddNewCourseState createState() => _AddNewCourseState();
}
class _AddNewCourseState extends State<AddNewCourse> {
  final TextEditingController courseIdController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseDescriptionController = TextEditingController();
  String? selectedCourseType;

  Future<void> _addNewCourse() async {
    final url = Uri.parse('http://localhost:5000/managecourse/addNewCourse');

    // Create a map with your course data
    final Map<String, dynamic> courseData = {
      'CourseID': courseIdController.text,
      'Course_Name': courseNameController.text,
      'Course_Type': selectedCourseType,
      'Course_Description': courseDescriptionController.text,
    };

    // Make a POST request to add a new course
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(courseData),
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Course added successfully
      showLoginSuccessToast('Course added successfully');
      // You might want to navigate to another screen or show a success message
    } else {
      // Failed to add the course
      final Map<String, dynamic> responseData = json.decode(response.body);



      showLoginFailedToast('${responseData['message']}');
      // You might want to show an error message
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                      DashboardScreen(parameter: "Add New Course "),
                      SizedBox(height: 20),
                      _buildAddCourseForm(),
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
  Widget _buildAddCourseForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildValidatedTextField(
            controller: courseIdController,
            labelText: 'Course ID',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Course ID';
              }
              return null;
            },
            prefixIcon: Icons.text_fields,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: courseNameController,
            labelText: 'Course Name',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Course Name';
              }
              return null;
            },
            prefixIcon: Icons.text_fields,
          ),
          SizedBox(height: 16),
          _buildDropdownButton(
            label: 'Course Type',
            controller: selectedCourseType,
            defaultValue: 'Select Course Type',
            prefixIcon: Icons.category,
            items: [
              DropdownMenuItem(
                value: 'Type 1',
                child: Row(
                  children: [
                    Icon(Icons.category, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Type 1', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'Type 2',
                child: Row(
                  children: [
                    Icon(Icons.category, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Type 2', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedCourseType = value;
              });
            },
          ),
          SizedBox(height: 16),
          _buildTextArea(
            controller: courseDescriptionController,
            labelText: 'Course Description',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Course Description';
              }
              return null;
            },
            prefixIcon: Icons.text_fields,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _addNewCourse();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF334155)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
    required String? controller,
    String defaultValue = '',
    IconData? prefixIcon,
    List<DropdownMenuItem<String>> items = const [],
    ValueChanged<String?>? onChanged,
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
          value: controller != null && controller.isNotEmpty ? controller : null,
          onChanged: onChanged,
          items: items,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: defaultValue,
            hintStyle: TextStyle(color: Colors.black),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value == 'Select Course Type') {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ],
    );
  }
  Widget _buildTextArea({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: null,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
        suffixIcon: _buildValidationIcon(controller.text, validator),
      ),
      keyboardType: TextInputType.multiline,
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

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String labelText,
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
      onChanged: (value) {
        setState(() {});
      },
      validator: validator,
    );
  }
}