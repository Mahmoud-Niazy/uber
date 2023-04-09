import 'package:flutter/material.dart';
import 'package:uber_final/data_models/order_data_model.dart';

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

class BuildClientOrderItem extends StatelessWidget{
  OrderDataModel order ;
  BuildClientOrderItem({
    required this.order,
});
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          )
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.black,
                    width: 2
                )
            ),
            child: CircleAvatar(
              radius: 40,
              child: Text(
                '${order.time}',
              ),
              backgroundColor: Colors.white,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                    ),
                    Text(" From : ${order.from}"),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                    ),
                    Text(" To : ${order.to}"),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.date_range_outlined,
                    ),
                    Text(" Date : ${order.date}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuildDriverOrderItem extends StatelessWidget{
  OrderDataModel order ;
  BuildDriverOrderItem({
    required this.order,
});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                order.clientImage!,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  order.clientName!,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                    ),
                    Text(" From : ${order.from} "),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                    ),
                    Text(" To : ${order.to} "),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.date_range_outlined,
                    ),
                    Text(" Date : ${order.date} "),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                    ),
                    Text(" Time : ${order.time} "),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

