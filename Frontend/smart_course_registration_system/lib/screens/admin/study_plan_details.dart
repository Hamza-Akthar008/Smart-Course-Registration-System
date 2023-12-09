import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import '../Component/Editabledata.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main/components/side_menu.dart';

class StudyPlanDetails extends StatefulWidget {
  @override
  _StudyPlanDetailsState createState() => _StudyPlanDetailsState();
}

class _StudyPlanDetailsState extends State<StudyPlanDetails> {
  late String studyplanid;
  List<String> headers = ['studplanid'];

  late Future<List<Map<String, dynamic>>> futureStudyPlans = Future.value([]);

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      studyplanid = prefs.getString('studplanid') ?? '';
      if (studyplanid.isNotEmpty) {
        // Initiate the data retrieval when the widget is first created
        futureStudyPlans = getAllStudyPlans();
      }
    });
  }

  Future<List<Map<String, dynamic>>> getAllStudyPlans() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/managestudyplan/gettstudplansbyid'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'studplanid': studyplanid}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData =
        json.decode(json.decode(response.body)['data']);
        List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(responseData);
        List<Map<String, dynamic>> localdata = [{'studplanid': '$studyplanid'}];
        localdata[0]
            .addAll(Map.fromEntries(data.map((item) => item.entries.first)));

        Set<String> allKeys = Set<String>.from(headers);
        for (var item in localdata) {
          allKeys.addAll(item.keys);
        }
        headers = allKeys.toList();
        headers.add("Edit");
        headers.add("Delete");

        return localdata;
      } else {
        print('Error fetching study plans: ${response.statusCode}');
        throw Exception('Failed to fetch study plans');
      }
    } catch (error) {
      print('Network error: $error');
      throw Exception('Network error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context)) Expanded(child: SideMenu()),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  DashboardScreen(parameter: "Study Plan Details"),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(right: 30.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  // Use FutureBuilder to handle asynchronous data retrieval
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: futureStudyPlans,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show a loading indicator while data is being fetched
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Handle error state
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Data is successfully fetched, render EditableDataTable
                        List<Map<String, dynamic>> studyPlansdetails =
                            snapshot.data ?? [];
                        return EditableDataTable(
                          headers: headers,
                          data: studyPlansdetails,
                          deleteurl:
                          'http://localhost:5000/managestudyplan/deletestudyplan',
                          editurl:
                          'http://localhost:5000/managestudyplan/editStudyPlan',
                          redirect: '/manage_study_plan',
                        );
                      }
                    },
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
