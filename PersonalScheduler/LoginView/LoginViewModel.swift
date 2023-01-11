//
//  LoginViewModel.swift
//  PersonalScheduler
//
//  Created by unchain on 2023/01/11.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthVM {
    var subScriptions = Set<AnyCancellable>()

    func kakaoLoginWithAPP() async {

        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    //do something
                    _ = oauthToken?.accessToken
                    continuation.resume(returning: true)
                }
            }
        }
    }

    func kakaoLoginWithAccount() async {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }

    @MainActor
    func kakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        //카카오톡 앱으로 로그인 인증
        Task {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                await kakaoLoginWithAPP()
            } else { // 카톡이 설치가 안되어 있으면
                await kakaoLoginWithAccount()
            }
        }
    } //login

    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
            }
        }
    }

    func handleKakaoLogout() async -> Bool {
        await withCheckedContinuation({ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        })
    }
}

