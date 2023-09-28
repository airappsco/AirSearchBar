//
//  AirSearchBar.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/23.
//

import SwiftUI

public struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    @FocusState var focused: Bool
    @State var shouldShowTableView: Bool = false
    @State var forceHideTableView = false

    public init(text: Binding<String>, isSearching: Binding<Bool>) {
        _text = text
        _isSearching = isSearching
    }

    public var body: some View {
        VStack {
            Spacer()
            VStack {
                Spacer()

                LazyVStack(spacing: 8) {
                    if shouldShowTableView {
                        LazyVStack(spacing: 0) {
                            ScrollView(.vertical) {
                                LazyVStack(alignment: .leading) {
                                    ForEach(1...8, id: \.self) { found in
                                        HStack {
                                            "Nebulous: \(found) ".boldDifferenceFrom(text)
                                                .font(Font.system(size: 17, weight: .light, design: .rounded))
                                                .padding([.leading, .trailing])
                                                .padding(.top, 12)
                                        }.onTapGesture {
                                            self.text = "Nebulous: \(found) "
                                            forceHideTableView.toggle()
                                        }
                                    }
                                }
                                .padding([.bottom, .top])
                            }
                            .frame(maxHeight: 236)
                            .padding(.horizontal, 12)

                            Rectangle()
                                .foregroundColor(Color(red: 0.68, green: 0.68, blue: 0.68))
                                .frame(maxWidth: .infinity, minHeight: 0.5, maxHeight: 0.5)
                                .padding(.horizontal, 16)
                                .padding(.bottom)

                        }
                        .background(.white)
                        .cornerRadius(28, corners: [.topLeft, .topRight])
                        .padding(.horizontal, 16)
                        .padding(.bottom, -8)
                    }

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                            .padding(.leading, 16)

                        TextField(
                            "Search",
                            text: $text,
                            onEditingChanged: { _ in },
                            onCommit: {
                                // Handle search here if needed
                            }
                        )
                        .onAppear {
                            shouldShowTableView = text.isEmpty == false
                            focused = true
                        }
                        .onChange(of: text, perform: { value in
                            shouldShowTableView = text.isEmpty == false
                        })
                        .onChange(of: forceHideTableView, perform: { value in
                            shouldShowTableView = false
                        })
                        .padding(.leading, 2)
                        .padding(.trailing, 8)
                        .background(.clear)
                        .cornerRadius(8)
                        .padding(.trailing, 8)
                        .focused($focused)
                        .frame(height: 56)

                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.76))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .opacity(text.isEmpty ? 0 : 1)
                    }
                    .background(.white)
                    .cornerRadius(28, corners: shouldShowTableView ? [.bottomLeft, .bottomRight] : [.allCorners])
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                    .frame(height: 56)
                }

            }
            .compositingGroup()
            .shadow(color: .black.opacity(0.2), radius: 25, x: 0, y: 20)
        }
        .padding(.top, 8)
        .background(Color.clear)
        .onAppear {
            isSearching = true
        }
        .onDisappear {
            isSearching = false
            text = ""
        }
    }
}

public extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

public extension String {
    func commonSuffix(with other: String) -> String {
            let selfReversed = String(self.reversed())
            let otherReversed = String(other.reversed())
            var commonSuffix = ""

            for (selfChar, otherChar) in zip(selfReversed, otherReversed) {
                if selfChar == otherChar {
                    commonSuffix.append(selfChar)
                } else {
                    break
                }
            }

            return String(commonSuffix.reversed())
        }

    func boldDifferenceFrom(_ original: String) -> Text {
            let commonPrefix = self.commonPrefix(with: original)
            let commonSuffix = self.commonSuffix(with: original)

            let prefixText = Text(commonPrefix)
            let suffixText = Text(commonSuffix)
            let differenceText = Text(self.dropFirst(commonPrefix.count).dropLast(commonSuffix.count)).bold()

            return prefixText + differenceText + suffixText
        }
}
