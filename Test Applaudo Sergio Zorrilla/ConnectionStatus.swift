//
//  ConnectionStatus.swift
//  Test Applaudo Sergio Zorrilla
//
//  Created by Sergio Eduardo Zorrilla Arellano on 19/08/17.
//  Copyright © 2017 Bodoque Inc. All rights reserved.
//

import Foundation
import SystemConfiguration

protocol Utilities {
}

extension NSObject:Utilities{
    enum ConnectionStatus{
        case notReachable
        case reachableViaWWAN
        case reachableViaWifi
    }
    
    var currentReachabilityStatus: ConnectionStatus{
        var zeroAdsress = sockaddr_in()
        zeroAdsress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAdsress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAdsress, { $0.withMemoryRebound(to: sockaddr.self, capacity: 1){
            SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })else{
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags){
            return .notReachable
        }else if flags.contains(.reachable) == false {
            return .reachableViaWWAN
        }else if flags.contains(.connectionRequired) == false {
            return .reachableViaWifi
        }else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true && flags.contains(.interventionRequired) == false){
            return .reachableViaWifi
        }else{
            return .notReachable
        }
    }
}
