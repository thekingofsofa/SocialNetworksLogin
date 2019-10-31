#  Three In One Login App
To add Google Auth:

https://developers.google.com/identity/sign-in/ios/start-integrating

• Set up Google CocoaPods dependencies
• Get an OAuth client ID
• Add a URL scheme to your project

Then open AppDelegate file and import GoogleSignIn library:
```
import GoogleSignIn
```
Configure the GIDSignIn shared instance and set the sign-in delegate in application(_:didFinishLaunchingWithOptions:) method:
```
GIDSignIn.sharedInstance().clientID = YourClientID
```
And add this method to handle authentitication url:
```
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
return GIDSignIn.sharedInstance().handle(url)
}
```

After completing those steps, you will need to copy GoogleAuthManager files to your project.

To add Facebook Auth:

https://developers.facebook.com/docs/facebook-login/ios/

• Set up Facebook CocoaPods dependencies
• Register and Configure Your App with Facebook
• Add a URL scheme to your project

Then open AppDelegate file and import GoogleSignIn library:
```
import FacebookCore
```
Add this line in application(_:didFinishLaunchingWithOptions:) method:
```
ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
```
And return option to handle authentitication url:
```
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    if ApplicationDelegate.shared.application(app, open: url, options: options) {
        return true
    } else if GIDSignIn.sharedInstance().handle(url) {
        return true
    }
    return false
}
```

