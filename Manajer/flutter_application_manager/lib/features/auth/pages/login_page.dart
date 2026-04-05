import 'package:flutter/material.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_input.dart';
import '../widgets/auth_button.dart';
import '../../home/pages/manager_home_page.dart';


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
    final username = usernameController.text;
    final password = passwordController.text;


    /// LOGIN ADMIN STATIS
    if (username == "admin" && password == "hebat123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ManagerDashboardPage(),
        ),
      );
      return;
    }
     else if (username != "admin") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User tidak ditemukan")),
      );
    } else if (password != "hebat123") {
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
                      "Masuk ke akun manajer",
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


                    AuthButton(
                      text: isLoading ? "Loading..." : "Masuk",
                      onPressed: isLoading ? null : handleLogin,
                    ),
                    const SizedBox(height: 20),
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
