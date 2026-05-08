import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../main.dart';
import 'verify_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  bool isValidLiuEmail(String email) {
    return email.trim().toLowerCase().endsWith('@students.liu.edu.lb');
  }

  Future<void> registerUser() async {
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (!isValidLiuEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please use a valid LIU student email")),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await supabase.auth.signUp(email: email, password: password);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VerifyScreen(email: email)),
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
      appBar: AppBar(title: const Text("Register")),
      body: Stack(
        children: [
          Positioned(
            top: -70, left: -50,
            child: Container(
              width: 180.w, height: 180.w,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80, right: -40,
            child: Container(
              width: 220.w, height: 220.w,
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
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Create Account",
                          style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20.h),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "University Email (@students.liu.edu.lb)",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r)),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          hintText: "Password (min 6 characters)",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r)),
                          suffixIcon: IconButton(
                            icon: Icon(obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => obscurePassword = !obscurePassword),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirm,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r)),
                          suffixIcon: IconButton(
                            icon: Icon(obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => obscureConfirm = !obscureConfirm),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : registerUser,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text("Register", style: TextStyle(fontSize: 18.sp)),
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