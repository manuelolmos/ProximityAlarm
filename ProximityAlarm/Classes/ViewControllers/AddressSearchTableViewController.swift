//
//  AddressSearchTableViewController.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 07/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import UIKit
import MapKit

protocol MapSearchDelegate: class {
    func addressSelected(placemark: MKPlacemark)
}

class AddressSearchTableViewController: UITableViewController, UISearchResultsUpdating {

    private var results = [MKMapItem]()
    weak var mapView: MKMapView?
    weak var mapSearchDelegate: MapSearchDelegate?

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell")!
        let selectedItem = results[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = AddressHelper().parseAddress(selectedItem: selectedItem)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = results[indexPath.row].placemark
        mapSearchDelegate?.addressSelected(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { [unowned self] response, _ in
            if let response = response {
                self.results = response.mapItems
                self.tableView.reloadData()
            }
        }
    }
}
