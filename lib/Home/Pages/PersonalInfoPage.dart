import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Home/Model/PersonalInfoModel.dart';
import 'package:flutter_jkxing/Home/Network/HomeRequest.dart';

/*
* 医生统计->个人信息展示规则:
*   1、如果接口返回titleMatch为false，需要多展示一项（'职称不匹配'），内容由titleType控制
*       1.1、如果titleType为1，展示'注册认证时填写的职称'，且没有'>'，该项不能点击
*       1.2、如果titleType为2，展示'工作证/工牌上的职称'，且没有'>'，该项不能点击
*       1.3、其他情况，展示'请选择'，有'>'，点击弹框选择
*   2、auditShowStatus控制显示状态
*       1：去完善
*       2：审核中
*       3：审核不通过，请重新上传
*       4：已完善
* */

class PersonalInfoPage extends StatefulWidget {
	final int doctorId;
	PersonalInfoPage(this.doctorId);
	@override
	State<StatefulWidget> createState() {
		return _PersonalInfoState();
	}
}

class _PersonalInfoState extends State<PersonalInfoPage> {
	EmptyWidgetType type = EmptyWidgetType.Loading;
	PersonalInfoModel perInfoModel;
	
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	Future<void> _initData() async {
		PersonalInfoModel respModel = await HomeRequest.getPersonDataStatusInfo(widget.doctorId, context);
		if (respModel != null) {
			// 请求成功
			this.perInfoModel = respModel;
			if (this.perInfoModel?.list?.length == 0 && this.perInfoModel?.titleMatch == false) {
				type = EmptyWidgetType.NoData;
			} else {
				type = EmptyWidgetType.None;
			}
			this.setState(() {});
		} else {
			// 请求失败
			this.setState(() {
				type = EmptyWidgetType.NetError;
			});
		}
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'个人信息',
				context: context
			),
			body: RefreshListView(
				child: ListView.separated(
					itemBuilder: (context, index) {
						return _itemBuilder(perInfoModel, index);
					},
					separatorBuilder: (BuildContext context, int index) {
						return Divider(color: Color(0xffe5e5e5), height: 0.5);
					},
					itemCount: perInfoModel == null ? 0 : perInfoModel.titleMatch != true ?
					(perInfoModel.list.length + 1) : perInfoModel.list.length
				),
				showRefreshHeader: false,
				type: this.type
			),
			backgroundColor: Colors.white
		);
	}
	
	Widget _itemBuilder(PersonalInfoModel model, int index) {
		String conStr = '';
		Color conColor = Colors.white;
		if (index < model.list.length) {
			PersonInfoListItemModel itemModel;
			itemModel = model.list[index];
			if (itemModel.auditShowStatus == 1) {
				conStr = '去完善';
				conColor = Color(0xff6bcbd7);
			} else if (itemModel.auditShowStatus == 2) {
				conStr = '审核中';
				conColor = Color(0xffe56767);
			} else if (itemModel.auditShowStatus == 3) {
				conStr = '审核不通过，请重新上传';
				conColor = Color(0xffe56767);
			} else if (itemModel.auditShowStatus == 4) {
				conStr = '已完善';
				conColor = Color(0x660a1314);
			}
			
			if (itemModel.auditType == 7) {
				return _createItem('认证照片', conStr, conColor, index);
			} else if (itemModel.auditType == 4) {
				return _createItem('医师执业证', conStr, conColor, index);
			} else if (itemModel.auditType == 3) {
				return _createItem('工作证/工牌', conStr, conColor, index);
			} else {
				return Container();
			}
		} else {
			bool disArr = true;
			if (this.perInfoModel?.titleType == 1) {
				conStr = '注册认证时填写的职称';
				conColor = Color(0x660a1314);
			} else if (this.perInfoModel?.titleType == 2) {
				conStr = '工作证/工牌上的职称';
				conColor = Color(0x660a1314);
			} else {
				conStr = '请选择';
				conColor = Color(0xffe56767);
				disArr = false;
			}
			return _createItem('职称不匹配', conStr, conColor, index, dismissArrow: disArr);
		}
	}
	
	Widget _createItem(String titleStr, String contentStr, Color contentColor, int index, {bool dismissArrow = false}) {
		return GestureDetector(
			onTap: () {
				if (index == 0) {
					// 认证照片
					
				} else if (index ==1) {
					// 工作证/工牌
					
				} else if (index == 2) {
					// 医师执业证
					
				} else if (index == 3) {
					// 职称不匹配
					if (!dismissArrow) {
						// 弹框提示
						_showAlert();
					}
				}
			},
			child: Container(
				height: 54,
				alignment: Alignment.center,
				padding: EdgeInsets.symmetric(horizontal: 15),
				child: Row(
					children: <Widget>[
						Text(
							titleStr,
							style: TextStyle(fontSize: 16, color: Color(0xff0a1314))
						),
						Padding(padding: EdgeInsets.only(right: 10)),
						Expanded(child: Text(
							contentStr,
							style: TextStyle(fontSize: 14, color: contentColor),
							textAlign: TextAlign.right
						)),
						Offstage(
							offstage: dismissArrow,
							child: Image.asset('lib/Images/btn_doctor_more.png', width: 24, height: 24)
						)
					]
				),
				decoration: BoxDecoration(
					border: Border(bottom: BorderSide(
						color: Color(0xffe5e5e5),
						width: 0.5
					))
				)
			)
		);
	}
	
	void _showAlert() {
		showGeneralDialog(
			context: context,
			pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
				return GestureDetector(
					onTap: () {
						Navigator.of(context).pop();
					},
					child: Container(
						color: Color(0xb2000000),
						alignment: Alignment.center,
						child: Container(
							height: 225,
							alignment: Alignment.center,
							margin: EdgeInsets.symmetric(horizontal: 35),
							padding: EdgeInsets.fromLTRB(15, 18, 15, 0),
							decoration: BoxDecoration(
								color: Colors.white,
								borderRadius: BorderRadius.circular(5)
							),
							child: Column(children: <Widget>[
								Text(
									'请选择以哪个职称为准？',
									style: TextStyle(
										fontSize: 16,
										color: Color(0xbf0a1314),
										fontWeight: FontWeight.w500,
										decoration: TextDecoration.none
									)
								),
								Padding(padding: EdgeInsets.only(top: 18)),
								
								GestureDetector(
									onTap: () {
									
									},
									child: Container(
										decoration: BoxDecoration(
											color: Color(0xff6bcbd6),
											borderRadius: BorderRadius.circular(22)
										),
										height: 44,
										alignment: Alignment.center,
										child: Text(
											'注册认证时填写的职称',
											style: TextStyle(
												fontSize: 16,
												color: Colors.white,
												fontWeight: FontWeight.normal,
												decoration: TextDecoration.none
											)
										),
										margin: EdgeInsets.only(bottom: 16)
									)
								),
								
								GestureDetector(
									onTap: () {
									
									},
									child: Container(
										decoration: BoxDecoration(
											color: Colors.white,
											borderRadius: BorderRadius.circular(22),
											border: Border.all(
												color: Color(0xff6bcbd6),
												width: 1
											)
										),
										height: 44,
										alignment: Alignment.center,
										child: Text(
											'工作证/工牌上的职称',
											style: TextStyle(
												fontSize: 16,
												color: Color(0xff6bcbd6),
												fontWeight: FontWeight.normal,
												decoration: TextDecoration.none
											)
										),
										margin: EdgeInsets.only(bottom: 10)
									)
								),
								
								GestureDetector(
									onTap: () {
										Navigator.of(context).pop();
									},
									child: Container(
										color: Colors.white,
										height: 44,
										alignment: Alignment.center,
										child: Text(
											'取消',
											style: TextStyle(
												fontSize: 16,
												color: Color(0x66000000),
												fontWeight: FontWeight.normal,
												decoration: TextDecoration.none
											)
										)
									)
								)
							])
						)
					)
				);
			},
			barrierDismissible: true,
			barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
			transitionDuration: const Duration(milliseconds: 150),
			transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
				return FadeTransition(
					opacity: CurvedAnimation(
						parent: animation,
						curve: Curves.easeOut
					),
					child: child
				);
			}
		);
	}
}