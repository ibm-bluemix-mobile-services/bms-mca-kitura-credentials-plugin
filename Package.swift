import PackageDescription

let package = Package(
    name: "MobileClientAccessKituraCredentialsPlugin",
	dependencies:[
		.Package(url: "https://github.com/ibm-bluemix-mobile-services/bms-mca-serversdk-swift.git", majorVersion: 0, minor: 6),
		.Package(url: "https://github.com/IBM-Swift/Kitura-Credentials.git", majorVersion: 1, minor: 6)
	]
)
