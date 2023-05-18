import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/app_localization.dart';
import 'package:uber_final/cashe_helper/cashe_helper.dart';
import '../data_models/order_data_model.dart';
import '../uber_cubit/uber_cubit.dart';
import '../uber_cubit/uber_states.dart';

class ChatScreen extends StatelessWidget {
  TextEditingController messegeController = TextEditingController();
  OrderDataModel? order;
  var formKey = GlobalKey<FormState>();

  ChatScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      UberCubit.get(context).GetAllMesseges(
        clientId: order!.clientId,
        driverId: order!.driverId,
      );
      return BlocConsumer<UberCubit, UberStates>(
        listener: (context, state) {
          if (state is SendMessegeSuccessfullyState) {
            messegeController.text = '';
          }
        },
        builder: (context, state) {
          var cubit = UberCubit.get(context);
          return cubit.allMesseges.length >= 0
              ? Scaffold(
                  appBar: AppBar(
                    title: Row(
                      children: [
                        Text((CasheHelper.GetData(key: 'isDriver')
                            ? order!.clientName!
                            : order!.driverName)!),
                        SizedBox(
                          width: 15,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              (CasheHelper.GetData(key: 'isDriver')
                                  ? order!.clientImage!
                                  : order!.driverImage)!),
                          radius: 20,
                        ),
                      ],
                    ),
                  ),
                  body: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (cubit.allMesseges[index].senderId ==
                                  CasheHelper.GetData(key: 'uId')) {
                                return BuildMyMessege(
                                  text: cubit.allMesseges[index].text!,
                                );
                              } else {
                                return BuildMessege(
                                  text: cubit.allMesseges[index].text!,
                                );
                              }
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 0,
                            ),
                            itemCount: cubit.allMesseges.length,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: TextFormField(
                                    controller: messegeController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Messege is empty';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      label: Text(
                                        AppLocalizations.of(context)!
                                            .Translate('Write your messege'),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    UberCubit.get(context).SendMessege(
                                      // title: 'New Messege for you',
                                      // body: messegeController.text,
                                      // FcmTo:
                                      //     (CasheHelper.GetData(key: 'isDriver')
                                      //         ? order!.fcmToken
                                      //         : order!.driverFcmToken)!,
                                      text: messegeController.text,
                                      senderId: CasheHelper.GetData(key: 'uId'),
                                      recieverId:
                                          (CasheHelper.GetData(key: 'isDriver')
                                              ? order!.clientId
                                              : order!.driverId)!,
                                    );
                                    cubit.SendNotification(
                                      to: (CasheHelper.GetData(key: 'isDriver')
                                          ? order!.fcmToken
                                          : order!.driverFcmToken)!,
                                      title: 'New Messege for you',
                                      body: messegeController.text,
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
              : Center(child: CircularProgressIndicator());
        },
      );
    });
  }

  BuildMyMessege({
    required String text,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(text),
        ),
      ),
    );
  }

  BuildMessege({
    required String text,
  }) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(text),
        ),
      ),
    );
  }
}
