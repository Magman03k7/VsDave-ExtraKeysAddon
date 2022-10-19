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

	public var ExpungedWindowCenterPos:FlxPoint = new FlxPoint(0,0);

	public var dadCombo:Int = 0;
	public static var globalFunny:CharacterFunnyEffect = CharacterFunnyEffect.None;

	public var localFunny:CharacterFunnyEffect = CharacterFunnyEffect.None;

	public var dadGroup:FlxGroup;
	public var bfGroup:FlxGroup;
	public var gfGroup:FlxGroup;

	public static var darkLevels:Array<String> = ['bambiFarmNight', 'daveHouse_night', 'unfairness', 'bedroomNight', 'backyard'];
	public var sunsetLevels:Array<String> = ['bambiFarmSunset', 'daveHouse_Sunset'];

	public var stupidx:Float = 0;
	public var stupidy:Float = 0; // stupid velocities for cutscene
	public var updatevels:Bool = false;

	public var hasTriggeredDumbshit:Bool = false;
	var AUGHHHH:String;
	var AHHHHH:String;

	public static var curmult:Array<Float> = [1, 1, 1, 1];

	public var curbg:BGSprite;
	public var pre3dSkin:String;
	#if SHADERS_ENABLED
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public static var lazychartshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
	public static var blockedShader:BlockedGlitchEffect;
	public var dither:DitherEffect = new DitherEffect();
	#end

	public var UsingNewCam:Bool = false;

	public var elapsedtime:Float = 0;

	public var elapsedexpungedtime:Float = 0;

	var focusOnDadGlobal:Bool = true;

	var funnyFloatyBoys:Array<String> = ['dave-angey', 'bambi-3d', 'expunged', 'bambi-unfair', 'exbungo', 'dave-festival-3d', 'dave-3d-recursed', 'bf-3d'];

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";

	var boyfriendOldIcon:String = 'bf-old';

	public var vocals:FlxSound;
	public var exbungo_funny:FlxSound;

	private var dad:Character;
	private var dadmirror:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var splitathonCharacterExpression:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	var nightColor:FlxColor = 0xFF878787;
	public var sunsetColor:FlxColor = FlxColor.fromRGB(255, 143, 178);

	private static var prevCamFollow:FlxObject;
	public static var recursedStaticWeek:Bool;
	

	private var strumLine:FlxSprite;
	private var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var dadStrums:FlxTypedGroup<StrumNote>;

	private var noteLimbo:Note;

	private var noteLimboFrames:Int;

	public var camZooming:Bool = false;
	public var crazyZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1;
	private var combo:Int = 0;

	public static var misses:Int = 0;

	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	private var windowSteadyX:Float;

	public static var eyesoreson = true;

	private var STUPDVARIABLETHATSHOULDNTBENEEDED:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	public var shakeCam:Bool = false;
	private var startingSong:Bool = false;

	public var TwentySixKey:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;

	private var camDialogue:FlxCamera;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var camTransition:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	public var hasDialogue:Bool = false;
	
	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	var notestuffsGuitar:Array<String> = ['LEFT', 'DOWN', 'MIDDLE', 'UP', 'RIGHT'];
	var fc:Bool = true;

	#if SHADERS_ENABLED
	var wiggleShit:WiggleEffect = new WiggleEffect();
	#end

	var talking:Bool = true;
	var songScore:Int = 0;

	var scoreTxt:FlxText;
	var kadeEngineWatermark:FlxText;
	var creditsWatermark:FlxText;
	var songName:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;
	var lockCam:Bool;
	
	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var activateSunTweens:Bool;

	var inFiveNights:Bool = false;

	var inCutscene:Bool = false;

	public var crazyBatch:String = "shutdown /r /t 0";

	public var backgroundSprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	var revertedBG:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	var canFloat:Bool = true;

	var possibleNotes:Array<Note> = [];

	var glitch:FlxSprite;
	var tweenList:Array<FlxTween> = new Array<FlxTween>();
	var pauseTweens:Array<FlxTween> = new Array<FlxTween>();

	var bfTween:ColorTween;

	var tweenTime:Float;

	var songPosBar:FlxBar;
	var songPosBG:FlxSprite;

	var bfNoteCamOffset:Array<Float> = new Array<Float>();
	var dadNoteCamOffset:Array<Float> = new Array<Float>();

	var video:VideoHandler;
	public var modchart:ExploitationModchartType;
	var weirdBG:FlxSprite;

	var mcStarted:Bool = false; 
	public var noMiss:Bool = false;
	public var creditsPopup:CreditsPopUp;
	public var blackScreen:FlxSprite;


	//bg stuff
	var baldi:BGSprite;
	var spotLight:FlxSprite;
	var spotLightPart:Bool;
	var spotLightScaler:Float = 1.3;
	var lastSinger:Character;

	var crowdPeople:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	
	var interdimensionBG:BGSprite;
	var currentInterdimensionBG:String;
	var nimbiLand:BGSprite;
	var nimbiSign:BGSprite;
	var flyingBgChars:FlxTypedGroup<FlyingBGChar> = new FlxTypedGroup<FlyingBGChar>();
	public static var isGreetingsCutscene:Bool;
	var originalPosition:FlxPoint = new FlxPoint();
	var daveFlying:Bool;
	var pressingKey5Global:Bool = false;

	var highway:FlxSprite;
	var bambiSpot:FlxSprite;
	var bfSpot:FlxSprite;
	var originalBFScale:FlxPoint;
	var originBambiPos:FlxPoint;
	var originBFPos:FlxPoint;

	var tristan:BGSprite;
	var curTristanAnim:String;

	var desertBG:BGSprite;
	var desertBG2:BGSprite;
	var sign:BGSprite;
    var georgia:BGSprite;
	var train:BGSprite;
	var trainSpeed:Float;

	var vcr:VCRDistortionShader;

	var place:BGSprite;
	var stageCheck:String = 'stage';

	// FUCKING UHH particles
	var emitter:FlxEmitter;
	var smashPhone:Array<Int> = new Array<Int>();

	//recursed
	var darkSky:BGSprite;
	var darkSky2:BGSprite;
	var darkSkyStartPos:Float = 1280;
	var resetPos:Float = -2560;
	var freeplayBG:BGSprite;
	var daveBG:String;
	var bambiBG:String;
	var tristanBG:String;
	var charBackdrop:FlxBackdrop;
	var alphaCharacters:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
	var daveSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Bonus Song'];
	var bambiSongs:Array<String> = ['Blocked', 'Corn-Theft', 'Maze', 'Mealie'];
	var tristanSongs:Array<String> = ['Adventure', 'Vs-Tristan'];
	var tristanInBotTrot:BGSprite; 

	var missedRecursedLetterCount:Int = 0;
	var recursedCovers:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var isRecursed:Bool = false;
	var recursedUI:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();

	var timeLeft:Float;
	var timeGiven:Float;
	var timeLeftText:FlxText;

	var noteCount:Int;
	var notesLeft:Int;
	var notesLeftText:FlxText;

	var preRecursedHealth:Float;
	var preRecursedSkin:String;
	var rotateCamToRight:Bool;
	var camRotateAngle:Float = 0;

	var rotatingCamTween:FlxTween;

	static var DOWNSCROLL_Y:Float;
	static var UPSCROLL_Y:Float;

	var switchSide:Bool;

	public var subtitleManager:SubtitleManager;
	
	public var guitarSection:Bool;
	public var dadStrumAmount = 4;
	public var playerStrumAmount = 4;
	
	//explpit
	var expungedBG:BGSprite;
	public static var scrollType:String;
	var preDadPos:FlxPoint = new FlxPoint();

	//window stuff
	public static var window:Window;
	var expungedScroll = new Sprite();
	var expungedSpr = new Sprite();
	var windowProperties:Array<Dynamic> = new Array<Dynamic>();
	var expungedWindowMode:Bool = false;
	var expungedOffset:FlxPoint = new FlxPoint();
	var expungedMoving:Bool = true;
	var lastFrame:FlxFrame;

	//indignancy
	var vignette:FlxSprite;
	
	//five night
	var time:FlxText;
	var times:Array<Int> = [12, 1, 2, 3, 4, 5];
	var night:FlxText;
	var powerLeft:Float = 100;
	var powerRanOut:Bool;
	var powerDrainer:Float = 1;
	var powerMeter:FlxSprite;
	var powerLeftText:FlxText;
	var powerDown:FlxSound;
	var usage:FlxText;

	var door:BGSprite;
	var doorButton:BGSprite;
	var doorClosed:Bool;
	var doorChanging:Bool;

	var banbiWindowNames:Array<String> = ['when you realize you have school this monday', 'industrial society and its future', 'my ears burn', 'i got that weed card', 'my ass itch', 'bruh', 'alright instagram its shoutout time'];
	
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

	var funnyFloatyBoys:Array<String> = ['dave-angey', 'bambi-3d', 'expunged', 'bambi-unfair', 'exbungo', 'dave-festival-3d', 'dave-3d-recursed', 'bf-3d'];

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	var botText:String = "";

	var boyfriendOldIcon:String = 'bf-old';


	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";

	var boyfriendOldIcon:String = 'bf-old';

	public var vocals:FlxSound;
	public var exbungo_funny:FlxSound;

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

	var barType:String;
	override public function create()
	{
		instance = this;

		paused = false;

		barType = FlxG.save.data.songBarOption;

		resetShader();

		switch (SONG.song.toLowerCase())
		{
			case 'exploitation':
				var programPath:String = Sys.programPath();
				var textPath = programPath.substr(0, programPath.length - CoolSystemStuff.executableFileName().length) + "help me.txt";
	
				if (FileSystem.exists(textPath))
				{
					FileSystem.deleteFile(textPath);
				}
				var path = CoolSystemStuff.getTempPath() + "/Null.vbs";
				if (FileSystem.exists(path))
				{
					FileSystem.deleteFile(path);
				}
				Main.toggleFuckedFPS(true);

				if (FlxG.save.data.exploitationState != null)
				{
					FlxG.save.data.exploitationState = 'playing';
				}
				FlxG.save.data.terminalFound = true;
				FlxG.save.flush();
				modchart = ExploitationModchartType.None;
			case 'recursed':
				daveBG = MainMenuState.randomizeBG();
				bambiBG = MainMenuState.randomizeBG();
				tristanBG = MainMenuState.randomizeBG();
			case 'vs-dave-rap' | 'vs-dave-rap-two':
				blackScreen = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.width * 2, FlxColor.BLACK);
				blackScreen.scrollFactor.set();
				add(blackScreen);
			case 'five-nights':
				inFiveNights = true;
		}
		scrollType = FlxG.save.data.downscroll ? 'downscroll' : 'upscroll';

		theFunne = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		eyesoreson = FlxG.save.data.eyesores;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;

		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyString();

		// To avoid having duplicate images in Discord assets
		switch (SONG.player2)
		{
			case 'dave' | 'dave-angey' | 'dave-3d-recursed':
				iconRPC = 'dave';
			case 'bambi-new' | 'bambi-angey' | 'bambi' | 'bambi-joke' | 'bambi-3d' | 'bambi-unfair' | 'expunged':
				iconRPC = 'bambi';
			default:
				iconRPC = 'none';
		}
		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				iconRPC = 'both';
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
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/houseDialogue'));
			case 'insanity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/insanityDialogue'));
			case 'furiosity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/furiosityDialogue'));
			case 'polygonized':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/polyDialogue'));
			case 'supernovae':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/supernovaeDialogue'));
			case 'glitch':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/glitchDialogue'));
			case 'blocked':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/retardedDialogue'));
			case 'corn-theft':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/cornDialogue'));
			case 'cheating':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/cheaterDialogue'));
			case 'unfairness':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/unfairDialogue'));
			case 'maze':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/mazeDialogue'));
			case 'splitathon':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/splitathonDialogue'));
			case 'greetings':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/greetings-cutscene'));
			case 'shredder':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/shredder'));
			case 'interdimensional':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/interdimensional'));
			case 'master':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/master'));				
		}

		var stageCheck:String = 'stage';

		if(SONG.stage == null)
		{
			switch(SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'supernovae' | 'warmup':
					stageCheck = 'house';
				case 'polygonized':
					stageCheck = 'red-void';
				case 'bonus-song':
					stageCheck = 'inside-house';
				case 'blocked' | 'corn-theft' | 'maze':
					stageCheck = 'farm';
				case 'indignancy':
					stageCheck = 'farm-night';
				case 'splitathon' | 'mealie':
					stageCheck = 'farm-night';
				case 'shredder' | 'greetings':
					stageCheck = 'festival';
				case 'interdimensional':
					stageCheck = 'interdimension-void';
				case 'rano':
					stageCheck = 'backyard';
				case 'cheating':
					stageCheck = 'green-void';
				case 'unfairness':
					stageCheck = 'glitchy-void';
				case 'exploitation':
					stageCheck = 'desktop';
				case 'kabunga':
					stageCheck = 'exbungo-land';
				case 'glitch' | 'memory':
					stageCheck = 'house-night';
				case 'secret':
					stageCheck = 'house-sunset';
				case 'vs-dave-rap' | 'vs-dave-rap-two':
					stageCheck = 'rapBattle';
				case 'recursed':
					stageCheck = 'freeplay';
				case 'roofs':
					stageCheck = 'roof';
				case 'bot-trot':
					stageCheck = 'bedroom';
				case 'escape-from-california':
					stageCheck = 'desert';
				case 'master':
					stageCheck = 'master';
				case 'overdrive':
					stageCheck = 'overdrive';
			}
		}
		else
		{
			stageCheck = SONG.stage;
		}

		backgroundSprites = createBackgroundSprites(stageCheck);
			case 'polygonized' | 'interdimensional':
				var stage = SONG.song.toLowerCase() != 'interdimensional' ? 'house-night' : 'festival';
				revertedBG = createBackgroundSprites(stage, true);
				for (bgSprite in revertedBG)
				{
					bgSprite.color = getBackgroundColor(SONG.song.toLowerCase() != 'interdimensional' ? 'daveHouse_night' : 'festival');
					bgSprite.alpha = 0;
			{
				bgSprite.alpha = 0;
			}
		}
		var gfVersion:String = 'gf';
		
		var noGFSongs = ['memory', 'five-nights', 'bot-trot', 'escape-from-california', 'overdrive'];
		
		if(SONG.gf != null)
		{
			gfVersion = SONG.gf;
		}
		if (formoverride == "bf-pixel")
		{
			gfVersion = 'gf-pixel';
		}
		if (SONG.player1 == 'bf-cool')
		{
			gfVersion = 'gf-cool';
		}
		if (SONG.player1 == 'tb-funny-man')
		{
			gfVersion = 'stereo';
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

		//char repositioning
		repositionChar(dad);
		if (dadmirror != null)
		{
			repositionChar(dadmirror);
		}
		repositionChar(boyfriend);
		repositionChar(gf);

		var font:String = Paths.font("comic.ttf");
		var fontScaler:Int = 1;
	
		switch (SONG.song.toLowerCase())
		{
			case 'five-nights':
				font = Paths.font('fnaf.ttf');
				fontScaler = 2;
		}

		if (FlxG.save.data.songPosition && !isGreetingsCutscene && !['five-nights', 'overdrive'].contains(SONG.song.toLowerCase()))
		{
			var yPos = scrollType == 'downscroll' ? FlxG.height * 0.9 + 20 : strumLine.y - 20;

			songPosBG = new FlxSprite(0, yPos).loadGraphic(Paths.image('ui/timerBar'));
			songPosBG.antialiasing = true;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);
			
			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), Conductor, 
			'songPosition', 0, FlxG.sound.music.length);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.fromRGB(57, 255, 20));
			insert(members.indexOf(songPosBG), songPosBar);
			
			songName = new FlxText(songPosBG.x, songPosBG.y, 0, "", 32);
			songName.text = (barType == 'ShowTime' ? '0:00' : barType == 'SongName' ? SONG.song : '');
			songName.setFormat(font, 32 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			songName.scrollFactor.set();
			songName.borderSize = 2.5 * fontScaler;
			songName.antialiasing = true;
			if (barType == 'ShowTime')
			{
				songName.alpha = 0;
			}

			var xValues = CoolUtil.getMinAndMax(songName.width, songPosBG.width);
			var yValues = CoolUtil.getMinAndMax(songName.height, songPosBG.height);
			
			songName.x = songPosBG.x - ((xValues[0] - xValues[1]) / 2);
			songName.y = songPosBG.y + ((yValues[0] - yValues[1]) / 2);

			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		if (inFiveNights)
		{
			time = new FlxText(1175, 24, 0, '12 AM', 60);
			time.setFormat(Paths.font('fnaf.ttf'), 60, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			time.scrollFactor.set();
			time.antialiasing = false;
			time.borderSize = 2.5;
			time.cameras = [camHUD];
			add(time);

			night = new FlxText(1175, 70, 0, 'Night 7', 34);
			night.setFormat(Paths.font('fnaf.ttf'), 34, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			night.scrollFactor.set();
			night.antialiasing = false;
			night.borderSize = 2.5;
			night.cameras = [camHUD];
			add(night);

			powerLeftText = new FlxText(1100, 650, 0, 'Power Left: 100%', 34);
			powerLeftText.setFormat(Paths.font('fnaf.ttf'), 34, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			powerLeftText.scrollFactor.set();
			powerLeftText.antialiasing = false;
			powerLeftText.borderSize = 2;
			powerLeftText.cameras = [camHUD];
			add(powerLeftText);

			usage = new FlxText(1100, 685, 0, 'Usage: ', 34);
			usage.setFormat(Paths.font('fnaf.ttf'), 34, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			usage.scrollFactor.set();
			usage.antialiasing = false;
			usage.borderSize = 2;
			usage.cameras = [camHUD];
			add(usage);
			
			powerMeter = new FlxSprite(1170, 683).loadGraphic(Paths.image('fiveNights/powerMeter'));
			powerMeter.scrollFactor.set();
			powerMeter.cameras = [camHUD];
			add(powerMeter);
		}
		
		var healthBarPath = '';
		switch (SONG.song.toLowerCase())
		{
			case 'exploitation':
				healthBarPath = Paths.image('ui/HELLthBar');
			case 'overdrive':
				healthBarPath = Paths.image('ui/fnfengine');
			case 'five-nights':
				healthBarPath = Paths.image('ui/fnafengine');
			default:
				healthBarPath = Paths.image('ui/healthBar');
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(healthBarPath);
		if (scrollType == 'downscroll')
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.antialiasing = true;
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, inFiveNights ? LEFT_TO_RIGHT : RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
		insert(members.indexOf(healthBarBG), healthBar);

		var credits:String;
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae':
				credits = LanguageManager.getTextString('supernovae_credit');
			case 'glitch':
				credits = LanguageManager.getTextString('glitch_credit');
			case 'unfairness':
				credits = LanguageManager.getTextString('unfairness_credit');
			case 'cheating':
				credits = LanguageManager.getTextString('cheating_credit');
			case 'exploitation':
				credits = LanguageManager.getTextString('exploitation_credit') + " " + (FlxG.save.data.selfAwareness ? CoolSystemStuff.getUsername() : 'Boyfriend') + "!";
			case 'kabunga':
				credits = LanguageManager.getTextString('kabunga_credit');
			default:
				credits = '';
		}
		var creditsText:Bool = credits != '';
		var textYPos:Float = healthBarBG.y + 50;
		if (creditsText)
		{
			textYPos = healthBarBG.y + 30;
		}
		
		var funkyText:String;

		switch(SONG.song.toLowerCase())
		{
			case "exploitation":
				funkyText = SONG.song;
			case 'overdrive':
				funkyText = '';
			default:
				funkyText = SONG.song;
		}

		if (!isGreetingsCutscene)
		{
			kadeEngineWatermark = new FlxText(4, textYPos, 0, funkyText, 16);

			kadeEngineWatermark.setFormat(font, 16 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			kadeEngineWatermark.scrollFactor.set();
			kadeEngineWatermark.borderSize = 1.25 * fontScaler;
			kadeEngineWatermark.antialiasing = true;
			add(kadeEngineWatermark);
		}
		if (creditsText)
		{
			creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
			creditsWatermark.setFormat(font, 16 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			creditsWatermark.scrollFactor.set();
			creditsWatermark.borderSize = 1.25 * fontScaler;
			creditsWatermark.antialiasing = true;
			add(creditsWatermark);
			creditsWatermark.cameras = [camHUD];
		}
		switch (curSong.toLowerCase())
		{
			case 'insanity':
				preload('backgrounds/void/redsky');
				preload('backgrounds/void/redsky_insanity');
			case 'polygonized':
				preload('characters/3d_bf');
				preload('characters/3d_gf');
			case 'maze':
				preload('spotLight');
			case 'shredder':
				preload('festival/bambi_shredder');
				for (asset in ['bambi_spot', 'boyfriend_spot', 'ch_highway'])
				{
					preload('festival/shredder/${asset}');
				}
			case 'interdimensional':
				preload('backgrounds/void/interdimensions/interdimensionVoid');
				preload('backgrounds/void/interdimensions/spike');
				preload('backgrounds/void/interdimensions/darkSpace');
				preload('backgrounds/void/interdimensions/hexagon');
				preload('backgrounds/void/interdimensions/nimbi/nimbiVoid');
				preload('backgrounds/void/interdimensions/nimbi/nimbi_land');
				preload('backgrounds/void/interdimensions/nimbi/nimbi');
			case 'mealie':
				preload('bambi/im_gonna_break_me_phone');
			case 'recursed':
				switch (boyfriend.curCharacter)
				{
					case 'dave':
						preload('recursed/characters/Dave_Recursed');
					case 'bambi-new':
						preload('recursed/characters/Bambi_Recursed');
					case 'tb-funny-man':
						preload('recursed/characters/STOP_LOOKING_AT_THE_FILES');
					case 'tristan' | 'tristan-golden':
						preload('recursed/characters/TristanRecursed');
					case 'dave-angey':
						preload('recursed/characters/Dave_3D_Recursed');
					default:
						preload('recursed/Recursed_BF');
				}
			case 'exploitation':
				preload('ui/glitch/glitchSwitch');
				preload('backgrounds/void/exploit/cheater GLITCH');
				preload('backgrounds/void/exploit/glitchyUnfairBG');
				preload('backgrounds/void/exploit/expunged_chains');
				preload('backgrounds/void/exploit/broken_expunged_chain');
				preload('backgrounds/void/exploit/glitchy_cheating_2');
			case 'bot-trot':
				preload('backgrounds/bedroom/night/bed');
				preload('backgrounds/bedroom/night/bg');
				preload('playrobot/playrobot_shadow');
			case 'escape-from-california':
				for (spr in ['1500miles', '1000miles', '500miles', 'welcomeToGeorgia', 'georgia'])
				{
					preload('california/$spr');
				}
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 40, FlxG.width, "", 20);
		scoreTxt.setFormat((SONG.song.toLowerCase() == "overdrive") ? Paths.font("ariblk.ttf") : font, 20 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5 * fontScaler;
		scoreTxt.antialiasing = true;
		scoreTxt.screenCenter(X);
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

		if (inFiveNights)
		{
			iconP2 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, false);
			iconP2.y = healthBar.y - (iconP2.height / 2);
			add(iconP2);

			iconP1 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, true);
			iconP1.y = healthBar.y - (iconP1.height / 2);
			add(iconP1);
		}
		else
		{
			iconP1 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, true);
			iconP1.y = healthBar.y - (iconP1.height / 2);
			add(iconP1);

			iconP2 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, false);
			iconP2.y = healthBar.y - (iconP2.height / 2);
			add(iconP2);
		}
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		if (kadeEngineWatermark != null)
		{
			kadeEngineWatermark.cameras = [camHUD];
		}
		doof.cameras = [camDialogue];
		
		#if SHADERS_ENABLED
		if (SONG.song.toLowerCase() == 'kabunga' || localFunny == CharacterFunnyEffect.Exbungo) //i desperately wanted it so if you use downscroll it switches it to upscroll and flips the entire hud upside down but i never got to it
		{
			lazychartshader.waveAmplitude = 0.03;
			lazychartshader.waveFrequency = 5;
			lazychartshader.waveSpeed = 1;

			camHUD.setFilters([new ShaderFilter(lazychartshader.shader)]);
		}
		if (SONG.song.toLowerCase() == 'blocked' || SONG.song.toLowerCase() == 'shredder')
		{
			blockedShader = new BlockedGlitchEffect(1280, 1, 1, true);
		}
		#end
		startingSong = true;
		if (startTimer != null && !startTimer.active)
		{
			startTimer.active = true;
		}
		if (isStoryMode || localFunny == CharacterFunnyEffect.Recurser)
		{
			if (hasDialogue)
			{
				schoolIntro(doof);
			}
			else
			{
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
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
		
		subtitleManager = new SubtitleManager();
		subtitleManager.cameras = [camHUD];
		add(subtitleManager);

		exbungo_funny = FlxG.sound.load(Paths.sound('amen_' + FlxG.random.int(1, 6)));
		exbungo_funny.volume = 0.91;

		super.create();

		Transition.nextCamera = camTransition;
	}
	
	public function createBackgroundSprites(bgName:String, revertedBG:Bool):FlxTypedGroup<BGSprite>
	{
		var sprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
		var bgZoom:Float = 0.7;
		var stageName:String = '';
		switch (bgName)
		{
			case 'house' | 'house-night' | 'house-sunset':
				bgZoom = 0.8;
				
				var skyType:String = '';
				var assetType:String = '';
				switch (bgName)
				{
					case 'house':
						stageName = 'daveHouse';
						skyType = 'sky';
					case 'house-night':
						stageName = 'daveHouse_night';
						skyType = 'sky_night';
						assetType = 'night/';
					case 'house-sunset':
						stageName = 'daveHouse_sunset';
						skyType = 'sky_sunset';
				}
				var bg:BGSprite = new BGSprite('bg', -600, -300, Paths.image('backgrounds/shared/${skyType}'), null, 0.6, 0.6);
				sprites.add(bg);
				add(bg);
				
				var stageHills:BGSprite = new BGSprite('stageHills', -834, -159, Paths.image('backgrounds/dave-house/${assetType}hills'), null, 0.7, 0.7);
				sprites.add(stageHills);
				add(stageHills);

				var grassbg:BGSprite = new BGSprite('grassbg', -1205, 580, Paths.image('backgrounds/dave-house/${assetType}grass bg'), null);
				sprites.add(grassbg);
				add(grassbg);
	
				var gate:BGSprite = new BGSprite('gate', -755, 250, Paths.image('backgrounds/dave-house/${assetType}gate'), null);
				sprites.add(gate);
				add(gate);
	
				var stageFront:BGSprite = new BGSprite('stageFront', -832, 505, Paths.image('backgrounds/dave-house/${assetType}grass'), null);
				sprites.add(stageFront);
				add(stageFront);

				if (SONG.song.toLowerCase() == 'insanity' || localFunny == CharacterFunnyEffect.Recurser)
				{
					var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/void/redsky_insanity'), null, 1, 1, true, true);
					bg.alpha = 0.75;
					bg.visible = false;
					add(bg);
					// below code assumes shaders are always enabled which is bad
					voidShader(bg);
				}

				var variantColor = getBackgroundColor(stageName);
				if (stageName != 'daveHouse_night')
				{
					stageHills.color = variantColor;
					grassbg.color = variantColor;
					gate.color = variantColor;
					stageFront.color = variantColor;
				}
			case 'inside-house':
				bgZoom = 0.6;
				stageName = 'insideHouse';

				var bg:BGSprite = new BGSprite('bg', -1000, -350, Paths.image('backgrounds/inside_house'), null);
				sprites.add(bg);
				add(bg);

			case 'farm' | 'farm-night' | 'farm-sunset':
				bgZoom = 0.8;

				switch (bgName.toLowerCase())
				{
					case 'farm-night':
						stageName = 'bambiFarmNight';
					case 'farm-sunset':
						stageName = 'bambiFarmSunset';
					default:
						stageName = 'bambiFarm';
				}
	
				var skyType:String = stageName == 'bambiFarmNight' ? 'sky_night' : stageName == 'bambiFarmSunset' ? 'sky_sunset' : 'sky';
				
				var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/shared/' + skyType), null, 0.6, 0.6);
				sprites.add(bg);
				add(bg);

				if (SONG.song.toLowerCase() == 'maze')
				{
					var sunsetBG:BGSprite = new BGSprite('sunsetBG', -600, -200, Paths.image('backgrounds/shared/sky_sunset'), null, 0.6, 0.6);
					sunsetBG.alpha = 0;
					sprites.add(sunsetBG);
					add(sunsetBG);

					var nightBG:BGSprite = new BGSprite('nightBG', -600, -200, Paths.image('backgrounds/shared/sky_night'), null, 0.6, 0.6);
					nightBG.alpha = 0;
					sprites.add(nightBG);
					add(nightBG);
					if (isStoryMode)
					{
						health -= 0.2;
					}
				}
				var flatgrass:BGSprite = new BGSprite('flatgrass', 350, 75, Paths.image('backgrounds/farm/gm_flatgrass'), null, 0.65, 0.65);
				flatgrass.setGraphicSize(Std.int(flatgrass.width * 0.34));
				flatgrass.updateHitbox();
				sprites.add(flatgrass);
				
				var hills:BGSprite = new BGSprite('hills', -173, 100, Paths.image('backgrounds/farm/orangey hills'), null, 0.65, 0.65);
				sprites.add(hills);
				
				var farmHouse:BGSprite = new BGSprite('farmHouse', 100, 125, Paths.image('backgrounds/farm/funfarmhouse', 'shared'), null, 0.7, 0.7);
				farmHouse.setGraphicSize(Std.int(farmHouse.width * 0.9));
				farmHouse.updateHitbox();
				sprites.add(farmHouse);

				var grassLand:BGSprite = new BGSprite('grassLand', -600, 500, Paths.image('backgrounds/farm/grass lands', 'shared'), null);
				sprites.add(grassLand);

				var cornFence:BGSprite = new BGSprite('cornFence', -400, 200, Paths.image('backgrounds/farm/cornFence', 'shared'), null);
				sprites.add(cornFence);
				
				var cornFence2:BGSprite = new BGSprite('cornFence2', 1100, 200, Paths.image('backgrounds/farm/cornFence2', 'shared'), null);
				sprites.add(cornFence2);

				var bagType = FlxG.random.int(0, 1000) == 0 ? 'popeye' : 'cornbag';
				var cornBag:BGSprite = new BGSprite('cornFence2', 1200, 550, Paths.image('backgrounds/farm/$bagType', 'shared'), null);
				sprites.add(cornBag);
				
				var sign:BGSprite = new BGSprite('sign', 0, 350, Paths.image('backgrounds/farm/sign', 'shared'), null);
				sprites.add(sign);

				var variantColor:FlxColor = getBackgroundColor(stageName);
				
				flatgrass.color = variantColor;
				hills.color = variantColor;
				farmHouse.color = variantColor;
				grassLand.color = variantColor;
				cornFence.color = variantColor;
				cornFence2.color = variantColor;
				cornBag.color = variantColor;
				sign.color = variantColor;
				
				add(flatgrass);
				add(hills);
				add(farmHouse);
				add(grassLand);
				add(cornFence);
				add(cornFence2);
				add(cornBag);
				add(sign);

				if (['blocked', 'corn-theft', 'maze', 'mealie', 'indignancy'].contains(SONG.song.toLowerCase()) && !MathGameState.failedGame && FlxG.random.int(0, 4) == 0)
				{
					FlxG.mouse.visible = true;
					baldi = new BGSprite('baldi', 400, 110, Paths.image('backgrounds/farm/baldo', 'shared'), null, 0.65, 0.65);
					baldi.setGraphicSize(Std.int(baldi.width * 0.31));
					baldi.updateHitbox();
					baldi.color = variantColor;
					sprites.insert(members.indexOf(hills), baldi);
					insert(members.indexOf(hills), baldi);
				}

				if (SONG.song.toLowerCase() == 'splitathon')
				{
					var picnic:BGSprite = new BGSprite('picnic', 1050, 650, Paths.image('backgrounds/farm/picnic_towel_thing', 'shared'), null);
					sprites.insert(sprites.members.indexOf(cornBag), picnic);
					picnic.color = variantColor;
					insert(members.indexOf(cornBag), picnic);
				}
			case 'festival':
				bgZoom = 0.7;
				stageName = 'festival';
				
				var mainChars:Array<Dynamic> = null;
				switch (SONG.song.toLowerCase())
				{
					case 'shredder':
						mainChars = [
							//char name, prefix, size, x, y, flip x
							['dave', 'idle', 0.8, 175, 100],
							['tristan', 'bop', 0.4, 800, 325]
						];
					case 'greetings':
						if (isGreetingsCutscene)
						{
							mainChars = [
								['bambi', 'bambi idle', 0.9, 400, 350],
								['tristan', 'bop', 0.4, 800, 325]
							];
						}
						else
						{
							mainChars = [
								['dave', 'idle', 0.8, 175, 100],
								['bambi', 'bambi idle', 0.9, 700, 350],
							];
						}
					case 'interdimensional':
						mainChars = [
							['bambi', 'bambi idle', 0.9, 400, 350],
							['tristan', 'bop', 0.4, 800, 325]
						];
				}
				var bg:BGSprite = new BGSprite('bg', -600, -230, Paths.image('backgrounds/shared/sky_festival'), null, 0.6, 0.6);
				sprites.add(bg);
				add(bg);

				var flatGrass:BGSprite = new BGSprite('flatGrass', 800, -100, Paths.image('backgrounds/festival/gm_flatgrass'), null, 0.7, 0.7);
				sprites.add(flatGrass);
				add(flatGrass);

				var farmHouse:BGSprite = new BGSprite('farmHouse', -300, -150, Paths.image('backgrounds/festival/farmHouse'), null, 0.7, 0.7);
				sprites.add(farmHouse);
				add(farmHouse);
				
				var hills:BGSprite = new BGSprite('hills', -1000, -100, Paths.image('backgrounds/festival/hills'), null, 0.7, 0.7);
				sprites.add(hills);
				add(hills);

				var corn:BGSprite = new BGSprite('corn', -1000, 120, 'backgrounds/festival/corn', [
					new Animation('corn', 'idle', 5, true, [false, false])
				], 0.85, 0.85, true, true);
				corn.animation.play('corn');
				sprites.add(corn);
				add(corn);

				var cornGlow:BGSprite = new BGSprite('cornGlow', -1000, 120, 'backgrounds/festival/cornGlow', [
					new Animation('cornGlow', 'idle', 5, true, [false, false])
				], 0.85, 0.85, true, true);
				cornGlow.blend = BlendMode.ADD;
				cornGlow.animation.play('cornGlow');
				sprites.add(cornGlow);
				add(cornGlow);
				
				var backGrass:BGSprite = new BGSprite('backGrass', -1000, 475, Paths.image('backgrounds/festival/backGrass'), null, 0.85, 0.85);
				sprites.add(backGrass);
				add(backGrass);
				
				var crowd = new BGSprite('crowd', -500, -150, 'backgrounds/festival/crowd', [
					new Animation('idle', 'crowdDance', 24, true, [false, false])
				], 0.85, 0.85, true, true);
				crowd.animation.play('idle');
				sprites.add(crowd);
				crowdPeople.add(crowd);
				add(crowd);
				
				for (i in 0...mainChars.length)
				{					
					var crowdChar = new BGSprite(mainChars[i][0], mainChars[i][3], mainChars[i][4], 'backgrounds/festival/mainCrowd/${mainChars[i][0]}', [
						new Animation('idle', mainChars[i][1], 24, false, [false, false], null)
					], 0.85, 0.85, true, true);
					crowdChar.setGraphicSize(Std.int(crowdChar.width * mainChars[i][2]));
					crowdChar.updateHitbox();
					sprites.add(crowdChar);
					crowdPeople.add(crowdChar);
					add(crowdChar);
				}
				
				var frontGrass:BGSprite = new BGSprite('frontGrass', -1300, 600, Paths.image('backgrounds/festival/frontGrass'), null, 1, 1);
				sprites.add(frontGrass);
				add(frontGrass);

				var stageGlow:BGSprite = new BGSprite('stageGlow', -450, 300, 'backgrounds/festival/generalGlow', [
					new Animation('glow', 'idle', 5, true, [false, false])
				], 0, 0, true, true);
				stageGlow.blend = BlendMode.ADD;
				stageGlow.animation.play('glow');
				sprites.add(stageGlow);
				add(stageGlow);

			case 'backyard':
				bgZoom = 0.7;
				stageName = 'backyard';

				var festivalSky:BGSprite = new BGSprite('bg', -600, -400, Paths.image('backgrounds/shared/sky_festival'), null, 0.6, 0.6);
				sprites.add(festivalSky);
				add(festivalSky);

				if (SONG.song.toLowerCase() == 'rano')
				{
					var sunriseBG:BGSprite = new BGSprite('sunriseBG', -600, -400, Paths.image('backgrounds/shared/sky_sunrise'), null, 0.6, 0.6);
					sunriseBG.alpha = 0;
					sprites.add(sunriseBG);
					add(sunriseBG);

					var skyBG:BGSprite = new BGSprite('bg', -600, -400, Paths.image('backgrounds/shared/sky'), null, 0.6, 0.6);
					skyBG.alpha = 0;
					sprites.add(skyBG);
					add(skyBG);
				}

				var hills:BGSprite = new BGSprite('hills', -1330, -432, Paths.image('backgrounds/backyard/hills', 'shared'), null, 0.75, 0.75, true);
				sprites.add(hills);
				add(hills);

				var grass:BGSprite = new BGSprite('grass', -800, 150, Paths.image('backgrounds/backyard/supergrass', 'shared'), null, 1, 1, true);
				sprites.add(grass);
				add(grass);

				var gates:BGSprite = new BGSprite('gates', 564, -33, Paths.image('backgrounds/backyard/gates', 'shared'), null, 1, 1, true);
				sprites.add(gates);
				add(gates);
				
				var bear:BGSprite = new BGSprite('bear', -1035, -710, Paths.image('backgrounds/backyard/bearDude', 'shared'), null, 0.95, 0.95, true);
				sprites.add(bear);
				add(bear);

				var house:BGSprite = new BGSprite('house', -1025, -323, Paths.image('backgrounds/backyard/house', 'shared'), null, 0.95, 0.95, true);
				sprites.add(house);
				add(house);

				var grill:BGSprite = new BGSprite('grill', -489, 452, Paths.image('backgrounds/backyard/grill', 'shared'), null, 0.95, 0.95, true);
				sprites.add(grill);
				add(grill);

				var variantColor = getBackgroundColor(stageName);

				hills.color = variantColor;
				bear.color = variantColor;
				grass.color = variantColor;
				gates.color = variantColor;
				house.color = variantColor;
				grill.color = variantColor;
			case 'desktop':
				bgZoom = 0.5;
				stageName = 'desktop';

				expungedBG = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
				expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/creepyRoom', 'shared'));
				expungedBG.setPosition(0, 200);
				expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
				expungedBG.scrollFactor.set();
				expungedBG.antialiasing = false;
				sprites.add(expungedBG);
				add(expungedBG);
				voidShader(expungedBG);
			case 'red-void' | 'green-void' | 'glitchy-void':
				bgZoom = 0.7;

				var bg:BGSprite = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
				
				switch (bgName.toLowerCase())
				{
					case 'red-void':
						bgZoom = 0.8;
						bg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
						stageName = 'daveEvilHouse';
					case 'green-void':
						stageName = 'cheating';
						bg.loadGraphic(Paths.image('backgrounds/void/cheater'));
						bg.setPosition(-700, -350);
						bg.setGraphicSize(Std.int(bg.width * 2));
					case 'glitchy-void':
						bg.loadGraphic(Paths.image('backgrounds/void/scarybg'));
						bg.setPosition(0, 200);
						bg.setGraphicSize(Std.int(bg.width * 3));
						stageName = 'unfairness';
				}
				sprites.add(bg);
				add(bg);
				voidShader(bg);
			case 'interdimension-void':
				bgZoom = 0.6;
				stageName = 'interdimension';

				var bg:BGSprite = new BGSprite('void', -700, -350, Paths.image('backgrounds/void/interdimensions/interdimensionVoid'), null, 1, 1, false, true);
				bg.setGraphicSize(Std.int(bg.width * 1.75));
				sprites.add(bg);
				add(bg);

				voidShader(bg);
				
				interdimensionBG = bg;

				for (char in ['ball', 'bimpe', 'maldo', 'memes kids', 'muko', 'ruby man', 'tristan', 'bambi'])
				{
					var bgChar = new FlyingBGChar(char, Paths.image('backgrounds/festival/scaredCrowd/$char'));
					sprites.add(bgChar);
					flyingBgChars.add(bgChar);
				}
				add(flyingBgChars);
			case 'exbungo-land':
				bgZoom = 0.7;
				stageName = 'kabunga';
				
				var bg:BGSprite = new BGSprite('bg', -320, -160, Paths.image('backgrounds/void/exbongo/Exbongo'), null, 1, 1, true, true);
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				sprites.add(bg);
				add(bg);

				var circle:BGSprite = new BGSprite('circle', -30, 550, Paths.image('backgrounds/void/exbongo/Circle'), null);
				sprites.add(circle);	
				add(circle);

				place = new BGSprite('place', 860, -15, Paths.image('backgrounds/void/exbongo/Place'), null);
				sprites.add(place);	
				add(place);
				
				voidShader(bg);
			case 'rapBattle':
				bgZoom = 1;
				stageName = 'rapLand';

				var bg:BGSprite = new BGSprite('rapBG', -640, -360, Paths.image('backgrounds/rapBattle'), null);
				sprites.add(bg);
				add(bg);
			case 'freeplay':
				bgZoom = 0.4;
				stageName = 'freeplay';
				
				darkSky = new BGSprite('darkSky', darkSkyStartPos, 0, Paths.image('recursed/darkSky'), null, 1, 1, true);
				darkSky.scale.set((1 / bgZoom) * 2, 1 / bgZoom);
				darkSky.updateHitbox();
				darkSky.y = (FlxG.height - darkSky.height) / 2;
				add(darkSky);
				
				darkSky2 = new BGSprite('darkSky', darkSky.x - darkSky.width, 0, Paths.image('recursed/darkSky'), null, 1, 1, true);
				darkSky2.scale.set((1 / bgZoom) * 2, 1 / bgZoom);
				darkSky2.updateHitbox();
				darkSky2.x = darkSky.x - darkSky.width;
				darkSky2.y = (FlxG.height - darkSky2.height) / 2;
				add(darkSky2);

				freeplayBG = new BGSprite('freeplay', 0, 0, daveBG, null, 0, 0, true);
				freeplayBG.setGraphicSize(Std.int(freeplayBG.width * 2));
				freeplayBG.updateHitbox();
				freeplayBG.screenCenter();
				freeplayBG.color = FlxColor.multiply(0xFF4965FF, FlxColor.fromRGB(44, 44, 44));
				freeplayBG.alpha = 0;
				add(freeplayBG);
				
				charBackdrop = new FlxBackdrop(Paths.image('recursed/daveScroll'), 1, 1, true, true);
				charBackdrop.antialiasing = true;
				charBackdrop.scale.set(2, 2);
				charBackdrop.screenCenter();
				charBackdrop.color = FlxColor.multiply(charBackdrop.color, FlxColor.fromRGB(44, 44, 44));
				charBackdrop.alpha = 0;
				add(charBackdrop);

				initAlphabet(daveSongs);
			case 'roof':
				bgZoom = 0.8;
				stageName = 'roof';
				var roof:BGSprite = new BGSprite('roof', -584, -397, Paths.image('backgrounds/gm_house5', 'shared'), null, 1, 1, true);
				roof.setGraphicSize(Std.int(roof.width * 2));
				roof.antialiasing = false;
				add(roof);
			case 'bedroom':
				bgZoom = 0.8;
				stageName = 'bedroom';
				
				var sky:BGSprite = new BGSprite('nightSky', -285, 318, Paths.image('backgrounds/bedroom/sky', 'shared'), null, 0.8, 0.8, true);
				sprites.add(sky);
				add(sky);

				var bg:BGSprite = new BGSprite('bg', -687, 0, Paths.image('backgrounds/bedroom/bg', 'shared'), null, 1, 1, true);
				sprites.add(bg);
				add(bg);

				var baldi:BGSprite = new BGSprite('baldi', 788, 788, Paths.image('backgrounds/bedroom/bed', 'shared'), null, 1, 1, true);
				sprites.add(baldi);
				add(baldi);

				tristanInBotTrot = new BGSprite('tristan', 888, 688, 'backgrounds/bedroom/TristanSitting', [
					new Animation('idle', 'daytime', 24, true, [false, false]),
					new Animation('idleNight', 'nighttime', 24, true, [false, false])
				], 1, 1, true, true);
				tristanInBotTrot.setGraphicSize(Std.int(tristanInBotTrot.width * 0.8));
				tristanInBotTrot.animation.play('idle');
				add(tristanInBotTrot);
				if (formoverride == 'tristan' || formoverride == 'tristan-golden' || formoverride == 'tristan-golden-glowing') {
					remove(tristanInBotTrot);	
			    }
			case 'office':
				bgZoom = 0.9;
				stageName = 'office';
				
				var backFloor:BGSprite = new BGSprite('backFloor', -500, -310, Paths.image('backgrounds/office/backFloor'), null, 1, 1);
				sprites.add(backFloor);
				add(backFloor);
			case 'desert':
				bgZoom = 0.5;
				stageName = 'desert';

				var bg:BGSprite = new BGSprite('bg', -900, -400, Paths.image('backgrounds/shared/sky'), null, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				sprites.add(bg);
				add(bg);

				var sunsetBG:BGSprite = new BGSprite('sunsetBG', -900, -400, Paths.image('backgrounds/shared/sky_sunset'), null, 0.2, 0.2);
				sunsetBG.setGraphicSize(Std.int(sunsetBG.width * 2));
				sunsetBG.updateHitbox();
				sunsetBG.alpha = 0;
				sprites.add(sunsetBG);
				add(sunsetBG);
				
				var nightBG:BGSprite = new BGSprite('nightBG', -900, -400, Paths.image('backgrounds/shared/sky_night'), null, 0.2, 0.2);
				nightBG.setGraphicSize(Std.int(nightBG.width * 2));
				nightBG.updateHitbox();
				nightBG.alpha = 0;
				sprites.add(nightBG);
				add(nightBG);
				
				desertBG = new BGSprite('desert', -786, -500, Paths.image('backgrounds/wedcape_from_cali_backlground', 'shared'), null, 1, 1, true);
				desertBG.setGraphicSize(Std.int(desertBG.width * 1.2));
				desertBG.updateHitbox();
				sprites.add(desertBG);
				add(desertBG);

				desertBG2 = new BGSprite('desert2', desertBG.x - desertBG.width, desertBG.y, Paths.image('backgrounds/wedcape_from_cali_backlground', 'shared'), null, 1, 1, true);
				desertBG2.setGraphicSize(Std.int(desertBG2.width * 1.2));
				desertBG2.updateHitbox();
				sprites.add(desertBG2);
				add(desertBG2);
				
				sign = new BGSprite('sign', 500, 450, Paths.image('california/leavingCalifornia', 'shared'), null, 1, 1, true);
				sprites.add(sign);
				add(sign);

				train = new BGSprite('train', -800, 500, 'california/train', [
					new Animation('idle', 'trainRide', 24, true, [false, false])
				], 1, 1, true, true);
				train.animation.play('idle');
				train.setGraphicSize(Std.int(train.width * 2.5));
				train.updateHitbox();
				train.antialiasing = false;
				sprites.add(train);
				add(train);
			case 'master':
				bgZoom = 0.4;
				stageName = 'master';

				var space:BGSprite = new BGSprite('space', -1724, -971, Paths.image('backgrounds/shared/sky_space'), null, 1.2, 1.2);
				space.setGraphicSize(Std.int(space.width * 10));
				space.antialiasing = false;
				sprites.add(space);
				add(space);
	
				var land:BGSprite = new BGSprite('land', 675, 555, Paths.image('backgrounds/dave-house/land'), null, 0.9, 0.9);
				sprites.add(land);
				add(land);
			case 'overdrive':
				bgZoom = 0.8;
				stageName = 'overdrive';

				var stfu:BGSprite = new BGSprite('stfu', -583, -383, Paths.image('backgrounds/stfu'), null, 1, 1);
				sprites.add(stfu);
				add(stfu);
			default:
				bgZoom = 0.9;
				stageName = 'stage';

				var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/stage/stageback'), null, 0.9, 0.9);
				sprites.add(bg);
				add(bg);
	
				var stageFront:BGSprite = new BGSprite('stageFront', -650, 600, Paths.image('backgrounds/stage/stagefront'), null, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				sprites.add(stageFront);
				add(stageFront);
	
				var stageCurtains:BGSprite = new BGSprite('stageCurtains', -500, -300, Paths.image('backgrounds/stage/stagecurtains'), null, 1.3, 1.3);
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				sprites.add(stageCurtains);
				add(stageCurtains);
		}
		if (!revertedBG)
		{
			defaultCamZoom = bgZoom;
			curStage = stageName;
		}

		return sprites;
	}
	public function getBackgroundColor(stage:String):FlxColor
	{
		var variantColor:FlxColor = FlxColor.WHITE;
		switch (stage)
		{
			case 'bambiFarmNight' | 'daveHouse_night' | 'backyard' | 'bedroomNight':
				variantColor = nightColor;
			case 'bambiFarmSunset' | 'daveHouse_sunset':
				variantColor = sunsetColor;
			default:
				variantColor = FlxColor.WHITE;
		}
		return variantColor;
				
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
			case 'blocked':
				switch (curStep)
				{
					case 128:
						defaultCamZoom += 0.1;
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub1'), 0.02, 1);
					case 165:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub2'), 0.02, 1);
					case 188:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub3'), 0.02, 1);
					case 224:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub4'), 0.02, 1);
					case 248:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub5'), 0.02, 0.5, {subtitleSize: 60});
					case 256:
						defaultCamZoom -= 0.1;
						FlxG.camera.flash();
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 640:
						FlxG.camera.flash();
						black.alpha = 0.6;
						defaultCamZoom += 0.1;
					case 768:
						FlxG.camera.flash();
						defaultCamZoom -= 0.1;
						black.alpha = 0;
					case 1028:
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub6'), 0.02, 1.5);
					case 1056:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub7'), 0.02, 1);
					case 1084:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub8'), 0.02, 1);
					case 1104:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub9'), 0.02, 1);
					case 1118:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub10'), 0.02, 1);
					case 1143:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub11'), 0.02, 1, {subtitleSize: 45});
						makeInvisibleNotes(false);
					case 1152:
						FlxTween.tween(black, {alpha: 0.4}, 1);
						defaultCamZoom += 0.3;
					case 1200:
						#if SHADERS_ENABLED
						if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
							{
								camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
							}
						#end
						FlxTween.tween(black, {alpha: 0.7}, (Conductor.stepCrochet / 1000) * 8);
					case 1216:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						camHUD.setFilters([]);
						remove(black);
						defaultCamZoom -= 0.3;
				}
			case 'corn-theft':
				switch (curStep)
				{
					case 668:
						defaultCamZoom += 0.1;
					case 784:
						defaultCamZoom += 0.1;
					case 848:
						defaultCamZoom -= 0.2;
					case 916:
						FlxG.camera.flash();
					case 935:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub1'), 0.02, 1);
					case 945:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub2'), 0.02, 1);
					case 976:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub3'), 0.02, 0.5);
					case 982:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub4'), 0.02, 1);
					case 992:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub5'), 0.02, 1);
					case 1002:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub6'), 0.02, 0.3);
					case 1007:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub7'), 0.02, 0.3);
					case 1033:
						subtitleManager.addSubtitle("Bye Baa!", 0.02, 0.3, {subtitleSize: 45});
						FlxTween.tween(dad, {alpha: 0}, (Conductor.stepCrochet / 1000) * 6);
						FlxTween.tween(black, {alpha: 0}, (Conductor.stepCrochet / 1000) * 6);
						FlxTween.num(defaultCamZoom, defaultCamZoom + 0.2, (Conductor.stepCrochet / 1000) * 6, {}, function(newValue:Float)
						{
							defaultCamZoom = newValue;
						});
						makeInvisibleNotes(false);
					case 1040:
						defaultCamZoom = 0.8; 
						dad.alpha = 1;
						remove(black);
						FlxG.camera.flash();
				}
			case 'maze':
				switch (curStep)
				{
					case 466:
						defaultCamZoom += 0.2;
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub1'), 0.02, 1);
					case 476:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub2'), 0.02, 0.7);
					case 484:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub3'), 0.02, 1);
					case 498:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub4'), 0.02, 1);
					case 510:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub5'), 0.02, 1, {subtitleSize: 60});
						makeInvisibleNotes(false);
					case 528:
						 defaultCamZoom = 0.8;
						black.alpha = 0;
						FlxG.camera.flash();
					case 832:
						defaultCamZoom += 0.2;
						FlxTween.tween(black, {alpha: 0.4}, 1);
					case 838:
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub6'), 0.02, 1);
					case 847:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub7'), 0.02, 0.5);
					case 856:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub8'), 0.02, 1);
					case 867:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub9'), 0.02, 1, {subtitleSize: 40});
					case 879:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub10'), 0.02, 1);
					case 890:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub11'), 0.02, 1);
					case 902:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub12'), 0.02, 1, {subtitleSize: 60});
						makeInvisibleNotes(false);
					case 908:
						FlxTween.tween(black, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
					case 912:
						if (!spotLightPart)
						{
							spotLightPart = true;
							defaultCamZoom -= 0.1;
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
	
							spotLight = new FlxSprite().loadGraphic(Paths.image('spotLight'));
							spotLight.blend = BlendMode.ADD;
							spotLight.setGraphicSize(Std.int(spotLight.width * (dad.frameWidth / spotLight.width) * spotLightScaler));
							spotLight.updateHitbox();
							spotLight.alpha = 0;
							spotLight.origin.set(spotLight.origin.x,spotLight.origin.y - (spotLight.frameHeight / 2));
							add(spotLight);
	
							spotLight.setPosition(dad.getGraphicMidpoint().x - spotLight.width / 2, dad.getGraphicMidpoint().y + dad.frameHeight / 2 - (spotLight.height));	
							updateSpotlight(false);
							
							FlxTween.tween(black, {alpha: 0.6}, 1);
							FlxTween.tween(spotLight, {alpha: 0.7}, 1);
						}
					case 1168:
						spotLightPart = false;
						FlxTween.tween(spotLight, {alpha: 0}, 1, {onComplete: function(tween:FlxTween)
						{
							remove(spotLight);
						}});
						FlxTween.tween(black, {alpha: 0}, 1);
					case 1232:
						FlxG.camera.flash();
				}
			case 'greetings':
				switch (curStep)
				{
					case 492:
						var curZoom = defaultCamZoom;
						var time = (Conductor.stepCrochet / 1000) * 20;
						FlxG.camera.fade(FlxColor.WHITE, time, false, function()
						{
							FlxG.camera.fade(FlxColor.WHITE, 0, true, function()
							{
								FlxG.camera.flash(FlxColor.WHITE, 0.5);
							});
						});
						FlxTween.num(curZoom, curZoom + 0.4, time, {onComplete: function(tween:FlxTween)
						{
							defaultCamZoom = 0.7;
						}}, function(newValue:Float)
						{
							defaultCamZoom = newValue;
						});
				}
			case 'recursed':
				switch (curStep)
				{
					case 320:
						defaultCamZoom = 0.6;
						cinematicBars(((Conductor.stepCrochet * 30) / 1000), 400);
					case 352:
						defaultCamZoom = 0.4;
						FlxG.camera.flash();
					case 864:
						FlxG.camera.flash();
						charBackdrop.loadGraphic(Paths.image('recursed/bambiScroll'));
						freeplayBG.loadGraphic(bambiBG);
						freeplayBG.color = FlxColor.multiply(0xFF00B515, FlxColor.fromRGB(44, 44, 44));
						initAlphabet(bambiSongs);
					case 1248:
						defaultCamZoom = 0.6;
						FlxG.camera.flash();
						charBackdrop.loadGraphic(Paths.image('recursed/tristanScroll'));
						freeplayBG.loadGraphic(tristanBG);
						freeplayBG.color = FlxColor.multiply(0xFFFF0000, FlxColor.fromRGB(44, 44, 44));
						initAlphabet(tristanSongs);
					case 1632:
						defaultCamZoom = 0.4;
						FlxG.camera.flash();
				}
			case 'splitathon':
				switch (curStep)
				{
					case 4750:
						dad.canDance = false;
						dad.playAnim('scared', true);
						camHUD.shake(0.015, (Conductor.stepCrochet / 1000) * 50);
					case 4800:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('dave', 'what');
						addSplitathonChar("bambi-splitathon");
						if (!hasTriggeredDumbshit)
						{
							throwThatBitchInThere('bambi-splitathon', 'dave-splitathon');
						}
					case 5824:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi', 'umWhatIsHappening');
						addSplitathonChar("dave-splitathon");
					case 6080:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('dave', 'happy'); 
						addSplitathonChar("bambi-splitathon");
					case 8384:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi', 'yummyCornLol');
						addSplitathonChar("dave-splitathon");
					case 4799 | 5823 | 6079 | 8383:
						hasTriggeredDumbshit = false;
						updatevels = false;
				}

			case 'insanity':
				switch (curStep)
				{
					case 384 | 1040:
						defaultCamZoom = 0.9;
					case 448 | 1056:
						defaultCamZoom = 0.8;
					case 512 | 768:
						defaultCamZoom = 1;
					case 640:
						defaultCamZoom = 1.1;
					case 660 | 680:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.visible = true;
						iconP2.changeIcon(dadmirror.curCharacter);
					case 664 | 684:
						dad.visible = true;
						dadmirror.visible = false;
						curbg.visible = false;
						iconP2.changeIcon(dad.curCharacter);
					case 708:
						defaultCamZoom = 0.8;
						dad.playAnim('um', true);

					case 1176:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
						curbg.alpha = 1;
						curbg.visible = true;
						iconP2.changeIcon(dadmirror.curCharacter);
					case 1180:
						dad.visible = true;
						dadmirror.visible = false;
						iconP2.changeIcon(dad.curCharacter);
						dad.canDance = false;
						dad.animation.play('scared', true);
				}
			case 'interdimensional':
				switch(curStep)
				{
					case 378:
						FlxG.camera.fade(FlxColor.WHITE, 0.3, false);
					case 384:
						black = new FlxSprite(0,0).makeGraphic(2560, 1440, FlxColor.BLACK);
						black.screenCenter();
						black.scrollFactor.set();
						black.alpha = 0.4;
						add(black);
						defaultCamZoom += 0.2;
						FlxG.camera.fade(FlxColor.WHITE, 0.5, true);
					case 512:
						defaultCamZoom -= 0.1;
					case 639:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						defaultCamZoom -= 0.1; // pooop
						FlxTween.tween(black, {alpha: 0}, 0.5, 
						{
							onComplete: function(tween:FlxTween)
							{
								remove(black);
							}
						});
						changeInterdimensionBg('spike-void');
					case 1152:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						changeInterdimensionBg('darkSpace');
						
						tweenList.push(FlxTween.color(gf, 1, gf.color, FlxColor.BLUE));
						tweenList.push(FlxTween.color(dad, 1, dad.color, FlxColor.BLUE));
						bfTween = FlxTween.color(boyfriend, 1, boyfriend.color, FlxColor.BLUE);
						flyingBgChars.forEach(function(char:FlyingBGChar)
						{
							tweenList.push(FlxTween.color(char, 1, char.color, FlxColor.BLUE));
						});
					case 1408:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						changeInterdimensionBg('hexagon-void');

						tweenList.push(FlxTween.color(dad, 1, dad.color, FlxColor.WHITE));
						bfTween = FlxTween.color(boyfriend, 1, boyfriend.color, FlxColor.WHITE);
						tweenList.push(FlxTween.color(gf, 1, gf.color, FlxColor.WHITE));
						flyingBgChars.forEach(function(char:FlyingBGChar)
						{
							tweenList.push(FlxTween.color(char, 1, char.color, FlxColor.WHITE));
						});
					case 1792:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						changeInterdimensionBg('nimbi-void');
					case 2176:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						changeInterdimensionBg('interdimension-void');
					case 2688:
						defaultCamZoom = 0.7;
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in revertedBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}

						canFloat = false;
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						switchDad('dave-festival', dad.getPosition(), false);

						regenerateStaticArrows(0);
						
						var color = getBackgroundColor(curStage);

						FlxTween.color(dad, 0.6, dad.color, color);
						if (formoverride != 'tristan-golden-glowing')
						{
							FlxTween.color(boyfriend, 0.6, boyfriend.color, color);
						}
						FlxTween.color(gf, 0.6, gf.color, color);

						FlxTween.linearMotion(dad, dad.x, dad.y, 100 + dad.globalOffset[0], 450 + dad.globalOffset[1], 0.6, true);
						
						for (char in [boyfriend, gf])
						{
							if (char.animation.curAnim != null && char.animation.curAnim.name.startsWith('sing') && !char.animation.curAnim.finished)
							{
								char.animation.finishCallback = function(animation:String)
								{
									char.canDance = false;
									char == boyfriend ? char.playAnim('hey', true) : char.playAnim('cheer', true);
								}
							}
							else
							{
								char.canDance = false;
								char == boyfriend ? char.playAnim('hey', true) : char.playAnim('cheer', true);
							}
						}
				}

			case 'unfairness':
				switch(curStep)
				{
					case 256:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
					case 261:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub1'), 0.02, 0.6);
					case 284:
					    subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub2'), 0.02, 0.6);
					case 321:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub3'), 0.02, 0.6);
					case 353:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub4'), 0.02, 1.5);
					case 414:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub5'), 0.02, 0.6);
					case 439:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub6'), 0.02, 1);
					case 468:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub7'), 0.02, 1);
					case 512:
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 2560:
						dadStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.tween(spr, {alpha: 0}, 6);
						});
					case 2688:
						playerStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.tween(spr, {alpha: 0}, 6);
						});
					case 3072:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						dad.visible = false;
						iconP2.visible = false;
				}
				case 'cheating':
					switch(curStep)
					{
						case 512:
							defaultCamZoom += 0.2;
							black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
							black.screenCenter();
							black.alpha = 0;
							add(black);
							FlxTween.tween(black, {alpha: 0.6}, 1);
							makeInvisibleNotes(true);
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub1'), 0.02, 0.6);
						case 537:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub2'), 0.02, 0.6);
						case 552:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub3'), 0.02, 0.6);
						case 570:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub4'), 0.02, 1);
						case 595:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub5'), 0.02, 0.6);
						case 607:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub6'), 0.02, 0.6);
						case 619:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub7'), 0.02, 1);
						case 640:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub8'), 0.02, 0.6);
						case 649:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub9'), 0.02, 0.6);
						case 654:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub10'), 0.02, 0.6);
						case 666:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub11'), 0.02, 0.6);
						case 675:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub12'), 0.02, 0.6);
						case 685:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub13'), 0.02, 0.6);
						case 695:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub14'), 0.02, 0.6);
						case 712:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub15'), 0.02, 0.6);
						case 715:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub16'), 0.02, 0.6);
						case 722:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub17'), 0.02, 0.6);
						case 745:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub18'), 0.02, 0.3);
						case 749:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub19'), 0.02, 0.3);
						case 756:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub20'), 0.02, 0.6);
						case 768:
							defaultCamZoom -= 0.2;
							FlxTween.tween(black, {alpha: 0}, 1);
							makeInvisibleNotes(false);
						case 1280:
							defaultCamZoom += 0.2;
							black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
							black.screenCenter();
							black.alpha = 0;
							add(black);
							FlxTween.tween(black, {alpha: 0.6}, 1);
						case 1301:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub21'), 0.02, 0.6);
						case 1316:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub22'), 0.02, 0.6);
						case 1344:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub23'), 0.02, 0.6);
						case 1374:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub24'), 0.02, 1);
						case 1394:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub25'), 0.02, 0.5);
						case 1403:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub26'), 0.02, 1);
						case 1429:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub27'), 0.02, 0.6);
						case 1475:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub28'), 0.02, 1.5);
						case 1504:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub29'), 0.02, 1);
						case 1528:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub30'), 0.02, 0.6);
						case 1536:
							defaultCamZoom -= 0.2;
							FlxTween.tween(black, {alpha: 0}, 1);

					}
			case 'polygonized':
				switch(curStep)
				{
					case 128 | 640 | 704 | 1535:
						defaultCamZoom = 0.9;
					case 256 | 768 | 1468 | 1596 | 2048 | 2144 | 2428:
						defaultCamZoom = 0.7;
					case 688 | 752 | 1279 | 1663 | 2176:
						defaultCamZoom = 1;
					case 1019 | 1471 | 1599 | 2064:
						defaultCamZoom = 0.8;
					case 1920:
						defaultCamZoom = 1.1;

					case 1024 | 1312:
						defaultCamZoom = 1.1;
						crazyZooming = true;

						if (localFunny != CharacterFunnyEffect.Recurser)
						{
							shakeCam = true;
							pre3dSkin = boyfriend.curCharacter;
							for (char in [boyfriend, gf])
							{
								if (char.skins.exists('3d'))
								{
									if (char == boyfriend)
									{
										switchBF(char.skins.get('3d'), char.getPosition());
									}
									else if (char == gf)
									{
										switchGF(char.skins.get('3d'), char.getPosition());
									}
								}
							}
						}
					case 1152 | 1408:
						defaultCamZoom = 0.9;
						shakeCam = false;
						crazyZooming = false;
						if (localFunny != CharacterFunnyEffect.Recurser)
						{
							if (boyfriend.curCharacter != pre3dSkin)
							{
								switchBF(pre3dSkin, boyfriend.getPosition());
								switchGF(boyfriend.skins.get('gfSkin'), gf.getPosition());
							}
						}
				}
			case 'adventure':
				switch (curStep)
				{
					case 1151:
						defaultCamZoom = 1;
					case 1407:
						defaultCamZoom = 0.8;	
				}
			case 'glitch':
				switch (curStep)
				{
					case 15:
						dad.playAnim('hey', true);
					case 16 | 719 | 1167:
						defaultCamZoom = 1;
					case 80 | 335 | 588 | 1103:
						defaultCamZoom = 0.8;
					case 584 | 1039:
						defaultCamZoom = 1.2;
					case 272 | 975:
						defaultCamZoom = 1.1;
					case 464:
						defaultCamZoom = 1;
						FlxTween.linearMotion(dad, dad.x, dad.y, 25, 50, 20, true);
					case 848:
						shakeCam = false;
						crazyZooming = false;
						defaultCamZoom = 1;
					case 132 | 612 | 740 | 771 | 836:
						shakeCam = true;
						crazyZooming = true;
						defaultCamZoom = 1.2;
					case 144 | 624 | 752 | 784:
						shakeCam = false;
						crazyZooming = false;
						defaultCamZoom = 0.8;
					case 1231:
						defaultCamZoom = 0.8;
						FlxTween.linearMotion(dad, dad.x, dad.y, 50, 280, 1, true);
				}
			case 'mealie':
				switch (curStep)
				{
					case 659:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub1'), 0.02, 0.6);
					case 1183:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
					case 1193:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub2'), 0.02, 0.6);
					case 1208:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub3'), 0.02, 1.5);
					case 1228:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub4'), 0.02, 1);
					case 1242:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub5'), 0.02, 1);
					case 1257:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub6'), 0.02, 0.5);
					case 1266:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub7'), 0.02, 1.5);
					case 1289:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub8'), 0.02, 2);
					case 1344:
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 1584:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub15'), 0.02, 1);
					case 1746:
					case 1751:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub9'), 0.02, 0.6);
					case 1770:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub10'), 0.02, 0.6);
					case 1776:
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						switchDad(FlxG.random.int(0, 999) == 0 ? 'bambi-angey-old' : 'bambi-angey', dad.getPosition());
						dad.color = nightColor;
					case 1800:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub11'), 0.02, 0.6);
					case 1810:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub12'), 0.02, 0.6);
					case 1843:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub13'), 0.02, 1, {subtitleSize: 60});
					case 2418:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub14'), 0.02, 0.6);				
				}
			case 'indignancy':
				switch (curStep)
				{
					case 124 | 304 | 496 | 502 | 576 | 848:
						defaultCamZoom += 0.2;
					case 176:
						defaultCamZoom -= 0.2;
						crazyZooming = true;
					case 320 | 832 | 864:
						defaultCamZoom -= 0.2;
					case 508:
						defaultCamZoom -= 0.4;		
					case 320 | 864:
						crazyZooming = true;	
					case 304 | 832 | 1088 | 2144:
						crazyZooming = false;
					case 1216:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
					case 1217:
						subtitleManager.addSubtitle(LanguageManager.getTextString('indignancy_sub1'), 0.02, 2);
					case 1262:
						subtitleManager.addSubtitle(LanguageManager.getTextString('indignancy_sub2'), 0.02, 1.5);
					case 1292:
						subtitleManager.addSubtitle(LanguageManager.getTextString('indignancy_sub3'), 0.02, 1);
					case 1330:
						subtitleManager.addSubtitle(LanguageManager.getTextString('indignancy_sub4'), 0.02, 0.5);
				    case 1344:
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 1622:
						subtitleManager.addSubtitle(LanguageManager.getTextString('indignancy_sub5'), 0.02, 0.3);
						
						defaultCamZoom += 0.4;
						FlxG.camera.shake(0.015, 0.6);
						dad.canDance = false;
						dad.playAnim('scream', true);
						dad.animation.finishCallback = function(animation:String)
						{
							dad.canDance = true;
						}
					case 1632:
						defaultCamZoom -= 0.4;
						crazyZooming = true;
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
				}
				switch (curBeat)
				{
					case 335:
						if (!spotLightPart)
						{
							spotLightPart = true;
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
	
							spotLight = new FlxSprite().loadGraphic(Paths.image('spotLight'));
							spotLight.blend = BlendMode.ADD;
							spotLight.setGraphicSize(Std.int(spotLight.width * (dad.frameWidth / spotLight.width) * spotLightScaler));
							spotLight.updateHitbox();
							spotLight.alpha = 0;
							spotLight.origin.set(spotLight.origin.x,spotLight.origin.y - (spotLight.frameHeight / 2));
							add(spotLight);
	
							spotLight.setPosition(dad.getGraphicMidpoint().x - spotLight.width / 2, dad.getGraphicMidpoint().y + dad.frameHeight / 2 - (spotLight.height));
	
							updateSpotlight(false);
							
							FlxTween.tween(black, {alpha: 0.6}, 1);
							FlxTween.tween(spotLight, {alpha: 1}, 1);
						}
					case 408:
						spotLightPart = false;
						FlxTween.tween(spotLight, {alpha: 0}, 1, {onComplete: function(tween:FlxTween)
						{
							remove(spotLight);
						}});
						FlxTween.tween(black, {alpha: 0}, 1);
				}
			case 'exploitation':
				switch(curStep)
				{
					case 12, 18, 23:
						blackScreen.alpha = 1;
						FlxTween.tween(blackScreen, {alpha: 0}, Conductor.crochet / 1000);
						FlxG.sound.play(Paths.sound('static'), 0.5);

						creditsPopup.switchHeading({path: 'songHeadings/glitchHeading', antiAliasing: false, animation: 
						new Animation('glitch', 'glitchHeading', 24, true, [false, false]), iconOffset: 0});
						
						creditsPopup.changeText('', 'none', false);
					case 20:
						creditsPopup.switchHeading({path: 'songHeadings/expungedHeading', antiAliasing: true,
						animation: new Animation('expunged', 'Expunged', 24, true, [false, false]), iconOffset: 0});

						creditsPopup.changeText('Song by Oxygen', 'Oxygen');
					case 14, 24:
						creditsPopup.switchHeading({path: 'songHeadings/expungedHeading', antiAliasing: true,
						animation: new Animation('expunged', 'Expunged', 24, true, [false, false]), iconOffset: 0});

						creditsPopup.changeText('Song by EXPUNGED', 'whoAreYou');
					case 32 | 512:
						FlxTween.tween(boyfriend, {alpha: 0}, 3);
						FlxTween.tween(gf, {alpha: 0}, 3);
						defaultCamZoom = FlxG.camera.zoom + 0.3;
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 4);
					case 128 | 576:
						defaultCamZoom = FlxG.camera.zoom - 0.3;
						FlxTween.tween(boyfriend, {alpha: 1}, 0.2);
						FlxTween.tween(gf, {alpha: 1}, 0.2);
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.3}, 0.05);
						mcStarted = true;

					case 184 | 824:
						FlxTween.tween(FlxG.camera, {angle: 10}, 0.1);
					case 188 | 828:
						FlxTween.tween(FlxG.camera, {angle: -10}, 0.1);
					case 192 | 832:
						FlxTween.tween(FlxG.camera, {angle: 0}, 0.2);
					case 1276:
						FlxG.camera.fade(FlxColor.WHITE, (Conductor.stepCrochet / 1000) * 4, false, function()
						{
							FlxG.camera.stopFX();
						});
						FlxG.camera.shake(0.015, (Conductor.stepCrochet / 1000) * 4);
					case 1280:
						shakeCam = true;
						FlxG.camera.zoom -= 0.2;

						windowProperties = [
							Application.current.window.x,
							Application.current.window.y,
							Application.current.window.width,
							Application.current.window.height
						];

						#if windows
						popupWindow();
						#end
						
						modchart = ExploitationModchartType.Figure8;
						dadStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});

					case 1282:
						expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/broken_expunged_chain', 'shared'));
						expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
					case 1311:
						shakeCam = false;
						FlxG.camera.zoom += 0.2;	
					case 1343:
						shakeCam = true;
						FlxG.camera.zoom -= 0.2;	
					case 1375:
						shakeCam = false;
						FlxG.camera.zoom += 0.2;
					case 1487:
						shakeCam = true;
						FlxG.camera.zoom -= 0.2;
					case 1503:
						shakeCam = false;
						FlxG.camera.zoom += 0.2;
					case 1536:						
						expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/creepyRoom', 'shared'));
						expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
						expungedBG.setPosition(0, 200);
						
						modchart = ExploitationModchartType.Sex;
						dadStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});

					case 2080:
						#if windows
						if (window != null)
						{
							window.close();
							expungedWindowMode = false;
							window = null;
							FlxTween.tween(Application.current.window, {x: windowProperties[0], y: windowProperties[1], width: windowProperties[2], height: windowProperties[3]}, 1, {ease: FlxEase.circInOut});
							FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.bounceOut});
						}
						#end
					case 2083:
						PlatformUtil.sendWindowsNotification("Anticheat.dll", "Threat expunged.dat successfully contained.");
				}
			case 'shredder':
				switch (curStep)
				{
					case 261:
						defaultCamZoom += 0.2;
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.scrollFactor.set();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub1'), 0.02, 0.3);
					case 273:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub2'), 0.02, 0.6);
					case 296:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub3'), 0.02, 0.6);
					case 325:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub4'), 0.02, 0.6);
					case 342:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub5'), 0.02, 0.6);
					case 356:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub6'), 0.02, 0.6);
					case 361:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub7'), 0.02, 0.6);
					case 384:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub8'), 0.02, 0.6, {subtitleSize: 60});
					case 393:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub9'), 0.02, 0.6, {subtitleSize: 60});
					case 408:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub10'), 0.02, 0.6, {subtitleSize: 60});
					case 425:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub11'), 0.02, 0.6, {subtitleSize: 60});
					case 484:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub12'), 0.02, 0.6, {subtitleSize: 60});
					case 512:
						defaultCamZoom -= 0.2;
						FlxG.camera.flash();
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 784 | 816 | 912 | 944:
						#if SHADERS_ENABLED
						camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
						#end
						defaultCamZoom += 0.2;
						FlxTween.tween(black, {alpha: 0.6}, 1);
					case 800 | 832 | 928:
						camHUD.setFilters([]);
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
					case 960:
						camHUD.setFilters([]);
						defaultCamZoom = 0.7;
						FlxTween.tween(black, {alpha: 0}, 1);
					case 992:
						dadStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.tween(spr, {alpha: 0}, 1);
						});
					case 1008:
						switchDad('bambi-shredder', dad.getPosition());
						dad.playAnim('takeOut', true);

					case 1024:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);

						playerStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.cancelTweensOf(spr);
						});

						dadStrums.forEach(function(spr:StrumNote)
						{
							spr.alpha = 1;
						});
						
						lockCam = true;
						
						originalBFScale = boyfriend.scale.copyTo(originalBFScale);
						originBFPos = boyfriend.getPosition();
						originBambiPos = dad.getPosition();

						dad.cameras = [camHUD];
						dad.scale.set(dad.scale.x * 0.55, dad.scale.y * 0.55);
						dad.updateHitbox();
						dad.offsetScale = 0.55;
						dad.scrollFactor.set();
						dad.setPosition(-21, -10);

						bambiSpot = new FlxSprite(34, 151).loadGraphic(Paths.image('festival/shredder/bambi_spot'));
						bambiSpot.scrollFactor.set();
						bambiSpot.blend = BlendMode.ADD;
						bambiSpot.cameras = [camHUD];
						insert(members.indexOf(dadGroup), bambiSpot);

						bfSpot = new FlxSprite(995, 381).loadGraphic(Paths.image('festival/shredder/boyfriend_spot'));
						bfSpot.scrollFactor.set();
						bfSpot.blend = BlendMode.ADD;
						bfSpot.cameras = [camHUD];
						bfSpot.alpha = 0;

						boyfriend.cameras = [camHUD];
						boyfriend.scale.set(boyfriend.scale.x * 0.45, boyfriend.scale.y * 0.45);
						boyfriend.updateHitbox();
						boyfriend.offsetScale = 0.45;
						boyfriend.scrollFactor.set();
						boyfriend.setPosition((bfSpot.x - (boyfriend.width / 3.25)) + boyfriend.globalOffset[0] * boyfriend.offsetScale, (bfSpot.y - (boyfriend.height * 1.1)) + boyfriend.globalOffset[1] * boyfriend.offsetScale);
						boyfriend.alpha = 0;

						insert(members.indexOf(bfGroup), bfSpot);

						highway = new FlxSprite().loadGraphic(Paths.image('festival/shredder/ch_highway'));
						highway.setGraphicSize(Std.int(highway.width * (670 / highway.width)), Std.int(highway.height * (1340 / highway.height)));
						highway.updateHitbox();
						highway.cameras = [camHUD];
						highway.screenCenter();
						highway.scrollFactor.set();
						insert(members.indexOf(strumLineNotes), highway);

						black = new FlxSprite().makeGraphic(2560, 1440, FlxColor.BLACK);
						black.screenCenter();
						black.scrollFactor.set();
						black.alpha = 0.9;
						insert(members.indexOf(highway), black);

						dadStrums.forEach(function(spr:StrumNote)
						{
							dadStrums.remove(spr);
							strumLineNotes.remove(spr);
							remove(spr);
						});
						generateGhNotes(0);
						
						dadStrums.forEach(function(spr:StrumNote)
						{
							spr.centerStrum();
							spr.x -= (spr.width / 4);
						});
						playerStrums.forEach(function(spr:StrumNote)
						{
							spr.centerStrum();
							spr.alpha = 0;
							spr.x -= (spr.width / 4);
						});
					case 1276:
						dadStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.tween(spr, {alpha: 0}, (Conductor.stepCrochet / 1000) * 2);
						});
						playerStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.tween(spr, {alpha: 1}, (Conductor.stepCrochet / 1000) * 2);
						});
					case 1280:
						FlxTween.tween(boyfriend, {alpha: 1}, 1);
						FlxTween.tween(bfSpot, {alpha: 1}, 1);
					case 1536:
						var blackFront = new FlxSprite(0, 0).makeGraphic(2560, 1440, FlxColor.BLACK);
						blackFront.screenCenter();
						blackFront.alpha = 0;
						blackFront.cameras = [camHUD];
						add(blackFront);
						FlxTween.tween(blackFront, {alpha: 1}, 0.5, {onComplete: function(tween:FlxTween)
						{
							lockCam = false;
							strumLineNotes.forEach(function(spr:StrumNote)
							{
								spr.x = spr.baseX;
							});
							switchDad('bambi-new', originBambiPos, false);

							boyfriend.cameras = dad.cameras;
							boyfriend.scale.set(originalBFScale.x, originalBFScale.y);
							boyfriend.updateHitbox();
							boyfriend.offsetScale = 1;
							boyfriend.scrollFactor.set(1, 1);
							boyfriend.setPosition(originBFPos.x, originBFPos.y);
							
							for (hudElement in [black, blackFront, bambiSpot, bfSpot, highway])
							{
								remove(hudElement);
							}
							FlxTween.tween(blackFront, {alpha: 0}, 0.5);
						}});
						regenerateStaticArrows(0);

						defaultCamZoom += 0.2;
						#if SHADERS_ENABLED
						if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
						{
							camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
						}
						#end
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
					case 1552:
						camHUD.setFilters([]);
						defaultCamZoom += 0.1;
					case 1568:
						#if SHADERS_ENABLED
						if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
							{
								camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
							}
						#end
						defaultCamZoom += 0.1;
					case 1584:
						camHUD.setFilters([]);
						defaultCamZoom += 0.1;
					case 1600:
						#if SHADERS_ENABLED
						if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
							{
								camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
							}
						#end
						defaultCamZoom += 0.1;
					case 1616:
						camHUD.setFilters([]);
						defaultCamZoom += 0.1;
					case 1632:
						#if SHADERS_ENABLED
						if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
							{
								camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
							}
						#end
						defaultCamZoom += 0.1;
					case 1648:
						FlxTween.tween(black, {alpha: 1}, 1);
						camHUD.setFilters([]);
						defaultCamZoom += 0.1;
					case 1664:
						defaultCamZoom -= 0.9;
						FlxG.camera.flash();
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 1937:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub13'), 0.02, 0.6, {subtitleSize: 60});
					case 1946:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub14'), 0.02, 0.6, {subtitleSize: 60});
				}
			case 'rano':
				switch (curStep)
				{
					case 512:
						defaultCamZoom = 0.9;
					case 640:
						defaultCamZoom = 0.7;
					case 1792:
						dad.canDance = false;
						dad.canSing = false;
						dad.playAnim('sleepIdle', true);
						dad.animation.finishCallback = function(anim:String)
						{
							dad.playAnim('sleeping', true);
						}
				}
			case 'five-nights':
				if (!powerRanOut)
				{
					switch (curStep)
					{
						case 60:
							switchNoteSide();
						case 64 | 320 | 480 | 576 | 704 | 832 | 1024:
							nofriendAttack();
						case 992:
							defaultCamZoom = 1.2;
							FlxTween.tween(camHUD, {alpha: 0}, 1);
						case 1088:
							sixAM();
					}
				}
			case 'bot-trot':
				switch (curStep)
				{
					case 896:
						FlxG.camera.flash();
						FlxG.sound.play(Paths.sound('lightswitch'), 1);
						defaultCamZoom = 1.1;
						switchToNight();
					case 1151:
						defaultCamZoom = 0.8;
				}
			case 'supernovae':
				switch (curStep)
				{
					case 60:
						dad.playAnim('hey', true);
					case 64:
						defaultCamZoom = 1;
					case 192:
						defaultCamZoom = 0.9;
					case 320 | 768:
						defaultCamZoom = 1.1;
					case 444:
						defaultCamZoom = 0.6;
					case 448 | 960 | 1344:
						defaultCamZoom = 0.8;
					case 896 | 1152:
						defaultCamZoom = 1.2;
					case 1024:
						defaultCamZoom = 1;
						shakeCam = true;
						FlxTween.linearMotion(dad, dad.x, dad.y, 25, 50, 15, true);

					case 1280:
						FlxTween.linearMotion(dad, dad.x, dad.y, 50, 280, 0.6, true);
						shakeCam = false;
						defaultCamZoom = 1;
				}
			case 'master':
				switch (curStep)
				{
					case 128:
						defaultCamZoom = 0.7;
					case 252 | 512:
						defaultCamZoom = 0.4;
						shakeCam = false;
					case 256:
						defaultCamZoom = 0.8;
					case 380:
						defaultCamZoom = 0.5;
					case 384:
						defaultCamZoom = 1;
						shakeCam = true;
					case 508:
						defaultCamZoom = 1.2;
					case 560:
						dad.playAnim('die', true);			
						FlxG.sound.play(Paths.sound('dead'), 1);
					}
			case 'vs-dave-rap':
				switch(curStep)
				{
						case 64:
							FlxG.camera.flash();
						case 68:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub1'), 0.02, 1);
						case 92:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub2'), 0.02, 0.8);
						case 112:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub3'), 0.02, 0.8);
						case 124:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub4'), 0.02, 0.5);
						case 140:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub5'), 0.02, 0.5);
						case 150:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub6'), 0.02, 1);
						case 176:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub7'), 0.02, 0.5);
						case 184:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub8'), 0.02, 0.8);
						case 201:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub9'), 0.02, 0.5);
						case 211:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub10'), 0.02, 0.8);
						case 229:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub11'), 0.02, 0.5);
						case 241:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub12'), 0.02, 0.8);
						case 260:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub13'), 0.02, 0.8);
						case 281:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub14'), 0.02, 0.5);
						case 288:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub15'), 0.02, 1.5);
						case 322:
							FlxG.camera.flash();
					}
		    case 'vs-dave-rap-two':
				switch(curStep)
			    {
					case 62:
						FlxG.camera.flash();
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub1'), 0.02, 0.5);
					case 79:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub2'), 0.02, 0.3);
					case 88:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub3'), 0.02, 1.5);
					case 112:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub4'), 0.02, 1.5);
					case 140:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub5'), 0.02, 1);
					case 168:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub6'), 0.02, 0.7);
					case 179:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub7'), 0.02, 0.7);
					case 194:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub8'), 0.02, 1.5);
					case 222:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub9'), 0.02, 2);
					case 256:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub10'), 0.02, 2);	
					case 291:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub11'), 0.02, 1);
					case 342:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub12'), 0.02, 1);
					case 351:
						FlxG.camera.flash();
				}
			case 'memory':
				switch (curStep)
				{
					case 1408:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
					case 1422:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub1'), 0.02, 0.5);
					case 1436:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub2'), 0.02, 1);
					case 1458:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub3'), 0.02, 0.7);
					case 1476:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub4'), 0.02, 1);
					case 1508:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub5'), 0.02, 1.5);
					case 1541:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub6'), 0.02, 1);
					case 1561:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub7'), 0.02, 1);
					case 1583:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub8'), 0.02, 0.8);
					case 1608:
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub9'), 0.02, 1);
					case 1632:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub10'), 0.02, 0.5);
					case 1646:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub11'), 0.02, 1);
					case 1664:
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
				}
		}
		if (SONG.song.toLowerCase() == 'exploitation' && curStep % 8 == 0)
		{
		
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
