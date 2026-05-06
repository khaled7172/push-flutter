import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'major_options_screen.dart';

class MajorsScreen extends StatelessWidget {
  final String schoolName;

   MajorsScreen({
    super.key,
    required this.schoolName,
  });

  final Map<String, List<String>> schoolMajors = {
    "School of Arts & Sciences": [
      "Information Technology",
      "Computer Science",
      "Graphic Design",
      "Interior Design",
      "Advertising",
      "Journalism",
      "Public Relations",
      "Radio and Television",
      "Biochemistry",
      "Biology",
      "Biomedical Sciences",
      "Chemistry",
      "Food Technology",
      "Nutrition and Dietetics",
      "Physics",
      "Mathematics",
    ],

    "School of Business": [
      "Accounting",
      "Economics",
      "Financial Sciences",
      "Hotel and Tourism Management",
      "Business Management",
      "Management of Information Systems",
      "Marketing",
      "LIU-Worms International Business Management",
    ],

    "School of Engineering": [
      "Biomedical Engineering",
      "Computer Engineering",
      "Electrical Engineering",
      "Electronics Engineering",
      "Mechanical Engineering",
      "Surveying Engineering",
      "Communications Engineering",
      "Industrial Engineering",
    ],

    "School of Pharmacy": [
      "Pharmacy",
    ],

    "School of Education": [
      "Basic Education - English",
      "Basic Education - Mathematics",
      "Basic Education - Sciences",
      "Teaching English as a Foreign Language",
      "Education in Early Childhood Education",
      "Translation and Interpretation",
    ],
  };

  @override
  Widget build(BuildContext context) {
    final majors =
        schoolMajors[schoolName] ?? ["No majors found"];

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(

        title: Text(schoolName),
      ),

      body: ListView.builder(
        padding: EdgeInsets.all(12.w),
        itemCount: majors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Container(
              decoration: BoxDecoration(
                color:
                isDark ? Colors.white10 : Colors.white,
                borderRadius:
                BorderRadius.circular(18.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                  )
                ],
              ),
              child: ListTile(
                title: Text(
                  majors[index],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing:
                const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MajorOptionsScreen(
                        majorName: majors[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}