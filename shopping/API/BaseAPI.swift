//
//  BaseAPI.swift
//  shopping
//
//  Created by 李京珂 on 2021/7/19.
//

import Foundation
import Moya

extension TargetType {
    /// 加密后的
    func encryptPath(_ path: String) -> String {
        LogUtil.log("调用接口=====>" + path)
        if EncryptUtil.openEncrypt { // 加密
            return EncryptUtil.encrypt(path)
        }
        return path
    }

    /// 加密后的
    func encryptTask(_ params: [String: Any]) -> Task {
        if EncryptUtil.openEncrypt { // 加密
            let jsonStr = EncryptUtil.encrypt(params)
            let data = jsonStr.data(using: .utf8)!
            return Task.requestCompositeData(bodyData: data, urlParameters: RequestConfig.getCommenParams())
        } else {
            let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return Task.requestCompositeData(bodyData: data, urlParameters: RequestConfig.getCommenParams())
        }
    }
}
