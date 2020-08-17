//
//  Repositorio.swift
//  Agenda
//
//  Created by André Silva on 17/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class Repositorio: NSObject {
    
    func salvaAluno(aluno: Dictionary<String,String>){
        
        AlunoAPI().SalvaAlunosNoServidor(parametros:[aluno])
        AlunoDAO().salvaAluno(dicionarioDeAluno:aluno)
    }

}
