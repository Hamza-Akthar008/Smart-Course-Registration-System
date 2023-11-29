import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import '../Component/Editabledata.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main/components/side_menu.dart';

class ManageBatchAdvisor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: Column(
                children: [
                  DashboardScreen(parameter: "Manage Batch Advisor"),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(right: 30.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/add_new_batch_advisor');
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF334155)),
                        ),
                        child: Text('Add New Batch Advisor'),
                      ),
                    ),
                  ),
                  EditableDataTable(
                    headers: ['AdvisorID', 'DepartID', 'Advisor Name', 'Advisor Email', 'Advisor Contact','Edit','Delete'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
