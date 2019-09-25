import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Redux/ZFAction.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ZFProgressHUDView extends StatelessWidget {
	final ProgressHUDType progressHUDType;
	final String titleStr;
	ZFProgressHUDView(this.progressHUDType, this.titleStr);
	
	@override
	Widget build(BuildContext context) {
		return Container(
			alignment: Alignment.center,
			color: Color.fromRGBO(0, 0, 0, 0),
			child: Container(
				decoration: BoxDecoration(
					color: Color.fromRGBO(0, 0, 0, 0.88),
					borderRadius: BorderRadius.circular(18)
				),
				padding: EdgeInsets.all(20),
				constraints: BoxConstraints(
					minWidth: 100,
					maxWidth: MediaQuery.of(context).size.width - 120,
					minHeight: 100,
					maxHeight: 120
				),
				child: _getContentWidget()
			)
		);
	}
	
	Widget _getContentWidget() {
		if (this.progressHUDType != ProgressHUDType.ProgressHUDType_Loading) {
			return CircularProgressIndicator(
				strokeWidth: 5,
				backgroundColor: Colors.white,
				valueColor: AlwaysStoppedAnimation(Colors.black)
			);
		} else {
			return Text(
				this.titleStr == null ? '解放发饿了发来我看饥饿疗法未来房价未来可减肥' : this.titleStr,
				style: TextStyle(
					fontSize: 16,
					height: 1.1,
					color: Colors.white,
					fontWeight: FontWeight.normal,
					decoration: TextDecoration.none
				),
				maxLines: 2,
				textAlign: TextAlign.center
			);
		}
	}
}