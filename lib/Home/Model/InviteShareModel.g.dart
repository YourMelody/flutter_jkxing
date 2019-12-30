// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InviteShareModel.dart';

InviteShareModel _$InviteShareModelFromJson(Map<String, dynamic> json) {
	return InviteShareModel(
		json['headImg'] as String,
		json['shareUrl'] as String,
		json['title'] as String,
		json['content'] as String
	);
}

Map<String, dynamic> _$InviteShareModelToJson(InviteShareModel instance) =>
	<String, dynamic>{
		'headImg': instance.headImg,
		'shareUrl': instance.shareUrl,
		'title': instance.title,
		'content': instance.content
	};
