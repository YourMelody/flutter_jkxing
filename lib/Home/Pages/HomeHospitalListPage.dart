import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_jkxing/Home/Model/AuthenticationDoctorModel.dart';
import 'package:flutter_jkxing/Home/Model/PendingAuthenticationModel.dart';
import 'package:flutter_jkxing/Home/Network/HomeRequest.dart';
import 'package:flutter_jkxing/Home/Pages/DoctorListOfHospitalPage.dart';

enum DoctorStatus {
	Authentication,         // 已通过
	PendingAuthentication   // 待认证
}

class HomeHospitalListPage extends StatefulWidget {
	final DoctorStatus doctorStatus;
	HomeHospitalListPage(this.doctorStatus);
	@override
	State<StatefulWidget> createState() {
		return _HomeHospitalListState();
	}
}

class _HomeHospitalListState extends State<HomeHospitalListPage> with AutomaticKeepAliveClientMixin {
	List <AuthenticationDoctorModel> authDataSource = [];       // 已通过数据源，不分页
	List <PendingAuthenticationModel> pendingDataSource = [];   // 待认证数据源，分页
	
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
		if (widget.doctorStatus == DoctorStatus.Authentication) {
			// 已通过
			List response = await HomeRequest.getAuthenDoctorList(context);
			if (response != null) {
				this.controller.finishRefresh(success: true);
				this.setState(() {
					this.authDataSource = response;
					type = response.length == 0 ? EmptyWidgetType.NoData : EmptyWidgetType.None;
				});
			} else {
				this.controller.finishRefresh(success: false);
				if (this.authDataSource == null || this.authDataSource.length == 0) {
					this.setState(() {
						type = EmptyWidgetType.NetError;
					});
				} else {
					this.setState(() {
						type = EmptyWidgetType.None;
					});
				}
			}
		} else {
			// 待认证
			var response = await HomeRequest.getPendingAuthenDoctorList(context, this.currentPage);
			if (response != null) {
				if (this.currentPage == 1) {
					this.pendingDataSource = response;
				} else {
					this.pendingDataSource.addAll(response);
				}
				List tempArr = response;
				if (tempArr.length < 10) {
					this.controller.finishLoad(noMore: true);
				} else {
					this.controller.finishLoad(success: true);
				}
				this.controller.finishRefresh(success: true);
				this.setState(() {
					type = this.pendingDataSource.length == 0 ? EmptyWidgetType.NoData : EmptyWidgetType.None;
				});
				this.currentPage++;
			} else {
				this.controller.finishRefresh(success: false);
				this.controller.finishLoad(success: false);
				if (this.pendingDataSource == null || this.pendingDataSource.length == 0) {
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
	}
	
	@override
	Widget build(BuildContext context) {
		super.build(context);
		return RefreshListView(
			controller: this.controller,
			child: ListView.builder(
				itemBuilder: (context, index) => _createItem(index),
				itemCount: widget.doctorStatus == DoctorStatus.Authentication ?
					(authDataSource == null ? 0 : authDataSource.length) :
					(pendingDataSource == null ? 0 : pendingDataSource.length)
			),
			onRefresh: () {
				if (widget.doctorStatus == DoctorStatus.PendingAuthentication) {
					this.currentPage = 1;
				}
				
				if (type == EmptyWidgetType.NetError) {
					setState(() {
						type = EmptyWidgetType.Loading;
					});
				}
				return _initData();
			},
			onLoad: widget.doctorStatus == DoctorStatus.PendingAuthentication ? () {
				return _initData();
			} : null,
			type: this.type
		);
	}
	
	Widget _createItem(int index) {
		if (widget.doctorStatus == DoctorStatus.Authentication) {
			// 已通过item
			AuthenticationDoctorModel model = this.authDataSource[index];
			return _createAuthItem(model);
		} else {
			// 待认证
			PendingAuthenticationModel model = this.pendingDataSource[index];
			return _createPendingItem(model);
		}
	}
	
	
	// 已通过的item
	Widget _createAuthItem(AuthenticationDoctorModel model) {
		return GestureDetector(
			onTap: () {
				Navigator.of(context).push(MaterialPageRoute(
					builder: (_) => DoctorListOfHospitalPage(doctorModel: model)
				));
			},
			child: Container(
				height: 54,
				padding: EdgeInsets.symmetric(horizontal: 15),
				decoration: BoxDecoration(
					border: Border(bottom: BorderSide(color: Color(0xffe5e5e5), width: 0.5))
				),
				child: Row(
					children: <Widget>[
						// 医院名称
						Expanded(child: Text(
							model?.hospitalName ?? '',
							style: TextStyle(fontSize: 16, color: Color(0xff0a1314)),
							maxLines: 1,
							overflow: TextOverflow.ellipsis
						)),
						Padding(padding: EdgeInsets.only(right: 15)),
						
						// 医生个数
						Text(
							'${model?.doctorCount ?? 0}名'
						),
						Image.asset('lib/Images/btn_arrow.png', width: 18, height: 18)
					],
				),
			),
		);
	}
	
	// 待认证的item
	Widget _createPendingItem(PendingAuthenticationModel model) {
		return GestureDetector(
			onTap: () {
			
			},
			child: model.userStatus == 1 ? _phoneCell(model) : _infoCell(model)
		);
	}
	
	// 待认证，userStatus为1，只展示手机号
	Widget _phoneCell(PendingAuthenticationModel model) {
		return Container(
			height: 54,
			padding: EdgeInsets.only(left: 15, right: 33),
			alignment: Alignment.center,
			decoration: BoxDecoration(
				border: Border(bottom: BorderSide(color: Color(0xffe5e5e5), width: 0.5))
			),
			child: Row(
				children: <Widget>[
					Expanded(child: Text(
						_getSecretPhoneNum(model.userPhone),
						style: TextStyle(fontSize: 18, color: Color(0xbf0a1314)),
					)),
					Text('未认证', style: TextStyle(fontSize: 14, color: Color(0xfff5a623)))
				],
			),
		);
	}
	
	String _getSecretPhoneNum(String phoneNum) {
		if (phoneNum == null || phoneNum.length == 0) {
			return '';
		} else if (phoneNum.length > 7) {
			return phoneNum.replaceRange(3, 7, '****');
		}
		return phoneNum;
	}
	
	// 待认证，userStatus不为1，展示医生信息
	Widget _infoCell(PendingAuthenticationModel model) {
		return Container(
			height: 66,
			padding: EdgeInsets.symmetric(horizontal: 15),
			decoration: BoxDecoration(
				border: Border(bottom: BorderSide(color: Color(0xffe5e5e5), width: 0.5))
			),
			child: Row(
				children: <Widget>[
					Expanded(
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								RichText(text: TextSpan(
									text: model?.realName ?? '',
									style: TextStyle(fontSize: 18, color: Color(0xbf0a1314), fontWeight: FontWeight.w500),
									children: <TextSpan>[
										TextSpan(
											text: model?.departmentName != null && model.departmentName.length > 0 ?
												'      ${model.departmentName}' : '',
											style: TextStyle(fontSize: 14, color: Color(0xbf0a1314))
										),
										TextSpan(
											text: model?.doctorTitle != null && model.doctorTitle.length > 0 ?
												'      ${model.doctorTitle}' : '',
											style: TextStyle(fontSize: 14, color: Color(0xbf0a1314))
										)
									]
								), maxLines: 1, overflow: TextOverflow.ellipsis),
								
								Padding(padding: EdgeInsets.only(bottom: 2)),
								
								Text(
									model?.hospitalName ?? '',
									style: TextStyle(fontSize: 14, color: Color(0xbf0a1314)),
									maxLines: 1,
									overflow: TextOverflow.ellipsis
								)
							]
						)
					),
					Padding(padding: EdgeInsets.only(right: 15)),
					
					// 状态标签
					_getStatusLabel(model),
					
					Image.asset('lib/Images/btn_arrow.png', width: 18, height: 18)
				]
			)
		);
	}
	
	Widget _getStatusLabel(PendingAuthenticationModel model) {
		if (model.userStatus == 1) {
			return Text('未认证', style: TextStyle(fontSize: 14, color: Color(0xfff5a623)));
		} else if (model.userStatus == 2) {
			return Text('审核中', style: TextStyle(fontSize: 14, color: Color(0x660a1314)));
		} else if (model.userStatus == 3) {
			// 认证通过，需要判断资料是否完整
			if (model.dataAuditStatus == 1) {
				// 我要达标
				return Text('我要达标', style: TextStyle(fontSize: 14, color: Color(0xffe55e5e)));
			} else if (model.dataAuditStatus == 2) {
				return Text('去完善', style: TextStyle(fontSize: 14, color: Color(0xff6bcbd6)));
			} else {
				return Text('');
			}
		} else if (model.userStatus == 7) {
			return Text('去认证', style: TextStyle(fontSize: 14, color: Color(0xfff56262)));
		} else {
			return Text('');
		}
	}
	
	@override
	bool get wantKeepAlive => true;
}