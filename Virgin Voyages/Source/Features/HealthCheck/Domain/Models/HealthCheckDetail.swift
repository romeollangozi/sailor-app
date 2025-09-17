//
//  HomeHealthCheckDetail.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/2/25.
//

import Foundation

struct HealthCheckDetail: Hashable {
    
    var id = UUID().uuidString
    let isHealthCheckComplete: Bool
    let isFitToTravel: Bool
    let landingPage: LandingPage
    let healthCheckRefusePage: HealthCheckRefusePage
    let healthCheckReviewPage: HealthCheckReviewPage
    let updateURL: String
    let downloadContractFileUrl: String
    
    static func == (lhs: HealthCheckDetail, rhs: HealthCheckDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    struct LandingPage {
        let title: String
        let description: String
        let imageURL: String
        let questionsPage: QuestionsPage
        
        struct QuestionsPage: Hashable {
            
            var id = UUID().uuidString
            let healthQuestions: [HealthQuestion]
            let healthContract: String
            let travelParty: TravelParty
            let confirmationQuestion: String
            
            struct HealthQuestion: Identifiable {
                var id = UUID().uuidString
                let title: String
                let question: String
                let options: [String]
                let selectedOption: String
                let questionCode: String
                let sequence: Int
            }
            
            struct TravelParty {
                let title: String
                let description: String
                let alreadySignedTitle: String
                let partyMembers: [PartyMember]
                
                struct PartyMember: Identifiable {
                    
                    var id = UUID().uuidString
                    let imageURL: String
                    let reservationGuestId: String
                    let name: String
                    let genderCode: String
                    let isAlreadySigned: Bool
                }
            }
            
            static func == (lhs: QuestionsPage, rhs: QuestionsPage) -> Bool {
                return lhs.id == rhs.id
            }
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }
            
        }
    }
    
    struct HealthCheckRefusePage {
        let imageURL: String
        let description: String
        let title: String
    }
    
    struct HealthCheckReviewPage {
        let imageURL: String
        let title: String
        let description: String
        let confirmationQuestion: String
    }
    
}

extension Array where Element == HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion {
    func sortedBySequence() -> [Element] {
        return self.sorted {
            $0.sequence < $1.sequence
        }
    }
}

extension Array where Element == HealthCheckDetail.LandingPage.QuestionsPage.TravelParty.PartyMember {
    
    var notSigned: [Element] {
        return self.filter { !$0.isAlreadySigned }
    }
    
    var alreadySigned: [Element] {
        return self.filter { $0.isAlreadySigned }
    }
    
}


extension HealthCheckDetail {
    
    static func empty() -> HealthCheckDetail {
        
        return HealthCheckDetail(isHealthCheckComplete: false,
                                     isFitToTravel: false,
                                     landingPage: .empty(),
                                     healthCheckRefusePage: .empty(),
                                     healthCheckReviewPage: .empty(),
                                     updateURL: "",
                                     downloadContractFileUrl: "")
    }
    
    static func sample() -> HealthCheckDetail {
        
        return HealthCheckDetail(
            isHealthCheckComplete: false,
            isFitToTravel: false,
            landingPage: .init(
                title: "Let us know you’re fit to sail",
                description: "<p>All our Sailors must complete a pre-departure health form. Honestly, it&#39;s quick and easy.</p>\n",
                imageURL: "https://cert.gcpshore.virginvoyages.com/dam/jcr:3d97939a-9f01-4b4e-a6f7-d0900caace29/IMG-RTS-Kettlebell-Discoball-v1-01-800x1200.jpg",
                questionsPage: .init(
                    healthQuestions: [
                        .init(
                            title: "Question 1",
                            question: "Do you currently have any of the following symptoms: fever, chills, feverishness, cough, shortness of breath,\u{00A0} difficulty breathing, sore throat, fatigue, muscle or body aches, headache, congestion or runny nose, new loss of taste or smell?",
                            options: ["Yes", "No"],
                            selectedOption: "NO",
                            questionCode: "UI003120",
                            sequence: 1
                        ),
                        .init(
                            title: "Question 2",
                            question: "In the last 72 hours have you had any symptoms such as diarrhea, nausea or vomiting (with fever, headache)?",
                            options: ["Yes", "No"],
                            selectedOption: "NO",
                            questionCode: "UI003121",
                            sequence: 2
                        ),
                        .init(
                            title: "Final Question",
                            question: "Will you be more than 24 weeks pregnant by the end of your voyage?",
                            options: ["Yes", "No"],
                            selectedOption: "NO",
                            questionCode: "UI004315",
                            sequence: 3
                        )
                    ],
                    healthContract: """
                    <p>If you answered &ldquo;YES&rdquo; to any of these questions, you&rsquo;ll be assessed free of charge by a member of our shipboard medical staff. You&rsquo;ll be allowed to travel &mdash; unless you&rsquo;re suspected of having an illness that causes a public health concern.</p>\n\n<p>The information in this questionnaire may be reported to the relevant Public Health Authorities, and penalties may apply to any individual who knowingly and willfully makes a false, fictitious or fraudulent statement or representation.</p>\n\n<p>I certify that the above declaration is true and correct and understand that any dishonest answers may have serious public health implications</p>\n
                    """,
                    travelParty: .init(
                        title: "Cabin mates",
                        description: "Let us know your cabin mates are healthy by completing the form on their behalf.",
                        alreadySignedTitle: "These Sailors have already declared their health status. You can (technically) overwrite it, but you should probably check with them before doing so.",
                        partyMembers: [
                            .init(
                                imageURL: "",
                                reservationGuestId: "2a2c5724-1e43-4a4d-b69c-55125bdb6f26",
                                name: "Sai Srinivas Dendukuri",
                                genderCode: "M",
                                isAlreadySigned: false
                            ),
                            .init(
                                imageURL: "",
                                reservationGuestId: "679d72a6-36c5-42e8-86ed-3cb20a324fa6",
                                name: "Mohammad Jilani Kattevale",
                                genderCode: "M",
                                isAlreadySigned: false
                            ),
                            .init(
                                imageURL: "",
                                reservationGuestId: "2a2c5724-1e43-4a4d-b69c-55125bdb6f26",
                                name: "Dendukuri",
                                genderCode: "M",
                                isAlreadySigned: true
                            ),
                            .init(
                                imageURL: "",
                                reservationGuestId: "679d72a6-36c5-42e8-86ed-3cb20a324fa6",
                                name: "Jilani",
                                genderCode: "M",
                                isAlreadySigned: true
                            )
                        ]
                    ),
                    confirmationQuestion: "I acknowledge, accept and agree to abide by the terms of the contract."
                )
            ),
            healthCheckRefusePage: .init(
                imageURL: "https://cert.gcpshore.virginvoyages.com/dam/jcr:77d869a5-bd1c-4973-b1e4-3d6d0df72bee/IMG-RTS-Kettlebell-Discoball-v1-01-314x314.jpg",
                description: "We're going to need you to fill out that health form before moving on. But don't worry, it wont take long at all.",
                title: "Nooot so fast, Sailor."
            ),
            healthCheckReviewPage: .init(
                imageURL: "",
                title: "Pre-departure health check",
                description: "You previously said you're all good to go.",
                confirmationQuestion: "Still all good?"
            ),
            updateURL: "https://cert.gcpshore.virginvoyages.com/rts-bff/healthcheck?reservation-guest-id=aabb86aa-c1e8-4222-849a-637421a49466",
            downloadContractFileUrl: "https://cert.gcpshore.virginvoyages.com/dxpcore/downloadcontract?contractType=HC&reservationGuestId=aabb86aa-c1e8-4222-849a-637421a49466"
        )
    }
    
}
