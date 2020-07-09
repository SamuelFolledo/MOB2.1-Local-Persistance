//
//  CloudError.swift
//  News
//
//  Created by Mustafa Yusuf on 15/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import CloudKit

extension Cloud {
    
    public func diagnoseError(error: Error?) {
        #if DEBUG
        guard let unwrappedError = error else { return }
        guard let error = unwrappedError as? CKError else { fatalError() }
        print("\n\n---------------------")
        print("\nCloudKit error")
        switch error.code {
        case .alreadyShared:
            print("alreadyShared")
        case .internalError:
            print("internalError")
        case .partialFailure:
            print("partialFailure")
        case .networkUnavailable:
            print("networkUnavailable")
        case .networkFailure:
            print("networkFailure")
        case .badContainer:
            print("badContainer")
        case .serviceUnavailable:
            print("serviceUnavailable")
        case .requestRateLimited:
            print("requestRateLimited")
        case .missingEntitlement:
            print("missingEntitlement")
        case .notAuthenticated:
            print("notAuthenticated")
        case .permissionFailure:
            print("permissionFailure")
        case .unknownItem:
            print("unknownItem")
        case .invalidArguments:
            print("invalidArguments")
        case .resultsTruncated:
            print("resultsTruncated")
        case .serverRecordChanged:
            print("serverRecordChanged")
        case .serverRejectedRequest:
            print("serverRejectedRequest")
        case .assetFileNotFound:
            print("assetFileNotFound")
        case .assetFileModified:
            print("assetFileModified")
        case .incompatibleVersion:
            print("incompatibleVersion")
        case .constraintViolation:
            print("constraintViolation")
        case .operationCancelled:
            print("operationCancelled")
        case .changeTokenExpired:
            print("changeTokenExpired")
        case .batchRequestFailed:
            print("batchRequestFailed")
        case .zoneBusy:
            print("zoneBusy")
        case .badDatabase:
            print("badDatabase")
        case .quotaExceeded:
            print("quotaExceeded")
        case .zoneNotFound:
            print("zoneNotFound")
        case .limitExceeded:
            print("limitExceeded")
        case .userDeletedZone:
            print("userDeletedZone")
        case .tooManyParticipants:
            print("tooManyParticipants")
        case .referenceViolation:
            print("referenceViolation")
        case .managedAccountRestricted:
            print("managedAccountRestricted")
        case .participantMayNeedVerification:
            print("participantMayNeedVerification")
        case .serverResponseLost:
            print("serverResponseLost")
        case .assetNotAvailable:
            print("assetNotAvailable")
        @unknown default:
            print("")
        }
        print("\n\n********************")
        #endif
    }
}
