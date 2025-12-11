import SwiftUI

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.primary)
            .cornerRadius(AppTheme.CornerRadius.lg)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(AppTheme.Animation.short, value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.headline)
            .foregroundColor(AppTheme.Colors.primary)
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg)
                    .stroke(AppTheme.Colors.primary, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(AppTheme.Animation.short, value: configuration.isPressed)
    }
}

struct DangerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.error)
            .cornerRadius(AppTheme.CornerRadius.lg)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(AppTheme.Animation.short, value: configuration.isPressed)
    }
}

// MARK: - Card Style
struct CardStyle: ViewModifier {
    let showShadow: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.background)
            .cornerRadius(AppTheme.CornerRadius.lg)
            .if(showShadow) { view in
                view.shadowMedium()
            }
    }
}

extension View {
    func cardStyle(shadow: Bool = true) -> some View {
        modifier(CardStyle(showShadow: shadow))
    }
}

// MARK: - Text Input Style
struct TextInputStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.body)
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.secondaryBackground)
            .cornerRadius(AppTheme.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md)
                    .stroke(AppTheme.Colors.secondaryLight, lineWidth: 1)
            )
    }
}

extension TextField {
    func textInputStyle() -> some View {
        self
            .modifier(TextInputStyle())
    }
}

// MARK: - Conditional Modifier
extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Loading Overlay
struct LoadingOverlay: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool) -> some View {
        modifier(LoadingOverlay(isLoading: isLoading))
    }
}

// MARK: - Error Toast
struct ErrorToast: ViewModifier {
    let message: String?
    let isVisible: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            if isVisible, let message = message {
                VStack {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(AppTheme.Colors.error)
                        
                        Text(message)
                            .foregroundColor(AppTheme.Colors.error)
                            .font(AppTheme.Typography.callout)
                        
                        Spacer()
                    }
                    .padding(AppTheme.Spacing.md)
                    .background(AppTheme.Colors.error.opacity(0.1))
                    .cornerRadius(AppTheme.CornerRadius.md)
                    .padding(AppTheme.Spacing.md)
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}

extension View {
    func errorToast(_ message: String?, isVisible: Bool) -> some View {
        modifier(ErrorToast(message: message, isVisible: isVisible))
    }
}

// MARK: - Success Toast
struct SuccessToast: ViewModifier {
    let message: String?
    let isVisible: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            if isVisible, let message = message {
                VStack {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppTheme.Colors.success)
                        
                        Text(message)
                            .foregroundColor(AppTheme.Colors.success)
                            .font(AppTheme.Typography.callout)
                        
                        Spacer()
                    }
                    .padding(AppTheme.Spacing.md)
                    .background(AppTheme.Colors.success.opacity(0.1))
                    .cornerRadius(AppTheme.CornerRadius.md)
                    .padding(AppTheme.Spacing.md)
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}

extension View {
    func successToast(_ message: String?, isVisible: Bool) -> some View {
        modifier(SuccessToast(message: message, isVisible: isVisible))
    }
}