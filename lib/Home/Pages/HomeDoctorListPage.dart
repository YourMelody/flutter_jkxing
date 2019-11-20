import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_jkxing/Common/RefreshListView.dart';
import 'package:flutter_jkxing/Home/Model/AuthenticationDoctorModel.dart';
import 'package:flutter_jkxing/Home/Model/PendingAuthenticationModel.dart';
import 'package:flutter_jkxing/Home/Network/HomeRequest.dart';

enum DoctorStatus {
	Authentication,         // 已通过
	PendingAuthentication   // 待认证
}

class HomeDoctorListPage extends StatefulWidget {
	final DoctorStatus doctorStatus;
	HomeDoctorListPage(this.doctorStatus);
	@override
	State<StatefulWidget> createState() {
		return _HomeDoctorListPageState();
	}
}

class _HomeDoctorListPageState extends State<HomeDoctorListPage> with AutomaticKeepAliveClientMixin {
	List <AuthenticationDoctorModel> authDataSource = [];       // 已通过数据源
	List <PendingAuthenticationModel> pendingDataSource = [];   // 待认证数据源
	
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
			child: ListView.separated(
				itemBuilder: (context, index) => _createItem(index),
				itemCount: widget.doctorStatus == DoctorStatus.Authentication ?
					(authDataSource == null ? 0 : authDataSource.length) :
					(pendingDataSource == null ? 0 : pendingDataSource.length),
				separatorBuilder: (context, index) {
					return Container(height: 1, color: Color(0xffe5e5e5));
				},
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
			onLoad: () {
				if (widget.doctorStatus == DoctorStatus.PendingAuthentication) {
					return _initData();
				}
				return null;
			},
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
			
			},
			child: Container(
				height: 54,
				padding: EdgeInsets.symmetric(horizontal: 15),
				child: Row(
					children: <Widget>[
						// 医院名称
						Text(
							model?.hospitalName ?? '',
							style: TextStyle(fontSize: 16, color: Color(0xff0a1314)),
							maxLines: 1,
							overflow: TextOverflow.ellipsis
						),
						Padding(padding: EdgeInsets.only(right: 15)),
						// 医生个数
						Text(
							'${model?.doctorCount ?? 0}名'
						)
					],
				),
			),
		);
	}
	
	// 待认证的item
	Widget _createPendingItem(PendingAuthenticationModel model) {
		return null;
	}
	
	@override
	bool get wantKeepAlive => true;
}