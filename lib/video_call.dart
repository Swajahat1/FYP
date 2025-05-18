// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class Callpage extends StatelessWidget {
//   const Callpage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userId = Random().nextInt(10000).toString(); // Generate a random userId

//     final callID = 'call_${Random().nextInt(10000)}'; // Generate a random callID

//     return ZegoUIKitPrebuiltCall(
//       appID: 778471871, 
//       appSign: 'f161cdcff3d4e23db37e74cc6a83a8c2db59d559a79234ea3e14f629397fca0e', 
//       userID: userId.toString(),
//       userName: 'UserName $userId',
//       callID: callID,
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
//     );
//   }
// }
