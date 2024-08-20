import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/forget_password_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the viewInsets to detect keyboard height
    final viewInsets = MediaQuery.of(context).viewInsets;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: viewInsets.bottom), // Adjust padding when keyboard is up
      constraints: BoxConstraints(
        maxWidth: 500,
        maxHeight: viewInsets.bottom == 0 ? 260 : 800, // Changes height based on keyboard
      ),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10,6,10,6), // Proper padding to avoid content cut-off
        child: SafeArea(
          child: SingleChildScrollView(
            reverse: true, // Ensures the view scrolls to the bottom when the keyboard appears
            child: Column(
              mainAxisSize: MainAxisSize.max, // Takes only required space
              crossAxisAlignment: CrossAxisAlignment.center, // Makes the content full-width
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Forgot password',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_outlined),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                TextField(
                  onChanged: Provider.of<ForgotPasswordProvider>(context, listen: false).setEmail,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: Provider.of<ForgotPasswordProvider>(context, listen: false).isLoading
                        ? null
                        : () async {
                      await Provider.of<ForgotPasswordProvider>(context, listen: false)
                          .submitForgotPassword();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF044B89),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Provider.of<ForgotPasswordProvider>(context, listen: true).isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Submit',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
