import 'package:flutter/material.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';

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
				padding: EdgeInsets.all(12),
				child: _getContentWidget(),
				constraints: BoxConstraints(
					minWidth: 90,
					maxWidth: MediaQuery.of(context).size.width - 140,
					minHeight: 90
				)
			)
		);
	}
	
	Widget _getContentWidget() {
		if (this.progressHUDType == ProgressHUDType.ProgressHUDType_Loading) {
			return CircularProgressIndicator(
				strokeWidth: 3,
				backgroundColor: Colors.black,
				valueColor: AlwaysStoppedAnimation(Colors.white)
			);
		} else {
			return IntrinsicHeight(
				child: Column(
					children: <Widget>[
						this.progressHUDType == ProgressHUDType.ProgressHUDType_Error ?
						Icon(Icons.error_outline, color: Colors.white, size: 30) :
						Icon(Icons.done, color: Colors.white, size: 30),
						Padding(padding: EdgeInsets.only(top: 8)),
						Text(
							this.titleStr,
							style: TextStyle(
								fontSize: 16,
								height: 1.1,
								color: Colors.white,
								fontWeight: FontWeight.normal,
								decoration: TextDecoration.none
							),
							maxLines: 2,
							textAlign: TextAlign.center
						)
					],
					mainAxisAlignment: MainAxisAlignment.center
				)
			);
		}
	}
}