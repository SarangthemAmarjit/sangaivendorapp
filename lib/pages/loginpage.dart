// Login Page with Username/Password and OTP options
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sangaivendorapp/controller/managementcon.dart';
import 'package:sangaivendorapp/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  // State variables
  bool _isOtpLogin = true; // true for OTP, false for username/password
  bool _otpSent = false;
  bool _obscurePassword = true;
  int _remainingSeconds = 120;
  bool _canResend = false;
  Timer? _timer;

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _pinFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 120;
    _canResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _sendOtp() {
    if (_mobileController.text.length == 10) {
      setState(() {
        _otpSent = true;
      });
      _startTimer();
      Future.delayed(const Duration(milliseconds: 100), () {
        _pinFocusNode.requestFocus();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
    }
  }

  void _resendOtp() {
    _otpController.clear();
    _startTimer();
    _pinFocusNode.requestFocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _verifyOtp() {
    if (_otpController.text == '123456') {
      Get.offAllNamed(AppRoutes.mainpage);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Try 123456 for demo')),
      );
    }
  }

  void _loginWithPassword() {
    // Demo credentials
    if (_usernameController.text == 'demo' &&
        _passwordController.text == 'password') {
      Get.offAllNamed(AppRoutes.mainpage);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials. Try demo/password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleLoginMethod() {
    setState(() {
      _isOtpLogin = !_isOtpLogin;
      _otpSent = false;
      _timer?.cancel();
      _canResend = false;
      // Clear all fields when switching
      _mobileController.clear();
      _otpController.clear();
      _usernameController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Managementcontroller mngcon = Get.put(Managementcontroller());
    // Pinput theme configuration
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color(0xFF2D3748),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.orange, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color(0xFFE8F5E9),
        border: Border.all(color: const Color(0xFF4CAF50)),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.red, width: 2),
      ),
    );

    return Scaffold(
      body: GetBuilder<Managementcontroller>(
        builder: (_) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 251, 239, 233),
                  Color.fromARGB(255, 229, 248, 225),
                  Color.fromARGB(255, 223, 241, 247),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/logo.png', height: 150),
                        const SizedBox(height: 15),
                        const Text(
                          'Sangai Festival',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const Text(
                          'Vendor Ticket Management',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF718096),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Toggle buttons for login method
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 112, 173, 114),
                            ),
                            color: const Color(0xFFF7FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (!_isOtpLogin) _toggleLoginMethod();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      // border: Border.all(
                                      //   color: _isOtpLogin
                                      //       ? Colors.green
                                      //       : Colors.transparent,
                                      // ),
                                      color: _isOtpLogin
                                          ? Colors.orange.withOpacity(0.3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone_android,
                                          size: 18,
                                          color: _isOtpLogin
                                              ? Colors.white
                                              : const Color(0xFF718096),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'OTP Login',
                                          style: TextStyle(
                                            color: _isOtpLogin
                                                ? const Color.fromARGB(
                                                    255,
                                                    133,
                                                    132,
                                                    132,
                                                  )
                                                : const Color(0xFF718096),
                                            fontWeight: _isOtpLogin
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (_isOtpLogin) _toggleLoginMethod();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      // border: Border.all(
                                      //   color: !_isOtpLogin
                                      //       ? Colors.green
                                      //       : Colors.transparent,
                                      // ),
                                      color: !_isOtpLogin
                                          ? Colors.orange.withOpacity(0.3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.lock_outline,
                                          size: 18,
                                          color: !_isOtpLogin
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  255,
                                                  133,
                                                  132,
                                                  132,
                                                ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Password',
                                          style: TextStyle(
                                            color: !_isOtpLogin
                                                ? const Color.fromARGB(
                                                    255,
                                                    133,
                                                    132,
                                                    132,
                                                  )
                                                : const Color(0xFF718096),
                                            fontWeight: !_isOtpLogin
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // OTP Login Section
                        if (_isOtpLogin) ...[
                          if (!_otpSent) ...[
                            const Text(
                              'Enter your registered mobile number to receive OTP.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF4A5568)),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                hintText: 'Enter Mobile Number',
                                prefixIcon: const Icon(Icons.phone),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.orange,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _sendOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    143,
                                    214,
                                    230,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Send OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            Text(
                              'Enter the 6-digit OTP sent to ${_mobileController.text}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF4A5568)),
                            ),
                            const SizedBox(height: 24),
                            Pinput(
                              controller: _otpController,
                              focusNode: _pinFocusNode,
                              length: 6,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: focusedPinTheme,
                              submittedPinTheme: submittedPinTheme,
                              errorPinTheme: errorPinTheme,
                              pinputAutovalidateMode:
                                  PinputAutovalidateMode.onSubmit,
                              showCursor: true,
                              cursor: Container(
                                height: 30,
                                width: 2,
                                color: Colors.orange,
                              ),
                              onCompleted: (pin) {
                                _verifyOtp();
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _verifyOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    143,
                                    214,
                                    230,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Verify OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!_canResend) ...[
                                  const Icon(
                                    Icons.timer_outlined,
                                    size: 18,
                                    color: Color(0xFF718096),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Resend OTP in ${_formatTime(_remainingSeconds)}',
                                    style: const TextStyle(
                                      color: Color(0xFF718096),
                                      fontSize: 14,
                                    ),
                                  ),
                                ] else ...[
                                  TextButton.icon(
                                    onPressed: _resendOtp,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Resend OTP'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.orange,
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _otpSent = false;
                                  _otpController.clear();
                                  _timer?.cancel();
                                  _canResend = false;
                                });
                              },
                              child: const Text('Change Number'),
                            ),
                          ],
                        ],

                        // Username/Password Login Section
                        if (!_isOtpLogin) ...[
                          const Text(
                            'Login with your username and password.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF4A5568)),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Handle forgot password
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Password reset feature coming soon!',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                var res = await mngcon.loginforshop(
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                );

                                if (res == "Login Successfully") {
                                  mngcon.showCommonDialog(
                                    context: context,
                                    title: 'Success',
                                    message: res,
                                    isSuccess: true,
                                  );
                                } else {
                                  mngcon.showCommonDialog(
                                    context: context,
                                    title: 'Error',
                                    message: res,
                                    isSuccess: false,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  143,
                                  214,
                                  230,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: mngcon.isloadingshopregister
                                  ? SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Get.offAllNamed(AppRoutes.registrationpage);
                            },
                            child: const Text(
                              'New vendor? Register here',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
