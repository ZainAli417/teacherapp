import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/login_provider.dart';
import 'ForgetPasswordScreen.dart';
import 'SignUp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: -10,
            child: Align(
              alignment: Alignment.topLeft,
              child: Image.asset('assets/images/upper_pattern.png'),
            ),
          ),
          Positioned(
            top: 810,
            right: 70,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset('assets/images/lower_pattern.png'),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 200),
                      Text(
                        "Let's Sign in",
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Welcome Back,\nYou've been missed!",
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller:
                        Provider.of<LoginProvider>(context).emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'johndoe@mail.com',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: Provider.of<LoginProvider>(context)
                            .passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: '********',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                     Row(
                       children: [
                         Align(
                        alignment: Alignment.centerRight,
                           child: TextButton(
                             onPressed: () {
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => SignupScreen(),
                                 ),
                               );
                             },
                             child: Text(
                               "New User? Register",
                               style: GoogleFonts.poppins(
                                 fontSize: 14,
                                 decoration: TextDecoration.underline,
                                 fontWeight: FontWeight.w500,
                                 color: Color(0xFF0A8C52),
                               ),
                             ),
                           ),

                      ),
                         SizedBox(width:50),
                         Align(
                           alignment: Alignment.centerLeft,
                           child: TextButton(
                             onPressed: () {
                               showModalBottomSheet(
                                 context: context,
                                 isScrollControlled: false,
                                 builder: (context) => ForgotPasswordScreen(),
                               );
                             },
                             child: Text(
                               'Forgot password?',
                               style: GoogleFonts.poppins(
                                 color: Color(0xFF777272),
                                 decoration: TextDecoration.underline,
                                 fontSize: 12,
                                 fontWeight: FontWeight.w400,
                               ),
                             ),
                           ),

                         ),
                  ]
                     ),
                      SizedBox(height: 20),
                      Center(
                        child: Consumer<LoginProvider>(
                          builder: (context, loginProvider, child) {
                            return ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  loginProvider.login(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0A8C52),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: loginProvider.isLoading
                                  ? const CircularProgressIndicator(
                                strokeWidth: 2, // Increase the stroke width to make it bigger
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              )
                                  : Text(
                                'Sign in',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "By logging in, you agree to our",
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.black54),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    const url = 'https://zainalidev.infy.uk';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Text(
                                    'Terms & Conditions',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF0A8C52),

                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Text(' & ',
                                    style: GoogleFonts.poppins(fontSize: 13)),
                                TextButton(
                                  onPressed: () async {
                                    const url = 'https://zainalidev.infy.uk';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Text(
                                    'Privacy Policy',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF0A8C52),

                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 200),
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
