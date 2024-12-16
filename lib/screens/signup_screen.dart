import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dart:ui';


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
  Widget build(BuildContext context){
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
            Image(image: AssetImage('assets/Gymbro.png'), height: heights / 4,),
            // Texto de registro
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text('Registrarse', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 37.5,
                    letterSpacing: 1
                  )
                ),
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
                        labelStyle: TextStyle(fontSize: 15 , color: Color.fromARGB(255, 150, 150, 150,)),
                        labelText: "Correo electrónico",
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Color.fromARGB(255, 222, 222, 222),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 85, 77), width: 1.5),
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
                        labelStyle: TextStyle(fontSize: 15 , color: Color.fromARGB(255, 150, 150, 150,)),
                        labelText: "Contraseña",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Color.fromARGB(255, 222, 222, 222),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 85, 77)),
                          borderRadius: BorderRadius.circular(15),    
                        )
                      ),
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
                        labelStyle: TextStyle(fontSize: 15 , color: Color.fromARGB(255, 150, 150, 150,)),
                        labelText: "Vuelve a escribir la contraseña",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Color.fromARGB(255, 222, 222, 222),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 85, 77)),
                          borderRadius: BorderRadius.circular(15),    
                        )
                      ),
                      obscureText: true,
                    ),
                  ), 
               ],
              )
            ),
            SizedBox(height: heights / 80), 
            // Espaciado y linea separadora
            Row(
              children: [
                Expanded(child: Divider(thickness: 0.8,)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('O', style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
                Expanded(child: Divider(thickness: 0.8,))
              ],
            ),
            SizedBox(height: heights / 80),
            // Botones de login con redes sociales
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: 
                    Container(
                      margin: const EdgeInsets.all(6),            
                      padding: const EdgeInsets.all(5.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), 
                        color: Colors.white, 
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]
                      ),
                      child: Image(image: AssetImage('assets/google_logo.png'), height: 25,),    
                    ),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                        SignupScreen())
                    ); 
                  },
                ),
                InkWell(
                  child: 
                    Container(
                      margin: const EdgeInsets.all(6),              
                      padding: const EdgeInsets.all(5.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), 
                        color: Colors.white, 
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3), 
                          )
                        ]
                      ),
                      child: Image(image: AssetImage('assets/facebook_logo.png'), height: 25,),
                    ),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                        SignupScreen())
                    ); 
                  },
                ),
                InkWell(
                  child: 
                    Container(
                      margin: const EdgeInsets.all(6),             
                      padding: const EdgeInsets.all(5.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), 
                        color: Colors.white, 
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3), 
                          )
                        ]
                      ),
                      child: Image(image: AssetImage('assets/microsoft_logo.png'), height: 25,),   
                    ),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                        SignupScreen())
                    ); 
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

                      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Por favor, rellena todos los campos"))
                      );
                      } else if (password != confirmPassword){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Las contraseñas no coinciden"))
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Te has registrado con exito"))
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(20), // Agrega un efecto visual al pulsar
                  child: Container(
                    width: 260,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("Registrarse", style: TextStyle(fontSize: 16,color: Color.fromARGB(200, 255, 255, 255)),)
                  ),
                ),
            ),
            // Apartado de iniciar sesion
            Text('¿Ya tienes cuenta?', 
              style: TextStyle(
                color:  Color.fromARGB(255, 156, 156, 156),
                fontSize: 14 
              ),  
            ),
            InkWell(
              child: 
                Text(
                  'Inicia sesión',
                  style: TextStyle(color: Colors.white),
                ),
              onTap: () {
                // Animacion de cambio de pantalla
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
                  )
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}