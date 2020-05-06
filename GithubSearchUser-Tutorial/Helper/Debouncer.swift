//
//  Debouncer.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation

final class Debouncer {
    private var interval: TimeInterval
    
    private var timer: Timer?
    
    init(interval: TimeInterval) {
        self.interval = interval
    }

    func call(action: @escaping () -> Void) {
        resetTimer()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: self.interval, repeats: false, block: { (_) in
                action()
            })
        }
    }
    
    private func resetTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}
