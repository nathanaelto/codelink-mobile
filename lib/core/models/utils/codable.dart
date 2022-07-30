import 'dart:convert';

import 'package:codelink_mobile/core/models/common/service_response.dart';

typedef DecodeFunction<Input,Output> = Output Function(Input);
typedef DecodeJsonObjectFunction<T> = T Function(Map<String, dynamic>);
typedef DecodeJsonObjectFunctionWithGeneric<T, G, I> = T Function(Map<String, dynamic>, DecodeFunction<I, G>);

class DecodableTools {

  static DEFAULT_PARSE_ERROR(String? key) => 'Une erreur est survenu lors de la récuperation de vos données $key';

  static bool checkType<T>(dynamic value) {
    return value is T;
  }

  static DecodeFunction<Input,Output> generateDecodeFunction<Input,Output>() {
    Output decodeFunction(Input input) {
      return DecodableTools._validateValue<Output>(input);
    }
    return decodeFunction;
  }

  static T _validateValue<T>(dynamic value) {
    if ( !checkType<T>(value) ) {
      print("error on _validateValue<T>(dynamic value)");
      throw Exception("wanted a ${T.toString()} type but got a ${value.runtimeType.toString()}");
    }
    return value;
  }

  static T _validateField<T>(Map<String, dynamic> dict, String key) {

    dynamic value = dict[key];
    if (value == null || !checkType<T>(value) ) {
      print("error $key is null or not a ${T.toString()}");

      throw Exception("wanted a ${T.toString()} type but got a ${value.runtimeType.toString()}");
    }
    return value;
  }


  static T? _validateNullableField<T>(Map<String, dynamic> dict, String key) {
    dynamic value = dict[key];
    if (value != null && !checkType<T>(value)) {
      print("error $key is not a ${T.toString()}");
      throw Exception(DEFAULT_PARSE_ERROR(""));
    }
    return value;
  }

  static ServiceResponse<T> decodeFromBodyString<T>(String bodyString, DecodeFunction<Map<String, dynamic>, T> decodeFunction) {
    try {
      dynamic jsonDecoded = jsonDecode(bodyString);

      if ( !checkType<Map<String, dynamic>>(jsonDecoded) ) {
        throw Exception(DEFAULT_PARSE_ERROR(""));
      }

      T data = decodeFunction(jsonDecoded);
      return ServiceResponse.success(data);


    } catch (error) {
      print("Error parsing : $bodyString");
      return ServiceResponse.error(error.toString());
    }
  }

  static ServiceResponse<List<T>> decodeListFromBodyString<T>(String bodyString, DecodeFunction<Map<String, dynamic>, T> decodeFunction) {
    try {
      dynamic jsonDecoded = jsonDecode(bodyString);
      if ( !checkType<List<dynamic>>(jsonDecoded)  ) {
        throw Exception(DEFAULT_PARSE_ERROR(""));
      }
      List<dynamic> list = jsonDecoded;
      List<T> listData = list.map((element) => decodeFunction(element)).toList();
      return ServiceResponse.success(listData);
    } catch (error) {
      return ServiceResponse.error(error.toString());
    }
  }

  static Map<String, dynamic> toJsonObject(String jsonString) {
    dynamic jsonDecoded = jsonDecode(jsonString);
    if ( checkType<Map<String, dynamic>>(jsonDecoded) ) {
      return jsonDecoded;
    }

    print("can't parse to jsonObject(Map<String, dynamic>) , we got a runtime type ${jsonDecoded.runtimeType}");
    throw Exception(DEFAULT_PARSE_ERROR(""));
  }


  static ServiceResponse<List<dynamic>> toJsonList(String jsonString) {
    dynamic jsonDecoded = jsonDecode(jsonString);
    if ( checkType<List<dynamic>>(jsonDecoded) ) {
      return ServiceResponse.success(jsonDecoded);
    }
    print('we got a JSON OBJECT');
    return ServiceResponse.error(DEFAULT_PARSE_ERROR(""));
  }


  static List<OutputType> decodeList<OutputType>(List<dynamic> dynamicList, DecodeJsonObjectFunction<OutputType> decodeFunction) {
    return dynamicList.map((dynamic) => decodeFunction(dynamic)).toList();
  }

  static List<OutputType> decodeNestedList<OutputType>(Map<String, dynamic> jsonObject, String key, DecodeJsonObjectFunction<OutputType> decodeFunction) {
    List<dynamic> dynamicList = _validateField<List<dynamic>>(jsonObject, key);
    return dynamicList.map((dynamic) => decodeFunction(dynamic)).toList();
  }

  static List<OutputType> decodeNestedListWithGeneric<OutputType, GenericType, I>(Map<String, dynamic> jsonObject, String key, DecodeJsonObjectFunctionWithGeneric<OutputType, GenericType, I> decodeFunctionWithGeneric, DecodeFunction<I, GenericType> decodeGeneric) {
    List<dynamic> dynamicList = _validateField<List<dynamic>>(jsonObject, key);
    return dynamicList.map((dynamic) => decodeFunctionWithGeneric(dynamic, decodeGeneric)).toList();
  }

  static OutputType decodeNestedObject<OutputType>(Map<String, dynamic> jsonObject, String key, DecodeJsonObjectFunction<OutputType> decodeFunction) {
    dynamic dynamicNestedJsonObject = jsonObject[key];
    if (!checkType<Map<String, dynamic>>(dynamicNestedJsonObject)  ) {
      throw Exception(DecodableTools.DEFAULT_PARSE_ERROR(key));
    }
    Map<String, dynamic> nestedJsonObject = dynamicNestedJsonObject;
    return decodeFunction(nestedJsonObject);
  }

  static OutputType? decodeNullableNestedObject<OutputType>(Map<String, dynamic> jsonObject, String key, DecodeJsonObjectFunction<OutputType> decodeFunction) {
    dynamic dynamicNestedJsonObject = jsonObject[key];
    if (dynamicNestedJsonObject == null) {
      return null;
    } else if ( !checkType<Map<String, dynamic>>(dynamicNestedJsonObject) ) {
      throw Exception(DecodableTools.DEFAULT_PARSE_ERROR(key));
    }
    Map<String, dynamic> nestedJsonObject = dynamicNestedJsonObject;
    return decodeFunction(nestedJsonObject);
  }


  static EnumType decodeEnum<InputType, EnumType>(Map<String, dynamic> jsonObject, String key, DecodeFunction<InputType, EnumType> decodeCivility) {
    dynamic dynamicValue = jsonObject[key];

    if ( !checkType<InputType>(dynamicValue) ) {
      throw Exception(DecodableTools.DEFAULT_PARSE_ERROR(key));
    }
    return decodeCivility(dynamicValue);
  }



  static String decodeString(Map<String, dynamic> jsonObject, String key) {
    return _validateField<String>(jsonObject, key);
  }

  static String? decodeNullableString(Map<String, dynamic> jsonObject, String key) {
    return _validateNullableField<String>(jsonObject, key);
  }

  static List<String> decodeStringList(Map<String, dynamic> jsonObject, String key) {

    List<dynamic> dynamicList = _validateField<List<dynamic>>(jsonObject, key);
    try {
      return dynamicList.map((dynamicValue) => _validateValue<String>(dynamicValue)).toList();
    } catch (error) {
      throw Exception("Could not parse $key  , ${error.toString()} ");
    }

  }

  static DateTime decodeDate(Map<String, dynamic> dict, String key) {
    dynamic value = dict[key];
    if (value == null ||  !checkType<String>(value) ) {
      print("error $key is null or not a String date");
      throw Exception(DEFAULT_PARSE_ERROR(key));
    }
    String stringDate = value;
    return DateTime.parse(stringDate);
  }

  static bool decodeBool(Map<String, dynamic> jsonObject, String key) {
    return _validateField<bool>(jsonObject, key);
  }


  static int decodeInt(Map<String, dynamic> jsonObject, String key) {
    return _validateField<int>(jsonObject, key);
  }

  static int? decodeNullableInt(Map<String, dynamic> jsonObject, String key) {
    return _validateNullableField<int>(jsonObject, key);
  }

  static double decodeDouble(Map<String, dynamic> jsonObject, String key) {
    dynamic value = jsonObject[key];

    if ( checkType<int>(value) ) {
      int intValue = _validateField<int>(jsonObject, key);
      return double.parse(intValue.toString());
    }
    return _validateField<double>(jsonObject, key);
  }

  static double? decodeNullableDouble(Map<String, dynamic> jsonObject, String key) {
    dynamic value = jsonObject[key];


    if (value == null) {
      return null;
    } else if ( checkType<int>(value) ) {
      int intValue = _validateField<int>(jsonObject, key);
      return double.parse(intValue.toString());
    }
    return _validateField<double>(jsonObject, key);
  }

  static T decodeGeneric<T>(Map<String, dynamic> jsonObject, String key) {
    return _validateField<T>(jsonObject, key);
  }

  static T? decodeNullableGeneric<T>(Map<String, dynamic> jsonObject, String key) {
    return _validateNullableField<T>(jsonObject, key);
  }
}

abstract class Decodable<OutputType, InputType> {
   OutputType decode(InputType jsonObject);
}

abstract class DecodableGeneric<OutputType, GenericType> {
  OutputType decode(Map<String, dynamic> toDecode, DecodeJsonObjectFunction<GenericType> decodeGeneric);
}

abstract class Encodable {
  String encode();
}



