import 'package:flutter/material.dart';
enum ProgressType {
	ProgressType_Loading,
	ProgressType_Success,
	ProgressType_Error
}

class ZFProgressHUDView extends StatelessWidget {
	final ProgressType progressType;
	final String title;
	ZFProgressHUDView(this.progressType, this.title);
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.transparent,
			body: Center(
				child: Container(
					decoration: BoxDecoration(
						color: Color.fromRGBO(0, 0, 0, 0.88),
						borderRadius: BorderRadius.circular(18)
					),
					padding: EdgeInsets.all(16),
					child: _getContentWidget(),
					constraints: BoxConstraints(
						minWidth: 90,
						maxWidth: MediaQuery.of(context).size.width - 140,
						minHeight: 90
					)
				)
			)
		);
	}
	
	Widget _getContentWidget() {
		if (this.progressType == ProgressType.ProgressType_Loading) {
			return CircularProgressIndicator(
				strokeWidth: 3,
				backgroundColor: Colors.black,
				valueColor: AlwaysStoppedAnimation(Colors.white)
			);
		} else {
			return IntrinsicHeight(
				child: Column(
					children: <Widget>[
						this.progressType == ProgressType.ProgressType_Error ?
						Icon(Icons.error_outline, color: Colors.white, size: 30) :
						Icon(Icons.done, color: Colors.white, size: 30),
						Padding(padding: EdgeInsets.only(top: 8)),
						Text(
							this?.title ?? '',
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