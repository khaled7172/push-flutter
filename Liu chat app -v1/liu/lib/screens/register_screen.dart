import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'verify_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool isValidLiuEmail(String email) {
    email = email.trim().toLowerCase();

    RegExp regex = RegExp(
      r'^\d+@students\.liu\.edu\.lb$',
    );

    return regex.hasMatch(email);
  }

  void registerUser() {
    String email = emailController.text.trim().toLowerCase();

    if (!isValidLiuEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please use a valid LIU student email",
          ),
        ),
      );
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Passwords do not match",
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VerifyScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Stack(
        children: [

          Positioned(
            top: -70,
            left: -50,
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -80,
            right: -40,
            child: Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                color: AppColors.navyBlue.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.white,
                    borderRadius:
                    BorderRadius.circular(25.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: "Full Name",
                        ),
                      ),

                      SizedBox(height: 15.h),

                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText:
                          "University Email",
                        ),
                      ),

                      SizedBox(height: 15.h),

                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: "Password",
                        ),
                      ),

                      SizedBox(height: 15.h),

                      TextField(
                        controller:
                        confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText:
                          "Confirm Password",
                        ),
                      ),

                      SizedBox(height: 25.h),

                      SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: registerUser,
                          child: Text(
                            "Register",
                            style:
                            TextStyle(fontSize: 18.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}