//
//  Edge.swift
//  Dijkstra
//
//  Adapted from Julien Gomès under Apache License.
//  Edited by Advanced Computer Science class for educational use.
//

import Foundation

struct Edge {
    var source: Vertex
    var destination: Vertex
    var distances: Int[]
    
    init(sourceParam: Vertex, destinationParam: Vertex, distancesParam: Int[]) {
        self.source = sourceParam
        self.destination = destinationParam
        self.distances = distancesParam
    }
}
