import Foundation

public struct Size: Hashable, Sendable {
    public let columns: Int
    public let rows: Int
}

extension Size {
    public static var zero: Size { Size(columns: 0, rows: 0) }

    public var width: Int { columns }
    public var height: Int { rows }

    init(columns: UInt16, rows: UInt16) {
        self.columns = Int(columns)
        self.rows = Int(rows)
    }
}

extension Size: CustomStringConvertible {
    public var description: String {
        "\(Int(columns)) columns, \(Int(rows)) rows"
    }
}

public struct Point: Hashable, Sendable {
    public let x: Int
    public let y: Int
}

extension Point: CustomStringConvertible {
    public var description: String { "x: \(x), y: \(y)" }
}
