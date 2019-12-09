import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Common/ZFSearchBar.dart';
import 'package:flutter_jkxing/Home/Model/DoctorInfoOfHospitalModel.dart';
import 'package:flutter_jkxing/Home/Network/HomeRequest.dart';
import 'package:flutter_jkxing/Home/Model/AuthenticationDoctorModel.dart';
import 'package:flutter_jkxing/Home/Pages/DoctorStatisticPage.dart';

class DoctorListOfHospitalPage extends StatefulWidget {
	final String agentName;
	final String agentId;
	final AuthenticationDoctorModel doctorModel;
	final bool showSearch;
	DoctorListOfHospitalPage({this.agentName, this.agentId, this.doctorModel, this.showSearch = false});
	@override
	State<StatefulWidget> createState() {
		return _DoctorListOfHospitalState();
	}
}

class _DoctorListOfHospitalState extends State<DoctorListOfHospitalPage> {
	
	List<DoctorInfoOfHospitalModel> dataSource = [];
	int currentPage = 1;
	EasyRefreshController controller = EasyRefreshController();
	EmptyWidgetType type = EmptyWidgetType.Loading;
	
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	Future<void> _initData() async {
		List response = await HomeRequest.getDoctorListOfHospital(context, widget.doctorModel.hospitalId, PPSession.getInstance().userId, this.currentPage);
		if (response != null) {
			this.controller.finishRefresh(success: true);
			if (response.length < 20) {
				this.controller.finishLoad(noMore: true);
			} else {
				this.controller.finishLoad(success: true);
			}
			this.setState(() {
				this.dataSource = response;
				type = response.length == 0 ? EmptyWidgetType.NoData : EmptyWidgetType.None;
			});
		} else {
			this.controller.finishRefresh(success: false);
			this.controller.finishLoad(success: false);
			if (this.dataSource == null || this.dataSource.length == 0) {
				this.setState(() {
					type = EmptyWidgetType.NetError;
				});
			} else {
				this.setState(() {
					type = EmptyWidgetType.None;
				});
			}
		}
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				widget.agentName != null && widget.agentName.length > 0 ?
				'${widget.agentName}的医生' : '我的医生',
				rightBarBtn: widget.showSearch ? Icon(Icons.search, size: 24, color: Color(0xff6bcbd6)) : null,
				rightBarBtnAction: () {
					// 搜索
					
				},
				context: context
			),
			body: Column(
				children: <Widget>[
					// 搜索框
					ZFSearchBar(
						placeholder: '医院名称/医生姓名',
						paddingH: 15,
						paddingV: 7,
						height: 44,
						showSearchIcon: false,
						onTapSearchBar: () {
						
						}
					),
					
					// 医院名称
					_createListHeader(),
					
					// 医生列表
					Expanded(child: RefreshListView(
						controller: this.controller,
						child: ListView.builder(
							itemBuilder: (context, index) => _createItem(this.dataSource[index]),
							itemCount: this.dataSource.length
						),
						onRefresh: () {
							this.currentPage = 1;
							if (type == EmptyWidgetType.NetError) {
								setState(() {
									type = EmptyWidgetType.Loading;
								});
							}
							return _initData();
						},
						onLoad: () {
							return _initData();
						},
						type: this.type
					))
				]
			),
			backgroundColor: Colors.white
		);
	}
	
	Widget _createListHeader() {
		return Container(
			height: 44,
			padding: EdgeInsets.fromLTRB(15, 12, 15, 0),
			child: Row(children: <Widget>[
				Expanded(child: Text(
					widget.doctorModel?.hospitalName ?? '',
					style: TextStyle(fontSize: 18, color: Color(0xff0a1314), fontWeight: FontWeight.w500),
					maxLines: 1,
					overflow: TextOverflow.ellipsis
				)),
				Padding(padding: EdgeInsets.only(left: 10)),
				Text(
					widget.doctorModel?.doctorCount != null ? '${widget.doctorModel.doctorCount.toString()}名' : '0名',
					style: TextStyle(fontSize: 14, color: Color(0x660a1314)),
					maxLines: 1,
					overflow: TextOverflow.ellipsis
				)
			])
		);
	}
	
	Widget _createItem(DoctorInfoOfHospitalModel model) {
		return GestureDetector(
			onTap: () {
				int userStatus = model.userStatus;
				if (userStatus == 1) {
					// 未认证不能跳转
					
				} else if (userStatus == 2) {
					// 待审核,跳转审核中界面
					
				} else if (userStatus == 3) {
					// 已通过,跳转医生统计界面
					Navigator.of(context).push(MaterialPageRoute(
						builder: (_) => DoctorStatisticPage(model)
					));
				} else if (userStatus == 7) {
					// 提交基础信息,跳转去认证界面
					
				}
			},
			child: Container(
				height: 80,
				alignment: Alignment.center,
				padding: EdgeInsets.fromLTRB(0, 16, 9, 16),
				margin: EdgeInsets.only(left: 15),
				decoration: BoxDecoration(
					border: Border(bottom: BorderSide(color: Color(0xffe5e5e5), width: 0.5))
				),
				child: Row(children: <Widget>[
					// 头像
					ClipRRect(
						child: FadeInImage.assetNetwork(
							placeholder: 'lib/Images/hospital_avatar_default.png',
							image: model?.headImgShowPath ?? '',
							height: 48,
							width: 48,
							fit: BoxFit.fitHeight,
							fadeOutDuration: Duration(milliseconds: 50),
							fadeInDuration: Duration(milliseconds: 50)
						),
						borderRadius: BorderRadius.circular(24)
					),
					Padding(padding: EdgeInsets.only(right: 10)),
					Expanded(child: Column(
						children: <Widget>[
							// 医生姓名
							Text(
								model?.realName ?? '',
								style: TextStyle(fontSize: 18, color: model.addNew == true ? Color(0xffe55e5e) : Color(0xff0a1314), fontWeight: FontWeight.w500),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							),
							Padding(padding: EdgeInsets.only(bottom: 1)),
							// 科室和职称
							Text(
								'${model?.departmentName ?? ''}${model.departmentName != null && model.departmentName.length > 0 ? '  ' : ''}${model?.doctorTitle ?? ''}',
								style: TextStyle(fontSize: 14, color: Color(0xff4d4d4d)),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							)
						],
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.start
					)),
					Padding(padding: EdgeInsets.only(right: 10)),
					// 状态
					_createStatusLabel(model),
					Image.asset('lib/Images/btn_doctor_more.png', width: 24, height: 24)
				])
			)
		);
	}
	
	// 状态
	Widget _createStatusLabel(DoctorInfoOfHospitalModel model) {
		String statusLabel = '';
		TextStyle statusStyle;
		int userStatus = model.userStatus;
		if (userStatus == 1) {
			statusLabel = '未认证';
			statusStyle = TextStyle(color: Color(0xfff5a623), fontSize: 14);
		} else if (userStatus == 2) {
			statusLabel = '审核中';
			statusStyle = TextStyle(color: Color(0x66f5a623), fontSize: 14);
		} else if (userStatus == 3) {
			if (model.dataAuditStatus == 1) {
				statusLabel = '我要达标';
				statusStyle = TextStyle(color: Color(0xffe55e5e), fontSize: 14);
			} else if (model.dataAuditStatus == 2) {
				statusLabel = '去完善';
				statusStyle = TextStyle(color: Color(0xff6bcbd6), fontSize: 14);
			}
		} else if (userStatus == 7) {
			statusLabel = '去认证';
			statusStyle = TextStyle(color: Color(0xfff56262), fontSize: 14);
		}
		return Text(
			statusLabel ?? '',
			style: statusStyle
		);
	}
}