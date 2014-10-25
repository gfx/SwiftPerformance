//
//  ViewController.swift
//  SwiftPerformance
//
//  Created by Fuji Goro on 2014/10/25.
//  Copyright (c) 2014年 Fuji Goro. All rights reserved.
//

import UIKit

class C {
    let foo = "foo"
    let bar = "bar"
    let baz = "baz"

    init() {}
    deinit {}
}
class S {
    let foo = "foo"
    let bar = "bar"
    let baz = "baz"

    init() {}
}

class ViewController: UIViewController {

    var N = 100000

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func startTiming(sender: UIButton) {
        perform("class ") {
            var a = [C]()
            for _ in 1 ... self.N {
                a.append(C())
            }
        }
        perform("struct") {
            var a = [S]()
            for _ in 1 ... self.N {
                a.append(S())
            }
        }
    }

    func perform(name: String, block: () -> Void) {
        var results = [NSTimeInterval]()

        for _ in 1 ... 10 {
            let t0 = getTime()
            block()
            results.append(getTime() - t0)
        }

        let sum = results.reduce(0.0) { (a, item) in
            a + item
        }
        let avg = sum / Double(results.count)

        let dev = sqrt(results.reduce(0.0) { (a, item) in
            a + pow(item - avg, 2)
        } / Double(results.count))

        println(String(format: "%@: %.03f (+/- %.03f)", name, avg, dev))
    }

    func getTime() -> NSTimeInterval {
        return NSDate().timeIntervalSince1970;
    }
}

