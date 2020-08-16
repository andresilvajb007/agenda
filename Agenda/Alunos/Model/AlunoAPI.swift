//
//  AlunoAPI.swift
//  Agenda
//
//  Created by André Silva on 16/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import Alamofire

class AlunoAPI: NSObject {

    func SalvaAlunosNoServidor(parametros: Array<Dictionary<String,String>>){
        guard let url = URL(string: "http://localhost:8080/api/aluno/lista") else { return  }
        
        var requisicao =  URLRequest(url: url)
        requisicao.httpMethod = "PUT"
        requisicao.httpBody = try! JSONSerialization.data(withJSONObject: parametros, options: [])
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var request =  AF.request(requisicao)
        request.responseJSON { (response) in
                print(response)
        }
        //AF.request(url, method: .put,parameters: parametros)
        
    }
}
