import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/background.png",color: Colors.white,),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () { Navigator.pushNamed(context, '/dashboard');},
          ),
          DrawerListTile(
            title: "Manage HOD",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.pushNamed(context, '/manage_hod');
            },
          ),
          DrawerListTile(
            title: "Manage Batch Advisor",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.pushNamed(context, '/manage_batch_advisor');
            },
          ),
          DrawerListTile(
            title: "Manage Student Records",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              Navigator.pushNamed(context, '/manage_student');
            },
          ),
          DrawerListTile(
            title: "Manage Study Plan",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              Navigator.pushNamed(context, '/manage_study_plan');
            },
          ),
          DrawerListTile(
            title: "Manage Offered Courses",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              Navigator.pushNamed(context, '/manage_offered_courses');
            },
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
