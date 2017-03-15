# LearningRxSwift
An observer subscribes to an Observable. Then that observer reacts to whatever item or sequence of items the Observable emits.

The Subscribe method is how you connect an observer to an Observable. Your observer implements some subset of the following methods:

* **onNext**
An Observable calls this method whenever the Observable emits an item. This method takes as a parameter the item emitted by the Observable.

* **onError**
An Observable calls this method to indicate that it has failed to generate the expected data or has encountered some other error. It will not make further calls to onNext or onCompleted. The onError method takes as its parameter an indication of what caused the error.

* **onCompleted**
An Observable calls this method after it has called onNext for the final time, if it has not encountered any errors.

## “Hot” and “Cold” Observables
A “hot” Observable may begin emitting items as soon as it is created, and so any observer who later subscribes to that Observable may start observing the sequence somewhere in the middle. A “cold” Observable, on the other hand, waits until an observer subscribes to it before it begins to emit items, and so such an observer is guaranteed to see the whole sequence from the beginning.

## Dispose Bag 🗑
 The Disposable that needs to be returned in the Observable is used to clean up the Observable if it doesn’t have a chance to complete the work normally or When we are done with a sequence and we want to release all of the resources allocated to compute the upcoming elements.
 When a DisposeBag is deallocated, it will call dispose on each of the added disposables.
 
 ## Schedulers
 Schedulers are most commonly used to easily tell the observables and observers on which threads/queues should they execute, or send notifications.
The most common operators connected to schedulers you’ll use are **observeOn** and **subscribeOn**.
Normally the Observable will execute and send notifications on the same thread on which the observer subscribes on.

#### **ObserveOn**
observeOn specifies a scheduler on which the Observable will send the events to the observer. It doesn’t change the scheduler (thread/queue) on which it executes.

```
let observable = Observable<String>.create { (observer) -> Disposable in
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        // Simulate some work
        NSThread.sleepForTimeInterval(10)
        observer.onNext("Hello dummy 🐥")
        observer.onCompleted()
    })
    return NopDisposable.instance
}.observeOn(MainScheduler.instance)
```
#### **SubscribeOn**
subscribeOn is very similar to observeOn but it also changes the scheduler on which the Observable will execute work.

```
let observable = Observable<String>.create { (observer) -> Disposable in
   // Simulate some work
   NSThread.sleepForTimeInterval(10)
   observer.onNext("Hello dummy 🐥")
   observer.onCompleted()
   return NopDisposable.instance
}

//it causes the Observable to work on a global queue, but also send events on a global queue, not on the UI queue
observable.subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Default)).subscribeNext { [weak self] (element) in
 self?.myUIText.text = element
}.addDisposableTo(disposeBag)
```

```
let observable = Observable<String>.create { (observer) -> Disposable in
   // Simulate some work
   NSThread.sleepForTimeInterval(10)
   observer.onNext("Hello dummy 🐥")
   observer.onCompleted()
   return NopDisposable.instance
}.observeOn(MainScheduler.instance)
        observable.subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Default)).subscribeNext { [weak self] (element) in
 self?.myUIText.text = element
}.addDisposableTo(disposeBag)
```
 
## Observable Operators
### **Creating Observables**
  * __Create__ — create an Observable from scratch by calling observer methods programmatically

  ```
  let observable = Observable<String>.create { (observer) -> Disposable in
    
    DispatchQueue.global(qos: .default).async {
        // Simulate some work
        Thread.sleep(forTimeInterval: 10)
        observer.onNext("Hi")
        observer.onCompleted()
    }
    return Disposables.create()
}

observable.subscribe(onNext: { (element) in
print(element)
}).addDisposableTo(disposeBag)
```

  * __Just__ — convert an object or a set of objects into an Observable that emits that or those objects
  ```
  let observable = Observable<String>.just("Hi");
observable.subscribe(onNext: { (element) in
    print(element)
}).addDisposableTo(disposeBag)
        
observable.subscribe(onCompleted: { 
    print("I'm done")
}).addDisposableTo(disposeBag)
  
  ```
  * __Interval__ — create an Observable that emits a sequence of integers spaced by a particular time interval
  
  ```
  let observable = Observable<Int>.interval(0.3, scheduler: MainScheduler.instance)
observable.subscribe(onNext: { (element) in
   print(element)
}).addDisposableTo(disposeBag)
```
  * __Repeat__ — create an Observable that emits a particular item or sequence of items repeatedly
  
  ```
  let observable = Observable<String>.repeatElement("Hi")
observable.subscribe(onNext: { (element) in
   print(element)
}).addDisposableTo(disposeBag)

```

### **Transforming Observables**
  * __FlatMap__ — transform the items emitted by an Observable into Observables, then flatten the emissions 
  * __Map__ — transform the items emitted by an Observable by applying a function to each item
  ```
  let observable = Observable<Int>.create { (observer) -> Disposable in
    observer.onNext(1)
    return NopDisposable.instance
}

let boolObservable : Observable<Bool> = observable.map { (element) -> Bool in
    if (element == 0) {
        return false
    } else {
        return true
    }
}

boolObservable.subscribeNext { (boolElement) in
    print(boolElement)
    }.addDisposableTo(disposeBag)
```
    
  * __Scan__ — apply a function to each item emitted by an Observable, sequentially, and emit each successive value
  
  ```
  let observable = Observable<String>.create { (observer) -> Disposable in
    observer.onNext("D")
    observer.onNext("U")
    observer.onNext("M")
    observer.onNext("M")
    observer.onNext("Y")
    return NopDisposable.instance
}

observable.scan("") { (lastValue, currentValue) -> String in
	// The new value emmited is the LAST value emmited + current value:
    return lastValue + currentValue
    }.subscribeNext { (element) in
        print(element)
    }.addDisposableTo(disposeBag)
    }
}

 Will print:
  D
  DU
  DUM
  DUMM
  DUMMY
```
```
let observable = Observable<Int>.create { (observer) -> Disposable in
    observer.onNext(1)
    observer.onNext(2)
    observer.onNext(3)
    observer.onNext(4)
    observer.onNext(5)
    return NopDisposable.instance
}

observable.scan(1) { (lastValue, currentValue) -> Int in  
    return lastValue * currentValue
    }.subscribeNext { (element) in
        print(element)
    }.addDisposableTo(disposeBag)
    }
}

//Here’s the scan operator to calculate a factorial of 5, which will print 120
```

### **Filtering Observables**
  * __Filter__ — emit only those items from an Observable that pass a predicate test
  
  ```
  let observable = Observable<String>.create { (observer) -> Disposable in
    observer.onNext("🎁")
    observer.onNext("💩")
    observer.onNext("🎁")
    observer.onNext("💩")
    observer.onNext("💩")
    return NopDisposable.instance
}

observable.filter { (element) -> Bool in
    return element == "🎁"
    }.subscribeNext { (element) in
        print(element)
    }.addDisposableTo(disposeBag)
}
```

  * __Debounce__ — only emit an item from an Observable if a particular timespan has passed without it emitting another item
  
  debounce in this example just skips elements that aren’t at least 2 seconds apart. So if an element will be emitted after   
  1 second after the last one, it’ll be skipped, if it’s emitted 2.5 seconds after the last one, it’ll be emitted.
  ```
  
observable.debounce(2, scheduler: MainScheduler.instance).subscribeNext { (element) in
    print(element)
}
```

### **Combining Observables**

  * __Merge__ — combine multiple Observables into one by merging their emissions
  
  ```
    let observable = Observable<String>.create { (observer) -> Disposable in
    observer.onNext("🎁")
    observer.onNext("🎁")
    return NopDisposable.instance
}
        
let observable2 = Observable<String>.create { (observer) -> Disposable in
    observer.onNext("💩")
    observer.onNext("💩")
    return NopDisposable.instance
}
        
Observable.of(observable, observable2).merge().subscribeNext { (element) in
    print(element)
}.addDisposableTo(disposeBag)
```

  * __Zip__ — combine the emissions of multiple Observables together via a specified function and emit single items for each combination based on the results of this function
  
  ```
  let observable = Observable<String>.create { (observer) -> Disposable in
    observer.onNext("🎁")
    observer.onNext("🎁")
    return NopDisposable.instance
}
        
let observable2 = Observable<String>.create { (observer) -> Disposable in
    observer.onNext("💩")
    observer.onNext("💩")
    return NopDisposable.instance
}

[observable, observable2].zip { (elements) -> String in
    var result = ""
    for element in elements {
        result += element
    }
    return result
}.subscribeNext { (element) in
    print(element)
}.addDisposableTo(disposeBag)
```



