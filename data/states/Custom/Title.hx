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
//Press Ent Text
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
//for that fuckass sonic
import openfl.display.BlendMode;
//cutscene a
import funkin.game.cutscenes.VideoCutscene;

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
    if(tmr != 15) tmr = 15;
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

function cutscene(){
    openSubState(new VideoCutscene(Paths.video('Intro'), () -> {
		FlxG.switchState(new TitleState());
	}));
}

function generateGraphic(sprite:FlxSprite, width:Float,height:Float,color:FlxColor = FlxColor.WHITE):FlxSprite
    {
        sprite.makeGraphic(1,1,color);
        sprite.setGraphicSize(Std.int(width),Std.int(height));
        sprite.updateHitbox();
        return sprite;
    }
var transitioning:Bool = false;
var wiggle:Bool = false;
var wiggleDistance:Float = 0;
var weewoo:Float = 0;
var pressSine:Float = 80;
var allowedStartFade:Bool = false;    

var transitioning:Bool = false;
var tmr:Float = 15;
var playingVideo:Bool = false;
var evil:Bool = FlxG.save.data.legacyReveal;
var allowedToEnter:Bool = false;
var handTop:FlxSprite;
var handBot:FlxSprite;
var startGame:FlxSprite;
var logo:FlxSprite;

override function update(elapsed:Float)
{
    if(evil){
        weewoo += elapsed * 2.8;
        FlxG.camera.scroll.y = 50 + Math.cos(weewoo) * 10;

        if (wiggle){
            doWiggle(handTop, logo.x + 97.6, logo.y + 34, weewoo, wiggleDistance);
            doWiggle(handBot, logo.x + 1069.75, logo.y + 639, weewoo, wiggleDistance, true);
        } else weewoo = 0;
        if (!transitioning){
            if (wiggle && allowedStartFade){
                pressSine += 80 * elapsed;
                startGame.alpha = 1 - Math.sin((Math.PI * pressSine) / 80);
            }
        } else {
            startGame.animation.play("press",true);
            startGame.alpha = 1;
        }
    }
    if(!evil){
		tmr -= elapsed;

		if (tmr <= 0 && !playingVideo) {
			playingVideo = true;
			FlxG.sound.music.fadeOut(2,0, Void -> {FlxG.sound.music.destroy(); FlxG.sound.music = null;});
			var b = new FlxSprite();
            generateGraphic(b,FlxG.width,FlxG.height,0xFF000000);
			b.alpha = 0;
			add(b);
			FlxTween.tween(b, {alpha: 1},2, {onComplete: Void -> {
                cutscene();
			}});


			//play video
		}
    }
    if (FlxG.keys.justPressed.F)  FlxG.fullscreen = !FlxG.fullscreen;

    var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

    var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

    if (gamepad != null)
    {
        if (gamepad.justPressed.START)
            pressedEnter = true;
    }

    if (pressedEnter && transitioning && skippedIntro && !evil) {
        tmr = 15;
        FlxG.camera.stopFX();// FlxG.camera.visible = false;
        goToMainMenu();
    }
    if(pressedEnter && !transitioning && skippedIntro && evil){
        forceComplete();
    }

    if (pressedEnter && !transitioning && skippedIntro && !evil)
    {
        pressEnter();
    }

    if (pressedEnter && !skippedIntro && !evil)
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
        if(!evil){
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
    }

function titleAssets(){

    if(!evil){
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
    if(evil){
        FlxG.camera.zoom = 0.35;
        FlxG.mouse.visible = false;

        FlxG.sound.playMusic(Paths.music('Legacytrueintro'), 1, true);

        FlxG.mouse.visible = false;
        
        handTop = new FlxSprite();
        handTop.loadGraphic(Paths.image("userinterface/title/handTop"));
        handTop.scrollFactor.set(0.5,0.5);
        add(handTop);

        handBot = new FlxSprite();
        handBot.loadGraphic(Paths.image("userinterface/title/handBot"));
        handBot.scrollFactor.set(0.5,0.5);
        add(handBot);

        logo = new FlxSprite();
        logo.loadGraphic(Paths.image("userinterface/title/logo"));
        logo.updateHitbox();
        logo.screenCenter(FlxAxes.XY);
        logo.alpha = 0;
        add(logo);

        startGame = new FlxSprite();
        startGame.frames = Paths.getSparrowAtlas('userinterface/title/startGame');
        startGame.animation.addByIndices("idle", "startGame", [0], "", 1, false);
        startGame.animation.addByIndices("press", "startGame", [1], "", 1, true);
        startGame.animation.play("idle");
        startGame.scrollFactor.set(1.5,2);
        add(startGame);


        for (g in [handTop,handBot,startGame]){
            g.updateHitbox();
            g.screenCenter(FlxAxes.XY);
            g.scale.set(0,0);
            g.alpha = 0;
            FlxTween.tween(g.scale, {x: 1, y:1}, 1, {ease: FlxEase.quintInOut});
        }

        FlxTween.tween(logo, {alpha: 1}, 0.5, {ease: FlxEase.quintInOut});
        
        startGame.y = logo.y+1012.9;

        new FlxTimer().start(0.2, function(start:FlxTimer){
                FlxTween.tween(FlxG.camera, {zoom: 0.4}, 2, {ease: FlxEase.sineOut});

                FlxTween.tween(handTop,{alpha:1},1,{ease: FlxEase.sineInOut,startDelay: 1});
                FlxTween.tween(handBot,{alpha:1},1,{ease: FlxEase.sineInOut,startDelay: 1});
    
                FlxTween.tween(startGame, {y: logo.y + 1237.75}, 2, {ease: FlxEase.quintInOut});
                FlxTween.tween(handTop, {x: logo.x + 97.6, y: logo.y + 34}, 2, {ease: FlxEase.quintInOut});
                FlxTween.tween(handBot, {x: logo.x + 1069.75, y: logo.y + 639}, 2, {ease: FlxEase.quintInOut});
                new FlxTimer().start(1.6,Void->{
                    wiggle = true;   
                    //FlxTween.tween(this, {wiggleDistance: 15}, 1, {ease: FlxEase.quadInOut});                    
                    //the one above crashes game, all it does is over the course of 1 second tween wiggleDistance to 15
                    //luckily theres a dedicated function for tweening numbers in flixel lol
                    FlxTween.num(wiggleDistance, 15, 1, {ease: FlxEase.quadInOut, onUpdate: (val:Float) -> wiggleDistance = val.value});
                    FlxTween.tween(startGame,{alpha:1},1,{ease: FlxEase.sineInOut});
                    new FlxTimer().start(0.8,Void->{allowedStartFade=true; allowedToEnter = true;});
    
                });
                
                
            });
        
        // FlxTransitionableState.defaultTransIn = FadeTransition;
        // FlxTransitionableState.defaultTransOut = FadeTransition;
    }
}
function forceComplete() {
    allowedToEnter = false;
    transitioning = true;
    FlxFlicker.flicker(startGame, 4, 0.06, true,true);
    FlxG.sound.play(Paths.sound('VERY_intro_sound'));

    new FlxTimer().start(3, function(tmr:FlxTimer){
        FlxG.sound.music.fadeIn(1.5, 0, 0);
            FlxG.camera.fade(0xFF000000, 1, false, () -> {
                new FlxTimer().start(1, function(tmr:FlxTimer){
                    goToMainMenu();
                });
            });
        });
}
function doWiggle(spr:FlxSprite, x:Float, y:Float, weewwoo:Float, mul:Float, reverse:Bool = false){
    if (reverse) spr.setPosition(x - Math.sin(weewwoo) * mul, y - Math.cos(weewwoo) * mul);
    else spr.setPosition(x + Math.sin(weewwoo) * mul, y + Math.cos(weewwoo) * mul);
    spr.angle = Math.sin(weewwoo) * (mul/7.5);
}
/*
function beatHit(curBeat:Int)
{
    logo.animation.play('idle');
}
*/