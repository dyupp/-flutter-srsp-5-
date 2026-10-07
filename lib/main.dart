import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SRSP 5 Register Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const RegistrationPage(),
    );
  }
}

// ----------------------------------------------------
// 1. ЭКРАН РЕГИСТРАЦИИ (RegistrationPage)
// ----------------------------------------------------
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Контроллеры
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // FocusNode
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _storyFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _storyFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', _nameController.text.trim());
      await prefs.setString('phoneNumber', _phoneController.text.trim());
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('lifeStory', _storyController.text.trim());

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserInfoPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Form'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            children: [
              // Full Name
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocus,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _nameController.clear(),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Full Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Phone Number *',
                  helperText: 'Phone format: (XXX)XXX-XXXX',
                  prefixIcon: const Icon(Icons.phone),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _phoneController.clear(),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'Please enter numbers only';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Address
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.mail),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Invalid email address format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Life Story
              TextFormField(
                controller: _storyController,
                focusNode: _storyFocus,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Life Story',
                  helperText: 'Keep it short, this is just a demo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: 'Password *',
                  prefixIcon: const Icon(Icons.security),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocus,
                obscureText: _obscurePassword,
                maxLength: 8,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password *',
                  prefixIcon: Icon(Icons.border_color),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Submit Form',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 2. ЭКРАН ПОЛЬЗОВАТЕЛЯ (UserInfoPage)
// ----------------------------------------------------
class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String fullName = '';
  String phoneNumber = '';
  String email = '';
  String lifeStory = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'Не указано';
      phoneNumber = prefs.getString('phoneNumber') ?? 'Не указано';
      email = prefs.getString('email') ?? 'Не указано';
      lifeStory = prefs.getString('lifeStory') ?? 'Не указано';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text('Full Name'),
                  subtitle: Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: const Text('Phone Number'),
                  subtitle: Text(phoneNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.orange),
                  title: const Text('Email Address'),
                  subtitle: Text(email, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.history_edu, color: Colors.purple),
                  title: const Text('Life Story'),
                  subtitle: Text(
                    lifeStory.isEmpty ? 'Не указано' : lifeStory,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}