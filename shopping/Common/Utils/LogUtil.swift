//
//  LogUtil.swift
//  shopping
//
//  Created by 李京珂 on 2021/7/19.
//

import Foundation

class LogUtil: NSObject {
    static var Log_Level = 1
    /// 打印日志
    public static func log(_ info: String) {
        #if DEBUG || BATA
            if LogUtil.Log_Level == 1 {
                print("=Log========>\(info)")
            }
        #endif
    }
}
