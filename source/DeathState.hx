package;

import MainMenuState.MenuButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class DeathState extends FlxSubState
{
	var deathArray:Array<String> = ['Restart', 'Exit'];
	var coolMenuGroup:FlxTypedGroup<MenuButton>;
	var curSelected:Int = 0;

	public function new()
	{
		super(0x74000000);
	}

	override function create()
	{
		super.create();
		var deadSprite = new FlxSprite(0, 50).loadGraphic(GameTools.getImage('game/death/died'));
		deadSprite.scale.set(2, 2);
		deadSprite.y += deadSprite.height / 2;
		deadSprite.screenCenter(X);
		add(deadSprite);

		var deadText = new FlxText(0, 0, 0, "High score: " + FlxG.save.data.highScore, 32);
		deadText.alignment = CENTER;
		deadText.screenCenter(XY);
		deadText.y -= 200;
		add(deadText);

		if (FlxG.save.data.difficulty == 0)
		{
			deadText.text += '\nHigh Scores will not be saved\nsince you are on Easy difficulty.';
			deadText.screenCenter(XY);
			deadText.y -= 200;
		}

		coolMenuGroup = new FlxTypedGroup<MenuButton>();

		for (i in 0...deathArray.length)
		{
			var item = new MenuButton(((FlxG.width / 2) - 250), (i * 160) + 600, deathArray[i]);
			coolMenuGroup.add(item);
		}

		add(coolMenuGroup);
		changeSelection();
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		FlxG.sound.play(GameTools.getSound('scroll'));
		if (curSelected < 0)
			curSelected = coolMenuGroup.length - 1;
		if (curSelected >= coolMenuGroup.length)
			curSelected = 0;
		for (i in 0...coolMenuGroup.members.length)
		{
			if (i == curSelected)
				coolMenuGroup.members[i].boxText.color = 0xFFFF6600;
			else
				coolMenuGroup.members[i].boxText.color = 0xFF000000;
		}
	}

	function accept()
	{
		switch (deathArray[curSelected])
		{
			case 'Restart':
				closeSubState();
				FlxG.switchState(new PlayState());
			case 'Exit':
				closeSubState();
				FlxG.switchState(new DifficultyMenu());
		}
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.UP)
			changeSelection(1);
		if (FlxG.keys.justPressed.DOWN)
			changeSelection(-1);
		if (FlxG.keys.justPressed.ENTER)
			accept();
	}
}
