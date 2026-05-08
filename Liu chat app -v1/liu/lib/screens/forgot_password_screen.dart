import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  bool emailSent = false;

  Future<void> sendResetEmail() async {
    final email = emailController.text.trim().toLowerCase();

    if (!email.endsWith('@students.liu.edu.lb')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please use a valid LIU student email")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await supabase.auth.resetPasswordForEmail(email);

      if (mounted) setState(() => emailSent = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send reset email. Try again.")),
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
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.w),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: emailSent
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mark_email_read_outlined,
                            size: 60.sp, color: AppColors.primaryOrange),
                        SizedBox(height: 15.h),
                        Text("Reset email sent!",
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.h),
                        Text(
                          "Check your inbox and follow the link to reset your password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 20.h),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Back to Login"),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Reset Password",
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.h),
                        Text(
                          "Enter your university email and we'll send a reset link.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        SizedBox(height: 20.h),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "University Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r)),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(
                          width: double.infinity,
                          height: 55.h,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : sendResetEmail,
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text("Send Reset Email",
                                    style: TextStyle(fontSize: 16.sp)),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}