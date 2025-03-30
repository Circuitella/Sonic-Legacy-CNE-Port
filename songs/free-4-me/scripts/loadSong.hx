var songList:Array<String> = [];
var curDiffName:String = "Hard";

function create(){
    if(player.cpu){
        songList = ["cheat-4-me"];
        PlayState.loadWeek({songs: [for (song in songList) {name: song}]}, curDiffName);
    }
    else{
        songList = ["Obituary"];
        PlayState.loadWeek({songs: [for (song in songList) {name: song}]}, curDiffName);
    }
}