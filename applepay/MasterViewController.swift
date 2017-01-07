//
//  MasterViewController.swift
//  applepay
//
//  Created by nakajijapan on 2016/07/07.
//  Copyright © 2016 nakajijapan. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {


    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }

}

