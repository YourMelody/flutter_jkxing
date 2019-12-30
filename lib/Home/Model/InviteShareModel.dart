import 'package:json_annotation/json_annotation.dart';

part "InviteShareModel.g.dart";

@JsonSerializable()

class InviteShareModel {
	
	InviteShareModel(this.headImg, this.shareUrl, this.title, this.content);
	
	String headImg;
	String shareUrl;
	String title;
	String content;
	
	factory InviteShareModel.fromJson(Map<String, dynamic> json) => _$InviteShareModelFromJson(json);
	Map<String, dynamic> toJson() => _$InviteShareModelToJson(this);
}