import APIKit
import Rswift

public enum APIRoutes {
    case fetchHiragana

    public func configurePath() -> (method: HTTPMethod, path: String) {
        switch self {
        case .fetchHiragana:
            return (.post, R.string.localizable.hiragana())
        }
    }
}
