import 'package:app/config/token.dart';
import 'package:app/models/auth.dart';
import 'package:app/models/response/error.dart';
import 'package:app/models/response/success.dart';
import 'package:app/pages/register.dart';
import 'package:app/repositories/auth.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/map.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final TextEditingController m_emailController = TextEditingController();
  final TextEditingController m_passwordController = TextEditingController();

  final AuthRepository m_authRepository = AuthRepository();

  final Color _primaryColor = const Color(0xFF09552f);
  final Color _darkTextColor = const Color(0xFF1B2921);
  final Color _bodyTextColor = const Color(0xFF526158);
  final Color _borderColor = const Color(0xFFDCE5DE);
  final Color _backgroundLight = const Color(0xFFF5F8F5);

  Future<void> Login() async {
    if (m_emailController.text.trim().isEmpty ||
        m_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await m_authRepository.Login(
        email: m_emailController.text.trim(),
        password: m_passwordController.text,
      );

      if (!mounted) return;

      if (response is SuccessResponseModel<AuthModel>) {
        final auth = response.m_data;

        if (auth == null) {
          throw Exception('Resposta inválida do servidor.');
        }

        await Token.Save(
          accessToken: auth.m_accessToken,
          refreshToken: auth.m_refreshToken,
        );

        if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Login realizado com sucesso!'),
  ),
);

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const MapPage(),
  ),
);      } else if (response is ErrorResponseModel) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.m_message)));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao realizar login: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }



  @override
  void dispose() {
    m_emailController.dispose();
    m_passwordController.dispose();
    super.dispose();
  }

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
                    emailController: m_emailController,
                    passwordController: m_passwordController,
                    onTogglePassword: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  _LoginButton(
                    buttonColor: this._darkTextColor,
                    isLoading: this._isLoading,
                    onPressed: this.Login,
                  ),
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
  final TextEditingController m_emailController;
  final TextEditingController m_passwordController;
  final VoidCallback m_onTogglePassword;

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
    String hint,
    TextEditingController controller, {
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
        controller: controller,
        obscureText: isPassword && !this.m_isPasswordVisible,
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
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
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required VoidCallback onTogglePassword,
  }) : m_primaryColor = primaryColor,
       m_darkColor = darkColor,
       m_bodyColor = bodyColor,
       m_borderColor = borderColor,
       m_isPasswordVisible = isPasswordVisible,
       m_emailController = emailController,
       m_passwordController = passwordController,
       m_onTogglePassword = onTogglePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        this._Label('Email'),
        this._InputField(
          Icons.mail_outline_rounded,
          "Digite o seu email",
          m_emailController,
        ),
        const SizedBox(height: 24),
        this._Label('Senha'),
        this._InputField(
          Icons.lock_open_rounded,
          "Digite a sua senha",
          m_passwordController,
          isPassword: true,
          suffix: IconButton(
            onPressed: m_onTogglePassword,
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
  final bool m_isLoading;
  final VoidCallback m_onPressed;

  const _LoginButton({
    required buttonColor,
    required bool isLoading,
    required VoidCallback onPressed,
  }) : m_buttonColor = buttonColor,
       m_isLoading = isLoading,
       m_onPressed = onPressed;

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
        onPressed: this.m_isLoading ? null : this.m_onPressed,
        child: m_isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
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
