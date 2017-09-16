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
    
    private var graphicsOverlay:AGSGraphicsOverlay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // instantiate map with basemap, initial viewpoint and level of detail
        let map = AGSMap(basemapType: AGSBasemapType.streets, latitude: 47.390173, longitude: 8.5062531, levelOfDetail: 13)
        
        // assign the map to mapView
        self.mapView.map = map
        
        let graphicsOverlay = AGSGraphicsOverlay()
        self.mapView.graphicsOverlays.add(graphicsOverlay)
        
        //add some buoy positions to the graphics overlay
        addBuoyPoints(to: graphicsOverlay)

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
