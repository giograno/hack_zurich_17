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

    // Set of variables assigned by the calling view
    var time            : Double = 0.0
    var total_time      : String = "240"; // hard coded
    var startingPoint: Place = Place(lat: 0, lon: 0, name: "starting")
    var endingPoint: Place = Place(lat: 0, lon: 0, name: "starting")
    
    // Geoprocessing URL
    let geo_URL         : String = "https://utility.arcgis.com/usrsvcs/appservices/ueHF8ushjjxEgUyO/rest/services/World/VehicleRoutingProblem/GPServer/SolveVehicleRoutingProblem"
    
    var geoprocessingTask: AGSGeoprocessingTask!
    var geoprocessingJob: AGSGeoprocessingJob!
    
    // Options selected
    var isBars          : Bool = true
    var isSightseeing   : Bool = false
    var isCoffee        : Bool = false
    
    var routeGraphicsOverlay = AGSGraphicsOverlay()
    var stopGraphicsOverlay = AGSGraphicsOverlay()
    
    // directions to pass to the next view
    var directions : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(goInstructions(_:)))

        Utils.setMapsController(self, title: "Maps", color: CIColor(color: Utils.myColor), style: UIBarStyle.default, button: addButton)
        
        // instantiate map with basemap, initial viewpoint and level of detail
        let map = AGSMap(basemapType: AGSBasemapType.streets, latitude: self.startingPoint.lat, longitude: self.startingPoint.long, levelOfDetail: 13)
        
        // assign the map to mapView
        self.mapView.map = map
        
        // Initialize geoprocessing task with the url of the service
        self.geoprocessingTask = AGSGeoprocessingTask(url: URL(string: geo_URL)!)
        
        self.mapView.graphicsOverlays.addObjects(from: [stopGraphicsOverlay, routeGraphicsOverlay])
        
        calculate_route()
    }
    
    private func feature_helper(location: Place) -> String {
        let aux : String = "{\"geometry\":{\"x\":" + location.long.toString() + ",\"y\":" + location.lat.toString() + "}, \"attributes\":{\"Name\":\"" + location.name + "\", \"ServiceTime\" : 20}}"
        return aux
    }
    
    private func wrap_features(featureList : [String]) -> String {
        let joined : String = featureList.joined(separator: ",")
        let aux = "{\"features\": [" + joined + "]}"
        return aux
    }
    
    //method provides a line symbol for the route graphic
    func routeSymbol() -> AGSSymbol {
        
        let outerSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.red, width: 5)
        let innerSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.blue, width: 2)
        let compositeSymbol = AGSCompositeSymbol(symbols: [outerSymbol, innerSymbol])
        return compositeSymbol
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
        
        let auxRoutes : String = "{\"features\":[{\"attributes\":{\"Name\":\"Traveller\",\"StartDepotName\": \"\(self.startingPoint.name)\",\"EndDepotName\":\"\(self.endingPoint.name)\",\"MaxTotalTime\": "  + total_time + "}}]}"
        params.inputs["routes"] = AGSGeoprocessingString(value: auxRoutes)
        params.inputs["populate_directions"] = AGSGeoprocessingBoolean(value: true)
        
        var place_feature_list : [String] = []
        let b : BarCoords = BarCoords()
        for bar in b.barList {
            place_feature_list.append(self.feature_helper(location: bar))
        }
        
        params.inputs["orders"] = AGSGeoprocessingString(value: self.wrap_features(featureList: place_feature_list))
        
        var auxDepots: String = ""
        
        if self.startingPoint == self.endingPoint {
            auxDepots = self.wrap_features(featureList: [self.feature_helper(location: self.startingPoint)])
        } else {
            var depotsList : [String] = []
            depotsList.append(self.feature_helper(location: self.startingPoint))
            depotsList.append(self.feature_helper(location: self.endingPoint))
            auxDepots = self.wrap_features(featureList: depotsList)
        }
        
        params.inputs["depots"] = AGSGeoprocessingString(value: auxDepots)
        
        // Initiate the job
        self.geoprocessingJob = self.geoprocessingTask.geoprocessingJob(with: params)
        
        routeGraphicsOverlay.graphics.removeAllObjects()
        stopGraphicsOverlay.graphics.removeAllObjects()
        
        Utils.progressBarDisplayer(self, msg: "Building Awesome Trips", indicator: true)
        self.geoprocessingJob.start(statusHandler: { (status: AGSJobStatus) in
            print(status.rawValue)
            
        }) { [weak self] (result: AGSGeoprocessingResult?, error: Error?) in
            
            if let error = error {
                print("error")
            }
            else {
                
                Utils.removeProgressBar(self!)
                if let resultFeatures = result?.outputs["out_routes"] as? AGSGeoprocessingFeatures, let featureSet = resultFeatures.features {
                    for feature in featureSet.featureEnumerator().allObjects {
                        let graphic = AGSGraphic(geometry: feature.geometry, symbol: self?.routeSymbol(), attributes: nil)
                        self?.routeGraphicsOverlay.graphics.add(graphic)
                    }
                }
                let markerSymbol = AGSSimpleMarkerSymbol(style: .triangle, color: UIColor.black, size: 14)
                
                var i = 0
                if let resultFeatures = result?.outputs["out_stops"] as? AGSGeoprocessingFeatures, let featureSet = resultFeatures.features {
                    for feature in featureSet.featureEnumerator().allObjects {
                        i += 1
                        print(feature.attributes)
                        let aux = feature.attributes["Name"] as! String
                        let graphic = AGSGraphic(geometry: self?.createPoint(name: aux), symbol: markerSymbol, attributes: nil)
                        self?.stopGraphicsOverlay.graphics.add(graphic)
                    }
                    print(i)
                }
                
                if let resultFeatures = result?.outputs["out_directions"] as? AGSGeoprocessingFeatures, let featureSet = resultFeatures.features {
                    for feature in featureSet.featureEnumerator().allObjects {
//                        let aux = String(describing: feature.attributes["ObjectID"]) + feature.attributes["Text"] as! String
                        let no = String(describing: feature.attributes["ObjectID"]!)
                        let aux = feature.attributes["Text"] as! String
                        self?.directions.append(no + " - " + aux)
                    }
                }
            }
        }
    }
    
    private func createPoint(name: String) -> AGSPoint {
        let b : BarCoords = BarCoords()
        var myPoint : Place = Place(lat: 0, lon: 0, name: "")
        for bar in b.barList {
            if bar.name == name {
                myPoint = bar
            }
        }
        // create a point using x,y coordinates and a spatial reference
        let point = AGSPoint(x: myPoint.long, y: myPoint.lat, spatialReference: AGSSpatialReference.wgs84())
        return point
    }
    
    @objc func goInstructions(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "Indication", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Indication" {
            let controller = segue.destination as! TableViewController
            controller.fake = self.directions
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
