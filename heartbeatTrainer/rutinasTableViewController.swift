//
//  rutinasTableViewController.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 06/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class rutinasTableViewController: UITableViewController {
    
    var usuario : Usuario!
    var items = [[ProtocolRutina]]()
    let headers = ["Activas","Completadas"]
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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rutinaCell", for: indexPath) as! RutinasTableViewCell
        let item = items[indexPath.section][indexPath.row]
        cell.titulo?.text = item.Titulo
        cell.icon?.image = item.Icon
        cell.fecha?.text = item.Fecha
        return cell
    }
    
    
    
    func startObservingDatabase () {
        databaseHandle = ref.child("rutinas").child(usuario.Ref).observe(.value, with: { (snapshot) in
            var activas = [ProtocolRutina]()
            for itemSnapShot in snapshot.childSnapshot(forPath: "activas").children {
                let item = rutina(datos: (itemSnapShot as! FIRDataSnapshot).value as! Dictionary<String, AnyObject>,  ref: (itemSnapShot as! FIRDataSnapshot).ref )
                activas.append(item as! ProtocolRutina)
            }
            var completas = [ProtocolRutina]()
            
            for itemSnapShot in snapshot.childSnapshot(forPath: "completas").children {
                let item = rutinaCompleta(datos: (itemSnapShot as! FIRDataSnapshot).value as! Dictionary<String, AnyObject>)
                completas.append(item as! ProtocolRutina)
            }
            self.items=[[ProtocolRutina]]()
            self.items.append(activas as! [ProtocolRutina])
            self.items.append(completas as! [ProtocolRutina])
            self.tableView.reloadData()
            
            
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch indexPath.section{
        case 0: self.performSegue(withIdentifier: "rutinaCompletaInfoSegue", sender: self);
        break;
        case 1: self.performSegue(withIdentifier: "rutinaIncompletaInfoSegue", sender: self);
        break;
        default:
            break
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rutinaCompletaInfoSegue" ,
            let nextScene = segue.destination as? RutinaViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedRutina = items[0][indexPath.row]
            nextScene.rutina = selectedRutina
           
            
        }
        
        if segue.identifier == "rutinaIncompletaInfoSegue" ,
            let nextScene = segue.destination as? rutinaCompletaViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedRutina = items[1][indexPath.row]
            nextScene.rutina = selectedRutina.DownCast
            nextScene.usuario = usuario
        }
        
        if segue.identifier == "agregarSegue" {
            let nextScene = segue.destination as? NuevaRutinaViewController
            nextScene?.usuario = usuario
            
            
        }

    }

    
    
    deinit {
        ref.child("rutinas").child(usuario.Ref).removeObserver(withHandle: databaseHandle)
    }
    
    
    
}
