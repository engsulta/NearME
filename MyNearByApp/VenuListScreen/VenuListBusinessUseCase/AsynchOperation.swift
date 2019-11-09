//
//  AsynchOperation.swift
//  TableView Handling Operations
//
//  Created by Ahmed Sultan  on 9/15/19.
//  Copyright © 2019 Ahmed Sultan . All rights reserved.
//

import Foundation

enum State:String {
    case ready, executing, finished
    
    fileprivate var keyPath : String{
        return "is" + self.rawValue.capitalized
    }
}

class AsynchOperation : Operation {
    
    var state = State.ready {
        willSet{
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet{
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
}

extension AsynchOperation{
    override var isReady: Bool{
        return super.isReady && state == State.ready
    }
    override var isExecuting: Bool{
       return  state == State.executing
    }
    override var isFinished: Bool{
        return state == State.finished
    }
    override var isAsynchronous: Bool{
        return true
    }
    
    override func start() {
        guard !isCancelled else {
            cancel()
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        state = .finished
    }
}
