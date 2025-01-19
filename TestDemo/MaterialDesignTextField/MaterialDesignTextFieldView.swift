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
                            isTapped = true
                        }
                        self.isShowError = self.notifier.isRequiredField
                        self.validationChecker = self.currentError.condition
                        self.editingChanged(isFocused)
                    }
                    .onSubmit {
                        // Handles return key press
                        if manager.text == "" {
                            withAnimation(.easeOut) {
                                isTapped = false
                            }
                        }
                        self.isShowError = self.notifier.isRequiredField
                        self.validationChecker = self.currentError.condition
                        self.commit()
                    }
                    .lineLimit(notifier.lineLimit)
                    .disabled(self.notifier.disabled)
                    .allowsHitTesting(self.notifier.allowsHitTesting)
                    .multilineTextAlignment(notifier.textAlignment)
                    .font(notifier.font)
                
                if let rightView = notifier.rightView {
                    rightView
                        .frame(height: 25)
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
    MaterialDesignTextField(.constant(""),
                            validationChecker: .constant(true),
                            placeholder: "User Name",
                            axis: .vertical) { status in
        
    } commit: {
        
    }
    
    MaterialDesignTextField(.constant(""),
                            validationChecker: .constant(true),
                            placeholder: "Full name",
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

@available(iOS 15.0, *)
extension MaterialDesignTextField {
    
    // MARK: FloatingLabelTextField Style Function
    public func floatingStyle<S>(_ style: S) -> some View where S: MaterialDesignTextFieldStyle {
        return style.body(content: self)
    }
    
    // MARK: View Property Function
    /// Sets the left view.
    public func leftView<LRView: View>(@ViewBuilder _ view: @escaping () -> LRView) -> Self {
        notifier.leftView = AnyView(view())
        return self
    }
    
    /// Sets the right view.
    public func rightView<LRView: View>(@ViewBuilder _ view: @escaping () -> LRView) -> Self {
        notifier.rightView = AnyView(view())
        return self
    }
    
    // MARK: Text Property Function
    /// Sets the alignment for text.
    public func textAlignment(_ alignment: TextAlignment) -> Self {
        notifier.textAlignment = alignment
        return self
    }
    
    /// Sets the secure text entry for TextField.
    public func isSecureTextEntry(_ isSecure: Bool) -> Self {
        notifier.isSecureTextEntry = isSecure
        return self
    }
    
    /// Whether users can interact with this.
    public func disabled(_ isDisabled: Bool) -> Self {
        notifier.disabled = isDisabled
        return self
    }
    
    /// Whether this view participates in hit test operations.
    public func allowsHitTesting(_ isAllowsHitTesting: Bool) -> Self {
        notifier.allowsHitTesting = isAllowsHitTesting
        return self
    }
    
    public func lineLimit(_ limit: Int) -> Self {
        notifier.lineLimit = limit
        return self
    }
    
    // MARK: Line Property Function
    /// Sets the line height.
    public func lineHeight(_ height: CGFloat) -> Self {
        notifier.lineHeight = height
        return self
    }
    
    /// Sets the selected line height.
    public func selectedLineHeight(_ height: CGFloat) -> Self {
        notifier.selectedLineHeight = height
        return self
    }
    
    /// Sets the line color.
    public func lineColor(_ color: Color) -> Self {
        notifier.lineColor = color
        return self
    }
    
    /// Sets the selected line color.
    public func selectedLineColor(_ color: Color) -> Self {
        notifier.selectedLineColor = color
        return self
    }
    
    // MARK: Title Property Function
    /// Sets the title color.
    public func titleColor(_ color: Color) -> Self {
        notifier.titleColor = color
        return self
    }
    
    /// Sets the selected title color.
    public func selectedTitleColor(_ color: Color) -> Self {
        notifier.selectedTitleColor = color
        return self
    }
    
    /// Sets the title font.
    public func titleFont(_ font: Font) -> Self {
        notifier.titleFont = font
        return self
    }
    
    /// Sets the space between title and text.
    public func spaceBetweenTitleText(_ space: Double) -> Self {
        notifier.spaceBetweenTitleText = space
        return self
    }
    
    // MARK: Text Property Function
    /// Sets the text color.
    public func textColor(_ color: Color) -> Self {
        notifier.textColor = color
        return self
    }
    
    /// Sets the selected text color.
    public func selectedTextColor(_ color: Color) -> Self {
        notifier.selectedTextColor = color
        return self
    }
    
    /// Sets the text font.
    public func textFont(_ font: Font) -> Self {
        notifier.font = font
        return self
    }
    
    // MARK: Placeholder Property Function
    /// Sets the placeholder color.
    public func placeholderColor(_ color: Color) -> Self {
        notifier.placeholderColor = color
        return self
    }
    
    /// Sets the placeholder font.
    public func placeholderFont(_ font: Font) -> Self {
        notifier.placeholderFont = font
        return self
    }
    
    // MARK: Error Property Function
    /// Sets the is show error message.
    public func isShowError(_ show: Bool) -> Self {
        notifier.isShowError = show
        return self
    }
    
    /// Sets the validation conditions.
    public func addValidations(_ conditions: [TextFieldValidator]) -> Self {
        notifier.arrValidator.append(contentsOf: conditions)
        return self
    }
    
    /// Sets the validation condition.
    public func addValidation(_ condition: TextFieldValidator) -> Self {
        notifier.arrValidator.append(condition)
        return self
    }
    
    /// Sets the error color.
    public func errorColor(_ color: Color) -> Self {
        notifier.errorColor = color
        return self
    }
    
    /// Sets the field is required or not with message.
    public func isRequiredField(_ required: Bool, with message: String) -> Self {
        notifier.isRequiredField = required
        notifier.requiredFieldMessage = message
        return self
    }
    
    // MARK: Text Field Editing Function
    /// Disable text field editing action. Like cut, copy, past, all etc.
    public func addDisableEditingAction(_ actions: [TextFieldEditActions]) -> Self {
        notifier.arrTextFieldEditActions = actions
        return self
    }
    
    // MARK: Animation Style Function
    /// Enable the placeholder label when the textfield is focused.
    public func enablePlaceholderOnFocus(_ isEnabled: Bool) -> Self {
        notifier.isAnimateOnFocus = isEnabled
        return self
    }
    
    /// Sets whether the text field is enabled for typing or not.
    public func isTextFieldEnabled(_ isEnabled: Bool) -> Self {
        notifier.disabled = !isEnabled
        notifier.allowsHitTesting = isEnabled
        return self
    }
    
}
