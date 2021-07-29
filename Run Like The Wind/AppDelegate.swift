
import UIKit
import Firebase
import GoogleSignIn
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //configure firebase
        FirebaseApp.configure()
        
        //configure google auth
        //GIDSignIn.sharedInstance().clientID = "372680810112-q3cdnfav1bfleq1jhata5msai43hd4kn.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "372680810112-q3cdnfav1bfleq1jhata5msai43hd4kn.apps.googleusercontent.com"
        
        //configure google map services
        GMSServices.provideAPIKey("AIzaSyCUv8CAmo7oQaNY1r-hstQIVPjd-Gt5Zrc")
        
        StatisticsDBAccess.instance.getStatisticsScore()
        //tab bar settings
        UITabBar.appearance().barTintColor = .green
        UITabBar.appearance().tintColor = .black
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK: Google sign in
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    //for iOS < 9.0
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let user = user{
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            
              Auth.auth().signIn(with: credential, completion: {autoResult, error in
                  if let error = error {
                    print(error)
                    return
                  }
              })
            UserDefaults.standard.set(true, forKey: Constants.LOGIN) //Bool
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }
    
    }


    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        UserDefaults.standard.set(false, forKey: Constants.LOGIN) //Bool
    }
    

}

