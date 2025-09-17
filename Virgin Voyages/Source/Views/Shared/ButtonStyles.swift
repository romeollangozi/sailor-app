//
//  ButtonStyles.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/11/24.
//

import SwiftUI
import VVUIKit

enum ButtonFrameStyle {
	case fullscreen
	case flexible
	
	var maxWidth: CGFloat? {
		switch self {
			case .fullscreen:
			return .infinity
		case .flexible:
			return nil
		}
	}
}

private struct ButtonLabelModifier: ViewModifier {
	var frameStyle: ButtonFrameStyle = .fullscreen
	func body(content: Content) -> some View {
		content
			.frame(maxWidth: frameStyle.maxWidth)
			.padding(15)
			.fontStyle(.button)
	}
}

struct PrimaryButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.modifier(ButtonLabelModifier())
			.background(configuration.isPressed ? Color.gray : .accentColor)
			.foregroundStyle(configuration.isPressed ? .white : Color.white)
			.clipShape(RoundedRectangle(cornerRadius: 6))
	}
}

struct PrimaryDisabledButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .modifier(ButtonLabelModifier())
            .background(configuration.isPressed ? Color.borderGray : Color.borderGray)
            .foregroundStyle(configuration.isPressed ? Color.mediumGray : Color.mediumGray)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}


private struct RedButtonLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(8)
            .fontStyle(.button)
    }
}

private struct PurchaseButtonLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 7)
            .padding(.horizontal, 24)
            .fontStyle(.button)
    }
}

private struct VoyageButtonLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 7)
            .padding(.horizontal, 24)
            .fontStyle(.button)
    }
}

struct PrimaryRedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .modifier(RedButtonLabelModifier())
            .background(configuration.isPressed ? Color.gray : .accentColor)
            .foregroundStyle(configuration.isPressed ? .white : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}


struct SecondaryButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.modifier(ButtonLabelModifier())
			.background(configuration.isPressed ? Color.gray : Color.white)
			.foregroundStyle(configuration.isPressed ? .white: Color(uiColor: .darkGray))
			.clipShape(RoundedRectangle(cornerRadius: 6))
			.overlay {
				RoundedRectangle(cornerRadius: 6)
					.stroke(style: .init(lineWidth: 1))
					.foregroundStyle(.gray)
			}
	}
}

struct VoyageButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .modifier(VoyageButtonLabelModifier())
            .background(configuration.isPressed ? Color.gray : Color.white)
            .foregroundStyle(configuration.isPressed ? .white : Color.darkGray)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundStyle(Color.darkGray)
            }
    }
}

struct WhiteAdaptiveButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .modifier(ButtonLabelModifier())
            .foregroundStyle(configuration.isPressed ? .lightGreyColor : Color(uiColor: .white))
            .background(Color.clear)
            .contentShape(RoundedRectangle(cornerRadius: 6))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundStyle(configuration.isPressed ? .lightGreyColor : Color(uiColor: .white))
            }
    }
}

struct AdaptiveButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .modifier(ButtonLabelModifier())
            .foregroundStyle(configuration.isPressed ? .lightGreyColor : Color(uiColor: .darkGray))
            .background(Color.clear)
            .contentShape(RoundedRectangle(cornerRadius: 6))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundStyle(configuration.isPressed ? .lightGreyColor : Color(uiColor: .darkGray))
            }
    }
}

struct AdaptiveErrorButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		ZStack {
			HStack {
				ErrorStatusView()
					.frame(width: 20, height: 20)
					.padding(.leading, 20)

				Spacer()
			}
			configuration.label
				.modifier(ButtonLabelModifier())
				.multilineTextAlignment(.center)
		}
		.frame(maxWidth: .infinity, minHeight: 44)
		.foregroundStyle(configuration.isPressed ? .lightGreyColor : Color(uiColor: .darkGray))
		.background(Color.clear)
		.contentShape(RoundedRectangle(cornerRadius: 6))
		.clipShape(RoundedRectangle(cornerRadius: 6))
		.overlay {
			RoundedRectangle(cornerRadius: 6)
				.stroke(style: .init(lineWidth: 1))
				.foregroundStyle(configuration.isPressed ? .lightGreyColor : Color(uiColor: .darkGray))
		}
	}
}


struct PurchaseButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .modifier(PurchaseButtonLabelModifier())
            .foregroundStyle(configuration.isPressed ? .white: enabledColor())
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundStyle(enabledColor())
            }
    }
    
    private func enabledColor() -> Color {
        return isEnabled ? Color(uiColor: .darkGray) : Color(uiColor: .lightGray)
    }
}


private struct ServiceStyleModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.frame(minWidth: 40)
			.padding(.horizontal, 20)
			.padding(.vertical, 15)
			.fontStyle(.subheadline)
			.fontWeight(.bold)
	}
}

private struct LinkStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 40, alignment: .leading)
            .fontStyle(.largeTagline)
            .fontWeight(.regular)
    }
}

struct PrimaryCapsuleButtonStyle: ButtonStyle {
	@Environment(\.isEnabled) var enabled
	var selected: Bool?
	func makeBody(configuration: Self.Configuration) -> some View {
		HStack {
			if selected == true {
				Image(systemName: "checkmark")
			}
			
			configuration.label
		}
		.frame(minWidth: 40)
		.padding(.horizontal, 30)
		.padding(.vertical, 20)
		.fontStyle(.subheadline)
		.fontWeight(.bold)
		.foregroundStyle(selected == true ? .black : Color(uiColor: .darkGray))
		.background(selected == true ? Color("Selected Green") : .white)
		.clipShape(Capsule())
		.opacity(enabled ? 1 : 0.6)
	}
}

struct PrimaryAddCapsuleButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var enabled
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
                Image(systemName: "plus")
                    .foregroundStyle(Color.vvRed)
            configuration.label
        }
        .frame(minWidth: 40)
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
        .fontStyle(.subheadline)
        .fontWeight(.bold)
        .foregroundStyle(Color(uiColor: .darkGray))
        .background(.white)
        .clipShape(Capsule())
        .opacity(enabled ? 1 : 0.6)
    }
}


struct PrimaryServiceButtonStyle: ButtonStyle {

    var statusType: StatusType
    var iconURL: String?
    
    var foregroundColor: Color {
        switch statusType {
        case .default:
            Color.slateGray
        case .active:
            Color.rockstarGray
        case .closed:
            Color.blackText
        }
    }
    
    var backgroundColor: Color {
        switch statusType {
        case .default:
            Color.vvWhite
        case .active:
            Color.selectedBlue
        case .closed:
            Color.vvWhite.opacity(0.8)
        }
    }
    
    var imageName: String {
        switch statusType {
        case .default:
            ""
        case .active:
            "clock"
        case .closed:
            "powersleep"
        }
    }
    
	func makeBody(configuration: Self.Configuration) -> some View {
		HStack {
			
            if let iconURL = iconURL, !iconURL.isEmpty {
				ImageViewer(url: iconURL, width: Sizes.defaultSize32, height: Sizes.defaultSize32, contentMode: .fit)
            } else if statusType != .default {
                Image(systemName: imageName)
            }
            
			configuration.label
		}
		.modifier(ServiceStyleModifier())
		.foregroundStyle(foregroundColor)
		.background(backgroundColor)
		.clipShape(Capsule())
	}
}

struct SecondaryServiceButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.modifier(ServiceStyleModifier())
			.foregroundStyle(.white)
			.clipShape(Capsule())
			.overlay {
				Capsule()
					.stroke(.white)
				}
	}
}

struct TertiaryButtonStyle: ButtonStyle {
	@Environment(\.isEnabled) var enabled
	var frameStyle: ButtonFrameStyle = .fullscreen
	
	init(_ frameStyle: ButtonFrameStyle = .fullscreen) {
		self.frameStyle = frameStyle
	}
	
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.underline()
			.modifier(ButtonLabelModifier(frameStyle: frameStyle))
			.clipShape(Capsule())
			.foregroundStyle(Color(uiColor: .darkGray))
			.opacity(enabled ? 1 : 0.6)
	}
}

struct TertiaryLinkStyle: ButtonStyle {
    @Environment(\.isEnabled) var enabled
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .underline()
            .modifier(ButtonLabelModifier())
            .clipShape(Capsule())
            .background(.clear)
            .foregroundStyle(Color(uiColor: .darkGray))
            .opacity(enabled ? 1 : 0.6)
    }
}

struct DismissServiceButtonStyle: ButtonStyle {
    let foregroundColor: Color
    
    init(foregroundColor: Color = .white) {
        self.foregroundColor = foregroundColor
    }
    
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.underline()
			.modifier(ServiceStyleModifier())
			.foregroundStyle(foregroundColor)
			.clipShape(Capsule())
	}
}

struct LinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .underline()
            .modifier(LinkStyleModifier())
            .foregroundColor(.gray)
    }
}

struct FilterButtonStyle: ButtonStyle {
	var selected: Bool
	
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.foregroundStyle(selected ? .white : Color(uiColor: .darkGray))
			.fontStyle(.headline)
			.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
			.background(selected ? Color("AccentColor") : .white) // .background
			.clipShape(Capsule())
			.shadow(color: .primary.opacity(0.2), radius: 2)
	}
}

struct PrimaryMessengerButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    
    init (backgroundColor: Color = .white, foregroundColor: Color = .accentColor) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label        
            .foregroundStyle(foregroundColor)
            .font(.custom(FontStyle.smallTitle.fontName, size: FontStyle.lightBody.pointSize))
            .padding(.horizontal, Paddings.defaultVerticalPadding16)
            .padding(.vertical, Paddings.capsuleButtonVerticalPadding)
            .background(backgroundColor)
            .clipShape(Capsule())
            .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 0)
    }
}

#Preview {
	ScrollView {
		VStack(spacing: 20) {

			Button("Primary") {

			}
			.buttonStyle(AdaptiveErrorButtonStyle())

            Button("Primary") {
                
            }
            .buttonStyle(AdaptiveButtonStyle())
            
			Button("Primary") {
				
			}
			.buttonStyle(PrimaryButtonStyle())
			
			Button("Secondary") {
				
			}
			.buttonStyle(SecondaryButtonStyle())
			
			Button("Option") {
				
			}
			.buttonStyle(PrimaryCapsuleButtonStyle())
			
			Button("Disabled") {
				
			}
			.buttonStyle(PrimaryCapsuleButtonStyle())
			.disabled(true)
            
            Button("Disabled 2") {
                
            }
            .buttonStyle(PrimaryDisabledButtonStyle())
            .disabled(true)
			
			Button("Ice") {
				
			}
            .buttonStyle(PrimaryServiceButtonStyle(statusType: .default))
			
			Button("Ice") {
				
			}
            .buttonStyle(PrimaryServiceButtonStyle(statusType: .active))
			
			Button("Service") {
				
			}
			.buttonStyle(SecondaryServiceButtonStyle())
			
			Button("No thanks") {
				
			}
			.buttonStyle(DismissServiceButtonStyle())
			
			TaskButton(title: "No thanks", underline: true, task: ScreenTask()) {
				
			}
			.buttonStyle(DismissServiceButtonStyle())
			
			Button("Cultured") {
				
			}
			.buttonStyle(FilterButtonStyle(selected: false))
			
			Button("Cultured") {
				
			}
			.buttonStyle(FilterButtonStyle(selected: true))
            
            Button("Link style") {
                
            }
            .buttonStyle(LinkButtonStyle())
            
            Button("Purchase") {
                
            }
            .buttonStyle(PurchaseButtonStyle())

            Button("Contact") {
                
            }
            .buttonStyle(PrimaryMessengerButtonStyle())
		}
	}
	.padding()
    .background(.vvGray)
}

