import Sys;

var camMove:Bool = true;
var songList:Array<String> = [];
var curDiffName:String = "Hard";

var rate = 25;

import flixel.camera.FlxCameraFollowStyle;

var timeAmount:Float = 0.35;
var lockOnSpeed:Float = 0.07;

var returnTimer = new FlxTimer();
var botPlayed:Bool = false;
function botPlayMFDie(){
    songList = ["cheat-4-me"];
    PlayState.loadWeek({songs: [for (song in songList) {name: song}]}, curDiffName);
}
function update(){
    if(player.cpu) botPlayed = true;
    if(playerStrums.cpu) botPlayed = true;
    if(botPlayed) botPlayMFDie();
}
function onNoteHit(_) {
    if(camMove){
        if(botPlayed == null) Sys.exit(0);
        if(_.player){
            if(curCameraTarget != 0) {
                if(returnTimer != null) returnTimer.cancel();
                returnTimer = new FlxTimer().start(timeAmount, function(timer) FlxG.camera.targetOffset.set(0, 0));
                moveCameraOnNotes(_.direction);
            }
        }
        if(!_.player){
            if(curCameraTarget == 0) {
                if(returnTimer != null) returnTimer.cancel();
                returnTimer = new FlxTimer().start(timeAmount, function(timer) FlxG.camera.targetOffset.set(0, 0));
                moveCameraOnNotes(_.direction);
            }
        }
    }

}

function moveCameraOnNotes(noteDirection) {
    switch(noteDirection){
        case 0: FlxG.camera.targetOffset.set(0 - rate, 0);
        case 1: FlxG.camera.targetOffset.set(0, 0 + rate);
        case 2: FlxG.camera.targetOffset.set(0, 0 - rate);
        case 3: FlxG.camera.targetOffset.set(0 + rate, 0);
    }
}
