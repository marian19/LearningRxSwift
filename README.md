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

### Observable Operators
