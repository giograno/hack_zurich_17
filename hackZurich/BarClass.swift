//
//  BarClass.swift
//  hackZurich
//
//  Created by Giovanni Grano on 16.09.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import Foundation

class Place {
    let lat: Double
    let long: Double
    let name: String
    
    init(
        lat: Double, lon: Double, name: String) {
        self.lat = lat
        self.long = lon
        self.name = name
    }
}

class BarCoords {
    var barList: [Place]
    
    init() {
        barList = []
        populate()
    }
    
    func populate() {
        self.barList.append(Place(lat: 47.3877252,lon: 8.518803200000001,name: "Brisket Southern BBQ & Bar"))
        self.barList.append(Place(lat: 47.3885043,lon: 8.5189273,name: "LABOR-BAR"))
        self.barList.append(Place(lat: 47.392065,lon: 8.518806,name: "Sphères, bar, buch, bühne"))
        self.barList.append(Place(lat: 47.3887004,lon: 8.519129600000001,name: "Nietturm"))
        self.barList.append(Place(lat: 47.3906712,lon: 8.510248299999999,name: "Café & Bar NUOVO"))
        self.barList.append(Place(lat: 47.388412,lon: 8.520775,name: "Aya Bar"))
        self.barList.append(Place(lat: 47.387207,lon: 8.519425,name: "Big Ben Westside"))
        self.barList.append(Place(lat: 47.3859945,lon: 8.5170543,name: "CLOUDS"))
        self.barList.append(Place(lat: 47.3900385,lon: 8.522268199999999,name: "IQ Bar"))
        self.barList.append(Place(lat: 47.3863682,lon: 8.527958099999999,name: "St Joseph's Pub"))
        self.barList.append(Place(lat: 47.3757038,lon: 8.5400261,name: "Pub Crawl Zurich"))
        self.barList.append(Place(lat: 47.3711071,lon: 8.537331199999999,name: "Mövenpick Wein-Bar"))
        self.barList.append(Place(lat: 47.3711071,lon: 8.527005400000002,name: "Mars Bar"))
        self.barList.append(Place(lat: 47.3828325,lon: 8.528683599999999,name: "The International Beer Bar"))
        self.barList.append(Place(lat: 47.37330799999999,lon: 8.532632000000001,name: "George"))
        self.barList.append(Place(lat: 47.3774275,lon: 8.5333518,name: "Kennedy's Irish Pub"))
        self.barList.append(Place(lat: 47.3824858,lon: 8.540406799999998,name: "Bar & Lounge 42"))
        self.barList.append(Place(lat: 47.378395,lon: 8.528829,name: "Dante"))
        self.barList.append(Place(lat: 47.371393,lon: 8.532532000000002,name: "Rimini Bar"))
        self.barList.append(Place(lat: 47.3792555,lon: 8.526057200000002,name: "Bar 63"))
        

//        self.barList.append(Place(lat: 47.365829017045606,lon: 8.547008142564577,name: "Goethe Bar"))
//        self.barList.append(Place(lat: 47.376124870475834,lon: 8.541386166088483,name: "Movie Restaurant and Bar"))
//        self.barList.append(Place(lat: 47.371130573961715,lon: 8.537323943141603,name: "Mövenpick Wein-Bar"))
//        self.barList.append(Place(lat: 47.36673426912936,lon: 8.536270669098537,name: "Onyx Bar"))
//        self.barList.append(Place(lat: 47.366921279925556,lon: 8.533578331853509,name: "Almodobar – Bar Lounge"))
//        self.barList.append(Place(lat: 47.37146139153977,lon: 8.542843982403278,name: "WINGS Airline Bar & Lounge"))
//        self.barList.append(Place(lat: 47.37402353517374,lon: 8.543610166894538,name: "Züri Bar"))
//        self.barList.append(Place(lat: 47.373077535233875,lon: 8.543919324874878,name: "Tina Bar"))
//        self.barList.append(Place(lat: 47.37331675747507,lon: 8.531723137142201,name: "Helvti Bar"))
//        self.barList.append(Place(lat: 47.373342,lon: 8.543817,name: "Restaurant Mexikano & Cuban Bar"))
//        self.barList.append(Place(lat: 47.38244149270345,lon: 8.540132992324093,name: "Bar & Lounge 42"))
//        self.barList.append(Place(lat: 47.37415195350545,lon: 8.536871433630834,name: "Nippon Sushi Bar"))
//        self.barList.append(Place(lat: 47.374204886815136,lon: 8.529926149776086,name: "Sherif’s Bar"))
//        self.barList.append(Place(lat: 47.367697234571004,lon: 8.54575627368673,name: "Kronenhalle Bar"))
//        self.barList.append(Place(lat: 47.375479016798664,lon: 8.54339495305972,name: "Grande Café & Bar"))
//        self.barList.append(Place(lat: 47.38516656631587,lon: 8.535383168210096,name: "Panama Bar & Restaurant"))
//        self.barList.append(Place(lat: 47.37500532609176,lon: 8.54387962363581,name: "Alexander Snack-Bar"))
//        self.barList.append(Place(lat: 47.368440546907514,lon: 8.542180955021328,name: "barfussbar"))
//        self.barList.append(Place(lat: 47.37454537207662,lon: 8.539752842207358,name: "Urania Tapas Bar"))
//        self.barList.append(Place(lat: 47.366028063792726,lon: 8.53677340504516,name: "Barfly’z"))
//        self.barList.append(Place(lat: 47.367328767443325,lon: 8.545793537925167,name: "Rosaly’s Restaurant & Bar"))
//        self.barList.append(Place(lat: 47.36862452516884,lon: 8.540764448978814,name: "Old Fashion Bar"))
//        self.barList.append(Place(lat: 47.377004554674045,lon:8.539515137672424,name: "Schweizerhof Bar"))
//        self.barList.append(Place(lat: 47.35818667254611,lon: 8.553995105532112,name: "Totò - Ristorante e Bar"))
//        self.barList.append(Place(lat: 47.369919844894525,lon: 8.534484993124845,name: "MOUDI - Bar & Restaurant"))
//        self.barList.append(Place(lat: 47.378194,lon: 8.52425,name: "Schönau Bar Restaurant"))
//        self.barList.append(Place(lat: 47.36941757387449,lon: 8.544071587594582,name: "Altstadt Bar"))
//        self.barList.append(Place(lat: 47.37819430447189,lon: 8.526906489459531,name: "Longstreet Bar"))
//        self.barList.append(Place(lat: 47.36863240543541,lon: 8.537337990928004,name: "Le Raymond Bar"))
//        self.barList.append(Place(lat: 47.37619669301417,lon: 8.535683286759294,name: "Rio Bar"))
//        self.barList.append(Place(lat: 47.36514549154508,lon: 8.548043973111007,name: "Masi Wine Bar"))
//        self.barList.append(Place(lat: 47.363795326288006,lon: 8.547773807553547,name: "Drinx Bar"))
//        self.barList.append(Place(lat: 47.37429440959302,lon: 8.51439088880916,name: "Berta - Bar & Café"))
//        self.barList.append(Place(lat: 47.36856483046523,lon: 8.545591498611909,name: "Wüste Bar"))
//        self.barList.append(Place(lat: 47.37378552376064,lon: 8.54281634707719,name: "01 Bar"))
//        self.barList.append(Place(lat: 47.37170497050914,lon: 8.543897369400863,name: "BarMünster"))
//        self.barList.append(Place(lat: 47.37179006910283,lon: 8.535116000162555,name: "Talacker BAR"))
//        self.barList.append(Place(lat: 47.39003909035854,lon: 8.521989108703064,name: "Studer’s Speisewirtschaft & Bar"))
    }
}
