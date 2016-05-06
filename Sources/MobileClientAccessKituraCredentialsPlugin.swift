/*
* Copyright 2015 IBM Corp.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
* http://www.apache.org/licenses/LICENSE-2.0
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation
import SimpleLogger
import Kitura
import Credentials
import MobileClientAccess

public class MobileClientAccessKituraCredentialsPlugin: CredentialsPluginProtocol {
	
	private static let AUTH_HEADER = "Authorization";
	
	private let logger = Logger(forName: "MobileClientAccessCredentialsPlugin")
	
	public var name: String {
		return "MobileClientAccess"
	}

	public var type: CredentialsPluginType{
		return CredentialsPluginType.Token
	}

	#if os(Linux)
		public var usersCache : NSCache?
	#else
		public var usersCache : NSCache<NSString, BaseCacheElement>?
	#endif


	public func authenticate(request: RouterRequest, response: RouterResponse, options: [String : OptionValue], onSuccess: (UserProfile) -> Void, onFailure: () -> Void, onPass: () -> Void, inProgress: () -> Void) {
		logger.debug("authenticate")

		let authHeader = request.headers[MobileClientAccessKituraCredentialsPlugin.AUTH_HEADER]

		MobileClientAccessSDK.sharedInstance.authorizationContext(from: authHeader) { error, authContext in
			if error != nil{
				self.logger.debug("authenticate :: failure")
				response.setHeader("WWW-Authenticate", value: "Bearer realm=\"imfAuthentication\"")
				response.status(.UNAUTHORIZED)
				_ = try? response.end("Unauthorized")
			} else {
				request.userInfo["mcaAuthContext"] = authContext
				if let userId = authContext?.userIdentity?.id,
					let displayName = authContext?.userIdentity?.displayName,
					let provider = authContext?.userIdentity?.authBy {
					self.logger.debug("authenticate :: success")
					let userProfile = UserProfile(id: userId, displayName: displayName, provider: provider)
					onSuccess(userProfile)
				} else {
					self.logger.debug("authenticate :: failure")
					onFailure()
				}
			}
		}
	}
}
