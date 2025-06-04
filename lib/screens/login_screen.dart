import 'package:fitpath/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import './signup_screen.dart';

// Mueve el enum SocialLogin aquí, a nivel superior (fuera de la clase)
enum SocialLogin { google, apple }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _tryLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = ref.read(authProvider.notifier);

    // Marcar “loading” de inmediato
    setState(() => _isLoading = true);

    try {
      // 1) Aquí inicia la llamada al login (setea _isLoading=true y notifica)
      final success = await auth.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // 2) Justo después de await, ya se ejecutó el `finally` con su notifyListeners()
      //    Ahora authProvider ha cambiado estado por última vez (_isLoading=false).
      if (!mounted) return;

      if (success) {
        // Fuerza la redirección a /home:
        GoRouter.of(context).go('/home');
      }
      if (!success) {
        // Login fallido: mostramos el mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? 'Credenciales inválidas'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // 3) Si llegamos aquí, la llamada al login fue exitosa y ya se completó
      //    notifyListeners() dentro de AuthProvider. Ahora GoRouter al reconstruirse
      //    verá que isLoggedIn==true y redirigirá a /home.
      //    NO hacemos Navigator.push manual; dejamos que GoRouter se encargue.
    } catch (e, stack) {
      if (!mounted) return;
      debugPrint('Login error inesperado: $e\n$stack');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      // 4) Ya pasados los notifyListeners() internos, detenemos el spinner local:
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final orientation = MediaQuery.of(context).orientation;

    double titleFontSize = screenWidth * 0.1;
    if (titleFontSize > 60) titleFontSize = 60;
    if (titleFontSize < 36) titleFontSize = 36;

    double subtitleFontSize = screenWidth * 0.07;
    if (subtitleFontSize > 34) subtitleFontSize = 34;
    if (subtitleFontSize < 22) subtitleFontSize = 22;

    double textFieldFontSize = screenWidth * 0.04;
    if (textFieldFontSize > 18) textFieldFontSize = 18;
    if (textFieldFontSize < 14) textFieldFontSize = 14;

    double buttonVPadding = screenHeight * 0.02;
    if (buttonVPadding > 20) buttonVPadding = 20;
    if (buttonVPadding < 12) buttonVPadding = 12;

    double horizontalPadding = screenWidth * 0.08;
    if (screenWidth > 800) horizontalPadding = screenWidth * 0.2;

    double verticalPadding = screenHeight * 0.05;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF005DC8),
              Color(0xFF014594),
              Color(0xFF01336D),
              Color(0xFF001f4a),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      Text(
                        'FitPath',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.genos(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Text(
                        'Login',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      _buildEmailField(textFieldFontSize),
                      SizedBox(height: screenHeight * 0.025),
                      _buildPasswordField(textFieldFontSize),
                      SizedBox(height: screenHeight * 0.04),
                      _buildLoginButton(buttonVPadding),
                      SizedBox(height: screenHeight * 0.03),
                      _buildOrDivider(),
                      SizedBox(height: screenHeight * 0.025),
                      _buildSocialLoginSection(orientation, screenWidth),
                      SizedBox(height: screenHeight * 0.04),
                      _buildSignUpLink(context),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(double fontSize) {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(color: Colors.white, fontSize: fontSize),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white70, fontSize: fontSize * 0.9),
        hintText: 'tu@email.com',
        hintStyle: TextStyle(color: Colors.white54, fontSize: fontSize * 0.9),
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        errorStyle: TextStyle(
            color: Colors.yellowAccent[700], fontSize: fontSize * 0.8),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, ingresa tu email.';
        }
        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Por favor, ingresa un email válido.';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(double fontSize) {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.white, fontSize: fontSize),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white70, fontSize: fontSize * 0.9),
        hintText: 'Ingresa tu contraseña',
        hintStyle: TextStyle(color: Colors.white54, fontSize: fontSize * 0.9),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        errorStyle: TextStyle(
            color: Colors.yellowAccent[700], fontSize: fontSize * 0.8),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu contraseña.';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(double verticalPadding) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _tryLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF01336D),
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF01336D)),
              ),
            )
          : const Text('LOGIN'),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white54, thickness: 0.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'OR',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
        ),
        const Expanded(child: Divider(color: Colors.white54, thickness: 0.5)),
      ],
    );
  }

  Widget _buildSocialLoginSection(Orientation orientation, double screenWidth) {
    bool useRow = (orientation == Orientation.landscape && screenWidth > 600) ||
        screenWidth > 450;

    List<Widget> socialButtons = [
      Expanded(child: _buildSocialButton(SocialLogin.google)),
      SizedBox(width: useRow ? 16 : 0, height: useRow ? 0 : 16),
      Expanded(child: _buildSocialButton(SocialLogin.apple)),
    ];

    return useRow
        ? Row(children: socialButtons)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: socialButtons);
  }

  Widget _buildSocialButton(SocialLogin type) {
    void socialLoginHandler() {
      print('Login with ${type.name}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${type.name} login not implemented yet.'),
            backgroundColor: Colors.blueGrey),
      );
    }

    IconData iconData =
        type == SocialLogin.google ? Icons.g_mobiledata : Icons.apple;
    String label = type == SocialLogin.google
        ? 'Continue with Google'
        : 'Continue with Apple';
    Color iconColor =
        type == SocialLogin.google ? Colors.red.shade700 : Colors.black87;
    Color buttonTextColor = Colors.black87;

    return ElevatedButton.icon(
      onPressed: socialLoginHandler,
      icon: Icon(iconData, color: iconColor, size: 20),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: buttonTextColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: buttonTextColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: Colors.grey[300]!),
        elevation: 1,
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              );
            },
            child: Text(
              'Sign Up',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
