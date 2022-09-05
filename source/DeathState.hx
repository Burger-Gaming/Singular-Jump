package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class DeathState extends FlxSubState
{
	public function new()
	{
		super(0x74000000);
	}

	override function create()
	{
		super.create();
		var deadText = new FlxText(0, 0, 0, "You died!\nPress ENTER to restart.\nPress ESCAPE to exit.\nHigh score: " + FlxG.save.data.highScore, 64);
		deadText.alignment = CENTER;
		deadText.screenCenter(XY);
		add(deadText);

		if (FlxG.save.data.difficulty == 0)
		{
			deadText.text += '\n High Scores will not\n be saved.';
			deadText.screenCenter(XY);
		}
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			closeSubState();
			FlxG.switchState(new PlayState());
		}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			closeSubState();
			FlxG.switchState(new TitleState());
		}
	}
}
