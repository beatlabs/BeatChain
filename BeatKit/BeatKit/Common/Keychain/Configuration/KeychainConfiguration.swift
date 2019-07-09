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

@objcMembers
public class KeychainConfiguration {

    /// A key whose value is a string indicating the item's service.
    static let serviceName = ""

    /// An access group is a logical collection of apps tagged with a particular group name string.
    /// Remember that the app and the extensions must have the same AppID in order to have a shared keychain
    static let accessGroup = ""
}
