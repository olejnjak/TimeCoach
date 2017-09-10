//
//  Container.swift
//  KartingCoach
//
//  Created by Lukáš Hromadník on 10.09.17.
//

import Swinject
import SwinjectAutoregistration

let container: Container = {
    let c = Container()
    
    c.autoregister(AppDependency.self, initializer: AppDependency.init)
    c.register(CircuitStore.self) { _ in LapTimeStore() }
    
    c.autoregister(AppFactory.self, initializer: AppFactory.init)
    c.register(NewRaceViewModelFactory.self) { r in
        return { NewRaceViewModel(circuit: $0, dependencies: r ~> AppDependency.self) }
    }
    
    return c
}()