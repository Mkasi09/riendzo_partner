part of '../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.onDone});
  final VoidCallback? onDone;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool register = false, hidden = true, busy = false;
  String? error;
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.onDone != null) {
      email.text = 'driver@riendzo.co.za';
      password.text = 'partner123';
    }
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    setState(() {
      busy = true;
      error = null;
    });
    if (widget.onDone != null) {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      widget.onDone!();
      return;
    }
    try {
      if (register) {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email.text.trim(),
              password: password.text,
            );
        await credential.user?.updateDisplayName(name.text.trim());
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
      }
    } on FirebaseAuthException catch (exception) {
      if (!mounted) return;
      setState(
        () => error = switch (exception.code) {
          'invalid-credential' ||
          'wrong-password' ||
          'user-not-found' => 'Email or password is incorrect.',
          'email-already-in-use' =>
            'An account already uses this email address.',
          'user-disabled' => 'This partner account has been disabled.',
          'invalid-email' => 'Enter a valid email address.',
          'weak-password' => 'Choose a stronger password.',
          _ => exception.message ?? 'Could not sign in. Please try again.',
        },
      );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: navy,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    BrandLogo(),
                    SizedBox(width: 10),
                    Text(
                      'RIENDZO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 45),
                Text(
                  register ? 'Join the road.' : 'Welcome back.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  register
                      ? 'Create your driver partner account.'
                      : 'Sign in to start driving with Riendzo.',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cream,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Form(
                    key: form,
                    child: Column(
                      children: [
                        if (register) ...[
                          TextFormField(
                            controller: name,
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (v) => (v?.trim().length ?? 0) < 2
                                ? 'Enter at least 2 characters'
                                : null,
                          ),
                          const SizedBox(height: 12),
                        ],
                        TextFormField(
                          controller: email,
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                          validator: (v) =>
                              !RegExp(r'^\S+@\S+\.\S+$').hasMatch(v ?? '')
                              ? 'Enter a valid email address'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: password,
                          obscureText: hidden,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => hidden = !hidden),
                              icon: Icon(
                                hidden
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (v) => (v?.length ?? 0) < 6
                              ? 'Use at least 6 characters'
                              : null,
                        ),
                        const SizedBox(height: 18),
                        if (error != null) ...[
                          Text(
                            error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        PrimaryButton(
                          label: register
                              ? 'Create partner account'
                              : 'Sign in',
                          loading: busy,
                          onPressed: busy ? null : submit,
                        ),
                        TextButton(
                          onPressed: () => setState(() => register = !register),
                          child: Text(
                            register
                                ? 'Already a partner? Sign in'
                                : 'New driver? Create an account',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
