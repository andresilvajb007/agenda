//
//  MapaViewController.swift
//  Agenda
//
//  Created by André Silva on 02/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController,CLLocationManagerDelegate {
    
    //MARK: - IBOutlet
    @IBOutlet weak var mapa: MKMapView!
    lazy var localizacao =  Localizacao()
    lazy var gerenciadorDeLocalizacao = CLLocationManager()
    
    //MARK: - Variavel
    var aluno: Aluno?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitulo()
        self.localizacaoInicial()
        self.localizarAluno()
        self.verificaAutorizacaoUsuario()
        
        mapa.delegate = localizacao
        gerenciadorDeLocalizacao.delegate = self
        
        
    }
    
    //MARK: - Metodos
    func getTitulo() -> String{
        return "Localizar Alunos"
    }
    
    func localizacaoInicial() {
           Localizacao().converteEnderecoEmCoordenadas(endereco: "Praca oito") { (localizacaoEncontrada) in

            let pino = Localizacao().configuraPino(titulo: "Praca oito", localizacao: localizacaoEncontrada, cor: .black, icone: nil)
            let regiao =  MKCoordinateRegion(center: pino.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
                
        }
    }
    
    func localizarAluno(){
        if let aluno = aluno{
                    
            Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacaoEncontrada) in
                
              let pino = Localizacao().configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada, cor: nil, icone: nil)
              let regiao =  MKCoordinateRegion(center: pino.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
              self.mapa.setRegion(regiao, animated: true)
              self.mapa.addAnnotation(pino)
              self.mapa.showAnnotations(self.mapa.annotations, animated: true)
          }
        }
    }
    
    func verificaAutorizacaoUsuario(){
        
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                let botao = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa)
                mapa.addSubview(botao)
                gerenciadorDeLocalizacao.startUpdatingLocation()
                
                break
            case .notDetermined:
                gerenciadorDeLocalizacao.requestWhenInUseAuthorization()
                break
            case .denied:
                break
                
            default:
                break
            }
        }
    }
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            let botao = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa)
            mapa.addSubview(botao)
            gerenciadorDeLocalizacao.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }


}
