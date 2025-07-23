// // ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

// import 'package:dio/dio.dart';
// import 'package:first_project/core/sumsub_process/sumsub_verification.dart';
// import 'package:first_project/core/utils/json_cache.dart';
// import 'package:first_project/remit_choice/dto/api_req/authenticate_token_req.dart';
// import 'package:first_project/remit_choice/dto/api_res/authenticate_token_res.dart';
// import 'package:first_project/remit_choice/dto/models/doc_model/app_doc.dart';
// import 'package:first_project/remit_choice/dto/models/identity_verification_req.dart';
// import 'package:first_project/remit_choice/dto/models/ondato_registration_model.dart';
// import 'package:first_project/remit_choice/dto/models/user_model/app_user.dart';
// import 'package:first_project/remit_choice/dto/repos/doc_repository.dart';
// import 'package:first_project/remit_choice/dto/repos/utils_repository.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart'
//     hide Options;
// import 'package:get_it/get_it.dart';

// import '../../../core/network/api_state.dart';
// import '../../../core/resources/app_constants.dart';
// import 'doc_verification_state.dart';

// class DocVerificationCubit extends Cubit<DocVerificationState> {
//   final UtilsRepository _utilsRepository;
//   final DocRepository _docRepository;

//   DocVerificationCubit(this._utilsRepository, this._docRepository)
//     : super(const DocVerificationState());

//   final _sp = GetIt.I<FlutterSecureStorage>();
//   final jsonCache = GetIt.I<JsonCacheHelper>();

//   void changeText(
//     String reviewHeading,
//     String reviewSubheading,
//     String buttonVerify,
//   ) {
//     emit(
//       state.copyWith(
//         reviewHeading: reviewHeading,
//         reviewSubheading: reviewSubheading,
//         buttonVerify: buttonVerify,
//       ),
//     );
//   }

//   void sumSubWidgetVisible(bool value) {
//     emit(state.copyWith(sumSubWidgetVisible: value));
//   }

//   Future<void> checkUserExistSumSub() async {
//     emit(state.copyWith(checkUserExistSumSubRes: ApiState.loading(true)));
//     try {
//       String? remitterID = await _sp.read(key: AppConstants.userID);
//       final response = await SumSubVerification.checkUserExistSumSub(
//         remitterID ?? '0',
//       );
//       if (response.toString().isNotEmpty) {
//         debugPrint('checkUserExistSumSub $response');
//         emit(
//           state.copyWith(
//             checkUserExistSumSubRes: ApiState.success(response.toString()),
//           ),
//         );
//       } else {
//         emit(
//           state.copyWith(
//             checkUserExistSumSubRes: ApiState.error(500, 'Error !!'),
//           ),
//         );
//       }
//     } catch (e, stackTrace) {
//       debugPrintStack(stackTrace: stackTrace);
//       emit(
//         state.copyWith(
//           checkUserExistSumSubRes: ApiState.error(500, 'Exception Error!!'),
//         ),
//       );
//     }
//   }

//   Future<void> createApplicantSumSub() async {
//     String? remitterID = await _sp.read(key: AppConstants.userID);
//     AppUser? appUser = await jsonCache.getObject(
//       AppConstants.appUserCache,
//       (json) => AppUser.fromJson(json),
//     );

//     emit(state.copyWith(createSumSubRes: ApiState.loading(true)));
//     try {
//       final dynamic response = await SumSubVerification.createApplicant(
//         remitterID ?? '',
//         appUser,
//       );
//       if (response.toString().isNotEmpty) {
//         emit(
//           state.copyWith(
//             createSumSubRes: ApiState.success(response.toString()),
//           ),
//         );
//       } else {
//         emit(state.copyWith(createSumSubRes: ApiState.error(500, 'Error !!')));
//       }
//     } catch (e, stackTrace) {
//       debugPrintStack(stackTrace: stackTrace);
//       emit(
//         state.copyWith(
//           createSumSubRes: ApiState.error(500, 'Exception Error!!'),
//         ),
//       );
//     }
//   }

//   Future<void> getDocTypeList(
//     String classificationID,
//     String classificationName,
//   ) async {
//     emit(state.copyWith(docTypeListRes: ApiState.loading(true)));
//     try {
//       final docTypeListRes = await _utilsRepository.getDocumentsTypeList(
//         classificationID,
//         classificationName,
//       );
//       if (docTypeListRes != null) {
//         if (docTypeListRes.result.Code == AppConstants.successCode) {
//           emit(
//             state.copyWith(docTypeListRes: ApiState.success(docTypeListRes)),
//           );
//         } else if (docTypeListRes.result.Code == AppConstants.tokenExpireCode ||
//             docTypeListRes.result.Code ==
//                 AppConstants.authenticationFailureCode) {
//           emit(
//             state.copyWith(
//               docTypeListRes: ApiState.tokenExpire(
//                 docTypeListRes.result.Code,
//                 docTypeListRes.result.Message,
//               ),
//             ),
//           );
//         } else {
//           emit(
//             state.copyWith(
//               docTypeListRes: ApiState.error(
//                 docTypeListRes.result.Code,
//                 docTypeListRes.result.Message,
//               ),
//             ),
//           );
//         }
//       }
//     } catch (error) {
//       emit(
//         state.copyWith(
//           docTypeListRes: ApiState.error(500, 'Exception Error!!'),
//         ),
//       );
//     }
//   }

//   // Future<void> docList() async {
//   //   try {
//   //     final docRes = await _docRepository.getDocsList();
//   //     if (docRes != null) {
//   //       if (docRes.result.Code == AppConstants.successCode) {
//   //         if (docRes.data != null) {
//   //           AppDoc? doc =  docRes.data?.firstWhere((user) => user.ClassificationId == '1' && user.UserDocType == 'P'
//   //               && user.ExternalProvider=='SUMSUB' && user.ExternalReferenceStatus==1);
//   //           if (doc != null) {
//   //             debugPrint('isValidDoc sumsub doc ${doc.DocID} ${doc.DocNumber}');
//   //             await _sp.write(key:AppConstants.isValidDoc,value: '1' );
//   //           } else {
//   //             await _sp.write(key:AppConstants.isValidDoc,value: '0' );
//   //           }
//   //         }
//   //       } else if (docRes.result.Code == AppConstants.tokenExpireCode ||
//   //           docRes.result.Code == AppConstants.authenticationFailureCode) {
//   //       } else {
//   //         await _sp.write(key:AppConstants.isValidDoc,value: '0' );
//   //       }
//   //     }
//   //   } catch (e) {
//   //     await _sp.write(key:AppConstants.isValidDoc,value: '0' );
//   //   }
//   // }

//   Future<void> checkValidDoc() async {
//     emit(state.copyWith(isLoading: true));
//     try {
//       AppDoc? validDoc = await docList();
//       if (validDoc != null) {
//         debugPrint(
//           'Valid document found: ${validDoc.remitter_document_id} - ${validDoc.document_number}',
//         );
//         getDocTypeList('0', '');
//         emit(state.copyWith(validDoc: validDoc, isLoading: false));
//       } else {
//         emit(state.copyWith(isLoading: false));
//       }
//     } catch (e, stackTrace) {
//       emit(state.copyWith(isLoading: false));
//       debugPrint('No valid document found. $stackTrace');
//     }
//   }

//   Future<AppDoc?> docList() async {
//     try {
//       final docRes = await _docRepository.getDocsList();
//       if (docRes != null && docRes.result.Code == AppConstants.successCode) {
//         if (docRes.data != null) {
//           AppDoc? appDoc;
//           if ((await _sp.read(key: AppConstants.onDatoCountries) ?? '')
//               .contains(
//                 await _sp.read(key: AppConstants.countryIso3Code) ?? '',
//               )) {
//             debugPrint('Check Valid doc Ondato');
//             appDoc = docRes.data?.firstWhere(
//               (user) =>
//                   user.document_category_id == '1' &&
//                   user.is_primary == true &&
//                   user.external_provider == 'ondato',
//               orElse: () => AppDoc(),
//             );
//           } else {
//             debugPrint('Check Valid doc SUMSUB');
//             appDoc = docRes.data?.firstWhere(
//               (user) =>
//                   user.document_category_id == '1' &&
//                   user.is_primary == true &&
//                   user.external_provider == 'SUMSUB' &&
//                   user.external_provider_status == 1,
//               orElse: () => AppDoc(),
//             );
//           }
//           await _sp.write(
//             key: AppConstants.isValidDoc,
//             value: appDoc != null ? '1' : '0',
//           );
//           return appDoc;
//         }
//       }

//       if (docRes?.result.Code == AppConstants.tokenExpireCode ||
//           docRes?.result.Code == AppConstants.authenticationFailureCode) {
//         return null;
//       }
//       await _sp.write(key: AppConstants.isValidDoc, value: '0');
//       return null;
//     } catch (e) {
//       await _sp.write(key: AppConstants.isValidDoc, value: '0');
//       return null;
//     }
//   }

//   Future<AuthenticateTokenRes?> ondatoAuthenticate() async {
//     AuthenticateTokenReq req = AuthenticateTokenReq();
//     req.client_id = dotenv.env['ONDATO_ClIENT_ID_PROD'];
//     req.client_secret = dotenv.env['ONDATO_ClIENT_SECRET_PROD'];
//     req.grant_type = "client_credentials";
//     try {
//       final Dio dio = Dio();

//       // SandBox Url
//       //  https://sandbox-id.ondato.com/

//       String encodedData = Uri(queryParameters: req.toJson()).query;
//       Response response = await dio.post(
//         'https://id.ondato.com/connect/token',
//         data: encodedData,
//         options: Options(
//           headers: {
//             "Content-Type": "application/x-www-form-urlencoded",
//             "charset": "UTF-8",
//           },
//         ),
//       );
//       debugPrint('ondatoAuthenticate response ${response.toString()}');
//       if (response.toString().isNotEmpty) {
//         AuthenticateTokenRes authenticateTokenRes =
//             AuthenticateTokenRes.fromJson(response.data);
//         if (authenticateTokenRes.access_token.isNotEmpty) {
//           return authenticateTokenRes;
//         }
//       } else {
//         return null;
//       }
//     } catch (e, stackTrace) {
//       debugPrintStack(stackTrace: stackTrace);
//       debugPrint('ondatoAuthenticate $e');
//       return null;
//     }
//     return null;
//   }

//   Future<void> identityVerification() async {
//     emit(state.copyWith(ondatoRes: ApiState.loading(true)));
//     try {
//       AuthenticateTokenRes? mRes = await ondatoAuthenticate();
//       if (mRes != null) {
//         final response = await ondatoIdentityVerification(mRes.access_token);
//         if (response.toString().isNotEmpty) {
//           debugPrint('ondatoRes $response');
//           emit(state.copyWith(ondatoRes: ApiState.success(response)));
//         } else {
//           emit(state.copyWith(ondatoRes: ApiState.error(500, 'Error !!')));
//         }
//       }
//     } catch (e, stackTrace) {
//       debugPrintStack(stackTrace: stackTrace);
//       emit(state.copyWith(ondatoRes: ApiState.error(500, 'Exception Error!!')));
//     }
//   }

//   Future<dynamic> ondatoIdentityVerification(String token) async {
//     AppUser? appUser = await jsonCache.getObject(
//       AppConstants.appUserCache,
//       (json) => AppUser.fromJson(json),
//     );

//     String? remitterID = await _sp.read(key: AppConstants.userID);

//     OndatoRegistrationModel ondatoRegistrationModel = OndatoRegistrationModel(
//       dateOfBirth: appUser!.date_of_birth ?? '',
//       email: appUser.email ?? '',
//       firstName: appUser.first_name ?? '',
//       lastName: appUser.last_name ?? '',
//       personalCode: remitterID ?? '',
//       phoneNumber: appUser.mobile_phone ?? '',
//       countryCode: appUser.country_iso_code ?? '',
//     );

//     IdentityVerificationReq req = IdentityVerificationReq(
//       externalReferenceId: remitterID ?? '',
//       registration: ondatoRegistrationModel,
//       setupId: dotenv.env['ONDATO_SETUP_ID_PROD'] ?? '',
//     );

//     try {
//       final Dio dio = Dio();
//       // SandBox Url
//       //  https://sandbox-idvapi.ondato.com/

//       dio.options.headers['Authorization'] = 'Bearer $token';
//       Response response = await dio.post(
//         'https://idvapi.ondato.com/v1/identity-verifications',
//         data: req.toJson(),
//       );

//       debugPrint('ondatoIdentityVerification response ${response.toString()}');
//       if (response.toString().isNotEmpty) {
//         return response;
//       } else {
//         return null;
//       }
//     } catch (e, stackTrace) {
//       debugPrintStack(stackTrace: stackTrace);
//       debugPrint('ondatoAuthenticate $e');
//       return null;
//     }
//   }

//   void reset() {
//     emit(const DocVerificationState());
//   }
// }
