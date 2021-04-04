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

enum ActiveWindow {
    case mapView
    case listView
}

class MainViewController: UIViewController {
    @IBOutlet var segmentedControl: SkratchSegmentControl!
    @IBOutlet var containerView: UIView!
    @IBOutlet var friendsNumTextField: UITextField!
    
    var mapViewController: MapViewController?
    var friendsViewController: FriendsViewController?
    var customkeyboardView : KeyboardAccessoryView?
    
    var activeWindow: ActiveWindow = .mapView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeChildViewControllers()
        initializeSegmentControl()
        initializeTextField()
        updateView()
    }
    
    private func initializeChildViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        friendsViewController = storyboard.instantiateViewController(withIdentifier: "FriendsViewController") as? FriendsViewController
    }
    
    private func initializeSegmentControl() {
        guard let img1 = UIImage(named: "map"),
              let img2 = UIImage(named: "list") else {
            return
        }
        
        segmentedControl.items = [img1, img2]
        segmentedControl.borderColor = .white
        segmentedControl.selectedImageColor = UIColor.skratch.purple
        segmentedControl.unselectedImageColor = UIColor.skratch.paleBlue
        segmentedControl.backgroundColor = .white
        segmentedControl.thumbColor = UIColor.skratch.paleBlue
        segmentedControl.padding = 7
        segmentedControl.selectedIndex = 0
        
        segmentedControl.addShadow(shadowColor: UIColor.black.cgColor,
                                   shadowOffset: CGSize(width: 1, height: 2),
                                   shadowOpacity: 0.15,
                                   shadowRadius: 8)
        
        segmentedControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
    }
    
    private func initializeTextField() {
        customkeyboardView = KeyboardAccessoryView.fromNib()
        customkeyboardView?.sizeToFit()
        customkeyboardView?.delegate = self
        friendsNumTextField.inputAccessoryView = customkeyboardView
        friendsNumTextField.addTarget(self, action: #selector(MainViewController.textFieldDidChange(_:)), for: .editingChanged)
        friendsNumTextField.delegate = self
        
        friendsNumTextField.addShadow(shadowColor: UIColor.black.cgColor,
                                   shadowOffset: CGSize(width: 1, height: 2),
                                   shadowOpacity: 0.15,
                                   shadowRadius: 8)
    }

    @IBAction func segmentControlValueChanged(_ sender: Any) {
        updateView()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        customkeyboardView?.textLabel.text = textField.text
    }
}

// MARK: - Handling segment control and switching between child views
extension MainViewController {
    
    private func updateView() {
        if segmentedControl.selectedIndex == 0 {
            activeWindow = .mapView
            remove(asChildViewController: friendsViewController!)
            add(asChildViewController: mapViewController!)
        } else {
            activeWindow = .listView
            remove(asChildViewController: mapViewController!)
            add(asChildViewController: friendsViewController!)
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
        let panelController = FloatingPanelController()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let contentVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as? UserDetailsViewController
            else {
                return
        }
        
        contentVC.loadViewIfNeeded()
        panelController.set(contentViewController: contentVC)
        panelController.delegate = self
        contentVC.populateUser(user)

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

extension MainViewController: KeyboardAccessoryDelegate {
    func finishEditing() {
        friendsNumTextField.resignFirstResponder()
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        customkeyboardView?.textLabel.text = textField.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              let number = Int(text) else {
            return
        }
        
        UsersModel.shared.getUsers(count: number) {  (result) in
            if case let .success(users) = result {
                DispatchQueue.main.async {
                    if self.activeWindow == .mapView {
                        self.mapViewController?.addAnotations()
                    } else {
                        self.friendsViewController?.tableView.reloadData()
                    }
                }
                print("Friends users: \(users)")
            }
        }
    }
}
