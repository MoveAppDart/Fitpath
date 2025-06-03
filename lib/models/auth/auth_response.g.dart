// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSuccessResponse _$AuthSuccessResponseFromJson(Map<String, dynamic> json) =>
    AuthSuccessResponse(
      success: json['success'] as bool,
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AuthSuccessResponseToJson(
        AuthSuccessResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

AuthErrorResponse _$AuthErrorResponseFromJson(Map<String, dynamic> json) =>
    AuthErrorResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 400,
    );

Map<String, dynamic> _$AuthErrorResponseToJson(AuthErrorResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'statusCode': instance.statusCode,
    };
