package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameTools
{
	public static function getImage(key:String)
	{
		return 'assets/images/${key}.png';
	}

	public static function getSound(key:String)
	{
		return 'assets/sounds/${key}.wav';
	}
}

class MenuButton extends FlxSpriteGroup
{
	public var boxText:FlxText;

	override public function new(leX:Float = 0, leY:Float = 0, label:String)
	{
		super();

		var box = new FlxSprite(leX, leY).loadGraphic(GameTools.getImage('menu/box'));
		add(box);

		boxText = new FlxText(leX, leY - 20, 0, label, 40);
		boxText.x += (250 - (boxText.width / 2));
		boxText.y += (80 - (boxText.height / 2));
		boxText.color = FlxColor.BLACK;
		add(boxText);
	}
}
