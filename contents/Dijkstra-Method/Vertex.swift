//
//  Vertex.swift
//  Dijkstra
//
//  Adapted from Julien Gomès under Apache License.
//  Edited by Advanced Computer Science class for educational use.
//

import Foundation

struct Vertex: Hashable {
    /**
    * ID of the vertex
    */
    var vertexId: Int
    /**
    * A human comprehensible representation of the vertex
    */
    var name: String
    /**
    * The parameter needed by the Hashable protocol
    */
    var hashValue:Int
    
    init(vertexIdParam: Int, nameParam:String) {
        self.vertexId = vertexIdParam
        self.name = nameParam
        self.hashValue = self.vertexId
    }
}

func == (vertexA: Vertex, vertexB: Vertex) -> Bool {
    return vertexA.hashValue == vertexB.hashValue
}
