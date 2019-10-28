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
	final Map doctorNumMap;
	MineSaleDetailWidget(this.model, this.doctorNumMap);
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
					height: PPSession.getInstance()?.userModel?.agentType == 1 ? 235 : 195,
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
		int agentType = PPSession.getInstance()?.userModel?.agentType;
		if (index == 0) {
			if (agentType == 1) {
				return _getFirstPageAgentType1();
			} else {
				int agentLevel = PPSession.getInstance()?.userModel?.agentLevel;
				return _getFirstPageAgentType2(agentLevel == 1);
			}
		} else {
			return _getSecondPage(agentType == 1);
		}
	}
	
	// 全职
	Widget _getFirstPageAgentType1() {
		return Container(
			padding: EdgeInsets.fromLTRB(15, 22, 15, 0),
			child: Column(
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
										_manageMoney(widget.model?.targetMoney, showLine: widget.model?.crossMonth),
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
											widget.model.grossProfitMargin,
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
											_manageMoney(widget.model?.floatMoney, showLine: widget.model?.crossMonth),
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
			)
		);
	}
	
	// 兼职
	Widget _getFirstPageAgentType2(bool isFirstLevel) {
		if (isFirstLevel) {
			return Container(
				padding: EdgeInsets.fromLTRB(15, 35, 15, 0),
				child: Column(
					children: <Widget>[
						Text(
							'销售业绩(元)',
							style: TextStyle(
								fontSize: 12,
								color: Color.fromRGBO(10, 19, 20, 0.4)
							)
						),
						
						// 销售业绩
						Text(
							_manageMoney(widget.model?.bonusMoney),
							style: TextStyle(
								fontSize: 36,
								fontWeight: FontWeight.w500,
								color: Color(0xff6bcbd7)
							)
						),
						Padding(padding: EdgeInsets.only(bottom: 21)),
						
						Row(
							children: <Widget>[
								Expanded(child: Column(
									children: <Widget>[
										Row(
											children: <Widget>[
												Text(
													'月销售指标(元)',
													style: TextStyle(
														fontSize: 12,
														color: Color.fromRGBO(10, 19, 20, 0.4)
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
										Padding(padding: EdgeInsets.only(bottom: 2)),
										Text(
											_manageMoney(widget.model?.targetMoney),
											style: TextStyle(
												fontSize: 16,
												color: Color.fromRGBO(10, 19, 20, 0.8)
											)
										)
									],
									crossAxisAlignment: CrossAxisAlignment.start
								)),
								Padding(padding: EdgeInsets.only(right: 10)),
								Container(
									width: 130,
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.end,
										children: <Widget>[
											Text(
												'距离销售指标(元)',
												style: TextStyle(
													fontSize: 12,
													color: Color.fromRGBO(10, 19, 20, 0.4)
												)
											),
											Padding(padding: EdgeInsets.only(bottom: 2)),
											Text(
												_manageMoney(widget.model?.floatMoney, showLine: widget.model?.crossMonth),
												style: TextStyle(
													fontSize: 16,
													color: Color(0xffe75d5b)
												)
											)
										]
									)
								)
							],
							crossAxisAlignment: CrossAxisAlignment.start
						)
					]
				)
			);
		} else {
			return Container(
				padding: EdgeInsets.only(top: 60),
				child: Column(
					children: <Widget>[
						Text(
							'销售业绩(元)',
							style: TextStyle(
								fontSize: 12,
								color: Color.fromRGBO(10, 19, 20, 0.4)
							)
						),
						
						// 销售业绩
						Text(
							_manageMoney(widget.model?.bonusMoney),
							style: TextStyle(
								fontSize: 36,
								fontWeight: FontWeight.w500,
								color: Color(0xff6bcbd7)
							)
						)
					]
				)
			);
		}
	}
	
	// isType1: true全职  false兼职
	Widget _getSecondPage(bool isType1) {
		String allNum = '0';
		String waitAuthNum = '0';
		String auditPassNum = '0';
		if (widget.doctorNumMap != null) {
			if (widget.doctorNumMap['allDoctors'] != null) {
				allNum = widget.doctorNumMap['allDoctors'].toString();
			}
			if (widget.doctorNumMap['waitAuthDoctors'] != null) {
				waitAuthNum = widget.doctorNumMap['waitAuthDoctors'].toString();
			}
			if (widget.doctorNumMap['auditPassDoctors'] != null) {
				auditPassNum = widget.doctorNumMap['auditPassDoctors'].toString();
			}
		}
		return Container(
			padding: EdgeInsets.fromLTRB(15, isType1 ? 32 : 17, 15, 0),
			child: Column(
				children: <Widget>[
					Text('医生数', style: TextStyle(fontSize: 16, color: Color(0xff3b4243))),
					Padding(padding: EdgeInsets.only(top: 2)),
					Text(allNum, style: TextStyle(fontSize: 30, color: Color(0xff6bcbd7))),
					Padding(padding: EdgeInsets.only(top: isType1 ? 18 : 8)),
					Container(
						height: 78,
						child: Row(children: <Widget>[
							Expanded(child: GestureDetector(
								onTap: () {
								
								},
								child: Column(
									children: <Widget>[
										Padding(padding: EdgeInsets.only(top: 15)),
										Row(
											children: <Widget>[
												Text('已通过', style: TextStyle(fontSize: 14, color: Color(0xff9da1a1))),
												Padding(padding: EdgeInsets.only(right: 5)),
												Image.asset('lib/Images/mini_right_arrow.png', width: 12, height: 12)
											],
											mainAxisAlignment: MainAxisAlignment.center
										),
										Padding(padding: EdgeInsets.only(top: 8)),
										Text(auditPassNum, style: TextStyle(fontSize: 20, color: Color(0xff3b4243)))
									]
								),
							)),
							Container(height: 40, width: 1, color: Color(0xffe5e5e5)),
							Expanded(child: GestureDetector(
								onTap: () {
								
								},
								child: Column(
									children: <Widget>[
										Padding(padding: EdgeInsets.only(top: 15)),
										Row(
											children: <Widget>[
												Text('待认证', style: TextStyle(fontSize: 14, color: Color(0xff9da1a1))),
												Padding(padding: EdgeInsets.only(right: 5)),
												Image.asset('lib/Images/mini_right_arrow.png', width: 12, height: 12)
											],
											mainAxisAlignment: MainAxisAlignment.center
										),
										Padding(padding: EdgeInsets.only(top: 8)),
										Text(waitAuthNum, style: TextStyle(fontSize: 20, color: Color(0xff3b4243)))
									]
								)
							))
						])
					)
				]
			)
		);
	}
	
	String _manageMoney(int money, {bool showLine}) {
		String resultMoney = money == null ? '0.00' : (money/100).toStringAsFixed(2);
		if (resultMoney == '0.00' && showLine == true) {
			resultMoney = '--';
		}
		return resultMoney;
	}
}