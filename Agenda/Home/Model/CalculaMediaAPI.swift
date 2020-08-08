//
//  CalculaMediaAPI.swift
//  Agenda
//
//  Created by André Silva on 08/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class CalculaMediaAPI: NSObject {
    
    func calculaMediaGeralDosAlunos(alunos: Array<Aluno>,
                                    sucesso: @escaping(_ dicionarioMedias: Dictionary<String,Any>) -> Void,
                                    falha: @escaping(_ error: Error) -> Void){
        
        guard let  url = URL(string: "https://www.caelum.com.br/mobile") else{
            return
        }
                
        var listaDeAlunos: Array<Dictionary<String,Any>> = []
        var json: Dictionary<String,Any> = [:]
        
        for aluno in alunos{
            
            guard let nome = aluno.nome else { break  }
            guard let endereco = aluno.endereco else { break  }
            guard let telefone = aluno.telefone else { break  }
            guard let site = aluno.site else { break  }
            
            
            let dicionarioDeAlunos =
            [
                "id" : "\(1)" ,
                "nome": nome,
                "endereco" : endereco,
                "telefone" : telefone,
                "site": site,
                "nota": String(aluno.nota)
            ] as [String : Any]
                   
            listaDeAlunos.append(dicionarioDeAlunos )
            
        }
        
       
        json = [
            "list": [
                ["aluno": listaDeAlunos]
            ]
        ]
        
        var request = URLRequest(url: url)
        
        do
        {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            print(String(data: data, encoding: .utf8))

            request.httpBody = data
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    do
                    {
                        let jsonRetorno = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String,Any>
                        print(jsonRetorno)
                        
                        sucesso(jsonRetorno)
                    }
                    catch{                        
                        falha(error)
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
