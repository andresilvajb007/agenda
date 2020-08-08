//
//  AutenticacaoLocal.swift
//  Agenda
//
//  Created by André Silva on 08/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import LocalAuthentication

class AutenticacaoLocal: NSObject {
    
    var error: NSError?
    
    func autorizaUsuario(completion: @escaping(_ autenticado: Bool) -> Void){
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "eh necessario autenticacao para apagar um aluno") { (resposta, erro) in
                 completion(resposta)
            }
        }
    }

}
