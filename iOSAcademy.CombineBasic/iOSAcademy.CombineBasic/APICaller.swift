//
//  ApiCaller.swift
//  iOSAcademy.CombineBasic
//
//  Created by 曲奕帆 on 2023/4/5.
//

import Foundation
import Combine

class APICaller {
    static let shared = APICaller()
    
    /// 傳統上，我們會設計類似completion handler的作法，
    /// 讓function執行完成後，執行此completion。
    ///
    /// -Authors: Tomtom Chu
    /// -Date: 2023.4.5
    func fetchData(completion: ([String]) -> Void){}
    
    /// 若採用Combine的作法，將會回傳一個Publisher
    /// (Future是一種Publisher)，
    /// 泛型中第一個參數代表Output的類別型態，
    /// 第二個代表發生錯誤的類別型態。
    ///
    /// -Authors: Tomtom Chu
    /// -Date: 2023.4.5
    func fetchCompanies() -> Future<[String], Error> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                promise(.success(["Apple", "Google", "Microsoft", "Facebook"]))
            }	
        }
    }
    
}
