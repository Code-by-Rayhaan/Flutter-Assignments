import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

/// Screen 2: Registration Form Screen
/// Handles user registration with extensive validation for email, password rules,
/// password confirmation, and required fields. Navigates to `/detail` upon successful submission.
class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  static const String routeName = '/form';

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State flags
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  bool _subscribeNewsletter = true;
  bool _termsError = false;
  bool _isSubmitting = false;

  String? _selectedAccountType;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final List<String> _accountTypes = const [
    'Student',
    'Software Developer',
    'UI/UX Designer',
    'Product Manager',
    'Data Scientist',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    setState(() {
      // Re-render password strength meter when password text changes
    });
  }

  // Password strength evaluation
  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;
    double score = 0.0;
    if (password.length >= 8) score += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) score += 0.25;
    if (password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'))) {
      score += 0.25;
    }
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score += 0.25;
    return score;
  }

  String _getPasswordStrengthLabel(double strength) {
    if (strength <= 0.25) return 'Weak';
    if (strength <= 0.75) return 'Medium';
    return 'Strong';
  }

  Color _getPasswordStrengthColor(double strength) {
    if (strength <= 0.25) return AppTheme.errorColor;
    if (strength <= 0.75) return AppTheme.warningColor;
    return AppTheme.successColor;
  }

  // --- VALIDATION FUNCTIONS ---

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full Name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters long';
    }
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(value.trim())) {
      return 'Name contains invalid characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    // Standard email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address (e.g. user@domain.com)';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digitsOnly = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!RegExp(r'^\d{10}$').hasMatch(digitsOnly)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Must contain at least 1 uppercase letter (A-Z)';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Must contain at least 1 lowercase letter (a-z)';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Must contain at least 1 number (0-9)';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Must contain at least 1 special character (!@#\$%^&*...)';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateAccountType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an account type';
    }
    return null;
  }

  // --- SUBMISSION HANDLER ---

  void _handleSubmit() async {
    // Switch to live validation on first submit attempt
    setState(() {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
      _termsError = !_agreedToTerms;
    });

    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid || !_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  !_agreedToTerms
                      ? 'Please accept the Terms & Conditions to proceed.'
                      : 'Please correct the highlighted errors before submitting.',
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // Processing submission
    setState(() {
      _isSubmitting = true;
    });

    // Simulated short async delay for realistic feel
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final user = UserModel(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      accountType: _selectedAccountType!,
      subscribedToNewsletter: _subscribeNewsletter,
      registeredAt: DateTime.now(),
    );

    setState(() {
      _isSubmitting = false;
    });

    // Navigate to Detail Screen using Named Route and passing UserModel as argument
    Navigator.pushNamed(
      context,
      '/detail',
      arguments: user,
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _selectedAccountType = null;
      _agreedToTerms = false;
      _termsError = false;
      _autoValidateMode = AutovalidateMode.disabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final passwordStrength = _calculatePasswordStrength(_passwordController.text);
    final strengthLabel = _getPasswordStrengthLabel(passwordStrength);
    final strengthColor = _getPasswordStrengthColor(passwordStrength);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
        actions: [
          IconButton(
            tooltip: 'Reset Form',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _resetForm,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create Your Profile',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Fill out all required fields to register.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- 1. FULL NAME FIELD ---
                const Text(
                  'Full Name *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('fullNameField'),
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'e.g. John Doe',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: _validateFullName,
                ),

                const SizedBox(height: 18),

                // --- 2. EMAIL ADDRESS FIELD ---
                const Text(
                  'Email Address *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('emailField'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'e.g. john.doe@example.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: _validateEmail,
                ),

                const SizedBox(height: 18),

                // --- 3. PHONE NUMBER FIELD ---
                const Text(
                  'Phone Number *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('phoneField'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 9876543210 (10 digits)',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: _validatePhone,
                ),

                const SizedBox(height: 18),

                // --- 4. ACCOUNT TYPE DROPDOWN ---
                const Text(
                  'Account Role / Type *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  key: const Key('accountTypeField'),
                  initialValue: _selectedAccountType,
                  decoration: const InputDecoration(
                    hintText: 'Select your role',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  items: _accountTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedAccountType = val;
                    });
                  },
                  validator: _validateAccountType,
                ),

                const SizedBox(height: 18),

                // --- 5. PASSWORD FIELD ---
                const Text(
                  'Password *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('passwordField'),
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Enter a strong password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                ),

                // Live Password Strength Indicator
                if (_passwordController.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: passwordStrength,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              strengthColor,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Strength: $strengthLabel',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: strengthColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildPasswordRuleChip(
                        '8+ chars',
                        _passwordController.text.length >= 8,
                      ),
                      _buildPasswordRuleChip(
                        'Uppercase (A-Z)',
                        _passwordController.text.contains(RegExp(r'[A-Z]')),
                      ),
                      _buildPasswordRuleChip(
                        'Lowercase (a-z)',
                        _passwordController.text.contains(RegExp(r'[a-z]')),
                      ),
                      _buildPasswordRuleChip(
                        'Number (0-9)',
                        _passwordController.text.contains(RegExp(r'[0-9]')),
                      ),
                      _buildPasswordRuleChip(
                        'Special char',
                        _passwordController.text.contains(
                          RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 18),

                // --- 6. CONFIRM PASSWORD FIELD ---
                const Text(
                  'Confirm Password *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('confirmPasswordField'),
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.lock_clock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: _validateConfirmPassword,
                ),

                const SizedBox(height: 18),

                // --- 7. NEWSLETTER OPT-IN ---
                Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      'Receive Newsletter & Product Updates',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    subtitle: const Text(
                      'Get notified about new feature announcements.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    value: _subscribeNewsletter,
                    activeTrackColor: AppTheme.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        _subscribeNewsletter = val;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // --- 8. TERMS & CONDITIONS CHECKBOX ---
                Material(
                  color: _termsError
                      ? AppTheme.errorColor.withValues(alpha: 0.05)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _termsError
                          ? AppTheme.errorColor
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: CheckboxListTile(
                    key: const Key('termsCheckbox'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    title: const Text(
                      'I agree to the Terms of Service and Privacy Policy *',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    value: _agreedToTerms,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        _agreedToTerms = val ?? false;
                        if (_agreedToTerms) _termsError = false;
                      });
                    },
                  ),
                ),
                if (_termsError) ...[
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      'You must accept the Terms of Service to register',
                      style: TextStyle(
                        color: AppTheme.errorColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                // --- ACTION BUTTONS ---
                ElevatedButton(
                  key: const Key('submitButton'),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 20),
                            SizedBox(width: 8),
                            Text('Register & View Profile'),
                          ],
                        ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _resetForm,
                  child: const Text('Clear All Fields'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRuleChip(String label, bool satisfied) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: satisfied
            ? AppTheme.successColor.withValues(alpha: 0.12)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: satisfied
              ? AppTheme.successColor.withValues(alpha: 0.3)
              : const Color(0xFFCBD5E1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            satisfied ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 13,
            color: satisfied ? AppTheme.successColor : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: satisfied
                  ? AppTheme.successColor
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
