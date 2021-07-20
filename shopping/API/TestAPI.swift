//
//  TestAPI.swift
//  shopping
//
//  Created by 李京珂 on 2021/7/19.
//

import Foundation
import Moya

let testProvider = MoyaProvider<TestAction>()

enum TestAction {
    // 示例API
    case testAPI(param: [String: Any])
}

extension TestAction: TargetType {
    var baseURL: URL {
        return URL(string: RequestConfig.requestDomain)!
    }
    
    var path: String {
        var detailPath: String = ""
        switch self {
        case .testAPI:
            detailPath = "/panVision/testAPI"
        }
        return encryptPath(detailPath)
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return encryptTask(self.params)
    }
    
    var params: [String: Any] {
        var params: [String: Any] = RequestConfig.getBodyCommenParam()
        switch self {
        case .testAPI(let param):
            for (k, v) in param {
                params[k] = v
            }
        }
        LogUtil.log("params -----\(params)")
        return params
    }
    
    var headers: [String: String]? {
        return ["appVersion": "1.0", "Content-Type": "application/json; charset=utf-8"]
    }
}
