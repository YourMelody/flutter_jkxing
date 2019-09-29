import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_jkxing/Common/PPSession.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_jkxing/Common/ZFBaseUrl.dart';
import 'package:flutter_jkxing/Redux/ZFAction.dart';
import 'package:flutter_jkxing/Redux/ZFAuthState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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
			connectTimeout: 15000,
			receiveTimeout: 15000,
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
	
	
	
	/*
	* url：请求链接
	* baseUrl：请求域名
	* data：请求参数，默认为ZFBaseUrl().BjUrl()
	* disposeData：是否处理返回的数据，默认为true
	* showToast：是否toast提示，默认为false，为true时，需要传context
	* */
	get<T>(url, {
		baseUrl,
		data,
		bool disposeData: true,
		bool showToast: false,
		BuildContext context
	}) async {
		Response<T> response;
		Store store;
		if (showToast && context != null) {
			store = StoreProvider.of<ZFAppState>(context);
			store.dispatch(AppActions.ZFProgressHUDLoading);
		}
		
		try{
			if (showToast && context != null) {
				store = StoreProvider.of<ZFAppState>(context);
				store.dispatch(AppActions.ZFProgressHUDLoading);
			}
			
			dio.options.baseUrl = baseUrl == null ? ZFBaseUrl().BjUrl() : baseUrl;
			response = await dio.get<T>(
				url,
				queryParameters: data
			);
//			print('-----${response.request.path}-----response-----${response.data}');
			String respStr = json.encode(response.data);
			Map<dynamic, dynamic> respMap = json.decode(respStr);
			
			// 直接返回请求的结果
			if (disposeData == false) {
				if (respMap['msg']['code'] == 0) {
					if (showToast && store != null) {
						store.dispatch(AppActions.ZFProgressHUDDismiss);
					}
				} else {
					// 请求失败
					if (showToast == true && store != null) {
						String respStr = respMap['msg']['info'];
						store.dispatch({'success': false, 'title':respStr});
						Timer(Duration(seconds: 1), () {
							store.dispatch(AppActions.ZFProgressHUDDismiss);
						});
					}
				}
				return response.data;
			}
			
			// 处理返回的数据
			if (respMap['msg']['code'] == 0) {
				if (showToast && store != null) {
					store.dispatch(AppActions.ZFProgressHUDDismiss);
				}
				// 请求成功
				return respMap['data'];
			} else {
				// 请求失败
				if (showToast == true && store != null) {
					String respStr = respMap['msg']['info'];
					store.dispatch({'success': false, 'title':respStr});
					Timer(Duration(seconds: 1), () {
						store.dispatch(AppActions.ZFProgressHUDDismiss);
					});
				}
				return null;
			}
		} on DioError catch(error){
			// 网络异常
			if (showToast == true && store != null) {
				store.dispatch({'success': false, 'title':'网络连接异常，请检查您的网络设置'});
				Timer(Duration(seconds: 1), () {
					store.dispatch(AppActions.ZFProgressHUDDismiss);
				});
			}
			return null;
		}
	}
	
	
	
	
	/*
	* url：请求链接
	* baseUrl：请求域名
	* data：请求参数
	* disposeData：是否处理返回的数据，默认为true
	* showToast：是否toast提示，默认为false，为true时，需要传context
	* */
	post<T>(url, {
		baseUrl,
		data,
		bool disposeData: true,
		bool showToast: false,
		BuildContext context
	}) async {
		Response<T> response;
		Store store;
		if (showToast && context != null) {
			store = StoreProvider.of<ZFAppState>(context);
			store.dispatch(AppActions.ZFProgressHUDLoading);
		}
		
		try{
			if (showToast && context != null) {
				store = StoreProvider.of<ZFAppState>(context);
				store.dispatch(AppActions.ZFProgressHUDLoading);
			}
			
			dio.options.baseUrl = baseUrl == null ? ZFBaseUrl().BjUrl() : baseUrl;
			response = await dio.post<T>(
				url,
				data: data
			);
//			print('-----${response.request.path}-----response-----${response.data}');
			String respStr = json.encode(response.data);
			Map<dynamic, dynamic> respMap = json.decode(respStr);
			
			// 直接返回请求的结果
			if (disposeData == false) {
				if (respMap['msg']['code'] == 0) {
					if (showToast && store != null) {
						store.dispatch(AppActions.ZFProgressHUDDismiss);
					}
				} else {
					// 请求失败
					if (showToast == true && store != null) {
						String respStr = respMap['msg']['info'];
						store.dispatch({'success': false, 'title':respStr});
						Timer(Duration(seconds: 1), () {
							store.dispatch(AppActions.ZFProgressHUDDismiss);
						});
					}
				}
				return response.data;
			}
			
			// 处理返回的数据
			if (respMap['msg']['code'] == 0) {
				if (showToast && store != null) {
					store.dispatch(AppActions.ZFProgressHUDDismiss);
				}
				// 请求成功
				return respMap['data'];
			} else {
				// 请求失败
				if (showToast == true && store != null) {
					String respStr = respMap['msg']['info'];
					store.dispatch({'success': false, 'title':respStr});
					Timer(Duration(seconds: 1), () {
						store.dispatch(AppActions.ZFProgressHUDDismiss);
					});
				}
				return null;
			}
		} on DioError catch(error){
			// 网络异常
			if (showToast == true && store != null) {
				store.dispatch({'success': false, 'title':'网络连接异常，请检查您的网络设置'});
				Timer(Duration(seconds: 1), () {
					store.dispatch(AppActions.ZFProgressHUDDismiss);
				});
			}
			return null;
		}
	}
}