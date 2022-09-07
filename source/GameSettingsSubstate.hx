package;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;

class GameSettingsSubstate extends FlxSubState
{
	var backdrop:FlxBackdrop;
	var testVar:Int = 95;

	override public function new()
	{
		super();
	}

	override function create()
	{
		super.create();

		backdrop = new FlxBackdrop(GameTools.getImage('menu/difficulty/gameSettings/settingBackdrop'), 1, 1, true, true);
		backdrop.velocity.set(50, 50);
		backdrop.alpha = 0;
		add(backdrop);

		var egg = new FlxSprite().loadGraphic(GameTools.getImage('menu/difficulty/gameSettings/egGear'));
		egg.alpha = 0;
		egg.angularVelocity = 10;
		add(egg);
	}
}
