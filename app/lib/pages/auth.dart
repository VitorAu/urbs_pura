import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final Color _primaryColor = const Color(0xFF09552f);
  final Color _darkTextColor = const Color(0xFF1B2921);
  final Color _bodyTextColor = const Color(0xFF526158);
  final Color _borderColor = const Color(0xFFDCE5DE);
  final Color _backgroundLight = const Color(0xFFF5F8F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: this._backgroundLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  _LoginHeader(
                    darkColor: this._bodyTextColor,
                    bodyColor: this._darkTextColor,
                  ),
                  const SizedBox(height: 48),
                  _LoginFormFields(
                    primaryColor: this._primaryColor,
                    darkColor: this._darkTextColor,
                    bodyColor: this._bodyTextColor,
                    borderColor: this._borderColor,
                    isPasswordVisible: this._isPasswordVisible,
                  ),
                  const SizedBox(height: 30),
                  _LoginButton(buttonColor: this._darkTextColor),
                  const SizedBox(height: 10),
                  _CreateAccountButton(
                    primaryColor: this._primaryColor,
                    bodyColor: this._bodyTextColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  final Color m_darkColor;
  final Color m_bodyColor;

  _LoginHeader({required Color darkColor, required bodyColor})
    : m_darkColor = darkColor,
      m_bodyColor = bodyColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 70),
        Text(
          'Cidade limpa',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: this.m_darkColor,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Digite as suas credenciais para acessar sua conta',
          style: TextStyle(
            fontSize: 16,
            color: this.m_bodyColor,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _LoginFormFields extends StatelessWidget {
  final Color m_primaryColor;
  final Color m_darkColor;
  final Color m_bodyColor;
  final Color m_borderColor;
  final bool m_isPasswordVisible;

  Widget _Label(String text) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 10, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: this.m_bodyColor.withOpacity(0.8),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _InputField(
    IconData icon,
    String hint, {
    bool isPassword = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: this.m_borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: this.m_darkColor.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword && !this.m_isPasswordVisible,
        style: TextStyle(color: this.m_darkColor, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: this.m_bodyColor.withOpacity(0.4),
            fontSize: 15,
          ),
          prefixIcon: Icon(icon, color: this.m_primaryColor, size: 22),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  _LoginFormFields({
    required Color primaryColor,
    required Color darkColor,
    required Color bodyColor,
    required Color borderColor,
    required bool isPasswordVisible,
  }) : m_primaryColor = primaryColor,
       m_darkColor = darkColor,
       m_bodyColor = bodyColor,
       m_borderColor = borderColor,
       m_isPasswordVisible = isPasswordVisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        this._Label('Email'),
        this._InputField(Icons.mail_outline_rounded, "Digite o seu email"),
        const SizedBox(height: 24),
        this._Label('Senha'),
        this._InputField(
          Icons.lock_open_rounded,
          "Digite a sua senha",
          isPassword: true,
          suffix: IconButton(
            onPressed: () {},
            icon: Icon(
              this.m_isPasswordVisible
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 20,
              color: this.m_bodyColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final Color m_buttonColor;

  const _LoginButton({required buttonColor}) : m_buttonColor = buttonColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: this.m_buttonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: () {},
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  final Color m_primaryColor;
  final Color m_bodyColor;

  const _CreateAccountButton({
    required Color primaryColor,
    required Color bodyColor,
  }) : m_primaryColor = primaryColor,
       m_bodyColor = bodyColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Deseja se cadastrar?', style: TextStyle(color: this.m_bodyColor)),
        TextButton(
          onPressed: () {},
          child: Text(
            'Criar uma conta',
            style: TextStyle(
              color: this.m_primaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
