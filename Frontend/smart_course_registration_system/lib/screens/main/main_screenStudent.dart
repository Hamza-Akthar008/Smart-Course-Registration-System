import 'package:smart_course_registration_system/screens/dashboard/dashboard_screenStudent.dart';
import 'package:smart_course_registration_system/screens/main/components/side_menuStudent.dart';

import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MainScreenStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenuStudent(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenuStudent(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreenStudent(parameter: 'DashboardStudent'),
            ),
          ],
        ),
      ),
    );
  }
}
