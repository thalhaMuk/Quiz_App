import 'package:flutter/material.dart';

class CustomKeyboard extends StatefulWidget {
  final Function(int) onNumberPressed;
  final Function() onSubmitPressed;
  final int? selectedNumber;

  const CustomKeyboard({
    Key? key,
    required this.onNumberPressed,
    required this.onSubmitPressed,
    required this.selectedNumber,
  }) : super(key: key);

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  bool showError = false;

  void _handleSubmission() {
    if (_isValidNumber(widget.selectedNumber)) {
      widget.onSubmitPressed();
      widget.onNumberPressed(-1);
      _hideError();
    } else {
      _showError();
    }
  }

  bool _isValidNumber(int? number) {
    return number != null && number >= 0;
  }

  void _showError() {
    setState(() {
      showError = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      _hideError();
    });
  }

  void _hideError() {
    setState(() {
      showError = false;
    });
  }

  GestureDetector _buildNumberButton(int number) {
    return GestureDetector(
      onTap: () => widget.onNumberPressed(number),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: widget.selectedNumber == number ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '$number',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildSubmitButton() {
    return GestureDetector(
      onTap: _handleSubmission,
      child: Container(
        width: 160,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Submit',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: <Widget>[
              ...List.generate(9, (index) {
                return _buildNumberButton(index + 1);
              }),
              _buildNumberButton(0),
              _buildSubmitButton(),
            ],
          ),
        ),
        if (showError)
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: showError ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Please enter a number!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
