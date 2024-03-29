//
//  SnapKit+Chainable.swift
//  swift-mvvm
//
//  Created by 남오승 on 2021/07/15.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    var didMoveToSuperview: ControlEvent<Void> {
        //sentMessage : 메소드가 호출 되기 전 실행
        //methodInvoked : 호출된 후 실행
        let event = methodInvoked(#selector(Base.didMoveToSuperview)).map { _ in }
        return ControlEvent(events: event)
    }
}

extension Chain where Origin: UIView {
    func constrain(_ maker: @escaping (ConstraintMaker) -> Void) -> Chain {
        if let _ = origin.superview {
            origin.snp.makeConstraints(maker)
        }else {
            _ = origin.rx.didMoveToSuperview
                .take(1)
                .subscribe(onNext:{ [weak self] _ in
                    self?.origin.snp.makeConstraints(maker)
                })
        }
        
        return self
    }
    
    func updateConstrain(_ maker: @escaping (ConstraintMaker) -> Void) -> Chain {
        if let _ = origin.superview {
            origin.snp.updateConstraints(maker)
        }else {
            _ = origin.rx.didMoveToSuperview
                .take(1)
                .subscribe(onNext:{ [weak self] _ in
                    self?.origin.snp.updateConstraints(maker)
                })
        }
        return self
    }
}
