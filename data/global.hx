import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import funkin.options.Options;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.CodenameBuildField;
import openfl.text.TextFormat;
import funkin.backend.system.macros.GitCommitMacro;
static var redirectStates:Map<FlxState, String> = [
    TitleState => "Custom/Title",
];

function update(elapsed) {
    if (FlxG.keys.justPressed.F6)
        NativeAPI.allocConsole();
    if (FlxG.keys.justPressed.F5)
        FlxG.resetState();
    if (FlxG.keys.justPressed.F7)
        FlxG.switchState(new TitleState());
    if (FlxG.keys.justPressed.F8)
        FlxG.switchState(new MainMenuState());
}
	function postStateSwitch(){
		if(!FlxG.save.data.legacyReveal){
		var windowName = "Friday Night Funkin': Rodentrap";
        if (FlxG.random.bool(0.7) && !legacyReveal) windowName = 'SonicEpicEdition (SEE)';
		WindowUtils.winTitle = windowName;
		window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('icon64'))));
        Framerate.codenameBuildField.text = 'Codename Engine '+ Main.releaseCycle + '\nCommit' + GitCommitMacro.commitNumber + ' (' + GitCommitMacro.commitHash + ')' + '\nRodentRap - CNE Port';

		}
		else{
			var windowName = "Sonic Legacy";
			WindowUtils.winTitle = windowName;
			window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('iconEXE'))));
            Framerate.codenameBuildField.text = 'Codename Engine '+ Main.releaseCycle + '\nCommit ' + GitCommitMacro.commitNumber + ' (' + GitCommitMacro.commitHash + ')' + '\nSonic Legacy - CNE Port';

		}

	}
    function preStateSwitch() {


        for (redirectState in redirectStates.keys())
            if (FlxG.game._requestedState is redirectState)
                FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
    }

	FlxG.save.data.legacyReveal ??= false;