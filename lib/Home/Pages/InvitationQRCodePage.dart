import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Common/ZFShareAlertView.dart';
import 'package:flutter_jkxing/Home/Model/DoctorInfoOfHospitalModel.dart';
import 'package:flutter_jkxing/Home/Network/HomeRequest.dart';
import 'package:flutter_jkxing/Home/Model/InviteShareModel.dart';
import 'package:flutter_jkxing/Utils/Util.dart';

// 医生统计->查看医生专属二维码
class InvitationQRCodePage extends StatefulWidget {
	final DoctorInfoOfHospitalModel doctorModel;
	InvitationQRCodePage(this.doctorModel);
	@override
	State<StatefulWidget> createState() {
		return _InvitationQRCodeState();
	}
}

class _InvitationQRCodeState extends State<InvitationQRCodePage> {
	String investCodeImage;
	InviteShareModel shareModel;
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	Future<void> _initData() async {
		Map response = await HomeRequest.getInvitationQRCodeReq(context, widget?.doctorModel?.userId ?? '');
		if (response != null && response['investCodeImage'] != null) {
			this.setState(() {
				this.investCodeImage = response['investCodeImage'];
			});
		}
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'邀请患者二维码',
				rightBarBtn: Container(
					height: 44,
					alignment: Alignment.centerRight,
					padding: EdgeInsets.only(left: 15),
					child: Image.asset(
						'lib/Images/doctor_qr_share.png',
						width: 24, height: 24
					),
				),
				rightBarBtnAction: () => _clickShareBtn(),
				context: context
			),
			backgroundColor: Color(0xff2d2c31),
			body: Container(
				padding: EdgeInsets.fromLTRB(37, 90, 37, 0),
				child: Column(children: <Widget>[
					Container(
						decoration: BoxDecoration(
							color: Colors.white,
							borderRadius: BorderRadius.circular(4)
						),
						padding: EdgeInsets.fromLTRB(25, 27, 25, 10),
						child: Column(children: <Widget>[
							Text(
								widget?.doctorModel?.realName ?? '',
								style: TextStyle(fontSize: 24, color: Color(0xff0a1314)),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							),
							Padding(padding: EdgeInsets.only(top: 11)),
							Text(
								'${widget?.doctorModel?.departmentName ?? ''}${widget?.doctorModel?.departmentName != null && widget.doctorModel.departmentName.length != 0 ? '  ' : ''}${widget?.doctorModel?.doctorTitle ?? ''}',
								style: TextStyle(fontSize: 14, color: Color(0xcc0a1314)),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							),
							Padding(padding: EdgeInsets.only(top: 4)),
							Text(
								widget?.doctorModel?.hospitalName ?? '',
								style: TextStyle(fontSize: 14, color: Color(0x660a1314)),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							),
							Container(
								alignment: Alignment.center,
								padding: EdgeInsets.only(top: 8),
								child: FadeInImage.assetNetwork(
									placeholder: 'lib/Images/img_invite_n0_network.png',
									image: this?.investCodeImage ?? '',
									width: 250 / 667 * MediaQuery.of(context).size.height,
									height: 250 / 667 * MediaQuery.of(context).size.height,
									fit: BoxFit.cover,
									fadeOutDuration: Duration(milliseconds: 20),
									fadeInDuration: Duration(milliseconds: 20)
								)
							)
						])
					),
					
					Padding(padding: EdgeInsets.only(top: 40)),
					
					GestureDetector(
						onTap: () {
							
						},
						child: Container(
							width: 152, height: 36,
							alignment: Alignment.center,
							decoration: BoxDecoration(
								color: Color(0xff6bcbd7),
								borderRadius: BorderRadius.circular(18)
							),
							child: Text(
								'保存到本地',
								style: TextStyle(fontSize: 14, color: Colors.white)
							)
						)
					),
					
					Expanded(child: Container())
				])
			)
		);
	}
	
	void _clickShareBtn() {
		// 请求获取分享信息
		if (this?.shareModel?.shareUrl == null) {
			HomeRequest.getShareInfoReq(context, widget?.doctorModel?.userId ?? '').then((response) {
				if (response != null) {
					this.setState(() {
						shareModel = response;
					});
					Util().showMyGeneralDialog(context, ZFShareAlertView());
				}
			});
		} else {
			Util().showMyGeneralDialog(context, ZFShareAlertView());
		}
	}
}