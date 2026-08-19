import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground( 
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox( height: 80 ),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        if ( !context.canPop() ) return;
                        context.pop();
                      }, 
                      icon: const Icon( Icons.arrow_back_rounded, size: 40, color: Colors.white )
                    ),
                    const Spacer(flex: 1),
                    Text('Crear cuenta', style: textStyles.titleLarge?.copyWith(color: Colors.white )),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox( height: 40 ),
    
                Container(
                  height: size.height - 160, // 80 de espacio superior, ~40 del header y 40 de separación
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _RegisterForm(),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class _RegisterForm extends ConsumerStatefulWidget {
  const _RegisterForm();

  @override
  ConsumerState<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<_RegisterForm> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  void _clearFields() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    repeatPasswordController.clear();
    ref.read(registerFormProvider.notifier).resetForm();
  }

  @override
  Widget build(BuildContext context) {

    final registerForm = ref.watch(registerFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        CustomToast.show(context, next.errorMessage!, type: ToastType.error);
        return;
      }

      if (previous?.authStatus != AuthStatus.authenticated &&
          next.authStatus == AuthStatus.authenticated) {
        CustomToast.show(
          context,
          'Usuario creado correctamente',
          type: ToastType.success,
        );
        _clearFields();
      }
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox( height: 30 ),
          Text('Nueva cuenta', style: textStyles.titleMedium ),
          const SizedBox( height: 30 ),

          CustomTextFormField(
            controller: fullNameController,
            label: 'Nombre completo',
            keyboardType: TextInputType.name,
            onChanged: ref.read(registerFormProvider.notifier).onFullNameChanged,
            errorMessage: registerForm.isFormPosted ? registerForm.fullName.errorMessage : null,
          ),
          const SizedBox( height: 18 ),

          CustomTextFormField(
            controller: emailController,
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChanged,
            errorMessage: registerForm.isFormPosted ? registerForm.email.errorMessage : null,
          ),
          const SizedBox( height: 18 ),

          CustomTextFormField(
            controller: passwordController,
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChanged,
            errorMessage: registerForm.isFormPosted ? registerForm.password.errorMessage : null,
          ),
    
          const SizedBox( height: 18 ),

          CustomTextFormField(
            controller: repeatPasswordController,
            label: 'Repita la contraseña',
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onRepeatPasswordChanged,
            errorMessage: registerForm.isFormPosted ? registerForm.repeatPassword.errorMessage : null,
          ),
    
          const SizedBox( height: 25 ),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Crear',
              buttonColor: Colors.black,
              onPressed: registerForm.isPosting
                ? null
                : () {
                    ref.read(registerFormProvider.notifier).onFormSubmit();
                  },
            )
          ),

          const Spacer( flex: 2 ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                onPressed: (){
                  if ( context.canPop()){
                    return context.pop();
                  }
                  context.go('/login');
                  
                }, 
                child: const Text('Ingresa aquí')
              )
            ],
          ),

          const Spacer( flex: 1),
        ],
      ),
    );
  }
}