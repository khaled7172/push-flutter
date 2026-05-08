import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../main.dart';
import '../services/encryption_service.dart';
import 'home_screen.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  Future<void> verifyCode() async {
    String code = codeController.text.trim();

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the 6-digit code")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await supabase.auth.verifyOTP(
        email: widget.email,
        token: code,
        type: OtpType.signUp,
      );

      // Initialize E2E encryption keys after successful login
      await EncryptionService.initializeKeys();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
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
          const SnackBar(content: Text("Verification failed. Try again.")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> resendCode() async {
    try {
      await supabase.auth.signInWithOtp(email: widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Code resent to your email")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to resend code")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -40,
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
            left: -50,
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
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Container(
                padding: EdgeInsets.all(25.w),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 20)
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Email Verification",
                      style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "Enter the 6-digit code sent to ${widget.email}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 25.h),
                    TextField(
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(hintText: "Enter Code"),
                    ),
                    SizedBox(height: 25.h),
                    SizedBox(
                      width: double.infinity,
                      height: 55.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : verifyCode,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text("Verify", style: TextStyle(fontSize: 18.sp)),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    TextButton(
                      onPressed: resendCode,
                      child: const Text("Resend Code"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}