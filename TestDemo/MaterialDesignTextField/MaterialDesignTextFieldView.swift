//
//  MaterialDesignTextFieldView.swift
//  TestDemo
//
//  Created by Ibrahim Abdelgani on 18/01/2025.
//

import SwiftUI
import CustomSwiftUIFloatingTextField

public protocol MaterialDesignTextFieldStyle {
    
    func body(content: MaterialDesignTextField) -> MaterialDesignTextField
    
}

public struct MaterialDesignTextField: View {
    
    // MARK: Observed Object
    @ObservedObject var manager = TextFieldManager()
    @ObservedObject private var notifier = FloatingLabelTextFieldNotifier()
    
    // MARK: Binding Property
    @Binding private var textFieldValue: String
    private var isSecure: Bool?
    @State private var isEditing: Bool = false
    @State private var isTapped: Bool = false
    @Binding private var validationChecker: Bool
    
    private var currentError: TextFieldValidator {
        if notifier.isRequiredField && isShowError && textFieldValue.isEmpty {
            return TextFieldValidator(condition: false, errorMessage: notifier.requiredFieldMessage)
        }
        
        if let firstError = notifier.arrValidator.filter({!$0.condition}).first {
            return firstError
        }
        return TextFieldValidator(condition: true, errorMessage: "")
    }
    @State private var isShowError: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    var shouldActivateTextFieldPickerWhileTapOnRightView: Bool
    
    // MARK: Properties
    private let axis: Axis
    private var placeholderText: String = ""
    private var editingChanged: (Bool) -> Void = { _ in }
    private var commit: () -> Void = { }
    
    // MARK: Init
    public init(_ text: Binding<String>,
                validationChecker: Binding<Bool>? = nil,
                placeholder: String = "",
                shouldActivateTextFieldPickerWhileTapOnRightView: Bool? = false,
                axis: Axis = .horizontal,
                editingChanged: @escaping (Bool) -> Void = { _ in },
                commit: @escaping () -> Void = { }) {
        self._textFieldValue = text
        self.placeholderText = placeholder
        self.axis = axis
        self.editingChanged = editingChanged
        self.commit = commit
        self._validationChecker = validationChecker ?? Binding.constant(false)
        self.shouldActivateTextFieldPickerWhileTapOnRightView = shouldActivateTextFieldPickerWhileTapOnRightView ?? false
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 15) {
                TextField("", text: $manager.text)
                    .focused($isTextFieldFocused) // Bind focus state
                    .onChange(of: isTextFieldFocused) { _, isFocused in
                        withAnimation(.easeIn) {
                            isTapped = isFocused
                        }
                    }
                    .onSubmit {
                        // Handles return key press
                        if manager.text.isEmpty {
                            withAnimation(.easeOut) {
                                isTapped = false
                            }
                        }
                    }
                
                Button {
                    // Button action
                } label: {
                    Image(systemName: "suit.heart")
                }
            }
            .padding(.top, isTapped ? 15 : 0)
            .background(
                Text(placeholderText)
                    .scaleEffect(isTapped ? 0.8 : 1)
                    .offset(x: isTapped ? -7 : 0, y: isTapped ? -15 : 0)
                    .foregroundStyle(isTapped ? .blue : .gray),
                alignment: .leading
            )
            .padding(.horizontal)
            
            // Divider
            Rectangle()
                .fill(isTapped ? .blue : .gray)
                .opacity(isTapped ? 1 : 0.5)
                .frame(height: 1)
                .padding(.top, 10)
        }
        .padding(.top, 12)
        .background(Color.gray.opacity(0.09))
        .cornerRadius(12)
        
        // Displaying count
        HStack {
            Text("\(manager.text.count) / 15")
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.leading)
                .padding(.top, 4)
            
            Spacer()
        }
    }

}

#Preview {
    
    MaterialDesignTextField(.constant("User Name"),
                            validationChecker: .constant(true),
                        placeholder: "User Name",
                            axis: .vertical) { status in
        
    } commit: {
        
    }

}

class TextFieldManager: ObservableObject {
    
    @Published var text = "" {
        didSet {
            if text.count >= 15 && oldValue.count <= 15 {
                text = oldValue
            }
        }
    }
    
}
