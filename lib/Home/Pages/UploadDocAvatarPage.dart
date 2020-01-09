import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Home/Network/HomeRequest.dart';

import 'ESImageViewPage.dart';

class UploadDocAvatarPage extends StatefulWidget {
	final int doctorId;
	final int auditShowStatus;
	final int auditType;
	UploadDocAvatarPage(this.doctorId, this.auditShowStatus, this.auditType);
	@override
	State<StatefulWidget> createState() {
		return _UploadDocAvatarState();
	}
}

class _UploadDocAvatarState extends State<UploadDocAvatarPage> {
	String imgUrl;
	bool hasAvatar;
	
	@override
	void initState() {
		super.initState();
		hasAvatar = widget.auditShowStatus == 4 || widget.auditShowStatus == 2;
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	void _initData() {
		HomeRequest.getDocAvatarReq(widget.doctorId, widget.auditType, context).then((response) {
			if (response != null) {
				String respStr = response['url'];
				if (respStr != null && respStr.length > 0) {
					this.setState(() {
						imgUrl = respStr;
					});
				}
			}
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'认证照片',
				context: context,
				rightBarBtn: !this.hasAvatar ?
					Container(
						height: 44,
						padding: EdgeInsets.only(left: 10),
						alignment: Alignment.center,
						child: Text('提交审核', style: TextStyle(fontSize: 16, color: Color(0xff0a1314)))
					) : null,
				rightBarBtnAction: () {
					if (!this.hasAvatar) {
					
					}
				}
			),
			body: _createBody(),
			backgroundColor: Color(0xfff4f6f9)
		);
	}
	
	Widget _createBody() {
		double deviceW = MediaQuery.of(context).size.width;
		return Container(
			height: 148,
			color: Colors.white,
			alignment: Alignment.center,
			child: Stack(
				alignment: Alignment.center,
				children: <Widget>[
					Container(width: double.infinity),
					// 头像
					GestureDetector(
						onTap: () {
							if (this.hasAvatar) {
								if (this.imgUrl != null && this.imgUrl.length > 0) {
									// 全屏查看头像
									_showAvatarDialog();
								}
							} else {
								// 拍照、选择照片
								_showSelectImageDialog();
							}
						},
						child: ClipRRect(
							borderRadius: BorderRadius.circular(49),
							child: Stack(children: <Widget>[
								FadeInImage.assetNetwork(
									placeholder: 'lib/Images/doctor_upload_default.png',
									image: this.imgUrl ?? '',
									width: 98,
									height: 98,
									fit: BoxFit.cover,
									fadeOutDuration: Duration(milliseconds: 20),
									fadeInDuration: Duration(milliseconds: 20)
								),
								
								Positioned(
									bottom: 0,
									child: Offstage(
										offstage: this.hasAvatar,
										child: Container(
											width: 98,
											height: 32,
											color: Color(0x66000000),
											padding: EdgeInsets.only(top: 2),
											alignment: Alignment.topCenter,
											child: Text(
												'上传头像',
												style: TextStyle(fontSize: 15, color: Colors.white)
											)
										)
									)
								)
							])
						)
					),
					
					// 删除头像
					Positioned(
						top: 25,
						right: deviceW / 2 - 50,
						child: Offstage(
							offstage: this.hasAvatar,
							child: GestureDetector(
								onTap: () {
								
								},
								child: Image.asset(
									'lib/Images/certification_avator_x.png',
									width: 25,
									height: 24
								)
							)
						)
					),
					
					
					// 半身白大褂
					Positioned(
						top: 78,
						left: deviceW / 2 + 47,
						child: Row(children: <Widget>[
							Container(
								width: 39,
								height: 1,
								color: Color(0xff5cc1cc)
							),
							Container(
								width: 6,
								height: 6,
								margin: EdgeInsets.only(right: 5),
								decoration: BoxDecoration(
									color: Color(0xff5cc1cc),
									borderRadius: BorderRadius.circular(3)
								)
							),
							Text(
								'半身白大褂',
								style: TextStyle(fontSize: 13, color: Color(0xff1a1a1a))
							)
						])
					),
					
					
					// 真人正脸
					Positioned(
						top: 24,
						right: deviceW / 2 + 48,
						child: Column(children: <Widget>[
							Text(
								'真人正脸',
								style: TextStyle(fontSize: 13, color: Color(0xff444444))
							),
							Padding(padding: EdgeInsets.only(bottom: 3)),
							Container(
								width: 6,
								height: 6,
								margin: EdgeInsets.only(right: 5),
								decoration: BoxDecoration(
									color: Color(0xff5cc1cc),
									borderRadius: BorderRadius.circular(3)
								)
							),
							CustomPaint(
								foregroundPainter: MyPainter()
							),
							Container(
								width: 40,
								height: 1,
								color: Color(0xff5cc1cc),
								margin: EdgeInsets.only(top: 13, left: 50),
							)
						])
					)
				]
			)
		);
	}
	
	void _showAvatarDialog() {
		Navigator.of(context).push(PageRouteBuilder(
			opaque: false,
			pageBuilder: (BuildContext context, Animation animation,
				Animation secondaryAnimation) =>
				FadeTransition(
					//使用渐隐渐入过渡,
					opacity: animation,
					child: ESImageViewPage(this.imgUrl)
				)
			)
		);
	}
	
	void _showSelectImageDialog() {
		showModalBottomSheet(
			context: context,
			backgroundColor: Color(0xff5d5e5f),
			builder: (BuildContext context) {
				return Container(
					height: 200 + PPSession.getInstance().paddingBottom,
					padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
					color: Color(0xff6f7473),
					child: Column(children: <Widget>[
						GestureDetector(
							onTap: () {
							
							},
							child: Container(
								height: 58,
								alignment: Alignment.center,
								decoration: BoxDecoration(
									borderRadius: BorderRadius.only(
										topLeft: Radius.circular(13),
										topRight: Radius.circular(13)
									),
									color: Colors.white
								),
								child: Text(
									'从相册选择',
									style: TextStyle(fontSize: 20, color: Color(0xff0a1314))
								)
							)
						),
						Container(height: 1, color: Color(0xffe5e5e5)),
						
						GestureDetector(
							onTap: () {
							
							},
							child: Container(
								height: 58,
								alignment: Alignment.center,
								margin: EdgeInsets.only(bottom: 8),
								decoration: BoxDecoration(
									borderRadius: BorderRadius.only(
										bottomLeft: Radius.circular(13),
										bottomRight: Radius.circular(13)
									),
									color: Colors.white
								),
								child: Text(
									'拍摄',
									style: TextStyle(fontSize: 20, color: Color(0xff0a1314))
								),
							)
						),
						
						GestureDetector(
							onTap: () {
								Navigator.of(context).pop();
							},
							child: Container(
								height: 58,
								alignment: Alignment.center,
								decoration: BoxDecoration(
									borderRadius: BorderRadius.circular(13),
									color: Colors.white
								),
								child: Text(
									'取消',
									style: TextStyle(fontSize: 20, color: Color(0xff0a1314))
								),
							)
						)
					])
				);
			}
		);
	}
}

class MyPainter extends CustomPainter {
	@override
	void paint(Canvas canvas, Size size) {
		Paint _paint = new Paint()
			..color = Color(0xff5cc1cc)
			..strokeCap = StrokeCap.square
			..isAntiAlias = true
			..strokeWidth = 1
			..style = PaintingStyle.stroke;
		canvas.drawLine(Offset(-1.5, 0.0), Offset(5, 13), _paint);
	}
	
	@override
	bool shouldRepaint(CustomPainter oldDelegate) => false;
}