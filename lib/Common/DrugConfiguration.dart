import 'package:flutter_jkxing/Order/Model/DrugConfigModel.dart';

class DrugConfiguration {
	static DrugConfiguration drugConf;
	DrugConfigModel drugConfModel;
	
	static DrugConfiguration getInstance(DrugConfigModel model) {
		if (drugConf == null) {
			drugConf = DrugConfiguration();
		}
		if (drugConf?.drugConfModel == null && model != null) {
			drugConf.drugConfModel = model;
		}
		return drugConf;
	}
}