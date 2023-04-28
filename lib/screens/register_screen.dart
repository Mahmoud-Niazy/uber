import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/app_localization.dart';
import 'package:uber_final/register_cubit/register_cubit.dart';
import 'package:uber_final/screens/check_code_screen.dart';
import '../components/components.dart';
import '../register_cubit/register_states.dart';
import '../variables.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is PhoneCorrectState) {
          name = nameController.text;
          email = emailController.text;
          phone = phoneController.text;
          password = passwordController.text;
          navigateAndFinish(screen: CheckCodeScreen(), context: context);
        }
        print(state);
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        var locale = AppLocalizations.of(context)!;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                locale.Translate('Register'),
              ),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/Carpool-rafiki.png',
                          height: MediaQuery.of(context).size.height * .35,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .04,
                      ),
                      BuildTextFormField(
                        label: locale.Translate('Name'),
                        controller: nameController,
                        pIcon: Icons.person,
                        validation: (value) {
                          if (value!.isEmpty) {
                            return locale.Translate('Name can\'t be empty');
                          }
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      BuildTextFormField(
                        label: locale.Translate('Email'),
                        controller: emailController,
                        pIcon: Icons.email_outlined,
                        validation: (value) {
                          if (value!.isEmpty) {
                            return locale.Translate('Email can\'t be empty');
                          }
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      BuildTextFormField(
                        label: locale.Translate('Password'),
                        controller: passwordController,
                        pIcon: Icons.lock_outline,
                        validation: (value) {
                          if (value!.isEmpty) {
                            return locale.Translate('Password can\'t be empty');
                          }
                        },
                        isPassword: cubit.isPassword,
                        sIcon: cubit.isPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onPressedOnSIcon: () {
                          cubit.changePasswordVisibility();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      BuildTextFormField(
                        label: locale.Translate('Phone'),
                        controller: phoneController,
                        pIcon: Icons.phone,
                        validation: (value) {
                          if (value!.isEmpty) {
                            return locale.Translate('Phone can\'t be empty');
                          }
                        },
                        type: TextInputType.phone,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.photo,
                            color: Colors.blue,
                          ),
                          BuildTextButton(
                            label: locale.Translate('Pick your photo'),
                            onPressed: () {
                              cubit.getProfileImage();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      if (cubit.profileImage != null)
                        Container(
                          height: 100,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(cubit.profileImage!),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if(!cubit.isDriver)
                                  cubit.changeTypeOfUser();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                child: Text(
                                  locale.Translate('Driver'),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: cubit.isDriver
                                        ? Colors.blue
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                if(cubit.isDriver)
                                  cubit.changeTypeOfUser();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                child: Text(
                                  locale.Translate('Client'),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: cubit.isDriver
                                        ? Colors.grey
                                        : Colors.blue,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .04,
                      ),
                      state is PhoneAuthLoadingState
                          ? Center(child: CircularProgressIndicator())
                          : BuildButton(
                              onPressed: () {
                                if (formKey.currentState!.validate() &&
                                    cubit.profileImage != null) {
                                  cubit.PhoneAuth(
                                    phoneNumber: phoneController.text,
                                  );
                                }
                              },
                              label: locale.Translate('Register now'),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
