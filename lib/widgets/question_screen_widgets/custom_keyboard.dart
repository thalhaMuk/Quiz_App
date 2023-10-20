import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(int) onNumberPressed;
  final Function() onSubmitPressed;
  final int? selectedNumber;

  const CustomKeyboard({
    required this.onNumberPressed,
    required this.onSubmitPressed,
    required this.selectedNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: <Widget>[
          ...List.generate(9, (index) {
            int number = index + 1;
            return GestureDetector(
              onTap: () => onNumberPressed(number),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color:
                      selectedNumber == number ? Colors.green : Colors.blue,
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
          }),
          GestureDetector(
            onTap: () => onNumberPressed(0),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: selectedNumber == 0 ? Colors.green : Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '0',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onSubmitPressed,
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
          ),
        ],
      ),
    );
  }
}
