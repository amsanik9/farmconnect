import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/main_layout.dart';
import '../farmer/widgets/farmer_layout.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;
  String? _selectedState;
  final _kisanIdController = TextEditingController();
  final _aadharIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _consumerPhoneController = TextEditingController();
  final List<TextEditingController> _farmerOtpControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> _consumerOtpControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _farmerOtpFocusNodes = List.generate(
    5,
    (index) => FocusNode(),
  );
  final List<FocusNode> _consumerOtpFocusNodes = List.generate(
    5,
    (index) => FocusNode(),
  );
  bool _showFarmerOtpField = false;
  bool _showConsumerOtpField = false;
  bool _showFarmerVerifyButton = false;
  bool _showConsumerVerifyButton = false;

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

  @override
  void dispose() {
    _kisanIdController.dispose();
    _aadharIdController.dispose();
    _phoneController.dispose();
    _consumerPhoneController.dispose();
    for (var controller in _farmerOtpControllers) {
      controller.dispose();
    }
    for (var controller in _consumerOtpControllers) {
      controller.dispose();
    }
    for (var node in _farmerOtpFocusNodes) {
      node.dispose();
    }
    for (var node in _consumerOtpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Widget _buildOtpFields(
      List<TextEditingController> controllers, List<FocusNode> focusNodes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        5,
        (index) => SizedBox(
          width: 50,
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 4) {
                focusNodes[index + 1].requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticationFlow({
    required String role,
    required String idType,
    required TextEditingController idController,
    required List<TextEditingController> otpControllers,
    required List<FocusNode> otpFocusNodes,
    required bool showOtpField,
    required bool showVerifyButton,
    required VoidCallback onGenerateOtp,
    required VoidCallback onVerifyOtp,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            value: _selectedState,
            decoration: const InputDecoration(
              labelText: 'Select State',
              border: OutlineInputBorder(),
            ),
            items: _states.map((String state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedState = newValue;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: idController,
            decoration: InputDecoration(
              labelText: idType,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (role == 'Farmer') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onGenerateOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Generate OTP',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        if (showOtpField) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildOtpFields(otpControllers, otpFocusNodes),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onVerifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Verify OTP',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
        if (showVerifyButton) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (role == 'Consumer') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainLayout(),
                          ),
                        );
                      } else if (role == 'Farmer') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FarmerLayout(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Handle sign up
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Select Your Role',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildRoleCard('Farmer', Icons.agriculture),
                _buildRoleCard('Consumer', Icons.shopping_cart),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(String role, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.green,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              value: role,
              groupValue: _selectedRole,
              onChanged: (String? value) {
                setState(() {
                  _selectedRole = value;
                  if (value != 'Farmer') {
                    _showFarmerOtpField = false;
                    _showFarmerVerifyButton = false;
                  } else {
                    _showConsumerOtpField = false;
                    _showConsumerVerifyButton = false;
                  }
                });
              },
              activeColor: Colors.green,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            if (_selectedRole == role) ...[
              const SizedBox(height: 16),
              if (role == 'Farmer') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/farmer-login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Login',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/farmer-registration');
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Sign Up',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else
                _buildAuthenticationFlow(
                  role: 'Consumer',
                  idType: 'Phone Number',
                  idController: _consumerPhoneController,
                  otpControllers: _consumerOtpControllers,
                  otpFocusNodes: _consumerOtpFocusNodes,
                  showOtpField: _showConsumerOtpField,
                  showVerifyButton: _showConsumerVerifyButton,
                  onGenerateOtp: () {
                    if (_consumerPhoneController.text.isNotEmpty &&
                        _selectedState != null) {
                      setState(() {
                        _showConsumerOtpField = true;
                      });
                    }
                  },
                  onVerifyOtp: () {
                    setState(() {
                      _showConsumerVerifyButton = true;
                    });
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}
