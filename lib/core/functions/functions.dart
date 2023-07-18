import 'package:flutter/material.dart';

import '../components/components.dart';

navigate({
  required Widget screen,
  required BuildContext context,
}) {
  Navigator.of(context).push(PageTransition(screen));
}

navigateAndFinish({
  required Widget screen,
  required BuildContext context,
}) {
  Navigator.of(context).pushAndRemoveUntil(
    PageTransition(screen),
    // MaterialPageRoute(builder: (context) => screen),
        (route) => false,
  );
}

navigatePop({
  required BuildContext context,
}) {
  Navigator.pop(context);
}
