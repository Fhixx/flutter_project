import 'package:flutter/material.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_input.dart';
import '../widgets/auth_button.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final alamatController = TextEditingController();
  final teleponController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool isLoading = false;

  Future<void> handleRegister() async {
    if (passwordController.text != confirmController.text) {
      _showMsg("Password tidak sama");
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await AuthService.register(
        username: usernameController.text,
        password: passwordController.text,
        alamat: alamatController.text,
        telepon: teleponController.text,
      );

      setState(() => isLoading = false);

      if (res["status"] == "success") {
        _showMsg("Registrasi berhasil");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        _showMsg("Username sudah digunakan");
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showMsg("Tidak dapat terhubung ke server");
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
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
                      "Daftar Akun Baru",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 28),

                    AuthInput(
                      label: "Username",
                      hint: "Buat Username",
                      icon: Icons.person_outline,
                      controller: usernameController,
                    ),
                    const SizedBox(height: 20),

                    AuthInput(
                      label: "Alamat",
                      hint: "Jln.xxx",
                      icon: Icons.home_outlined,
                      controller: alamatController,
                    ),
                    const SizedBox(height: 20),

                    AuthInput(
                      label: "No. Telepon",
                      hint: "xxxxxxxx",
                      icon: Icons.phone_outlined,
                      controller: teleponController,
                    ),
                    const SizedBox(height: 20),

                    AuthInput(
                      label: "Password",
                      hint: "Minimal 6 karakter",
                      icon: Icons.lock_outline,
                      obscure: true,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 20),

                    AuthInput(
                      label: "Konfirmasi Password",
                      hint: "Ulangi password Anda",
                      icon: Icons.lock_outline,
                      obscure: true,
                      controller: confirmController,
                    ),
                    const SizedBox(height: 28),

                    AuthButton(
                      text: "Daftar Sekarang",
                      onPressed: handleRegister,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun? ",
                          style: AppTextStyles.subtitle,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Masuk",
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
