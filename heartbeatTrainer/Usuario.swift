//
//  Usuario.swift
//  heartbeatTrainer
//
//  Created by Emmanuel Paez on 30/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class Usuario {
    private var nombre : String?
    private var sexo : String?
    private var ref : String?
    private var icon : UIImage?
    private var data :Dictionary<String, AnyObject>?

    
    
    init (datos:Dictionary<String, AnyObject>,ref: FIRDatabaseReference?){
        
        self.ref = ref?.key
        self.nombre = datos["nombre"] as! String?
        self.sexo = datos["sexo"] as! String?
       
        
        self.data = [
            "ref" : self.ref as AnyObject,
            "nombre":self.nombre as AnyObject,
            "sexo":self.sexo as AnyObject,
            
        ]
        
        self.icon = UIImage(named: self.sexo!)
        
    }
    
    var getData : Dictionary<String, AnyObject>{
        get{
            return self.data!
        }
    }
    
    var Nombre : String{
        get{
            return self.nombre!
        }
        
        set(newNombre){
            self.nombre = newNombre
        }
    }
    var Sexo : String{
        get{
            return self.sexo!
        }
        
        set(newSexo){
            self.sexo = newSexo
        }
    }
    var Ref : String{
        get{
            return self.ref!
        }
        
        set(newRef){
            self.ref = newRef
        }
    }
    var Icon : UIImage{
        get{
            return self.icon!
        }
        
        set(newIcon){
            self.icon = newIcon
        }
    }


    
    
    
    
}

