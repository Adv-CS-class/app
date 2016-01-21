//
//  Dijkstra.swift
//  Dijkstra
//
//  Adapted from Julien Gomès under Apache License.
//  Edited by Advanced Computer Science class for educational use.
//

import Foundation

class Dijkstra {
    /**
    * The graph on which the algorithm is launched
    */
    var graph: Graph
    /**
    * The list of stops we have already settled
    */
    var settledStopList: Vertex[] = []
    /**
    * The list of stops we have not settled yet
    */
    var unSettledStopList: Vertex[] = []
    /**
    * An array containing all the predecessor for one vertex
    */
    var predecessors: Dictionary<Vertex, Vertex> = Dictionary<Vertex, Vertex>()
    /**
    * For each vertex of the grah, this dictionarry contains the list of distance
    * from the source. If only one dimension is used for the distance mesurement,
    * then the dimension of the array will always be 1
    */
    var distanceFromVertex: Dictionary<Vertex, Int[]> = Dictionary<Vertex, Int[]>()
    
    /**
    * First we give the algorithm the graph
    */
    init(graphParam:Graph) {
        self.graph = graphParam
    }
    
    /**
    * When we want to launch the algiorithm, we provide the source
    */
    func execute(destination: Vertex) {
        // We start by initializing all the different members
        self.settledStopList = []
        self.unSettledStopList = []
        self.predecessors = Dictionary<Vertex, Vertex>()
        
        // We initialize the value for the source and add it as the root
        self.distanceFromVertex[destination] = self.createDistance(0)
        self.unSettledStopList.append(destination)
        
        // And we start to iterate
        while self.unSettledStopList.count > 0 {
            let vertexAndIndexSelected = self.getVertexWithMinimunDistanceAmong(self.unSettledStopList)
            
            self.settledStopList.append(vertexAndIndexSelected.vertex)
            self.unSettledStopList.removeAtIndex(vertexAndIndexSelected.index)
            
            self.findMinimalDistanceForVertexAndInsertInUnSettledVertex(vertexAndIndexSelected.vertex)
        }
    }
    
    func createDistance(initializationValue: Int) -> Int[]{
        // TODO: check that edgeList has at least one edge
        let dimension: Int = self.graph.edgeList[0].distances.count
        var distance: Int[] = Int[]()
        for index in 0..dimension {
            distance.append(initializationValue);
        }
        return distance
    }
    
    func getVertexWithMinimunDistanceAmong(vertexList: Vertex[]) -> (vertex: Vertex, index: Int) {
        var vertex: Vertex?
        var index: Int?
        var currentIndex: Int = 0;
        for tmpVertex in vertexList {
            if(vertex == nil) {
                vertex = tmpVertex
                index = currentIndex
            } else {
                let shortestDistanceForVertexA:Int[] = self.getShortestDistanceForVertex(vertex!)
                let shortestDistanceForVertexTmpVertex:Int[] = self.getShortestDistanceForVertex(tmpVertex)
                if(self.compareShortestDistance(shortestDistanceForVertexA,shortestDistanceForVertexB: shortestDistanceForVertexTmpVertex) == -1) {
                    vertex = tmpVertex
                    index = currentIndex
                }
            }
            
            currentIndex++
        }
        return (vertex!, index!)
    }
    
    func compareShortestDistance(shortestDistanceForVertexA: Int[], shortestDistanceForVertexB: Int[]) -> Int {
        var result:Int = 0
        
        for index in 0..shortestDistanceForVertexA.count {
            let distanceA = shortestDistanceForVertexA[index]
            let distanceB = shortestDistanceForVertexB[index]
            if(distanceA < distanceB) {
                result = -1;
                break;
            } else if (distanceA > distanceB) {
                result = 1;
                break;
            } else {
                result = 0;
            }
        }
        return result
    }
    
    func findMinimalDistanceForVertexAndInsertInUnSettledVertex(vertex: Vertex) {
        let neighborList: Vertex[] = self.getNeighbors(vertex)
        for neighbour: Vertex in neighborList {
            let shortestDistanceForVertex: Int[] = self.getShortestDistanceForVertex(vertex)
            let shortestDistanceForNeighbour: Int[] = self.getShortestDistanceForVertex(neighbour)
            let distanceBetweenVertexAndTarget: Int[] = self.getDistanceBetween(vertex,destination: neighbour)
            
            let distances: Int[] = self.addDistance(shortestDistanceForVertex,distanceB: distanceBetweenVertexAndTarget)
            
            if(self.compareShortestDistance(shortestDistanceForNeighbour, shortestDistanceForVertexB: distances) == 1) {
                self.distanceFromVertex[neighbour] = distances
                self.predecessors[neighbour] = vertex
                self.unSettledStopList.append(neighbour)
            }
        }
    }
    
    func getNeighbors(vertex: Vertex) -> Vertex[] {
        var neighbors: Vertex[] = Vertex[]()
        for edge in self.graph.edgeList {
            if(edge.source == vertex) {
                neighbors.append(edge.destination)
            }
        }
        return neighbors
    }
    
    func getShortestDistanceForVertex(vertex: Vertex) -> Int[]{
        var distance:Int[] = Int[]()
        if(self.distanceFromVertex[vertex]) {
            distance = self.distanceFromVertex[vertex]!
        } else {
            distance = self.createDistance(Int.max)
        }
        return distance
    }
    
    func getDistanceBetween(source: Vertex, destination: Vertex) -> Int[] {
        var distances:Int[] = Int[]()
        for edge: Edge in self.graph.edgeList {
            if(edge.source == source && edge.destination == destination) {
                distances = edge.distances
                break
            }
        }
        return distances
    }
    
    func addDistance(distanceA: Int[], distanceB: Int[]) -> Int[] {
        var distance:Int[] = Int[]()
        for index: Int in 0..distanceA.count {
            distance.append(distanceA[index] + distanceB[index])
        }
        return distance
    }
    
    func getPath(destination: Vertex) -> Vertex[]? {
        var path:Vertex[] = Vertex[]()
        var step: Vertex = destination
        if(!self.predecessors[destination]) {
            return nil
        }
        path.append(step)
        while(self.predecessors[step]) {
            step = self.predecessors[step]!
            path.append(step)
        }
        return path.reverse()
    }
}
