import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:led_control/UI/colors.dart';

// Widget cardTemplate(context, mode) {
//   return ExpandableNotifier(
//     child: Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: 7,
//         vertical: 5,
//       ),
//       child: Card(
//         color: pageBackgroundColor,
//         clipBehavior: Clip.antiAlias,
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: mode.background,
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(25.0)),
//           ),
//           child: Column(
//             children: [
//               ScrollOnExpand(
//                 scrollOnExpand: true,
//                 scrollOnCollapse: false,
//                 child: ExpandablePanel(
//                   theme: const ExpandableThemeData(
//                     headerAlignment: ExpandablePanelHeaderAlignment.center,
//                     tapBodyToCollapse: true,
//                   ),
//                   header: Padding(
//                     padding: EdgeInsets.only(
//                       top: 25,
//                       left: 25,
//                       bottom: 15,
//                     ),
//                     child: Text(
//                       mode.modeName,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 30.0,
//                         fontFamily: "Roboto",
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                   // collapsed: Text(
//                   //   "Something...",
//                   //   softWrap: true,
//                   //   maxLines: 2,
//                   //   overflow: TextOverflow.ellipsis,
//                   // ),
//                   // expanded: Column(
//                   //   crossAxisAlignment: CrossAxisAlignment.start,
//                   //   children: <Widget>[
//                   //     for (var _ in Iterable.generate(5))
//                   //       Padding(
//                   //         padding: EdgeInsets.only(bottom: 10),
//                   //         child: Text(
//                   //           "loremIpsum",
//                   //           softWrap: true,
//                   //           overflow: TextOverflow.fade,
//                   //         ),
//                   //       ),
//                   //   ],
//                   // ),
//                   expanded: getCardWidget(mode.modeName.toLowerCase()),
//                   builder: (_, collapsed, expanded) {
//                     return Padding(
//                       padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                       child: Expandable(
//                         collapsed: collapsed,
//                         expanded: expanded,
//                         theme: const ExpandableThemeData(crossFadePoint: 0),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
