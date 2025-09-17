//
//  GetHealthCheckDetailResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/3/25.
//

import Foundation

extension GetHealthCheckDetailResponse {
    
    func toDomain() -> HealthCheckDetail {
        return HealthCheckDetail(
            isHealthCheckComplete: self.isHealthCheckComplete.value,
            isFitToTravel: self.isFitToTravel.value,
            landingPage: self.landingPage?.toDomain() ?? .empty(),
            healthCheckRefusePage: self.healthCheckRefusePage?.toDomain() ?? .empty(),
            healthCheckReviewPage: self.healthCheckReviewPage?.toDomain() ?? .empty(),
            updateURL: self.updateURL.value,
            downloadContractFileUrl: self.downloadContractFileUrl.value
        )
    }
    
}

extension GetHealthCheckDetailResponse.LandingPage {
    
    func toDomain() -> HealthCheckDetail.LandingPage {
        return HealthCheckDetail.LandingPage(
            title: self.title.value,
            description: self.description.value,
            imageURL: self.imageURL.value,
            questionsPage: self.questionsPage?.toDomain() ?? .empty()
        )
    }
}

extension GetHealthCheckDetailResponse.LandingPage.QuestionsPage {
    
    func toDomain() -> HealthCheckDetail.LandingPage.QuestionsPage {
        return HealthCheckDetail.LandingPage.QuestionsPage(
            healthQuestions: self.healthQuestions?.map { $0.toDomain() } ?? [],
            healthContract: self.healthContract.value,
            travelParty: self.travelParty?.toDomain() ?? .empty(),
            confirmationQuestion: self.confirmationQuestion.value
        )
    }
}

extension GetHealthCheckDetailResponse.LandingPage.QuestionsPage.HealthQuestion {
    
    func toDomain() -> HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion {
        return HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion(
            title: self.title.value,
            question: self.question.value,
            options: self.options ?? [],
            selectedOption: self.selectedOption.value,
            questionCode: self.questionCode.value,
            sequence: self.sequence.value
        )
    }
}

extension GetHealthCheckDetailResponse.LandingPage.QuestionsPage.TravelParty {
    
    func toDomain() -> HealthCheckDetail.LandingPage.QuestionsPage.TravelParty {
        return HealthCheckDetail.LandingPage.QuestionsPage.TravelParty(
            title: self.title.value,
            description: self.description.value,
            alreadySignedTitle: self.alreadySignedTitle.value,
            partyMembers: self.partyMembers?.map { $0.toDomain() } ?? []
        )
    }
}

extension GetHealthCheckDetailResponse.LandingPage.QuestionsPage.TravelParty.PartyMember {
    
    func toDomain() -> HealthCheckDetail.LandingPage.QuestionsPage.TravelParty.PartyMember {
        return HealthCheckDetail.LandingPage.QuestionsPage.TravelParty.PartyMember(
            imageURL: self.imageURL.value,
            reservationGuestId: self.reservationGuestId.value,
            name: self.name.value,
            genderCode: self.genderCode.value,
            isAlreadySigned: self.isAlreadySigned.value
        )
    }
}

extension GetHealthCheckDetailResponse.HealthCheckRefusePage {
    
    func toDomain() -> HealthCheckDetail.HealthCheckRefusePage {
        return HealthCheckDetail.HealthCheckRefusePage(
            imageURL: self.imageURL.value,
            description: self.description.value,
            title: self.title.value
        )
    }
}

extension GetHealthCheckDetailResponse.HealthCheckReviewPage {
    
    func toDomain() -> HealthCheckDetail.HealthCheckReviewPage {
        return HealthCheckDetail.HealthCheckReviewPage(
            imageURL: self.imageURL.value,
            title: self.title.value,
            description: self.description.value,
            confirmationQuestion: self.confirmationQuestion.value
        )
    }
}

// MARK: - Empty objects

extension HealthCheckDetail.LandingPage {
    
    static func empty() -> HealthCheckDetail.LandingPage {
        HealthCheckDetail.LandingPage(title: "",
                                          description: "",
                                          imageURL: "",
                                          questionsPage: .empty())
    }
}

extension HealthCheckDetail.LandingPage.QuestionsPage {
    
    static func empty() -> HealthCheckDetail.LandingPage.QuestionsPage {
        
        HealthCheckDetail.LandingPage.QuestionsPage(healthQuestions: [],
                                                        healthContract: "",
                                                        travelParty: .empty(),
                                                        confirmationQuestion: "")
    }
}

extension HealthCheckDetail.LandingPage.QuestionsPage.TravelParty {
    
    static func empty() -> HealthCheckDetail.LandingPage.QuestionsPage.TravelParty {
        HealthCheckDetail.LandingPage.QuestionsPage.TravelParty(title: "",
                                                                    description: "",
                                                                    alreadySignedTitle: "",
                                                                    partyMembers: [])
    }
}

extension HealthCheckDetail.HealthCheckRefusePage {
    
    static func empty() -> HealthCheckDetail.HealthCheckRefusePage {
        HealthCheckDetail.HealthCheckRefusePage(imageURL: "",
                                                    description: "",
                                                    title: "")
    }
}

extension HealthCheckDetail.HealthCheckReviewPage {
    
    static func empty() -> HealthCheckDetail.HealthCheckReviewPage {
        HealthCheckDetail.HealthCheckReviewPage(imageURL: "",
                                                    title: "",
                                                    description: "",
                                                    confirmationQuestion: "")
    }
}
