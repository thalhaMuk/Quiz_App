import 'package:flutter/material.dart';
import 'package:quiz_app/helpers/string_helper.dart';
import '../../helpers/color_helper.dart';
import '../../helpers/constant_helper.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: ColorHelper.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Image.asset(
            ConstantHelper.appIconPath,
            width: 125,
            height: 125,
          ),
          const SizedBox(height: 40),
          const Text(
            StringHelper.appName,
            style: TextStyle(fontSize: 36, color: ColorHelper.secondaryColor),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
