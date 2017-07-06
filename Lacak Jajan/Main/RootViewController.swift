//
//  RootViewController.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 5/2/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        
    
        if let _ = UserDefaults.standard.object(forKey: "userzat") {
            performSegue(withIdentifier: "taskSegue", sender: self)
        } else {
            
            performSegue(withIdentifier: "splashSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "splashSegue" {
            let _ = segue.destination as! SplashViewController
        }
        else {
            let tabCtrl = segue.destination as! UITabBarController
            let vc1 = tabCtrl.viewControllers![0] as! UINavigationController
            vc1.title = "Home"
            
            let vc2 = tabCtrl.viewControllers![1] as! UINavigationController
            vc2.title = "History"
            
            let vc3 = tabCtrl.viewControllers![2] as! UINavigationController
            vc3.title = "Other"
        }
        
    }
}
