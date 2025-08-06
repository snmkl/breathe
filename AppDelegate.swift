import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var breatheView: BreatheView!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
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
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        breatheView?.stopAnimation()
    }
}