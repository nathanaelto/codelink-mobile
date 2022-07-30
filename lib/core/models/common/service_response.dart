import 'package:codelink_mobile/shared/widgets/toast.dart';
import 'package:flutter/material.dart';

class ServiceResponse<ResponseType> {
  ResponseType? data;
  String? error;

  bool hasError;
  bool hasData;


  factory ServiceResponse.success(ResponseType data) {
    return ServiceResponse(data, null, false, true);
  }

  factory ServiceResponse.error(String error) {
    return ServiceResponse(null, error, true, false);
  }

  ServiceResponse(this.data, this.error, this.hasError, this.hasData);

  @override
  String toString() {
    return 'ServiceResponse{data: $data, error: $error, hasError: $hasError, hasData: $hasData}';
  }

  Future<void > displayToastIfError(BuildContext context) async {
    if (hasError || !hasData ) {
      Toast.show(error!, context, duration: 5,  backgroundColor: Colors.red);
    }

  }

}