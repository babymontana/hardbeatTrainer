//
//  NuevaRutinaViewController.swift
//  heartbeatTrainer
//
//  Created by Emmanuel Paez on 02/04/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NuevaRutinaViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
   

    @IBOutlet weak var descripcion: UITextView!
   
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var tipo: UIPickerView!
    
    @IBOutlet weak var duracion: UITextField!
    var fecha:NSDate!
    
    var usuario : Usuario!
    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!

    var type = "crossTraining"
    
    let tituloEjercicios=["Cross Training","Bicicleta","Baile","Maquina elliptica","Gimnacia","Mente y cuerpo","Entrenamiento cardio-metabolidco mixto","Calentamiento y recuperación","correr","nadar","Fuerza tradicional","caminar","Fitness en agua","Yoga","Otro","Barra","Entrenamiento Core","Flexibilidad","Entrenamiento intervalo alta intensidad","Saltar Cuerda","Pilates","Escaleras","Aerobics"]
    let ejercicios=["crossTraining","cycling","dance","elliptical","gymnastics","mindAndBody","mixedMetabolicCardioTraining","preparationAndRecovery","running","swimming","traditionStrengthTraining","walking","waterFitness","yoga","other","barre","coreTraining","flexibility","highIntesityIntervalTraining","jumpRope","pilates","stairs","stepTraining"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let secondary = FIRApp.init(named: "secondary")
            else { assert(false, "Could not retrieve secondary app") }
        
        
        // Retrieve a Real Time Database client configured against a specific app.
        let secondaryDb = FIRDatabase.database(app: secondary)
        ref = secondaryDb.reference()

        descripcion.layer.borderWidth = 1
        descripcion.layer.cornerRadius = 5.0
        descripcion.layer.borderColor = UIColor(red: 0.783922, green: 0.783922, blue: 0.8, alpha: 0.5).cgColor
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(NuevaRutinaViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        tipo.delegate = self
        tipo.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ejercicios.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tituloEjercicios[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type =  ejercicios[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   
    
    @IBAction func next(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func editando(_ sender: Any) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    @IBAction func finEditando(_ sender: Any) {
        animateViewMoving(up:false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }


    @IBAction func agregar(_ sender: Any) {
        if (titulo.text != "" && descripcion.text != "" && duracion.text != ""){
            let k = ref.child("rutinas").child(usuario.Ref).child("activas").childByAutoId().key
            let date = NSDate()
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MMM/yyyy "
            fecha = Date() as NSDate!
            let data = [
                "descripcion":self.descripcion.text,
                "duracion":self.duracion.text,
                "fecha":dateFormatter.string(from: fecha as Date) as AnyObject?,
                "tipo":type,
                "titulo":titulo.text
            ] as [String : Any]
            self.ref.child("rutinas").child(usuario.Ref).child("activas").child(k).setValue(data)
            //Go to the HomeViewController if the login is sucessful
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "home")
            self.present(vc!, animated: true, completion: nil)
        }else{
            
            let alertController = UIAlertController(title: "Error", message: "Porfavor llene todos los datos", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
