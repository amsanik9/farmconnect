import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../farmer/widgets/farmer_layout.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';

class FarmerLoginScreen extends StatefulWidget {
  static const String routeName = '/farmer-login';

  const FarmerLoginScreen({Key? key}) : super(key: key);

  @override
  State<FarmerLoginScreen> createState() => _FarmerLoginScreenState();
}

class _FarmerLoginScreenState extends State<FarmerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isOtpValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_phoneController.text.length == 10) {
      setState(() {
        _isOtpSent = true;
        _isOtpValid = false;
      });
    } else {
      final appLocalizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(appLocalizations.enterValidPhoneNumber)),
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text.length == 6) {
      setState(() => _isOtpValid = true);
    } else {
      final appLocalizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.enterValidOTP)),
      );
    }
  }

  void _login() {
    if (_otpController.text.length == 6) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FarmerLayout()),
      );
    } else {
      final appLocalizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.enterValidOTP)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(title: appLocalizations.login),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                labelText: appLocalizations.phoneNumber,
                border: const OutlineInputBorder(),
                prefixText: '+91 ',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(appLocalizations.generateOTP),
            ),
            if (_isOtpSent) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: InputDecoration(
                  labelText: appLocalizations.verifyOTP,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(appLocalizations.verify),
              ),
              if (_isOtpValid) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(appLocalizations.login),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
