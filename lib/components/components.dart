import 'package:flutter/material.dart';

class BuildTextFormField extends StatelessWidget {
  String label;

  IconData pIcon;
  IconData? sIcon;
  bool? isPassword;
  TextInputType? type;
  void Function()? onPressedOnPIcon;
  void Function()? onPressedOnSIcon;
  String? Function(String?)? validation;
  TextEditingController controller;
  Color? pIconColor ;

  BuildTextFormField({
    required this.label,
    required this.pIcon,
    this.sIcon,
    this.isPassword = false,
    this.onPressedOnSIcon,
    this.onPressedOnPIcon,
    this.validation,
    this.type,
    required this.controller,
    this.pIconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text(
          label,
        ),
        prefixIcon: IconButton(
          icon: Icon(
            pIcon,
            color:pIconColor ,
          ),
          onPressed: onPressedOnPIcon,
        ),
        suffixIcon: IconButton(
          icon: Icon(sIcon),
          onPressed: onPressedOnSIcon,
        ),
      ),
      validator: validation,
      obscureText: isPassword!,
      keyboardType: type,
      controller: controller,
    );
  }
}

class BuildButton extends StatelessWidget {
  void Function()? onPressed;
  double height;

  double width;
  String label;
  Color color;

  BuildButton({
    required this.onPressed,
    this.height = 55,
    this.width = double.infinity,
    required this.label,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class BuildTextButton extends StatelessWidget {
  String label;

  void Function()? onPressed;

  BuildTextButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        label,
      ),
      onPressed: onPressed,
    );
  }
}

navigate({
  required Widget screen,
  required BuildContext context,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

navigateAndFinish({
  required Widget screen,
  required BuildContext context,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context)=> screen),
    (route) => false,
  );
}

navigatePop({
  required BuildContext context,
}){
  Navigator.pop(context);
}
