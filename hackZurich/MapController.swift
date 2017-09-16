//
//  MapController.swift
//  hackZurich
//
//  Created by Giovanni Grano on 16.09.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import UIKit
import ArcGIS

class MapController: UIViewController {

    
    @IBOutlet weak var mapView: AGSMapView!

    // Maximum amount of time
    var time            : Double = 0.0
    var total_time      : String = "320"; // hard coded
    
    // Geoprocessing URL
    let geo_URL         : String = "https://utility.arcgis.com/usrsvcs/appservices/ueHF8ushjjxEgUyO/rest/services/World/VehicleRoutingProblem/GPServer/SolveVehicleRoutingProblem"
    
    //
    var geoprocessingTask: AGSGeoprocessingTask!
    var geoprocessingJob: AGSGeoprocessingJob!
    
    // Options selected
    var isBars          : Bool = true
    var isSightseeing   : Bool = false
    var isCoffee        : Bool = false
    
    // Hardcoded technopark starting point
    let technopark      : Place = Place(lat: 47.414288300000003, lon: 8.549590600000000, name: "Technopark")
    let hb              : Place = Place(lat: 47.377923, lon: 8.5380011, name: "Technopark")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // instantiate map with basemap, initial viewpoint and level of detail
        let map = AGSMap(basemapType: AGSBasemapType.streets, latitude: 47.390173, longitude: 8.5062531, levelOfDetail: 13)
        
        // assign the map to mapView
        self.mapView.map = map
        
        // Initialize geoprocessing task with the url of the service
        self.geoprocessingTask = AGSGeoprocessingTask(url: URL(string: geo_URL)!)
        
        calculate_route()
    }
    
    private func feature_helper(location: Place) -> String {
        let aux : String = "{\"geometry\":{\"x\":" + location.long.toString() + ",\"y\":" + location.lat.toString() + "}, \"attributes\":{\"Name\":\"" + location.name + "\", \"ServiceTime\" : 15}}"
        return aux
    }
    
    private func wrap_features(featureList : [String]) -> String {
        let joined : String = featureList.joined(separator: ",")
        let aux = "{\"features\": [" + joined + "]}"
        return aux
    }
    
    private func calculate_route() {
        
        // Geoprocessing parameters
        let params = AGSGeoprocessingParameters(executionType: .asynchronousSubmit)
        params.processSpatialReference = self.mapView.map?.spatialReference
        params.outputSpatialReference = self.mapView.map?.spatialReference

        params.inputs["default_date"] = AGSGeoprocessingDouble(value: 1455609600000)
        params.inputs["time_units"] = AGSGeoprocessingString(value: "Minutes")
        
        let auxTravelMode : String = "{\"attributeParameterValues\": [{\"parameterName\": \"Restriction Usage\", \"attributeName\": \"Walking\", \"value\": \"PROHIBITED\"}, {\"parameterName\": \"Restriction Usage\", \"attributeName\": \"Preferred for Pedestrians\", \"value\": \"PREFER_LOW\"}, {\"parameterName\": \"Walking Speed (km/h)\", \"attributeName\": \"WalkTime\", \"value\": 5}], \"description\": \"Follows paths and roads that allow pedestrian traffic and finds solutions that optimize travel time. The walking speed is set to 5 kilometers per hour.\", \"impedanceAttributeName\": \"WalkTime\", \"simplificationToleranceUnits\": \"esriMeters\", \"uturnAtJunctions\": \"esriNFSBAllowBacktrack\", \"restrictionAttributeNames\": [\"Preferred for Pedestrians\", \"Walking\"], \"useHierarchy\": false, \"simplificationTolerance\": 2, \"timeAttributeName\": \"WalkTime\", \"distanceAttributeName\": \"Miles\", \"type\": \"WALK\", \"id\": \"caFAgoThrvUpkFBW\", \"name\": \"Walking Time\"}"
        
        params.inputs["travel_mode"] = AGSGeoprocessingString(value: auxTravelMode)
        
        let auxRoutes : String = "{\"features\":[{\"attributes\":{\"Name\":\"Traveller\",\"StartDepotName\": \"Technopark\",\"EndDepotName\":\"Technopark\",\"MaxTotalTime\": "  + total_time + "}}]}"
        params.inputs["routes"] = AGSGeoprocessingString(value: auxRoutes)
        params.inputs["populate_directions"] = AGSGeoprocessingBoolean(value: true)
        
        var place_feature_list : [String] = []
        let b : BarCoords = BarCoords()
        for bar in b.barList {
            place_feature_list.append(self.feature_helper(location: bar))
        }
        
        params.inputs["orders"] = AGSGeoprocessingString(value: self.wrap_features(featureList: place_feature_list))
        
        print(self.wrap_features(featureList: place_feature_list))
        
        let auxDepots : String = self.wrap_features(featureList: [self.feature_helper(location: self.technopark)])
        print(auxDepots)
        params.inputs["depots"] = AGSGeoprocessingString(value: auxDepots)
        
        // Initiate the job
        self.geoprocessingJob = self.geoprocessingTask.geoprocessingJob(with: params)
        
        self.geoprocessingJob.start(statusHandler: { (status: AGSJobStatus) in
            print(status.rawValue)
        }) { [weak self] (result: AGSGeoprocessingResult?, error: Error?) in
            
            if let error = error {
                print("error")
            }
            else {
                // Remove previous layers
                self?.mapView.map?.operationalLayers.removeAllObjects()
                
                // Add the new layer to the map
//                var out_features : AGSGeoprocessingFeatures = result?.outputs["out_routes"] as! AGSGeoprocessingFeatures
//                print(out_features.features?.geometryType)
                if let resultFeatures = result?.outputs["out_routes"] as? AGSGeoprocessingFeatures, let featureSet = resultFeatures.features {
                    for feature in featureSet.featureEnumerator().allObjects {
                        let graphic = AGSGraphic(geometry: feature.geometry, symbol: nil, attributes: nil)
                    }
                }
                
                //set map view's viewpoint to the new layer's full extent
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.15f",self)
    }
}
