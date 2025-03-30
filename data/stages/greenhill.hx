function create(){
	createUI();

	/*var greenHillSky:FunkinSprite = new FunkinSprite('stages/bg-greenhill/Sky', -485, -600, 0.0, 0.0);
    greenHillSky.setGraphicSize(Std.int(greenHillSky.width * 2.0));
    greenHillSky.updateHitbox();
    add(greenHillSky);

    var greenHillClouds:FunkinSprite = new FunkinSprite('stages/bg-greenhill/Clouds', -607, -335, 0.05, 0.05);
    greenHillClouds.setGraphicSize(Std.int(greenHillClouds.width * 2.0));
    greenHillClouds.updateHitbox();
    add(greenHillClouds);

    var greenHillMountians:FunkinSprite = new FunkinSprite('stages/bg-greenhill/Moutians', -589, -190, 0.10, 0.10);
    greenHillMountians.setGraphicSize(Std.int(greenHillMountians.width * 1.75));
    greenHillMountians.updateHitbox();
    add(greenHillMountians);

    var greenHillWater:FunkinSprite = new FunkinSprite('stages/bg-greenhill/Water', -633, 235, 0.2, 0.2);
    greenHillWater.setGraphicSize(Std.int(greenHillWater.width * 2.0));
    greenHillWater.updateHitbox();
    add(greenHillWater);

    var greenhillLand:FunkinSprite = new FunkinSprite('stages/bg-greenhill/Ground', -1048, -200, 1, 1);
    greenhillLand.setGraphicSize(Std.int(greenhillLand.width * 1.75));
    greenhillLand.updateHitbox();
    add(greenhillLand);

    // var greenhillRings = new FunkinSprite('bg-greenhill/rings', -575, 280, 1, 1);
    var greenhillRings = new FlxSprite(-575, 280);
    greenhillRings.frames = Paths.getSparrowAtlas('stages/bg-greenhill/rings');
    greenhillRings.animation.addByPrefix('idle ring', 'idle ring', 12, true);
    greenhillRings.animation.play('idle ring', true);
    greenhillRings.setGraphicSize(Std.int(greenhillRings.width * 0.875));
    greenhillRings.updateHitbox();
    add(greenhillRings);

    var greenHillRocks:FunkinSprite = new FunkinSprite('stages/bg-greenhill/Foreground', -1029, 225, 1.25, 1.25);
    greenHillRocks.setGraphicSize(Std.int(greenHillRocks.width * 2.5));
    greenHillRocks.updateHitbox();
    foreground.add(greenHillRocks);*/
}
function sonicFNFDies(){
	dad.visible = false;
	remove(dad, true);
}
function postCreate(){
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
    insert(100, scoreTxt);
    insert(100, missesTxt);
    insert(100, accuracyTxt);
}

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