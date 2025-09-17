//
//  TermsAndConditionsDetailsView.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 31.10.24.
//

import SwiftUI

struct TermsAndConditionsDetailsView: View {
    
    @State private var detailsItem: TermsAndConditionsListItemModel
    @State private var didLoadContent: Bool = false
    
    init(detailsItem: TermsAndConditionsListItemModel) {
        _detailsItem = State(wrappedValue:detailsItem)
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                // Header
                HStack(alignment: .top) {
                    // Title
                    Text(detailsItem.heading)
                        .fontStyle(.largeTitle)
                    Spacer()
                }
                .padding(.top, Paddings.defaultVerticalPadding32)
                .padding(.bottom, Paddings.defaultVerticalPadding16)
                
                
                ForEach(detailsItem.content, id: \.id) { item in
                    VStack (alignment: .leading, spacing: Paddings.defaultVerticalPadding) {
                        if let title = item.title {
                            Text(title)
                                .fontStyle(.smallTitle)
                        }
                        
                        if let subtitle = item.subtitle {
                            Text(subtitle)
                                .fontStyle(.button)
                        }
                        
                        VVWebView(htmlString: item.body) {
                            withAnimation {
                                didLoadContent = true
                            }
                        }
                        .id(item.id)
                        .padding(.bottom, Paddings.defaultVerticalPadding)
                        
                        Divider()
                    }
                    .foregroundColor(.vvGray)
                }
                .opacity(didLoadContent ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: didLoadContent)
            }
            .padding(.horizontal)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: VVBackButton())
        }
    }
}

#Preview {
    TermsAndConditionsDetailsView(detailsItem: TermsAndConditionsListItemModel(id: "2", key: .general, heading: "General", content: [TermsAndConditionsListItemModel.ContentModel.init(title: "title", subtitle: "subtitle", body: "<p>The United States Government requires cruise lines which operate in United States waters to provide certain information to their passengers in the form of a Security Guide.&nbsp;&nbsp;</p>\n\n<p>The safety and security of our passengers and crew is our highest priority.&nbsp; Allegations of crime, missing person reports and medical emergencies are taken seriously, and we are committed to responding in an effective and caring manner for those involved.&nbsp; Each of our ships is staffed with dedicated security and medical teams to respond to alleged crimes and medical situations, respectively.&nbsp; They are onboard, on duty and available at all times. For voyages embarking or debarking in the United States, you may independently contact the FBI or US Coast Guard for incidents arising at any time during the voyage from your phone, or through the ship&rsquo;s Security Office. For incidents within state or foreign waters or ports you may, in addition, contact local law enforcement authorities.&nbsp;&nbsp;</p>\n\n<p>Contact information for these entities, along with contact information for third party victim advocacy groups and the locations of United States Embassies and Consulates for the ports we plan to visit during United States oriented voyages is provided below.&nbsp; If you need assistance in locating this information or if you find this information has changed since publication or is incorrect, please contact the onboard Sailor Services desk immediately.<br />\n<br />\nLink to <a href=\"https://prod.virginvoyages.com/dam/jcr:dac27bfb-bee1-4622-ba61-b324357cfd7b/VV_Security_GuideAndContactList.pdf\">our Security Guide</a></p>\n")]))
}
