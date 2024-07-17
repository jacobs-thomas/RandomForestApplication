import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class RandomForestApplicationApp extends Application.AppBase
{
    // Cosntructor:
    function initialize() 
    {
        AppBase.initialize();
    }


    // Methods:
    function onStart(state as Dictionary?) as Void 
    {
    }

    function onStop(state as Dictionary?) as Void 
    {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] 
    {
        return [ new RandomForestApplicationView() ];
    }

    function onSettingsChanged() as Void 
    {
        WatchUi.requestUpdate();
    }

}

function getApp() as RandomForestApplicationApp 
{
    return Application.getApp() as RandomForestApplicationApp;
}