import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../controllers/MenuAppController.dart';
import '../../../responsive.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../main/components/side_menu.dart';
class StudyPlanApi {
  static const String apiUrl = 'http://localhost:5000/managestudyplan/add_new_studyplan';

  static Future<void> addNewStudyPlan({
    required String studplanid,
    required String depart_id,
    required String batch_id,
    required List<StudyPlanDetail> studyPlanDetails,
  }) async {
    final Map<String, dynamic> requestData = {
      'studplanid': studplanid,
      'depart_id': depart_id,
      'batch_id': batch_id,
      'studyplan_details': studyPlanDetails.map((detail) => {
        "${detail.majorController.text}" : "${detail.numberOfCoursesController.text}",
      }).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        // Study plan created successfully
        showLoginSuccessToast('Study plan created successfully');
      } else {
        // Handle other status codes or errors
        showLoginFailedToast('Error creating study plan: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      showLoginFailedToast('Network error: $error');
    }
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
class addnewstudyplan extends StatefulWidget {
  @override
  ADDNEWSTUDYPLAN createState() => ADDNEWSTUDYPLAN();
}

class ADDNEWSTUDYPLAN extends State<addnewstudyplan> {
  final TextEditingController studplanIdController = TextEditingController();
  final TextEditingController departIdController = TextEditingController();
  final TextEditingController selectbatchController = TextEditingController();
  String? selectedDepartment;
  String? selectedBatch;
  List<StudyPlanDetail> studyPlanDetails = [];
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
                      DashboardScreen(parameter: "Add New Study Plan "),
                      SizedBox(height: 20),
                      _buildAddStudyPlanForm(),
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

  Widget _buildAddStudyPlanForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildValidatedTextField(
            controller: studplanIdController,
            labelText: 'Study Plan ID',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Study Plan ID';
              }
              return null;
            },
            prefixIcon: Icons.text_fields,
          ),
          SizedBox(height: 16),
          _buildDropdownButton(
            label: 'Department ID',
            controller: departIdController,
            defaultValue: selectedDepartment ?? 'Select Department',
            prefixIcon: Icons.business,
            items: [
              DropdownMenuItem(
                value: '101',
                child: Row(
                  children: [
                    Icon(Icons.business, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Department 101', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: '102',
                child: Row(
                  children: [
                    Icon(Icons.business, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Department 102', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedDepartment = value;
              });
            },
          ),
          SizedBox(height: 16),
          _buildDropdownButton(
            label: 'Batch ',
            controller: selectbatchController,
            defaultValue:  'Select Batch ',
            prefixIcon: Icons.group,
            items: [
              DropdownMenuItem(
                value: '2023',
                child: Row(
                  children: [
                    Icon(Icons.group, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Batch 2023', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: '2024',
                child: Row(
                  children: [
                    Icon(Icons.group, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Batch 2024', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedBatch = value;
                selectbatchController.text = value ?? '';
              });
            },
          ),
          SizedBox(height: 16),
          _buildStudyPlanDetails(),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_formKey.currentState!.validate()) {
                  StudyPlanApi.addNewStudyPlan(
                    studplanid: studplanIdController.text,
                    depart_id: selectedDepartment!,
                    batch_id: selectedBatch!,
                    studyPlanDetails: studyPlanDetails,
                  );
                }
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF334155)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Square-shaped button
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

  Widget _buildStudyPlanDetails() {
    return Column(
      children: [
        Text(
          'Study Plan Details',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: studyPlanDetails.length + 1,
          itemBuilder: (context, index) {
            if (index == studyPlanDetails.length) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    studyPlanDetails.add(StudyPlanDetail());
                  });
                },
                child: Text('Add Study Plan Detail'),
              );
            }
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildValidatedTextField(
                    controller: studyPlanDetails[index].majorController,
                    labelText: 'Course Type',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Course Type';
                      }
                      return null;
                    },
                    prefixIcon: Icons.school, // Add an icon for Course Type
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildValidatedTextField(
                    controller: studyPlanDetails[index].numberOfCoursesController,
                    labelText: 'Number of Courses',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Number of Courses';
                      }
                      return null;
                    },
                    prefixIcon: Icons.format_list_numbered, // Add an icon for Number of Courses
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      studyPlanDetails.removeAt(index);
                    });
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }


  Widget _buildDropdownButton({
    required String label,
    required TextEditingController controller,
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
          value: controller.text.isNotEmpty ? controller.text : null,
          onChanged: onChanged,
          items: items,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: defaultValue,
            hintStyle: TextStyle(color: Colors.black),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value == 'Select Department' || value == 'Select Batch') {
              return 'Please select $label';
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
        prefixIcon:
        prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
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
}

class StudyPlanDetail {
  TextEditingController majorController = TextEditingController();
  TextEditingController numberOfCoursesController = TextEditingController();
}
