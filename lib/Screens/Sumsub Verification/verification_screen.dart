// import 'dart:async';
// import 'dart:convert';

// import 'package:first_project/core/resources/app_colors.dart';
// import 'package:first_project/remit_choice/dto/api_res/utils_res_model/doc_type_list_res.dart';
// import 'package:first_project/remit_choice/dto/models/review_result.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get_it/get_it.dart';
// import 'package:go_router/go_router.dart';
// import 'package:ondato_flutter/ondato_config.dart';
// import 'package:ondato_flutter/ondato_flutter.dart';
// import '../../../core/components/app_dialogs.dart';
// import '../../../core/components/back_button_widget.dart';
// import '../../../core/components/custom_shimmer.dart';
// import '../../../core/components/sized_box.dart';
// import '../../../core/resources/app_constants.dart';
// import '../../../core/resources/app_image.dart';
// import '../../../core/resources/app_routes.dart';
// import '../../../core/sumsub_process/sumsub_verification.dart';
// import 'doc_verification_cubit.dart';
// import 'doc_verification_state.dart';

// class DocVerification extends StatefulWidget {
//   const DocVerification({super.key});

//   @override
//   State<DocVerification> createState() => _DocVerificationState();
// }

// class _DocVerificationState extends State<DocVerification> {
//   Timer? apiStatusCheckTimer;
//   late final DocVerificationCubit cubit;
//   final _sp = GetIt.I<FlutterSecureStorage>();
//   @override
//   void initState() {
//     super.initState();
//     cubit = BlocProvider.of<DocVerificationCubit>(context);

//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       if ((await _sp.read(key: AppConstants.onDatoCountries) ?? '').contains(
//         (await _sp.read(key: AppConstants.countryIso3Code) ?? ''),
//       )) {
//         cubit.checkValidDoc();
//       } else {
//         cubit.docList();
//         startApiStatusCheck();
//         cubit.sumSubWidgetVisible(true);
//         cubit.checkUserExistSumSub();
//       }
//     });

//     //cubit.getDocTypeList('0', '');
//   }

//   @override
//   void dispose() {
//     cubit.reset();
//     stopApiStatusCheck();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 BackButtonWidget(
//                   onPressed: () {
//                     context.pop();
//                   },
//                   iconColor: Colors.grey.shade600,
//                 ),
//                 sizedBoxWidth(0, 15),
//                 Align(
//                   alignment: Alignment.topCenter,
//                   child: Text(
//                     'Doc Verification',
//                     //AppLocalization.of(context).translate('login_Title'),
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                 ),
//               ],
//             ),
//             sizedBoxWidth(0, 10),
//             BlocBuilder<DocVerificationCubit, DocVerificationState>(
//               buildWhen: (previous, current) =>
//                   previous.checkUserExistSumSubRes !=
//                   current.checkUserExistSumSubRes,
//               builder: (context, state) {
//                 if (state.checkUserExistSumSubRes?.loadingState != null) {
//                   return Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: shimmerLoadingWidget(),
//                   );
//                 } else if (state.checkUserExistSumSubRes?.successState !=
//                     null) {
//                   final res = state.checkUserExistSumSubRes?.successState?.data;
//                   if (res != '') {
//                     checkUserExistSumSubRes(res!);
//                     return const SizedBox.shrink();
//                   } else {
//                     return const SizedBox.shrink();
//                   }
//                 } else if (state.checkUserExistSumSubRes?.errorState != null) {
//                   checkUserExistSumSubRes('');
//                   return const SizedBox.shrink();
//                 } else {
//                   return const SizedBox.shrink();
//                 }
//               },
//             ),
//             sizedBoxWidth(0, 10),
//             BlocBuilder<DocVerificationCubit, DocVerificationState>(
//               // buildWhen: (previous, current) =>
//               // previous.validDoc != current.validDoc,
//               builder: (context, state) {
//                 if (state.isLoading != false) {
//                   return Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: shimmerLoadingWidget(),
//                   );
//                 } else if (state.validDoc != null) {
//                   return Container(
//                     margin: const EdgeInsets.all(15),
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey,
//                           spreadRadius: 2,
//                           blurRadius: 7,
//                           offset: Offset(0, 1),
//                         ),
//                       ],
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           sizedBoxWidth(15, 0),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Photo ID',
//                                   style: Theme.of(context).textTheme.bodyLarge
//                                       ?.copyWith(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                 ),
//                                 sizedBoxWidth(0, 5),
//                                 Text(
//                                   'Your Identity document is successfully verified!!',
//                                   style: Theme.of(context).textTheme.bodyLarge
//                                       ?.copyWith(
//                                         color: Colors.black,
//                                         fontSize: 14,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 } else if (state.validDoc == null) {
//                   return Container(
//                     margin: const EdgeInsets.all(15),
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey,
//                           spreadRadius: 2,
//                           blurRadius: 7,
//                           offset: Offset(0, 1), // changes position of shadow
//                         ),
//                       ],
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           //  Image.asset(AppImage.docBtnIcon),
//                           sizedBoxWidth(15, 0),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Photo ID',
//                                   style: Theme.of(context).textTheme.bodyLarge
//                                       ?.copyWith(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                 ),
//                                 sizedBoxWidth(0, 5),
//                                 Text(
//                                   'Start Verification Step',
//                                   style: Theme.of(context).textTheme.bodyLarge
//                                       ?.copyWith(
//                                         color: Colors.black,
//                                         fontSize: 16,
//                                       ),
//                                 ),
//                                 sizedBoxWidth(0, 15),
//                                 BlocConsumer<
//                                   DocVerificationCubit,
//                                   DocVerificationState
//                                 >(
//                                   listenWhen: (previous, current) =>
//                                       previous.ondatoRes != current.ondatoRes,
//                                   buildWhen: (previous, current) =>
//                                       previous.ondatoRes != current.ondatoRes,
//                                   listener: (context, state) {
//                                     if (state.ondatoRes != null) {
//                                       ondatoResState(state);
//                                     }
//                                   },
//                                   builder: (context, state) {
//                                     return Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         OutlinedButton(
//                                           onPressed: () {
//                                             cubit.identityVerification();
//                                           },
//                                           child:
//                                               state
//                                                       .createSumSubRes
//                                                       ?.loadingState !=
//                                                   null
//                                               ? shimmerWidget(100, 30)
//                                               : Text(
//                                                   'Continue',
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .bodyMedium
//                                                       ?.copyWith(
//                                                         fontSize: 14,
//                                                         color: Colors.black,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                 ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 } else {
//                   return const SizedBox.shrink();
//                 }
//               },
//             ),
//             sizedBoxWidth(0, 10),
//             BlocBuilder<DocVerificationCubit, DocVerificationState>(
//               buildWhen: (previous, current) =>
//                   previous.sumSubWidgetVisible != current.sumSubWidgetVisible,
//               builder: (context, state) {
//                 return Visibility(
//                   maintainState: true,
//                   maintainSize: false,
//                   visible: state.sumSubWidgetVisible,
//                   child: Container(
//                     margin: const EdgeInsets.all(15),
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey,
//                           spreadRadius: 2,
//                           blurRadius: 7,
//                           offset: Offset(0, 1), // changes position of shadow
//                         ),
//                       ],
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           //  Image.asset(AppImage.docBtnIcon),
//                           sizedBoxWidth(15, 0),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Photo ID',
//                                   style: Theme.of(context).textTheme.bodyLarge
//                                       ?.copyWith(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                 ),
//                                 sizedBoxWidth(0, 5),
//                                 BlocConsumer<
//                                   DocVerificationCubit,
//                                   DocVerificationState
//                                 >(
//                                   listenWhen: (previous, current) =>
//                                       previous.reviewHeading !=
//                                       current.reviewHeading,
//                                   buildWhen: (previous, current) =>
//                                       previous.reviewHeading !=
//                                       current.reviewHeading,
//                                   listener: (context, state) {
//                                     // TODO: implement listener
//                                   },
//                                   builder: (context, state) {
//                                     return state.reviewHeading.isEmpty
//                                         ? const SizedBox.shrink()
//                                         : Text(
//                                             state.reviewHeading,
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyLarge
//                                                 ?.copyWith(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                 ),
//                                           );
//                                   },
//                                 ),
//                                 sizedBoxWidth(0, 5),
//                                 BlocConsumer<
//                                   DocVerificationCubit,
//                                   DocVerificationState
//                                 >(
//                                   listenWhen: (previous, current) =>
//                                       previous.reviewSubheading !=
//                                       current.reviewSubheading,
//                                   buildWhen: (previous, current) =>
//                                       previous.reviewSubheading !=
//                                       current.reviewSubheading,
//                                   listener: (context, state) {
//                                     // TODO: implement listener
//                                   },
//                                   builder: (context, state) {
//                                     return state.reviewSubheading.isEmpty
//                                         ? const SizedBox.shrink()
//                                         : state.reviewSubheading ==
//                                               'Your Identity document is successfully verified!!'
//                                         ? Text(
//                                             state.reviewSubheading,
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyLarge
//                                                 ?.copyWith(
//                                                   color: Colors.black,
//                                                   fontSize: 14,
//                                                 ),
//                                           )
//                                         : Text(
//                                             state.reviewSubheading,
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyLarge
//                                                 ?.copyWith(
//                                                   color: Colors.red,
//                                                   fontSize: 14,
//                                                 ),
//                                           );
//                                   },
//                                 ),
//                                 sizedBoxWidth(0, 15),
//                                 BlocConsumer<
//                                   DocVerificationCubit,
//                                   DocVerificationState
//                                 >(
//                                   listenWhen: (previous, current) =>
//                                       previous.buttonVerify !=
//                                           current.buttonVerify ||
//                                       previous.createSumSubRes !=
//                                           current.createSumSubRes,
//                                   buildWhen: (previous, current) =>
//                                       previous.buttonVerify !=
//                                           current.buttonVerify ||
//                                       previous.createSumSubRes !=
//                                           current.createSumSubRes,
//                                   listener: (context, state) {
//                                     if (state.createSumSubRes != null) {
//                                       createSumSubResState(state);
//                                     }
//                                   },
//                                   builder: (context, state) {
//                                     return state.buttonVerify.isEmpty
//                                         ? const SizedBox.shrink()
//                                         : Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             children: [
//                                               OutlinedButton(
//                                                 onPressed: goToSumSub,
//                                                 child:
//                                                     state
//                                                             .createSumSubRes
//                                                             ?.loadingState !=
//                                                         null
//                                                     ? shimmerWidget(100, 30)
//                                                     : Text(
//                                                         state.buttonVerify,
//                                                         style: Theme.of(context)
//                                                             .textTheme
//                                                             .displaySmall
//                                                             ?.copyWith(
//                                                               fontSize: 14,
//                                                               color:
//                                                                   Colors.black,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                             ),
//                                                       ),
//                                               ),
//                                             ],
//                                           );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             sizedBoxWidth(0, 10),
//             Expanded(
//               child: BlocConsumer<DocVerificationCubit, DocVerificationState>(
//                 buildWhen: (previousState, currentState) =>
//                     previousState.docTypeListRes != currentState.docTypeListRes,
//                 listenWhen: (previousState, currentState) =>
//                     previousState.docTypeListRes != currentState.docTypeListRes,
//                 listener: (context, state) {
//                   if (state.docTypeListRes?.tokenExpireState != null) {
//                     context.goNamed(AppRoutes.sliderScreen);
//                     AppsDialogs.tokeExpireMessage();
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state.docTypeListRes?.loadingState != null) {
//                     return docTypeListShimmer();
//                   } else if (state.docTypeListRes?.successState != null) {
//                     final res = state.docTypeListRes?.successState?.data;
//                     if (res?.data != null) {
//                       return docTypeCategoryList(res!);
//                     } else {
//                       return Container(
//                         padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                         alignment: Alignment.center,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Image.asset(
//                               AppImage.noDocument,
//                               height: MediaQuery.of(context).size.width * 0.55,
//                               fit: BoxFit.fitHeight,
//                             ),
//                             sizedBoxWidth(0, 30),
//                             Text(
//                               'No Doc Types Found',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Theme.of(context).primaryColor,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 20,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   } else if (state.docTypeListRes?.errorState != null) {
//                     return const Center(child: Text('Record Not Found '));
//                   } else {
//                     return const SizedBox.shrink();
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void createSumSubResState(DocVerificationState state) {
//     if (state.createSumSubRes != null) {
//       if (state.createSumSubRes?.successState != null) {
//         final resp = state.createSumSubRes?.successState?.data;
//         final parsedJson = jsonDecode(resp!);
//         if (parsedJson['code'] == 404) {
//           debugPrint('Applicant not found');
//         } else if (parsedJson['code'] == 409) {
//           debugPrint('Applicant with external user id  already exists');
//           SumSubVerification.getAccessToken();
//         } else {
//           SumSubVerification.getAccessToken();
//         }
//       } else if (state.createSumSubRes?.errorState != null) {
//         final errorMessage = state.createSumSubRes?.errorState?.errorMessage;
//         AppsDialogs.statusDialog(context, '', errorMessage ?? 'Error !!');
//       }
//     }
//   }

//   void ondatoResState(DocVerificationState state) {
//     if (state.ondatoRes != null) {
//       if (state.ondatoRes?.successState != null) {
//         final resp = state.ondatoRes?.successState?.data;
//         final parsedJson = jsonDecode(resp.toString());
//         debugPrint('Applicant ${parsedJson.toString()}');
//         if (parsedJson['id'] != '') {
//           // launchOndatoSdk(parsedJson['id']);
//           context.pushNamed(
//             AppRoutes.ondatoScreen,
//             extra: {'identificationId': parsedJson['id'] ?? ''},
//           );
//         }
//       } else if (state.ondatoRes?.errorState != null) {
//         final errorMessage = state.ondatoRes?.errorState?.errorMessage;
//         AppsDialogs.statusDialog(context, '', errorMessage ?? 'Error !!');
//       }
//     }
//   }

//   void checkUserExistSumSubRes(String res) {
//     if (res.isNotEmpty) {
//       final parsedJson = jsonDecode(res);
//       if (parsedJson['code'] == 404) {
//         if (parsedJson['description'] == 'Applicant not found') {
//           cubit.changeText("Start verification step.", '', "Continue");
//         }
//       } else if (parsedJson['code'] == 409) {
//       } else {
//         final review = parsedJson['review'];
//         final reviewStatus = review['reviewStatus'];
//         if (review['reviewResult'] != null) {
//           final reviewResult = ReviewResult.fromJson(review['reviewResult']);
//           if (reviewStatus == 'completed') {
//             if (reviewResult.reviewAnswer == 'RED' &&
//                 reviewResult.reviewRejectType == 'RETRY') {
//               cubit.changeText(
//                 '',
//                 'We are failed to verify your document, click on resubmit and follow the instructions. Note: Screenshots and/or photo of Id copies are not acceptable.',
//                 'Resubmit',
//               );
//             } else if (reviewResult.reviewAnswer == 'RED' &&
//                 reviewResult.reviewRejectType == 'FINAL') {
//               if (reviewResult.clientComment?.isNotEmpty == true) {
//                 final formattedMessage = reviewResult.clientComment!
//                     .split('\n')
//                     .map((point) => point.replaceAll('- ', '').trim())
//                     .where((point) => point.isNotEmpty)
//                     .map((point) => '• $point')
//                     .join('\n');
//                 cubit.changeText(
//                   reviewResult.moderationComment ?? '',
//                   '$formattedMessage\n\nFor further queries please contact us at help@izisend.com',
//                   '',
//                 );
//               } else {
//                 cubit.changeText(
//                   '',
//                   "You can't submit any document for now. \n\nFor further queries please contact us at help@remitunion.co.uk",
//                   '',
//                 );
//               }
//             }
//             if (reviewResult.reviewAnswer == 'GREEN') {
//               cubit.changeText(
//                 '',
//                 'Your Identity document is successfully verified!!',
//                 '',
//               );
//               stopApiStatusCheck();
//               cubit.getDocTypeList('0', '');
//             }
//           }
//         } else if (reviewStatus == 'init' || reviewStatus == 'prechecked') {
//           cubit.changeText('Start Verification step', '', 'Continue');
//         } else if (reviewStatus == 'pending' || reviewStatus == 'onHold') {
//           cubit.changeText(
//             'In Process',
//             "We're checking your ID, status of ID verification will be updated very soon.",
//             '',
//           );
//         }
//       }
//     } else {
//       cubit.changeText("Start verification step.", '', "Continue");
//     }
//   }

//   Widget docTypeCategoryList(DocTypeListRes data) {
//     return ListView.builder(
//       itemCount: data.data.length,
//       shrinkWrap: true,
//       itemBuilder: (BuildContext context, index) {
//         // This condition is not show the identity doc category for
//         // new and old system both
//         return (data.data[index]['id'] != 1)
//             ? Container(
//                 margin: const EdgeInsets.all(15),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey,
//                       spreadRadius: 2,
//                       blurRadius: 7,
//                       offset: Offset(0, 1), // changes position of shadow
//                     ),
//                   ],
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//                 padding: const EdgeInsets.all(15),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Image.asset(AppImage.docBtnIcon),
//                     sizedBoxWidth(15, 0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             data.data[index]['name'].toString(),
//                             style: Theme.of(context).textTheme.bodyLarge
//                                 ?.copyWith(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w500,
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                           ),
//                           sizedBoxWidth(0, 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               SizedBox(
//                                 width: MediaQuery.sizeOf(context).width * 0.2,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     padding: const EdgeInsets.all(6),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     context.pushNamed(
//                                       AppRoutes.addNewDocument,
//                                       extra: {
//                                         'classificationID': data
//                                             .data[index]['id']
//                                             .toString(),
//                                         'classificationName': data
//                                             .data[index]['name']
//                                             .toString(),
//                                       },
//                                     );
//                                   },
//                                   child: const Text('Add'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : const SizedBox.shrink();
//       },
//     );
//   }

//   void goToSumSub() {
//     cubit.createApplicantSumSub();
//   }

//   void startApiStatusCheck() {
//     const interval = Duration(seconds: 25);
//     apiStatusCheckTimer = Timer.periodic(interval, (timer) {
//       cubit.checkUserExistSumSub();
//     });
//   }

//   void stopApiStatusCheck() {
//     if (apiStatusCheckTimer != null && apiStatusCheckTimer!.isActive) {
//       apiStatusCheckTimer!.cancel();
//     }
//   }

//   Future<void> launchOndatoSdk(String id) async {
//     final result = await OndatoFlutter.init(
//       OndatoServiceConfiguration(
//         identificationId: id,
//         language: OndatoLanguage.en,
//         mode: OndatoEnvironment.live,
//         flowConfiguration: OndatoFlowConfiguration(
//           showSuccessWindow: true,
//           showStartScreen: true,
//         ),
//         appearance: OndatoIosAppearance(
//           errorColor: AppColors.primary,
//           progressColor: AppColors.primary,
//         ),
//       ),
//     );
//     debugPrint('OndatoFlutter ${result.toString()}');
//   }
// }
