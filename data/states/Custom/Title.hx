import funkin.backend.MusicBeatGroup;
import funkin.backend.utils.XMLUtil;
import flixel.util.typeLimit.OneOfTwo;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
import haxe.xml.Access;
import flixel.addons.display.FlxBackdrop; 
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.effects.FlxFlicker;
import flixel.math.FlxRect;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import openfl.display.BlendMode;

var initialized:Bool = false;

var curWacky:Array<String> = [];

var blackScreen:FlxSprite;
var textGroup:FlxGroup;
var ngSpr:FlxSprite;
var logo:FlxSprite;
var wackyImage:FlxSprite;

//LEGACY
var rSonicOverlay:FlxSprite;
var rSonic:FlxSprite;
var rLogo:FlxSprite;
var rLogoBop:FlxTween = null;
var camBop:FlxTween = null;

var pressStartTxt:FlxText;

var pressSine:Float = 0.0;

var blackScreen:FlxSprite;

var rShowTitle:Bool = false;
//END LEGACY VARS

function create()
{
    startIntro();
}

var logoBl:FlxSprite;
var gfDance:FlxSprite;
var danceLeft:Bool = false;
var titleText:FlxSprite;
var titleScreenSprites:MusicBeatGroup;

function startIntro()
{
    if (!initialized)
        CoolUtil.playMenuSong(true);

    persistentUpdate = true;

    skipIntro();
}

function getIntroTextShit():Array<Array<String>>
{
    var fullText:String = Assets.getText(Paths.txt('titlescreen/introText'));

    var firstArray:Array<String> = fullText.split('\n');
    var swagGoodArray:Array<Array<String>> = [];

    for (i in firstArray)
    {
        swagGoodArray.push(i.split('--'));
    }

    return swagGoodArray;
}

var transitioning:Bool = false;

override function update(elapsed:Float)
{
    if (!transitioning){ //got mad when i used &&
        if (FlxG.sound.music.volume < 0.8)
            FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);
    }


    if (FlxG.keys.justPressed.F)  FlxG.fullscreen = !FlxG.fullscreen;

    var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

    var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

    if (gamepad != null)
    {
        if (gamepad.justPressed.START)
            pressedEnter = true;
    }

    if (pressedEnter && transitioning && skippedIntro) {
        FlxG.camera.stopFX();// FlxG.camera.visible = false;
        goToMainMenu();
    }

    if (pressedEnter && !transitioning && skippedIntro)
    {
        pressEnter();
    }

    if (pressedEnter && !skippedIntro)
        skipIntro();
}

function pressEnter() {
    transitioning = true;
    FlxG.camera.flash(FlxColor.WHITE, 1);
    FlxG.sound.play(Paths.sound('menu/confirm'), 0.7);
    new FlxTimer().start(1, (_) -> goToMainMenu());
    if (pressStartTxt != null) {
        pressStartTxt.alpha = 1.0;
        pressStartTxt.color = FlxColor.YELLOW;
        FlxFlicker.flicker(pressStartTxt, 1, 0.06, true, true);
    }
}

function goToMainMenu() {
    FlxG.switchState(new MainMenuState());
}

function createCoolText(textArray:Array<String>)
{
    for (i=>text in textArray)
    {
        if (text == "" || text == null) continue;
        var money:Alphabet = new Alphabet(0, (i * 60) + 200, text, true, false);
        money.screenCenter(X);
        textGroup.add(money);
    }
}

function addMoreText(text:String)
{
    var coolText:Alphabet = new Alphabet(0, (textGroup.length * 60) + 200, text, true, false);
    coolText.screenCenter(X);
    textGroup.add(coolText);
}

function deleteCoolText()
{
    while (textGroup.members.length > 0) {
        textGroup.members[0].destroy();
        textGroup.remove(textGroup.members[0], true);
    }
}



var skippedIntro:Bool = false;

function skipIntro():Void
{
    if (!skippedIntro)
    {
        skippedIntro = true;
        titleAssets();
    }
}

function beatHit(curBeat:Int)
	{		
		if (curBeat % 4 == 0)
			{

					if(rLogoBop != null) rLogoBop.cancel();
					rLogo.scale.set(0.725, 0.725);
					rLogoBop = FlxTween.tween(rLogo, {'scale.x': 0.675, 'scale.y': 0.675}, 0.5, {ease: FlxEase.quartOut});
	
					if(camBop != null) camBop.cancel();
					camBop = FlxTween.num(1.015, 1.0, 0.25, {ease: FlxEase.quartOut}, function(v:Float)
						{
							FlxG.camera.zoom = v;
						});
					

				if (!rShowTitle && !transitioning)
					{
						rShowTitle = true;
						FlxG.camera.flash(0xD0FFFFFF, 1.25);
						blackScreen.visible = false;
					}
			}
        }

function titleAssets(){
    var bg = new FlxBackdrop(Paths.image('userinterface/title/city'));
    bg.velocity.x = 100;
    bg.antialiasing = true;
    add(bg);

    rSonicOverlay = new FlxSprite(500, -100).loadGraphic(Paths.image('userinterface/title/sonic'));
    rSonicOverlay.antialiasing = true;
    rSonicOverlay.scale.set(0.9, 0.9);
    rSonicOverlay.updateHitbox();
    rSonicOverlay.blend = BlendMode.MULTIPLY;
    rSonicOverlay.clipRect = new FlxRect(0,0,rSonicOverlay.width-250,rSonicOverlay.height);
    add(rSonicOverlay);

    var bar = new FlxSprite();
    bar.makeGraphic(FlxG.width,124, FlxColor.BLACK);
    add(bar);

    var bar2 = new FlxSprite(0,FlxG.height-124);
    bar2.makeGraphic(FlxG.width,124, FlxColor.BLACK);
    add(bar2);



    rSonic = new FlxSprite(532, -65).loadGraphic(Paths.image('userinterface/title/sonic'));
    rSonic.antialiasing = true;
    rSonic.scale.set(0.675, 0.675);
    add(rSonic);

    rLogo = new FlxSprite(-160, 170).loadGraphic(Paths.image('userinterface/title/rodentraplogo'));
    rLogo.antialiasing = true;
    rLogo.scale.set(0.675, 0.675);
    add(rLogo);

    pressStartTxt = new FlxText(188, 510, 0, "Press ENTER to start!", 32);
    pressStartTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    pressStartTxt.scrollFactor.set();
    pressStartTxt.borderSize = 1.25;
    pressStartTxt.antialiasing = true;
    add(pressStartTxt);
        

    blackScreen = new FlxSprite((FlxG.width * -1) / 2, (FlxG.height * -1)).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
    add(blackScreen);

}
/*
function beatHit(curBeat:Int)
{
    logo.animation.play('idle');
}
*/