import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Math;

module Jacobs
{    
    class RandomForest
    {
        /**
        * Class representing a Random Forest for evaluating performance metrics (cadence, pace, and heart rate).
        * The Random Forest consists of multiple decision trees, and each tree is used to evaluate
        * metrics such as Cadence, Pace, and HeartRate. The evaluation results in the most recommended
        * metric based on the trees' heuristics.
        */


        // Class Attributes:
        private const NUMBER_OF_TREES as Integer32 = 8;
        private const ROOT_NODE as Integer32 = 0;
        private const NODES_PER_BRANCH as Integer32 = 2;
        private const LEFT as Integer32 = 1;
        private const RIGHT as Integer32 = 2;
        private const POSITIVE as Integer32 = 1;


        // Instance Attributes:
        private var _metrics as Array<Metric> = new Array<Metric>[0];
        private var _trees as Array<Tree> = new Array<Tree>[0];
        private var _previousResponse = 0;


        // Constructor:
        public function initialize()
        {
            /**
            * Initialises the RandomForest instance by setting up the metrics and trees.
            */

            // Initialise the metrics array with instances of different metrics.
            _metrics = [new Cadence(), new Pace(), new HeartRate()];
            
            // Initialize the decision trees with random sizes between 4 and 13.
            for(var i = 0; i < NUMBER_OF_TREES; i++)
            {
                _trees.add(new Tree(Math.rand() % 10 + 4));
            }
        }


        // Methods:
        public function evaluate() as Metric or Null
        {
            /**
            * Evaluates the metrics using the random forest.
            * This method updates each metric to collect new samples, then evaluates each decision tree in the forest.
            * Each tree traverses its nodes based on the heuristics of the metrics, updating the node values and recording
            * positive recommendations for the metrics. The metric with the most positive recommendations is returned.
            * 
            * @return Metric or Null - The metric with the most positive recommendations, or null if no metric is found.
            */


            // Update each metric to collect new samples.
            for(var i = 0; i < _metrics.size(); i++) { _metrics[i].addSample(Activity.getActivityInfo()); }

            // Initialise variables to cache state during evaluation.
            var currentNodeIndex = ROOT_NODE;
            var metricResults = [0,0,0];
            var currentNode = null;
            var tree = null;
            var heuristicValue = 0;

            // Evaluate each decision tree in the forest.
            for(var i = 0; i <_trees.size(); i++)
            {
                tree = _trees[i];
                currentNodeIndex = 0;
                var exit = false;

                if(tree.previousResponse != _previousResponse) { tree.weight -= tree.weight * 0.01; }
                else { tree.weight += tree.weight * 0.1; }

                // Traverse nodes in the current tree.
                while(currentNodeIndex < tree.nodes.size() && exit == false)
                {
                    // Cache the current node and heuristic value for the current metric being assessed.
                    currentNode = tree.nodes[currentNodeIndex];
                    heuristicValue = _metrics[currentNode.metric].getHeuristics().getHeuristic(currentNode.heuristic);

                    // If the heuristic value exceeds the node value, update node and move to left child.
                    if(heuristicValue < currentNode.value)
                    {
                        currentNode.value += (heuristicValue - currentNode.value);
                        currentNodeIndex = NODES_PER_BRANCH * currentNodeIndex + LEFT;
                        continue;
                    }

                    // Otherwise, update node and move to right child, and record a positive rsesult for the metric.
                    currentNode.value += (heuristicValue - currentNode.value);
                    metricResults[currentNode.metric] += POSITIVE * tree.weight;
                    tree.previousResponse = currentNode.metric;
                    exit = true;
                }
            }


            // Finally, determine the metric with the most positive recommendations.
            var result = null;
            var resultValue = 0;

            for(var i = 0; i < metricResults.size(); i++)
            {
                if(result == null || metricResults[i] > resultValue)
                {
                    resultValue = metricResults[i];
                    result = _metrics[i];
                    _previousResponse = i;
                }
            }


            return result;
        }
    }
}