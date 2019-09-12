import 'package:dio/dio.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';

class HttpUtil {
	static HttpUtil instance;
	static Map<String, dynamic> optHeader;
	static String userId;
	static String userToken;
	Dio dio;
	BaseOptions options;
	
	static HttpUtil getInstance() {
		if(instance == null || userId == null || userToken == null){
			PPSession tempSession = PPSession.getInstance();
			userId = tempSession.userId;
			userToken = tempSession.userToken;
			instance = HttpUtil();
		}
		return instance;
	}
	
	HttpUtil() {
		var userId = PPSession.getInstance().userId;
		var userToken = PPSession.getInstance().userToken;
		Map<String, dynamic> optHeader = {
			'traceinfo': 'versionName=2.6.4;versionCode=20190918;appName=%E5%81%A5%E5%AE%A2%E8%A1%8C;model=iPhone8,2;clientname=iPhone;channelId=10000;idfa=EE6C1572-06B5-4415-931A-247618068190;loginSource=2;deviceUuid=6815F5E3FE06436DBD6C0AD8DCFC970F;source=2;applicationCode=jkAgent;userId=$userId;userToken=$userToken',
			'User-Agent': 'HotSpot',
			'Accept-Language': 'zh-cn',
			'Content-Type': 'application/json',
			'Connection': 'keep-alive'
		};
		
		options = BaseOptions(
			//连接服务器超时时间，单位是毫秒.
			connectTimeout: 30000,
			headers: optHeader
		);
		dio = Dio(options);
		
//		(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
//			// 设置代理
//			client.findProxy = (uri) {
//				return 'PROXY 192.168.36.77:8888';
//			};
//		};
	}
	
	// get
	get<T>(url, {baseUrl, data, options, cancelToken}) async {
		Response<T> response;
		try{
			dio.options.baseUrl = baseUrl;
			response = await dio.get<T>(
				url,
				queryParameters: data,
				cancelToken: cancelToken
			);
			return response.data;
		} on DioError catch(e){
			return null;
		}
	}
	
	// post
	post<T>(url, {baseUrl, data, options, cancelToken}) async {
		Response<T> response;
		try{
			dio.options.baseUrl = baseUrl;
			response = await dio.post<T>(
				url,
				data: data,
				cancelToken: cancelToken
			);
			return response.data;
		} on DioError catch(error){
			return error;
		}
	}
}