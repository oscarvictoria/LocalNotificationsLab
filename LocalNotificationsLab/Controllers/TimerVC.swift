//
//  ViewController.swift
//  LocalNotificationsLab
//
//  Created by Oscar Victoria Gonzalez  on 2/20/20.
//  Copyright © 2020 Oscar Victoria Gonzalez . All rights reserved.
//

import UIKit

class TimerVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    private let center = UNUserNotificationCenter.current()
    
    private var refreshControll: UIRefreshControl!
    
    private var notifications = [UNNotificationRequest]() {
         didSet {
             DispatchQueue.main.async {
                 self.tableView.reloadData()
             }
         }
     }
    
    private let pendingNotification = PendingNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureRefreshControll()
        checkForNotificationPermission()
        center.delegate = self
        loadNotification()
    }

    private func configureRefreshControll() {
        refreshControll = UIRefreshControl()
        tableView.refreshControl = refreshControll
        refreshControll.addTarget(self, action: #selector(loadNotification), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           guard let navController = segue.destination as? UINavigationController,
               let createVC = navController.viewControllers.first as? CreateTimerVC else {
                   fatalError("error")
           }
           createVC.delegate = self
       }
    
    func configureTableView() {
        tableView.dataSource = self
    }
    
    private func checkForNotificationPermission() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("app is authorized for notifications")
            } else {
                self.requestNotificationPermission()
            }
        }
     }
    
    private func requestNotificationPermission() {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("error requesting authorization \(error)")
                return
            }
            if granted {
                print("access was granted")
            } else {
                print("access denied")
            }
        }
    }
    
   @objc private func loadNotification() {
         pendingNotification.getPendingNotifications { (request) in
             self.notifications = request
//              stop the refresh control from animating and remove from the UI
             DispatchQueue.main.async {
                 self.refreshControll.endRefreshing()
             }
         }
     }
    
}

extension TimerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.content.title
        cell.detailTextLabel?.text = notification.content.body
        return cell
    }
    
}

extension TimerVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

extension TimerVC: NotificationControllerDelegate {
    func didCreateNotification(_ createNotification: CreateTimerVC) {
        loadNotification()
    }
}
