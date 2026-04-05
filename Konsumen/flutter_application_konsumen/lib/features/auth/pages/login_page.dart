import 'package:flutter/material.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_input.dart';
import '../widgets/auth_button.dart';
import 'register_page.dart';
import '../services/auth_service.dart';
import '../../home/pages/home_page.dart';
import '../../../core/session/user_session.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> handleLogin() async {
    setState(() => isLoading = true);

    final result = await AuthService.login(
      username : usernameController.text,
      password : passwordController.text,
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (result["status"] == "success") {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login berhasil")),
    );
    UserSession.id = result["id"];
    UserSession.username = result["username"];
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          username: result["username"],
          userId: result["id"],
        ),
      ),
    );
    } else if (result["status"] == "not_found") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User tidak ditemukan")),
      );
    } else if (result["status"] == "wrong_password") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password salah")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.5, 0),
            end: Alignment(0.5, 1),
            colors: [AppColors.backgroundTop, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: AuthLogo(),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Selamat Datang",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 6),

                    const Text(
                      "Masuk ke akun konsumen Anda",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: 28),

                    AuthInput(
                      label: "Username",
                      hint: "Masukkan Username",
                      icon: Icons.person_outline,
                      controller: usernameController,
                    ),
                    const SizedBox(height: 20),

                    AuthInput(
                      label: "Password",
                      hint: "Masukkan Password",
                      icon: Icons.lock_outline,
                      obscure: true,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Hubungi admin untuk reset password"),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                          );
                        },
                        child: const Text(
                          "Lupa Password?",
                          style: AppTextStyles.link,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    AuthButton(
                      text: isLoading ? "Loading..." : "Masuk",
                      onPressed: isLoading ? null : handleLogin,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Belum punya akun? ",
                          style: AppTextStyles.subtitle,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Daftar Sekarang",
                            style: AppTextStyles.link,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
