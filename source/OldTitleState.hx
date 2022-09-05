package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OldTitleState extends FlxState
{
	var difficultyText:FlxText;
	var difficultyArray:Array<Array<Dynamic>> = [['EASY', FlxColor.LIME], ['NORMAL', FlxColor.YELLOW], ['HARD', FlxColor.RED]];

	override function create()
	{
		super.create();
		if (FlxG.save.data.highScore == null)
		{
			FlxG.save.data.highScore = 0;
		}
		if (FlxG.save.data.difficulty == null)
		{
			FlxG.save.data.difficulty = 1;
		}

		FlxG.autoPause = false;

		var titleText = new FlxText(0, 0, 0, "Welcome to Singular Jump!\nPress ENTER to start.\nPress LEFT & RIGHT to change\nthe difficulty.", 32);
		titleText.alignment = CENTER;
		titleText.screenCenter(XY);
		titleText.y -= 150;
		add(titleText);

		difficultyText = new FlxText(0, 0, 0, "Difficulty: " + difficultyArray[FlxG.save.data.difficulty][0], 32);
		difficultyText.alignment = CENTER;
		difficultyText.screenCenter(XY);
		difficultyText.y += 150;
		difficultyText.color = difficultyArray[FlxG.save.data.difficulty][1];
		add(difficultyText);
	}

	function changeDiff(change:Int)
	{
		FlxG.save.data.difficulty += change;
		if (FlxG.save.data.difficulty < 0)
			FlxG.save.data.difficulty = 2;
		if (FlxG.save.data.difficulty > 2)
			FlxG.save.data.difficulty = 0;
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.switchState(new PlayState());
		}
		difficultyText.text = "Difficulty: " + difficultyArray[FlxG.save.data.difficulty][0];
		difficultyText.color = difficultyArray[FlxG.save.data.difficulty][1];
		difficultyText.screenCenter(XY);

		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);
		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
	}
}
