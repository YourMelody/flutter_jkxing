import 'package:flutter/material.dart';

class ESImageViewPage extends StatefulWidget {
	final String imgUrl;
	ESImageViewPage(this.imgUrl);
	@override
	State<StatefulWidget> createState() {
		return _ESImageViewState();
	}
}

class _ESImageViewState extends State<ESImageViewPage> with SingleTickerProviderStateMixin {
	
	double _scale = 1.0;
	AnimationController _controller;
	Animation<Offset> _animation;
	Offset _offset = Offset.zero;
	Offset _normalizedOffset;
	double _previousScale;
	double _kMinFlingVelocity = 600.0;
	
	@override
	void initState() {
		super.initState();
		_controller = AnimationController(vsync: this);
		_controller.addListener(() {
			setState(() {
				_offset = _animation.value;
			});
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: GestureDetector(
				onTap: () {
					if (_scale == 1.0) {
						Navigator.of(context).pop();
					} else {
						this.setState(() {
							_scale = 1.0;
						});
					}
				},
				onDoubleTap: () {
					if (_scale == 1.0) {
						this.setState(() {
							_scale = 2.0;
						});
					}
				},
				onScaleStart: _handleOnScaleStart,
				onScaleUpdate: _handleOnScaleUpdate,
				onScaleEnd: _handleOnScaleEnd,
				child: Container(
					alignment: Alignment.center,
					color: Colors.black,
					child: ClipRect(child: Transform(
						child: Image.network(
							widget.imgUrl ?? '',
							fit: BoxFit.cover
						),
						transform: Matrix4.identity()..translate(_offset.dx, _offset.dy)
							..scale(_scale)
					))
				)
			),
			backgroundColor: Colors.black,
		);
	}
	
	
	Offset _clampOffset(Offset offset) {
		final Size size = context.size;
		// widget的屏幕宽度
		final Offset minOffset = Offset(size.width, size.height) * (1.0 - _scale);
		// 限制他的最小尺寸
		return Offset(
			offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
	}
	
	void _handleOnScaleStart(ScaleStartDetails details) {
		setState(() {
			_previousScale = _scale;
			_normalizedOffset = (details.focalPoint - _offset) / _scale;
			// 计算图片放大后的位置
			_controller.stop();
		});
	}
	
	void _handleOnScaleUpdate(ScaleUpdateDetails details) {
		setState(() {
			_scale = (_previousScale * details.scale).clamp(0.1, 3.0);
			// 限制放大倍数 0.1~3倍
			_offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
			// 更新当前位置
		});
	}
	
	void _handleOnScaleEnd(ScaleEndDetails details) {
		final double magnitude = details.velocity.pixelsPerSecond.distance;
		if (magnitude < _kMinFlingVelocity) return;
		final Offset direction = details.velocity.pixelsPerSecond / magnitude;
		// 计算当前的方向
		final double distance = (Offset.zero & context.size).shortestSide;
		// 计算放大倍速，并相应的放大宽和高，比如原来是600*480的图片，放大后倍数为1.25倍时，宽和高是同时变化的
		_animation = _controller.drive(Tween<Offset>(
			begin: _offset, end: _clampOffset(_offset + direction * distance)));
		_controller
			..value = 0.0
			..fling(velocity: magnitude / 1000.0);
	}
	
	@override
	void dispose() {
		super.dispose();
		_controller.dispose();
	}
}