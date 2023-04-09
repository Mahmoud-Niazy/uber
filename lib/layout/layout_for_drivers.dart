import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';

import '../uber_cubit/uber_states.dart';

class LayoutForDrivers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit,UberStates>(
      listener: (context,state){
        print(state);
      },
      builder: (context,state){
        var cubit = UberCubit.get(context);
        return  Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex:cubit.currentIndexInDriversLayout,
            onTap: (i) => cubit.BottomNavigationInDriversLayout(i),
            items: [
              SalomonBottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Orders"),
                // selectedColor: Colors.purple,
              ),

              SalomonBottomBarItem(
                icon: Icon(Icons.settings_outlined),
                title: Text("Settings"),
                // selectedColor: Colors.teal,
              ),
            ],
          ),
          body: cubit.screensInDriversLayout[cubit.currentIndexInDriversLayout],
        );
      },
    );
  }
}