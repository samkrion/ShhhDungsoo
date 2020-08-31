//
//  AppDelegate.swift
//  ShhhDungsoo
//
//  Created by Kyujin Cho on 2020/08/28.
//  Copyright © 2020 Kyujin Cho. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var enabled = true
    var isWorkHour = false

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let enableItem = NSMenuItem(title: "Enabled", action: #selector(enableButtonChecked), keyEquivalent: "e")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let hourAndMinute = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let minutes = (hourAndMinute.hour ?? 0) * 60 + (hourAndMinute.minute ?? 0)
        isWorkHour = minutes >= 600 && minutes <= 1140
        if isWorkHour { enable() } else { disable() }
        
        constructMenu()

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.enabled && !NSSound.systemVolumeIsMuted {
                NSSound.systemVolumeIsMuted = true
            }
            let hourAndMinute = Calendar.current.dateComponents([.hour, .minute], from: Date())
            let minutes = (hourAndMinute.hour ?? 0) * 60 + (hourAndMinute.minute ?? 0)
            if self.isWorkHour && (minutes > 1140 || minutes < 600) {
                self.isWorkHour = false
                self.disable()
            }
            if !self.isWorkHour && (minutes >= 600 && minutes <= 1140) {
                self.isWorkHour = true
                self.enable()
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func enable() {
        enableItem.state = .on
        enabled = true
        if let button = statusItem.button {
            let btnImage = #imageLiteral(resourceName: "StatusBarEnabledButtonImage")
            button.image = btnImage
        }
    }
    
    func disable() {
        enableItem.state = .off
        enabled = false
        if let button = statusItem.button {
            let btnImage = #imageLiteral(resourceName: "StatusBarButtonImage")
            button.image = btnImage
        }
    }
    
    @objc func enableButtonChecked() {
        if enabled {
            disable()
        } else {
            enable()
        }
    }
 
    func constructMenu() {
        let menu = NSMenu()
        enableItem.state = .on
        menu.addItem(enableItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit ShhhDungsoo", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
}

