import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var breatheView: BreatheView!
    var statusMenu: NSMenu!
    var chimeTimer: Timer?
    var isChimeMuted: Bool = true
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        // Create the menu
        statusMenu = NSMenu()
        
        let muteItem = NSMenuItem(title: isChimeMuted ? "Unmute Chime" : "Mute Chime", action: #selector(toggleChimeMute), keyEquivalent: "")
        muteItem.target = self
        statusMenu.addItem(muteItem)
        
        statusMenu.addItem(NSMenuItem.separator())
        
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
        
        playChimeSound()
        startChimeTimer()
    }
    
    @objc func statusBarButtonClicked() {
        if let statusButton = statusItem.button {
            statusMenu.popUp(positioning: nil, at: NSPoint(x: 0, y: statusButton.bounds.height), in: statusButton)
        }
    }
    
    @objc func toggleChimeMute() {
        isChimeMuted.toggle()
        updateMuteMenuItem()
    }
    
    private func updateMuteMenuItem() {
        if let muteItem = statusMenu.items.first {
            muteItem.title = isChimeMuted ? "Unmute Chime" : "Mute Chime"
        }
    }
    
    @objc func closeApp() {
        NSApplication.shared.terminate(self)
    }
    
    private func startChimeTimer() {
        chimeTimer = Timer.scheduledTimer(withTimeInterval: 15 * 60, repeats: true) { [weak self] _ in
            self?.playChimeSound()
        }
    }
    
    @objc private func playChimeSound() {
        guard !isChimeMuted else {
            print("Chime is muted, skipping sound")
            return
        }
        
        guard let soundPath = Bundle.main.path(forResource: "chime", ofType: "mp3") else {
            print("Error: Could not find chime.mp3 in bundle")
            return
        }
        
        print("Found chime file at: \(soundPath)")
        
        guard let sound = NSSound(contentsOfFile: soundPath, byReference: false) else {
            print("Error: Could not create NSSound from chime file")
            return
        }
        
        print("Playing chime...")
        sound.volume = 1.0
        let success = sound.play()
        print("Chime play result: \(success)")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        breatheView?.stopAnimation()
        chimeTimer?.invalidate()
    }
}