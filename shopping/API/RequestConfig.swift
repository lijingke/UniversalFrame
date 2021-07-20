//
//  RequestConfig.swift
//  shopping
//
//  Created by 李京珂 on 2021/7/19.
//

import Foundation

struct RequestConfig {
    static var requestDomain = ""
    static var uploadImageUrl = ""

    /// 初始化
    static func initDomain() {
        #if DEBUG // 开发环境
        RequestConfig.change(domain: "")
        #elseif BATA // 测试环境
        RequestConfig.change(domain: "")
        #elseif RELEASE // 发布环境
        RequestConfig.change(domain: "")
        #endif
    }

    static func change(domain: String) {
        #if DEBUG || BATA
        RequestConfig.requestDomain = domain
        #else
        RequestConfig.requestDomain = domain
        #endif
        RequestConfig.requestDomain = "http://\(domain)/share"
        LogUtil.log("----切换环境为------>" + RequestConfig.requestDomain)
    }
}

extension RequestConfig {
    // 通用参数配置
    static func getCommenParams() -> [String: Any] {
//        LogUtil.log("----服务器地址------->"+domain)
        return ["sys_p": "I",
//                "sys_m":UIDevice.deviceModel(),
//                "sys_v":UIDevice.systemVersion(),
                "sys_vc": "",
                "cli_c": "AppStore",
//                "cli_v": ez.appVersionAndBuild ?? "",
                "langType": "0",
                "token": ""]
    }

    // 获取请求body内的共同参数
    static func getBodyCommenParam() -> [String: Any] {
        var params: [String: Any] = ["langType": 0]
        params["client"] = "user"
        params["systemPlatform"] = "I"
//        params["clientVersion"] = AppConfigHelper.getVersion()
//
//        if User.userInfo != nil &&
//            User.userInfo!.count != 0 {
//            params["token"] = User.userToken
//            params["loginId"] = User.currentUserId
//            let loca = LocationService.share().currentCity()
//            params["latitude"] = loca.lat
//            params["longitude"] = loca.lon
//        }
        return params
    }
}
