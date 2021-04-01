//
//  MainViewController.swift
//  Friends
//
//  Created by Gorazd Kunej on 01/04/2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var containerView: UIView!
    
    private lazy var mapViewController: MapViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController

        return viewController
    }()
    
    private lazy var friendsViewController: FriendsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController


        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 0
        updateView()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func segmentControlValueChanged(_ sender: Any) {
        updateView()
    }
}

// MARK: - Handling segment control and switching between child views
extension MainViewController {
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: friendsViewController)
            add(asChildViewController: mapViewController)
        } else {
            remove(asChildViewController: mapViewController)
            add(asChildViewController: friendsViewController)
        }
    }
    
    private func remove(asChildViewController viewController: UIViewController) {

        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
            // call before adding child view controller's view as subview
            addChild(viewController)
            
            viewController.view.frame = containerView.bounds
            containerView.addSubview(viewController.view)
            
            // call before adding child view controller's view as subview
        viewController.didMove(toParent: self)
    }
}
