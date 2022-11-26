package;

import DifficultyMenu.DifficultyCard;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class MainMenuState extends FlxState
{
	var backdrop:FlxBackdrop;
	var menuItems:Array<String> = ['Start Game' #if desktop, 'Exit' #end];
	var curSelected:Int = 0;
	var menuItemGroup:FlxTypedGroup<GameTools.MenuButton>;

	override function create()
	{
		super.create();

		GameTools.setupGame();

		var white = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(white);

		backdrop = new FlxBackdrop(GameTools.getImage('menu/backdrop'), 1, 1, true, true);
		backdrop.alpha = 0.55;
		add(backdrop);

		var logo = new FlxSprite().loadGraphic(GameTools.getImage('menu/logo'));
		logo.antialiasing = true;
		logo.screenCenter(X);
		logo.y -= logo.height;
		add(logo);
		FlxTween.tween(logo, {y: (FlxG.height / 2) - (logo.height * 2)}, 1, {ease: FlxEase.circOut});
		FlxTween.tween(logo.scale, {x: 1.25, y: 1.25}, 5, {ease: FlxEase.circInOut, type: PINGPONG});

		menuItemGroup = new FlxTypedGroup<GameTools.MenuButton>();

		for (i in 0...menuItems.length)
		{
			var menuItem = new GameTools.MenuButton(((FlxG.width / 2) - 250), (i * 160) + 600, menuItems[i]);
			menuItemGroup.add(menuItem);
		}
		add(menuItemGroup);
		changeSelection();
	}

	override function update(elapsed:Float)
	{
		backdrop.x++;
		backdrop.y++;
		if (FlxG.keys.justPressed.UP)
			changeSelection(1);
		if (FlxG.keys.justPressed.DOWN)
			changeSelection(-1);
		if (FlxG.keys.justPressed.ENTER)
			checkOption(curSelected);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(GameTools.getSound('scroll'));
		curSelected += change;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;
		for (i in 0...menuItemGroup.members.length)
		{
			if (i == curSelected)
				menuItemGroup.members[i].boxText.color = 0xFFFF6600;
			else
				menuItemGroup.members[i].boxText.color = 0xFF000000;
		}
	}

	function checkOption(option:Int = 0)
	{
		switch (option)
		{
			case 0:
				FlxG.switchState(new DifficultyMenu());
			case 1:
				#if desktop
				Sys.exit(0);
				#end
		}
	}
}
