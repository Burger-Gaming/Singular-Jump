package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DifficultyMenu extends FlxState
{
	var difficultyArray:Array<Array<Dynamic>> = [['EASY', FlxColor.LIME], ['NORMAL', FlxColor.YELLOW], ['HARD', FlxColor.RED]];
	var difficultyDescription:Array<String> = [
		"- The pot does not rise up to increase difficulty.\n- Narrow range of platform spawning.\n- Your score won't save on this one.",
		"- The pot rises in difficulty.\n- Regular range of platform spawning.",
		"- Platforms will move at random speeds while the\npot rises in difficulty. \n- Widest range of platform spawning."
	];
	var yArray:Array<Float> = [200, 650, 1100];
	var camFollow:FlxObject;

	override function create()
	{
		super.create();

		var bg = new FlxSprite().loadGraphic(GameTools.getImage('menu/difficulty/back'));
		bg.scale.set(2, 2);
		bg.x += bg.width / 2;
		bg.y += bg.height / 2;
		bg.scrollFactor.set();
		bg.color = 0xFF6C6C6C;
		add(bg);

		for (i in 0...difficultyArray.length)
		{
			var card = new DifficultyCard(0, i * 450, difficultyArray[i][0], difficultyDescription[i], difficultyArray[i][1]);
			add(card);
		}

		camFollow = new FlxObject(300, yArray[FlxG.save.data.difficulty]);
		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.5);
	}

	override function update(elapsed:Float)
	{
		// camFollow.y = (450 * FlxG.save.data.difficulty);
		if (FlxG.keys.justPressed.DOWN)
			changeDiff(1);
		if (FlxG.keys.justPressed.UP)
			changeDiff(-1);
		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(new PlayState());
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new MainMenuState());
		if (FlxG.keys.justPressed.G)
			openSubState(new GameSettingsSubstate());
	}

	function changeDiff(change:Int)
	{
		FlxG.save.data.difficulty += change;
		if (FlxG.save.data.difficulty < 0)
			FlxG.save.data.difficulty = 2;
		if (FlxG.save.data.difficulty > 2)
			FlxG.save.data.difficulty = 0;
		FlxG.sound.play(GameTools.getSound('scroll'));
		camFollow.y = yArray[FlxG.save.data.difficulty];
	}
}

class DifficultyCard extends FlxSpriteGroup
{
	override public function new(leX:Float = 0, leY:Float = 0, diffName:String, diffDesc:String, diffColor:FlxColor)
	{
		super();

		var card = new FlxSprite(leX, leY).loadGraphic(GameTools.getImage('menu/difficulty/${diffName.toLowerCase()}'));
		card.antialiasing = false;
		add(card);

		var cardText:FlxText = new FlxText(leX + card.width + 20, leY + card.height / 2, 0, diffDesc, 16);
		cardText.color = diffColor;
		cardText.y -= cardText.height / 2;
		cardText.borderStyle = SHADOW;
		cardText.shadowOffset.set(2, 2);
		add(cardText);
	}
}
