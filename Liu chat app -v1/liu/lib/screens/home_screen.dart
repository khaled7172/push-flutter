import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'majors_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> schools = [
    "School of Arts & Sciences",
    "School of Business",
    "School of Engineering",
    "School of Pharmacy",
    "School of Education",
  ];

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(

        title: const Text("LIU Schools"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: EdgeInsets.only(top: 25.h),
        itemCount: schools.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.only(
                bottom: 30.h,
                left: 12.w,
                right: 12.w,),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  MajorsScreen(
                      schoolName: schools[index],
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(33.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white10
                      : Colors.white,
                  borderRadius:
                  BorderRadius.circular(20.r),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.school,
                      color: AppColors.primaryOrange,
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Text(
                        schools[index],
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}