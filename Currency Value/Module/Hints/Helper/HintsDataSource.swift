//
//  HintsDataSource.swift
//  Currency Value
//
//  Created by Sowrirajan S on 27/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class HintsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var hintsArray: NSDictionary?
    // MARK: - Table view Delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (hintsArray?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HintsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel?.text = hintsArray?.allKeys[indexPath.row] as? String
        cell.descriptionLabel?.text = hintsArray?.allValues[indexPath.row] as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }

}
