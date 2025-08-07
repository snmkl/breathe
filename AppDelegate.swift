import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var breatheView: BreatheView!
    var statusMenu: NSMenu!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        // Create the menu
        statusMenu = NSMenu()
        let closeItem = NSMenuItem(title: "Close", action: #selector(closeApp), keyEquivalent: "")
        closeItem.target = self
        statusMenu.addItem(closeItem)
        
        if let statusButton = statusItem.button {
            let buttonFrame = statusButton.bounds
            let viewSize: CGFloat = 18
            breatheView = BreatheView(frame: NSRect(
                x: (buttonFrame.width - viewSize) / 2,
                y: (buttonFrame.height - viewSize) / 2,
                width: viewSize,
                height: viewSize
            ))
            statusButton.addSubview(breatheView)
            breatheView.startAnimation()
            
            statusButton.action = #selector(statusBarButtonClicked)
            statusButton.target = self
        }
    }
    
    @objc func statusBarButtonClicked() {
        if let statusButton = statusItem.button {
            statusMenu.popUp(positioning: nil, at: NSPoint(x: 0, y: statusButton.bounds.height), in: statusButton)
        }
    }
    
    @objc func closeApp() {
        NSApplication.shared.terminate(self)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        breatheView?.stopAnimation()
    }
}