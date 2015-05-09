//
//  ViewController.swift
//  RealmFire
//
//  Created by shoya on 5/9/15.
//  Copyright (c) 2015 com.moru. All rights reserved.
//

import UIKit
import RealmSwift

class Note: Object {
    dynamic var id = "3"
    dynamic var body = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    private var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField("init")
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField){
        println("textFieldDidBeginEditing: \(textField.text)")
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
        let firebaseUrl = "https://realmfire.firebaseio.com/note"
        var firebaseRef = Firebase(url:firebaseUrl)
    
        var realm = Realm(path: "/Users/shoya/Documents/RealmFire/db.realm")
        
        let note = Note()
        note.id = "1"
        note.body = textField.text
        
        
        // 'The Realm is already in a write transaction' が発生する
        /*
        realm.beginWrite()
        realm.add(note, update: true)
        
        firebaseRef.setValue(textField.text, withCompletionBlock: {
            (error:NSError?, ref:Firebase!) in
            if (error != nil) {
                realm.cancelWrite()
                println("could not be saved.")
            } else {
                realm.commitWrite()
                println("saved successfully!")
            }
        })
        */
        
        // とりあえずこれ
        realm.write { () -> Void in
            realm.add(note, update: true)
        }
        
        firebaseRef.setValue(textField.text)

        return true;
    }
    
    func setupTextField(body: String) {
        
        textField = UITextField(frame: CGRectMake(0,0,300,100))
        textField.text = body
        textField.delegate = self
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.layer.position = CGPoint(x:self.view.bounds.width/2,y:100);
        self.view.addSubview(textField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

