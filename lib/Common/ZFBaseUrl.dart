
class ZFBaseUrl {
	// 0--开发    1--测试    2--线上
	static int JK_APP_DEBUG_SETTING = 1;
	
	BjUrl() {
		switch(JK_APP_DEBUG_SETTING) {
			case 0:
				return "http://bj-api.d.jianke.com/";
			case 1:
				return "https://bjtest.jianke.com/";
			case 2:
				return "https://bj-api.jianke.com/";
		}
	}
	
	GDUrl() {
		switch(JK_APP_DEBUG_SETTING) {
			case 0:
				return "http://app-gateway.dev.jianke.com/";
			case 1:
				return "http://app-gateway.dev.jianke.com/";
			case 2:
				return "https://acgi.jianke.com/";
		}
	}
	
	// 药品详情
	ProductDetailUrl() {
		switch(JK_APP_DEBUG_SETTING) {
			case 0:
				return "http://bj-acgi.d.jianke.com/product/detail/mainData/";
			case 1:
				return "https://bj-acgi-test.jianke.com/product/detail/mainData/";
			case 2:
				return "https://bj-acgi.jianke.com/product/detail/mainData/";
		}
	}
	
	// 药品说明书
	InstructionsUrl() {
		switch(JK_APP_DEBUG_SETTING) {
			case 0:
				return "http://app-hybrid.tst.jianke.com";
			case 1:
				return "http://app-hybrid.tst.jianke.com";
			case 2:
				return "https://app-hybrid.jianke.com";
		}
	}
}