//
//  MySwiftUIView.swift
//  TestDemo
//
//  Created by Ibrahim Gedami on 28/12/2023.
//

import SwiftUI
import Charts
import CustomSwiftUIFloatingTextField

struct MySwiftUIView: View {
    let viewMonths = MockData().viewMonths
    
    @State var userName: String = ""
    @State var fullName: String = ""
    @State var showDropdown: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            MaterialTextField($userName, placeholder: "User Name") { status in
            } commit: {
            }
            
            MaterialTextField($fullName, placeholder: "Full name") { status in
                
            } commit: {
                
            }
            .rightView {
                Button(action: {
                    showDropdown.toggle()
                }) {
                    Image(systemName: "chevron.down")
                        .imageScale(.medium)
                        .padding(.horizontal)
                        .foregroundStyle(.white)
                }
                .frame(width: 40, height: 40)
                .background(.blue)
        //        .clipShape(RoundedCorner(radius: 12, corners: [.bottomRight, .topRight]))
                .onTapGesture {
                    showDropdown.toggle()
                }
                .popover(isPresented: $showDropdown) {
        //            CustomSearchableList(items: items, showSearchView: showSearchView) { item in
        //                showDropdown = false
        //                fieldText = item.displayedText ?? ""
        //                onSelect(item)
        //            }
        //            .frame(maxWidth: 250)
        //            .onDisappear {
        //                showDropdown = false
        //            }
                }
            }
            .validationMessageView {
                HStack {
                    Text("your name shpould be more than 3 char")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.leading)
                    
                    Spacer()
                }
            }
            
            FloatingLabelTextField(.constant("Text"), validationChecker: .constant(true), placeholder: "Text", editingChanged: { _ in
                
            }, commit: {
                
            })
            .rightView {
                Text("Text")
            }
        }
        .padding()
    }
    
    var barMarkChart: some View {
        Chart {
            //                RuleMark(x: .value("Goal", 3500))
            //            RuleMark(y: .value("Goal", 8500))
            //                .foregroundStyle(Color.mint)
            //                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            //                .annotation(alignment: .leading) {
            //                    Text("Goal")
            //                        .font(.caption)
            //                        .foregroundColor(.secondary)
            //                }
            ForEach(viewMonths) { viewMonth in
                if let viewsCount = viewMonth.views, let date = viewMonth.date {
                    BarMark(
                        x: .value("Month", date, unit: .day),
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
            AxisMarks(values: viewMonths.map({ $0.date!})) { date in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.day())
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
    
    var areaMarkChart: some View {
        Chart {
            //                RuleMark(x: .value("Goal", 3500))
            //            RuleMark(y: .value("Goal", 8500))
            //                .foregroundStyle(Color.mint)
            //                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            //                .annotation(alignment: .leading) {
            //                    Text("Goal")
            //                        .font(.caption)
            //                        .foregroundColor(.secondary)
            //                }
            ForEach(viewMonths) { viewMonth in
                if let viewsCount = viewMonth.views, let date = viewMonth.date {
                    AreaMark(
                        x: .value("Month", date, unit: .day),
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
            AxisMarks(values: viewMonths.map({ $0.date! })) { date in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.day())
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

import SwiftUI
import Charts

struct FoodIntake: Hashable {
    let date: Date
    let calories: Int
}

func date(year: Int, month: Int, day: Int) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
}

let intake = stride(from: 1, to: 31, by: 1).map { day in
    FoodIntake(date: date(year: 2022, month: 5, day: day), calories: Int.random(in: 1800...2200))
}

struct ChartTest: View {
    @State var selectedElement: FoodIntake?
    
    var body: some View {
        Chart {
            ForEach(intake, id: \.self) { data in
                BarMark(x: .value("Date", data.date),
                        y: .value("Calories", data.calories))
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElement(location: value.location, proxy: proxy, geometry: geo)
                                if selectedElement?.date == element?.date {
                                    // If tapping the same element, clear the selection.
                                    selectedElement = nil
                                } else {
                                    selectedElement = element
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElement = findElement(location: value.location, proxy: proxy, geometry: geo)
                                    }
                            )
                    )
            }
        }
        .chartBackground { proxy in
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    if let selectedElement = selectedElement {
                        let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElement.date)!
                        let startPositionX = proxy.position(forX: dateInterval.start) ?? 0
                        let midStartPositionX = startPositionX + geo[proxy.plotAreaFrame].origin.x
                        let lineHeight = geo[proxy.plotAreaFrame].maxY
                        let boxWidth: CGFloat = 150
                        let boxOffset = max(0, min(geo.size.width - boxWidth, midStartPositionX - boxWidth / 2))
                        
                        Rectangle()
                            .fill(.quaternary)
                            .frame(width: 2, height: lineHeight)
                            .position(x: midStartPositionX, y: lineHeight / 2)
                        
                        VStack(alignment: .leading) {
                            Text("\(selectedElement.date, format: .dateTime.year().month().day())")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text("\(selectedElement.calories, format: .number) calories")
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                        }
                        .frame(width: boxWidth, alignment: .leading)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.background)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.quaternary.opacity(0.7))
                            }
                            .padding([.leading, .trailing], -8)
                            .padding([.top, .bottom], -4)
                        }
                        .offset(x: boxOffset)
                    }
                }
            }
        }
        .frame(height: 250)
        .padding()
    }
    
    func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> FoodIntake? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in intake.indices {
                let nthDataDistance = intake[dataIndex].date.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return intake[index]
            }
        }
        return nil
    }
}
struct MySwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChartTest()
    }
}
