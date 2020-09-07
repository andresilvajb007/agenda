//
//  Repositorio.swift
//  Agenda
//
//  Created by André Silva on 17/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class Repositorio: NSObject {
    
    func recuperaAlunos(completion: @escaping(_ listaDeAlunos: Array<Aluno>) -> Void){
        var alunos = AlunoDAO().recuperaAlunos()
        
        if alunos.count == 0{
            AlunoAPI().RecuperaAlunos {
                alunos = AlunoDAO().recuperaAlunos()
                completion(alunos)
            }
        }
        else{
            completion(alunos)
        }        
    }
    
    func salvaAluno(aluno: Dictionary<String,String>){
        
        AlunoAPI().SalvaAlunosNoServidor(parametros:[aluno])
        AlunoDAO().salvaAluno(dicionarioDeAluno:aluno)
    }
    
    func deletaAluno(aluno: Aluno){
        
        guard let id = aluno.id else { return  }
        AlunoAPI().DeletaAlunoServidor(id: String(describing: id).lowercased())
        AlunoDAO().deletaAluno(aluno: aluno)
    }

}
