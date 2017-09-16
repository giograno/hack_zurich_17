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
    var total_time      : String = "120"; // hard coded
    
    // Geoprocessing URL
    let geo_URL         : String = "https://utility.arcgis.com/usrsvcs/appservices/ueHF8ushjjxEgUyO/rest/services/World/VehicleRoutingProblem/GPServer/SolveVehicleRoutingProblem/submitJob"
    
    //
    var geoprocessingTask: AGSGeoprocessingTask!
    var geoprocessingJob: AGSGeoprocessingJob!
    
    // Options selected
    var isBars          : Bool = true
    var isSightseeing   : Bool = false
    var isCoffee        : Bool = false
    
    // Hardcoded technopark starting point
    let technopark      : Place = Place(lat: 47.4142883, lon: 8.5495906, name: "Technopark Zurich")
    let hb              : Place = Place(lat: 47.377923, lon: 8.5380011, name: "Technopark Zurich")
    
    
    var startGeometry   : AGSPoint!
    var endGeometry     : AGSPoint!
    
    var stopGraphicsOverlay = AGSGraphicsOverlay()

    // The route task
    var routeTask:AGSRouteTask!
    var routeParameters:AGSRouteParameters!
    
    private var graphicsOverlay:AGSGraphicsOverlay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // instantiate map with basemap, initial viewpoint and level of detail
        let map = AGSMap(basemapType: AGSBasemapType.streets, latitude: 47.390173, longitude: 8.5062531, levelOfDetail: 13)
        
        // assign the map to mapView
        self.mapView.map = map
        
        // Initialize geoprocessing task with the url of the service
        self.geoprocessingTask = AGSGeoprocessingTask(url: URL(string: geo_URL)!)

        // initialize the route task
        self.routeTask = AGSRouteTask(url: URL(string: "https://sampleserver6.arcgisonline.com/arcgis/rest/services/NetworkAnalysis/SanDiego/NAServer/Route")!)

        let graphicsOverlay = AGSGraphicsOverlay()
        self.mapView.graphicsOverlays.add(graphicsOverlay)
        calculate_route()
        //add some buoy positions to the graphics overlay
//        addBuoyPoints(to: graphicsOverlay)

    }
    
    private func feature_helper(location: Place) -> String {
        return "{\"geometry\":{\"x\":" + location.long.toString() + ",\"y\":" + location.lat.toString() + ", \"attributes\":{\"Name\":\"" + location.name + "\", \"ServiceTime\" : 35}}"
    }
    
    private func wrap_features(featureList : [String]) -> String {
        return "{\"features\": [" + featureList.joined(separator: ",") + "]}"
    }
    
    private func calculate_route() {
        
        // Geoprocessing parameters
        let params = AGSGeoprocessingParameters(executionType: .asynchronousSubmit)
        params.inputs["default_date"] = AGSGeoprocessingDouble(value: 1455609600000)
        params.inputs["time_units"] = AGSGeoprocessingString(value: "Minutes")
        params.inputs["travel_mode"] = AGSGeoprocessingString(value: "{\"attributeParameterValues\": [{\"parameterName\": \"Restriction Usage\", \"attributeName\": \"Walking\", \"value\": \"PROHIBITED\"}, {\"parameterName\": \"Restriction Usage\", \"attributeName\": \"Preferred for Pedestrians\", \"value\": \"PREFER_LOW\"}, {\"parameterName\": \"Walking Speed (km/h)\", \"attributeName\": \"WalkTime\", \"value\": 5}], \"description\": \"Follows paths and roads that allow pedestrian traffic and finds solutions that optimize travel time. The walking speed is set to 5 kilometers per hour.\", \"impedanceAttributeName\": \"WalkTime\", \"simplificationToleranceUnits\": \"esriMeters\", \"uturnAtJunctions\": \"esriNFSBAllowBacktrack\", \"restrictionAttributeNames\": [\"Preferred for Pedestrians\", \"Walking\"], \"useHierarchy\": false, \"simplificationTolerance\": 2, \"timeAttributeName\": \"WalkTime\", \"distanceAttributeName\": \"Miles\", \"type\": \"WALK\", \"id\": \"caFAgoThrvUpkFBW\", \"name\": \"Walking Time\"}")
        params.inputs["routes"] = AGSGeoprocessingString(value: "{\"features\":[{\"attributes\":{\"Name\":\"Traveller\",\"StartDepotName\": \"Technopark\",\"EndDepotName\":\"Technopark\",\"MaxTotalTime\": "  + total_time + "}}]}")
        params.inputs["populate_directions"] = AGSGeoprocessingBoolean(value: true)
        
        var place_feature_list : [String] = []
        let b : BarCoords = BarCoords()
        for bar in b.barList {
            place_feature_list.append(self.feature_helper(location: bar))
        }
        params.inputs["orders"] = AGSGeoprocessingString(value: self.wrap_features(featureList: place_feature_list))
        params.inputs["depots"] = AGSGeoprocessingString(value: self.wrap_features(featureList: [self.feature_helper(location: self.technopark)]))
        
        // Initiate the job
        self.geoprocessingJob = self.geoprocessingTask.geoprocessingJob(with: params)
        
        self.geoprocessingJob.start(statusHandler: { (status: AGSJobStatus) in
            print(status.rawValue)
        }) { [weak self] (result: AGSGeoprocessingResult?, error: Error?) in
            
            if let error = error {
//                self?.showAlert(messageText: "Error", informativeText: error.localizedDescription)
                print("error")
            }
            else {
                print(result)
            }
        }
    }
    
    func addStops() {
        self.startGeometry = AGSPoint(x: technopark.long, y: technopark.lat, spatialReference: AGSSpatialReference(wkid: 3857))
        self.endGeometry = AGSPoint(x: hb.long, y: hb.lat, spatialReference: AGSSpatialReference(wkid: 3857))
        
        let startStopGraphic = AGSGraphic(geometry: startGeometry, symbol: self.stopSymbol(withName: "Origin", textColor: UIColor.blue), attributes: nil)
        let endStopGraphic = AGSGraphic(geometry: endGeometry, symbol: self.stopSymbol(withName: "Destination", textColor: UIColor.red), attributes: nil)
        
        self.stopGraphicsOverlay.graphics.addObjects(from: [startStopGraphic, endStopGraphic])
    }
    
    // Method provides a text symbol for stop with specified parameters
    func stopSymbol(withName name:String, textColor:UIColor) -> AGSTextSymbol {
        return AGSTextSymbol(text: name, color: textColor, size: 20, horizontalAlignment: .center, verticalAlignment: .middle)
    }
    
    func getDefaultParameters() {
        
        self.routeTask.defaultRouteParameters { [weak self] (params: AGSRouteParameters?, error: Error?) -> Void in
            if let error = error {
                print(error)
            }
            else {
                //on completion store the parameters
                self?.routeParameters = params
                //add stops
                self?.addStops()
                //enable bar button item
//                self?.routeBBI.isEnabled = true
            }
        }
    }
    
    private func addBuoyPoints(to graphicsOverlay:AGSGraphicsOverlay) {
        
        //define the buoy locations
        let wgs84 = AGSSpatialReference.wgs84()
        
        let buoy1Loc = AGSPoint(x: 8.5094722, y: 47.3828982, spatialReference: wgs84)
        let buoy2Loc = AGSPoint(x: 8.517873, y: 47.390831, spatialReference: wgs84)
        let buoy3Loc = AGSPoint(x: 8.515094, y: 47.391862, spatialReference: wgs84)
        let buoy4Loc = AGSPoint(x: 8.519268, y: 47.388318, spatialReference: wgs84)
        
        //create a marker symbol
        let buoyMarker = AGSSimpleMarkerSymbol(style: .circle, color: UIColor.red, size: 10)
        
        //create graphics
        let buoyGraphic1 = AGSGraphic(geometry: buoy1Loc, symbol: buoyMarker, attributes: nil)
        let buoyGraphic2 = AGSGraphic(geometry: buoy2Loc, symbol: buoyMarker, attributes: nil)
        let buoyGraphic3 = AGSGraphic(geometry: buoy3Loc, symbol: buoyMarker, attributes: nil)
        let buoyGraphic4 = AGSGraphic(geometry: buoy4Loc, symbol: buoyMarker, attributes: nil)
        
        //add the graphics to the graphics overlay
        graphicsOverlay.graphics.addObjects(from: [buoyGraphic1, buoyGraphic2, buoyGraphic3, buoyGraphic4])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}
