
import 'package:flutter/material.dart';
import 'package:app/repositories/auth.dart';
import 'package:app/models/user.dart';
import 'package:app/models/response/success.dart';
import 'package:app/models/response/error.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final TextEditingController m_nameController = TextEditingController();
  final TextEditingController m_usernameController = TextEditingController();
  final TextEditingController m_emailController = TextEditingController();
  final TextEditingController m_phoneController = TextEditingController();
  final TextEditingController m_passwordController = TextEditingController();
  final TextEditingController m_confirmPasswordController =
      TextEditingController();

  final AuthRepository m_authRepository = AuthRepository();

  final Color _primaryColor = const Color(0xFF09552f);
  final Color _darkTextColor = const Color(0xFF1B2921);
  final Color _bodyTextColor = const Color(0xFF526158);
  final Color _borderColor = const Color(0xFFDCE5DE);
  final Color _backgroundLight = const Color(0xFFF5F8F5);

  Future<void> Register() async {
    if (m_nameController.text.trim().isEmpty ||
        m_usernameController.text.trim().isEmpty ||
        m_emailController.text.trim().isEmpty ||
        m_phoneController.text.trim().isEmpty ||
        m_passwordController.text.isEmpty ||
        m_confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    if (m_passwordController.text != m_confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await m_authRepository.Register(
        name: m_nameController.text.trim(),
        username: m_usernameController.text.trim(),
        email: m_emailController.text.trim(),
        phone: m_phoneController.text.trim(),
        password: m_passwordController.text,
      );

      if (!mounted) return;

      if (response is SuccessResponseModel<UserModel>) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada com sucesso!')),
        );

        Navigator.pop(context);
      } else if (response is ErrorResponseModel) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.m_message)),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar conta: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    m_nameController.dispose();
    m_usernameController.dispose();
    m_emailController.dispose();
    m_phoneController.dispose();
    m_passwordController.dispose();
    m_confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundLight,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            _RegisterHeader(
              darkColor: _bodyTextColor,
              bodyColor: _darkTextColor,
            ),
            const SizedBox(height: 48),
            _RegisterFormFields(
              primaryColor: _primaryColor,
              darkColor: _darkTextColor,
              bodyColor: _bodyTextColor,
              borderColor: _borderColor,
              isPasswordVisible: _isPasswordVisible,
              nameController: m_nameController,
              usernameController: m_usernameController,
              emailController: m_emailController,
              phoneController: m_phoneController,
              passwordController: m_passwordController,
              confirmPasswordController: m_confirmPasswordController,
              onTogglePassword: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 30),
            _RegisterButton(
              buttonColor: _darkTextColor,
              isLoading: _isLoading,
              onPressed: Register,
            ),
            const SizedBox(height: 10),
            _CreateAccountButton(
              primaryColor: _primaryColor,
              bodyColor: _bodyTextColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  final Color m_darkColor;
  final Color m_bodyColor;

  const _RegisterHeader({
    required Color darkColor,
    required Color bodyColor,
  }) : m_darkColor = darkColor,
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
            color: m_darkColor,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Preencha os dados para criar sua conta',
          style: TextStyle(
            fontSize: 16,
            color: m_bodyColor,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _RegisterFormFields extends StatelessWidget {
  final Color m_primaryColor;
  final Color m_darkColor;
  final Color m_bodyColor;
  final Color m_borderColor;
  final bool m_isPasswordVisible;

  final TextEditingController m_nameController;
  final TextEditingController m_usernameController;
  final TextEditingController m_emailController;
  final TextEditingController m_phoneController;
  final TextEditingController m_passwordController;
  final TextEditingController m_confirmPasswordController;

  final VoidCallback m_onTogglePassword;

  _RegisterFormFields({
    required Color primaryColor,
    required Color darkColor,
    required Color bodyColor,
    required Color borderColor,
    required bool isPasswordVisible,
    required TextEditingController nameController,
    required TextEditingController usernameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required VoidCallback onTogglePassword,
  }) : m_primaryColor = primaryColor,
       m_darkColor = darkColor,
       m_bodyColor = bodyColor,
       m_borderColor = borderColor,
       m_isPasswordVisible = isPasswordVisible,
       m_nameController = nameController,
       m_usernameController = usernameController,
       m_emailController = emailController,
       m_phoneController = phoneController,
       m_passwordController = passwordController,
       m_confirmPasswordController = confirmPasswordController,
       m_onTogglePassword = onTogglePassword;

  Widget _Label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: m_bodyColor.withOpacity(0.8),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: m_borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: m_darkColor.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !m_isPasswordVisible,
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : TextInputType.text,
        style: TextStyle(
          color: m_darkColor,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: m_bodyColor.withOpacity(0.4),
            fontSize: 15,
          ),
          prefixIcon: Icon(icon, color: m_primaryColor, size: 22),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: m_onTogglePassword,
                  icon: Icon(
                    m_isPasswordVisible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    size: 20,
                    color: m_bodyColor,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label('Nome completo'),
        _InputField(
          Icons.person_outline_rounded,
          'Digite seu nome',
          m_nameController,
        ),
        const SizedBox(height: 20),
        _Label('Nome de usuário'),
        _InputField(
          Icons.alternate_email_rounded,
          'Digite seu nome de usuário',
          m_usernameController,
        ),
        const SizedBox(height: 20),
        _Label('Email'),
        _InputField(
          Icons.mail_outline_rounded,
          'Digite seu email',
          m_emailController,
        ),
        const SizedBox(height: 20),
        _Label('Telefone'),
        _InputField(
          Icons.phone_outlined,
          'Digite seu telefone',
          m_phoneController,
        ),
        const SizedBox(height: 20),
        _Label('Senha'),
        _InputField(
          Icons.lock_open_rounded,
          'Digite sua senha',
          m_passwordController,
          isPassword: true,
        ),
        const SizedBox(height: 20),
        _Label('Confirmar senha'),
        _InputField(
          Icons.lock_outline_rounded,
          'Confirme sua senha',
          m_confirmPasswordController,
          isPassword: true,
        ),
      ],
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final Color m_buttonColor;
  final bool m_isLoading;
  final VoidCallback m_onPressed;

  const _RegisterButton({
    required Color buttonColor,
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
          backgroundColor: m_buttonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: m_isLoading ? null : m_onPressed,
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
                'Criar conta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
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
        Text('Já possui uma conta?', style: TextStyle(color: m_bodyColor)),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Entrar',
            style: TextStyle(
              color: m_primaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
