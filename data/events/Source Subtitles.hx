import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.text.FlxText;
var camLyric:FlxCamera;

var box:FlxSprite;
var lines = [];

function create()
{
    camLyric = new FlxCamera();
	camLyric.bgColor = 0;
    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(camLyric, false);
	FlxG.cameras.add(camHUD, false);

    box = new FlxSprite(0, 570).makeGraphic(FlxG.width / 2, 60, FlxColor.TRANSPARENT);
    box.cameras = [camLyric];
    box.screenCenter();
    box.alpha = 0.5;
    add(box);

    //game.modchartTimers['lyricTimer'] = new FlxTimer();
}

function onEvent(event)
{
    if(event.event.name != "Source Subtitles") return;
    trace(event.event.params);
    var value1:String = event.event.params[1];
    var value2:String = event.event.params[2];
    var flValue1:Null<Float> = Std.parseFloat(value1);
    var flValue2:Null<Float> = Std.parseFloat(value2);
    if (Math.isNaN(flValue1)) flValue1 = null;
    if (Math.isNaN(flValue2)) flValue2 = null;
    if (box.alpha == 0)
        FlxTween.tween(box, {alpha: 0.5}, 0.3, {ease: FlxEase.expoOut});

    var lyric = new FlxText(box.x + 10, 570, box.width - 10, value1, 28);
    lyric.font = Paths.font("trebuc.ttf");
    lyric.cameras = [camLyric];

    if (lyric.textField.numLines > 1)
        lyric.y -= 15 * lyric.textField.numLines;
    
    lyric.alpha = 1;
    FlxTween.tween(lyric, {alpha: 1}, 0.4, {ease: FlxEase.expoOut});

    lines.push(lyric);
    add(lyric);

    var totalHeight = lyric.height;

    // stupid fucking solution but IDK ANYTHING ELSE THAT IS WORKIN RIGHT :upside_down:
    while (lines.length > 4)
    {
        remove(lines[0]);
        lines.remove(lines[0]);
    }

    remove(lyric, false);
    insert(99, lyric);
    
    for (i in 0...lines.length - 1)
    {
        var curLine = lines[i];
        FlxTween.cancelTweensOf(curLine);

        FlxTween.tween(curLine, {y: curLine.y - lyric.height}, 0.01, {ease: FlxEase.expoOut});
        totalHeight += curLine.height;
    }

    FlxTween.completeTweensOf(box);

    var scaling = box.height;

    box.y = lines[0].y;

    if (lines.length > 1)
        box.y -= lyric.height;

    box.makeGraphic(box.width, totalHeight, FlxColor.TRANSPARENT);
    box.origin.set(0, box.height);

    scaling /= box.height;
    FlxTween.tween(box.scale, {y: 1}, 0.4, {ease: FlxEase.expoOut});

    box.scale.set(1, scaling);

    if (modchartTimers['lyricTimer'].active)
        modchartTimers['lyricTimer'].cancel();

    modchartTimers['lyricTimer'].start(value2, ()->
    {
        FlxTween.tween(box.scale, {y: 0}, 0.4, {ease: FlxEase.backIn});



        var i = 0;
        for (line in lines)
        {
            FlxTween.tween(line, {alpha: 0}, 0.4, {ease: FlxEase.expoOut, startDelay: 0.08 * i,
                onComplete: ()->
                {
                    remove(line);
                    lines.remove(line);
                }});
        }
        i++;
    });
}

function onUpdate()
{
    if (lines.length == 0)
        box.alpha = 0;

    FlxSpriteUtil.drawRoundRect(box, 0, 0, box.width, box.height, 20, 20, 0xFF000000);
}