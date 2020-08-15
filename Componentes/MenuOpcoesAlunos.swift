//
//  MenuOpcoesAlunos.swift
//  Agenda
//
//  Created by André Silva on 02/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

enum EnumMenuOpcoesAlunos
{
    case sms
    case ligacao
    case waze
    case mapa
    case paginaWeb
}

class MenuOpcoesAlunos: NSObject {

    func configuraMenudeOpcoesDoAluno(completion: @escaping(_ opcao: EnumMenuOpcoesAlunos) -> Void ) -> UIAlertController{
        
        let alert = UIAlertController(title: "Atencao", message: "Escolha uma das opcoes abaixo", preferredStyle: .actionSheet)
        
        let sms = UIAlertAction(title: "enviar sms", style: .default) { (acao) in
            //implementar
            completion(.sms)
        }
        
        let ligacao = UIAlertAction(title: "ligar", style: .default) { (acao) in
            //implementar
            completion(.ligacao)
        }
        
        let waze = UIAlertAction(title: "localizar no waze", style: .default) { (acao) in
            //implementar
            completion(.ligacao)
        }
        
        let mapa = UIAlertAction(title: "localizar no mapa", style: .default) { (acao) in
            //implementar
            completion(.mapa)
        }
        
        let pagina = UIAlertAction(title: "acessar pagina", style: .default) { (acao) in
                  //implementar
                  completion(.paginaWeb)
              }
        
        let cancelar = UIAlertAction(title: "cancelar", style: .cancel, handler: nil)
        
        
        alert.addAction(sms)
        alert.addAction(ligacao)
        alert.addAction(waze)
        alert.addAction(mapa)
        alert.addAction(pagina)
        alert.addAction(cancelar)
        
        return alert
    }
}
