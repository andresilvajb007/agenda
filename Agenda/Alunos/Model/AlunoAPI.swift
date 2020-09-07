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
    
    func RecuperaAlunos(completion: @escaping() -> Void){
            
        let request =  AF.request("http://localhost:8080/api/aluno", method: .get)
        
        request.responseJSON { (response) in
            switch response.result{
            case .success(let JSON):

                if let data = JSON as? Dictionary<String,Any>{
                    guard let listaDeAlunos = data["alunos"] as? Array<Dictionary<String,Any>>  else { return  }
                    
                    for aluno in listaDeAlunos{
                        AlunoDAO().salvaAluno(dicionarioDeAluno: aluno)
                    }
                    
                    completion()
                }
                
                break
            case .failure:
                print(response.error!)
                completion()
                break;
            }
        }
    }
    
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
    
    func DeletaAlunoServidor(id: String){
        guard let url = URL(string: "http://localhost:8080/api/aluno/\(id)") else { return  }
        
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "DELETE"
        
        var afRequest = AF.request(requisicao)
        afRequest.responseJSON { (response) in
            print(response)
        }
        
    }
}
