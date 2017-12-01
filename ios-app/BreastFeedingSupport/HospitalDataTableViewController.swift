//
//  HospitalDataTableViewController.swift
//  BreastFeedingSupport
//
//  Created by Justin Kristensen on 10/27/17.
//

import UIKit

class HospitalDataTableViewController: UITableViewController {

    //variables for alerts
    var alertController: UIAlertController?
    var baseMessage: String?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var diabetesLabel: UILabel!
    @IBOutlet weak var polyOvarianLabel: UILabel!
    @IBOutlet weak var glandularLabel: UILabel!
    @IBOutlet weak var breastSurgeryLabel: UILabel!
    @IBOutlet weak var hyperthyroidLabel: UILabel!
    @IBOutlet weak var hypothyroidLabel: UILabel!
    @IBOutlet weak var postpartumHLabel: UILabel!
    @IBOutlet weak var gestationalLabel: UILabel!
    @IBOutlet weak var obesityLabel: UILabel!
    @IBOutlet weak var cysticFibLabel: UILabel!
    @IBOutlet weak var depressionLabel: UILabel!
    @IBOutlet weak var agalactiaLabel: UILabel!
    @IBOutlet weak var supervisionLabel: UILabel!
    @IBOutlet weak var extractionFailedLabel: UILabel!
    @IBOutlet weak var outcomeLabel: UILabel!
    
    
    @IBOutlet weak var babyNameLabel: UILabel!
    @IBOutlet weak var babyBirthTimeLabel: UILabel!
    @IBOutlet weak var babyBirthWeightLabel: UILabel!
    
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var dischargeWeightLabel: UILabel!

    
    @IBAction func SendDataBtnPressed(_ sender: Any) {
        self.showConsentAlertMsg("Alert", message: "You're about to send your Patient Data to the pediatrician. Are you sure you want to send your data?")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Check for hospital data on the server.
        self.UpdateViewLabelValues()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UpdateViewLabelValues(){
        let fs = FileSystem()
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_FILENAME))
        {
            print("PATIENT FILE FOUND")
            let patientInfo = fs.ExtractPatientNameAge()
            self.nameLabel.text = patientInfo[0]
            self.ageLabel.text = patientInfo[1]
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_BMI_FILENAME))
        {
            print("BMI FILE FOUND")
            self.bmiLabel.text = fs.ExtractPatientBMI()
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_DIABETES_FILENAME))
        {
            print("DIABETES FILE FOUND")
            self.diabetesLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_POLYOVARIAN_FILENAME))
        {
            print("POLYOVARIAN FILE FOUND")
            self.polyOvarianLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_GLANDULAR_FILENAME))
        {
            print("GLANDULAR FILE FOUND")
            self.glandularLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_BREAST_SURGERY_FILENAME))
        {
            print("PATHOLOGY AND SURGERY FILE FOUND")
            self.breastSurgeryLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_BABY_FILENAME))
        {
            print("BABY PATIENT FILE FOUND")
            let babyInfo = fs.ExtractBabyNameBirthTime()
            self.babyNameLabel.text = babyInfo[0]
            self.babyBirthTimeLabel.text = babyInfo[1]
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_BIRTH_WEIGHT_FILENAME))
        {
            print("BIRTH WEIGHT FILE FOUND")
            self.babyBirthWeightLabel.text = fs.ExtractBabyBirthWeight()
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_DELIVERY_FILENAME))
        {
            print("DELIVERY FILE FOUND")
            self.deliveryLabel.text = fs.ExtractDelivery()
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_DISCHARGE_WEIGHT_FILENAME))
        {
            print("DISCHARGE WEIGHT FILE FOUND")
            self.dischargeWeightLabel.text = fs.ExtractDischargeWeight()
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_HYPERTHYROIDISM_FILENAME))
        {
            print("HYPERTHYROIDISM FILE FOUND")
            self.hyperthyroidLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_HYPOTHYROIDISM_FILENAME))
        {
            print("HYPOTHYROIDISM FILE FOUND")
            self.hypothyroidLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_POSTPARTUM_HEMORRHAGE_FILENAME))
        {
            print("POSTPARTUM_HEMORRHAGE FILE FOUND")
            self.postpartumHLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_GESTATIONAL_HYPERTENSION_FILENAME))
        {
            print("GESTATIONAL_HYPERTENSION FILE FOUND")
            self.gestationalLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_OBESITY_FILENAME))
        {
            print("OBESITY FILE FOUND")
            self.obesityLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_CYSTIC_FIBROSIS_FILENAME))
        {
            print("CYSTIC_FIBROSIS FILE FOUND")
            self.cysticFibLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_DEPRESSION_FILENAME))
        {
            print("DEPRESSION FILE FOUND")
            self.depressionLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_AGALACTIA_FILENAME))
        {
            print("AGALACTIA FILE FOUND")
            self.agalactiaLabel.text = "Yes"
        }
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_FAILED_EXTRACTION_FILENAME))
        {
            print("FAILED EXTRACTION FILE FOUND")
            self.extractionFailedLabel.text = "Yes"
        }
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_SUPERVISION_LACTATE_FILENAME))
        {
            print("SUPERVISION FILE FOUND")
            self.supervisionLabel.text = "Yes"
        }
        
        if(fs.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_DELIVERY_OUTCOME_FILENAME))
        {
            print("DELIVERY OUTCOME FILE FOUND")
            let outcomeInfo = fs.ExtractDeliveryOutcome()
            self.outcomeLabel.text = outcomeInfo
        }
    }
    
    //alert after submit button is pressed
    func showConsentAlertMsg(_ title: String, message: String) {
        
        guard (self.alertController == nil) else {
            print("Alert already displayed")
            return
        }
        
        self.baseMessage = message
        
        self.alertController = UIAlertController(title: title, message: self.baseMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Consent Alert was cancelled")
            self.alertController=nil;
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            print("Consent Alert accepted")
            let result = self.SendPatientDataToFHIRServer()
            self.alertController=nil;
        }
        
        self.alertController!.addAction(cancelAction)
        self.alertController!.addAction(submitAction)

        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    func SendPatientDataToFHIRServer()->Bool{
        let fs = FileSystem()
        fs.BeginUploadEHRDataProcedure()
//        fs.UploadEHRDataFromHospitalServer()
        // For each json file. Verify if it's on the server or not.
        
        // If it's on the server, then just update it.
        
        // If it's not on the server, then just add it
        
        return false
    }
}
