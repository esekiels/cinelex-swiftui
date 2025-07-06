//
//  ViewModelState.swift
//  Base
//
//  Created by Esekiel Surbakti on 06/07/25.
//

public enum ViewModelState<T> {
    case idle
    case loading
    case success(data: T)
    case error(error: AppError)
}
