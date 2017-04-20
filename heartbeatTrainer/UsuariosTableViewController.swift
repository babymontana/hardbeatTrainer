//
//  UsuariosTableViewController.swift
//  heartbeatTrainer
//
//  Created by Emmanuel Paez on 30/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class UsuariosTableViewController: UITableViewController {
    
     var items = [Usuario]()
    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Retrieve a previous created named app.
        guard let secondary = FIRApp.init(named: "secondary")
            else { assert(false, "Could not retrieve secondary app") }
        
        
        // Retrieve a Real Time Database client configured against a specific app.
        let secondaryDb = FIRDatabase.database(app: secondary)
        ref = secondaryDb.reference()
        startObservingDatabase()
        
           }
    
    func startObservingDatabase () {
        databaseHandle = ref.child("users").observe(.value, with: { (snapshot) in
            var newItems = [Usuario]()
            
            for itemSnapShot in snapshot.children {
                let item = Usuario(datos: (itemSnapShot as! FIRDataSnapshot).value as! Dictionary<String, AnyObject>,  ref: (itemSnapShot as! FIRDataSnapshot).ref )
                newItems.append(item)
            }
            
            self.items = newItems
            self.tableView.reloadData()
            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        ref.child("users").removeObserver(withHandle: databaseHandle)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usuarioCell", for: indexPath) as! UsuarioTableViewCell
        let item = items[indexPath.row]
        cell.nombre.text = item.Nombre
        cell.userImg.image = item.Icon
        return cell
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        self.performSegue(withIdentifier: "usuarioRutinas", sender: self)

        
        
        
    }

    @IBAction func cerrar(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "usuarioRutinas" ,
            let nextScene = segue.destination as? rutinasTableViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedUsuario = items[indexPath.row]
            nextScene.usuario = selectedUsuario 
        }
    }


}
