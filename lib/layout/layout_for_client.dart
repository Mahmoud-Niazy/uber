import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:uber_final/app_localization.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import '../uber_cubit/uber_states.dart';

class LayoutForClient extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit,UberStates>(
      listener: (context,state){
        print(state);
      },
      builder: (context,state){
        var cubit = UberCubit.get(context);
        var locale = AppLocalizations.of(context)!;
        return SafeArea(
          child: Scaffold(
            // appBar: AppBar(
            //   title: Text(
            //     cubit.titles[cubit.currentIndexInClientsLayout],
            //   ),
            // ),
            bottomNavigationBar: SalomonBottomBar(
              currentIndex:cubit.currentIndexInClientsLayout,
              onTap: (i) => cubit.BottomNavigationInClientsLayout(i),

              items: [
                SalomonBottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text(
                    locale.Translate("Orders"),
                  ),
                  // selectedColor: Colors.purple,
                ),

                SalomonBottomBarItem(
                  icon: Icon(Icons.chat_outlined),
                  title: Text(
                    locale.Translate("Make order")
                  ),
                  // selectedColor: Colors.pink,
                ),


                SalomonBottomBarItem(
                  icon: Icon(Icons.person),
                  title: Text(
                    locale.Translate("Profile"),
                  ),
                  // selectedColor: Colors.teal,
                ),
              ],
            ),

            body: cubit.screensInClientsLayout[cubit.currentIndexInClientsLayout],
          ),
        );
      },
    );
  }
}