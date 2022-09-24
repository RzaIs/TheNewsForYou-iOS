//
//  TabBarService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 31.08.22.
//


import Domain


class TabBarService: BaseService<Void, Void> {
    
    private let authIsLoggedInUseCase: BaseUseCase<Void, Bool>
    private let authGetFirstOpeningDateUseCase: BaseUseCase<Void, FirstOpeningEntity>
    private let authSetFirstOpeningDateUseCase: BaseUseCase<Date, Void>
    
    init(
        authIsLoggedInUseCase: BaseUseCase<Void, Bool>,
        authGetFirstOpeningDateUseCase: BaseUseCase<Void, FirstOpeningEntity>,
        authSetFirstOpeningDateUseCase: BaseUseCase<Date, Void>
    ) {
        self.authIsLoggedInUseCase = authIsLoggedInUseCase
        self.authGetFirstOpeningDateUseCase = authGetFirstOpeningDateUseCase
        self.authSetFirstOpeningDateUseCase = authSetFirstOpeningDateUseCase
    }
    
    var isLoggedIn: Bool {
        self.authIsLoggedInUseCase.execute(input: Void())
    }
    
    func setAskLogin(date: Date) {
        self.authSetFirstOpeningDateUseCase.execute(input: date)
    }
    
    func isAskingForLoginNeeded() -> Bool {
        if self.isLoggedIn {
            return false
        }
        
        switch self.authGetFirstOpeningDateUseCase.execute(input: Void()) {
        case .notOpened:
            return true
        case .opened(let date):
            if let days = self.daysBetween(from: date, to: Date()), days > 7 {
                return true
            } else {
                // MARK: - should be false
                return true
            }
        }
    }
    
    func daysBetween(from: Date, to: Date) -> Int? {
        Calendar.current.dateComponents([.day], from: from, to: to).day
    }
}
