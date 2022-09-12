// import 'package:flutter/material.dart';
// import 'package:sillyhouseorg/core/enums/view_state.dart';
// import 'package:sillyhouseorg/core/viewmodels/home_model.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sillyhouseorg/widgets/my_app_bar.dart';
//
// class NotificationScreen extends StatefulWidget {
//   NotificationScreen({Key? key}) : super(key: key);
//
//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   _NotificationScreenState({Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseView<HomeModel>(
//       builder: (context, model, child) => Scaffold(
//         appBar: myAppBar(
//           leadingFunction: () => Navigator.of(context).pop(),
//           title: "Мэдэгдэл",
//         ) as PreferredSizeWidget?,
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: model.state == ViewState.Busy
//               ? Container(child: Center(child: CircularProgressIndicator()))
//               : Column(children: [
//                   Expanded(
//                       child: Center(
//                           child: Container(
//                     height: 450,
//                     child: Stack(
//                       children: [
//                         Image.asset('lib/assets/info.png', height: 450),
//                         Positioned(
//                           top: 110,
//                           left: MediaQuery.of(context).size.width / 2 - 80,
//                           child: Text('Мэдэгдэл ирээгүй', style: GoogleFonts.kurale(fontSize: 16, color: Colors.black)),
//                         ),
//                         Positioned(
//                           top: 130,
//                           left: MediaQuery.of(context).size.width / 2 - 45,
//                           child: Text(' байна.', style: GoogleFonts.kurale(fontSize: 16, color: Colors.black)),
//                         ),
//                       ],
//                     ),
//                   ))),
//                 ]),
//         ),
//       ),
//     );
//   }
// }
