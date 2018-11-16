//
//  Network.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift
import RxCocoa

class Network {
    
    static let shared = Network()
    
    func get(url: String, params: [String: Any]?) -> Single<Data> {
        return Observable.create({ operation in
            do {
                let convertedURL = try url.asURL()
                
                let nextHandler: (HTTPURLResponse, Any) -> Void = { res, data in
                    do {
                        let rawData = try JSONSerialization.data(withJSONObject: data, options: [])
                        operation.onNext(rawData)
                        operation.onCompleted()
                    } catch {
                        let error = NSError(domain: "failed JSONSerialization",
                                            code: 0,
                                            userInfo: nil)
                        operation.onError(error)
                    }
                }
                
                let errorHandler: (Error) -> Void = { error in
                    operation.onError(error)
                }
                
                
                _ = RxAlamofire.requestJSON(.get,
                                            convertedURL,
                                            parameters: params,
                                            encoding: URLEncoding.default,
                                            headers: nil)
                    .subscribe(onNext: nextHandler,
                               onError: errorHandler)
                
            } catch {
                let error = NSError(domain: "failed convert url",
                                    code: 0,
                                    userInfo: nil)
                operation.onError(error)
            }
            
            return Disposables.create()
        }).asSingle()
    }
}
