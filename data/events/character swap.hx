function onEvent(e:EventGameEvent){
    if (e.event.name == "character swap"){
        switchChar(e.event.params[0],e.event.params[0]);
    }
}

function switchChar(isPlayer:Bool = false,sel:Int = 0) {
    for (i in 0...strumLines.members[(isPlayer ? 1 : 0)].characters.length){
        strumLines.members[(isPlayer ? 1 : 0)].characters[i].visible = (sel == i ? true : false);
    }
}

function create() switchChar();