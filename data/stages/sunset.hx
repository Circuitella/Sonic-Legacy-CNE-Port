import funkin.menus.ui.Alphabet;
import flixel.FlxCamera;
import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import flixel.ui.FlxBar;
import flixel.math.FlxRect;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import openfl.display.BlendMode;
import flixel.ui.FlxBarFillDirection;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.ui.FlxBar;
//vid imports
import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;
//RodentRap To Sonic Legacy Thingaling
import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.CodenameBuildField;
//vars for keeping track of song progress
var phase:Int = 1;
var songNameThing = PlayState.SONG.meta.displayName;
//groups for each phase
var fakerBG:Array<FlxSprite> = [];
var scaryBG:Array<FlxSprite> = [];
var thirdBG:Array<FlxSprite> = [];
//That blue faker
var introAnim:FlxSprite;
//lyric vars
var subTimer:FlxTimer;
var subtitleText:FlxText = new FlxText();
//UI
var healthBarOverlay:FlxSprite;
var healthBarStitch:FlxSprite; 
var scoreNum:FlxBitmapText;
var cmboNum:FlxBitmapText;
var accNum:FlxBitmapText;
var cmboBreaks:FlxSprite;
var sscore:FlxSprite;
var acc:FlxSprite;

//Videos
var video:FlxVideoSprite;
var cutscene:FlxVideoSprite;
var p3Video:FlxVideoSprite;

//Bullying BF
var kickingAnim:FlxSprite;
var rabbitHead:FlxSprite;

//Onscreen Text
var playText:Alphabet;
var boring:FlxSprite;
var boringAlphaBet:Alphabet;
var boringAlphaBet2:Alphabet;

//Ending
var black:FlxSprite;
var braindeadBF:FlxSprite;
var monitor:FlxSprite;
var blackBars:Array<FlxSprite> = [];
var scarystatic:FlxSprite;

//shaders
var itime:Float = 0;
var heatShader:CustomShader;
var crtShader:CustomShader;

//camOther is made in this song since CNE Doesnt Have One By Default
var camOther = new FlxCamera();

function onCountdown(event) event.cancel(); //skip countdown

function createUI() 
    {
        healthBarOverlay = new FlxSprite().loadGraphic(Paths.image('hpBar'));
        healthBarOverlay.screenCenter(FlxAxes.X);
        
        healthBarOverlay.y += camHUD.downscroll ? -10 : 630;
        healthBarOverlay.flipY = camHUD.downscroll;

        /*healthBar.createFilledBar(FlxColor.fromRGB(71, 63, 75), FlxColor.fromRGB(255, 242, 0));
        healthBar.updateFilledBar();
		healthBar.updateBar();*/

        healthBarStitch = new FlxSprite().loadGraphic(Paths.image('stitchMiddle'));
        healthBarStitch.y = healthBarOverlay.y + 15;
        //healthBarStitch.camera = camHUD;
        //add(healthBarStitch);

        final scoreY:Float = (camHUD.downscroll ? 100 : camHUD.height * 0.91);
        scoreTxt = new FlxText(0, scoreY + 36, FlxG.width, "", 20);
		//scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//scoreTxt.borderSize = 1.25;
        healthBarOverlay.camera = healthBarStitch.camera = camHUD;

        healthBarOverlay.alpha = healthBarStitch.alpha = 1;
        add(healthBarOverlay);
        add(healthBarStitch);


    }
function cutsceneLore(){
    camZooming = false;
    var spr = fakerBG[fakerBG.length-1];
    var time = 0.4;
    var delay = 0.2;
    //og y 616;
    FlxTween.tween(spr, {alpha: 0.3},time, {ease: FlxEase.quadIn, startDelay: delay});
    FlxTween.tween(camFollow, {x: 350, y: 580},time, {ease: FlxEase.quadIn, startDelay: delay});
    FlxTween.tween(camGame, {zoom: 1.5},time, {ease: FlxEase.quadIn, startDelay: delay, onComplete: function (f:FlxTween) {
        spr.alpha = 1;
        cutscene.alpha = 1;
        cutscene.play();
        camOther.flash(0xFFFFFFFF, 0.5);
        camHUD.zoom = 1.05;
        FlxTween.tween(camHUD,{zoom: 1},0.4, {ease: FlxEase.quadOut});
    }});
}
function doesZoom(bop:Bool){
    camZooming = bop;
}
function cutsceneDone(){
    camZooming = true;
    //imHungry();
    cutscene.destroy();
}



function generateSubs(text:String) { //timer is stupid >:( It No Work
    subtitleText.visible = true;
    subtitleText.text = text;
    subtitleText.updateHitbox();
    subtitleText.y = FlxG.height - subtitleText.height + -150;
}

function create(){
    subtitleText = new FlxText(0,0,FlxG.width,'',32);
    subtitleText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    add(subtitleText);
    subtitleText.cameras = [camOther];
    subtitleText.visible = false;
    //subtitleText.borderSize = 1.5;

    //player.cpu = true;
    heatShader = new CustomShader("heatShader");
    crtShader = new CustomShader("CRT");

    //videos
    cutscene = new FlxVideoSprite();
	cutscene.load(Assets.getPath(Paths.video('cutscene-1')));
    cutscene.camera = camHUD;
    //cutscene.video.video.onEndReached(cutsceneDone());

    add(cutscene);

    remove(cutscene, true);
    insert(0, cutscene);

    var cutsceneCacher = new FlxVideoSprite();
	cutsceneCacher.load(Assets.getPath(Paths.video('cutscene-1')));
    cutsceneCacher.camera = camOther;
    cutsceneCacher.alpha = 0.001;
    cutsceneCacher.play();
    add(cutsceneCacher);


    //this tween is to ensure it since it takes more then 1 frame to zoom in
    FlxTween.tween(camGame, {zoom: 1.3},0.5, {ease: FlxEase.sineInOut});
    camGame.zoom = 1.3;
    camOther.zoom = camHUD.zoom;
    camOther.x = camHUD.x;
    camOther.y = camHUD.y;
    camGame.zoom = 1.5;
	FlxG.cameras.add(camOther, false);
    camOther.bgColor = 0;
    camOther.alpha = 1;

    addPhase1();
    addPhase2();
    addPhase3();
    createUI();

    for(i in scaryBG) i.visible = false;

    for(i in thirdBG) i.visible = false;

    black = new FlxSprite();
    generateGraphic(black,FlxG.width,FlxG.height,0xFF000000);
    black.cameras = [camOther];
    add(black);
    remove(black, true);
    insert(0, black);
    playText = new Alphabet(0,0,'Do you want to play with me?',true, false, 0.0, 0.7);
    add(playText);
    playText.screenCenter();
    playText.cameras = [camOther];
    playText.visible = false;

    var boringOffset = 50;
    boring = new FlxSprite().loadGraphic(Paths.image('stages/obituary/boring'));
    add(boring);
    setScale(boring,0.7);
    boring.screenCenter();
    boring.x += boringOffset;
    boring.cameras = [camOther];

    boringAlphabet = new Alphabet(0,0,"you're",true, false, 0.0);
    add(boringAlphabet);
    boringAlphabet.screenCenter();
    boringAlphabet.x += -boring.width + boringOffset;
    boringAlphabet.cameras = [camOther];

    boringAlphabet2 = new Alphabet(0,0,"me",true, false, 0.0);
    add(boringAlphabet2);
    boringAlphabet2.screenCenter();
    boringAlphabet2.x += (boring.width/1.25) + boringOffset;
    boringAlphabet2.cameras = [camOther];
    
    boring.visible = boringAlphabet.visible = boringAlphabet2.visible = false;
    black.visible = false;

    var blackBar = new FlxSprite();
    generateGraphic(blackBar,FlxG.width,65,0xFF000000);
    add(blackBar);
    blackBar.cameras = [camOther];
    blackBars.push(blackBar);

    var blackBar = new FlxSprite(0,FlxG.height-65);
    generateGraphic(blackBar,FlxG.width,65,0xFF000000);
    add(blackBar);
    blackBar.cameras = [camOther];
    blackBars.push(blackBar);

    var blackBar = new FlxSprite();
    generateGraphic(blackBar,310,FlxG.height,0xFF000000);
    add(blackBar);
    blackBar.cameras = [camOther];
    blackBars.push(blackBar);

    var blackBar = new FlxSprite(980);
    generateGraphic(blackBar,310,FlxG.height,0xFF000000);
    add(blackBar);
    blackBar.cameras = [camOther];
    blackBars.push(blackBar);

    fuckassOverlay = new FlxSprite().loadGraphic(Paths.image('stages/obituary/p2/fuckassOverlay'));
    add(fuckassOverlay);
    setScale(fuckassOverlay,0.7);
    fuckassOverlay.screenCenter();
    fuckassOverlay.visible = false;
    fuckassOverlay.alpha = 0.7;
    fuckassOverlay.blend = BlendMode.ADD;
    add(fuckassOverlay);
    fuckassOverlay.cameras = [camOther];

    braindeadBF = new FlxSprite();
    braindeadBF.frames = Paths.getSparrowAtlas('stages/obituary/p1/bfreflection');
    braindeadBF.animation.addByPrefix('i','braindead',24);
    braindeadBF.animation.play('i');
    braindeadBF.cameras = [camOther];
    braindeadBF.screenCenter();
    add(braindeadBF);
    braindeadBF.scale.set(0.85,0.85);

    monitor = new FlxSprite(199.9, -26.6);
    monitor.frames = Paths.getSparrowAtlas('userinterface/desktop/bgLayers');
    monitor.animation.addByPrefix('on','monitorOn instance 1',12);
    monitor.animation.addByPrefix('off','monitorOff instance 1',12);
    monitor.animation.play('on');
    add(monitor);
    monitor.cameras = [camOther];
    // camOther.zoom = 2.2;
    braindeadBF.alpha = 0;
    monitor.visible = false;
    for (i in blackBars) i.visible = false;

    scarystatic = new FlxSprite();
    scarystatic.frames = Paths.getSparrowAtlas('static');
    scarystatic.animation.addByPrefix('idle', 'static idle', 24, true);
    scarystatic.animation.play('idle');
    scarystatic.screenCenter();
    scarystatic.camera = camOther;
    scarystatic.visible = false;
    add(scarystatic);
    camGame.alpha = 0;
    camHUD.alpha = 0;


}

function onSubstateOpen() if (cutscene != null) cutscene.pause();
function onSubstateClose() if (cutscene != null) cutscene.resume();
function onFocus() if (paused) onSubstateOpen(); // lil fix for when the window regains focus


function onSongStart(){
    remove(iconP1, true);
    remove(iconP2, true);
    remove(healthBar, true);
    remove(healthBarBG, true);
    remove(healthBarOverlay, true);
    remove(healthBarStitch, true);
    remove(accuracyTxt, true);
    remove(missesTxt, true);
    remove(scoreTxt, true);
    scoreTxt.y = scoreTxt.y + 20;
    missesTxt.y = scoreTxt.y;
    accuracyTxt.y = scoreTxt.y;

    insert(4, healthBar);
    healthBar.scale.set(1,2);
    healthBar.y = healthBar.y;
    insert(6, healthBarOverlay);
    insert(5, healthBarStitch);
    insert(99, iconP1);
    insert(99, iconP2);
    remove(boyfriend, true);
    insert(99, boyfriend);
    remove(dad, true);
    insert(99, dad);
    insert(100, scoreTxt);
    insert(100, missesTxt);
    insert(100, accuracyTxt);

    PlayState.SONG.meta.displayName = 'Free 4 Me';
    //exeUI();
    var spr = fakerBG[fakerBG.length-1];
    remove(spr, true);
    insert(101, spr);
    FlxTween.tween(spr, {alpha: 0.3},1.2);
    camHUD.alpha = 0;
    var x = 260;
    var y = 620;
    camFollow.setPosition(x,y);
    camzoom = 1.25;
    dad.visible = false;
    introAnim.animation.play('intro', false);
    camGame.alpha = 1;

}

function generateGraphic(sprite:FlxSprite, width:Float,height:Float,color:FlxColor = FlxColor.WHITE):FlxSprite
{
    sprite.makeGraphic(1,1,color);
    sprite.setGraphicSize(Std.int(width),Std.int(height));
    sprite.updateHitbox();
    return sprite;
}

function lookRight(){
    //FlxTween.tween(FlxG.camera.scroll, {x: 500},0.7, {ease: FlxEase.sineInOut});
    FlxTween.tween(camGame, {zoom: 1},0.7, {ease: FlxEase.sineInOut});
    var spr = fakerBG[fakerBG.length-1];
    FlxTween.tween(spr, {alpha: 1},1.2);
}
function begin(){
    var x = dad.getMidpoint().x + 150;
    var y = dad.getMidpoint().y - 100;

    FlxTween.tween(camFollow, {x: x,y: y},1.3, {ease: FlxEase.sineInOut});
    FlxTween.tween(camGame, {zoom: 0.65},1.3, {ease: FlxEase.sineInOut});
                
    camHUD.zoom = 1.2;
    FlxTween.tween(camHUD, {alpha: 1,zoom: 1},1.3, {ease: FlxEase.sineInOut}); 
}
function evilWindow(){
    PlayState.SONG.meta.displayName = 'Obituary';
    var windowName = "Sonic Legacy";
    WindowUtils.winTitle = windowName;
    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('iconEXE'))));
    Framerate.codenameBuildField.text = 'Sonic Legacy - CNE Port';
    FlxG.save.data.legacyReveal = true;

}
function phase2Vis(){
    phase = 2;
    for (i in fakerBG) i.visible = false;
    video.visible = true;
    for (i in scaryBG) i.visible = true;

    remove(boyfriend, true);
    insert(99, boyfriend);
    remove(dad, true);
    insert(99, dad);

    //setgraphicsize stuff
    var f = new FlxSprite();
    f.frames = Paths.getSparrowAtlas('stages/obituary/p1/bgFiles');
    f.animation.addByPrefix('i','frontshit',24);
    f.animation.play('i');
    f.setGraphicSize(3885);
    f.updateHitbox();
    f.scrollFactor.set(1.25,1.25);
    f.screenCenter();
    f.x += 210 + 150;
    f.y += 400;
    scaryBG.push(f);
    add(f);
    remove(f, true);
    insert(1111, f);
    f.antialiasing = true;

}
var evil:Bool = false;
function phase3Vis(){
    phase = 3;
    defaultCamZoom = 1.75;
    //black.alpha = 0.1;
    for (i in scaryBG) i.visible = false;
    p3Video.visible = true;
    for (i in thirdBG) i.visible = true;

    remove(boyfriend, true);
    insert(99, boyfriend);
    remove(dad, true);
    insert(99, dad);
    remove(iconP2);
    insert(99, iconP2);
    for (e in strumLines.members[0]) {
        e.alpha = 0;
      }
}

function onPostStrumCreation(event:StrumCreationEvent){
    if(phase == 3){
    for (i in [0]) {
        for(babyArrow in strumLines.members[i]){
            babyArrow.alpha = 0;
        }
    }
    }
}

function update(elapsed:Float){
    healthBarStitch.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - 7;

    if(phase == 3){
        for (note in cpu.notes) note.alpha = 0;

    for (e in strumLines.members[0]) {
        e.alpha = 0;
  }
  
}
  if(evil){
  itime+=elapsed;
  heatShader.iTime = itime;
  }
}

function setZoomGame(zoom:Int){
    defaultCamZoom = zoom;
}
function camGameZoomLerp(lerp:Float){
    camGameZoomLerp = lerp;
}

function addPhase1() {
    addObject('whatsupthesky',0.825,[0.4,0.4],'xy',[-100,0],false,1);

    addObject1('biggerbackrocks','bgFiles',0.825,[0.5,0.5],'xy',[0,0],false,1,12);
    
    addObject1('backrocks','bgFiles',0.825,[0.5,0.5],'xy',[-50,0],false,1,12);

    addObject1('agua','waterfall',0.825,[0.5,0.5],'xy',[0,0],false,1,12);

    addObject1('mmmpalms','bgFiles',0.825,[0.85,0.85],'xy',[0,0],false,1,12);

    addObject1('ground','bgFiles',0.825,[1,1],'x',[0,500],false,1,12);
    introAnim = new FlxSprite(-22,362);
    introAnim.frames = Paths.getSparrowAtlas('stages/obituary/p1/Sonic_Turn');
    introAnim.antialiasing = true;
    introAnim.animation.addByPrefix('intro', 'intro', 24, false);
    introAnim.animation.finishCallback = function (n:String) {
        dad.visible = true;
        introAnim.visible = false;
    }
    add(introAnim);

    addObject1('frontobjects','bgFiles',1,[1.25,1.25],'x',[330,100],true,1,12);
}

function addPhase2() {
    //video sky for optimize
    video = new FlxVideoSprite();
	video.load(Assets.getPath(Paths.video('fire')), [':input-repeat=65535']);
    video.camera = camGame;
    video.play();
    add(video);
    video.scale.set(2,2);
    video.scrollFactor.set(0.5, 0.5);
    video.y += 100;
    video.visible = false;
    addObject1('mountains','p1/bgFiles',0.825,[0.5,0.425],'xy',[0,-100],false,2,12);

    addObject1('water','p1/bgFiles2',0.825,[0.5,0.5],'xy',[0,-95],false,2,12);

    addObject1('sun','p1/bgFiles3',0.875,[0.5,0.5],'xy',[0,-380],false,2,12);

    addObject1('frontmountains','p1/bgFiles',0.875,[0.5,0.5],'xy',[0,75],false,2,12);

    addObject1('ground','p1/bgFiles',0.875,[1,1],'x',[0,500],false,2,12);

    addObject1('plants','p1/bgFiles',0.875,[1,1],'xy',[-50,225],false,2,12);

    addObject1('fellas1','p1/bgFiles',0.875,[1,1],'x',[0,650],false,2,12);

    addObject1('fellas2','p1/bgFiles',0.875,[1,1],'x',[0,650],true,2,12);

    var treeOffset:Array<Float> = [55,-49];

    addObject1('trees','p1/bgFiles',0.875,[1,1],'xy',[-50 + treeOffset[0],200 + treeOffset[1]],false,2,12);

        var birdsAnim = new FlxSprite();
        birdsAnim.frames = Paths.getSparrowAtlas('stages/obituary/p1/birds1');
        birdsAnim.animation.addByPrefix('i', 'birds', 12, true);
        birdsAnim.animation.play('i');
        setScale(birdsAnim,0.765);
        birdsAnim.screenCenter();
        birdsAnim.y += 30 + treeOffset[1];
        birdsAnim.x += -55+ treeOffset[0];
        birdsAnim.antialiasing = true;
        add(birdsAnim);
        scaryBG.push(birdsAnim);

    kickingAnim = new FlxSprite(-160,275);
    kickingAnim.frames = Paths.getSparrowAtlas('stages/obituary/p1/X_Kick');
    kickingAnim.antialiasing = true;
    kickingAnim.animation.addByIndices('kick', 'kickx', [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22], "", 24, false);
    kickingAnim.animation.addByIndices('laugh', 'kickx', [21,22,23,24,25], "", 24, false);
    kickingAnim.animation.addByIndices('return', 'kickx', [26,27], "", 24, false);
    setScale(kickingAnim,0.9);
    insert(101, kickingAnim);
    kickingAnim.visible = false;

    kickingAnim.animation.finishCallback = function (n:String) {
        if (n == 'return') kickingAnim.alpha = 0;
    }

    
    rabbithead = new FlxSprite(320,515);
    rabbithead.frames = Paths.getSparrowAtlas('stages/obituary/p1/Bunny_Kick');
    rabbithead.animation.addByPrefix('play','rabbit head',24,false);
    setScale(rabbithead,0.75);
    rabbithead.antialiasing = true;
    insert(155, rabbitHead);
    scaryBG.push(rabbithead);
}

function addPhase3() {
    var p3Offsets:Array<Float> = [100,100];

    p3Video = new FlxVideoSprite();
	p3Video.load(Assets.getPath(Paths.video('makeaGif')), [':input-repeat=65535']);
    p3Video.camera = camGame;
    p3Video.play();
    p3Video.scale.set(2,2.5);
    p3Video.y += -150;
    p3Video.x += 100;
    add(p3Video);
    p3Video.visible = false;
    addObject1('henges3','p2/bgFiles',0.825,[0.8,0.8],'xy',[-50+p3Offsets[0],-120+p3Offsets[1]],false,3,12);

        addObject1('Smoke1','p2/smoke',0.825,[0.7,0.7],'0',[-275,-150],false,3,24);

        addObject1('Smoke2','p2/smoke',0.825,[0.7,0.7],'0',[1000,-125],false,3,24);


    var firebgbottom = new FlxSprite();
    generateGraphic(firebgbottom,3813,767,0xFFF4260A);
    firebgbottom.scrollFactor.set(0.8,0.8);
    firebgbottom.screenCenter();
    add(firebgbottom);
    thirdBG.push(firebgbottom);

    var firebgbottomL = new FlxSprite();
    generateGraphic(firebgbottomL,3813,767,0xFFF4260A);
    firebgbottomL.scrollFactor.set(0.8,0.8);
    firebgbottomL.screenCenter();
    graphicSize(firebgbottomL,1000,767);
    firebgbottomL.x += 500;
    add(firebgbottomL);
    thirdBG.push(firebgbottomL);

    var fireBG = new FlxSprite();
    fireBG.frames = Paths.getSparrowAtlas('stages/obituary/p2/FireBG');
    fireBG.animation.addByPrefix('i','FIRE instancia 1',24);
    fireBG.animation.play('i');
    setScale(fireBG,0.825);
    fireBG.screenCenter();
    fireBG.scrollFactor.set(0.8,0.8);
    fireBG.y += -50;
    add(fireBG);
    thirdBG.push(fireBG);

    firebgbottom.y = fireBG.y + fireBG.height - 250;
    firebgbottomL.y = fireBG.y + fireBG.height - 350;

    addObject1('pike1','p2/bgFiles',0.825,[0.9,0.9],'xy',[-610+p3Offsets[0],100+p3Offsets[1]],false,3,12);

    addObject1('pike2','p2/bgFiles',0.825,[0.9,0.9],'xy',[-210+p3Offsets[0],100+p3Offsets[1]],false,3,12);

    addObject1('pike3','p2/bgFiles',0.825,[0.9,0.9],'xy',[610+p3Offsets[0],0+p3Offsets[1]],false,3,12);

    addObject1('floor3','p2/bgFiles',0.825,[1,1],'xy',[-50+p3Offsets[0],200+p3Offsets[1]],false,3,12);

    addObject1('head','p2/bgFiles',0.825,[1,1],'xy',[-334+p3Offsets[0],535+p3Offsets[1]],true,3,12);

    addObject1('fgLEFT','p2/bgFiles',0.825,[1.25,1.25],'xy',[-1200+p3Offsets[0],700+p3Offsets[1]],true,3,12);

    addObject1('fgRIGHT','p2/bgFiles',0.825,[1.25,1.25],'xy',[1200+p3Offsets[0],600+p3Offsets[1]],true,3,12);

}

function graphicSize(sprite:FlxSprite, width:Float = 0, height:Float = 0, updatehitbox = true):FlxSprite
	{
		if (width <= 0 && height <= 0)
			return sprite;

		var newScaleX:Float = width / sprite.frameWidth;
		var newScaleY:Float = height / sprite.frameHeight;
		sprite.scale.set(newScaleX, newScaleY);

		if (width <= 0)
			sprite.scale.x = newScaleY;
		else if (height <= 0)
			sprite.scale.y = newScaleX;

		if (updatehitbox) sprite.updateHitbox();
		return sprite;
	}

//quick and dirty setup
function addObject(path:String,scale:Float,scrollF:Array<Float>,centerAxis:String,offsets:Array<Float>,isForeground:Bool,phase:Int) {
    var dir = 'obituary';
    if (phase == 1) dir = 'sunset'; 
    var f = new FlxSprite().loadGraphic(Paths.image('stages/' + dir + '/' + path));
    setScale(f,scale);
    f.scrollFactor.set(scrollF[0],scrollF[1]);
    if (centerAxis == 'x') f.screenCenter(FlxAxes.X);
    else if (centerAxis == 'y') f.screenCenter(FlxAxes.Y);
    else if (centerAxis == 'xy') f.screenCenter();
    f.x += offsets[0];
    f.y += offsets[1];
    if (isForeground) insert(666, f);
    else add(f);
    if (phase == 1) fakerBG.push(f);
    else if (phase == 2)scaryBG.push(f);
    else if (phase == 3)thirdBG.push(f);
    f.antialiasing = true;
}

function setScale(f:FlxSprite,scale:Float) {
    f.scale.set(scale,scale);
    f.updateHitbox();
    return;
}

function ow(){
    camZooming = true;

    boyfriend.stunned = true;
    boyfriend.playAnim('hurt');
    if (health > 1) {
        health = 1;
    }
    else {
        health = 0.1;
    }

    camHUD.shake(0.025,0.25);
    FlxG.sound.play(Paths.sound('ow'),0.5);
}

function addObject1(image:String,path:String,scale:Float,scrollF:Array<Float>,centerAxis:String,offsets:Array<Float>,isForeground:Bool,phase:Int,fps:Int) {
    var dir = 'obituary';
    if (phase == 1) dir = 'sunset'; 
    var f = new FlxSprite();
    f.frames = Paths.getSparrowAtlas('stages/' + dir + '/' + path);
    f.animation.addByPrefix('i',image,fps);
    f.animation.play('i');
    
    setScale(f,scale);
    f.scrollFactor.set(scrollF[0],scrollF[1]);
    if (centerAxis == 'x') f.screenCenter(FlxAxes.X);
    else if (centerAxis == 'y') f.screenCenter(FlxAxes.Y);
    else if (centerAxis == 'xy') f.screenCenter();
    f.x += offsets[0];
    f.y += offsets[1];
    if (isForeground) insert(999, f);
    else add(f);
    if (phase == 1) fakerBG.push(f);
    else if (phase == 2)scaryBG.push(f);
    else if (phase == 3)thirdBG.push(f);
    f.antialiasing = true;
}

function boringMe(){
        boring.visible = true;
        boringAlphabet.visible = true;
        boringAlphabet2.visible = true;
        black.visible = true;
}
function boringMeEnd(){
    boring.visible = false;
    boringAlphabet.visible = false;
    boringAlphabet2.visible = false;
    black.visible = false;
}

function letsPlay(value2:String){
    var val:Bool = value2 == 'true' ? true : false;
    black.visible = val;
    playText.visible = val;
    if (!val) {
        fadeIn();
        exeUI();
        }
    if(val){
        evilWindow();
    }
}

function exeUI(){
    healthBarOverlay.loadGraphic(Paths.image('ui/hpBar-exe'));
    healthBarStitch.loadGraphic(Paths.image('ui/stitchMiddleEXE'));
    healthBar.y = healthBar.y + 12;

    scoreTxt.y = scoreTxt.y + 5;
    missesTxt.y = scoreTxt.y;
    accuracyTxt.y = scoreTxt.y;
    remove(iconP1, true);
    remove(iconP2, true);
    insert(99, iconP2);
    insert(99, iconP1);

    /*sscore = new FlxSprite();
    sscore.loadImage('ui/score');
    sscore.camera = camHUD;
    add(sscore);
    cmboBreaks = new FlxSprite().loadImage('ui/cmbo');
    acc = new FlxSprite().loadImage('ui/acc');
    
    cmboNum = new FlxBitmapText(FlxBitmapFont.fromMonospace(Paths.image('ui/nums'),'0123456789:',numSpacing));
    cmboNum.text = '01';

    scoreNum = new FlxBitmapText(FlxBitmapFont.fromMonospace(Paths.image('ui/nums'),'0123456789:',numSpacing));
    scoreNum.text = '01';

    accNum = new FlxBitmapText(FlxBitmapFont.fromMonospace(Paths.image('ui/ratings'),'xsabcde:',new FlxPoint(18,19)));
    accNum.text = 'x';

    for (i in [cmboBreaks,cmboNum,score,scoreNum,acc,accNum]) {i.setScale(2); i.y = scoreY + 25;}
    accNum.centerOnSprite(acc,Y);*/
}

function fadeIn(){
    for(i in fakerBG){
        i.visible = false;
        FlxTween.color(i, 0.1, 0xFF606060, 0xFF000000, {ease: FlxEase.quadInOut});
    }
    for(i in scaryBG){
        i.visible = true;                    
    }

    defaultCamZoom = 0.65;
    camGame.zoom = 0.65;
    //FlxTween.tween(game, {barSongLength: PlayState.instance.songLength}, 3, {ease: FlxEase.quadInOut});
    camHUD.alpha = 1;
    // if (atweenIthinklol != null) atweenIthinklol.cancel();
    FlxTween.tween(camHUD, {alpha: 1}, 0.00001, {ease: FlxEase.quadOut});
}

function kick(){
        dad.alpha = 0.00001; //cam cant move if no dad
        kickingAnim.visible = true;
        kickingAnim.animation.play('kick');
        FlxG.sound.play(Paths.sound('windUpKick'),0.75);
        rabbithead.animation.play('play');
       
}
function Klaught(){
    kickingAnim.animation.play('laugh',true);
}
function Kend(){
        rabbithead.visible = false;
        kickingAnim.animation.play('return');
        kickingAnim.animation.finishCallback = function (n:String) {
            kickingAnim.visible = false;
            dad.alpha = 1;
        }
}

function imHungry(){
    camZooming = true;

    //FlxG.camera.zoom = 0.65;
    //defaultCamZoom = 0.65;
    if(introAnim.visible) introAnim.visible = false;
    if (!dad.visible) dad.visible = true; //just cause i skip time alot
    new FlxTimer().start(0.1, Void -> {
        for(i in fakerBG){
            i.color = 0xFFFFFFFF;
            i.alpha = 1;
            FlxTween.color(i, 0.75, 0xFFFFFFFF, 0xFF464646, {ease: FlxEase.quadInOut});
        }
        defaultCamZoom = 0.8;

    });
}

function toBlack(){
    black.visible = true;
    black.alpha = 1;
    scarystatic();
}
function scarystatic(){
    scarystatic.visible = true;
    scarystatic.alpha = FlxG.random.float(0.125, 1.0);
    new FlxTimer().start(0.25, function(){
        scarystatic.visible = false;
    });
}

function onNoteHit(event){
    if (event.note.noteType == "Alt Animation")
        event.animSuffix = "-alt"; //YOOOOOOOOO
    if (event.note.noteType == "No Animation") event.animSuffix = "-the-sexy-alt"; //2nd best line ever i think idk
} 



function zoomOut(){
    camZooming = false;
    defaultCamZoom = 1.75;
    FlxTween.tween(FlxG.camera, {zoom: 0.65}, 6, {ease: FlxEase.quadOut, onComplete: function(v:FlxTween){
        defaultCamZoom = 0.65;
    }});
    FlxTween.tween(black, {alpha: 0}, 6, {ease: FlxEase.quadInOut, onComplete: function(v:FlxTween){
        black.visible = false;
    }});

    for(i in scaryBG) i.visible = false;
    for(i in thirdBG) i.visible = true;
    for(s in strumLines){
        for(note in cpuStrums.members)
            {
              FlxTween.tween(note, {alpha: 0}, 0.01);
            }
    }
}
function evil(){
    evil = true;
    camHUD.flash(0xFFFF0000, 0.5);
    camGame.addShader(heatShader);
    fuckassOverlay.visible = true;
}
function endZoom(){
                camOther.zoom = 2.2;
                monitor.visible = true;
                camGame.removeShader(heatShader);
                camGame.addShader(crtShader);

                for (i in blackBars) i.visible = true;

                FlxTween.tween(camHUD, {alpha: 0},0.3, {ease: FlxEase.sineOut});
                FlxTween.tween(camOther, {zoom: 1},1.25, {ease: FlxEase.sineOut});
                camZooming = false;
                camFollow.x = dad.getGraphicMidpoint().x + ((boyfriend.getGraphicMidpoint().x - dad.getGraphicMidpoint().x)/2);
                camZoomingInterval = 11111111;
                FlxTween.cancelTweensOf(camGame);
                FlxTween.tween(FlxG.camera, {zoom: 0.36}, 1.25, {ease: FlxEase.sineOut, onComplete: function(v:FlxTween){
                    camZooming = false;
                    defaultCamZoom = 0.36;
                    trace(camGame.zoom);                
                }});
                camZooming = false;
                FlxTween.tween(fuckassOverlay, {alpha: 0},0.5, {ease: FlxEase.sineOut});

                FlxTween.num(0, 5.0, 3.5, {ease: FlxEase.sineOut, update: function(v:FlxTween){
                    crtShader.data.warp.value = [v.value];
                }});
}
function end(){
    monitor.animation.play('off');
    black.alpha = 1;
    black.visible = true;
    FlxTween.tween(braindeadBF, {alpha: 1},0.4, {startDelay: 0.4});
    FlxTween.tween(braindeadBF, {alpha: 0},0.4, {startDelay: 5});
}

function fadeinreal(){
    black.visible = true;
    black.alpha = 0;
    FlxTween.tween(black, {alpha: 1}, 2.5, {ease: FlxEase.quadInOut}); 
}