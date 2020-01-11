import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/ZFAppBar.dart';
import 'package:flutter_jkxing/Home/Model/DoctorInfoOfHospitalModel.dart';
import 'package:flutter_jkxing/Home/Network/HomeRequest.dart';
import 'package:flutter_jkxing/Utils/Util.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_jkxing/Home/Model/DoctorStatisticModel.dart';
import 'InvitationQRCodePage.dart';
import 'package:flutter_jkxing/Order/Pages/OrderContentPage.dart';

import 'PersonalInfoPage.dart';

// 首页->已通过列表->我的医生->医生统计
// 我的->医生统计
class DoctorStatisticPage extends StatefulWidget {
	final DoctorInfoOfHospitalModel doctorModel;
	DoctorStatisticPage(this.doctorModel);
	@override
	State<StatefulWidget> createState() {
		return _DoctorStatisticState();
	}
}

class _DoctorStatisticState extends State<DoctorStatisticPage> {
	int startTime;    // 默认为当月开始时间
	String startTimeStr;
	
	int endTime;      // 默认为当前时间
	String endTimeStr;
	int selectedIndex = 0;  // 今日：0   近7日：1   近30日：2  其他：null
	
	DoctorStatisticModel statisticModel;
	
	@override
	void initState() {
		super.initState();
		var now = DateTime.now();
		this.startTime = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
		this.startTimeStr = '${now.year}${_addZero(now.month)}${_addZero(now.day)}';
		this.endTime = now.millisecondsSinceEpoch;
		this.endTimeStr = '${now.year}${_addZero(now.month)}${_addZero(now.day)}';
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_initData();
		});
	}
	
	Future<void> _initData() async {
		this.statisticModel = await HomeRequest.getDoctorStatisticRequest(context, this.startTime, this.endTime, widget.doctorModel.userId.toString());
		this.setState(() {});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: ZFAppBar(
				'医生统计', 
				context: context,
				rightBarBtn: Row(children: <Widget>[
					Text('联系医生', style: TextStyle(fontSize: 14, color: Color(0xff6bcbd6))),
					Padding(padding: EdgeInsets.only(right: 5)),
					Image.asset(
						'lib/Images/btn_phone.png',
						width: 21, height: 21
					)
				]),
				rightBarBtnAction: () {
					// 拨打电话
					
				}
			),
			body: ListView.builder(
				itemBuilder: (context, index) => _createItem(index),
				itemCount: 12
			)
		);
	}
	
	Widget _createItem(int index) {
		if (index == 0) {
			// 头部医生信息
			return _createDoctorHeaderItem(widget.doctorModel);
		} else if (index == 1) {
			// 时间选择
			return _createTimeHeader();
		} else if (index == 2) {
			// 入驻天数
			return _createDaysItem();
		} else if (index == 3) {
			return _createListHeaderItem();
		} else if (index == 4) {
			return _createCommonItem('问诊数', this.statisticModel?.askNum, index);
		} else if (index == 5) {
			return _createCommonItem('接诊数', this.statisticModel?.visitNum, index);
		} else if (index == 6) {
			return _createCommonItem('回访数', this.statisticModel?.returnNum, index);
		} else if (index == 7) {
			return _createCommonItem('处方发送数', this.statisticModel?.sendNum, index);
		} else if (index == 8) {
			return _createCommonItem('处方支付数', this.statisticModel?.payNum, index);
		} else if (index == 9) {
			return _createCommonItem('扫码患者', this.statisticModel?.patientNum, index);
		} else if (index == 10) {
			return _createCommonItem('支付金额', this.statisticModel?.payMoney, index);
		} else if (index == 11) {
			return _createBottomBtn();
		}
		return null;
	}
	
	// 头部医生相关信息
	Widget _createDoctorHeaderItem(DoctorInfoOfHospitalModel model) {
		return GestureDetector(
			onTap: () {
				Navigator.of(context).push(MaterialPageRoute(
					builder: (_) => PersonalInfoPage(model.userId)
				));
			},
			child: Container(
				padding: EdgeInsets.all(15),
				child: Row(children: <Widget>[
					// 医生头像
					ClipRRect(
						child: CachedNetworkImage(
							imageUrl: this.statisticModel?.headImgShowPath ?? '',
							placeholder: (context, url) => Image.asset(
								'lib/Images/hospital_avatar_default.png',
								width: 64,
								height: 64,
								fit: BoxFit.cover
							),
							width: 64,
							height: 64,
							fit: BoxFit.cover,
							fadeInDuration: Duration(milliseconds: 50),
							fadeOutDuration: Duration(milliseconds: 50)
						),
						borderRadius: BorderRadius.circular(32)
					),
					Padding(padding: EdgeInsets.only(right: 10)),
					Expanded(child: Column(
						children: <Widget>[
							// 医生姓名
							Text(
								widget.doctorModel.realName ?? '',
								style: TextStyle(fontSize: 18, color: Color(0xff4d4d4d), fontWeight: FontWeight.w500),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							),
							Padding(padding: EdgeInsets.only(bottom: 2)),
							// 科室和职称
							Text(
								'${model?.departmentName ?? ''}${model.departmentName != null && model.departmentName.length > 0 ? '  ' : ''}${model?.doctorTitle ?? ''}',
								style: TextStyle(fontSize: 14, color: Color(0xff4d4d4d)),
								maxLines: 1,
								overflow: TextOverflow.ellipsis
							),
							
							// 医生所在医院
							Text(
								model.hospitalName ?? '',
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
	
	// 时间选择
	Widget _createTimeHeader() {
		return Container(
			padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
			margin: EdgeInsets.only(bottom: 14),
			decoration: BoxDecoration(
				border: Border(
					bottom: BorderSide(
						width: 0.5,
						color: Color(0xffe5e5e5)
					),
					top: BorderSide(
						width: 0.5,
						color: Color(0xffe5e5e5)
					)
				)
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					// 当月、上个月、近3个月
					Row(children: <Widget>[
						_createDateButton('今日', this.selectedIndex == 0, 0),
						Padding(padding: EdgeInsets.only(right: 15)),
						_createDateButton('近7日', this.selectedIndex == 1, 1),
						Padding(padding: EdgeInsets.only(right: 15)),
						_createDateButton('近30日', this.selectedIndex == 2, 2)
					]),
					
					Padding(padding: EdgeInsets.only(bottom: 16)),
					
					// 自定义日期
					Row(children: <Widget>[
						_createDateButton(this.startTimeStr, false, 3, customDate: true),
						Container(
							width: 15,
							alignment: Alignment.center,
							child: Text('~', style: TextStyle(fontSize: 14, color: Color(0xff999999)))
						),
						_createDateButton(this.endTimeStr, false, 4, customDate: true),
						Padding(padding: EdgeInsets.only(right: 15)),
						_createDateButton('确定', true, 5)
					])
				]
			)
		);
	}
	
	/*
	* title: button的标题
	* selected：是否选中
	* index：0：当月  1：上个月  2：近3个月  3：自定义开始时间  4：自定义结束时间  5：确定
	* customDate：是否为自定义时间
	* */
	Widget _createDateButton(String title, bool selected, int index, {bool customDate = false}) {
		return Expanded(child: GestureDetector(
			onTap: () {
				_clickTimeButton(index, customDate);
			},
			child: Container(
				height: 30,
				alignment: Alignment.center,
				child: customDate ? Row(
					mainAxisAlignment: MainAxisAlignment.end,
					children: <Widget>[
						Text(
							title ?? '',
							style: TextStyle(
								fontSize: 14,
								color: Color(0xff4d4d4d)
							)
						),
						Container(
							width: 30,
							height: 30,
							alignment: Alignment.center,
							child: Image.asset('lib/Images/date_icon_dropdown.png', width: 16, height: 16)
						)
					]
				) : Text(
					title ?? '',
					style: TextStyle(
						fontSize: 14,
						color: selected ? Colors.white : Color(0xff999999)
					)
				),
				decoration: BoxDecoration(
					color: selected ? Color(0xff6bcbd7) : Colors.white,
					borderRadius: BorderRadius.circular(2),
					border: Border.all(
						width: selected ? 0 : 1,
						color: Color(0xffe5e5e5)
					)
				)
			)
		));
	}
	
	// 选择时间
	void _clickTimeButton(int index, bool customDate) {
		var now = DateTime.now();
		if (customDate) {
			// 选择日期
			_selectDate(index == 3);
		} else if (index == 0) {
			// 今日
			this.selectedIndex = 0;
			this.startTime = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
			this.startTimeStr = '${now.year}${_addZero(now.month)}${_addZero(now.day)}';
			this.endTime = now.millisecondsSinceEpoch;
			this.endTimeStr = '${now.year}${_addZero(now.month)}${_addZero(now.day)}';
			setState(() {});
			_initData();
		} else if (index == 1) {
			// 近7日
			this.selectedIndex = 1;
			// 开始时间
			DateTime tempStart = DateTime.parse('${now.year}-${_addZero(now.month)}-${_addZero(now.day)} 00:00:00');
			int tempStartMilliseconds = tempStart.millisecondsSinceEpoch;
			this.startTime = tempStartMilliseconds - 24 * 60 * 60 * 1000 * 6;
			DateTime startDate = DateTime.fromMillisecondsSinceEpoch(this.startTime);
			this.startTimeStr = '${startDate.year}${_addZero(startDate.month)}${_addZero(startDate.day)}';
			
			// 结束时间
			this.endTime = now.millisecondsSinceEpoch;
			this.endTimeStr = '${now.year}${_addZero(now.month)}${_addZero(now.day)}';
			setState(() {});
			_initData();
		} else if (index == 2) {
			// 近30天
			this.selectedIndex = 2;
			// 开始时间
			DateTime tempStart = DateTime.parse('${now.year}-${_addZero(now.month)}-${_addZero(now.day)} 00:00:00');
			int tempStartMilliseconds = tempStart.millisecondsSinceEpoch;
			this.startTime = tempStartMilliseconds - 24 * 60 * 60 * 1000 * 29;
			DateTime startDate = DateTime.fromMillisecondsSinceEpoch(this.startTime);
			this.startTimeStr = '${startDate.year}${_addZero(startDate.month)}${_addZero(startDate.day)}';
			
			// 结束时间
			this.endTime = now.millisecondsSinceEpoch;
			this.endTimeStr = '${now.year}${_addZero(now.month)}${_addZero(now.day)}';
			setState(() {});
			_initData();
		} else if (index == 5) {
			// 确定
			_initData();
		}
	}
	
	// 自定义时间选择日期
	void _selectDate(bool isStartTime) {
		Picker(
			adapter: DateTimePickerAdapter(
				type: 7,
				isNumberMonth: true,
				yearBegin: 2000,
				yearEnd: DateTime.now().year,
				yearSuffix: '年',
				monthSuffix: '月',
				daySuffix: '日',
				value: isStartTime ?
				DateTime.fromMillisecondsSinceEpoch(this.startTime) :
				DateTime.fromMillisecondsSinceEpoch(this.endTime),
				maxValue: isStartTime ? DateTime.fromMillisecondsSinceEpoch(this.endTime) : DateTime.now(),
				minValue: !isStartTime ? DateTime.fromMillisecondsSinceEpoch(this.startTime) : DateTime.parse('2000-01-01 00:00:00')
			),
			title: Text('选择日期'),
			textAlign: TextAlign.right,
			selectedTextStyle: TextStyle(color: Color(0xff6bcbd6)),
			cancelText: '取消',
			cancelTextStyle: TextStyle(fontSize: 16, color: Color(0xff999999)),
			confirmText: '确定',
			confirmTextStyle: TextStyle(fontSize: 16, color: Color(0xff6bcbd6)),
			onSelect: (Picker picker, int index, List<int> selected) {
				setState(() {});
			},
			onConfirm: (Picker picker, List<int> selected) {
				DateTime tempTime = (picker.adapter as DateTimePickerAdapter).value;
				String tempDateStr = '${tempTime.year}${_addZero(tempTime.month)}${_addZero(tempTime.day)}';
				if (isStartTime) {
					// 开始时间
					setState(() {
						this.startTimeStr = tempDateStr;
						this.startTime = tempTime.millisecondsSinceEpoch;
						this.selectedIndex = null;
					});
				} else {
					// 结束时间
					setState(() {
						this.endTimeStr = tempDateStr;
						this.endTime = tempTime.millisecondsSinceEpoch;
						this.selectedIndex = null;
					});
				}
			}
		).showModal(context);
	}
	
	String _addZero(int value) {
		if (value < 10) {
			return '0' + value.toString();
		}
		return value.toString();
	}
	
	// 医生入驻
	Widget _createDaysItem() {
		return Container(
			padding: EdgeInsets.only(left: 15, bottom: 14),
			child: Text(
				'该医生入驻：${statisticModel?.enterDays ?? ''}天',
				style: TextStyle(fontSize: 14, color: Color(0xff0a1314))
			),
		);
	}
	
	// 指标/数量头部
	Widget _createListHeaderItem() {
		return Row(
			children: <Widget>[
				Padding(padding: EdgeInsets.only(left: 15)),
				Expanded(child: Container(
					height: 39,
					alignment: Alignment.center,
					decoration: BoxDecoration(
						borderRadius: BorderRadius.only(
							topLeft: Radius.circular(5)
						),
						color: Color(0xff6bcbd6)
					),
					child: Text('指标', style: TextStyle(fontSize: 14, color: Colors.white))
				)),
				
				Padding(padding: EdgeInsets.only(right: 0.5)),
				Expanded(child: Container(
					height: 39,
					alignment: Alignment.center,
					decoration: BoxDecoration(
						borderRadius: BorderRadius.only(
							topRight: Radius.circular(5)
						),
						color: Color(0xff6bcbd6)
					),
					child: Text('数量', style: TextStyle(fontSize: 14, color: Colors.white))
				)),
				Padding(padding: EdgeInsets.only(right: 15))
			]
		);
	}
	
	// 数据item
	Widget _createCommonItem(String title, int num, int index) {
		return Container(
			margin: EdgeInsets.symmetric(horizontal: 15),
			height: 32,
			decoration: BoxDecoration(
				border: Border(
					left: BorderSide(width: 1, color: Color(0xff6bcbd6)),
					right: BorderSide(width: 1, color: Color(0xff6bcbd6)),
					bottom: index == 9 ? BorderSide(width: 0, color: Colors.white) : BorderSide(width: 1, color: Color(0xff6bcbd6)),
					top: index == 10 ? BorderSide(width: 1, color: Color(0xff6bcbd6)) : BorderSide(width: 0, color: Colors.white)
				),
				borderRadius: index == 10 ? BorderRadius.only(
					bottomLeft: Radius.circular(5),
					bottomRight: Radius.circular(5)
				) : null
			),
			child: Row(children: <Widget>[
				Expanded(child: Text(
					title,
					style: TextStyle(
						fontSize: 14,
						color: Color(0xcd0a1314)
					),
					maxLines: 1,
					overflow: TextOverflow.ellipsis,
					textAlign: TextAlign.center
				)),
				Container(
					width: 0.5,
					height: 32,
					color: Color(0xff6bcbd6),
				),
				Expanded(child: Text(
					index != 10 ? (num == null || num < 0 ? '0' : num.toString()) :
					(num == null || num < 0 ? '0.00' : Util().formatNum((num/100.0).toStringAsFixed(2))),
					style: TextStyle(
						fontSize: 14,
						color: Color(0xcd0a1314)
					),
					maxLines: 1,
					overflow: TextOverflow.ellipsis,
					textAlign: TextAlign.center
				))
			])
		);
	}
	
	// 底部两个按钮
	Widget _createBottomBtn() {
		return Container(
			margin: EdgeInsets.only(top: 31, left: 15, right: 15),
			child: Row(children: <Widget>[
				GestureDetector(
					onTap: () {
						Navigator.of(context).push(MaterialPageRoute(
							builder: (_) => OrderContentPage(doctorModel: widget.doctorModel)
						));
					},
					child: Container(
						height: 36,
						width: 152 / 375 * MediaQuery.of(context).size.width,
						alignment: Alignment.center,
						decoration: BoxDecoration(
							color: Color(0xff6bcbd6),
							borderRadius: BorderRadius.circular(18)
						),
						child: Text(
							'查看医生处方详情',
							style: TextStyle(fontSize: 14, color: Colors.white)
						)
					)
				),
				
				Expanded(child: Container()),
				
				GestureDetector(
					onTap: () {
						Navigator.of(context).push(MaterialPageRoute(
							builder: (_) => InvitationQRCodePage(widget.doctorModel)
						));
					},
					child: Container(
						height: 36,
						width: 152 / 375 * MediaQuery.of(context).size.width,
						alignment: Alignment.center,
						decoration: BoxDecoration(
							color: Colors.white,
							borderRadius: BorderRadius.circular(18),
							border: Border.all(color: Color(0xff6bcbd6), width: 0.5)
						),
						child: Text(
							'查看医生专属二维码',
							style: TextStyle(fontSize: 14, color: Color(0xff6bcbd6))
						)
					)
				)
			])
		);
	}
}