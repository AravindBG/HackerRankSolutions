import Foundation

/*
 * Complete the 'queensAttack' function below.
 *
 * The function is expected to return an INTEGER.
 * The function accepts following parameters:
 *  1. INTEGER n
 *  2. INTEGER k
 *  3. INTEGER r_q
 *  4. INTEGER c_q
 *  5. 2D_INTEGER_ARRAY obstacles


 - int n: the number of rows and columns in the board
 - nt k: the number of obstacles on the board
 - int r_q: the row number of the queen's position
 - int c_q: the column number of the queen's position
 - int obstacles[k][2]: each element is an array of integers, the row and column of an obstacle
 */

enum ObstacleRelativePosition: String {
    case lowerLeft
    case lowerCenter
    case lowerRight
    case leftCenter
    case rightCenter
    case topLeft
    case topCenter
    case topRight
    case none
}

struct Position: Equatable {
    var row = 0
    var column = 0

    var distance = 0
    var relPos: ObstacleRelativePosition = .none

    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
}

extension Position {

    func getRelativeObstaclePosition(obtPos: inout Position) {
        let rowDiff = obtPos.row - self.row
        let colDiff = obtPos.column - self.column

        // lower left diagonal (-1, -1)
        if rowDiff == colDiff && rowDiff < 0 && colDiff < 0 {
            obtPos.distance = abs(rowDiff) - 1
            obtPos.relPos = .lowerLeft
        }

        // top right diagonal (1,1)?

        else if rowDiff == colDiff && rowDiff > 0 && colDiff > 0 {
            obtPos.distance = rowDiff - 1
            obtPos.relPos = .topRight
        }

        // lower vertical diagonal (-1, 0)

        else if colDiff == 0 && rowDiff < 0 {
            obtPos.distance = abs(rowDiff) - 1
            obtPos.relPos = .lowerCenter
        }

        // lower right diagonal (-1, 1)

        else if abs(rowDiff) == abs(colDiff) && colDiff < 0 {
            obtPos.distance = abs(rowDiff) - 1
            obtPos.relPos = .lowerRight
        }

        // left horizondal diagonal (0, -1)

        else if rowDiff == 0 && colDiff < 0 {
            obtPos.distance = abs(colDiff) - 1
            obtPos.relPos = .leftCenter
        }

        // right horizondal diagonal (0, 1)

        else if rowDiff == 0 && colDiff > 0 {
            obtPos.distance = colDiff - 1
            obtPos.relPos = .rightCenter
        }

        // top left diagonal (1, -1)
        else if abs(rowDiff) == abs(colDiff) && colDiff > 0 {
            obtPos.distance = colDiff - 1
            obtPos.relPos = .topLeft
        }

        // top vertical diagonal (1, 0)

        else if colDiff == 0 && rowDiff > 0 {
            obtPos.distance = rowDiff - 1
            obtPos.relPos = .topCenter
        }
    }

}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ position: Position) {
        appendInterpolation("Position [\(position.row), \(position.column)], distance \(position.distance), relative position \(position.relPos.rawValue)")
    }
}

func queensAttack(n: Int, k: Int, r_q: Int, c_q: Int, obstacles: [[Int]]) -> Int {
    // Write your code here

    if n == 1 { return 0 }
    let qPos = Position(row: r_q, column: c_q, distance: 0, relPos: .none) //(r_q, c_q)
    print("Queen \(qPos)")

    let obstaclePos = obstacles.map { (obst) -> Position in
        if obst.count == 2 {
            return Position(row: obst.first ?? 0, column: obst.last ?? 0, distance: 0, relPos: .none)
        }
        fatalError("Invalid input")
    }

    // Identify closest position
    print("\n\n")
    // lower left diagonal (-1, -1)
    var minValue = min(qPos.row, qPos.column)
    var maxMoveDist = minValue - 1
    var lld: Position = Position(row: qPos.row - maxMoveDist, column: qPos.column - maxMoveDist, distance: maxMoveDist, relPos: .lowerLeft)
    print("Left Lower \(lld)")
    // lower vertical diagonal (-1, 0)

    var lvd: Position = Position(row: 1, column: qPos.column, distance: qPos.row - 1, relPos: .lowerCenter)
    print("Left vertical \(lvd)")

    // lower right diagonal (-1, 1)
    minValue = min(qPos.row - 1 , n - qPos.column)
    // maxMoveDist = minValue //max(minValue - 1, 1)

    var lrd: Position = Position(row: qPos.row - minValue, column: qPos.column + minValue, distance: minValue, relPos: .lowerRight)
    print("Left right \(lrd)")

    // left horizondal diagonal (0, -1)

    var lhd: Position = Position(row: qPos.row, column: 1, distance: qPos.column - 1, relPos: .leftCenter)
    print("Left center \(lhd)")

    // right horizondal diagonal (0, 1)

    var rhd: Position = Position(row: qPos.row, column: n, distance: max(n - qPos.column, 0), relPos: .rightCenter)
    print("Right center \(rhd)")

    // top left diagonal (1, -1)
    //    var maxValue = max(qPos.row, qPos.column)
    maxMoveDist = min((n - qPos.row), (qPos.column - 1))

    var tld: Position = Position(row: qPos.row + maxMoveDist, column: qPos.column - maxMoveDist, distance: maxMoveDist, relPos: .topLeft)
    print("Top left \(tld)")

    // top vertical diagonal (1, 0)

    var tvd: Position = Position(row: n, column: qPos.column, distance: n - qPos.row, relPos: .topCenter)
    print("Top center \(tvd)")

    // top right diagonal (1,1)
    maxMoveDist = n - max(qPos.row, qPos.column)

    var trd: Position = Position(row: qPos.row + maxMoveDist, column: qPos.column + maxMoveDist, distance: maxMoveDist, relPos: .topRight)
    print("Top right \(trd)")
    print("\n\n")

    for pos in obstaclePos {

        var otherPos = pos
        qPos.getRelativeObstaclePosition(obtPos: &otherPos)
        let relPos = otherPos.relPos
        print("Obstacle \(otherPos)")

        switch relPos {
        case .lowerLeft:
            closestObstacle(obtPos: &lld, otherPos: otherPos, relPos: relPos)
        case .lowerCenter:
            closestObstacle(obtPos: &lvd, otherPos: otherPos, relPos: relPos)
        case .lowerRight:
            closestObstacle(obtPos: &lrd, otherPos: otherPos, relPos: relPos)
        case .leftCenter:
            closestObstacle(obtPos: &lhd, otherPos: otherPos, relPos: relPos)
        case .rightCenter:
            closestObstacle(obtPos: &rhd, otherPos: otherPos, relPos: relPos)
        case .topLeft:
            closestObstacle(obtPos: &tld, otherPos: otherPos, relPos: relPos)
        case .topCenter:
            closestObstacle(obtPos: &tvd, otherPos: otherPos, relPos: relPos)
        case .topRight:
            closestObstacle(obtPos: &trd, otherPos: otherPos, relPos: relPos)
        case .none:
            continue
        }
    }

    let firstHalf: Int = lld.distance + lvd.distance + lrd.distance + lhd.distance
    let secondHalf: Int = rhd.distance + tld.distance + tvd.distance + trd.distance
    return firstHalf + secondHalf

}

func closestObstacle( obtPos: inout Position, otherPos: Position, relPos: ObstacleRelativePosition) {
    if obtPos.distance > otherPos.distance {
        print("\(obtPos.distance) \(otherPos.distance)")
        obtPos = otherPos
    }
    print("Closest obstacle after comparing \(obtPos)")
}

let result = queensAttack(n: 8, k: 4, r_q: 4, c_q: 4, obstacles: [[1,1], [5,6], [4,7], [8,8]])
//let result = queensAttack(n: 4, k: 0, r_q: 4, c_q: 4, obstacles: []) // 9
//let result = queensAttack(n: 1, k: 0, r_q: 1, c_q: 1, obstacles: [])
//let result = queensAttack(n: 8, k: 4, r_q: 4, c_q: 4, obstacles: []) // 27
//let result = queensAttack(n: 8, k: 4, r_q: 4, c_q: 4, obstacles: [[3,5]]) // 24

//let result = queensAttack(n: 4, k: 0, r_q: 1, c_q: 1, obstacles: []) // 9

print("Result \(result)")
