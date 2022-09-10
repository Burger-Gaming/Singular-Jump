package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets.FlxShader;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameTools
{
	public static function setupGame()
	{
		if (FlxG.save.data.highScore == null)
			FlxG.save.data.highScore = 0;
		if (FlxG.save.data.difficulty == null)
			FlxG.save.data.difficulty = 1;
		if (FlxG.save.data.flipX == null)
			FlxG.save.data.flipX = false;
		if (FlxG.save.data.flipY == null)
			FlxG.save.data.flipY = false;
		if (FlxG.save.data.voidMode == null)
			FlxG.save.data.voidMode = false;
		FlxG.autoPause = false;
	}

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

class FlipXAxis extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        void main()
        {
                vec2 uv = vec2(1.0 - openfl_TextureCoordv.x, openfl_TextureCoordv.y);
                gl_FragColor = texture2D(bitmap, uv);
        }')
	public function new()
	{
		super();
	}
}

class FlipYAxis extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        void main()
        {
                vec2 uv = vec2(openfl_TextureCoordv.x, 1.0 - openfl_TextureCoordv.y);
                gl_FragColor = texture2D(bitmap, uv);
        }')
	public function new()
	{
		super();
	}
}
