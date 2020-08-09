//
//  Localizacao.swift
//  Agenda
//
//  Created by André Silva on 02/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Localizacao: NSObject, MKMapViewDelegate {

    func converteEnderecoEmCoordenadas(endereco: String, local: @escaping(_ local: CLPlacemark) -> Void){
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { (listaDeLocalizacoes, error) in
            if let localizacao = listaDeLocalizacoes?.first{
                local(localizacao)
            }
        }
    }
    
    func configuraBotaoLocalizacaoAtual(mapa: MKMapView) -> MKUserTrackingButton{
        let botao = MKUserTrackingButton(mapView: mapa)
        botao.frame.origin.x = 10;
        botao.frame.origin.y = 10;
        
        return botao
        
    }
    
    //MARK: - Configura Pinos
    func configuraPino(titulo: String, localizacao: CLPlacemark, cor: UIColor?, icone: UIImage?) -> Pino{
        let pino = Pino(coordenada: localizacao.location!.coordinate)
        pino.title = titulo
        pino.cor = cor
        pino.icone = icone
        
        return pino
    }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Pino{
            
            let  annotationView =  annotation as! Pino
            
            var pinoView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationView.title!) as? MKMarkerAnnotationView
            pinoView = MKMarkerAnnotationView (annotation: annotationView, reuseIdentifier: annotationView.title!)
            
            pinoView?.annotation = annotationView
            pinoView?.glyphImage = annotationView.icone
            pinoView?.markerTintColor = annotationView.cor
            
            return pinoView
            
            
        }
        return nil
    }
}
