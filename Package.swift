import PackageDescription

let package = Package(
    name: "MobileClientAccessKituraCredentialsPlugin",
	dependencies:[
		.Package(url: "https://github.com/ibm-bluemix-mobile-services/bms-serversdk-swift-mca.git", majorVersion: 0, minor: 0),
		.Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0, minor: 12),
		.Package(url: "https://github.com/IBM-Swift/Kitura-Credentials.git", majorVersion: 0, minor: 12),
	]
)
