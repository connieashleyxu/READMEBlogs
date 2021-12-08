//
//  IAPManager.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/13/21.
//

import Foundation
import Purchases
import StoreKit

final class IAPManager {
    static let shared = IAPManager()
    static let formatter = ISO8601DateFormatter()
    
    //track blog views
    var totalViews = UserDefaults.standard.integer(forKey: "totalViews")
    
    //when is user eligible to view post
    private var postEligibleViewDate: Date? {
        get {
            guard let string = UserDefaults.standard.string(forKey: "postEligibleViewDate") else {
                return nil
            }
            return IAPManager.formatter.date(from: string)
        }
        set {
            guard let date = newValue else {
                return
            }
            let string = IAPManager.formatter.string(from: date)
            UserDefaults.standard.set(string, forKey: "postEligibleViewDate")
        }
    }

    private init() {}

    //is user a premium user
    func isPremium() -> Bool {
        return UserDefaults.standard.bool(forKey: "premium")
    }

    //get latest status of user sub
    public func getSubscriptionStatus(completion: ((Bool) -> Void)?){
        Purchases.shared.purchaserInfo { info, error in
            guard let entitlements = info?.entitlements,
                  error == nil else {
                      return
                  }

            //print(entitlements)
            if entitlements.all["Premium"]?.isActive == true {
                print("sub updated")
                UserDefaults.standard.set(true, forKey: "premium")
                completion?(true)
            } else {
                print("not sub updated")
                UserDefaults.standard.set(false, forKey: "premium")
                completion?(false)
            }
        }
    }

    //get single package
    public func fetchPackages(completion: @escaping (Purchases.Package?) -> Void) {
        //TODO: fix error fetching package
        Purchases.shared.offerings { offerings, error in
            guard let package = offerings?.offering(identifier: "default")?.availablePackages.first,
                  error == nil else {
                print("error fetch package sub")
                completion(nil)
                return
            }
            completion(package)
        }
    }

    //is user subscribed
    public func subscribe(package: Purchases.Package, completion: @escaping (Bool) -> Void) {
        print("IAPManager subscribe func called")
        guard !isPremium() else {
            //already subscribed
            print("user already sub")
            completion(true)
            return
        }

        Purchases.shared.purchasePackage(package) { transaction, info, error, userCancelled in
            guard let transaction = transaction, let entitlements = info?.entitlements, error == nil, !userCancelled else {
                      return
                  }

            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                //print("purchased: \(entitlements)")
                //update user default after check entitlement
                if entitlements.all["Premium"]?.isActive == true {
                    print("purchased")
                    UserDefaults.standard.set(true, forKey: "premium")
                    completion(true)
                } else {
                    print("purchase failed")
                    UserDefaults.standard.set(false, forKey: "premium")
                    completion(false)
                }

                //set user default true if premium
                //UserDefaults.standard.set(true, forKey: "premium")
            case .failed:
                print("failed")
            case .restored:
                print("restored")
            case .deferred:
                print("deferred")
            @unknown default:
                print("default")
            }
        }
    }

    //restore previous prem/subs
    public func restorePurchases(completion: @escaping (Bool) -> Void){
        Purchases.shared.restoreTransactions { info, error in
            guard let entitlements = info?.entitlements,
                  error == nil else {
                      return
                  }

            //print("restored: \(entitlements)")
            if entitlements.all["Premium"]?.isActive == true {
                print("restore success")
                UserDefaults.standard.set(true, forKey: "premium")
                completion(true)
            } else {
                print("restore failure")
                UserDefaults.standard.set(false, forKey: "premium")
                completion(false)
            }
        }
    }
}

//track post views
extension IAPManager {
    var canViewPost: Bool {
        if isPremium() {
            return true
        }

        guard let date = postEligibleViewDate else {
            return true
        }
        
        UserDefaults.standard.set(0, forKey: "postViews")
        return Date() >= date
    }
    
    //track post views
    public func logPostViewed() {
        //total view count for blog

        totalViews += 1

        UserDefaults.standard.set(totalViews, forKey: "totalViews")
        
//        let totalViews = UserDefaults.standard.integer(forKey: "postViews")
//        UserDefaults.standard.set(totalViews + 1, forKey: "postViews")
        
        print("log post view count: \(totalViews)")
        
        if totalViews == 2 {
            print("total post views is 2")
            
            //cannot view post for period of time
            let hour: TimeInterval = 60 * 60
            postEligibleViewDate = Date().addingTimeInterval(hour * 24)
        }
    }
}
