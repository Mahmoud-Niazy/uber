import 'package:flutter/material.dart';
import 'package:uber_final/components/components.dart';
import 'package:uber_final/screens/clients/google_map_screen.dart';

class MakeOrderScreen extends StatelessWidget {
  var fromController = TextEditingController();
  var toController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make Your order',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              BuildTextFormField(
                label: 'From',
                pIcon: Icons.location_on_outlined,
                controller: fromController,
                onPressedOnPIcon: (){
                  navigate(screen: GoogleMapScreen(), context: context);
                },
                pIconColor: Colors.blue,
              ),
              SizedBox(
                height: 15,
              ),
              BuildTextFormField(
                label: 'To',
                pIcon: Icons.location_on_outlined,
                controller: toController,
                onPressedOnPIcon: (){},
                pIconColor: Colors.blue,
              ),
              SizedBox(
                height: 15,
              ),
              BuildTextFormField(
                label: 'Time',
                pIcon: Icons.watch_later_outlined,
                controller: timeController,
                onPressedOnPIcon: (){},
                pIconColor: Colors.blue,
              ),
              SizedBox(
                height: 15,
              ),
              BuildTextFormField(
                label: 'Date',
                pIcon: Icons.date_range_outlined,
                controller: dateController,
                onPressedOnPIcon: (){},
                pIconColor: Colors.blue,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              BuildButton(
                onPressed: (){},
                label: 'Order',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
