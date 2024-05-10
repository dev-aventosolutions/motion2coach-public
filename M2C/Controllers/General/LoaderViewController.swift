//
// LoaderViewController.swift
//
//
// Created by Abdul Samad on 19/01/2022.
//

import UIKit


class LoaderViewController: UIViewController {
    
    
    var activityView: UIActivityIndicatorView?
    var container: UIView?
    var loadingView: UIView?
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        container = UIView()
        loadingView = UIView()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        showActivityIndicatory(uiView: self.view)
    }
    
    
    // MARK: Show Loader
    func showActivityIndicatory(uiView: UIView) {
        loadingView?.frame = CGRect(x: 0, y: 0, width: 125, height: 110)
        let loadingLabel = UILabel(frame: CGRect(x: 25, y: 70 , width: loadingView!.frame.width, height: 20))
        loadingLabel.text = "Loading..."
        loadingLabel.font = UIFont.systemFont(ofSize: 17)
        loadingLabel.textColor = UIColor.black
        container?.frame = uiView.frame
        container?.center = uiView.center
        container?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // To center the loading view.
        loadingView?.center = CGPoint(x: uiView.frame.size.width / 2,
                                      y: uiView.frame.size.height / 2)
        loadingView?.backgroundColor = UIColor.systemGray6
        loadingView?.clipsToBounds = true
        loadingView?.layer.cornerRadius = 10
        loadingView?.addSubview(loadingLabel)
        activityView?.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        } else {
            // Fallback on earlier versions
            activityView = UIActivityIndicatorView(style: .whiteLarge)
        }
        activityView?.color = .black
        activityView?.center = CGPoint(x: loadingView!.frame.size.width / 2,
                                       y: loadingView!.frame.size.height / 2.5);
        loadingView?.addSubview(activityView!)
        container?.addSubview(loadingView!)
        uiView.addSubview(container!)
        loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView?.startAnimating()
    }
    func stopActivityIndicatory()
    {
        if (activityView != nil)
        {
            container?.removeFromSuperview()
            activityView?.stopAnimating()
            loadingView?.removeFromSuperview()
        }
    }
}
