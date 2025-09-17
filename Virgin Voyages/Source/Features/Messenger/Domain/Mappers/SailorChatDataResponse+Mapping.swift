//
//  SailorDataResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.2.25.
//

extension SailorChatDataResponse {
    func toDomain() -> SailorChatData {
        return SailorChatData(
            result: self.result ?? "unknown",
            msg: self.msg.value,
            id: self.id ?? -1,
            sailorIamUserId: self.sailorIamUserId.value,
            subject: self.subject.value,
            status: self.status.value,
            loyalty: self.loyalty.value,
            cabinNumber: self.cabinNumber.value,
            ownedBy: self.ownedBy.value,
            requiresAttention: self.requiresAttention ?? false,
            creationTime: self.creationTime.value,
            firstMessageTime: self.firstMessageTime.value,
            streamId: self.streamId ?? -1,
            voyageNumber: self.voyageNumber.value,
            resolvedAt: self.resolvedAt.value,
            lastMessageContent: self.lastMessageContent.value,
            lastMessageTime: self.lastMessageTime.value,
            lastMessageSenderIamId: self.lastMessageSenderIamId.value,
            lastMessageSenderTime: self.lastMessageSenderTime.value,
            isUserAccountMerged: self.isUserAccountMerged ?? false
        )
    }
}
