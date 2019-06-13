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

public enum KeychainManagerError: Error {
    case noItemFound
    case unexpectedData
    case unhandledError(status: OSStatus)
}

public protocol KeychainManagerInterface {
    func readValue(_ item: Queryable) throws -> String
    func saveValue(_ value: String, to item: Queryable) throws
    func deleteItem(_ item: Queryable) throws
}

public class KeychainManager: KeychainManagerInterface {
    
    private let keychain: KeychainInterface
    
    // MARK: - Interface
    
    public init(keychain: KeychainInterface = Keychain()) {
        self.keychain = keychain
    }
    
    // MARK: - public interface
    
   public func readValue(_ item: Queryable) throws -> String {
        
        // Build a query
        var query = item.query
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        let keychainResponse = keychain.fetch(query)
        
        // Check the return status and throw an error if appropriate.
        guard keychainResponse.status != errSecItemNotFound else {
            BKLogDebug("Item not found", extended: true, category: .keychain)
            throw KeychainManagerError.noItemFound
        }
        
        guard keychainResponse.status == noErr else {
            BKLogError("Error getting item: \(keychainResponse.status)", extended: true, category: .keychain)
            throw KeychainManagerError.unhandledError(status: keychainResponse.status)
        }
        
        // Parse the string value from the query result.
        guard let existingItem = keychainResponse.queryResult as? [String : AnyObject],
            let data = existingItem[kSecValueData as String] as? Data,
            let value = String(data: data, encoding: String.Encoding.utf8) else {
                BKLogError("Invalid item format", extended: true, category: .keychain)
                throw KeychainManagerError.unexpectedData
        }
        
        BKLogDebug("Value has been read successfully", extended: true, category: .keychain)
        return value
    }
    
    public func saveValue(_ value: String, to item: Queryable) throws {
        
        // Encode the value into a Data object.
        let encodedValue = value.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = readValue(item)
            
            // Update the existing item with the new password.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedValue as AnyObject?
            
            let status = keychain.update(item.query, with: attributesToUpdate)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else {
                BKLogError("Error getting item: \(status)", extended: true, category: .keychain)
                throw KeychainManagerError.unhandledError(status: status)
            }
            BKLogDebug("Value has saved successfully", extended: true, category: .keychain)
        }
        catch KeychainManagerError.noItemFound {
            
            // No item was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = item.query
            newItem[kSecValueData as String] = encodedValue as AnyObject?
            
            // Add the new item to the keychain.
            let status = keychain.add(newItem)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else {
                BKLogError("Error getting item: \(status)", extended: true, category: .keychain)
                throw KeychainManagerError.unhandledError(status: status)
            }
            BKLogDebug("Value has been saved successfully", extended: true, category: .keychain)
        }
    }
    
    /// Delete all keychain items that match a specific item's query
    public func deleteItem(_ item: Queryable) throws {
        
        // Delete the existing item(s) from the keychain.
        let status = keychain.delete(item.query)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else {
            BKLogError("Error getting item: \(status)", extended: true, category: .keychain)
            throw KeychainManagerError.unhandledError(status: status)
        }
        BKLogDebug("Item has been deleted successfully", extended: true, category: .keychain)
    }
}
