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

### Dispose Bag 🗑
 The Disposable that needs to be returned in the Observable is used to clean up the Observable if it doesn’t have a chance to complete the work normally or When we are done with a sequence and we want to release all of the resources allocated to compute the upcoming elements.
 When a DisposeBag is deallocated, it will call dispose on each of the added disposables.
 
#### Observable Operators
* **Creating Observables**
  * __Create__ — create an Observable from scratch by calling observer methods programmatically
  ```
  let observable = Observable<String>.create { (observer) -> Disposable in
    
    DispatchQueue.global(qos: .default).async {
        // Simulate some work
        Thread.sleep(forTimeInterval: 10)
        observer.onNext("Hello 🐣")
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
  let observable = Observable<String>.just("Hello again  🐥");
observable.subscribe(onNext: { (element) in
    print(element)
}).addDisposableTo(disposeBag)
        
observable.subscribe(onCompleted: { 
    print("I'm done")
}).addDisposableTo(disposeBag)
  
  ```
  * __Interval__ — create an Observable that emits a sequence of integers spaced by a particular time interval
  * __Repeat__ — create an Observable that emits a particular item or sequence of items repeatedly
