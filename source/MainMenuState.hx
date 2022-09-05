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
	var menuItemGroup:FlxTypedGroup<MenuButton>;

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

		var white = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(white);

		backdrop = new FlxBackdrop('assets/images/menu/backdrop.png', 1, 1, true, true);
		backdrop.alpha = 0.35;
		add(backdrop);

		var logo = new FlxSprite().loadGraphic('assets/images/menu/logo.png');
		logo.antialiasing = false;
		logo.screenCenter(X);
		logo.y -= logo.height;
		add(logo);
		FlxTween.tween(logo, {y: (FlxG.height / 2) - (logo.height * 2)}, 1, {ease: FlxEase.circOut});
		FlxTween.tween(logo.scale, {x: 1.25, y: 1.25}, 5, {ease: FlxEase.circInOut, type: PINGPONG});

		menuItemGroup = new FlxTypedGroup<MenuButton>();

		for (i in 0...menuItems.length)
		{
			var menuItem = new MenuButton(((FlxG.width / 2) - 250), (i * 160) + 600, menuItems[i]);
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

class MenuButton extends FlxSpriteGroup
{
	public var boxText:FlxText;

	override public function new(leX:Float = 0, leY:Float = 0, label:String)
	{
		super();

		var box = new FlxSprite(leX, leY).loadGraphic('assets/images/menu/box.png');
		add(box);

		boxText = new FlxText(leX, leY - 20, 0, label, 40);
		boxText.x += (250 - (boxText.width / 2));
		boxText.y += (80 - (boxText.height / 2));
		boxText.color = FlxColor.BLACK;
		add(boxText);
	}
}
