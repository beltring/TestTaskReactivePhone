import Foundation

func getPathMatrix(matrix: [[Int]]) -> [[Int]] {
    let n = matrix.count
    let m = matrix[0].count

    var newMatrix = Array(repeating: Array(repeating: 0, count: m), count: n)

    for i in 0..<n {
        for j in 0..<m {
            var minDistance = Int.max
            for x in 0..<n {
                for y in 0..<m {
                    if matrix[x][y] == 1 {
                        let distance = abs(x - i) + abs(y - j)
                        minDistance = min(minDistance, distance)
                    }
                }
            }
            newMatrix[i][j] = minDistance
        }
    }

    return newMatrix
}

print(getPathMatrix(matrix:
                [[1,0,1],
                 [0,1,0],
                 [0,0,0]
                ]))
