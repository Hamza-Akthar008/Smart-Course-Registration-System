import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/MenuAppController.dart';
import '../../../responsive.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../main/components/side_menu.dart';

class addnewstudent extends StatefulWidget {
  @override
  AddNEWSTUDENT createState() => AddNEWSTUDENT();
}

class AddNEWSTUDENT extends State<addnewstudent> {
  final TextEditingController StudentIdController = TextEditingController();
  final TextEditingController StudentCNICController = TextEditingController();
  final TextEditingController StudentAddressController = TextEditingController();
  final TextEditingController StudentController = TextEditingController();
  final TextEditingController selectbatchController = TextEditingController();
  final TextEditingController departIdController = TextEditingController();
  final TextEditingController StudentNameController = TextEditingController();
  final TextEditingController StudentEmailController = TextEditingController();
  final TextEditingController StudentContactController = TextEditingController();
  final TextEditingController StudentPasswordController = TextEditingController();
  String? selectedDepartment;
  String? selectedBatch;
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
                      DashboardScreen(parameter: "Add New Student "),
                      SizedBox(height: 20),
                      _buildAddBatchAdvisorForm(),
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

  Widget _buildAddBatchAdvisorForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildValidatedTextField(
            controller: StudentIdController,
            labelText: 'Student ID',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Batch Advisor ID';
              }
              return null;
            },
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: StudentCNICController,
            labelText: 'Student CNIC',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Student CNIC';
              }
              if (value.length > 13) {
                return 'Please enter Valid CNIC address';
              }
              return null;
            },
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: StudentAddressController,
            labelText: 'Student Address',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Student Address';
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
          _buildValidatedTextField(
            controller: StudentNameController,
            labelText: 'Student Name',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Batch Advisor Name';
              }
              return null;
            },
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: StudentEmailController,
            labelText: 'Student Email',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter student Email';
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
            controller: StudentContactController,
            labelText: 'Student Contact',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Student Contact';
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            prefixIcon: Icons.phone,
          ),
          SizedBox(height: 16),
          _buildValidatedTextField(
            controller: StudentPasswordController,
            labelText: 'Student Password',
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Student Password';
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
                // Handle form submission
                // You can access the entered values using the controller.text
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
