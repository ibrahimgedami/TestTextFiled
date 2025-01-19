//
//  MaterialDesignTextFieldView.swift
//  TestDemo
//
//  Created by Ibrahim Abdelgani on 18/01/2025.
//

import SwiftUI
import CustomSwiftUIFloatingTextField

public protocol MaterialTextFieldStyle {
    
    func body(content: MaterialTextField) -> MaterialTextField
    
}

public struct MaterialTextField: View {
    
    // MARK: Observed Object
    @ObservedObject var notifier = FloatingLabelTextFieldNotifier()
    
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
                TextField("", text: $textFieldValue)
                    .focused($isTextFieldFocused) // Bind focus state
                    .onChange(of: isTextFieldFocused) { _, isFocused in
                        withAnimation(.easeIn) {
                            isTapped = textFieldValue.isEmpty ? isFocused : true
                        }
                        self.isShowError = self.notifier.isRequiredField
                        self.validationChecker = self.currentError.condition
                        self.editingChanged(isFocused)
                    }
                    .onSubmit {
                        // Handles return key press
                        if textFieldValue.isEmpty {
                            withAnimation(.easeOut) {
                                isTapped = false
                                isTextFieldFocused = false
                            }
                            self.isShowError = self.notifier.isRequiredField
                            self.validationChecker = self.currentError.condition
                            self.commit()
                        } else {
                            debugPrint("nil")
                        }
                    }
                    .lineLimit(notifier.lineLimit)
                    .disabled(self.notifier.disabled)
                    .allowsHitTesting(self.notifier.allowsHitTesting)
                    .multilineTextAlignment(notifier.textAlignment)
                    .font(notifier.font)
                
                if let rightView = notifier.rightView {
                    rightView
                }
            }
            .padding(.top, isTapped ? 15 : 0)
            .background(
                Text(placeholderText)
                    .scaleEffect(isTapped ? 0.8 : 1)
                    .offset(x: isTapped ? -7 : 0, y: isTapped ? -15 : 0)
                    .foregroundStyle(isTapped ? notifier.selectedLineColor : notifier.lineColor),
                alignment: .leading
            )
            .padding(.horizontal)
            
            // Divider
            Rectangle()
                .fill(isTapped ? notifier.selectedLineColor : notifier.lineColor)
                .opacity(isTapped ? 1 : 0.5)
                .frame(height: 1)
                .padding(.top, 10)
        }
        .padding(.top, 12)
        .background(notifier.backgroundColor)
        .cornerRadius(12)
        
        if let validationView = notifier.validationMessageView {
            validationView
        }
    }
    
}

@available(iOS 15.0, *)
extension MaterialTextField {
    
    // MARK: FloatingLabelTextField Style Function
    public func floatingStyle<S>(_ style: S) -> some View where S: MaterialTextFieldStyle {
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
    
    /// Sets the validationMessage (bottom view) view
    public func validationMessageView<LRView: View>(@ViewBuilder _ view: @escaping () -> LRView) -> Self {
        notifier.validationMessageView = AnyView(view())
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
    
    public func backgroundColor(_ color: Color) -> Self {
        notifier.backgroundColor = color
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


#Preview {
    @Previewable @State var userName: String = ""
    @Previewable @State var fullName: String = ""
    @Previewable @State var showDropdown: Bool = false
    
    MaterialTextField($userName, placeholder: "User Name") { _ in } commit: {
        
    }
    
    MaterialTextField($fullName, placeholder: "Full name")
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
                VStack {
                    Text("Text 1")
                    Text("Text 1")
                }
                .background(.red)
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
    
}
