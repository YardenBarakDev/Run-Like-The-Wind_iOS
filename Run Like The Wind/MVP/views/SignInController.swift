
import UIKit
import GoogleSignIn
import Firebase

class SignInController: UIViewController{
  
    @IBOutlet var GoogleSignInButton: GIDSignInButton!
    private let presenter = SigninPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //GIDSignIn.sharedInstance().signIn()

        if (UserDefaults.standard.bool(forKey: Constants.LOGIN)) {
            moveToMainScreen()
        }
        
    }
    
    func moveToMainScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
      withError error: NSError!) {
        if (error == nil) {
         print("user error")
        } else {
          print("user \(error.localizedDescription)")
        }
    }
    
}



//MARK: SignInPresenterDelegate callback
extension SignInController : SignInPresenterDelegate{
    
    func returnedResult(result: String) {
        if(result == Constants.SUCCESS){
            moveToMainScreen()
            print("user login success")
        }else{
            print("user \(result) to connect to server")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
          withError error: Error!) {
        if let error = error {
            print("user \(error.localizedDescription)")
        } else {
            print("user sign in sign")
          moveToMainScreen()
        }
    }
}

/*
 // after user has successfully logged out

let storyboard = UIStoryboard(name: "Main", bundle: nil)
let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")

(UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
 */
