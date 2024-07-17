import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

import Jacobs;

class RandomForestApplicationView extends WatchUi.WatchFace
{
    // Class Attributes:
    private const _TOLERANCE as Float = 1.0;


    // Instance Attributes:
    private var layoutOrchestrator as LayoutOrchestrator = new LayoutOrchestrator();
    private var _metrics = [new Cadence(), new Pace(), new HeartRate()];


    // Constructor:
    function initialize() 
    {
        WatchFace.initialize();
    }


    // Methods:
    function onLayout(dc as Dc) as Void 
    {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onUpdate(dc as Dc) as Void 
    {
        // Update and clear the previous view frame.
        View.onUpdate(dc);

        // Cache these variables to optimise their frequent use.
        var activity = Activity.getActivityInfo();
        var queue = new MetricQueue();
        var result = [];
        var maximumPriority = 0;
        var priority = 0;
        var heuristics = [];

        // Collect and prioritise metrics
        for (var i = 0; i < _metrics.size(); i++)
        {
            // Add a new sample using the latest activity info.
            _metrics[i].addSample(activity);


            heuristics = _metrics[i].getHeuristicsAsArray();
            priority = (heuristics[0] + heuristics[1] + heuristics[2]) * heuristics[3];

            queue.enqueue(_metrics[i], priority);

            if(maximumPriority < priority) { maximumPriority = priority; }
        }

        // Filter metrics based on the tolerance threshold
        var item = null;

        while (!queue.isEmpty())
        {
            item = queue.dequeue();

            if(maximumPriority - item.priority < _TOLERANCE)
            {
                result.add(item.metric);
            }
        }

        // Draw filtered metrics
        layoutOrchestrator.draw(result, dc);
    }
}
