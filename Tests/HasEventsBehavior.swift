//
//  HasEventsBehavior.swift
//  RxCoreLocation
//
//  Created by Bob Obi on 09.11.17.
//  Copyright © 2017 RxCoreLocation. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import CoreLocation
@testable import RxCoreLocation


struct HasEventsBehaviorContext {
    let sut: CLLocationManager
    let scheduler: TestScheduler
    let selector: Selector
    let invoked: (() -> ())
    
    init(_ sut: CLLocationManager, _ scheduler: TestScheduler, _ selector: Selector, invoked: @escaping(() -> ())) {
        self.sut = sut
        self.scheduler = scheduler
        self.selector = selector
        self.invoked = invoked
    }
}

class HasEventsBehavior: Quick.Behavior<HasEventsBehaviorContext> {
    override class func spec(_ context: @escaping () -> HasEventsBehaviorContext) {
        
        var sut: CLLocationManager!
        var scheduler: TestScheduler!
        var selector: Selector!
        var invoked: (() -> ())!
        
        beforeEach {
            let cxt = context()
            sut = cxt.sut
            scheduler = cxt.scheduler
            selector = cxt.selector
            invoked = cxt.invoked
        }
        
        afterEach {
            sut = nil
            scheduler = nil
            selector = nil
        }
        
        describe("Has Events Behavior") {
            it("sentMessage") {
                SharingScheduler.mock(scheduler: scheduler) {
                    let sentMessage = scheduler.record(source: sut.rx.delegate.sentMessage(selector))
                    invoked()
                    scheduler.start()
                    expect(sentMessage.events.count) == 1
                }
            }
            
            it("methodInvoke") {
                SharingScheduler.mock(scheduler: scheduler) {
                    let methodInvoked = scheduler.record(source: sut.rx.delegate.methodInvoked(selector))
                    invoked()
                    scheduler.start()
                    expect(methodInvoked.events.count) == 1
                }
            }
        }
    }   
}