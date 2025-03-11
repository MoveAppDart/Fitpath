import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'bottom_navbar.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    // Get screen size for responsive calculations
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;
    final bool isDesktop = screenSize.width > 1200;
    
    // Calcul dels valors responsive
    final double titleFontSize = isDesktop ? 90 : (isTablet ? 72 : 60); // Larger base values
    final double horizontalPadding = isDesktop ? 80 : (isTablet ? 40 : 16);
    final double verticalSpacing = isDesktop ? 50 : (isTablet ? 40 : 30);
    
=======
>>>>>>> eedefb8cb61e311b3918b8a8856ddf0e9805cbb8
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
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
                          SizedBox(height: 40),
                          
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
                          SizedBox(height: 40),
                          
                          // Login Text
                          Row(
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isDesktop ? 42 : (isTablet ? 38 : 34),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Email field
                          _buildTextField(
                            controller: _emailController,
                            hintText: 'example@example.com',
                          ),
                          const SizedBox(height: 40),

                          // Password field
                          _buildTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            isPassword: true,
                          ),
                          SizedBox(height: 40),

                          // Login button
                          _buildLoginButton(context),
                          const SizedBox(height: 40),

                          // OR divider
                          _buildOrDivider(),
                          SizedBox(height: 40),

                          // Social login buttons
                          _buildSocialLoginButtons(isTablet),
                          SizedBox(height: 40),

                          // Sign up link
                          _buildSignUpLink(context),
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
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12.5),
        hintText: hintText,
        filled: true,
        fillColor: const Color.fromARGB(148, 224, 224, 224),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(170, 255, 255, 255),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  // Login button widget
  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter both email and password'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavbar()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(148, 0, 0, 0),
          minimumSize: const Size(260, 50),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // OR divider widget
  Widget _buildOrDivider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 1,
          ),
        ),
<<<<<<< HEAD
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('OR', style: TextStyle(color: Colors.white)),
        ),
        Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 1,
=======
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Title
                  Center(
                    child: Text(
                      'FitPath',
                      style: GoogleFonts.genos(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email field
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12.5),
                      hintText: 'example@example.com',
                      filled: true,
                      fillColor: const Color.fromARGB(148, 224, 224, 224),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(148, 224, 224, 224),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12.5),
                      hintText: 'Password',
                      filled: true,
                      fillColor: const Color.fromARGB(148, 224, 224, 224),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(148, 224, 224, 224),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Login button
                  ElevatedButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please enter both email and password'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavbar()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(148, 0, 0, 0),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Segunda opción de login
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child:
                            Text('OR', style: TextStyle(color: Colors.white)),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Botones de inicio de sesión con Google y Apple.
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/google_logo.png',
                          width: 18,
                          height: 18,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),
                        label: const Text(
                          'Continue with Google',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side:
                              BorderSide(color: Colors.black.withOpacity(0.1)),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 50),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/apple_logo.png',
                          width: 19,
                          height: 19,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),
                        label: const Text(
                          'Continue with Apple',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side:
                              BorderSide(color: Colors.black.withOpacity(0.1)),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Enlace para ir a la pantalla de registro.
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SignupScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Don\'t Have An Account? Sign Up Here!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
>>>>>>> eedefb8cb61e311b3918b8a8856ddf0e9805cbb8
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
        children: [
          Expanded(child: _buildGoogleButton()),
          const SizedBox(width: 70),
          Expanded(child: _buildAppleButton()),
        ],
      );
    }
    
    // For mobile, stack buttons vertically
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGoogleButton(),
        const SizedBox(height: 40),
        _buildAppleButton(),
      ],
    );
  }

  // Google login button
  Widget _buildGoogleButton() {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Image.asset(
          'assets/google_logo.png',
          width: 18,
          height: 18,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, color: Colors.red),
        ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: const BorderSide(color: Colors.black12), // Fixed opacity
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  // Apple login button
  Widget _buildAppleButton() {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Image.asset(
          'assets/apple_logo.png',
          width: 19,
          height: 19,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, color: Colors.red),
        ),
        label: const Text(
          'Continue with Apple',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: const BorderSide(color: Colors.black12), // Fixed opacity
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  // Sign up link widget
  Widget _buildSignUpLink(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SignupScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
        child: const Text(
          'Don\'t Have An Account? Sign Up Here!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
