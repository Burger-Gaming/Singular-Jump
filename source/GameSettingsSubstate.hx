package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class GameSettingsSubstate extends FlxSubState
{
	var backdrop:FlxBackdrop;
	var testVar:Int = 95;
	var egg:FlxSprite;
	var cardArray:Array<Dynamic> = [
		// display name, description, ID
		['Flip X', 'Flip the screen horizontally!', 'flipScreenX'],
		['Flip Y', 'Flip the screen vertically!', 'flipScreenY'],
		['Void Mode', 'Lights out!', 'voidMode']
	];
	var curHover:Int = -1;
	var cardGroup:FlxTypedGroup<FlxSprite>;
	var descriptionText:FlxText;

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
		backdrop.scrollFactor.set();
		add(backdrop);

		egg = new FlxSprite().loadGraphic(GameTools.getImage('menu/difficulty/gameSettings/egGear'));
		egg.alpha = 0;
		egg.screenCenter(XY);
		egg.scrollFactor.set();
		add(egg);

		cardGroup = new FlxTypedGroup<FlxSprite>();

		for (i in 0...cardArray.length)
		{
			var card = new FlxSprite((i * 400) + 1024, 100).loadGraphic(GameTools.getImage('menu/difficulty/gameSettings/options/${cardArray[i][2]}'));
			card.scrollFactor.set();
			card.updateHitbox();
			cardGroup.add(card);

			switch (i)
			{
				case 0:
					if (FlxG.save.data.flipX)
						card.color = 0xFFFFFFFF;
					else
						card.color = 0xFF8B8B8B;
				case 1:
					if (FlxG.save.data.flipY)
						card.color = 0xFFFFFFFF;
					else
						card.color = 0xFF8B8B8B;
				case 2:
					if (FlxG.save.data.voidMode)
						card.color = 0xFFFFFFFF;
					else
						card.color = 0xFF8B8B8B;
			}
			FlxMouseEventManager.add(card, clickOption, null, function(s:FlxSprite)
			{
				curHover = i;
				trace('now hovering: ' + i);
				FlxG.sound.play(GameTools.getSound('scroll'));
			});
			FlxTween.tween(card, {x: (i * 400) + 20}, 0.75, {ease: FlxEase.circInOut});
		}

		descriptionText = new FlxText(0, 0, 0, 'Hover over a button to see a description!', 16);
		descriptionText.borderStyle = SHADOW;
		descriptionText.shadowOffset.set(2, 2);
		descriptionText.screenCenter(XY);
		descriptionText.alignment = CENTER;
		descriptionText.scrollFactor.set();
		add(descriptionText);

		add(cardGroup);

		// cardGroup.forEach(s -> FlxTween.tween(s, {x: }, 0.75, {ease: FlxEase.circInOut}));

		FlxTween.tween(backdrop, {alpha: 0.5}, 1, {ease: FlxEase.circInOut});
		FlxTween.tween(egg, {alpha: 0.75}, 1, {ease: FlxEase.circInOut});
	}

	function clickOption(s:FlxSprite):Void
	{
		FlxG.sound.play(GameTools.getSound('scroll'));
		switch (curHover)
		{
			case 0:
				FlxG.save.data.flipX = !FlxG.save.data.flipX;
				if (FlxG.save.data.flipX)
					cardGroup.members[curHover].color = 0xFFFFFFFF;
				else
					cardGroup.members[curHover].color = 0xFF8B8B8B;
			case 1:
				FlxG.save.data.flipY = !FlxG.save.data.flipY;
				if (FlxG.save.data.flipY)
					cardGroup.members[curHover].color = 0xFFFFFFFF;
				else
					cardGroup.members[curHover].color = 0xFF8B8B8B;
			case 2:
				FlxG.save.data.voidMode = !FlxG.save.data.voidMode;
				if (FlxG.save.data.voidMode)
					cardGroup.members[curHover].color = 0xFFFFFFFF;
				else
					cardGroup.members[curHover].color = 0xFF8B8B8B;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		egg.angle += 2.5;

		if (curHover != -1)
		{
			descriptionText.text = cardArray[curHover][0] + '\n' + cardArray[curHover][1];
			descriptionText.screenCenter(XY);
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxTween.tween(backdrop, {alpha: 0}, 0.5, {ease: FlxEase.circInOut});
			FlxTween.tween(egg, {alpha: 0}, 0.5, {ease: FlxEase.circInOut});
			FlxTween.tween(descriptionText, {alpha: 0}, 0.5, {ease: FlxEase.circInOut});
			cardGroup.forEach(s -> FlxTween.tween(s, {alpha: 0}, 0.5, {ease: FlxEase.circInOut}));
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				closeSubState();
				FlxG.switchState(new DifficultyMenu());
			});
		}
	}
}
