import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:maternity_app/validation.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email address.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Password reset link sent to $email. Check your inbox.')),
      );

      Navigator.pop(context); // رجوع إلى صفحة تسجيل الدخول
    } catch (error) {
      debugPrint('Error sending reset email: $error');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to send password reset email. Try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Sign_In.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context, screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.06),
              _buildHeaderText(screenWidth),
              SizedBox(height: screenHeight * 0.04),
              _buildForm(screenHeight, screenWidth, context),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
      BuildContext context, double screenHeight, double screenWidth) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.black,
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo2.png',
            height: screenHeight * 0.08,
            width: screenWidth * 0.1,
          ),
          SizedBox(width: screenWidth * 0.02),
          Text(
            'Mamativity',
            style: GoogleFonts.inriaSerif(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(double screenWidth) {
    return Column(
      children: [
        Center(
          child: Text(
            'Forgot Password',
            style: GoogleFonts.inriaSerif(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.09,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Center(
          child: Text(
            textAlign: TextAlign.center,
            'Reset account password and access\nyour personal account again',
            style: GoogleFonts.inriaSerif(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(
      double screenHeight, double screenWidth, BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.inriaSerif(
                      textStyle: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: ColorManager.txtEditor_font_color,
                      ),
                    ),
                  ),
                  validator: (value) => InputValidator.validateEmail(value),
                ),
                SizedBox(height: screenHeight * 0.3),
                Row(
                  children: [
                    Text(
                      'Next',
                      style: GoogleFonts.inriaSerif(
                        textStyle: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_forward, color: Colors.black),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _sendPasswordResetEmail(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
