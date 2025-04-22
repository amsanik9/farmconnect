import 'package:flutter/material.dart';
import '../farmer/widgets/farmer_layout.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';

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
    final appLocalizations = AppLocalizations.of(context);
    if (_otpController.text.length == 6) {
      setState(() => _isOtpValid = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.enterValidOTP)),
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
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.signup),
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
                decoration: InputDecoration(
                  labelText: appLocalizations.name,
                  border: const OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? appLocalizations.enterName : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: appLocalizations.selectState,
                  border: const OutlineInputBorder(),
                ),
                value: _selectedState,
                items: _states
                    .map((st) => DropdownMenuItem(value: st, child: Text(st)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedState = val),
                validator: (val) => val == null ? appLocalizations.selectState : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: appLocalizations.deliveryAddress,
                  border: const OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? appLocalizations.enterValidAddress : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kisanIdController,
                decoration: InputDecoration(
                  labelText: appLocalizations.kisanId,
                  border: const OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? appLocalizations.enterKisanId : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: appLocalizations.phoneNumber,
                  border: const OutlineInputBorder(),
                  prefixText: '+91 ',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.enterPhoneNumber;
                  }
                  if (value.length != 10) {
                    return appLocalizations.enterValidPhoneNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (!_isOtpSent)
                ElevatedButton(
                  onPressed: _sendOtp,
                  child: Text(appLocalizations.generateOTP),
                ),
              if (_isOtpSent) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.verifyOTP,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6)
                  ],
                  validator: (value) => value == null || value.length != 6
                      ? appLocalizations.enterValidOTP
                      : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _verifyOtp,
                  child: Text(appLocalizations.verify),
                ),
                if (_isOtpValid) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _handleSignUp,
                    child: Text(appLocalizations.signup),
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
