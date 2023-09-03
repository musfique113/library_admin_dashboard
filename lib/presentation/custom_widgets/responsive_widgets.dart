import 'package:flutter/material.dart';

// class ResponsiveWidget extends StatelessWidget {
//   final Widget largeScreen;
//   final Widget? mediumScreen;
//   final Widget? smallScreen;
//
//   const ResponsiveWidget({
//     Key? key,
//     required this.largeScreen,
//     this.mediumScreen,
//     this.smallScreen,
//   }) : super(key: key);
//
//   static bool isSmallScreen(BuildContext context) {
//     return MediaQuery.of(context).size.width < 600;
//   }
//
//   static bool isLargeScreen(BuildContext context) {
//     return MediaQuery.of(context).size.width > 1200;
//   }
//
//   static bool isMediumScreen(BuildContext context) {
//     return MediaQuery.of(context).size.width >= 600 &&
//         MediaQuery.of(context).size.width <= 1200;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth > 1200) {
//           return largeScreen;
//         } else if (constraints.maxWidth <= 1200 &&
//             constraints.maxWidth >= 600) {
//           return mediumScreen ?? largeScreen;
//         } else {
//           return smallScreen ?? largeScreen;
//         }
//       },
//     );
//   }
// }

class ResponsiveLayout extends StatelessWidget {
  final Widget tiny;
  final Widget phone;
  final Widget tablet;
  final Widget largeTablet;
  final Widget computer;

  const ResponsiveLayout({
    required this.tiny,
    required this.phone,
    required this.tablet,
    required this.largeTablet,
    required this.computer,
  });

  static final int tinyHeightLimit = 100;
  static final int tinyLimit = 270;
  static final int phoneLimit = 550;
  static final int tabletLimit = 800;
  static final int largeTabletLimit = 1100;

  static bool isTinyHeightLimit(BuildContext context) =>
      MediaQuery.of(context).size.height < tinyHeightLimit;

  static bool isTinyLimit(BuildContext context) =>
      MediaQuery.of(context).size.width < tinyLimit;

  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < phoneLimit &&
      MediaQuery.of(context).size.width >= tinyLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletLimit &&
      MediaQuery.of(context).size.width >= phoneLimit;

  static bool isLargeTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < largeTabletLimit &&
      MediaQuery.of(context).size.width >= tabletLimit;

  static bool isComputer(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeTabletLimit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < tinyLimit ||
            constraints.maxHeight < tinyHeightLimit) {
          return tiny;
        }
        if (constraints.maxWidth < phoneLimit) {
          return phone;
        }
        if (constraints.maxWidth < tabletLimit) {
          return tablet;
        }
        if (constraints.maxWidth < largeTabletLimit) {
          return largeTablet;
        } else {
          return computer;
        }
      },
    );
  }
}
