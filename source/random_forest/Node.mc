import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Math;

module Jacobs
{
    class Node
    {
        /**
        * A data structure representing a node in the decision tree used in the RandomForest.
        * Each node contains a heuristic, a metric, and a value used for evaluations.
        */


        // Instance Attributes:
        public var heuristic as Numeric32 = 0;
        public var metric as Numeric32 = 0;
        public var value as Numeric32 = 0;


        // Constructor:
        public function initialize(heuristic as Numeric32, metric as Numeric32)
        {
            /**
            * Initializes the Node instance with the given heuristic and metric values.
            * 
            * @param heuristic as Numeric32 - The heuristic value to be assigned to the node.
            * @param metric as Numeric32 - The metric value to be assigned to the node.
            */


            self.heuristic = heuristic;
            self.metric = metric;
        }
    }
}