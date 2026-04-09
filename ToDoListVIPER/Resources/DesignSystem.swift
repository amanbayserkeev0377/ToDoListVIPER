import UIKit

enum DesignSystem {
    
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
    
    enum FontSize {
        static let caption: CGFloat = 11
        static let small: CGFloat = 12
        static let body: CGFloat = 16
        static let title: CGFloat = 34
    }
    
    enum Layout {
        static let bottomBarHeight: CGFloat = 83
        static let checkboxSize: CGFloat = 24
        static let tableRowHeight: CGFloat = 80
        static let stackSpacing: CGFloat = 4
        static let cellElementSpacing: CGFloat = 12
        static let cellVerticalPadding: CGFloat = 12
    }
    
    enum Icon {
        static let addTask = "square.and.pencil"
        static let checkboxEmpty = "circle"
        static let checkboxFilled = "checkmark.circle.fill"
        static let hideKeyboard = "keyboard.chevron.compact.down"
        static let edit = "pencil"
        static let share = "square.and.arrow.up"
        static let trash = "trash"
    }
    
    enum DateFormat {
        static let display = "dd/MM/yy"
    }
}
