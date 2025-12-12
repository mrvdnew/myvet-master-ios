import SwiftUI

struct AppTheme {
    // MARK: - Colors
    struct Colors {
        // Primary Colors (Android-inspired green)
        static let primary = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
        static let primaryDark = Color(red: 0.235, green: 0.549, blue: 0.251)
        
        // Secondary Colors (Android-inspired orange)
        static let secondary = Color(red: 1.0, green: 0.596, blue: 0.0) // #FF9800
        static let secondaryLight = Color(red: 1.0, green: 0.718, blue: 0.298)
        
        // Accent Colors
        static let accent = Color(red: 0.012, green: 0.855, blue: 0.773) // #03DAC5 Teal
        static let success = Color(red: 0.34, green: 0.85, blue: 0.39)
        static let warning = Color(red: 1.0, green: 0.8, blue: 0.0)
        static let error = Color(red: 1.0, green: 0.23, blue: 0.19)
        static let info = Color(red: 0.0, green: 0.48, blue: 1.0)
        
        // Background Colors
        static let background = Color(red: 0.961, green: 0.945, blue: 0.922) // #F5F1EB Beige
        static let secondaryBackground = Color(.systemGray6)
        
        // Text Colors
        static let text = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        static let textTertiary = Color(.tertiaryLabel)
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
        static let title = Font.system(size: 28, weight: .bold, design: .default)
        static let title2 = Font.system(size: 22, weight: .bold, design: .default)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
        static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .semibold, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 4
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
        static let full: CGFloat = 999
    }
    
    // MARK: - Shadow
    struct Shadow {
        static let small = Shadow(
            color: Color.black.opacity(0.08),
            radius: 2,
            x: 0,
            y: 1
        )
        
        static let medium = Shadow(
            color: Color.black.opacity(0.12),
            radius: 4,
            x: 0,
            y: 2
        )
        
        static let large = Shadow(
            color: Color.black.opacity(0.15),
            radius: 8,
            x: 0,
            y: 4
        )
        
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
        
        var shadow: SwiftUI.Shadow {
            SwiftUI.Shadow(color: color, radius: radius, x: x, y: y)
        }
    }
    
    // MARK: - Animation
    struct Animation {
        static let short = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let medium = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let long = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
    }
}

// MARK: - View Extensions
extension View {
    func shadowSmall() -> some View {
        shadow(color: AppTheme.Shadow.small.color, radius: AppTheme.Shadow.small.radius, x: AppTheme.Shadow.small.x, y: AppTheme.Shadow.small.y)
    }
    
    func shadowMedium() -> some View {
        shadow(color: AppTheme.Shadow.medium.color, radius: AppTheme.Shadow.medium.radius, x: AppTheme.Shadow.medium.x, y: AppTheme.Shadow.medium.y)
    }
    
    func shadowLarge() -> some View {
        shadow(color: AppTheme.Shadow.large.color, radius: AppTheme.Shadow.large.radius, x: AppTheme.Shadow.large.x, y: AppTheme.Shadow.large.y)
    }
    
    func cornered(_ radius: CGFloat = AppTheme.CornerRadius.md) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius))
    }
}

// MARK: - Color Palette
extension Color {
    static let appPrimary = AppTheme.Colors.primary
    static let appSecondary = AppTheme.Colors.secondary
    static let appAccent = AppTheme.Colors.accent
    static let appSuccess = AppTheme.Colors.success
    static let appWarning = AppTheme.Colors.warning
    static let appError = AppTheme.Colors.error
    static let appInfo = AppTheme.Colors.info
    static let appBackground = AppTheme.Colors.background
}