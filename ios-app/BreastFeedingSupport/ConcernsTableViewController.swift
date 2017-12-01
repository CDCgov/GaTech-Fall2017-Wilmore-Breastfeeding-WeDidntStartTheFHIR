//
//  ConcernsTableViewController.swift
//  BreastFeedingSupport
//
//  Created by Justin Kristensen on 10/27/17.
//

import UIKit

class ConcernsTableViewController: UITableViewController {

    
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var baseMessage: String?
    var concernData : BreastFeedingConcerns = BreastFeedingConcerns()
    let patientID : String = Utilities.patientID
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //submitButton.isEnabled = false
        
    }
    
    func enableSubmit() -> Bool{
        if(concerns.hasText){
            return true
        }
        else{
            return false
        }
    }
  
    @IBOutlet weak var concerns: UITextView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAlertMsg(_ title: String, message: String, time: Int) {
        
        guard (self.alertController == nil) else {
            print("Alert already displayed")
            return
        }
        
        self.baseMessage = message
        self.remainingTime = time
        
        self.alertController = UIAlertController(title: title, message: self.baseMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            print("Alert was cancelled")
            self.alertController=nil;
            self.alertTimer?.invalidate()
            self.alertTimer=nil
        }
        
        self.alertController!.addAction(cancelAction)
        
        self.alertTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    func countDown() {
        
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.alertController!.dismiss(animated: true, completion: {
                self.alertController = nil
            })
        } else {
            self.alertController!.message = self.alertMessage()
        }
        
    }
    
    func alertMessage() -> String {
        var message=""
        if let baseMessage=self.baseMessage {
            message=baseMessage+" "
        }
        return(message+"\(self.remainingTime)")
    }

    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submitAction(_ sender: Any) {
        let canSubmit : Bool = enableSubmit()
        if(canSubmit){
        
            concernData.patientID = patientID
            concernData.concerns = concerns.text ?? ""
            
            let jsonString = JSONGenerator.GenerateConcernJson(patientID: concernData.patientID, concerns: concernData.concerns )
            
            let jsonDic = Utilities.ConvertToDictionary(text: jsonString)
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDic)
            let url = URL(string: Utilities.QUESTIONNAIRE_RESPONSE_URL+"/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            
            task.resume()
            self.showAlertMsg("Result",message: "Succesfully sumbitted", time: 5)
        }else{
            self.showAlertMsg("Result",message: "Please answer all questions", time: 5)
        }
    }
}

