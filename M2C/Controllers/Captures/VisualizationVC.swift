//
//  VisualizationVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 14/06/2022.
//

import UIKit
import SceneKit
//import ARKit

class VisualizationVC: BaseVC {
    
//    @IBOutlet weak var lblNote: UILabel!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var lblProcessing: UILabel!
//    @IBOutlet weak var sceneView: ARSCNView!
//    var scnScene = SCNScene()
//    var node: SCNNode?
//    //visualizationUrl is a url to track where download file is saved
//    var visualizationUrl = URL(string: "")
//    var fileName = Date().DateAndTimeToString()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if let url = URL(string: "https://m2c-media.s3.eu-central-1.amazonaws.com/2022022214221845_018_18_MartinBorgmeier_Driver_7.dae") {
//
//            self.loadFileAsync(url: url) { (path, error) in
//            print("Dae File downloaded to : \(path!)")
//
//            //replacinf already existing file
//            if let resourceUrl = Bundle.main.url(forResource: "animations.scnassets/animation", withExtension: "dae") {
//                if FileManager.default.fileExists(atPath: resourceUrl.path) {
//                        print("file found")
//                        //do stuff
//                    self.configScene(name: self.visualizationUrl!.absoluteString)
////                    do{
////                        self.visualizationUrl!.startAccessingSecurityScopedResource()
////                        resourceUrl.startAccessingSecurityScopedResource()
////                        try FileManager.default.copyItem(at: self.visualizationUrl!, to: resourceUrl)
////                        self.configScene(name: resourceUrl.absoluteString)
////                        self.visualizationUrl!.stopAccessingSecurityScopedResource()
////                        resourceUrl.stopAccessingSecurityScopedResource()
////                    } catch{
////                        print("Can't copy .dae file in ios swift")
////                    }
//                    }
//                }
//
//        }
//        }
//        self.activityIndicator.startAnimating()
//        self.lblProcessing.text = "Processing your video\nIt might take few minutes"
//        self.lblNote.attributedText = NSMutableAttributedString()
////            .setColorForText("Reminder: ", with: UIColor(hexString: "#006AB3"))
//            .normal("It might take few minutes to analyze your swing you can check your swing under ")
//            .blueForeground("History")
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleHistory(_:)))
//        self.lblNote.addGestureRecognizer(tap)
////        self.downLoadVisualization()
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//
//
//        // Run the view's session
//        sceneView.session.run(configuration)
//        sceneView.backgroundColor = UIColor(red: 0, green: 0, blue: 255.0, alpha: 0.3)
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        Global.shared.selectedCapture = CaptureModel()
////        let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
////        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName).scnassets/\(fileName).dae")
//        do {
//            try FileManager.default.removeItem(atPath: visualizationUrl?.absoluteString ?? "")
//        }
//        catch {
//            print("Error removing file at file ")
//
//        }
//    }
//
//    @objc func handleHistory(_ sender: Any){
//        self.navigateForward(storyBoard: SBRecordings, viewController: recordingHistoryVCID)
//    }
//
//
//
//    func configScene(name: String){
//        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//        //        /Users/mhussain03/Downloads/animate.dae
//        // Create a new scene
//        let scene = SCNScene(named: "animations.scnassets/animation.dae")!
//
//                self.node = scene.rootNode.childNode(withName: "Baserig", recursively: true)
//        self.node?.position = SCNVector3Make(0, 0, -1)
//
//
//        // Set the scene to the view
//        sceneView.scene = scene
//        scene.background.contents = UIColor.blue
//        sceneView.backgroundColor = UIColor(red: 0, green: 0, blue: 255.0, alpha: 0.3)
//
//    }
//
//    func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
//    {
//        //getting .dae link from public url
//        var publicUrl = Global.shared.selectedCapture.publicUrl
//        publicUrl = "djfdfjfh"
//        if !publicUrl.isEmpty{
//
//
//            let resourceUrl = Bundle.main.url(forResource: "animations.scnassets/animation", withExtension: "dae")!
//
//
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            self.fileName = "\(Date()).dae"
//        let destinationUrl = resourceUrl//documentsUrl.appendingPathComponent(self.fileName)
//
//
//        visualizationUrl = destinationUrl
//        if false//FileManager().fileExists(atPath: destinationUrl.path)
//        {
//            print("File already exists [\(destinationUrl.path)]")
//            self.configScene(name: destinationUrl.absoluteString)
//            completion(destinationUrl.path, nil)
//        }
//        else
//        {
//            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            let task = session.dataTask(with: request, completionHandler:
//                                            {
//                data, response, error in
//                if error == nil
//                {
//                    if let response = response as? HTTPURLResponse
//                    {
//                        if response.statusCode == 200
//                        {
//                            if let data = data
//                            {
//                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
//                                {
//                                    completion(destinationUrl.path, error)
//                                }
//                                else
//                                {
//                                    completion(destinationUrl.path, error)
//                                }
//                            }
//                            else
//                            {
//                                completion(destinationUrl.path, error)
//                            }
//                        }
//                    }
//                }
//                else
//                {
//                    completion(destinationUrl.path, error)
//                }
//            })
//            task.resume()
//        }
//        }
//    }
//
//    @IBAction func actionHome(_ sender: Any) {
//        self.popBackToDashboardOptions()
//    }
    
}

//extension VisualizationVC : ARSCNViewDelegate{
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//
//    }
//}
