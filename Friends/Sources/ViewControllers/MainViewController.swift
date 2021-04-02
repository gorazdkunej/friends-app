//
//  MainViewController.swift
//  Friends
//
//  Created by Gorazd Kunej on 01/04/2021.
//

import UIKit
import FloatingPanel

protocol MainViewDelegate {
    func openPanel(for user: User)
}

class ContainerChildViewController: UIViewController {
    var delegate: MainViewDelegate?
}

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
    }

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
    
    private func remove(asChildViewController viewController: ContainerChildViewController) {

        viewController.willMove(toParent: nil)
        viewController.delegate = nil
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func add(asChildViewController viewController: ContainerChildViewController) {
            
        addChild(viewController)
        viewController.delegate = self
            
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
            
        viewController.didMove(toParent: self)
    }
}

extension MainViewController: MainViewDelegate {
    func openPanel(for user: User) {
        print(user)
        let panelController = FloatingPanelController()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        guard let contentVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as? UserDetailsViewController
            else {
                return
        }
        
        contentVC.loadViewIfNeeded()
        panelController.set(contentViewController: contentVC)
        panelController.delegate = self

        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 38.5
        panelController.surfaceView.appearance = appearance
        panelController.backdropView.dismissalTapGestureRecognizer.isEnabled = true

        panelController.isRemovalInteractionEnabled = true

        self.present(panelController, animated: true, completion: nil)
    }
}

extension MainViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, contentOffsetForPinning trackingScrollView: UIScrollView) -> CGPoint {
        return CGPoint(x: 0.0, y: 0.0 - trackingScrollView.contentInset.top)
    }

    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return ModalPanelLayout()
           
    }
}

class ModalPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full

    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: 0.0, referenceGuide: .safeArea),
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.3
    }
}
