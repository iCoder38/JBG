//
//  ServerConstants.swift
//  WaterTanker
//
//  Created by Shyam on 06/10/20.
//  Copyright © 2020 EVS. All rights reserved.
//

import Foundation
import UIKit

//MARK - Base Url
struct SERVER{
    static let kBASE_URL = "https://script.google.com/macros/s/AKfycbyAz8p2wjn4IR7kF7-WAZdFYumXxSOOWrvCdxB7LknLyjkaeiVk/exec"
    static let kSERVER_CONN = "Server connecction faild! Please try later."
}

//MARK - Url Methods

struct API_Urls {
    static let login_Api                        = "login"
    static let forgotpassword_Api               = "forgotpassword"
    static let resetpassword                    = "resetpassword"
    static let registration_Api                 = "registration"
    static let otpVerify_Api                    = "verifyotp"
    static let resentOtp_Api                    = "resendotp"
    //User
    static let profile_Details_Api              = "profile"
    static let editprofile_Api                  = "editprofile"
    static let changePassword_Api               = "changePassword"
    static let termAndConditions_Api            = "termAndConditions"
    static let privacypolicy_Api                = "privacypolicy"
    static let logout_Api                       = "logout"
}

struct ACTION {
    static let kAPI_ACTION                     = "action"
}

struct USER {
    static let kUSERID                           = "userId"
    static let kUSER_PWD                         = "password"
    static let kUSER_EMAIL                       = "email"
    static let kUSER_FULL_NAME                   = "fullName"
    static let kUSER_MOBILE                      = "contactNumber"
    static let kUSER_IMG                         = "image"
    static let kUSER_ADDRESS                     = "address"
    static let kLATITUDE                         = "latitude"
    static let kLONGITUDE                        = "logitude"
    static let userRole                          = "role"
    static let kDRIVERID                         = "driverId"
}

struct EXTRA {
    
    static let kAPI_STATUS                    = "status"
    static let kAPI_STATUS_SUCCESS            = "success"
    static let kAPI_MSG                       = "msg"
    static let kAPI_RESPONSE                  = "response"
    static let kAPI_LOGIN_DATA                = "loginInfo"
    static let kAPI_REPORT_DATA               = "reportInfo"
    static let kAPI_OPTIONS                   = "options"
    static let kAPI_PAGE_NO                   = "page"
}

struct DEVICE {
    static let kDEVICE                        = "device"
    static let kDEVICE_NAME                   = "ios"
    static let kDEVICE_TOKEN                  = "deviceToken"
}
