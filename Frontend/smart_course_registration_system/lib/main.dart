import 'package:smart_course_registration_system/screens/Login.dart';
import 'package:smart_course_registration_system/screens/admin/Add_New/add_new_batch_advisor.dart';
import 'package:smart_course_registration_system/screens/admin/Add_New/add_new_hod.dart';
import 'package:smart_course_registration_system/screens/admin/Add_New/add_new_student.dart';
import 'package:smart_course_registration_system/screens/admin/manage_batch_advisor.dart';
import 'package:smart_course_registration_system/screens/admin/manage_hod.dart';
import 'package:smart_course_registration_system/screens/admin/manage_offered_courses.dart';
import 'package:smart_course_registration_system/screens/admin/manage_student_records.dart';
import 'package:smart_course_registration_system/screens/admin/manage_studyplan.dart';

import 'constants.dart';
import 'controllers/MenuAppController.dart';
import 'screens/main/main_screen.dart';
import 'screens/admin/manage_hod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Course Registration System',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      initialRoute: '/', // Set the initial route
      routes: {

        '/dashboard': (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MenuAppController()),
          ],
          child: MainScreen(),
        ),
        '/':(context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MenuAppController()),
          ],
          child: LoginScreen(),
        ),
        '/manage_hod':  (context) => MultiProvider(
    providers: [
    ChangeNotifierProvider(create: (context) => MenuAppController()),
    ],
    child: ManageHOD(),
    ),
        '/manage_batch_advisor':  (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MenuAppController()),
          ],
          child: ManageBatchAdvisor(),
        ),
        '/manage_student':   (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MenuAppController()),
          ],
          child: ManageStudent(),
        ),
        '/manage_study_plan':   (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MenuAppController()),
          ],
          child: ManageStudyPlan(),
        ),
        '/manage_offered_courses': (context) => MultiProvider(
    providers: [
    ChangeNotifierProvider(create: (context) => MenuAppController()),
    ],
    child: ManageOfferedCourse(),),
        '/add_new_hod': (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MenuAppController()),
          ],
          child: addnewhod(),
        ),
        '/add_new_batch_advisor': (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MenuAppController()),
          ],
          child: addnewbatchadvisor(),
        ),
        '/add_new_student': (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MenuAppController()),
          ],
          child: addnewstudent(),
        )
      },

    );

  }
}
