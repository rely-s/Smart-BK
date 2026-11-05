import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identityController = TextEditingController(text: '0071234567');
  final _passwordController = TextEditingController(text: 'Siswa123!');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.riskHigh,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Brand Logo
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SMART BK CARE',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Sistem Perlindungan, Deteksi Dini & Konseling Digital\nSMA / SMK Sumatera Barat',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 32),
                    // Login Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Masuk ke Akun Anda',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'NISN / NUPTK / Email Terdaftar',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _identityController,
                              decoration: const InputDecoration(
                                hintText: 'Masukkan nomor identitas',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Kata Sandi',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Masukkan kata sandi',
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      final identity = _identityController.text.trim();
                                      final password = _passwordController.text.trim();
                                      if (identity.isNotEmpty && password.isNotEmpty) {
                                        context.read<AuthBloc>().add(
                                              LoginSubmittedEvent(
                                                identityOrEmail: identity,
                                                password: password,
                                              ),
                                            );
                                      }
                                    },
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text('Masuk'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Quick Demo Persona Switcher for Evaluation
                    TextButton.icon(
                      icon: const Icon(Icons.fast_forward_rounded, size: 16),
                      label: const Text('Gunakan Akun Uji Coba Cepat (R&D)'),
                      onPressed: () => _showQuickTestAccountSheet(context),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickTestAccountSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pilih Akun Demo Uji Coba', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Siswa: Fajri Pratama (SMAN 1 Padang)'),
                subtitle: const Text('NISN: 0071234567'),
                onTap: () {
                  setState(() {
                    _identityController.text = '0071234567';
                    _passwordController.text = 'Siswa123!';
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('Guru BK: Dra. Rahmi Fadilah, Kons.'),
                subtitle: const Text('NUPTK: 198504122010012015'),
                onTap: () {
                  setState(() {
                    _identityController.text = '198504122010012015';
                    _passwordController.text = 'GuruBK123!';
                  });
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

