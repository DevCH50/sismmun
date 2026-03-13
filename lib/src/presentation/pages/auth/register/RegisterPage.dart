import 'package:sismmun/src/presentation/widgets/DefaultIconBack.dart';
import 'package:sismmun/src/presentation/widgets/DefaultTextField.dart';
import 'package:sismmun/src/presentation/widgets/PrimaryElevatedButton.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent, // Make the background transparent
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/img/background_shopping.jpg', // Replace with your image path
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken, // Darken the image
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white54.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_add, size: 125, color: Colors.white),
                    const Text(
                      'REGISTRO',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    DefaultTextField(
                      label: 'Nombre',
                      icon: Icons.person,
                      onChanged: (text) {
                        print('Nombre: $text');
                      },
                    ),
                    DefaultTextField(
                      label: 'Apellido Paterno',
                      icon: Icons.person,
                      onChanged: (text) {
                        print('Apellido Paterno: $text');
                      },
                    ),
                    DefaultTextField(
                      label: 'Apellido Materno',
                      icon: Icons.person,
                      onChanged: (text) {
                        print('Apellido Materno: $text');
                      },
                    ),
                    DefaultTextField(
                      label: 'Celular',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      onChanged: (text) {
                        print('Celular: $text');
                      },
                    ),
                    DefaultTextField(
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (text) {
                        print('Email: $text');
                      },
                    ),
                    DefaultTextField(
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true,
                      onChanged: (text) {
                        print('Password: $text');
                      },
                    ),
                    DefaultTextField(
                      label: 'Confirmar Contraseña',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      onChanged: (text) {
                        print('Confirm Password: $text');
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(
                        context,
                      ).size.width, // Make button full width
                      child: PrimaryElevatedButton(
                        text: 'Guardar',
                        onPressed: () {
                          // Handle registration action
                          print('Register button pressed');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const DefaultIconBack(left: 45, top: 135),
          ],
        ),
      ),
    );
  }
}
