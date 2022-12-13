//
//  Device.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 6/3/22.
//

import Foundation

struct Device {
    
    static var isiOS: Bool {
#if os(iOS)
        return  true
#else
        return false
#endif
    }
}
