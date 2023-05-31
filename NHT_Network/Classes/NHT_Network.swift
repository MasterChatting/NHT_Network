//
//  Network.swift
//  BalticSwift
//
//  Created by NHT on 2023/4/21.
//

import Foundation
import Alamofire
import LoadingView_NHT
import NHT_SomeSupport

/// 错误时，默认提示语
var Network_DefaultErrorMessage = "操作失败，请重试！";
/// 调用接口后，对返回数据处理需要弹窗提示时取值用的key
var Network_ShowAlertMessageKey = "message";
/// 调用接口后，对返回数据处理时 判断是否成功用到的key
var Network_CheckSuccessKey = "code";

///是否需要添加HTTPHeaders
var Network_NeedHeaders = true;
///HTTPHeaders 配置方法：Network_Headers.add(name: "access-token", value: "内容")
var Network_Headers:HTTPHeaders = [];

func Request_GET(urlStr:String,loading:Bool, parameters:[String:Any] ,successBlock: @escaping ([String:Any],Int) -> Void) {
    Request_BASE(urlStr: urlStr, loading: loading, method: .get, parameters: parameters, successBlock: { resultInfo, resultCode in
        successBlock(resultInfo,resultCode);
    })
}

func Request_POST(urlStr:String,loading:Bool,parameters:[String:Any] ,successBlock: @escaping ([String:Any],Int) -> Void) {
    Request_BASE(urlStr: urlStr, loading: loading, method: .post, parameters: parameters, successBlock: { resultInfo, resultCode in
        successBlock(resultInfo,resultCode);
    })
}
func Request_BASE(urlStr:String,loading:Bool,method:HTTPMethod, parameters:[String:Any] ,successBlock: @escaping ([String:Any],Int) -> Void) {
    if loading {
        LoadingView_NHT.sharedLoading().loadingAnimationStart();
    }
    print("URL---:",urlStr,"\n","parameters---:",parameters)
    AF.request(urlStr,method: method, parameters: parameters,headers: Network_NeedHeaders ? Network_Headers : nil).response{ response in
        handleData(response: response,urlString: urlStr) { success , resultCode in
            if loading {
                LoadingView_NHT.sharedLoading().loadingAnimationStop();
            }
            successBlock(success,resultCode);
        } ;
    };
}

///对返回信息进行处理
private func handleData(response:AFDataResponse<Data?>,urlString:String,successBlock: ([String:Any],Int) -> Void){
    switch response.result {
    case .success:
        let data = response.value!!;
        do {
            let resultJson = try JSONSerialization.jsonObject(with: data)
            var resultObject = Support_Common.changeType(resultJson) as! [String:Any];
            
            //错误提示信息
            if resultObject[Network_ShowAlertMessageKey] == nil {
                resultObject[Network_ShowAlertMessageKey] = Network_DefaultErrorMessage;
            }
            if resultObject[Network_CheckSuccessKey] == nil {
                resultObject[Network_CheckSuccessKey] = "-10086";
            }
            let resultCode = resultObject[Network_CheckSuccessKey] as! String;
            successBlock(resultObject,Int(resultCode) ?? -10086);
        } catch  {
            print(error);
            successBlock([Network_CheckSuccessKey:"-10086",Network_ShowAlertMessageKey:Network_DefaultErrorMessage],-10086);
        }
        break
    case .failure:
        /**
         AFError 错误信息
         errorDescription 错误具体描述，response.error?.errorDescription 比如：URLSessionTask failed with error: The Internet connection appears to be offline
         underlyingError 错误的详细信息，response.error?.underlyingError
         
         let error = response.error;
         let errorDescription = error?.errorDescription;
         let underlyingError = error?.underlyingError as? NSError;
         let userInfo = underlyingError!.userInfo;
         */
    
        let error = response.error;
        let errorDescription = error?.errorDescription ?? Network_DefaultErrorMessage;
        successBlock([Network_CheckSuccessKey:"-10086",Network_ShowAlertMessageKey:errorDescription],-10086);
        break
    }
}
