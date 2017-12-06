//
//  RoutingAPI.swift
//  hackZurich
//
//  Created by Giovanni Grano on 05.12.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import UIKit
import ArcGIS

class RoutingAPI: NSObject {
    
    let geo_URL : String = "https://utility.arcgis.com/usrsvcs/appservices/ueHF8ushjjxEgUyO/re st/services/World/VehicleRoutingProblem/GPServer/SolveVehicleRoutingProblem"
    
    private func feature_helper(location: Place) -> String {
        let aux : String = "{\"geometry\":{\"x\":" + location.long.toString() + ",\"y\":" + location.lat.toString() + "}, \"attributes\":{\"Name\":\"" + location.name + "\", \"ServiceTime\" : 20}}"
        return aux
    }
    
    private func wrap_features(featureList : [String]) -> String {
        let joined : String = featureList.joined(separator: ",")
        let aux = "{\"features\": [" + joined + "]}"
        return aux
    }
    
    func getRoute() {
        // to implement
    }
}
