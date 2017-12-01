//
//  QuestionnaireTabViewController.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 4/12/17.
//
//
// THIS CLASS IS FOR QUESTIONNAIRE SUBMISSION.

import Foundation
import UIKit
class QuestionnaireTabViewController: UITableViewController {
    
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var baseMessage: String?
    var bfq : BreastfeedingQuestionnaire = BreastfeedingQuestionnaire()
    let patientID : String = Utilities.patientID
    
    let fileSystem: FileSystem = FileSystem()
    
    public var questionnaireID: String?
    public var questionnaireLastDate: String?
    public var milkPreviousAnswer: Bool?
    public var stoolPreviousAnswer: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply default choice selection
        self.hasMilkComeInNo.isChecked = true
        self.isStoolMustardNo.isChecked = true
        
        // NOTE: this isn't saying did milk get answered
        // true previosly, it represents the actual
        // answer from last time
        if (self.milkPreviousAnswer == true){
            self.MilkComeInChoicesCell.isHidden = true
            self.MilkComeInQuestionCell.isHidden = true
            self.hasMilkComeInYes.isEnabled = false
            self.hasMilkComeInNo.isEnabled = false
            
            hasMilkComeInYes.isChecked = self.milkPreviousAnswer!
        }
        
        if (self.stoolPreviousAnswer == true){
            self.StoolChoicesCell.isHidden = true
            self.StoolQuestionCell.isHidden = true
            self.isStoolMustardYes.isEnabled = false
            self.isStoolMustardNo.isEnabled = false
            
            isStoolMustardYes.isChecked = self.stoolPreviousAnswer!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Reformat Questionnaire Table
        
        // Shift the submit btn up one if the stool question was answered
        // else shift the submit btn and the stool qeustion up one.
        if (self.milkPreviousAnswer == false && self.stoolPreviousAnswer == true){
            let IndexSubmitBtn = IndexPath(row: 5, section: 0)
            
            let IndexSubmitBtnto = IndexPath(row: 3, section: 0)
            
            self.tableView.moveRow(at: IndexSubmitBtn, to: IndexSubmitBtnto)
        
        } else if(self.milkPreviousAnswer == true && self.stoolPreviousAnswer == false){
            let indexSQ = IndexPath(row: 3, section: 0)
            let indexSC = IndexPath(row: 4, section: 0)
            
            let IndexSubmitBtn = IndexPath(row: 5, section: 0)
            
            let indexSQto = IndexPath(row: 1, section: 0)
            let IndexSCto = IndexPath(row: 2, section: 0)
            let IndexSubmitBtnto = IndexPath(row: 3, section: 0)
            
            self.tableView.moveRow(at: indexSQ, to: indexSQto)
            self.tableView.moveRow(at: indexSC, to: IndexSCto)
            self.tableView.moveRow(at: IndexSubmitBtn, to: IndexSubmitBtnto)
        }
    }
    
    func enableSubmit() -> Bool{
        if((hasMilkComeInYes.isChecked  || hasMilkComeInNo.isChecked) && (isStoolMustardYes.isChecked || isStoolMustardNo.isChecked)){
            return true
        }
        else{
            return false
        }
    }
    @IBOutlet weak var MilkComeInQuestionCell: UITableViewCell!
    @IBOutlet weak var MilkComeInChoicesCell: UITableViewCell!
    @IBOutlet weak var StoolQuestionCell: UITableViewCell!
    @IBOutlet weak var StoolChoicesCell: UITableViewCell!
    
    
    @IBOutlet weak var hasMilkComeInYes: CheckBox!
    @IBOutlet weak var hasMilkComeInNo: CheckBox!
    @IBOutlet weak var isStoolMustardYes: CheckBox!
    @IBOutlet weak var isStoolMustardNo: CheckBox!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func HasMilkComeInYes(_ sender: CheckBox) {
        hasMilkComeInYes.isChecked = !hasMilkComeInYes.isChecked
        hasMilkComeInNo.isChecked = false
    }

    @IBAction func HasMilkComeInNo(_ sender: CheckBox) {
        hasMilkComeInNo.isChecked = !hasMilkComeInNo.isChecked
        hasMilkComeInYes.isChecked = false
    }
 
    @IBAction func IsStoolMustardYes(_ sender: Any) {
        isStoolMustardYes.isChecked = !isStoolMustardYes.isChecked
        isStoolMustardNo.isChecked = false
    }
    
    @IBAction func IsStoolMustardNo(_ sender: Any) {
        isStoolMustardNo.isChecked = !isStoolMustardNo.isChecked
        isStoolMustardYes.isChecked = false
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
        
            bfq.patientID = patientID
            bfq.hasMilkComeIn = hasMilkComeInYes.isChecked
            bfq.isStoolMustard = isStoolMustardYes.isChecked
            
            var jsonString :String
            
            if(self.questionnaireID == nil){
                jsonString = JSONGenerator.GenerateDailyQuestionnaireJson(patientID: bfq.patientID, hasMilkComeIn: bfq.hasMilkComeIn, isStoolMustard: bfq.isStoolMustard)!
            } else {
                jsonString = JSONGenerator.GenerateDailyQuestionnaireJsonWithTestID(patientID: bfq.patientID, testID: self.questionnaireID!, hasMilkComeIn: bfq.hasMilkComeIn, isStoolMustard: bfq.isStoolMustard)!
            }
            
            let jsonDic = Utilities.ConvertToDictionary(text: jsonString)
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDic)
            
            var url: URL
            
            if(self.questionnaireID == nil){
                url = URL(string: Utilities.QUESTIONNAIRE_RESPONSE_URL+"/")!
            } else {
                url = URL(string: Utilities.GetQuestionnaireResponseURL(questionnaireID: self.questionnaireID!))!
            }

            var request = URLRequest(url: url)
            
            if(self.questionnaireID == nil){
                request.httpMethod = "POST"
            } else {
                request.httpMethod = "PUT"
            }
            
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
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "BFTabBarController")
            self.present(controller, animated: true, completion: nil)
            
            task.resume()
            self.showAlertMsg("Result",message: "Succesfully sumbitted", time: 5)
            
        }else{
            self.showAlertMsg("Result",message: "Please answer all questions", time: 5)
        }
    }
}
