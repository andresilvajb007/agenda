//
//  MapaViewController.swift
//  Agenda
//
//  Created by André Silva on 02/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var mapa: MKMapView!
    lazy var localizacao =  Localizacao()
    
    //MARK: - Variavel
    var aluno: Aluno?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitulo()
        self.localizacaoInicial()
        self.localizarAluno()
        
        mapa.delegate = localizacao
        
        
    }
    
    //MARK: - Metodos
    func getTitulo() -> String{
        return "Localizar Alunos"
    }
    
    func localizacaoInicial() {
           Localizacao().converteEnderecoEmCoordenadas(endereco: "Praca oito") { (localizacaoEncontrada) in

            let pino = Localizacao().configuraPino(titulo: "Praca oito", localizacao: localizacaoEncontrada, cor: .black, icone: nil)
            let regiao =  MKCoordinateRegion(center: pino.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
                
        }
    }
    
    func localizarAluno(){
        if let aluno = aluno{
                    
            Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacaoEncontrada) in
                
              let pino = Localizacao().configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada, cor: nil, icone: nil)
              let regiao =  MKCoordinateRegion(center: pino.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
              self.mapa.setRegion(regiao, animated: true)
              self.mapa.addAnnotation(pino)
          }
        }
    }
    


}
