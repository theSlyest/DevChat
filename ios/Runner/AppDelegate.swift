import UIKit
import Flutter
//import G

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
//    GMSPlacesClient.provideApiKey("AIzaSyCmwp39gsOOET1A0i8edyZVhqCzAYRbhrE")
//    GMSSServices.provideApiKey("AIzaSyCmwp39gsOOET1A0i8edyZVhqCzAYRbhrE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
