import Cocoa

class BreatheView: NSView {
    private var timer: Timer?
    private var startTime = Date()
    private var lastSize: CGFloat = 0
    
    func startAnimation() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/6.0, repeats: true) { _ in
            let elapsed = Date().timeIntervalSince(self.startTime)
            let progress = elapsed.truncatingRemainder(dividingBy: 19.0) / 19.0
            let currentSize = self.calculateSize(progress: progress)
            
            if abs(currentSize - self.lastSize) > 0.001 {
                self.lastSize = currentSize
                self.needsDisplay = true
            }
        }
    }
    
    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        let size = lastSize
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let outerRadius = size * 0.6
        let innerRadius = outerRadius * 0.6
        
        context.setFillColor(NSColor.labelColor.cgColor)
        
        let outerRect = CGRect(x: center.x - outerRadius, y: center.y - outerRadius, 
                              width: outerRadius * 2, height: outerRadius * 2)
        let innerRect = CGRect(x: center.x - innerRadius, y: center.y - innerRadius,
                              width: innerRadius * 2, height: innerRadius * 2)
        
        context.addEllipse(in: outerRect)
        context.addEllipse(in: innerRect)
        context.fillPath(using: .evenOdd)
    }
    
    private func calculateSize(progress: Double) -> CGFloat {
        let minSize: CGFloat = 4.0
        let maxSize: CGFloat = 12.0
        
        switch progress {
        case 0..<(4.0/19.0):
            // Inhale (4s)
            let t = progress / (4.0/19.0)
            return minSize + (maxSize - minSize) * CGFloat(t)
            
        case (4.0/19.0)..<(11.0/19.0):
            // Hold (7s)
            return maxSize
            
        case (11.0/19.0)..<(15.0/19.0):
            // Exhale (4s)
            let t = (progress - 11.0/19.0) / (4.0/19.0)
            return maxSize - (maxSize - minSize) * CGFloat(t)
            
        default:
            // Hold (4s)
            return minSize
        }
    }
}