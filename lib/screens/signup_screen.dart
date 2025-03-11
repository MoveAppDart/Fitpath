import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'dart:ui';

<<<<<<< HEAD
// Assuming FirstStepSignup is in this path, if not, adjust the import
import 'register/step1_signup.dart';

=======
>>>>>>> eedefb8cb61e311b3918b8a8856ddf0e9805cbb8
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  @override
<<<<<<< HEAD
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
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
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 40),

                          // Password field
                          _buildTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            isPassword: true,
                          ),
                          SizedBox(height: 40),
                          
                          // Confirm Password field
                          _buildTextField(
                            controller: _passwordController2,
                            hintText: 'Repeat your password',
                            isPassword: true,
                          ),
                          SizedBox(height: 40),

                           // Sign Up button
                          _buildSignUpButton(context),
                          SizedBox(height: 40),

                          // OR divider
                          _buildOrDivider(),
                          SizedBox(height: 40),

                          // Social login buttons
                          _buildSocialLoginButtons(isTablet),
                          SizedBox(height: 40),

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
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12.5),
        hintText: hintText,
        labelText: hintText,
        labelStyle: TextStyle(color: Color.fromARGB(170, 255, 255, 255)),
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
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 85, 77), width: 1.5),
          borderRadius: BorderRadius.circular(15),
=======
  Widget build(BuildContext context) {
    dynamic size, heights, width;
    size = MediaQuery.of(context).size;
    heights = size.height;
    width = size.width;
    return Scaffold(
        body: Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen del logo superior
            Image(
              image: AssetImage('assets/Gymbro.png'),
              height: heights / 4,
            ),
            // Texto de registro
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign Up',
                    style: TextStyle(
                        color: Colors.white, fontSize: 37.5, letterSpacing: 1)),
              ],
            ),
            SizedBox(height: heights / 80),
            Form(
                child: Column(
              children: [
                // Textfield de correo electronico
                Container(
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12.5),
                      labelStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(
                            255,
                            150,
                            150,
                            150,
                          )),
                      labelText: "Email",
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Color.fromARGB(255, 222, 222, 222),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 85, 77), width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: heights / 55),
                // Textfield de contraseña
                Container(
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.5),
                        labelStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(
                              255,
                              150,
                              150,
                              150,
                            )),
                        labelText: "Password",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Color.fromARGB(255, 222, 222, 222),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 85, 77)),
                          borderRadius: BorderRadius.circular(15),
                        )),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: heights / 55),
                // Textfield de volver a poner contraseña
                Container(
                  child: TextFormField(
                    controller: _passwordController2,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.5),
                        labelStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(
                              255,
                              150,
                              150,
                              150,
                            )),
                        labelText: "Repeat your password",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Color.fromARGB(255, 222, 222, 222),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 85, 77)),
                          borderRadius: BorderRadius.circular(15),
                        )),
                    obscureText: true,
                  ),
                ),
              ],
            )),
            SizedBox(height: heights / 80),
            // Espaciado y linea separadora
            Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 0.8,
                )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('OR SIGN UP USING USING',
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
                Expanded(
                    child: Divider(
                  thickness: 0.8,
                ))
              ],
            ),
            SizedBox(height: heights / 80),
            // Botones de login con redes sociales
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(5.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Image(
                      image: AssetImage('assets/google_logo.png'),
                      height: 25,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                ),
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(5.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Image(
                      image: AssetImage('assets/apple_logo.png'),
                      height: 25,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                ),
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(5.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Image(
                      image: AssetImage('assets/microsoft_logo.png'),
                      height: 25,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                ),
              ],
            ),
            SizedBox(height: heights / 12),
            // Boton de registro de sesion
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.78, 0.81, 0.84, 0.88, 1.0],
                  colors: [
                    Color(0xFF152CAF), // 78%
                    Color(0xFF142BAC), // 81%
                    Color(0xFF142AA9), // 84%
                    Color(0xFF142AA6), // 88%
                    Color(0xFF122699), // 100%
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  String confirmPassword = _passwordController2.text;

                  if (email.isEmpty ||
                      password.isEmpty ||
                      confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please fill in all the fields")));
                  } else if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("The passwords do not match.")));
                  } else {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 600),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FirstStepSignup(),
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
                  }
                },
                borderRadius: BorderRadius.circular(
                    20), // Agrega un efecto visual al pulsar
                child: Container(
                    width: 260,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(200, 255, 255, 255)),
                    )),
              ),
            ),
            // Apartado de iniciar sesion
            Text(
              'Already have an account?',
              style: TextStyle(
                  color: Color.fromARGB(255, 156, 156, 156), fontSize: 14),
            ),
            InkWell(
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Animacion de cambio de pantalla
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 600),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          LoginScreen(),
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
                    ));
              },
            ),
          ],
>>>>>>> eedefb8cb61e311b3918b8a8856ddf0e9805cbb8
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
    return Center(
      child: ElevatedButton(
        onPressed: () {
          String email = _emailController.text;
          String password = _passwordController.text;
          String confirmPassword = _passwordController2.text;

          if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please fill in all the fields"))
            );
          } else if (password != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("The passwords do not match."))
            );
          } else {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 600),
                pageBuilder: (context, animation, secondaryAnimation) => FirstStepSignup(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: animation.value * 5, sigmaY: animation.value * 5),
                      child: child,
                    ),
                  );
                },
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(148, 0, 0, 0),
          minimumSize: const Size(260, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
        child: const Text(
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
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(5.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Image.asset(
          assetPath,
          height: 25,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, color: Colors.red),
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
          Text(
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
                  transitionDuration: Duration(milliseconds: 600),
                  pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: animation.value * 5, sigmaY: animation.value * 5),
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
