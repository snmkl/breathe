import Cocoa

class BreatheView: NSView {
    private var timer: Timer?
    private var animationStartTime: Date = Date()
    private let cycleDuration: TimeInterval = 19.0  // 4-7-4-4 breathing pattern
    private let minSize: CGFloat = 4.0
    private let maxSize: CGFloat = 12.0
    private var lastDotSize: CGFloat = 0.0
    private var isInStaticPhase: Bool = false
    
    private let phase1Duration: Double = 4.0/19.0  // Inhale: 4 seconds
    private let phase2Duration: Double = 7.0/19.0  // Hold big: 7 seconds  
    private let phase3Duration: Double = 4.0/19.0  // Exhale: 4 seconds
    private let phase4Duration: Double = 4.0/19.0  // Hold small: 4 seconds
    
    private var cachedCenterX: CGFloat = 0
    private var cachedCenterY: CGFloat = 0
    private var lastBounds: CGRect = .zero
    
    private lazy var fillColor = NSColor.labelColor.cgColor
    
    func startAnimation() {
        animationStartTime = Date()
        lastDotSize = 0.0
        isInStaticPhase = false
        updateCachedCenter()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/6.0, repeats: true) { [weak self] _ in
            self?.checkAndRedraw()
        }
    }
    
    private func updateCachedCenter() {
        if lastBounds != bounds {
            cachedCenterX = bounds.width / 2
            cachedCenterY = bounds.height / 2
            lastBounds = bounds
        }
    }
    
    private func checkAndRedraw() {
        let elapsed = Date().timeIntervalSince(animationStartTime)
        let cycleProgress = (elapsed.truncatingRemainder(dividingBy: cycleDuration)) / cycleDuration
        let currentDotSize = calculateDotSize(for: cycleProgress)
        
        let isCurrentlyStatic = isStaticPhase(cycleProgress)
        
        if !isInStaticPhase || !isCurrentlyStatic || abs(currentDotSize - lastDotSize) > 0.001 {
            lastDotSize = currentDotSize
            isInStaticPhase = isCurrentlyStatic
            needsDisplay = true
        }
    }
    
    private func isStaticPhase(_ progress: Double) -> Bool {
        return (progress >= phase1Duration && progress < (phase1Duration + phase2Duration)) ||
               (progress >= (phase1Duration + phase2Duration + phase3Duration) && progress < 1.0)
    }
    
    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        updateCachedCenter()
        
        let outerRadius = lastDotSize * 0.6
        let innerRadius = outerRadius * 0.6
        
        context.setFillColor(fillColor)
        
        let outerRect = CGRect(x: cachedCenterX - outerRadius, y: cachedCenterY - outerRadius, 
                              width: outerRadius * 2, height: outerRadius * 2)
        let innerRect = CGRect(x: cachedCenterX - innerRadius, y: cachedCenterY - innerRadius,
                              width: innerRadius * 2, height: innerRadius * 2)
        
        context.addEllipse(in: outerRect)
        context.addEllipse(in: innerRect)
        context.fillPath(using: .evenOdd)
    }
    
    private func calculateDotSize(for progress: Double) -> CGFloat {
        switch progress {
        case 0..<phase1Duration:
            // Inhale (4s): grow from min to max
            let inhaleProgress = progress / phase1Duration
            let easeProgress = easeInOutQuad(inhaleProgress)
            return minSize + (maxSize - minSize) * CGFloat(easeProgress)
            
        case phase1Duration..<(phase1Duration + phase2Duration):
            // Hold big (7s): stay at max size
            return maxSize
            
        case (phase1Duration + phase2Duration)..<(phase1Duration + phase2Duration + phase3Duration):
            // Exhale (4s): shrink from max to min
            let exhaleStart = phase1Duration + phase2Duration
            let exhaleProgress = (progress - exhaleStart) / phase3Duration
            let easeProgress = easeInOutQuad(exhaleProgress)
            return maxSize - (maxSize - minSize) * CGFloat(easeProgress)
            
        default:
            // Hold small (4s): stay at min size
            return minSize
        }
    }
    
    private func easeInOutQuad(_ t: Double) -> Double {
        return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
    }
}