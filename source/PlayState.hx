package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var egg:FlxSprite;
	var levelBounds:FlxGroup;
	var jumping:Bool = false;
	var platformGroup:FlxGroup;
	var canJump:Bool;
	var potBack:FlxSprite;
	var potFront:FlxSprite;
	var gameScore:Int = 0;
	var updateScore:Bool = true;
	var isDead:Bool = false;

	override public function create()
	{
		super.create();
		// FlxG.camera.zoom = 4;

		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(bg);

		potBack = new FlxSprite().loadGraphic(GameTools.getImage('game/potBack'));
		potBack.antialiasing = false;
		potBack.scale.set(4, 4);
		potBack.y = 853;
		potBack.screenCenter(X);
		potBack.active = false;
		add(potBack);

		egg = new FlxSprite().loadGraphic(GameTools.getImage('game/egg'));
		egg.antialiasing = false;
		egg.scale.set(4, 4);
		egg.updateHitbox();
		egg.acceleration.y = 900 * 1.05;
		egg.maxVelocity.y = 900 * 1.5;
		egg.screenCenter(XY);
		add(egg);

		levelBounds = FlxCollision.createCameraWall(FlxG.camera, true, 1, true);
		add(levelBounds);

		levelBounds.members[3].destroy(); // destroy the floor so you can die

		platformGroup = new FlxGroup();
		add(platformGroup);

		potFront = new FlxSprite().loadGraphic(GameTools.getImage('game/potFront'));
		potFront.antialiasing = false;
		// potFront.scale.set(4, 4);
		potFront.y = 853 - 24;
		potFront.active = false;
		potFront.screenCenter(X);
		add(potFront);

		var startPlat = new FlxSprite().loadGraphic(GameTools.getImage('game/plat'));
		startPlat.antialiasing = false;
		startPlat.scale.set(4, 4);
		startPlat.updateHitbox();
		startPlat.screenCenter(X);
		startPlat.y = egg.y + egg.height;
		startPlat.immovable = true;
		platformGroup.add(startPlat);

		var scoreText:FlxText = new FlxText(5, 5, 0, "Score: " + gameScore, 32);
		scoreText.color = FlxColor.BLACK;
		add(scoreText);

		FlxTween.tween(startPlat, {y: FlxG.height}, 5, {
			onComplete: function(twn:FlxTween)
			{
				startPlat.destroy();
			}
		});

		new FlxTimer().start(2.5, function(tmr:FlxTimer)
		{
			if (updateScore)
			{
				var diffModifier:Float = 0;
				switch (FlxG.save.data.difficulty)
				{
					case 0:
						diffModifier = 150;
					case 1:
						diffModifier = 75;
					case 2:
						diffModifier = 0;
				}

				var plat = new FlxSprite().loadGraphic(GameTools.getImage('game/plat'));
				plat.antialiasing = false;
				plat.scale.set(4, 4);
				plat.updateHitbox();
				plat.x = FlxG.random.float(20 + diffModifier, FlxG.width - plat.width - 20 - diffModifier);
				plat.y -= plat.height;
				plat.immovable = true;
				platformGroup.add(plat);

				var tweenTime:Float = 4.5;
				if (FlxG.save.data.difficulty == 2)
				{
					tweenTime = FlxG.random.float(3.75, 5.25);
				}

				FlxTween.tween(plat, {y: FlxG.height}, tweenTime, {
					onComplete: function(twn:FlxTween)
					{
						plat.destroy();
					}
				});
			}
		}, 0);

		new FlxTimer().start(50, function(tmr:FlxTimer)
		{
			if (potFront.y >= 0 && updateScore && FlxG.save.data.difficulty >= 1)
			{
				FlxTween.tween(potFront, {y: potFront.y - 100}, 2, {ease: FlxEase.sineInOut});
				FlxTween.tween(potBack, {y: potBack.y - 100}, 2, {ease: FlxEase.sineInOut});
			}
		}, 0);

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			if (updateScore)
			{
				gameScore++;
				scoreText.text = 'Score: ' + gameScore;
			}
		}, 0);
	}

	var jumpTimer:Float = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(egg, levelBounds);
		FlxG.collide(egg, platformGroup);

		var jumpPressed = FlxG.keys.justPressed.UP;
		var left = FlxG.keys.pressed.LEFT;
		var right = FlxG.keys.pressed.RIGHT;

		if (FlxG.keys.pressed.RIGHT)
		{
			egg.velocity.x = 300;
		}
		else if (FlxG.keys.pressed.LEFT)
		{
			egg.velocity.x = -300;
		}
		else
		{
			egg.velocity.x = 0;
		}

		if (jumpTimer >= 0 && jumpPressed && !jumping && canJump)
		{
			canJump = false;
			egg.velocity.y = -900;
		}

		if (egg.isTouching(FLOOR))
		{
			canJump = true;
		}
		if (egg.y >= FlxG.height && !isDead)
		{
			#if !debug
			updateScore = false;
			isDead = true;
			FlxG.sound.play(GameTools.getSound('death'));
			FlxG.camera.shake(0.05, 0.75, function()
			{
				new FlxTimer().start(0.25, function(tmr:FlxTimer)
				{
					if (gameScore > FlxG.save.data.highScore && FlxG.save.data.difficulty <= 1)
						FlxG.save.data.highScore = gameScore;
					openSubState(new DeathState());
				});
			});
			#end
		}
	}
}
