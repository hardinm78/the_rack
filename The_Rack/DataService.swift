//
//  DataService.swift
//  The_Rack
//
//  Created by Michael Hardin on 4/5/16.
//  Copyright © 2016 Michael Hardin. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()
    
    
    private var _REF_BASE = Firebase(url: "https://the-rack.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}