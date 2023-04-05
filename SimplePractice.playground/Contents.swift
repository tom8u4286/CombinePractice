
import Foundation
import Combine

enum WeatherError: Error {
    case thingsJustHappen
}


let weatherPublisher = PassthroughSubject<Int, WeatherError>()

//let subscriber = weatherPublisher
//    .filter { $0 > 20}
//    .sink { error in
//        print(error)
//    } receiveValue: { value in
//        print("the temperture is \(value)")
//    }

//let anotherScriber =
weatherPublisher.handleEvents(receiveSubscription: { subscription in
    print("new subscription \(subscription)")
}, receiveOutput: { output in
    print("The output is \(output)")
}, receiveCompletion: { error in
    print("Subscription complited with potential error \(error)")
}, receiveCancel: {
    print("Subscription cancelled.")
}).sink { error in
    print(error)
} receiveValue: { value in
    print(value)
}

weatherPublisher.send(10)
weatherPublisher.send(15)
weatherPublisher.send(completion: Subscribers.Completion<WeatherError>.failure(.thingsJustHappen))
//weatherPublisher.send(20)
//weatherPublisher.send(25)
//weatherPublisher.send(30)
