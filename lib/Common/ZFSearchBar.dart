import 'package:flutter/material.dart';

class ZFSearchBar extends StatelessWidget {
	final double paddingH;      // 水平方向边距，默认20
	final double paddingV;      // 竖直方向空白，默认10
	final double height;        // 总高度（包含paddingH），默认50
	final String placeholder;   // 占位文字
	final Color textColor;      // 占位文字颜色，默认为660a1314
	final double fontSize;      // 占位文字字体大小，默认为14
	final Color bgColor;        // 背景色，默认为fff4f6f9
	final Function onTapSearchBar; // 搜索框点击事件
	final bool showSearchIcon;  // 是否展示搜索图片，默认为true
	
	ZFSearchBar({
		this.paddingH = 20,
		this.paddingV = 10,
		this.height = 50,
		this.placeholder,
		this.textColor,
		this.fontSize,
		this.bgColor,
		this.onTapSearchBar,
		this.showSearchIcon = true
	});
	
	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			child: Container(
				margin: EdgeInsets.symmetric(horizontal: this.paddingH, vertical: this.paddingV),
				height: height - 2 * this.paddingV,
				decoration: BoxDecoration(
					borderRadius: BorderRadius.all(Radius.circular((height - 2 * paddingV)/2.0)),
					color: this.bgColor ?? Color(0xfff4f6f9)
				),
				child: Row(
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[
						Padding(padding: EdgeInsets.only(left: 10)),
						Offstage(
							offstage: this.showSearchIcon == false,
							child: Icon(
								Icons.search,
								color: Colors.grey,
								size: 18
							)
						),
						Padding(padding: EdgeInsets.only(left: 5)),
						Text(
							this.placeholder ?? '',
							style: TextStyle(
								color: this.textColor ?? Color(0x660a1314),
								fontSize: this.fontSize != null && this.fontSize > 0 ? this.fontSize : 14
							)
						)
					]
				)
			),
			onTap: () {
				if (this.onTapSearchBar != null) {
					this.onTapSearchBar();
				}
			}
		);
	}
}