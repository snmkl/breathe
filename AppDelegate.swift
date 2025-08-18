import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var breatheView: BreatheView!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            breatheView = BreatheView(frame: NSRect(x: 0, y: 0, width: 18, height: 18))
            breatheView.center = CGPoint(x: button.bounds.midX, y: button.bounds.midY)
            button.addSubview(breatheView)
            breatheView.startAnimation()
            
            button.action = #selector(showMenu)
            button.target = self
        }
    }
    
    @objc func showMenu() {
        let menu = NSMenu()
        let closeItem = NSMenuItem(title: "Close", action: #selector(closeApp), keyEquivalent: "")
        closeItem.target = self
        menu.addItem(closeItem)
        
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }
    
    @objc func closeApp() {
        NSApplication.shared.terminate(self)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        breatheView?.stopAnimation()
    }
}

extension NSView {
    var center: CGPoint {
        get { CGPoint(x: frame.midX, y: frame.midY) }
        set { frame = CGRect(x: newValue.x - frame.width/2, y: newValue.y - frame.height/2, width: frame.width, height: frame.height) }
    }
}