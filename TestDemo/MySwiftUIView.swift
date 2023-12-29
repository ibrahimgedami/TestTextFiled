//
//  MySwiftUIView.swift
//  TestDemo
//
//  Created by Ibrahim Gedami on 28/12/2023.
//

import SwiftUI
import Charts

struct MySwiftUIView: View {
    let viewMonths = MockData().viewMonths
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Youtube Views")
            Text("Total: \(viewMonths.reduce(0, {$0 + ($1.views ?? 0) }))")
                .fontWeight(.semibold)
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.bottom, 12)
            barMarkChart
            
            
        }
        .padding()
    }
    
    var barMarkChart: some View {
        Chart {
            //                RuleMark(x: .value("Goal", 3500))
            RuleMark(y: .value("Goal", 8500))
                .foregroundStyle(Color.mint)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                .annotation(alignment: .leading) {
                    Text("Goal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            ForEach(viewMonths) { viewMonth in
                if let viewsCount = viewMonth.views, let date = viewMonth.date {
                    BarMark(
                        x: .value("Month", date, unit: .month),
                        y: .value("Views", viewsCount)
                        //                            x: .value("Views", viewsCount),
                        //                            y: .value("Month", date, unit: .month)
                    )
                    .foregroundStyle(.pink.gradient)
                }
            }
        }
        .frame(height: 200)
        .chartXAxis {
            AxisMarks(values: viewMonths.map({ $0.date ?? Date() })) { date in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.month(.narrow))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
//            .chartYScale(domain: 0...40000)
//            .chartPlotStyle { plotContent in
//                plotContent
//                    .background(.black.gradient.opacity(0.3))
//                    .border(.green, width: 1.5)
//            }
    }
}

struct MySwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MySwiftUIView()
    }
}
