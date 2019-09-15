// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    json['realName'] as String,
    json['userPhone'] as String,
    json['userId'] as int,
    json['medicalCompany'] as String,
    json['regionName'] as String,
    json['investCodeImage'] as String,
    json['agentLevel'] as int,
    json['agentType'] as int,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'realName': instance.realName,
      'userPhone': instance.userPhone,
      'userId': instance.userId,
      'medicalCompany': instance.medicalCompany,
      'regionName': instance.regionName,
      'investCodeImage': instance.investCodeImage,
      'agentType': instance.agentType,
      'agentLevel': instance.agentLevel,
    };
