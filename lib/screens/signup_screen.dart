import 'dart:ui';
import 'package:fitpath/screens/register/step1_signup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

enum Gender { male, female, other }

class _SignupScreenState extends ConsumerState<SignupScreen> {
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Form state
  final _formKey = GlobalKey<FormState>();
  Gender? _selectedGender;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive calculations
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;
    final bool isDesktop = screenSize.width > 1200;

    // Calculate responsive values
    final double titleFontSize = isDesktop ? 60 : (isTablet ? 54 : 48);
    final double horizontalPadding = isDesktop ? 80 : (isTablet ? 40 : 16);
    final double verticalSpacing = isDesktop ? 50 : (isTablet ? 40 : 30);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 0, 93, 200),
                  Color.fromARGB(255, 1, 69, 148),
                  Color.fromARGB(255, 1, 51, 109),
                  Color.fromARGB(255, 2, 45, 96),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 16.0,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 600 : double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: verticalSpacing),

                          // Title
                          Center(
                            child: Text(
                              'FitPath',
                              style: GoogleFonts.genos(
                                fontSize: titleFontSize,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: verticalSpacing),

                          // Sign Up Text
                          Row(
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      isDesktop ? 42 : (isTablet ? 38 : 34),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: verticalSpacing * 0.7),

                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Name field
                                _buildTextField(
                                  controller: _nameController,
                                  hintText: 'First Name',
                                  keyboardType: TextInputType.name,
                                  validator: (value) => value?.isEmpty ?? true
                                      ? 'Please enter your first name'
                                      : null,
                                ),
                                const SizedBox(height: 20),

                                // Last Name field
                                _buildTextField(
                                  controller: _lastNameController,
                                  hintText: 'Last Name',
                                  keyboardType: TextInputType.name,
                                  validator: (value) => value?.isEmpty ?? true
                                      ? 'Please enter your last name'
                                      : null,
                                ),
                                const SizedBox(height: 20),

                                // Email field
                                _buildTextField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Age field
                                _buildTextField(
                                  controller: _ageController,
                                  hintText: 'Age',
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your age';
                                    }
                                    final age = int.tryParse(value);
                                    if (age == null || age < 13 || age > 120) {
                                      return 'Please enter a valid age (13-120)';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Gender dropdown
                                _buildGenderDropdown(),
                                const SizedBox(height: 20),

                                // Password field
                                _buildTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Confirm Password field
                                _buildTextField(
                                  controller: _passwordController2,
                                  hintText: 'Confirm Password',
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: verticalSpacing),
                              ],
                            ),
                          ),

                          // Sign Up button
                          _buildSignUpButton(context),
                          const SizedBox(height: 40),

                          // OR divider
                          _buildOrDivider(),
                          SizedBox(height: verticalSpacing * 1),

                          // Social login buttons
                          _buildSocialLoginButtons(isTablet),
                          SizedBox(height: verticalSpacing),

                          // Login link
                          _buildLoginLink(context),
                        ],
                      ),
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

  // Reusable text field widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12.5),
        hintText: hintText,
        labelText: hintText,
        labelStyle: const TextStyle(color: Color.fromARGB(190, 255, 255, 255)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: const Color.fromARGB(148, 224, 224, 224),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(148, 224, 224, 224),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 85, 77), width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  // Gender selection widget
  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<Gender>(
      value: _selectedGender,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12.5),
        labelText: 'Gender',
        labelStyle: const TextStyle(color: Color.fromARGB(190, 255, 255, 255)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: const Color.fromARGB(148, 224, 224, 224),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Color.fromARGB(148, 224, 224, 224)),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 85, 77), width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      items: Gender.values.map((Gender gender) {
        return DropdownMenuItem<Gender>(
          value: gender,
          child: Text(
            gender.toString().split('.').last[0].toUpperCase() +
                gender.toString().split('.').last.substring(1),
          ),
        );
      }).toList(),
      onChanged: (Gender? value) {
        setState(() {
          _selectedGender = value;
        });
      },
      validator: (value) => value == null ? 'Please select a gender' : null,
    );
  }

  // OR divider widget
  Widget _buildOrDivider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 0.8,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'OR SIGN UP USING',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 0.8,
          ),
        ),
      ],
    );
  }

  // Social login buttons widget
  Widget _buildSocialLoginButtons(bool isTablet) {
    // For tablet and above, show buttons side by side
    if (isTablet) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSocialButton('assets/google_logo.png'),
          const SizedBox(width: 20),
          _buildSocialButton('assets/apple_logo.png'),
        ],
      );
    }

    // For mobile, keep the original row layout
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton('assets/google_logo.png'),
        _buildSocialButton('assets/apple_logo.png'),
      ],
    );
  }

  // Sign Up button
  Widget _buildSignUpButton(BuildContext context) {
    final auth = ref.read(authProvider.notifier);
    return Center(
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                if (!(_formKey.currentState?.validate() ?? false)) {
                  return;
                }

                setState(() {
                  _isLoading = true;
                });

                try {
                  // Attempt to register the user with all required fields
                  final success = await auth.register(
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                    name: _nameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                    age: int.parse(_ageController.text),
                    gender: _selectedGender.toString().split('.').last,
                  );

                  if (mounted) {
                    if (success) {
                      // Clear form on successful registration
                      _nameController.clear();
                      _lastNameController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                      _passwordController2.clear();
                      _ageController.clear();
                      setState(() => _selectedGender = null);

                      // Navigate to the next step in the registration flow
                      GoRouter.of(context).go('/home');
                    } else {
                      // Check for email already exists error
                      if (auth.error?.toLowerCase().contains('email') ??
                          false) {
                        // Show email already registered dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Email Already Registered'),
                            content: const Text(
                              'This email is already associated with an account. '
                              'Would you like to sign in with this account?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Use another email'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacementNamed(
                                    '/login',
                                    arguments: _emailController.text.trim(),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                child: const Text('Sign In'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Show other errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(auth.error ??
                                'Registration failed. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                } catch (e) {
                  // Handle unexpected errors
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'An unexpected error occurred: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  if (mounted) {
                    setState(() => _isLoading = false);
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              _isLoading ? Colors.grey : const Color.fromARGB(148, 0, 0, 0),
          minimumSize: const Size(260, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Sign Up',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  // Individual social button
  Widget _buildSocialButton(String assetPath) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Image.asset(
          assetPath,
          height: 35, // Increased icon size
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, color: Colors.red, size: 35),
        ),
      ),
      onTap: () {
        // Social login functionality would go here
      },
    );
  }

  // Login link widget
  Widget _buildLoginLink(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            'Already have an account?',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 600),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const FirstStepSignup(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: animation.value * 5,
                            sigmaY: animation.value * 5),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
