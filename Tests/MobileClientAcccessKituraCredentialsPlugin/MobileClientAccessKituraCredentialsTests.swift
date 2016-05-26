import XCTest
import Foundation
import Credentials
import Kitura
import KituraNet
import KituraSys

@testable import MobileClientAccessKituraCredentialsPlugin
@testable import MobileClientAccess

class MobileClientAccessKituraCredentialsTests: XCTestCase {

	override func setUp(){
		self.continueAfterFailure = false
	}

	func testMobileClientAccessCredentials(){
		let mcaCredentials = MobileClientAccessKituraCredentialsPlugin()
	 	XCTAssertEqual(mcaCredentials.name, "MobileClientAccess")
		XCTAssertFalse(mcaCredentials.redirecting)
		//doTestServer()
	}
	
	func doTestServer(){
		let credentials = Credentials()
		let mcaCredentials = MobileClientAccessKituraCredentialsPlugin()
		credentials.register(plugin: mcaCredentials)
		
		let router = Router()
		router.all("/public", handler: { (request, response, next) in
			response.status(.OK).send("Hello from a public resource!")
			next()
		})
		router.all("/protected", middleware: credentials)
		router.all("/protected", handler: { (request, response, next) in
			print("in protected")
			let userProfile = request.userProfile
			let authContext = request.userInfo["mcaAuthContext"] as! AuthorizationContext
			
			XCTAssertNotNil(userProfile)
			XCTAssertNotNil(authContext)
			
			response.status(.OK).send("Hello from a protected resource, " + authContext.userIdentity!.id)
			next()
		})
		
		HTTPServer.listen(port: 1234, delegate: router)
		
		Server.run()
	}
}

extension MobileClientAccessKituraCredentialsTests {
	static var allTests : [(String, MobileClientAccessKituraCredentialsTests -> () throws -> Void)] {
		return [
		       	("testMobileClientAccessCredentials", testMobileClientAccessCredentials)
		]
	}
}
