//
//  CenterFinder.swift
//  IG
//
//  Created by Tariq on 3/17/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class CenterFinder: UIViewController {

    @IBOutlet weak var centersTableView: UITableView!
    
    var centers = [CenterData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        centersTableView.delegate = self
        centersTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Centers"
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }

}
extension CenterFinder: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return centers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CenterFinderCell", for: indexPath) as! CenterFinderCell
        cell.selectionStyle = .none
        cell.confige(center: centers[indexPath.row].name ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "IGGuide", bundle: Bundle.main).instantiateViewController(withIdentifier: "CenterDetails") as? CenterDetails
        vc?.center = centers[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
