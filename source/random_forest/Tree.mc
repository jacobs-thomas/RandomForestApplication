import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Math;

module Jacobs
{
    class Tree
    {
        /**
        * A data structure representing a decision tree used in the RandomForest.
        * Each tree consists of nodes that evaluate heuristics and metrics.
        */


        // Instance Attributes:
        public var nodes as Array<Node>;
        public var weight as Float32 = 1.0;
        public var previousResponse as Integer32 = 0;


        // Constructor:
        public function initialize(size as Integer32)
        {
            /**
            * Initialises the Tree instance by creating a specified number of nodes.
            * 
            * @param size as Integer32 - The number of nodes to initialize in the tree.
            */


            // Initialise the nodes array
            nodes = new Array<Node>[0];

            // Populate the nodes array with a random quantity of new Node instances.
            for(var i = 0; i < size; i++)
            {
                var randomHeuristic = Math.rand() % 3;
                var randomMetric = Math.rand() & 2;
                nodes.add(new Node(randomHeuristic, randomMetric));
            }
        }
    }
}