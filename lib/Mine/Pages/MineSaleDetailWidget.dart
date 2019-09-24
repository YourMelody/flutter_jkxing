import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_jkxing/Mine/Model/MineDetailModel.dart';

/* *
 * 显示规则：
 *  1、预计个人提成和销售业绩，数据为空时显示0.00
 *  2、净毛利率数据为空时，显示0.00%
 *  3、月销售业绩和距离销售业绩，跨月查看数据为空，显示--，非跨月查看数据为空显示0.00
 *  4、全职（agentType为1），显示所有信息    高度235
 *  5、兼职（agentType为2）                高度195
 *      5.1 一级（agentLevel为1）不显示预计个人提成和净毛利率
 *      5.2 二级（agentLevel为2）只显示销售业绩
 * */

class MineSaleDetailWidget extends StatefulWidget {
	final MineDetailModel model;
	MineSaleDetailWidget(this.model);
	@override
	State<StatefulWidget> createState() {
		return _MineSaleDetailState();
	}
}

class _MineSaleDetailState extends State<MineSaleDetailWidget> {
	int currentPage = 0;
	@override
	Widget build(BuildContext context) {
		return Stack(
			children: <Widget>[
				Container(
					height: PPSession.getInstance().userModel.agentType == 1 ? 235 : 195,
					padding: EdgeInsets.fromLTRB(15, 23, 15, 0),
					width: double.maxFinite,
					color: Colors.white,
					child: PageView.builder(
						itemBuilder: (context, index) => _pageViewItem(index),
						itemCount: 2,
						onPageChanged: (page) {
							setState(() {
								this.currentPage = page;
							});
						},
					)
				),
				Positioned(
					bottom: 15,
					child: Row(children: <Widget>[
						Container(
							width: 10,
							height: 10,
							margin: EdgeInsets.only(right: 10),
							decoration: BoxDecoration(
								color: this.currentPage == 0 ? Color(0xff6bcbd6) : Color(0x4c6bcbd6),
								borderRadius: BorderRadius.circular(5)
							)
						),
						Container(
							width: 10,
							height: 10,
							decoration: BoxDecoration(
								color: this.currentPage == 1 ? Color(0xff6bcbd6) : Color(0x4c6bcbd6),
								borderRadius: BorderRadius.circular(5)
							)
						)
					])
				)
			],
			alignment: Alignment.topCenter,
		);
	}
	
	Widget _pageViewItem(int index) {
		int agentType = PPSession.getInstance().userModel.agentType;
		if (index == 0) {
			if (agentType == 1) {
				return _getFirstPageAgentType1();
			} else {
				return _getFirstPageAgentType2();
			}
		} else {
			return _getSecondPage(agentType == 1);
		}
	}
	
	// 全职
	Widget _getFirstPageAgentType1() {
		return Column(
			children: <Widget>[
				Text(
					'预计个人提成(元)',
					style: TextStyle(
						fontSize: 16,
						color: Color(0xff3b4243)
					)
				),
				Padding(padding: EdgeInsets.only(top: 6)),
				
				// 个人提成
				Text(
					_manageMoney(widget.model?.bonusMoney),
					style: TextStyle(
						fontSize: 30,
						fontWeight: FontWeight.w500,
						color: Color(0xff6bcbd7)
					)
				),
				Padding(padding: EdgeInsets.only(bottom: 18)),
				
				Row(
					children: <Widget>[
						Expanded(child: Column(
							children: <Widget>[
								Text(
									'销售业绩(元)',
									style: TextStyle(
										fontSize: 12,
										color: Color(0xff9da1a1)
									)
								),
								Padding(padding: EdgeInsets.only(bottom: 4)),
								Text(
									_manageMoney(widget.model?.saleMoney),
									style: TextStyle(
										fontSize: 16,
										color: Color(0xff3b4243)
									)
								),
								Padding(padding: EdgeInsets.only(bottom: 11)),
								Row(
									children: <Widget>[
										Text(
											'月销售指标(元)',
											style: TextStyle(
												fontSize: 12,
												color: Color(0xff9da1a1)
											)
										),
										
										GestureDetector(
											onTap: () {
												showDialog(
													context: context,
													builder: (context) {
														return CupertinoAlertDialog(
															title: Text('提示', style: TextStyle(fontSize: 16, color: Color(0xff0a1314))),
															content: Padding(
																padding: EdgeInsets.only(top: 10),
																child: Text('查询销售指标时不支持跨月查询', style: TextStyle(fontSize: 14, color: Color(0xff0a1314))),
															),
															actions: <Widget>[
																CupertinoButton(
																	onPressed: () {
																		Navigator.pop(context);
																	},
																	child: Text('知道了', style: TextStyle(fontSize: 16, color: Color(0xff6bcbd6))),
																	pressedOpacity: 0.8
																)
															],
														);
													}
												);
											},
											
											child: Container(
												width: 16, height: 16,
												child: Center(
													child: Image.asset(
														'lib/Images/me_btn_msg.png',
														width: 12, height: 12
													)
												)
											)
										)
									]
								),
								Text(
									_manageMoney(widget.model?.targetMoney),
									style: TextStyle(
										fontSize: 16,
										color: Color(0xff3b4243)
									)
								)
							],
							crossAxisAlignment: CrossAxisAlignment.start
						)),
						Padding(padding: EdgeInsets.only(right: 10)),
						Container(
							width: 130,
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
									Text(
										'净毛利率',
										style: TextStyle(
											fontSize: 12,
											color: Color(0xff9da1a1)
										)
									),
									Padding(padding: EdgeInsets.only(bottom: 4)),
									Text(
										(widget.model?.grossProfitMargin == null || widget.model?.grossProfitMargin?.length == 0) ? '0.00%' :
										widget.model.grossProfitMargin.length,
										style: TextStyle(
											fontSize: 16,
											color: Color(0xff3b4243)
										)
									),
									Padding(padding: EdgeInsets.only(bottom: 11)),
									Text(
										'距离销售指标(元)',
										style: TextStyle(
											fontSize: 12,
											color: Color(0xff9da1a1)
										)
									),
									Text(
										_manageMoney(widget.model?.floatMoney),
										style: TextStyle(
											fontSize: 16,
											color: Color(0xff3b4243)
										)
									)
								]
							)
						)
					],
					crossAxisAlignment: CrossAxisAlignment.start
				)
			],
			crossAxisAlignment: CrossAxisAlignment.start
		);
	}
	
	// 兼职
	Widget _getFirstPageAgentType2() {
		return Center(child: Text('first'));
	}
	
	// isType1: true全职  false兼职
	Widget _getSecondPage(bool isType1) {
		return Column(
			children: <Widget>[
				Padding(padding: EdgeInsets.only(top: isType1 ? 15 : 0)),
				Text('医生数', style: TextStyle(fontSize: 16, color: Color(0xff3b4243))),
				Padding(padding: EdgeInsets.only(top: 2)),
				Text('532', style: TextStyle(fontSize: 30, color: Color(0xff6bcbd7))),
				Padding(padding: EdgeInsets.only(top: isType1 ? 25 : 15)),
			]
		);
	}
	
	String _manageMoney(int money) {
		String resultMoney = money == null ? '0.00' : (money/1000).toStringAsFixed(2);
		return resultMoney;
	}
}