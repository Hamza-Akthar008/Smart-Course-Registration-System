import '../../responsive.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/header.dart';

class DashboardScreen extends StatelessWidget {
   String parameter; // Add a parameter variable
  // Constructor to receive the parameter
  DashboardScreen({required this.parameter});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header( Parameter: parameter),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    // Use the 'parameter' variable as needed in your UI

                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
