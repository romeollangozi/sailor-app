//
//  PrimaryButton.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 17.1.25.
//

import SwiftUI

public struct PrimaryButton: View {
    private let title: String
    private let font: Font
    private let padding: CGFloat
    private let action: () -> Void
    private let isDisabled: Bool
	private let isLoading: Bool
    
	public init (_ title: String, isDisabled: Bool = false, font: Font = Font.vvBodyBold, padding: CGFloat = Spacing.space16, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.font = font
        self.padding = padding
        self.isDisabled = isDisabled
		self.isLoading = isLoading
    }
    
	public var body: some View {
	   ZStack {
		   Button(action: isDisabled || isLoading ? {} : action) {
			   Text(title)
				   .font(font)
                   .opacity(isLoading ? 0 : 1)
				   .fontWeight(.bold)
				   .foregroundColor((isDisabled || isLoading) ? Color.darkGray : .white)
				   .frame(maxWidth: .infinity)
				   .padding(Spacing.space16)
				   .background((isDisabled || isLoading) ? Color.borderGray : Color.vvRed)
				   .cornerRadius(4)
		   }
		   .disabled(isDisabled || isLoading)
		   
		   if isLoading {
			   ProgressView()
                   .padding(Spacing.space16)
		   }
	   }
       .padding(padding)
   }
}

public struct SecondaryButton: View {
	private let title: String
	private let action: () -> Void
	private let font: Font?
	private let isDisabled: Bool
	private let isLoading: Bool
	
	public init (_ title: String,  isDisabled: Bool = false, isLoading: Bool = false, action: @escaping () -> Void, font: Font? = nil) {
		self.title = title
		self.action = action
		self.font = font
		self.isDisabled = isDisabled
		self.isLoading = isLoading
	}
	
	public var body: some View {
		ZStack {
			Button(action: isDisabled || isLoading ? {} : action) {
				Text(title)
					.font(font != nil ? font! : .vvBodyBold)
                    .opacity(isLoading ? 0 : 1)
					.foregroundColor((isDisabled || isLoading) ? Color.iconGray : .blackText)
					.frame(maxWidth: .infinity)
					.padding()
					.background((isDisabled || isLoading) ? Color.white : Color.clear)
					.cornerRadius(4)
					.clipShape(RoundedRectangle(cornerRadius: 4))
					.overlay {
						RoundedRectangle(cornerRadius: 4)
							.stroke(style: .init(lineWidth: 1))
							.foregroundColor((isDisabled || isLoading) ? Color.iconGray : .darkGray)
					}
			}
			.disabled(isDisabled || isLoading)
			.padding(Spacing.space16)
			
			if isLoading {
				ProgressView()
                    .padding(Spacing.space16 + Spacing.space16)
			}
		}
	}
}

public struct WarningButton: View {
	private let title: String
	private let action: () -> Void
	private let font: Font?

	public init (_ title: String,  action: @escaping () -> Void, font: Font? = nil) {
		self.title = title
		self.action = action
		self.font = font
	}

	public var body: some View {
		Button(action: action) {
			ZStack {
				HStack {
					Image(systemName: "exclamationmark.circle.fill")
						.frame(width: 20, height: 20)
						.padding(.leading, 20)
						.foregroundStyle(.orange)
					Spacer()
				}
				Text(title)
					.font(font != nil ? font! : .vvBodyBold)
					.foregroundColor(.blackText)
					.frame(maxWidth: .infinity)
					.padding()
					.cornerRadius(4)
					.clipShape(RoundedRectangle(cornerRadius: 4))
					.overlay {
						RoundedRectangle(cornerRadius: 4)
							.stroke(style: .init(lineWidth: 1))
							.foregroundColor(.darkGray)
					}
			}

		}
		.padding(Spacing.space16)
	}
}

public struct LinkButton: View {
    private let title: String
    private let action: () -> Void
    private let font: Font?
	private let isDisabled: Bool
	private let isLoading: Bool
    private let color: Color

    public init (_ title: String, font: Font? = nil, color: Color = Color.vvBlack, isDisabled: Bool = false, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.font = font
		self.isDisabled = isDisabled
		self.isLoading = isLoading
        self.color = color
    }
    
    public var body: some View {
		ZStack {
			Button(action: isDisabled || isLoading ? {} : action) {
                if !isLoading {
                    Text(title)
                        .font(font != nil ? font! : .vvBodyBold)
                        .underline()
                        .foregroundStyle(color)
                }
			}
			.disabled(isDisabled || isLoading)
			.buttonStyle(.plain)
			.padding(Spacing.space16)
			
			if isLoading {
				ProgressView()
					.padding(Spacing.space16)
			}
		}
    }
}

public struct ClosableButton: View {
    private let action: () -> Void
    
    public init (action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .foregroundStyle(.black, .white)
        .opacity(0.75)
    }
}

public struct XClosableButton: View {
    private let action: () -> Void
    
    public init (action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 14, height: 14)
        }
        .foregroundStyle(.black, .white)
        .opacity(0.75)
    }
}

public struct CustomBorderedButton: View {
    private let title: String
    private let action: () -> Void

    public init (title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)
                .foregroundColor(Color(uiColor: .darkGray))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(uiColor: .darkGray))
                )
                .fixedSize()
        }
    }
}

public struct CapsuleButton: View {
    private let title: String
    private let action: () -> Void
    private let image: Image
    private let accessoryImage: Image?

    public init(
        title: String,
        image: Image,
        accessoryImage: Image? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.accessoryImage = accessoryImage
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.space16) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(Spacing.space8)

                Text(title)
                    .font(.vvBody)
                    .foregroundColor(.black)

                Spacer()

                if let accessoryImage = accessoryImage {
                    accessoryImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                        .padding(.vertical, Spacing.space12)
                        .padding(.trailing, Spacing.space16)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

public struct HorizontalTextImageButton: View {
    private var title: String
    private var image: Image
    private var action: () -> Void
    
    public init(_ title: String, image: Image, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.space8)  {
                Text(title)
                    .font(.vvSmallBold)
                image
                    .frame(width: Spacing.space32, height: Spacing.space32)
                    .background(AnyView(Circle().fill(Color.black.opacity(0.05))))
            }
            .foregroundStyle(.white)
        }
    }
}

public struct HorizontalImageTextButton: View {
	private var title: String
	private var image: Image
	private var action: () -> Void

	public init(_ title: String, image: Image, action: @escaping () -> Void) {
		self.title = title
		self.image = image
		self.action = action
	}

	public var body: some View {
		Button(action: action) {
			HStack(spacing: Spacing.space8)  {
				image
					.frame(width: Spacing.space32, height: Spacing.space32)
				Text(title)
					.font(.vvSmallBold)
			}
			.foregroundStyle(Color.darkGray)
		}
	}
}

public struct RoundedImageButton: View {
    var imageName: String
    var buttonSize: CGFloat
    var imageSize: CGFloat
    var action: () -> Void
    
    public init(
        imageName: String,
        buttonSize: CGFloat = 48,
        imageSize: CGFloat = 24,
        action: @escaping () -> Void
    ) {
        self.imageName = imageName
        self.buttonSize = buttonSize
        self.imageSize = imageSize
        self.action = action
    }

    
    public var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .padding(12)
                .frame(width: buttonSize, height: buttonSize)
                .background(Color.white)
                .cornerRadius(buttonSize)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 1)
                .shadow(color: Color.black.opacity(0.07), radius: 48, x: 0, y: 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct CapsuleTextButton: View {
	private let title: String
	private let action: () -> Void
	private let textColor: Color
	private let backgroundColor: Color
	
	init (_ title: String,
				 textColor: Color = .slateGray,
				 backgroundColor: Color = .white,
				 action: @escaping () -> Void) {
		self.title = title
		self.action = action
		self.textColor = textColor
		self.backgroundColor = backgroundColor
	}
	
	var body: some View {
		Button(title) {
			action()
		}
		.font(.vvSmallBold)
		.foregroundStyle(textColor)
		//.foregroundColor(selected ? Color.white : Color.slateGray)
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 24)
				.fill(backgroundColor)
				.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
		)
		.buttonStyle(.plain)
	}
}

public struct CapsuleToggleButton: View {
    let title: String
    @Binding var selectedOption: String
    let action: () -> Void

    public init(title: String,
                selectedOption: Binding<String>,
                action: @escaping () -> Void) {
        self.title = title
        self._selectedOption = selectedOption
        self.action = action
    }

    public var body: some View {
        let isSelected = selectedOption.lowercased() == title.lowercased()
        
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.vvSmallBold)
                .foregroundStyle(isSelected ? .white : .slateGray)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(isSelected ? Color.vvRed : .white)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
        }
        .buttonStyle(.plain)
    }
}

public struct CapsulePrimaryButton: View {
	private let title: String
	private let action: () -> Void
	
	public init (_ title: String,
				 action: @escaping () -> Void) {
		self.title = title
		self.action = action
	}
	
	public var body: some View {
		CapsuleTextButton(title, textColor: .white, backgroundColor: .vvRed, action: action)
	}
}

public struct CapsuleSecondaryButton: View {
	private let title: String
	private let action: () -> Void
	
	public init (_ title: String,
				 action: @escaping () -> Void) {
		self.title = title
		self.action = action
	}
	
	public var body: some View {
		CapsuleTextButton(title, textColor: .slateGray, backgroundColor: .white, action: action)
	}
}

#Preview("Buttons") {
    
    ScrollView {
        
        PrimaryButton("Primary Button", action:{})
        
        PrimaryButton("Primary Button with loading", isLoading: true, action:{})
        
        SecondaryButton("Secondary Button", action:{})
        
        SecondaryButton("Secondary Button with loading", isLoading: true, action:{})

        WarningButton("Warning Button", action:{})

        LinkButton("Link Button", action: {})
        
        LinkButton("Link Button with loading", isLoading: true, action: {})

        HorizontalImageTextButton("Horizontal Button", image: Image(systemName: "person.crop.circle.fill"), action: {})

        ClosableButton(action: {})
            .background(.black.opacity(0.25))
        
        XClosableButton(action: {})
        
        CapsuleButton(
            title: "Capsule button",
            image: Image(systemName: "person.crop.circle.fill"),
            accessoryImage: .init(systemName: "plus")) {
                
            print("Button tapped")
        }
        
        CapsulePrimaryButton("Capsule Primary Text Button") {
            
        }
        
        CapsuleSecondaryButton("Capsule Secondary Text Button") {
            
        }
        
        HorizontalTextImageButton("Horizontal Button", image: Image(systemName: "person.crop.circle.fill"), action: {})

        RoundedImageButton(imageName: "Logo") {
            print("Button tapped")
        }
        
        CapsuleToggleButton(title: "Yes",
                            selectedOption: .constant("YES")) {
            print("Button tapped")
        }
    }

}
