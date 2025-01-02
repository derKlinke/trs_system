import SwiftUI
import Charts

public struct TRSLineGraph: View {
    private var dataPoints: [Float]

    public init(dataPoints: [Float]) {
        self.dataPoints = dataPoints
    }

    public var body: some View {
        Chart(Array(dataPoints.enumerated()), id: \.offset) { index, value in
            LineMark(x: .value("Index", index), y: .value("Value", value))
        }
    }
}
