//
//  CreateGroupViewController.swift
//  quikvid
//
//  Created by Gordon Moore on 12/23/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let groupName = groupNameTextField.text,
            !groupName.isEmpty else { return }
        
        let currentUID = User.current.uid
        
        let groupData = ["users/\(currentUID)/groups/\(groupName)" : currentUID,
                          "groups/\(currentUID)/\(groupName)/members/\(currentUID)" : "true"]
        
        let ref = Database.database().reference()
        ref.updateChildValues(groupData)
        
        self.performSegue(withIdentifier: "toAddMembers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "toAddMembers" {
            let vc = segue.destination as! AddMembersViewController
            vc.group = groupNameTextField.text!
            self.groupNameTextField.text = nil
        }
        
    }
}
