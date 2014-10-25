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
}
struct S {
    let foo = "foo"
    let bar = "bar"
    let baz = "baz"
}
class O: NSObject {
    let foo = "foo"
    let bar = "bar"
    let baz = "baz"
}

class ViewController: UIViewController {

    var N = 10000

    var result: Any?

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func startTiming(sender: UIButton) {
        perform("class     ") {
            var a = [C]()
            for _ in 1 ... self.N {
                a.append(C())
            }
        }
        perform("objc class") {
            var a = [O]()
            for _ in 1 ... self.N {
                a.append(O())
            }
        }
        perform("struct    ") {
            var a = [S]()
            for _ in 1 ... self.N {
                a.append(S())
            }
        }
    }
    @IBAction func startTimingForOptionalTypes(sender: UIButton) {
        perform("optional    ") {
            var i: Int? = 0
            for x in 1 ... self.N {
                i = (i ?? 0) + x
            }
            self.result = i // prevent optimization
        }
        perform("non-optional") {
            var i: Int = 0
            for x in 1 ... self.N {
                i = i + x
            }
            self.result = i // prevent optimization
        }
    }
    func perform(name: String, block: () -> Void) {
        // rps: run per second

        let t0 = getTime()
        var count = 0
        while true {
            block()

            count++
            let elapsed = getTime() - t0
            if elapsed >= 1.0 {
                let rps = NSTimeInterval(count) / elapsed
                println("\(name): \(Int(rps)) rps")
                break;
            }
        }
    }

    func perform_(name: String, block: () -> Void) {
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

