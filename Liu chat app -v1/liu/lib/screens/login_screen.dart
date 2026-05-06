import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../main.dart';
import 'register_screen.dart';
import 'verify_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  bool isValidLiuEmail(String email) {
    return email.trim().toLowerCase().endsWith('@students.liu.edu.lb');
  }

  Future<void> loginUser() async {
    String email = emailController.text.trim().toLowerCase();

    if (!isValidLiuEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please use a valid LIU student email")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await supabase.auth.signInWithOtp(email: email);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyScreen(email: email),
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong. Try again.")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -50,
            child: Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 250.w,
              height: 250.w,
              decoration: BoxDecoration(
                color: AppColors.navyBlue.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(25.w),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 20)
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "University Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : loginUser,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text("Send OTP", style: TextStyle(fontSize: 18.sp)),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
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