import SwiftUI

// MARK: - CALineGraphLayer
class CALineGraphLayer: CALayer {
    var dataPoints: [Float] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    var lineColor: CGColor = NSColor.blue.cgColor {
        didSet {
            setNeedsDisplay()
        }
    }

    var lineWidth: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(in ctx: CGContext) {
        guard dataPoints.count > 1 else {
            return
        }

        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)

        let path = CGMutablePath()

        // Compute min and max Y from dataPoints
        guard let minYValue = dataPoints.min(), let maxYValue = dataPoints.max(),
              minYValue != maxYValue else {
            return
        }
        let yRange = CGFloat(maxYValue - minYValue)

        // Add padding to prevent clipping
        let padding = lineWidth / 2
        let drawingRect = bounds.insetBy(dx: padding, dy: padding)

        let points = dataPoints.enumerated().map { index, point -> CGPoint in
            let x = CGFloat(index) / CGFloat(dataPoints.count - 1) * drawingRect.width + drawingRect.minX
            let y = ((CGFloat(point) - CGFloat(minYValue)) / yRange * drawingRect.height) + drawingRect.minY
            return CGPoint(x: x, y: y)
        }

        path.move(to: points[0])

        // Use simple cubic Bezier curves for smoothing
        for i in 1 ..< points.count {
            let previousPoint = points[i - 1]
            let currentPoint = points[i]
            let midPoint = CGPoint(x: (previousPoint.x + currentPoint.x) / 2,
                                   y: (previousPoint.y + currentPoint.y) / 2)

            path.addQuadCurve(to: midPoint, control: previousPoint)
            path.addQuadCurve(to: currentPoint, control: midPoint)
        }

        ctx.addPath(path)
        ctx.setStrokeColor(lineColor)
        ctx.setLineWidth(lineWidth)
        ctx.setLineCap(.round)
        ctx.setLineJoin(.round)

        ctx.setBlendMode(.normal)
        ctx.setShouldSmoothFonts(true)
        ctx.setRenderingIntent(.absoluteColorimetric)

        ctx.strokePath()
    }
}

// MARK: - CALineGraphView
public class CALineGraphView: NSView {
    private let graphLayer = CALineGraphLayer()

    var dataPoints: [Float] = [] {
        didSet {
            graphLayer.dataPoints = dataPoints
        }
    }

    var lineColor: NSColor = .blue {
        didSet {
            graphLayer.lineColor = lineColor.cgColor
        }
    }

    var lineWidth: CGFloat = 1.0 {
        didSet {
            graphLayer.lineWidth = lineWidth
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }

    private func setupLayer() {
        wantsLayer = true
        layer = CALayer()
        layer?.addSublayer(graphLayer)

        graphLayer.frame = bounds
        graphLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        graphLayer.contentsScale = window?.screen?.backingScaleFactor ?? 2.0
    }

    override public func layout() {
        super.layout()
        graphLayer.frame = bounds
    }
}

// MARK: - TRSLineGraph
public struct TRSLineGraph: NSViewRepresentable {
    var dataPoints: [Float]
    var lineColor = NSColor(DynamicTRSColor.headline.color)
    var lineWidth: CGFloat = 1.0

    public init(dataPoints: [Float], lineColor: NSColor = NSColor(DynamicTRSColor.headline.color),
                lineWidth: CGFloat = 1.0) {
        self.dataPoints = dataPoints
        self.lineColor = lineColor
        self.lineWidth = lineWidth
    }

    public func makeNSView(context: Context) -> CALineGraphView {
        let view = CALineGraphView(frame: .zero)
        view.lineColor = lineColor
        view.lineWidth = lineWidth
        return view
    }

    public func updateNSView(_ nsView: CALineGraphView, context: Context) {
        nsView.dataPoints = dataPoints
        nsView.lineColor = lineColor
        nsView.lineWidth = lineWidth
    }
}
