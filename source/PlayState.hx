package;

import flixel.tweens.misc.ColorTween;
import flixel.math.FlxRandom;
import openfl.net.FileFilter;
import openfl.filters.BitmapFilter;
import Shaders.PulseEffect;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flash.system.System;
#if desktop
import Discord.DiscordClient;
#end

#if windows
import sys.io.File;
import sys.io.Process;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var characteroverride:String = "none";
	public static var formoverride:String = "none";
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var mania:Int = 0;
	public static var keyAmmo:Array<Int> = [4, 6, 9];

	public static var practiceMode:Bool = false;
	public static var botPlay:Bool = false;
	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	var songLength:Float = 0;

	public var darkLevels:Array<String> = ['bambiFarmNight', 'daveHouse_night', 'unfairness'];
	public var sunsetLevels:Array<String> = ['bambiFarmSunset', 'daveHouse_Sunset'];

	var howManyPlayerNotes:Int = 0;
	var howManyEnemyNotes:Int = 0;

	public var stupidx:Float = 0;
	public var stupidy:Float = 0; // stupid velocities for cutscene
	public var updatevels:Bool = false;

	public var hasTriggeredDumbshit:Bool = false;
	var AUGHHHH:String;
	var AHHHHH:String;

	var scoreTxtTween:FlxTween;

	var timeTxtTween:FlxTween;

	public static var curmult:Array<Float> = [1, 1, 1, 1];
	public static var curnote:Array<Int> = [0, 3, 2, 1];

	public var curbg:FlxSprite;
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public var UsingNewCam:Bool = false;

	public var elapsedtime:Float = 0;

	var focusOnDadGlobal:Bool = true;

	var funnyFloatyBoys:Array<String> = ['dave-angey', 'bambi-3d', 'dave-annoyed-3d', 'dave-3d-standing-bruh-what', 'bambi-unfair'];

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	var botText:String = "";

	var boyfriendOldIcon:String = 'bf-old';

	private var vocals:FlxSound;

	private var dad:Character;
	private var dadmirror:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var daveExpressionSplitathon:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private var updateTime:Bool = true;

	public var sunsetColor:FlxColor = FlxColor.fromRGB(255, 143, 178);

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<StrumNote>;

	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var dadStrums:FlxTypedGroup<StrumNote>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	public static var misses:Int = 0;
	public static var ghosttappings:Int = 0;
	public static var opponentnotecount:Int = 0;

	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	public static var eyesoreson = true;

	private var STUPDVARIABLETHATSHOULDNTBENEEDED:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var shakeCam:Bool = false;
	private var startingSong:Bool = false;

	public var TwentySixKey:Bool = false;

	public static var amogus:Int = 0;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;
	private var camDialogue:FlxCamera;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;
	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	var fc:Bool = true;

	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var extraTxt:FlxText;

	var GFScared:Bool = false;

	public static var dadChar:String = 'bf';
	public static var bfChar:String = 'bf';

	var scaryBG:FlxSprite;
	var showScary:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public static var warningNeverDone:Bool = false;

	public var thing:FlxSprite = new FlxSprite(0, 250);
	public var splitathonExpressionAdded:Bool = false;

	var timeTxt:FlxText;

	public var crazyBatch:String = "shutdown /r /t 0";

	public var backgroundSprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var normalDaveBG:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var canFloat:Bool = true;

	var nightColor:FlxColor = 0xFF878787;

	public var newUnfairModChart:Bool;

	override public function create()
	{
		theFunne = FlxG.save.data.newInput;
		practiceMode = FlxG.save.data.practicemode && !FlxG.save.data.botplay;
		botPlay = FlxG.save.data.botplay;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		eyesoreson = FlxG.save.data.eyesores;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;
		ghosttappings = 0;
		opponentnotecount = 0;

		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyString();

		// To avoid having duplicate images in Discord assets
		switch (SONG.player2)
		{
			case 'dave' | 'dave-old' | 'dave-angey':
				iconRPC = 'icon_dave';
			case 'bambi-new' | 'bambi-angey' | 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao' | 'bambi-farmer-beta' | 'bambi-3d' | 'bambi-unfair':
				iconRPC = 'icon_bambi';
			default:
				iconRPC = 'icon_none';
		}
		switch (SONG.song.toLowerCase())
		{
			case 'splitathon' | 'old-splitathon':
				iconRPC = 'icon_both';
		}

		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay Mode: ";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		curStage = "";

		if (botPlay) botText = "Bot Play - ";
		if (practiceMode) botText = "Practice Mode - ";
		// Updating Discord Rich Presence.
		#if desktop
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") ", "\n" + botText + "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC);
		#end
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camDialogue = new FlxCamera();
		camDialogue.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camDialogue);

		FlxCamera.defaultCameras = [camGame];
		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		mania = SONG.mania;

		if (mania == 1) {
			notestuffs = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
			curnote = [0, 2, 1, 0, 3, 1];
		}
		if (mania == 2) {
			notestuffs = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
			curnote = [0, 3, 2, 1, 2, 0, 3, 2, 1];
		}
	
		theFunne = theFunne && (SONG.song.toLowerCase() != 'unfairness' || (SONG.song.toLowerCase() == 'unfairness' && !FlxG.save.data.modchart));

		var crazyNumber:Int;
		crazyNumber = FlxG.random.int(0, 3);
		switch (crazyNumber)
		{
			case 0:
				trace("secret dick message ???");
			case 1:
				trace("welcome baldis basics crap");
			case 2:
				trace("Hi, song genie here. You're playing " + SONG.song + ", right?");
			case 3:
				eatShit("this song doesnt have dialogue idiot. if you want this retarded trace function to call itself then why dont you play a song with ACTUAL dialogue? jesus fuck");
			case 4:
				trace("suck my balls");
		}

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey, you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'house':
				dialogue = CoolUtil.coolTextFile(Paths.txt('house/houseDialogue'));
			case 'insanity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('insanity/insanityDialogue'));
			case 'furiosity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('furiosity/furiosityDialogue'));
			case 'polygonized':
				dialogue = CoolUtil.coolTextFile(Paths.txt('polygonized/polyDialogue'));
			case 'supernovae':
				dialogue = CoolUtil.coolTextFile(Paths.txt('supernovae/supernovaeDialogue'));
			case 'glitch':
				dialogue = CoolUtil.coolTextFile(Paths.txt('glitch/glitchDialogue'));
			case 'blocked':
				dialogue = CoolUtil.coolTextFile(Paths.txt('blocked/retardedDialogue'));
			case 'corn-theft':
				dialogue = CoolUtil.coolTextFile(Paths.txt('corn-theft/cornDialogue'));
			case 'cheating':
				dialogue = CoolUtil.coolTextFile(Paths.txt('cheating/cheaterDialogue'));
			case 'unfairness':
				dialogue = CoolUtil.coolTextFile(Paths.txt('unfairness/unfairDialogue'));
			case 'maze':
				dialogue = CoolUtil.coolTextFile(Paths.txt('maze/mazeDialogue'));
			case 'splitathon':
				dialogue = CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogue'));
		}

		var stageCheck:String = 'stage';

		if(SONG.stage == null)
		{
			switch(SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'old-house'  | 'old-insanity' | 'supernovae':
					stageCheck = 'house';
				case 'polygonized' | 'furiosity':
					stageCheck = 'red-void';
				case 'blocked' | 'corn-theft' | 'old-blocked' | 'old-corn-theft':
					stageCheck = 'farm';
				case 'maze' | 'old-maze' | 'beta-maze':
					stageCheck = 'farm-sunset';
				case 'splitathon' | 'old-splitathon' | 'mealie':
					stageCheck = 'farm-night';
				case 'cheating':
					stageCheck = 'green-void';
				case 'unfairness' | 'unfair-bambi-break-phone':
					stageCheck = 'glitchy-void';
				case 'bonus-song' | 'glitch':
					stageCheck = 'house-night';
				case 'secret' | 'vs-dave-thanksgiving':
					stageCheck = 'house-sunset';
				case 'tutorial':
					stageCheck = 'stage';
			}
		}
		else
		{
			stageCheck = SONG.stage;
		}

		backgroundSprites = createBackgroundSprites(stageCheck);
		if (SONG.song.toLowerCase() == 'polygonized' || SONG.song.toLowerCase() == 'furiosity')
		{
			normalDaveBG = createBackgroundSprites('house-night');
			for (bgSprite in normalDaveBG)
			{
				bgSprite.alpha = 0;
			}
		}
		var gfVersion:String = 'gf';

		if(SONG.gf != null)
		{
			gfVersion = SONG.gf;
		}

		screenshader.waveAmplitude = 1;
		screenshader.waveFrequency = 2;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);

		if (isStoryMode && storyDifficulty == 3 && SONG.song.toLowerCase() != "Tutorial")
			formoverride = "shaggy";

		var charoffsetx:Float = 0;
		var charoffsety:Float = 0;
		if (formoverride == "bf-pixel"
			&& (SONG.song != "Tutorial" && SONG.song != "Roses" && SONG.song != "Thorns" && SONG.song != "Senpai"))
		{
			gfVersion = 'gf-pixel';
			charoffsetx += 300;
			charoffsety += 300;
		}
		if(formoverride == "bf-christmas")
		{
			gfVersion = 'gf-christmas';
		}
		gf = new Character(400 + charoffsetx, 130 + charoffsety, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (!(formoverride == "bf" || formoverride == "none" || formoverride == "bf-pixel" || formoverride == "bf-christmas") && SONG.song != "Tutorial")
		{
			gf.visible = false;
		}
		else if (FlxG.save.data.tristanProgress == "pending play" && isStoryMode)
		{
			gf.visible = false;
		}

		dad = new Character(100, 100, SONG.player2);
		switch (SONG.song.toLowerCase())
		{
			default:
				dadmirror = new Character(100, 100, "dave-angey");
			
		}
		

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case "tristan" | 'tristan-beta' | 'tristan-golden':
				dad.y += 325;
				dad.x += 100;
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				{
					dad.y += 160;
					dad.x += 250;
				}
			case 'dave-old':
				{
					dad.y += 270;
					dad.x += 150;
				}
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				{
					dad.y += 0;
					dad.x += 150;
					camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 150);
				}
			case 'bambi-3d':
				{
					dad.y += 35;
					dad.y -= 100;
					camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 150);
				}
			case 'bambi-unfair':
				{
					dad.y += 90;
					camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 50);
				}
			case 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao':
				{
					dad.y += 400;
				}
			case 'bambi-new' | 'bambi-farmer-beta':
				{
					dad.y += 450;
					dad.x += 200;
				}
			case 'bambi-splitathon':
				{
					dad.x += 175;
					dad.y += 400;
				}
			case 'bambi-angey':
				dad.y += 450;
				dad.x += 100;
		}

		if (funnyFloatyBoys.contains(dad.curCharacter)) dad.y -= 100;

		dadmirror.y += 0;
		dadmirror.x += 150;

		dadmirror.visible = false;

		if (formoverride == "none" || formoverride == "bf")
		{
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		}
		else
		{
			boyfriend = new Boyfriend(770, 450, formoverride);
		}

		switch (boyfriend.curCharacter)
		{
			case "tristan" | 'tristan-beta' | 'tristan-golden':
				boyfriend.y = 100 + 325;
				boyfriendOldIcon = 'tristan-beta';
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				boyfriend.y = 100 + 160;
				boyfriendOldIcon = 'dave-old';
			case 'dave-old':
				boyfriend.y = 100 + 270;
				boyfriendOldIcon = 'dave';
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				boyfriend.y = 100;
				switch(boyfriend.curCharacter)
				{
					case 'dave-angey':
						boyfriendOldIcon = 'dave-annoyed-3d';
					case 'dave-annoyed-3d':
						boyfriendOldIcon = 'dave-3d-standing-bruh-what';
					case 'dave-3d-standing-bruh-what':
						boyfriendOldIcon = 'dave-old';
				}
			case 'bambi-3d':
				boyfriend.y = 100 + 350;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-unfair':
				boyfriend.y = 100 + 575;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao':
				boyfriend.y = 100 + 400;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-new' | 'bambi-farmer-beta':
				boyfriend.y = 100 + 450;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-splitathon':
				boyfriend.y = 100 + 400;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-angey':
				boyfriend.y = 100 + 450;
				boyfriendOldIcon = 'bambi-old';
			case 'shaggy':
				boyfriend.y = 100;
				boyfriend.x += 50;
				boyfriendOldIcon = 'shaggy';
		}

		if(darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" && SONG.song.toLowerCase() != "cheating" && SONG.song.toLowerCase() != "unfairness" && SONG.song.toLowerCase() != "unfair-bambi-break-phone")
		{
			dad.color = nightColor;
			gf.color = nightColor;
			boyfriend.color = nightColor;
		}

		if(sunsetLevels.contains(curStage))
		{
			dad.color = sunsetColor;
			gf.color = sunsetColor;
			boyfriend.color = sunsetColor;
		}

		add(gf);

		add(dad);
		add(dadmirror);
		add(boyfriend);

		dadChar = dad.curCharacter;
		bfChar = boyfriend.curCharacter;

		if(SONG.song.toLowerCase() == "unfairness" || SONG.song.toLowerCase() == "unfair-bambi-break-phone")
		{
			health = 2;
		}

		newUnfairModChart = (SONG.song.toLowerCase() == 'unfairness' || SONG.song.toLowerCase() == 'unfair-bambi-break-phone') && FlxG.save.data.modchart && FlxG.save.data.newunfair;

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		timeTxt = new FlxText(42 + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		if(FlxG.save.data.downscroll) timeTxt.y = FlxG.height - 44;
		add(timeTxt);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<StrumNote>();

		dadStrums = new FlxTypedGroup<StrumNote>();

		if (boyfriend.curCharacter == 'shaggy' && SONG.song.toLowerCase() != "tutorial" && SONG.song.toLowerCase() != "mealie" && SONG.song.toLowerCase() != "furiosity" && SONG.song.toLowerCase() != "old-house" && SONG.song.toLowerCase() != "old-insanity" && SONG.song.toLowerCase() != "old-blocked" && SONG.song.toLowerCase() != "old-corn-theft" && SONG.song.toLowerCase() != "old-maze" && SONG.song.toLowerCase() != "beta-maze" && SONG.song.toLowerCase() != "old-splitathon" && SONG.song.toLowerCase() != "secret")
		{
			Main.shaggyVoice = true;
		}
		else 
			Main.shaggyVoice = false;

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		add(healthBar);

		var credits:String;
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae':
				credits = 'Original Song made by ArchWk!';
			case 'glitch':
				credits = 'Original Song made by DeadShadow and PixelGH!';
			case 'mealie':
				credits = 'Original Song made by Alexander Cooper 19!';
			case 'unfairness':
				if (FlxG.save.data.modchart)
					credits = "Ghost tapping is forced off! Screw you!";
				else
					credits = "You wanted normal gameplay!? Screw you!";
			case 'cheating' | 'unfair-bambi-break-phone':
				credits = 'Screw you!';
			case 'vs-dave-thanksgiving':
				credits = 'What the hell!';
			default:
				credits = '';
		}
		var randomThingy:Int = FlxG.random.int(0, 2);
		var engineName:String = 'stupid';
		switch(randomThingy)
	    {
			case 0:
				engineName = 'Dave ';
			case 1:
				engineName = 'Bambi ';
			case 2:
				engineName = 'Tristan ';
		}
		var creditsText:Bool = credits != '';
		var textYPos:Float = healthBarBG.y + 10;
		if (creditsText)
		{
			textYPos = healthBarBG.y + -10;
		}
		// Add Kade Engine watermark
		var difficulty:Array<String> = ['Easy', "Normal", "Hard", "Extra Keys"];
		var kadeEngineWatermark = new FlxText(4, textYPos, 0,
		SONG.song + " - " + (curSong.toLowerCase() != 'splitathon' && curSong.toLowerCase() != 'old-splitathon' ? difficulty[storyDifficulty] : storyDifficulty == 1 ? "Finale" : difficulty[storyDifficulty]), 16);
		kadeEngineWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.borderSize = 1.25;
		add(kadeEngineWatermark);
		var kadeEngineWatermark2 = new FlxText(4, textYPos + 20, 0,
		engineName + "Engine (KE 1.2)", 16);
		kadeEngineWatermark2.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark2.scrollFactor.set();
		kadeEngineWatermark2.borderSize = 1.25;
		add(kadeEngineWatermark2);
		var kadeEngineWatermark3 = new FlxText(4, textYPos + 40, 0,
		"Extra Keys Addon v1.2.1", 16);
		kadeEngineWatermark3.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark3.scrollFactor.set();
		kadeEngineWatermark3.borderSize = 1.25;
		add(kadeEngineWatermark3);
		if (creditsText)
		{
			var creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
			creditsWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			creditsWatermark.scrollFactor.set();
			creditsWatermark.borderSize = 1.25;
			add(creditsWatermark);
			creditsWatermark.cameras = [camHUD];
		}
		switch (curSong.toLowerCase())
		{
			case 'splitathon' | 'old-splitathon':
				preload('splitathon/Bambi_WaitWhatNow');
				preload('splitathon/Bambi_ChillingWithTheCorn');
			case 'insanity':
				preload('dave/redsky');
				preload('dave/redsky_insanity');
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 200, healthBarBG.y + 40, 0, "", 20);
		scoreTxt.setFormat(Paths.font("comic.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5;
		add(scoreTxt);

		extraTxt = new FlxText(10, 18, 0, "", 20);
		extraTxt.setFormat(Paths.font("comic.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		extraTxt.scrollFactor.set();
		extraTxt.borderSize = 1.5;
		if (FlxG.save.data.opponentnotes)
			add(extraTxt);

		botplayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0,
		"BOTPLAY", 20);
		botplayTxt.setFormat(Paths.font("comic.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 3;
		botplayTxt.visible = botPlay;
		add(botplayTxt);

		iconP1 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		extraTxt.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		kadeEngineWatermark.cameras = [camHUD];
		kadeEngineWatermark2.cameras = [camHUD];
		kadeEngineWatermark3.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camDialogue];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if ((isStoryMode || FlxG.save.data.freeplayCuts) && boyfriend.curCharacter != "shaggy")
		{
			switch (curSong.toLowerCase())
			{
				case 'house' | 'insanity' | 'furiosity' | 'polygonized' | 'supernovae' | 'glitch' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'cheating' | 'unfairness':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}

	function createBackgroundSprites(bgName:String):FlxTypedGroup<FlxSprite>
	{
		var sprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
		switch (bgName)
		{
			case 'house':
				defaultCamZoom = 0.9;
				curStage = 'daveHouse';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;

				sprites.add(bg);
				add(bg);
	
				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;
				
				sprites.add(stageHills);
				add(stageHills);
	
				var gate:FlxSprite = new FlxSprite(-200, -125).loadGraphic(Paths.image('dave/gate'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;

				sprites.add(gate);
				add(gate);
	
				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;
				
				sprites.add(stageFront);
				add(stageFront);

				UsingNewCam = true;
				if (SONG.song.toLowerCase() == 'insanity')
				{
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/redsky_insanity'));
					bg.alpha = 0.75;
					bg.active = true;
					bg.visible = false;
					add(bg);
					// below code assumes shaders are always enabled which is bad
					var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
					testshader.waveAmplitude = 0.1;
					testshader.waveFrequency = 5;
					testshader.waveSpeed = 2;
					bg.shader = testshader.shader;
					curbg = bg;
				}
			case 'farm' | 'farm-night' | 'farm-sunset':
				defaultCamZoom = 0.9;

				switch (bgName.toLowerCase())
				{
					case 'farm-night':
						curStage = 'bambiFarmNight';
					case 'farm-sunset':
						curStage = 'bambiFarmSunset';
					default:
						curStage = 'bambiFarm';
				}
	
				var skyType:String = curStage == 'bambiFarmNight' ? 'dave/sky_night' : 'dave/sky';
				if(curStage == 'bambiFarmSunset')
				{
					skyType = 'dave/sky_sunset';
				}
	
				var bg:FlxSprite = new FlxSprite(-700, -100).loadGraphic(Paths.image(skyType));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				sprites.add(bg);
	
				var hills:FlxSprite = new FlxSprite(-250, 200).loadGraphic(Paths.image('bambi/orangey hills'));
				hills.antialiasing = true;
				hills.scrollFactor.set(0.9, 0.7);
				hills.active = false;
				sprites.add(hills);
	
				var farm:FlxSprite = new FlxSprite(150, 250).loadGraphic(Paths.image('bambi/funfarmhouse'));
				farm.antialiasing = true;
				farm.scrollFactor.set(1.1, 0.9);
				farm.active = false;
				sprites.add(farm);
				
				var foreground:FlxSprite = new FlxSprite(-400, 600).loadGraphic(Paths.image('bambi/grass lands'));
				foreground.antialiasing = true;
				foreground.active = false;
				sprites.add(foreground);
				
				var cornSet:FlxSprite = new FlxSprite(-350, 325).loadGraphic(Paths.image('bambi/Cornys'));
				cornSet.antialiasing = true;
				cornSet.active = false;
				sprites.add(cornSet);
				
				var cornSet2:FlxSprite = new FlxSprite(1050, 325).loadGraphic(Paths.image('bambi/Cornys'));
				cornSet2.antialiasing = true;
				cornSet2.active = false;
				sprites.add(cornSet2);
				
				var fence:FlxSprite = new FlxSprite(-350, 450).loadGraphic(Paths.image('bambi/crazy fences'));
				fence.antialiasing = true;
				fence.active = false;
				sprites.add(fence);
	
				var sign:FlxSprite = new FlxSprite(0, 500).loadGraphic(Paths.image('bambi/Sign'));
				sign.antialiasing = true;
				sign.active = false;
				sprites.add(sign);

				if (curStage == 'bambiFarmNight')
				{
					hills.color = nightColor;
					farm.color = nightColor;
					foreground.color = nightColor;
					cornSet.color = nightColor;
					cornSet2.color = nightColor;
					fence.color = nightColor;
					sign.color = nightColor;
				}

				if (curStage == 'bambiFarmSunset')
				{
					hills.color = sunsetColor;
					farm.color = sunsetColor;
					foreground.color = sunsetColor;
					cornSet.color = sunsetColor;
					cornSet2.color = sunsetColor;
					fence.color = sunsetColor;
					sign.color = sunsetColor;
				}
				
				add(bg);
				add(hills);
				add(farm);
				add(foreground);
				add(cornSet);
				add(cornSet2);
				add(fence);
				add(sign);
	
				UsingNewCam = true;
			case 'house-night':
				defaultCamZoom = 0.9;
				curStage = 'daveHouse_night';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky_night'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;
				
				sprites.add(bg);
				add(bg);
	
				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills_night'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;

				sprites.add(stageHills);
				add(stageHills);
	
				var gate:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/gate_night'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;

				sprites.add(gate);
				add(gate);
	
				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass_night'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;

				sprites.add(stageFront);
				add(stageFront);

				UsingNewCam = true;
			case 'red-void' | 'green-void' | 'glitchy-void':
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/redsky'));
				bg.active = true;
	
				switch (bgName.toLowerCase())
				{
					case 'green-void':
						bg.loadGraphic(Paths.image('dave/cheater'));
						curStage = 'cheating';
					case 'glitchy-void':
						bg.loadGraphic(Paths.image('dave/scarybg'));
						curStage = 'unfairness';
					default:
						bg.loadGraphic(Paths.image('dave/redsky'));
						curStage = 'daveEvilHouse';
				}
				
				sprites.add(bg);
				add(bg);
				// below code assumes shaders are always enabled which is bad
				// i wouldnt consider this an eyesore though
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
				if (SONG.song.toLowerCase() == 'furiosity' || SONG.song.toLowerCase() == 'polygonized' || SONG.song.toLowerCase() == 'unfairness' || SONG.song.toLowerCase() == 'unfair-bambi-break-phone')
				{
					UsingNewCam = true;
				}
			default:
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				
				sprites.add(bg);
				add(bg);
	
				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				sprites.add(stageFront);
				add(stageFront);
	
				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
	
				sprites.add(stageCurtains);
				add(stageCurtains);
			case 'house-sunset':
				defaultCamZoom = 0.9;
				curStage = 'daveHouse_sunset';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky_sunset'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;

				sprites.add(bg);
				add(bg);
	
				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;
				
				sprites.add(stageHills);
				add(stageHills);
	
				var gate:FlxSprite = new FlxSprite(-200, -125).loadGraphic(Paths.image('dave/gate'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;

				sprites.add(gate);
				add(gate);
	
				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;
				
				sprites.add(stageFront);
				add(stageFront);

				gate.color = sunsetColor;
				stageHills.color = sunsetColor;
				stageFront.color = sunsetColor;
		}
		return sprites;
	}

	function schoolIntro(?dialogueBox:DialogueBox, isStart:Bool = true):Void
	{
		inCutscene = true;
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x - 200, dad.getGraphicMidpoint().y - 10);
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var stupidBasics:Float = 1;
		if (isStart)
		{
			FlxTween.tween(black, {alpha: 0}, stupidBasics);
		}
		else
		{
			black.alpha = 0;
			stupidBasics = 0;
		}
		new FlxTimer().start(stupidBasics, function(fuckingSussy:FlxTimer)
		{
			if (dialogueBox != null)
			{
				add(dialogueBox);
			}
			else
			{
				startCountdown();
			}
		});
	}

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;
	
		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
					focusOnDadGlobal = false;
					ZoomCam(false);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
					focusOnDadGlobal = true;
					ZoomCam(true);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
					focusOnDadGlobal = false;
					ZoomCam(false);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
					focusOnDadGlobal = true;
					ZoomCam(true);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		vocals.play();
		if (FlxG.save.data.tristanProgress == "pending play" && isStoryMode && storyWeek != 10)
		{
			FlxG.sound.music.volume = 0;
		}

		songLength = FlxG.sound.music.length;

		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\n" + botText + "Acc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		FlxG.sound.music.onComplete = endSong;
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % Main.keyAmmo[mania]);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > Main.keyAmmo[mania] - 1)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, gottaHitNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(SONG.speed, 2)), daNoteData, oldNote, true);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);

						sustainNote.mustPress = gottaHitNote;

						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}

			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...keyAmmo[mania])
		{
			// FlxG.log.add(i);
			var babyArrow:StrumNote = new StrumNote(0, strumLine.y, i);

			if (funnyFloatyBoys.contains(dad.curCharacter) && player == 0 || funnyFloatyBoys.contains(boyfriend.curCharacter) && player == 1)
			{
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_3D');
				babyArrow.animation.addByPrefix('green', 'arrowUP');
				babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
				babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
				babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

				babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));

				var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
				var pPre:Array<String> = ['left', 'down', 'up', 'right'];
				switch (mania)
				{
					case 1:
						nSuf = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
						pPre = ['left', 'up', 'right', 'yel', 'down', 'dark'];
					case 2:
						nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
						pPre = ['left', 'down', 'up', 'right', 'white', 'yel', 'violet', 'black', 'dark'];
						babyArrow.x -= Note.tooMuch;
				}
				babyArrow.x += Note.swagWidth * i;
				babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
				babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
				babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);
			}
			else
			{
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
				babyArrow.animation.addByPrefix('green', 'arrowUP');
				babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
				babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
				babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

				babyArrow.antialiasing = true;
				babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));

				var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
				var pPre:Array<String> = ['left', 'down', 'up', 'right'];
				switch (mania)
				{
					case 1:
						nSuf = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
						pPre = ['left', 'up', 'right', 'yel', 'down', 'dark'];
					case 2:
						nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
						pPre = ['left', 'down', 'up', 'right', 'white', 'yel', 'violet', 'black', 'dark'];
						babyArrow.x -= Note.tooMuch;
				}
				babyArrow.x += Note.swagWidth * i;
				babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
				babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
				babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);
			}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
	
			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				dadStrums.add(babyArrow);
			}

			babyArrow.playAnim('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
			
			babyArrow.resetTrueCoords();
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if desktop
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") |",
				botText + "Acc: "
				+ truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	public function throwThatBitchInThere(guyWhoComesIn:String = 'bambi', guyWhoFliesOut:String = 'dave')
	{
		hasTriggeredDumbshit = true;
		if(BAMBICUTSCENEICONHURHURHUR != null)
		{
			remove(BAMBICUTSCENEICONHURHURHUR);
		}
		BAMBICUTSCENEICONHURHURHUR = new HealthIcon(guyWhoComesIn, false);
		BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
		add(BAMBICUTSCENEICONHURHURHUR);
		BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
		BAMBICUTSCENEICONHURHURHUR.x = -100;
		FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3, true, {ease: FlxEase.expoInOut});
		AUGHHHH = guyWhoComesIn;
		AHHHHH = guyWhoFliesOut;
		new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			if (startTimer.finished)
				{
					#if desktop
					DiscordClient.changePresence(detailsText
						+ " "
						+ SONG.song
						+ " ("
						+ storyDifficultyText
						+ ") ",
						"\n" + botText + "Acc: "
						+ truncateFloat(accuracy, 2)
						+ "% | Score: "
						+ songScore
						+ " | Misses: "
						+ misses, iconRPC, true,
						FlxG.sound.music.length
						- Conductor.songPosition);
					#end
				}
				else
				{
					#if desktop
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") ", iconRPC);
					#end
				}
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\n" + botText + "Acc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	private var likeawing:Array<Float> = [70, 120, -100, 130, 0, -130, -80, 60, -70];

	override public function update(elapsed:Float)
	{
		elapsedtime += elapsed;
		if (curbg != null)
		{
			if (curbg.active) // only the furiosity background is active
			{
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
			}
		}

		//welcome to 3d sinning avenue
		if(funnyFloatyBoys.contains(dad.curCharacter.toLowerCase()) && canFloat)
		{
			dad.y += (Math.sin(elapsedtime) * 0.6);
		}
		if(funnyFloatyBoys.contains(boyfriend.curCharacter.toLowerCase()) && canFloat)
		{
			boyfriend.y += (Math.sin(elapsedtime) * 0.6);
		}
		/*if(funnyFloatyBoys.contains(dadmirror.curCharacter.toLowerCase()))
		{
			dadmirror.y += (Math.sin(elapsedtime) * 0.6);
		}*/
		if(funnyFloatyBoys.contains(gf.curCharacter.toLowerCase()) && canFloat)
		{
			gf.y += (Math.sin(elapsedtime) * 0.6);
		}

		if (SONG.song.toLowerCase() == 'cheating' && !inCutscene && FlxG.save.data.modchart) // fuck you
		{
			var num:Float = 1.5;
			if (mania == 1) num = 1.4;
			if (mania == 2) num = 1.3;
			playerStrums.forEach(function(spr:FlxSprite)
			{
				spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x -= Math.sin(elapsedtime) * num;
			});
			dadStrums.forEach(function(spr:FlxSprite)
			{
				spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x += Math.sin(elapsedtime) * num;
			});
		}

		if ((SONG.song.toLowerCase() == 'unfairness' || SONG.song.toLowerCase() == 'unfair-bambi-break-phone') && FlxG.save.data.modchart && !inCutscene) // fuck you
		{
			var num:Float = 1;
			if (mania == 1) num = 1.5;
			if (mania == 2) num = 2.25;
			if (FlxG.save.data.newunfair) {
				var ddr:Array<Int> = [3, 0, 2, 1];
				if (mania == 2) ddr = [5, 6, 7, 8, 0, 1, 2, 3, 4];
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = FlxG.width / 2 + (Math.sin(elapsedtime + (ddr[spr.ID] / num) * (Math.PI / 2)) * 150) - 156 * Note.scales[mania] / 2;
					spr.y = FlxG.height / 2 + (Math.cos(elapsedtime + (ddr[spr.ID] / num) * (Math.PI / 2)) * 150) - 156 * Note.scales[mania] / 2;
					if (spr.ID != 4 || mania != 2) {
						spr.angle = elapsedtime * -(360 / Math.PI / 2);
						if (mania == 2) spr.angle += likeawing[spr.ID];
					}
				});
				dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = FlxG.width / 2 + (Math.sin(elapsedtime * 2 + (ddr[spr.ID] / num) * (Math.PI / 2) + (Math.PI / 4)) * 300) - 156 * Note.scales[mania] / 2;
					spr.y = FlxG.height / 2 + (Math.cos(elapsedtime * 2 + (ddr[spr.ID] / num) * (Math.PI / 2) + (Math.PI / 4)) * 300) - 156 * Note.scales[mania] / 2;
					if (spr.ID != 4 || mania != 2) {
						spr.angle = elapsedtime * 2 * -(360 / Math.PI / 2) + 135;
						if (mania == 2) spr.angle += likeawing[spr.ID];
					}
				});
			}
			else {
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 2) - (156 * Note.scales[mania] / 2)) + (Math.sin(elapsedtime + (spr.ID / num)) * 300);
					spr.y = ((FlxG.height / 2) - (156 * Note.scales[mania] / 2)) + (Math.cos(elapsedtime + (spr.ID / num)) * 300);
				});
				dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 2) - (156 * Note.scales[mania] / 2)) + (Math.sin((elapsedtime + (spr.ID)) * 2) * 300);
					spr.y = ((FlxG.height / 2) - (156 * Note.scales[mania] / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
				});
			}
		}
			
		FlxG.camera.setFilters([new ShaderFilter(screenshader.shader)]); // this is very stupid but doesn't effect memory all that much so
		if (shakeCam && eyesoreson)
		{
			// var shad = cast(FlxG.camera.screen.shader,Shaders.PulseShader);
			FlxG.camera.shake(0.015, 0.015);
		}
		screenshader.shader.uTime.value[0] += elapsed;
		if (shakeCam && eyesoreson)
		{
			screenshader.shader.uampmul.value[0] = 1;
		}
		else
		{
			screenshader.shader.uampmul.value[0] -= (elapsed / 2);
		}
		screenshader.Enabled = shakeCam && eyesoreson;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == boyfriendOldIcon)
			{
				var isBF:Bool = formoverride == 'bf' || formoverride == 'none';
				iconP1.animation.play(isBF ? SONG.player1 : formoverride);
			}
			else
			{
				iconP1.animation.play(boyfriendOldIcon);
			}
		}

		switch (SONG.song.toLowerCase())
		{
			case 'splitathon' | 'old-splitathon':
				switch (curStep)
				{
					case 4750:
						dad.canDance = false;
						dad.playAnim('scared', true);
						camHUD.shake(0.015, (Conductor.stepCrochet / 100) * 5);
					case 4800:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitterThonDave('what');
						addSplitathonChar("bambi-splitathon");
						if (!hasTriggeredDumbshit)
						{
							throwThatBitchInThere('bambi', 'dave');
						}
					case 5824:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi-what', -100, 550);
						addSplitathonChar("dave-splitathon");
						if (!hasTriggeredDumbshit)
						{
							throwThatBitchInThere('dave', 'bambi');
						}
					case 6080:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitterThonDave('happy');
						addSplitathonChar("bambi-splitathon");
						if (!hasTriggeredDumbshit)
						{
							throwThatBitchInThere('bambi', 'dave');
						}
					case 8384:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi-corn', -100, 550);
						addSplitathonChar("dave-splitathon");
						if (!hasTriggeredDumbshit)
						{
							throwThatBitchInThere('dave', 'bambi');
						}
					case 4850 | 5874 | 6130 | 8434:
						//bullshit
						hasTriggeredDumbshit = false;
						updatevels = false;
				}
			case 'insanity':
				switch (curStep)
				{
					case 660 | 680:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.visible = true;
						iconP2.animation.play(dadmirror.curCharacter);
					case 664 | 684:
						dad.visible = true;
						dadmirror.visible = false;
						curbg.visible = false;
						iconP2.animation.play(dad.curCharacter);
					case 1176:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.loadGraphic(Paths.image('dave/redsky'));
						curbg.alpha = 1;
						curbg.visible = true;
						iconP2.animation.play(dadmirror.curCharacter);
					case 1180:
						dad.visible = true;
						dadmirror.visible = false;
						iconP2.animation.play(dad.curCharacter);
						dad.canDance = false;
						dad.animation.play('scared', true);
				}
		}

		super.update(elapsed);
	
		if (health > 2)
			health = 2;

		scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Combo:" + combo + " | Health:" + Math.floor(health * 500) / 10 + "%" + " | Accuracy:" + truncateFloat(accuracy, 2) + "% ";
		extraTxt.text = "Opponent Notes Count: " + opponentnotecount;

		if(botplayTxt.visible) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			var diff:String = "";
			if (storyDifficulty == 3) diff = "-extrakeys";
			switch (curSong.toLowerCase())
			{
				case 'supernovae' | 'glitch':
					PlayState.SONG = Song.loadFromJson("cheating" + diff, "cheating"); // you dun fucked up
					FlxG.save.data.cheatingFound = true;
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new PlayState());
					return;
					// FlxG.switchState(new VideoState('assets/videos/fortnite/fortniteballs.webm', new CrasherState()));
				case 'cheating':
					PlayState.SONG = Song.loadFromJson("unfairness" + diff, "unfairness"); // you dun fucked up again
					FlxG.save.data.unfairnessFound = true;
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new PlayState());
					return;
				case 'unfairness' | 'unfair-bambi-break-phone':
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new YouCheatedSomeoneIsComing());
				default:
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new ChartingState());
					#if desktop
					DiscordClient.changePresence("Chart Editor", null, null, true);
					#end
			}
		}

		/* if (FlxG.keys.justPressed.FOUR) {
			shakeCam = false;
			screenshader.Enabled = false;
			FlxG.switchState(new ChartingState());
			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		} */

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.8)),Std.int(FlxMath.lerp(150, iconP1.height, 0.8)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.8)),Std.int(FlxMath.lerp(150, iconP2.height, 0.8)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(dad.curCharacter));
		if (FlxG.keys.justPressed.TWO)
			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
		if (FlxG.keys.justPressed.THREE)
			FlxG.switchState(new AnimationDebug(gf.curCharacter));
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) 
				{
					var curTime:Float = Conductor.songPosition;
					if(curTime < 0) curTime = 0;

					var songCalc:Float = (FlxG.sound.music.length - curTime);

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;
					
					timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong.toLowerCase() == 'furiosity')
		{
			switch (curBeat)
			{
				case 127:
					camZooming = true;
				case 159:
					camZooming = false;
				case 191:
					camZooming = true;
				case 223:
					camZooming = false;
			}
		}

		if (health <= 0 && !botPlay && !practiceMode)
		{
			if(!perfectMode)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
	
				vocals.stop();
				FlxG.sound.music.stop();
	
				screenshader.shader.uampmul.value[0] = 0;
				screenshader.Enabled = false;
			}

			if(shakeCam)
			{
				FlxG.save.data.unlockedcharacters[7] = true;
			}

			if (!shakeCam)
			{
				if(!perfectMode)
				{
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition()
						.y, formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));

						#if desktop
						DiscordClient.changePresence("GAME OVER -- "
						+ SONG.song
						+ " ("
						+ storyDifficultyText
						+ ") ",
						"\n" + botText + "Acc: "
						+ truncateFloat(accuracy, 2)
						+ "% | Score: "
						+ songScore
						+ " | Misses: "
						+ misses, iconRPC);
						#end
				}
			}
			else
			{
				if (isStoryMode)
				{
					switch (SONG.song.toLowerCase())
					{
						case 'blocked' | 'corn-theft' | 'maze':
							FlxG.openURL("https://www.youtube.com/watch?v=eTJOdgDzD64");
							System.exit(0);
						default:
							FlxG.switchState(new EndingState('rtxx_ending', 'badEnding'));
					}
				}
				else
				{
					if(!perfectMode)
					{
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition()
							.y, formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));

							#if desktop
							DiscordClient.changePresence("GAME OVER -- "
							+ SONG.song
							+ " ("
							+ storyDifficultyText
							+ ") ",
							"\n" + botText + "Acc: "
							+ truncateFloat(accuracy, 2)
							+ "% | Score: "
							+ songScore
							+ " | Misses: "
							+ misses, iconRPC);
							#end
					}
				}
			}

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < ((SONG.song.toLowerCase() == 'unfairness' || SONG.song.toLowerCase() == 'unfair-bambi-break-phone') && FlxG.save.data.modchart ? 15000 : 1500))
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				var notesScroll:Float = FlxG.save.data.downscroll ? -0.45 : 0.45;
	
				if (FlxG.save.data.modchart) {
					if (SONG.song.toLowerCase() == 'unfairness' || SONG.song.toLowerCase() == 'unfair-bambi-break-phone') {
						var num:Float = 1;
						if (mania == 1) num = 1.5;
						if (mania == 2) num = 2.25;
						if (FlxG.save.data.newunfair) {
							var ddr:Array<Int> = [3, 0, 2, 1];
							if (mania == 2) ddr = [5, 6, 7, 8, 0, 1, 2, 3, 4];
							if(daNote.mustPress)
							{
								daNote.x = playerStrums.members[daNote.noteData].x + Math.sin(elapsedtime + (ddr[daNote.noteData] / num) * (Math.PI / 2)) * (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.localSpreadX, 2));
								daNote.y = playerStrums.members[daNote.noteData].y + Math.cos(elapsedtime + (ddr[daNote.noteData] / num) * (Math.PI / 2)) * (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.localSpreadY, 2));
								daNote.angle = playerStrums.members[daNote.noteData].angle;
							}
							else
							{
								daNote.x = dadStrums.members[daNote.noteData].x + Math.sin(elapsedtime * 2 + (ddr[daNote.noteData] / num) * (Math.PI / 2) + (Math.PI / 4)) * (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.localSpreadX, 2));
								daNote.y = dadStrums.members[daNote.noteData].y + Math.cos(elapsedtime * 2 + (ddr[daNote.noteData] / num) * (Math.PI / 2) + (Math.PI / 4)) * (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.localSpreadY, 2));
								daNote.angle = dadStrums.members[daNote.noteData].angle;
							}
							if (daNote.isSustainNote) {
								if (mania == 0) daNote.angle += daNote.noteData == 0 || daNote.noteData == 3 ? 90 : 0;
								if (mania == 2) {
									if (daNote.noteData == 4) daNote.angle = elapsedtime * (daNote.mustPress ? 1 : 2) * -(360 / Math.PI / 2) + (daNote.mustPress ? 0 : 135) + likeawing[daNote.noteData];
									daNote.angle += daNote.noteData == 0 || daNote.noteData == 3 || daNote.noteData == 5 || daNote.noteData == 8 ? 90 : 0;
								}
								daNote.x -= daNote.width / 2;
								daNote.x -= daNote.height / 2;
								daNote.x += 156 * Note.scales[mania] / 2;
								daNote.x += 156 * Note.scales[mania] / 2;
							}
						}
						else {
							if(daNote.mustPress)
							{
								daNote.x = playerStrums.members[daNote.noteData].x;
								daNote.y = playerStrums.members[daNote.noteData].y - (Conductor.songPosition - daNote.strumTime) * (notesScroll * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2));
							}
							else
							{
								daNote.x = dadStrums.members[daNote.noteData].x;
								daNote.y = dadStrums.members[daNote.noteData].y - (Conductor.songPosition - daNote.strumTime) * (notesScroll * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2));
							}
							if (daNote.isSustainNote) {
								daNote.x -= daNote.width / 2;
								daNote.x += 156 * Note.scales[mania] / 2;
							}
						}
					}
					else daNote.y = strumLine.y - (Conductor.songPosition - daNote.strumTime) * (notesScroll * FlxMath.roundDecimal(SONG.speed, 2));
				}
				else {
					if (SONG.song.toLowerCase() == 'unfairness' || SONG.song.toLowerCase() == 'unfair-bambi-break-phone') {
						if (mania == 0) SONG.speed = 3.1;
						if (mania == 2) SONG.speed = 2.5;
					}
					daNote.y = strumLine.y - (Conductor.songPosition - daNote.strumTime) * (notesScroll * FlxMath.roundDecimal(SONG.speed, 2));
				}

				if (FlxG.save.data.downscroll && daNote.isSustainNote && !newUnfairModChart)
				{
					if (daNote.animation.curAnim.name.endsWith('end')) {
						daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * SONG.speed + (46 * (SONG.speed - 1));
						daNote.y -= 46 * (1 - (fakeCrochet / 600)) * SONG.speed;
						daNote.y -= 19;
					} 
					daNote.y += (Note.swagWidth / 2) - (60.5 * (SONG.speed - 1));
					daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (SONG.speed - 1);
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";
					var healthtolower:Float = 0.02;

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							if (SONG.song.toLowerCase() != "cheating")
							{
								altAnim = '-alt';
							}
							else
							{
								healthtolower = 0.005;
							}
					}

					//'LEFT', 'DOWN', 'UP', 'RIGHT'
					var fuckingDumbassBullshitFuckYou:String;
					fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(daNote.noteData)) % keyAmmo[mania]];
					if(dad.nativelyPlayable)
					{
						switch(notestuffs[Math.round(Math.abs(daNote.noteData)) % keyAmmo[mania]])
						{
							case 'LEFT':
								fuckingDumbassBullshitFuckYou = 'RIGHT';
							case 'RIGHT':
								fuckingDumbassBullshitFuckYou = 'LEFT';
						}
					}
					if(dad.curCharacter == 'bambi-unfair' || dad.curCharacter == 'bambi-3d')
					{
						FlxG.camera.shake(0.0075, 0.1);
						camHUD.shake(0.0045, 0.1);
					}
					dad.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);
					dadmirror.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);

					var time:Float = 0.15;
					if(daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end')) {
						time += 0.15;
					}
					StrumPlayAnim(true, Std.int(Math.abs(daNote.noteData)) % keyAmmo[mania], time);
					daNote.hitByOpponent = true;
					if (!daNote.isSustainNote) opponentnotecount += 1;

					if (UsingNewCam)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}

					switch (SONG.song.toLowerCase())
					{
						case 'cheating':
							health -= healthtolower * (storyDifficulty == 3 ? 1 : 0.925);
						case 'unfairness':
							health -= healthtolower / (storyDifficulty == 3 ? 10 : 6);
						case 'unfair-bambi-break-phone':
							health -= 0.0062111801242236;
						default:
							if (FlxG.save.data.healthdrain && health > 0.2)
							{
								if (!daNote.isSustainNote)
									health -= 0.01725;
								else
									health -= 0.003;
								if (health < 0.2)
									health = 0.2;
							}
					}
					
					// boyfriend.playAnim('hit',true);
					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					if (!daNote.isSustainNote || (daNote.isSustainNote && newUnfairModChart))
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}

				if(daNote.mustPress && botPlay) {
					if(daNote.isSustainNote) {
						if(daNote.canBeHit) {
							goodNoteHit(daNote);
						}
					} else if(daNote.strumTime <= Conductor.songPosition || (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress)) {
						goodNoteHit(daNote);
					}
				}

				var strumY:Float = playerStrums.members[daNote.noteData].y;
				if(!daNote.mustPress) strumY = dadStrums.members[daNote.noteData].y;

				var center:Float = strumY + Note.swagWidth / 2;
				if(daNote.isSustainNote && !newUnfairModChart && (daNote.mustPress || (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))))
				{
					if (FlxG.save.data.downscroll)
					{
						if(daNote.y - daNote.scale.y + daNote.height >= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;

							daNote.clipRect = swagRect;
						}
					}
					else
					{
						if (daNote.y + daNote.scale.y <= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (center - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;

							daNote.clipRect = swagRect;
						}
					}
				}

				if (Conductor.songPosition > 350 / SONG.speed + daNote.strumTime)
				{
					if(daNote.mustPress && daNote.finishedGenerating && !botPlay && (daNote.tooLate || !daNote.wasGoodHit))
					{
						noteMiss(daNote.noteData);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		ZoomCam(focusOnDadGlobal);

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		/* #if debug
		if (FlxG.keys.justPressed.TWO)
		{
			BAMBICUTSCENEICONHURHURHUR = new HealthIcon("bambi", false);
			BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
			add(BAMBICUTSCENEICONHURHURHUR);
			BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
			BAMBICUTSCENEICONHURHURHUR.x = -100;
			FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3, true, {ease: FlxEase.expoInOut});
			new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
		}
		#end */
		if (updatevels)
		{
			stupidx *= 0.98;
			stupidy += elapsed * 6;
			if (BAMBICUTSCENEICONHURHURHUR != null)
			{
				BAMBICUTSCENEICONHURHURHUR.x += stupidx;
				BAMBICUTSCENEICONHURHURHUR.y += stupidy;
			}
		}
	}

	function FlingCharacterIconToOblivionAndBeyond(e:FlxTimer = null):Void
	{
		iconP2.animation.play(AUGHHHH, true);
		BAMBICUTSCENEICONHURHURHUR.animation.play(AHHHHH, true, false, 1);
		stupidx = -5;
		stupidy = -5;
		updatevels = true;
		
	}

	function ZoomCam(focusondad:Bool):Void
	{
		var bfplaying:Bool = false;
		if (focusondad)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (!bfplaying)
				{
					if (daNote.mustPress)
					{
						bfplaying = true;
					}
				}
			});
			if (UsingNewCam && bfplaying)
			{
				return;
			}
		}
		if (focusondad)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

			switch (dad.curCharacter)
			{
				case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
					camFollow.y = dad.getMidpoint().y;
			}

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				tweenCamIn();
			}
		}

		if (!focusondad)
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

			switch(boyfriend.curCharacter)
			{
				case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
					camFollow.y = boyfriend.getMidpoint().y;
				case 'bambi-3d' | 'bambi-unfair':
					camFollow.y = boyfriend.getMidpoint().y - 550;
				case 'shaggy':
					camFollow.setPosition(boyfriend.getMidpoint().x - 200, boyfriend.getMidpoint().y - 50);
			}

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			}
		}
	}


	function THROWPHONEMARCELLO(e:FlxTimer = null):Void
	{
		STUPDVARIABLETHATSHOULDNTBENEEDED.animation.play("throw_phone");
		new FlxTimer().start(5.5, function(timer:FlxTimer)
		{ 
			FlxG.switchState(new FreeplayState());
		});
	}

	function endSong():Void
	{
		inCutscene = false;
		canPause = false;
		updateTime = false;

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		if (!botPlay && !practiceMode) {
			if (SONG.validScore)
			{
				trace("score is valid");
				#if !switch
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, characteroverride == "none"
					|| characteroverride == "bf" ? "bf" : characteroverride);
				#end
			}
	
			if (curSong.toLowerCase() == 'bonus-song')
			{
				FlxG.save.data.unlockedcharacters[3] = true;
			}
	
			if (curSong.toLowerCase() == 'unfairness' && storyDifficulty == 3 && mania == 2 && FlxG.save.data.modchart)
			{
				FlxG.save.data.beatUnfairness = true;
			}
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			if (!botPlay && !practiceMode) {
				var completedSongs:Array<String> = [];
				var mustCompleteSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Blocked', 'Corn-Theft', 'Maze', 'Splitathon'];
				var allSongsCompleted:Bool = true;
				if (FlxG.save.data.songsCompleted == null)
				{
					FlxG.save.data.songsCompleted = new Array<String>();
				}
				completedSongs = FlxG.save.data.songsCompleted;
				completedSongs.push(storyPlaylist[0]);
				for (i in 0...mustCompleteSongs.length)
				{
					if (!completedSongs.contains(mustCompleteSongs[i]))
					{
						allSongsCompleted = false;
						break;
					}
				}
				if (allSongsCompleted && !FlxG.save.data.unlockedcharacters[6])
				{
					FlxG.save.data.unlockedcharacters[6] = true;
				}
				FlxG.save.data.songsCompleted = completedSongs;
			}

			FlxG.save.flush();

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				switch (curSong.toLowerCase())
				{
					case 'polygonized':
						FlxG.save.data.tristanProgress = "unlocked";
						if (health >= 0.1)
						{
							if (!botPlay && !practiceMode) {
								FlxG.save.data.unlockedcharacters[2] = true;
								if (storyDifficulty == 3)
								{
									FlxG.save.data.unlockedcharacters[5] = true;
								}
							}
							if (boyfriend.curCharacter != "shaggy")
								FlxG.switchState(new EndingState('goodEnding', 'goodEnding'));
							else
								FlxG.switchState(new StoryMenuState());
						}
						else if (health < 0.1)
						{
							if (!botPlay && !practiceMode)
								FlxG.save.data.unlockedcharacters[4] = true;
							if (boyfriend.curCharacter != "shaggy")
								FlxG.switchState(new EndingState('vomit_ending', 'badEnding'));
							else
								FlxG.switchState(new StoryMenuState());
						}
					case 'maze':
						if (boyfriend.curCharacter != "shaggy") {
							canPause = false;
							FlxG.sound.music.volume = 0;
							vocals.volume = 0;
							generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
							boyfriend.stunned = true;
							var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('maze/endDialogue')));
							doof.scrollFactor.set();
							doof.finishThing = function()
							{
								FlxG.switchState(new StoryMenuState());
							};
							doof.cameras = [camDialogue];
							schoolIntro(doof, false);
						}
						else
							FlxG.switchState(new StoryMenuState());
					case 'splitathon':
						if (boyfriend.curCharacter != "shaggy") {
							canPause = false;
							FlxG.sound.music.volume = 0;
							vocals.volume = 0;
							generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
							boyfriend.stunned = true;
							var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogueEnd')));
							doof.scrollFactor.set();
							doof.finishThing = function()
							{
								FlxG.switchState(new StoryMenuState());
							};
							doof.cameras = [camDialogue];
							schoolIntro(doof, false);
						}
						else
							FlxG.switchState(new StoryMenuState());
					default:
						FlxG.switchState(new StoryMenuState());
				}
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore && !botPlay && !practiceMode)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore,
						storyDifficulty, characteroverride == "none" || characteroverride == "bf" ? "bf" : characteroverride);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				switch (SONG.song.toLowerCase())
				{
					case 'insanity':
						if (boyfriend.curCharacter != "shaggy") {
							canPause = false;
							FlxG.sound.music.volume = 0;
							vocals.volume = 0;
							generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
							boyfriend.stunned = true;
							var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('insanity/endDialogue')));
							doof.scrollFactor.set();
							doof.finishThing = nextSong;
							doof.cameras = [camDialogue];
							schoolIntro(doof, false);
						}
						else
							nextSong();
					default:
						nextSong();
				}
			}
		}
		else
		{
			if (SONG.song.toLowerCase() == "glitch" && FlxG.save.data.freeplayCuts) {
				canPause = false;
				FlxG.sound.music.volume = 0;
				vocals.volume = 0;
				var marcello:FlxSprite = new FlxSprite(dad.x - 170, dad.y);
				marcello.flipX = true;
				add(marcello);
				marcello.antialiasing = true;
				marcello.color = 0xFF878787;
				dad.visible = false;
				boyfriend.stunned = true;
				marcello.frames = Paths.getSparrowAtlas('dave/cutscene');
				marcello.animation.addByPrefix('throw_phone', 'bambi0', 24, false);
				FlxG.sound.play(Paths.sound('break_phone'), 1, false, null, true);
				boyfriend.playAnim('hit', true);
				STUPDVARIABLETHATSHOULDNTBENEEDED = marcello;
				new FlxTimer().start(5.5, THROWPHONEMARCELLO);
			}
			else if (SONG.song.toLowerCase() == "insanity" && FlxG.save.data.freeplayCuts && boyfriend.curCharacter != "shaggy") {
				canPause = false;
				FlxG.sound.music.volume = 0;
				vocals.volume = 0;
				generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
				boyfriend.stunned = true;
				var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('insanity/endDialogue')));
				doof.scrollFactor.set();
				doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
				doof.cameras = [camDialogue];
				schoolIntro(doof, false);
			}
			else if (SONG.song.toLowerCase() == "maze" && FlxG.save.data.freeplayCuts && boyfriend.curCharacter != "shaggy") {
				canPause = false;
				FlxG.sound.music.volume = 0;
				vocals.volume = 0;
				generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
				boyfriend.stunned = true;
				var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('maze/endDialogue')));
				doof.scrollFactor.set();
				doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
				doof.cameras = [camDialogue];
				schoolIntro(doof, false);
			}
			else if (SONG.song.toLowerCase() == "splitathon" && FlxG.save.data.freeplayCuts && boyfriend.curCharacter != "shaggy") {
				canPause = false;
				FlxG.sound.music.volume = 0;
				vocals.volume = 0;
				generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
				boyfriend.stunned = true;
				var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogueEnd')));
				doof.scrollFactor.set();
				doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
				doof.cameras = [camDialogue];
				schoolIntro(doof, false);
			}
			else {
				if (SONG.song.toLowerCase() == "unfair-bambi-break-phone")
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.switchState(new FreeplayState());
			}
		}
	}

	function ughWhyDoesThisHaveToFuckingExist() 
	{
		FlxG.switchState(new FreeplayState());
	}

	var endingSong:Bool = false;

	function nextSong()
	{
		var difficulty:String = "";

		if (storyDifficulty == 0)
			difficulty = '-easy';

		if (storyDifficulty == 2)
			difficulty = '-hard';

		if (storyDifficulty == 3)
			difficulty = '-extrakeys';


		trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();
		
		switch (curSong.toLowerCase())
		{
			case 'corn-theft':
				if (boyfriend.curCharacter != "shaggy")
					LoadingState.loadAndSwitchState(new VideoState('assets/videos/mazeecutscenee.webm', new PlayState()), false);
				else
					LoadingState.loadAndSwitchState(new PlayState());
			default:
				LoadingState.loadAndSwitchState(new PlayState());
		}
	}
	private function popUpScore(strumtime:Float, notedata:Int):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (!botPlay)
		{
			if (noteDiff > Conductor.safeZoneOffset * 2)
			{
				daRating = 'shit';
				totalNotesHit += 0;
				score = 50;
				ss = false;
				shits++;
			}
			else if (noteDiff < Conductor.safeZoneOffset * -2)
			{
				daRating = 'shit';
				totalNotesHit += 0;
				score = 50;
				ss = false;
				shits++;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.5)
			{
				daRating = 'bad';
				score = 100;
				totalNotesHit += 0.5;
				ss = false;
				bads++;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.25)
			{
				daRating = 'good';
				totalNotesHit += 0.75;
				score = 200;
				ss = false;
				goods++;
			}
		}
			
		if (daRating == 'sick')
		{
			totalNotesHit += 1;
			sicks++;
		}

		score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[curnote[notedata]], 0), Int);

		if (daRating != 'shit' || daRating != 'bad')
		{
			songScore += score;

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */

			if(scoreTxtTween != null) 
			{
				scoreTxtTween.cancel();
			}

			scoreTxt.scale.x = 1.075;
			scoreTxt.scale.y = 1.075;
			scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					scoreTxtTween = null;
				}
			});

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';

			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.x = coolText.x - 40;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);

			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			comboSpr.updateHitbox();
			rating.updateHitbox();

			var seperatedScore:Array<Int> = [];

			if(combo >= 1000) {
				seperatedScore.push(Math.floor(combo / 1000) % 10);
			}
			seperatedScore.push(Math.floor(combo / 100) % 10);
			seperatedScore.push(Math.floor(combo / 10) % 10);
			seperatedScore.push(combo % 10);
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80;

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				// if (combo >= 10 || combo == 0)
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();

					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	var l1Hold:Bool = false;
	var uHold:Bool = false;
	var r1Hold:Bool = false;
	var l2Hold:Bool = false;
	var dHold:Bool = false;
	var r2Hold:Bool = false;

	var n0Hold:Bool = false;
	var n1Hold:Bool = false;
	var n2Hold:Bool = false;
	var n3Hold:Bool = false;
	var n4Hold:Bool = false;
	var n5Hold:Bool = false;
	var n6Hold:Bool = false;
	var n7Hold:Bool = false;
	var n8Hold:Bool = false;

	var reachBeat:Float;

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var l1 = controls.L1;
		var u = controls.U1;
		var r1 = controls.R1;
		var l2 = controls.L2;
		var d = controls.D1;
		var r2 = controls.R2;

		var l1P = controls.L1_P;
		var uP = controls.U1_P;
		var r1P = controls.R1_P;
		var l2P = controls.L2_P;
		var dP = controls.D1_P;
		var r2P = controls.R2_P;

		var l1R = controls.L1_R;
		var uR = controls.U1_R;
		var r1R = controls.R1_R;
		var l2R = controls.L2_R;
		var dR = controls.D1_R;
		var r2R = controls.R2_R;


		var n0 = controls.N0;
		var n1 = controls.N1;
		var n2 = controls.N2;
		var n3 = controls.N3;
		var n4 = controls.N4;
		var n5 = controls.N5;
		var n6 = controls.N6;
		var n7 = controls.N7;
		var n8 = controls.N8;

		var n0P = controls.N0_P;
		var n1P = controls.N1_P;
		var n2P = controls.N2_P;
		var n3P = controls.N3_P;
		var n4P = controls.N4_P;
		var n5P = controls.N5_P;
		var n6P = controls.N6_P;
		var n7P = controls.N7_P;
		var n8P = controls.N8_P;

		var n0R = controls.N0_R;
		var n1R = controls.N1_R;
		var n2R = controls.N2_R;
		var n3R = controls.N3_R;
		var n4R = controls.N4_R;
		var n5R = controls.N5_R;
		var n6R = controls.N6_R;
		var n7R = controls.N7_R;
		var n8R = controls.N8_R;

		if (botPlay)
		{
			up = false; //UP;
			right = false; //RIGHT;
			down = false; //DOWN;
			left = false; //LEFT;
	
			upP = false; //UP_P;
			rightP = false; //RIGHT_P;
			downP = false; //DOWN_P;
			leftP = false; //LEFT_P;
	
			upR = false; //UP_R;
			rightR = false; //RIGHT_R;
			downR = false; //DOWN_R;
			leftR = false; //LEFT_R;

			l1 = false; //L1;
			u = false; //U1;
			r1 = false; //R1;
			l2 = false; //L2;
			d = false; //D1;
			r2 = false; //R2;
	
			l1P = false; //L1_P;
			uP = false; //U1_P;
			r1P = false; //R1_P;
			l2P = false; //L2_P;
			dP = false; //D1_P;
			r2P = false; //R2_P;
	
			l1R = false; //L1_R;
			uR = false; //U1_R;
			r1R = false; //R1_R;
			l2R = false; //L2_R;
			dR = false; //D1_R;
			r2R = false; //R2_R;
	
	
			n0 = false; //N0;
			n1 = false; //N1;
			n2 = false; //N2;
			n3 = false; //N3;
			n4 = false; //N4;
			n5 = false; //N5;
			n6 = false; //N6;
			n7 = false; //N7;
			n8 = false; //N8;
	
			n0P = false; //N0_P;
			n1P = false; //N1_P;
			n2P = false; //N2_P;
			n3P = false; //N3_P;
			n4P = false; //N4_P;
			n5P = false; //N5_P;
			n6P = false; //N6_P;
			n7P = false; //N7_P;
			n8P = false; //N8_P;
	
			n0R = false; //N0_R;
			n1R = false; //N1_R;
			n2R = false; //N2_R;
			n3R = false; //N3_R;
			n4R = false; //N4_R;
			n5R = false; //N5_R;
			n6R = false; //N6_R;
			n7R = false; //N7_R;
			n8R = false; //N8_R;
		}
		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		var ankey = (upP || rightP || downP || leftP);
		if (mania == 1)
		{ 
			ankey = (l1P || uP || r1P || l2P || dP || r2P);
			controlArray = [l1P, uP, r1P, l2P, dP, r2P];
		}
		else if (mania == 2)
		{
			ankey = (n0P || n1P || n2P || n3P || n4P || n5P || n6P || n7P || n8P);
			controlArray = [n0P, n1P, n2P, n3P, n4P, n5P, n6P, n7P, n8P];
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (ankey && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && daNote.finishedGenerating)
				{
					possibleNotes.push(daNote);
				}
			});

			possibleNotes.sort((a, b) -> Std.int(a.noteData - b.noteData)); //sorting twice is necessary as far as i know
			haxe.ds.ArraySort.sort(possibleNotes, function(a, b):Int {
				var notetypecompare:Int = Std.int(a.noteData - b.noteData);

				if (notetypecompare == 0)
				{
					return Std.int(a.strumTime - b.strumTime);
				}
				return notetypecompare;
			});

			var canMiss:Bool = true;

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				var lasthitnote:Int = -1;
				var lasthitnotetime:Float = -1;

				for (note in possibleNotes) 
				{
					if (controlArray[note.noteData % keyAmmo[mania]])
					{
						if (lasthitnotetime > Conductor.songPosition - Conductor.safeZoneOffset
							&& lasthitnotetime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2)) //reduce the past allowed barrier just so notes close together that aren't jacks dont cause missed inputs
						{
							if ((note.noteData % keyAmmo[mania]) == (lasthitnote % keyAmmo[mania]))
							{
								continue; //the jacks are too close together
							}
						}
						lasthitnote = note.noteData;
						lasthitnotetime = note.strumTime;
						goodNoteHit(note);
						canMiss = false;
					}
				}
			}
			if (!theFunne && canMiss)
			{
				badNoteCheck(null);
			}
		}

		var condition = up || right || down || left;
		if (mania == 1)
		{
			condition = l1 || u || r1 || l2 || d || r2;
		}
		else if (mania == 2)
		{
			condition = n0 || n1 || n2 || n3 || n4 || n5 || n6 || n7 || n8;
		}
		if (condition && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					if (mania == 0)
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 2:
								if (up || upHold)
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold)
									goodNoteHit(daNote);
							case 1:
								if (down || downHold)
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold)
									goodNoteHit(daNote);
						}
					}
					else if (mania == 1)
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 0:
								if (l1 || l1Hold)
									goodNoteHit(daNote);
							case 1:
								if (u || uHold)
									goodNoteHit(daNote);
							case 2:
								if (r1 || r1Hold)
									goodNoteHit(daNote);
							case 3:
								if (l2 || l2Hold)
									goodNoteHit(daNote);
							case 4:
								if (d || dHold)
									goodNoteHit(daNote);
							case 5:
								if (r2 || r2Hold)
									goodNoteHit(daNote);
						}
					}
					else
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 0: if (n0 || n0Hold) goodNoteHit(daNote);
							case 1: if (n1 || n1Hold) goodNoteHit(daNote);
							case 2: if (n2 || n2Hold) goodNoteHit(daNote);
							case 3: if (n3 || n3Hold) goodNoteHit(daNote);
							case 4: if (n4 || n4Hold) goodNoteHit(daNote);
							case 5: if (n5 || n5Hold) goodNoteHit(daNote);
							case 6: if (n6 || n6Hold) goodNoteHit(daNote);
							case 7: if (n7 || n7Hold) goodNoteHit(daNote);
							case 8: if (n8 || n8Hold) goodNoteHit(daNote);
						}
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !condition)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.dance();
			}
		}

		playerStrums.forEach(function(spr:StrumNote)
		{
			if (mania == 0)
			{
				switch (spr.ID)
				{
					case 2:
						if (upP && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							trace('play');
							ghosttappings++;
						}
						if (upR)
						{
							spr.playAnim('static');
						}
					case 3:
						if (rightP && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (rightR)
						{
							spr.playAnim('static');
						}
					case 1:
						if (downP && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (downR)
						{
							spr.playAnim('static');
						}
					case 0:
						if (leftP && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (leftR)
						{
							spr.playAnim('static');
						}
				}
			}
			else if (mania == 1)
			{
				switch (spr.ID)
				{
					case 0:
						if (l1P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							trace('play');
							ghosttappings++;
						}
						if (l1R)
						{
							spr.playAnim('static');
							
						}
					case 1:
						if (uP && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (uR)
						{
							spr.playAnim('static');
							
						}
					case 2:
						if (r1P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (r1R)
						{
							spr.playAnim('static');
							
						}
					case 3:
						if (l2P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (l2R)
						{
							spr.playAnim('static');
							
						}
					case 4:
						if (dP && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (dR)
						{
							spr.playAnim('static');
							
						}
					case 5:
						if (r2P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (r2R)
						{
							spr.playAnim('static');
							
						}
				}
			}
			else if (mania == 2)
			{
				switch (spr.ID)
				{
					case 0:
						if (n0P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (n0R) spr.playAnim('static');
					case 1:
						if (n1P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (n1R) spr.playAnim('static');
					case 2:
						if (n2P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (n2R) spr.playAnim('static');
					case 3:
						if (n3P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (n3R) spr.playAnim('static');
					case 4:
						if (n4P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (n4R) spr.playAnim('static');
					case 5:
						if (n5P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (n5R) spr.playAnim('static');
					case 6:
						if (n6P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (n6R) spr.playAnim('static');
					case 7:
						if (n7P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (n7R) spr.playAnim('static');
					case 8:
						if (n8P && spr.animation.curAnim.name != 'confirm')
						{
							spr.playAnim('pressed');
							ghosttappings++;
						}
						if (n8R) spr.playAnim('static');
				}
			}

			/* if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets(); */
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned && !botPlay)
		{
			health -= 0.0475;
			trace("note miss");
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			songScore -= 10;
			vocals.volume = 0;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			if (boyfriend.animation.getByName("singLEFTmiss") != null)
			{
				//'LEFT', 'DOWN', 'UP', 'RIGHT'
				var fuckingDumbassBullshitFuckYou:String;
				fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(direction)) % keyAmmo[mania]];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[Math.round(Math.abs(direction)) % keyAmmo[mania]])
					{
						case 'LEFT':
							fuckingDumbassBullshitFuckYou = 'RIGHT';
						case 'RIGHT':
							fuckingDumbassBullshitFuckYou = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou + "miss", true);
			}
			else
			{
				boyfriend.color = 0xFF000084;
				//'LEFT', 'DOWN', 'UP', 'RIGHT'
				var fuckingDumbassBullshitFuckYou:String;
				fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(direction)) % keyAmmo[mania]];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[Math.round(Math.abs(direction)) % keyAmmo[mania]])
					{
						case 'LEFT':
							fuckingDumbassBullshitFuckYou = 'RIGHT';
						case 'RIGHT':
							fuckingDumbassBullshitFuckYou = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			}

			updateAccuracy();
		}
	}

	function badNoteCheck(note:Note = null)
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		if (note != null)
		{
			if(note.mustPress && note.finishedGenerating)
			{
				noteMiss(note.noteData);
			}
			return;
		}
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var l1P = controls.L1_P;
		var uP = controls.U1_P;
		var r1P = controls.R1_P;
		var l2P = controls.L2_P;
		var dP = controls.D1_P;
		var r2P = controls.R2_P;

		var n0P = controls.N0_P;
		var n1P = controls.N1_P;
		var n2P = controls.N2_P;
		var n3P = controls.N3_P;
		var n4P = controls.N4_P;
		var n5P = controls.N5_P;
		var n6P = controls.N6_P;
		var n7P = controls.N7_P;
		var n8P = controls.N8_P;
		
		if (mania == 0)
		{
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
		}
		else if (mania == 1)
		{
			if (l1P)
				noteMiss(0);
			else if (uP)
				noteMiss(1);
			else if (r1P)
				noteMiss(2);
			else if (l2P)
				noteMiss(3);
			else if (dP)
				noteMiss(4);
			else if (r2P)
				noteMiss(5);
		}
		else
		{
			if (n0P) noteMiss(0);
			if (n1P) noteMiss(1);
			if (n2P) noteMiss(2);
			if (n3P) noteMiss(3);
			if (n4P) noteMiss(4);
			if (n5P) noteMiss(5);
			if (n6P) noteMiss(6);
			if (n7P) noteMiss(7);
			if (n8P) noteMiss(8);
		}
		updateAccuracy();
	}

	function updateAccuracy()
	{
		if (misses > 0 || accuracy < 96)
			fc = false;
		else
			fc = true;
		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;
	}

	function noteCheck(keyP:Bool, note:Note):Void // sorry lol
	{
		if (keyP)
		{
			goodNoteHit(note);
		}
		else if (!theFunne && !botPlay)
		{
			badNoteCheck(note);
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note.strumTime, note.noteData);
				if (FlxG.save.data.donoteclick)
				{
					FlxG.sound.play(Paths.sound('note_click'));
				}
				updateAccuracy();
			}

			if (!note.isSustainNote)
				health += 0.023;
			else
				health += 0.004;

			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" && SONG.song.toLowerCase() != "cheating" && SONG.song.toLowerCase() != "unfairness" && SONG.song.toLowerCase() != "unfair-bambi-break-phone")
			{
				boyfriend.color = nightColor;
			}
			else if(sunsetLevels.contains(curStage))
			{
				boyfriend.color = sunsetColor;
			}
			else
			{
				boyfriend.color = FlxColor.WHITE;
			}

			//'LEFT', 'DOWN', 'UP', 'RIGHT'
			var fuckingDumbassBullshitFuckYou:String;
			fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(note.noteData)) % keyAmmo[mania]];
			if(!boyfriend.nativelyPlayable)
			{
				switch(notestuffs[Math.round(Math.abs(note.noteData)) % keyAmmo[mania]])
				{
					case 'LEFT':
						fuckingDumbassBullshitFuckYou = 'RIGHT';
					case 'RIGHT':
						fuckingDumbassBullshitFuckYou = 'LEFT';
				}
			}
			if(boyfriend.curCharacter == 'bambi-unfair' || boyfriend.curCharacter == 'bambi-3d')
			{
				FlxG.camera.shake(0.0075, 0.1);
				camHUD.shake(0.0045, 0.1);
			}
			boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			if (UsingNewCam)
			{
				focusOnDadGlobal = false;
				ZoomCam(false);
			}

			if(botPlay) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % keyAmmo[mania], time);
			} else {
				playerStrums.forEach(function(spr:StrumNote)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.playAnim('confirm', true);
					}
				});
			}

			note.wasGoodHit = true;
			vocals.volume = 1;

			if(botPlay) {
				boyfriend.holdTimer = 0;
			}
			if (!note.isSustainNote || (note.isSustainNote && newUnfairModChart)) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
			if(botPlay) {
				var targetHold:Float = Conductor.stepCrochet * 0.001 * 4;
				if(boyfriend.holdTimer + 0.2 > targetHold) {
					boyfriend.holdTimer = targetHold - 0.2;
				}
			}

		}
	}


	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
		switch (SONG.song.toLowerCase())
		{
			case 'furiosity':
				switch (curStep)
				{
					case 512 | 768:
						shakeCam = true;
					case 640 | 896:
						shakeCam = false;
					case 1305:
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in normalDaveBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'dave', false);
						add(dad);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
				}
			case 'polygonized':
				switch(curStep)
				{
					case 1024 | 1312 | 1424 | 1552 | 1664:
						shakeCam = true;
						camZooming = true;
					case 1152 | 1408 | 1472 | 1600 | 2048 | 2188:
						shakeCam = false;
						camZooming = false;
					case 2432:
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
				}
			case 'glitch':
				switch (curStep)
				{
					case 480 | 681 | 1390 | 1445 | 1515 | 1542 | 1598 | 1655:
						shakeCam = true;
						camZooming = true;
					case 512 | 688 | 1420 | 1464 | 1540 | 1558 | 1608 | 1745:
						shakeCam = false;
						camZooming = false;
				}
		}
		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			botText + "Acc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			FlxG.sound.music.length
			- Conductor.songPosition);
		#end
	}
	
	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}
		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if(curBeat % 4 == 0)
		{
			if(timeTxtTween != null) 
			{
				timeTxtTween.cancel();
			}

			timeTxt.scale.x = 1.1;
			timeTxt.scale.y = 1.1;
			timeTxtTween = FlxTween.tween(timeTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					timeTxtTween = null;
				}
			});
		}

		if (!UsingNewCam)
		{
			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{
				if (curBeat % 4 == 0)
				{
					// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
				}

				if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = true;
					ZoomCam(true);
				}

				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = false;
					ZoomCam(false);
				}
			}
		}
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxG.save.data.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		if (dad.animation.finished)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'tutorial':
					dad.dance();
					dadmirror.dance();
				default:
					if (dad.holdTimer <= 0 && curBeat % 2 == 0)
					{
						dad.dance();
						dadmirror.dance();
					}
			}
		}

		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		switch (curSong.toLowerCase())
		{
			case 'furiosity':
				if ((curBeat >= 128 && curBeat < 160) || (curBeat >= 192 && curBeat < 224))
					{
						if (camZooming)
						{
							FlxG.camera.zoom += 0.015;
							camHUD.zoom += 0.03;
						}
					}
			case 'polygonized':
				switch (curBeat)
				{
					case 608:
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in normalDaveBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'dave', false);
						add(dad);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
				}
			case 'mealie':
				switch (curStep)
				{
					case 1776:
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'bambi-angey', false);
						dad.color = nightColor;
						add(dad);
				}
		}
		if (shakeCam)
		{
			gf.playAnim('scared', true);
		}

		var funny:Float = (healthBar.percent * 0.01) + 0.01;

		//health icon bounce but epic
		iconP1.setGraphicSize(Std.int(iconP1.width + (50 * funny)),Std.int(iconP2.height - (25 * funny)));
		iconP2.setGraphicSize(Std.int(iconP2.width + (50 * (2 - funny))),Std.int(iconP2.height - (25 * (2 - funny))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			if (!shakeCam)
			{
				gf.dance();
			}
		}

		if(curBeat % 2 == 0)
		{
			if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.canDance)
				{
					boyfriend.dance();
					if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" && SONG.song.toLowerCase() != "furiosity" && SONG.song.toLowerCase() != "cheating" && SONG.song.toLowerCase() != "unfairness" && SONG.song.toLowerCase() != "unfair-bambi-break-phone")
					{
						boyfriend.color = nightColor;
					}
					else if(sunsetLevels.contains(curStage))
					{
						boyfriend.color = sunsetColor;
					}
					else
					{
						boyfriend.color = FlxColor.WHITE;
					}
				}
		}

		if (curBeat % 8 == 7 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf') // fixed your stupid fucking code ninjamuffin this is literally the easiest shit to fix like come on seriously why are you so dumb
		{
			dad.playAnim('cheer', true);
			boyfriend.playAnim('hey', true);
		}
	}

	function eatShit(ass:String):Void
	{
		if (dialogue[0] == null)
		{
			trace(ass);
		}
		else
		{
			trace(dialogue[0]);
		}
	}

	public function addSplitathonChar(char:String):Void
	{
		boyfriend.stunned = true; //hopefully this stun stuff should prevent BF from randomly missing a note
		remove(dad);
		dad = new Character(100, 100, char);
		add(dad);
		dad.color = nightColor;
		switch (dad.curCharacter)
		{
			case 'dave-splitathon':
				{
					dad.y += 160;
					dad.x += 250;
				}
			case 'bambi-splitathon':
				{
					dad.x += 100;
					dad.y += 450;
				}
		}
		boyfriend.stunned = false;
	}

	//this is cuz splitathon dave expressions are now baked INTO the sprites! so cool! bonuses of this include:
	// - Not having to cache every expression
	// - Being able to reuse them for other things (ie. lookup for scared)
	public function splitterThonDave(expression:String):Void
	{
		boyfriend.stunned = true; //hopefully this stun stuff should prevent BF from randomly missing a note
		//stupid bullshit cuz i dont wanna bother with removing thing erighkjrehjgt
		thing.x = -9000;
		thing.y = -9000;
		if(daveExpressionSplitathon != null)
			remove(daveExpressionSplitathon);
		daveExpressionSplitathon = new Character(-100, 260, 'dave-splitathon');
		add(daveExpressionSplitathon);
		daveExpressionSplitathon.color = nightColor;
		daveExpressionSplitathon.canDance = false;
		daveExpressionSplitathon.playAnim(expression, true);
		boyfriend.stunned = false;
	}

	public function preload(graphic:String) //preload assets
	{
		if (boyfriend != null)
		{
			boyfriend.stunned = true;
		}
		var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic));
		add(newthing);
		remove(newthing);
		if (boyfriend != null)
		{
			boyfriend.stunned = false;
		}
	}


	public function splitathonExpression(expression:String, x:Float, y:Float):Void
	{
		if (SONG.song.toLowerCase() == 'splitathon' || SONG.song.toLowerCase() == 'old-splitathon')
		{
			if(daveExpressionSplitathon != null)
			{
				remove(daveExpressionSplitathon);
			}
			if (expression != 'lookup')
			{
				camFollow.setPosition(dad.getGraphicMidpoint().x + 100, boyfriend.getGraphicMidpoint().y + 150);
			}
			boyfriend.stunned = true;
			thing.color = nightColor;
			thing.x = x;
			thing.y = y;
			remove(dad);

			switch (expression)
			{
				case 'bambi-what':
					thing.frames = Paths.getSparrowAtlas('splitathon/Bambi_WaitWhatNow');
					thing.animation.addByPrefix('uhhhImConfusedWhatsHappening', 'what', 24);
					thing.animation.play('uhhhImConfusedWhatsHappening');
				case 'bambi-corn':
					thing.frames = Paths.getSparrowAtlas('splitathon/Bambi_ChillingWithTheCorn');
					thing.animation.addByPrefix('justGonnaChillHereEatinCorn', 'cool', 24);
					thing.animation.play('justGonnaChillHereEatinCorn');
			}
			if (!splitathonExpressionAdded)
			{
				splitathonExpressionAdded = true;
				add(thing);
			}
			thing.antialiasing = true;
			boyfriend.stunned = false;
		}
	}
}
