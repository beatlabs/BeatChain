/*
   Copyright 2019 BEAT

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import Foundation

public struct GenericPasswordItem {
    
    // MARK: Properties
    
    let service: String
    let account: String?
    let accessGroup: String?
    
    // MARK: Initializer
    
    public init(service: String, account: String?, accessGroup: String?) {
        
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
}

extension GenericPasswordItem: Queryable {
    
    public var query: [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject
        }
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject
        }
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        return query
    }
}
