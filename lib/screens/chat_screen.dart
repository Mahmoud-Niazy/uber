import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/app_localization.dart';
import 'package:uber_final/cashe_helper/cashe_helper.dart';
import 'package:uber_final/components/components.dart';
import '../data_models/order_data_model.dart';
import '../uber_cubit/uber_cubit.dart';
import '../uber_cubit/uber_states.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController messegeController = TextEditingController();
   OrderDataModel? order;
  final formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  ChatScreen(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      UberCubit.get(context).getAllMesseges(
        clientId: order!.clientId,
        driverId: order!.driverId,
        // driverSend: CasheHelper.GetData(key: 'uId'),
        // recieverId: CasheHelper.GetData(key: 'isDriver') ? order!.clientId : order!.driverId ,
      );

      return BlocConsumer<UberCubit, UberStates>(
        listener: (context, state) {
          if (state is SendMessegeSuccessfullyState) {
            messegeController.text = '';
          }
        },
        builder: (context, state) {
          var cubit = UberCubit.get(context);
          return order != null
              ? Scaffold(
                  appBar: AppBar(
                    title: Row(
                      children: [
                        Text((CasheHelper.getData(key: 'isDriver')
                            ? order!.clientName!
                            : order!.driverName)!),
                        const SizedBox(
                          width: 15,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              (CasheHelper.getData(key: 'isDriver')
                                  ? order!.clientImage!
                                  : order!.driverImage)!),
                          radius: 20,
                        ),
                      ],
                    ),
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () {
                        order = null;
                        navigatePop(context: context);
                      },
                    ),
                  ),
                  body: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          cubit.allMesseges.isNotEmpty
                              ? Expanded(
                                  child: ListView.separated(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      if (cubit.allMesseges[index].senderId ==
                                          CasheHelper.getData(key: 'uId')) {
                                        return buildMyMessege(
                                          text: cubit.allMesseges[index].text!,
                                        );
                                      } else {
                                        return buildMessege(
                                          text: cubit.allMesseges[index].text!,
                                        );
                                      }
                                      // CasheHelper.GetData(key: "isDriver")? element.recieverId == order!.clientId : element.recieverId == order!.driverId
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 0,
                                    ),
                                    itemCount: cubit.allMesseges.length,
                                  ),
                                )
                              : const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      controller: messegeController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Messege is empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          AppLocalizations.of(context)!
                                              .translate('Write your messege'),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      UberCubit.get(context).sendMessege(
                                        // title: 'New Messege for you',
                                        // body: messegeController.text,
                                        // FcmTo:
                                        //     (CasheHelper.GetData(key: 'isDriver')
                                        //         ? order!.fcmToken
                                        //         : order!.driverFcmToken)!,
                                        text: messegeController.text,
                                        senderId: CasheHelper.getData(key: 'uId'),
                                        recieverId:
                                            (CasheHelper.getData(key: 'isDriver')
                                                ? order!.clientId
                                                : order!.driverId)!,
                                      );
                                      cubit.sendNotification(
                                        to: (CasheHelper.getData(key: 'isDriver')
                                            ? order!.fcmToken
                                            : order!.driverFcmToken)!,
                                        title: 'New Messege for you',
                                        body: messegeController.text,
                                      );
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        curve: Curves.easeOut,
                                        duration:
                                            const Duration(milliseconds: 300),
                                      );
                                    }
                                  },
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              : const Center(child: CircularProgressIndicator());
        },
      );
    });
  }

  buildMyMessege({
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(text),
        ),
      ),
    );
  }

  buildMessege({
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(text),
        ),
      ),
    );
  }
}
