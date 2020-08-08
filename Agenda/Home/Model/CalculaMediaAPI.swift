//
//  CalculaMediaAPI.swift
//  Agenda
//
//  Created by André Silva on 08/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class CalculaMediaAPI: NSObject {
    
    func calculaMediaGeralDosAlunos(){
        guard let  url = URL(string: "https://caelum.com.br/mobile") else{
            return
        }
                
        var listaDeAlunos: Array<Dictionary<String,Any>> = []
        var json: Dictionary<String,Any> = [:]
        let dicionarioDeAlunos =
        [
            "id" : "1" ,
            "nome": "Andre",
            "endereco" : "rua aaa",
            "telefone" : "9999-9999",
            "site": "www.alura.com.br",
            "nota": "8"
        ]
        
        listaDeAlunos.append(dicionarioDeAlunos as [String:Any] )
        json = [
            "list": [
                ["aluno": listaDeAlunos]
            ]
        ]
        
        var request = URLRequest(url: url)
        do
        {
            let dicionario = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = dicionario
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    do
                    {
                        let dicionario = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(dicionario)
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                    
                }
            }
            
            task.resume()
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
}
