import 'package:flutter/material.dart';
import '../farmer/widgets/farmer_layout.dart';
import 'package:flutter/services.dart';

class FarmerRegistrationScreen extends StatefulWidget {
  static const String routeName = '/farmer-registration';

  const FarmerRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<FarmerRegistrationScreen> createState() =>
      _FarmerRegistrationScreenState();
}

class _FarmerRegistrationScreenState extends State<FarmerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedState;
  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];
  final _kisanIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isOtpValid = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _kisanIdController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isOtpSent = true;
        _isOtpValid = false;
      });
      // TODO: Implement OTP sending logic
    }
  }

  void _verifyOtp() {
    if (_otpController.text.length == 6) {
      setState(() => _isOtpValid = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit OTP')),
      );
    }
  }

  void _handleSignUp() {
    // navigate to farmer layout on successful sign-up
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FarmerLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                value: _selectedState,
                items: _states
                    .map((st) => DropdownMenuItem(value: st, child: Text(st)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedState = val),
                validator: (val) => val == null ? 'Select a state' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter your address' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kisanIdController,
                decoration: const InputDecoration(
                  labelText: 'Kisan ID',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter your Kisan ID' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixText: '+91 ',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 10) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (!_isOtpSent)
                ElevatedButton(
                  onPressed: _sendOtp,
                  child: const Text('Generate OTP'),
                ),
              if (_isOtpSent) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6)
                  ],
                  validator: (value) => value == null || value.length != 6
                      ? 'Enter 6-digit OTP'
                      : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _verifyOtp,
                  child: const Text('Verify OTP'),
                ),
                if (_isOtpValid) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _handleSignUp,
                    child: const Text('Sign Up'),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
