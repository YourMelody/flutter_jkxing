import 'package:json_annotation/json_annotation.dart';

part "DoctorStatisticModel.g.dart";

@JsonSerializable()

class DoctorStatisticModel {
	
	DoctorStatisticModel(this.askNum, this.visitNum, this.returnNum, this.sendNum, this.payNum, this.payMoney,
		this.patientNum, this.doctorName, this.hospitalName, this.enterDays, this.doctorNum,
		this.headImgShowPath, this.titleName, this.departmentName);
	
	int askNum;             // 接诊数
	int visitNum;           // 问诊数
	int returnNum;          // 回访数
	int sendNum;            // 处方发送数
	int payNum;             // 处方支付数
	int payMoney;           // 支付金额
	int patientNum;         // 患者数
	String doctorName;      // 医生姓名
	String hospitalName;    // 医院名称
	int enterDays;          // 入驻时间
	int doctorNum;          // 医生数
	String headImgShowPath; // 医生头像
	String titleName;       // 医生职称
	String departmentName;  // 科室名称
	
	
	factory DoctorStatisticModel.fromJson(Map<String, dynamic> json) => _$DoctorStatisticModelFromJson(json);
	Map<String, dynamic> toJson() => _$DoctorStatisticModelToJson(this);
}