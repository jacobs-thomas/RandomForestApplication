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
    private var _randomForest as RandomForest = new RandomForest();


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

        // Draw filtered metrics.
        var results = _randomForest.evaluate(Activity.getActivityInfo());
        var metrics = [];
        var previousPriority = 0;
        

        while(!results.isEmpty())
        {
            var item = results.dequeue();
            if(previousPriority - item.priority > _TOLERANCE) { continue; }
            previousPriority = item.priority;
            metrics.add(item.metric);
        }

        layoutOrchestrator.draw(metrics, dc);
    }
}
