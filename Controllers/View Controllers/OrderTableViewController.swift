//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Evgeniy Ryshkov on 19/11/2018.
//  Copyright © 2018 Evgeniy Ryshkov. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    let rowHeight: CGFloat = 60
    var order = Order()
    let menuController = MenuController()
    
//    var orderGroupped: [MenuItem] {
//        var result = [MenuItem]()
//
//        let nonDuplicatedArray = order.menuItems.removingDuplicates()
//
//        for var item in nonDuplicatedArray {
//            var count = 0
//            for item2 in order.menuItems {
//                if item2 == item {
//                    count += 1
//                }
//            }
//            item.detailText = "\(count)"
//            result.append(item)
//        }
//
//        return result
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    func layoutSetup() {
        tableView.tableFooterView = UIView()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return order.menuItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? MenuTableViewCell else {
            fatalError("Cannot cast MenuTableViewCell at \(#function) \(#file) line \(#line)")
        }
        
        cell.update(with: order.menuItems[indexPath.row])

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func updateBadge() {
        if order.getOrderPrice() > 0 {
            navigationController?.tabBarItem.badgeValue = "$\(order.getOrderPrice())"
        }else{
            navigationController?.tabBarItem.badgeValue = nil
        }
        
    }
    
    func cleanOrder() {
        self.order.menuItems.removeAll()
        updateBadge()
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    
    @IBAction func trashButtonTapped(_ sender: UIBarButtonItem) {
        cleanOrder()
    }
    
    @IBAction func checkOutButtonTapped(_ sender: UIBarButtonItem) {
        
        menuController.submitOrder(forMenuIDs: order.getMenuIDs()) {[unowned self](time) in
            DispatchQueue.main.async {
                if let prepTime = time {
                    let ac = UIAlertController(title: "Order received", message: "Preparation time \(prepTime) min", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self](_) in
                        self.cleanOrder()
                    })
                    
                    ac.addAction(alertAction)
                    self.present(ac, animated: true)
                }else{
                    let ac = UIAlertController(title: "Order isn't received", message: "Please try again later", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default)
                    
                    ac.addAction(alertAction)
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
}

extension OrderTableViewController: OrderPassable{
    
    func passData(_ data: Order) {
        
        for item in data.menuItems {
            order.menuItems.append(item)
            
        }
        
        updateBadge()
    }
}
