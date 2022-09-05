package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DifficultyMenu extends FlxState
{
	var difficultyArray:Array<Array<Dynamic>> = [['EASY', FlxColor.LIME], ['NORMAL', FlxColor.YELLOW], ['HARD', FlxColor.RED]];
	var difficultyDescription:Array<String> = [
		"The pot does not rise up to increase difficulty.\nYour score won't save on this one.",
		"The pot rises in difficulty.",
		"Platforms will move at random speeds while the pot rises in difficulty."
	];

	override function create()
	{
		super.create();

        var bg = new FlxSprite().loadGraphic('assets/images/menu/difficulty/back.png');
        bg.scale.set(2, 2);
        add(bg);
	}
}

class DifficultyCard extends FlxSpriteGroup
{
	override public function new(leX:Float = 0, leY:Float = 0, diffName:String, diffDesc:String, diffColor:FlxColor)
	{
		super();

		var card = new FlxSprite(leX, leY).loadGraphic('assets/images/menu/difficulty/${diffName.toLowerCase()}.png');
		card.antialiasing = false;
		add(card);

		var cardText:FlxText = new FlxText(leX + card.width + 20, leY + card.height / 2, 0, diffDesc, 32);
		cardText.color = diffColor;
		cardText.borderStyle = SHADOW;
		cardText.shadowOffset.set(4, 4);
		add(cardText);
	}
}
