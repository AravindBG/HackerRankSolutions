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

struct Position: Equatable, Hashable {
    var row: Int
    var col: Int

    static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ position: Position) {
        appendInterpolation("Position [\(position.row), \(position.col)]")
    }
}

func queensAttack(n: Int, k: Int, r_q: Int, c_q: Int, obstacles: [(Int, Int)]) -> Int {
    if n == 0 {
        return 0
    }

    let pointArray = obstacles.compactMap({Position(row: $0.0, col: $0.1)})
    let vSet = Set(pointArray)
    let qPoint = Position(row: r_q, col: c_q)
    if vSet.contains(qPoint) {
        return 0
    }

    let directions = [Position(row: 1, col: 0),
                      Position(row: -1, col: 0),
                      Position(row: 0, col: 1),
                      Position(row: 0, col: -1),
                      Position(row: 1, col: 1),
                      Position(row: -1, col: -1),
                      Position(row: 1, col: -1),
                      Position(row: -1, col: 1)]
    var count = 0
    for pos in directions {
        var curr = Position(row: r_q+pos.row, col: c_q+pos.col)
        let numRange = 1...n
        while numRange.contains(curr.row),numRange.contains(curr.col), !(vSet.contains(curr)) {
            //print(curr)
            curr = Position(row: curr.row + pos.row, col: curr.col + pos.col) //(cur[0]+u, cur[1]+v)
            count = count + 1
        }
    }
    return count
}

let result = queensAttack(n: 8, k: 4, r_q: 4, c_q: 4, obstacles: [(1,1), (5,6), (4,7), (8,8)]) // 23
//let result = queensAttack(n: 4, k: 0, r_q: 4, c_q: 4, obstacles: []) // 9
//let result = queensAttack(n: 1, k: 0, r_q: 1, c_q: 1, obstacles: [])
//let result = queensAttack(n: 8, k: 4, r_q: 4, c_q: 4, obstacles: []) // 27
//let result = queensAttack(n: 8, k: 4, r_q: 4, c_q: 4, obstacles: [(3,5)]) // 24

//let result = queensAttack(n: 4, k: 0, r_q: 1, c_q: 1, obstacles: []) // 9

print("Result \(result)")
