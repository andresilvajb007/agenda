//
//  Pino.swift
//  Agenda
//
//  Created by André Silva on 09/08/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import MapKit


class Pino: NSObject, MKAnnotation {
    
    var title: String?
    var icone: UIImage?
    var cor: UIColor?
    var coordinate: CLLocationCoordinate2D
    
    init(coordenada: CLLocationCoordinate2D){
        self.coordinate = coordenada
    }

}
