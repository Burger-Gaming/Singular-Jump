package;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;

class GameSettingsSubstate extends FlxSubState
{
	var backdrop:FlxBackdrop;

	override public function new()
	{
		super(0x00000000);
	}

	override function create()
	{
		super.create();

		backdrop = new FlxBackdrop(GameTools.getImage('menu/difficulty/gameSettings/settingsBackdrop'), 1, 1, true, true);
		backdrop.velocity.set(50, 50);
		backdrop.alpha = 0;
		add(backdrop);

		var egg = new FlxSprite().loadGraphic(GameTools.getImage('menu/difficulty/gameSettings/egGear'));
		egg.alpha = 0;
		egg.angularVelocity = 10;
		add(egg);
	}
}
