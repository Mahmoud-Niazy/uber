import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:uber_final/core/app_localization.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';

import '../../uber_cubit/uber_states.dart';

class LayoutForClient extends StatelessWidget {
  const LayoutForClient({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        var locale = AppLocalizations.of(context)!;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                locale.translate(
                    cubit.titlesForClient[cubit.currentIndexInClientsLayout]),
              ),
              actions: [
                UberCubit.get(context).client != null ?
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: cubit.client!.image,
                      ),
                    ),
                  ),
                )
                    :
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                    ),

              ],
            ),
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: cubit.currentIndexInClientsLayout,
              onTap: (i) => cubit.bottomNavigationInClientsLayout(i),
              items: [
                SalomonBottomBarItem(
                  icon: const Icon(Icons.home),
                  title: Text(
                    locale.translate("Orders"),
                  ),
                  // selectedColor: Colors.purple,
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.chat_outlined),
                  title: Text(locale.translate("Make order")),
                  // selectedColor: Colors.pink,
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.person),
                  title: Text(
                    locale.translate("Profile"),
                  ),
                  // selectedColor: Colors.teal,
                ),
              ],
            ),
            body:
                cubit.screensInClientsLayout[cubit.currentIndexInClientsLayout],
          ),
        );
      },
    );
  }
}
