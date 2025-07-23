// import 'package:equatable/equatable.dart';
// import 'package:first_project/remit_choice/dto/api_res/utils_res_model/doc_type_list_res.dart';
// import 'package:first_project/remit_choice/dto/models/doc_model/app_doc.dart';

// import '../../../core/network/api_state.dart';

// class DocVerificationState extends Equatable {
//   const DocVerificationState({
//     this.reviewHeading = '',
//     this.reviewSubheading = '',
//     this.buttonVerify = '',
//     this.docTypeListRes,
//     this.checkUserExistSumSubRes,
//     this.createSumSubRes,
//     this.ondatoRes,
//     this.validDoc,
//     this.sumSubWidgetVisible = false,
//     this.isLoading = false,
//   });
//   final String reviewHeading;
//   final String reviewSubheading;
//   final String buttonVerify;
//   final bool sumSubWidgetVisible;
//   final bool isLoading;
//   final AppDoc? validDoc;
//   final ApiState<DocTypeListRes>? docTypeListRes;
//   final ApiState<String>? checkUserExistSumSubRes;
//   final ApiState<dynamic>? ondatoRes;
//   final ApiState<String>? createSumSubRes;

//   DocVerificationState copyWith({
//     String? reviewHeading,
//     String? reviewSubheading,
//     String? buttonVerify,
//     AppDoc? validDoc,
//     bool? sumSubWidgetVisible,
//     bool? isLoading,
//     ApiState<DocTypeListRes>? docTypeListRes,
//     ApiState<String>? checkUserExistSumSubRes,
//     ApiState<String>? createSumSubRes,
//     ApiState<dynamic>? ondatoRes,
//   }) {
//     return DocVerificationState(
//       reviewHeading: reviewHeading ?? this.reviewHeading,
//       reviewSubheading: reviewSubheading ?? this.reviewSubheading,
//       buttonVerify: buttonVerify ?? this.buttonVerify,
//       docTypeListRes: docTypeListRes ?? this.docTypeListRes,
//       sumSubWidgetVisible: sumSubWidgetVisible ?? this.sumSubWidgetVisible,
//       isLoading: isLoading ?? this.isLoading,
//       validDoc: validDoc ?? this.validDoc,
//       checkUserExistSumSubRes:
//           checkUserExistSumSubRes ?? this.checkUserExistSumSubRes,
//       createSumSubRes: createSumSubRes ?? this.createSumSubRes,
//       ondatoRes: ondatoRes ?? this.ondatoRes,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     reviewHeading,
//     reviewSubheading,
//     buttonVerify,
//     docTypeListRes,
//     checkUserExistSumSubRes,
//     createSumSubRes,
//     sumSubWidgetVisible,
//     isLoading,
//     validDoc,
//     ondatoRes,
//   ];
// }
