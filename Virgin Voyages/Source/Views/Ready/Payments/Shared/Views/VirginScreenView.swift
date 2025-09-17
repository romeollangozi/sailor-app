//
//  VirginScreenView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/10/24.
//

import SwiftUI
import VVUIKit

enum ScreenState {
    case content
    case error
    case loading
}

struct DefaultScreenView<Content: View>: View {
    @Binding var state: ScreenState
    let content: () -> Content
    let onRefresh: () -> Void
    let toolBarOptions: ToolBarOption?

    init(
        state: Binding<ScreenState>,
        toolBarOptions: ToolBarOption? = nil,
        @ViewBuilder content: @escaping () -> Content,
        onRefresh: @escaping () -> Void
    ) {
        self._state = state
        self.toolBarOptions = toolBarOptions
        self.content = content
        self.onRefresh = onRefresh
    }

    var body: some View {
        if toolBarOptions?.onBackTapped != nil || toolBarOptions?.onCloseTapped != nil {
            ZStack(alignment: .center) {
                wrapperView()
                
				VStack{
                    toolbar()
                    
					Spacer()
                }
            }
        } else {
            wrapperView()
        }
    }

    private func wrapperView() -> some View {
        VirginScreenView(state: $state,
                         content: content) {
            ProgressView("Loading...")
                .fontStyle(.headline)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } errorView: {
            NoDataView(action: onRefresh)
        }
    }

    private func toolbar() -> some View {
        HStack(alignment: .top) {
			if let onBackTapped = toolBarOptions?.onBackTapped {
                BackButton(onBackTapped)
                    .padding(.leading, Spacing.space24)
					.padding(.top, toolBarOptions?.backButtonPaddingTop ?? Spacing.space32)
            }
            
			Spacer()
			
			if let onCloseTapped = toolBarOptions?.onCloseTapped {
                ClosableButton(action: onCloseTapped)
                    .padding(.trailing, Spacing.space24)
                    .padding(.top, Spacing.space32)
            }
        }
    }
}

struct VirginScreenView<Content: View, LoadingView: View, ErrorView: View>: View {
    
    @Binding var state: ScreenState
    let content: () -> Content
    let loadingView: () -> LoadingView
    let errorView: () -> ErrorView
    
    var body: some View {
        ZStack {
            if case .content = state {
                content()
            } else if case .error = state {
                errorView()
            } else if case .loading = state {
                loadingView()
            }
        }
        .toolbar {
            
        }
    }
}

struct ToolBarOption {
    let onBackTapped: VoidCallback?
    let onCloseTapped: VoidCallback?
	let backButtonPaddingTop: CGFloat?

    init(onBackTapped: VoidCallback? = nil,
		 onCloseTapped: VoidCallback? = nil,
		 backButtonPaddingTop: CGFloat? = nil) {
        self.onBackTapped = onBackTapped
        self.onCloseTapped = onCloseTapped
		self.backButtonPaddingTop = backButtonPaddingTop
    }
}
