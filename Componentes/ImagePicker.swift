//
//  ImagePicker.swift
//  Agenda
//
//  Created by André Silva on 25/07/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

enum MenuOpcoes {
    case camera
    case biblioteca
}

protocol ImagePickerFotoSelecionada {
    func ImagePickerFotoSelecionada(_ foto:UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: atributos
    var delegate: ImagePickerFotoSelecionada?
    
    //MARK: - metodos
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let foto = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        delegate?.ImagePickerFotoSelecionada(foto)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func menuDeOpcoes(completion: @escaping(_ opcao: MenuOpcoes) -> Void ) -> UIAlertController{
        
        let alert = UIAlertController(title: "Opcoes", message: "Selecione uma opcao", preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (action) in
            //implementar
            completion(MenuOpcoes.camera)
        }
        
        let actionBibloteca = UIAlertAction(title: "Biblioteca", style: .default) { (action) in
            //implementar
            completion(MenuOpcoes.biblioteca)
        }
        
        let actionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(actionCamera)
        alert.addAction(actionBibloteca)
        alert.addAction(actionCancelar)
        
        return alert
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
