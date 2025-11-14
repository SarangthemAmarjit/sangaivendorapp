// Registration Page
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sangaivendorapp/pages/loginpage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _boothIdController = TextEditingController();
  final TextEditingController _rangeStartController = TextEditingController();
  final TextEditingController _rangeEndController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final TextEditingController _otpController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _otpSent = false;
  int _remainingSeconds = 120; // 2 minutes
  bool _canResend = false;
  Timer? _timer;

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

  void _sendOtp() {
  if(_formKey.currentState!.validate()){
    if (_mobileController.text.length == 10) {
      setState(() {
        _otpSent = true;
      });
      _startTimer();
      // Auto-focus on PIN input after OTP is sent
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


  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
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

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _verifyOtp() {
    if (_otpController.text == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Try 123456 for demo')),
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _pinFocusNode.dispose();
    _timer?.cancel();

    _shopNameController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        height: MediaQuery.of(context).size.height,
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/images/msflogo.png', height: 150),

                  // Container(
                  //   width: 80,
                  //   height: 80,
                  //   decoration: BoxDecoration(
                  //     gradient: const LinearGradient(
                  //       colors: [Colors.orange, Colors.red],
                  //     ),
                  //     borderRadius: BorderRadius.circular(40),
                  //   ),
                  //   child: const Icon(
                  //     Icons.store,
                  //     size: 40,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  const Text(
                    'Vendor Registration',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),

                  const Text(
                    'Sangai Festival 2025',
                    style: TextStyle(fontSize: 16, color: Color(0xFF718096)),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !_otpSent
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Shop Information',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D3748),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _shopNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Full Name *',
                                        hintText: 'Enter your full name',
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          color: Colors.orange,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.orange,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter full name';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // declare this in your State class
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        labelText: 'Password *',
                                        hintText: 'Enter your password',
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: Colors.orange,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.orange,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.orange,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        } else if (value.length < 6) {
                                          return 'Password must be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _mobileController,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        labelText: 'Mobile Number *',
                                        hintText:
                                            'Enter 10-digit mobile number',
                                        prefixIcon: const Icon(
                                          Icons.phone,
                                          color: Colors.orange,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.orange,
                                            width: 2,
                                          ),
                                        ),
                                        counterText: '',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter mobile number';
                                        }
                                        if (value.length != 10) {
                                          return 'Mobile number must be 10 digits';
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _sendOtp,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            143,
                                            214,
                                            230,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: _isLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : const Text(
                                                'Send OTP',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Already registered? Login here',
                                          style: TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Verify Code',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D3748),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      'Enter the 6-digit OTP sent to ${_mobileController.text}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF4A5568),
                                      ),
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
                                        // Auto-verify when all digits are entered
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                    // Timer and Resend OTP Section
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  ],
                                ),

                          // const SizedBox(height: 24),
                          // const Text(
                          //   'Ticket Range Assignment',
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.bold,
                          //     color: Color(0xFF2D3748),
                          //   ),
                          // ),
                          // const SizedBox(height: 16),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: TextFormField(
                          //         controller: _rangeStartController,
                          //         keyboardType: TextInputType.number,
                          //         decoration: InputDecoration(
                          //           labelText: 'Start Number *',
                          //           hintText: 'e.g., 1001',
                          //           prefixIcon: const Icon(
                          //             Icons.confirmation_number,
                          //             color: Colors.orange,
                          //           ),
                          //           border: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //           ),
                          //           focusedBorder: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //             borderSide: const BorderSide(
                          //               color: Colors.orange,
                          //               width: 2,
                          //             ),
                          //           ),
                          //         ),
                          //         validator: (value) {
                          //           if (value == null || value.isEmpty) {
                          //             return 'Required';
                          //           }
                          //           if (int.tryParse(value) == null) {
                          //             return 'Invalid number';
                          //           }
                          //           return null;
                          //         },
                          //       ),
                          //     ),
                          //     const SizedBox(width: 16),
                          //     Expanded(
                          //       child: TextFormField(
                          //         controller: _rangeEndController,
                          //         keyboardType: TextInputType.number,
                          //         decoration: InputDecoration(
                          //           labelText: 'End Number *',
                          //           hintText: 'e.g., 1500',
                          //           prefixIcon: const Icon(
                          //             Icons.confirmation_number_outlined,
                          //             color: Colors.orange,
                          //           ),
                          //           border: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //           ),
                          //           focusedBorder: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //             borderSide: const BorderSide(
                          //               color: Colors.orange,
                          //               width: 2,
                          //             ),
                          //           ),
                          //         ),
                          //         validator: (value) {
                          //           if (value == null || value.isEmpty) {
                          //             return 'Required';
                          //           }
                          //           if (int.tryParse(value) == null) {
                          //             return 'Invalid number';
                          //           }
                          //           int? start = int.tryParse(
                          //             _rangeStartController.text,
                          //           );
                          //           int? end = int.tryParse(value);
                          //           if (start != null &&
                          //               end != null &&
                          //               end <= start) {
                          //             return 'Must be > start';
                          //           }
                          //           return null;
                          //         },
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 24),
                          // Container(
                          //   padding: const EdgeInsets.all(12),
                          //   decoration: BoxDecoration(
                          //     color: Colors.blue.shade50,
                          //     borderRadius: BorderRadius.circular(8),
                          //     border: Border.all(color: Colors.blue.shade200),
                          //   ),
                          //   child: Row(
                          //     children: const [
                          //       Icon(
                          //         Icons.info_outline,
                          //         color: Colors.blue,
                          //         size: 20,
                          //       ),
                          //       SizedBox(width: 8),
                          //       Expanded(
                          //         child: Text(
                          //           'Total tickets will be calculated automatically based on the range',
                          //           style: TextStyle(
                          //             fontSize: 12,
                          //             color: Colors.blue,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
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
  }
}
