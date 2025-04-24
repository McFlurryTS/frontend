import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/onboarding_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 1500);

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'El correo es requerido';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (password.length < 5) {
      return 'La contraseña debe tener al menos 5 caracteres';
    }
    return null;
  }

  Future<String?> _authUser(LoginData data, BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final onboardingProvider = Provider.of<OnboardingProvider>(
        context,
        listen: false,
      );

      final success = await userProvider.login(data.name, data.password);

      if (success) {
        // Si hay onboarding guardado, enviarlo al servidor
        if (onboardingProvider.form != null) {
          await onboardingProvider.checkAndSubmitSavedForm(context);
        }
        return null; // Login exitoso
      }

      return 'Usuario o contraseña incorrectos';
    } catch (e) {
      return 'Error al intentar iniciar sesión';
    }
  }

  Future<String?> _recoverPassword(String email) async {
    try {
      final emailValid = _validateEmail(email);
      if (emailValid != null) return emailValid;

      await Future.delayed(loginTime);
      return null;
    } catch (e) {
      return 'Error al intentar recuperar la contraseña';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'McDonald\'s',
      logo: const AssetImage('assets/icons/logo/72_logo.png'),
      onLogin: (loginData) => _authUser(loginData, context),
      onSignup: null,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed('/');
      },
      onRecoverPassword: _recoverPassword,
      userValidator: _validateEmail,
      passwordValidator: _validatePassword,
      theme: LoginTheme(
        primaryColor: const Color(0xFFDA291C),
        accentColor: const Color(0xFFFFC72C),
        errorColor: Colors.redAccent,
        pageColorLight: Colors.white,
        pageColorDark: Colors.white,
        logoWidth: 0.5,
        titleStyle: GoogleFonts.poppins(
          color: const Color(0xFF333333),
          fontSize: 32.0,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
        bodyStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: const Color(0xFF666666),
        ),
        textFieldStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: const Color(0xFF333333),
        ),
        buttonStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 5,
          margin: const EdgeInsets.all(4),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFFFC72C)),
          ),
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.yellow[700],
          backgroundColor: const Color(0xFFDA291C),
          highlightColor: Colors.yellow[700],
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      messages: LoginMessages(
        userHint: 'Correo electrónico',
        passwordHint: 'Contraseña',
        confirmPasswordHint: 'Confirmar contraseña',
        loginButton: 'INICIAR SESIÓN',
        signupButton: 'REGISTRARSE',
        forgotPasswordButton: '¿Olvidaste tu contraseña?',
        recoverPasswordButton: 'RECUPERAR',
        goBackButton: 'REGRESAR',
        confirmPasswordError: 'Las contraseñas no coinciden',
        recoverPasswordIntro: '¿Olvidaste tu contraseña?',
        recoverPasswordDescription:
            'Te enviaremos un correo con instrucciones para recuperar tu contraseña',
        recoverPasswordSuccess: 'Correo enviado correctamente',
      ),
    );
  }
}
