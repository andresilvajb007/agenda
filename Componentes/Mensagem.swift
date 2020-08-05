//
//  Mensagem.swift
//  Agenda
//
//  Created by André Silva on 02/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import MessageUI

class Mensagem: NSObject, MFMessageComposeViewControllerDelegate {
    
    
    //MARK: - Metodo
    
    func configuraSMS(_ aluno: Aluno) -> MFMessageComposeViewController? {
        
        if MFMessageComposeViewController.canSendText(){
            
            let componenteMensagem = MFMessageComposeViewController()
            guard let numeroDoAluno = aluno.telefone else { return componenteMensagem }
            componenteMensagem.recipients = [numeroDoAluno]
            componenteMensagem.messageComposeDelegate = self
            
            return componenteMensagem
        }

        return nil
    }
    
    
    //MARK: - MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}
