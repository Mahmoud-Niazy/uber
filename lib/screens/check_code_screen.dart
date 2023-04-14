import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uber_final/components/components.dart';
import 'package:uber_final/register_cubit/register_cubit.dart';
import '../register_cubit/register_states.dart';
import '../variables.dart';
import 'login_screen.dart';

class CheckCodeScreen extends StatelessWidget {
  var codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        print(state);
        if (state is PhoneAuthSuccessfullyState) {
          RegisterCubit.get(context).createUser(
            email: email.toString().trim(),
            password: password,
            name: name,
            phone: phone,
          );
          Fluttertoast.showToast(
            msg: 'Register Successfully',
            backgroundColor: Colors.green,
          ).then((value) {
            navigateAndFinish(screen: LoginScreen(), context: context);
          });
        }
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter code',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  PinCodeTextField(
                    keyboardType: TextInputType.phone,
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: codeController,
                    onCompleted: (v) {
                      cubit.CheckCode(smsCode: codeController.text);
                    },
                    onChanged: (value) {
                      print(value);
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
