package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.ui.*;
	import flash.media.*;
	import flash.system.fscommand;
	
	
	import Game.*;
	import flash.net.URLRequest;
	
	public class GameController extends MovieClip
	{
		private var playerScore:Number;
		private var gameObjects, bricks, coins, lifts:Array;
		private var scrollSoFar:Number;
		private var currGameStage;
		
		private var player:Player;
		private var moveX:Number;
		private var jump:Boolean;
		static  var currFrame:String;
		
		var menu_bgm:Sound=new Sound();
		var prolog1_bgm:Sound=new Sound();
		var ingame_bgm:Sound=new Sound();
		var mySoundChannel:SoundChannel=new SoundChannel();
		
		var sfx_Jump:Sound = new sfx_jump(); 
		var sfx_poin:Sound = new sfx_bonus(); 
			
		
		public function setCurrFrame(frame:String)
		{
			currFrame=frame;
		}
		
		public function GameController()
		{
			currFrame="mainMenu";
			menu_bgm.load(new URLRequest("Music/menu.mp3"));
			prolog1_bgm.load(new URLRequest("Music/prolog1.mp3"));
			ingame_bgm.load(new URLRequest("Music/ingame.mp3"));
			
		}
		
		public function startMenu()
		{
			btnTentang.addEventListener(MouseEvent.CLICK, gotoTentang);
			btnExit.addEventListener(MouseEvent.CLICK, gotoKeluar);
			btnPanduan.addEventListener(MouseEvent.CLICK, gotoPanduan);
			btnPlay.addEventListener(MouseEvent.CLICK, gotoProlog);
			
			//MusicBG
			mySoundChannel=menu_bgm.play();

		}
		
		private function gotoProlog(evt:MouseEvent)
		{
			mySoundChannel.stop();
			mySoundChannel=prolog1_bgm.play(0,int.MAX_VALUE);
			
			btnPlay.removeEventListener(MouseEvent.CLICK, gotoProlog);
			
			gotoAndStop("Prolog");
			
		}
		
		
		private function gotoTentang(evt:MouseEvent)
		{
			btnTentang.removeEventListener(MouseEvent.CLICK, gotoTentang);
			gotoAndStop("Tentang");
		}
		
		private function gotoPanduan(evt:MouseEvent)
		{
			btnPanduan.removeEventListener(MouseEvent.CLICK, gotoPanduan);
			gotoAndStop("Panduan");
		}
		
		private function gotoKeluar(evt:MouseEvent)
		{
			btnExit.removeEventListener(MouseEvent.CLICK, gotoKeluar);
			fscommand("quit");
		}
		
		public function ToMenu()
		{
			btnToMenu.addEventListener(MouseEvent.CLICK, gotoMenu);
			
		}
		
		private function gotoMenu(evt:MouseEvent)
		{
			
			//MusicBG
			mySoundChannel.stop();
			btnToMenu.removeEventListener(MouseEvent.CLICK, gotoMenu);
			if (currentLabel == "Story1" || currentLabel == "Story2")
			{
				clearGame();
			}
			gotoAndStop("mainMenu");
		}
		
		public function ToRestart()
		{
			btnToRestart.addEventListener(MouseEvent.CLICK, gotoRestart);	
		}
		
		public function gotoRestart(evt:MouseEvent)
		{
			btnToRestart.removeEventListener(MouseEvent.CLICK, gotoRestart);
			if(currFrame == "Menu_Story1")
			{
				clearGame();
				gotoAndStop("mainMenu");
				gotoAndStop("Story1");
			}
			else if(currFrame == "Menu_Story2")
			{
				clearGame();
				gotoAndStop("mainMenu");
				gotoAndStop("Story2");
			}
			else
			{
				gotoAndStop(currFrame);
			}
		}
		
		public function startGame()
		{	
		
			mySoundChannel.stop();
			mySoundChannel=ingame_bgm.play(0,int.MAX_VALUE);
			
			playerScore = C.PLAYER_START_SCORE;
			
			gameObjects = new Array();
			bricks = new Array();
			coins = new Array();
			lifts = new Array();
			
			scrollSoFar = 0;
			moveX = 0;
			jump = false;
			
			currGameStage = mcGameStage;
			
			setUpGame();
			
			
			
			//Add player on to stage
			player = new Player(C.PLAYER_START_X, C.PLAYER_START_Y);
			currGameStage.addChild(player);
			
			//Hide Markers
			currGameStage.mcStartMarker.visible = false;
			currGameStage.mcEndMarker.visible = false; 
						
			currGameStage.addEventListener(Event.ENTER_FRAME,update);
			
			//Handle event when this game is being preloaded
			addEventListener(Event.ADDED_TO_STAGE, gameAddedToStage ); 
			
			//Handle situations when this game is being run directly
			if (stage != null)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
				stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			}
		}
		
		public function startGame2()
		{	
			playerScore = 500;
			
			gameObjects = new Array();
			bricks = new Array();
			coins = new Array();
			lifts = new Array();
			
			scrollSoFar = 0;
			moveX = 0;
			jump = false;
			
			currGameStage = mcGameStage2;
			
			setUpGame();
			
			//Add player on to stage
			player = new Player(C.PLAYER_START_X, C.PLAYER_START_Y);
			currGameStage.addChild(player);
			
			//Hide Markers
			currGameStage.mcStartMarker.visible = false;
			currGameStage.mcEndMarker.visible = false; 
						
			currGameStage.addEventListener(Event.ENTER_FRAME,update);
			
			//Handle event when this game is being preloaded
			addEventListener(Event.ADDED_TO_STAGE, gameAddedToStage ); 
			
			//Handle situations when this game is being run directly
			if (stage != null)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
				stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			}
		}
		
		private function gameAddedToStage(evt: Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
		}  
		
		private function keyDownHandler(evt:KeyboardEvent):void
		{
			if (evt.keyCode == 37) //LEFT Key 
			{
				moveX = -1;
			}
			else if (evt.keyCode == 39) //RIGHT Key
			{
				moveX = 1;
			}
			
			if (evt.keyCode == 32) //Spacebar
			{
				jump = true;
			}
		}
		
		private function keyUpHandler(evt:KeyboardEvent):void
		{
			if ((evt.keyCode == 37) || (evt.keyCode == 39))
			{
				moveX = 0;
			}
			
			if (evt.keyCode == 32) //Spacebar
			{
				jump = false;
			}
		}
		
		private function setUpGame()
		{
			//Loop through all items on stage
			for (var i=0; i< currGameStage.numChildren; i++)
			{
				var currObject = currGameStage.getChildAt(i);
				
				//Identify the bricks
				if (currObject is Brick)
				{
					bricks.push(currObject);
					gameObjects.push(currObject);
				}
				else if (currObject is Coin)
				{
					coins.push(currObject);
					gameObjects.push(currObject);
				}
				else if (currObject is VerticalLift)
				{
					lifts.push(currObject);
					gameObjects.push(currObject);
				}
			}
		}
		
		public function update(evt:Event)
		{
			//******************			
			//Handle User Input
			//******************
			if (moveX > 0)
				player.moveRight();
			else if (moveX < 0)
				player.moveLeft();
			else if (moveX == 0)
				player.stopMoving();
			
			if (jump && !player.isInAir())
			{
				player.jump();
				sfx_Jump.play();
				jump = false;
				
			}
			
			//******************
			//Handle Game Logic
			//******************
			//Update lifts
			for (var i=lifts.length - 1; i >= 0; i--)
			{
				lifts[i].update();
			}
			
			//Update Player
			player.update();
				
			//Check for collisions
			if (player.isInAir() && player.isFalling())
			{	
				for (var i=bricks.length - 1; i >= 0; i--)
				{
					if (player.hitAreaFloor.hitTestObject(bricks[i]))
					{
						//Player landed on the brick
						player.hitFloor(bricks[i]);
					}
				}
				
				for (var i=lifts.length - 1; i >= 0; i--)
				{
					if (player.hitAreaFloor.hitTestObject(lifts[i]))
					{
						//Player landed on the lift
						player.hitFloor(lifts[i]);
						
					}
				}
			}
			
			//Check for collisions
			for (var i=coins.length - 1; i >= 0; i--)
			{
				if (player.hitTestObject(coins[i]))
				{
					//Player obtain a coin
					playerScore += C.SCORE_PER_COIN;
					sfx_poin.play();
					
					//Remove the coin
					currGameStage.removeChild(coins[i]);
					coins.splice(i,1);
				}
			}
			
			if (player.notInScreen())
			{
				currFrame=currentLabel;
				gameOver();
			}
			
			//******************
			//Handle Display
			//******************			
			//Display new Score
			txtScorePlayer.text = String(playerScore/10)+"%";
			
			//******************
			//Handle Display
			//******************			
			//check transition to other levels
			if (currentLabel == "Story1")
			{
				if (coins.length == 0)
				{
					clearGame();
					
					gotoAndStop("Story2");
				}
			}
			else
			{
				if (coins.length == 0)
				{
					clearGame();
					mySoundChannel.stop();
					mySoundChannel=prolog1_bgm.play(0,int.MAX_VALUE);
					gotoAndStop("Epilog");
					
				}
			}
		}
		
		private function clearGame()
		{
			for (var i=coins.length - 1; i >= 0; i--)
			{
				currGameStage.removeChild(coins[i]);
				coins.splice(i,1);
			}
			
			for (var i=bricks.length - 1; i >= 0; i--)
			{
				currGameStage.removeChild(bricks[i]);
				bricks.splice(i,1);
			}
			
			
			for (var i=lifts.length - 1; i >= 0; i--)
			{
				currGameStage.removeChild(lifts[i]);
				lifts.splice(i,1);
			}
			
			
			currGameStage.removeChild(player);
			
			currGameStage.removeEventListener(Event.ENTER_FRAME,update);
		}
		
		
		
		
		private function gameOver()
		{
			player = null;
			bricks = null;
			
			currGameStage.removeEventListener(Event.ENTER_FRAME,update);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			gotoAndStop("gameOver");
		}
		
		//public functions for children to invoke
		public function playerShouldMoveLeft():Boolean
		{
			return ((currGameStage.mcStartMarker.x >= 0) ||
					(currGameStage.mcEndMarker.x - player.x <= C.SCROLL_BOUND));
		}
		
		public function playerShouldMoveRight():Boolean
		{
			return ((currGameStage.mcEndMarker.x <= C.GAME_WIDTH) ||
					(player.x - currGameStage.mcStartMarker.x <= C.SCROLL_BOUND));
		}
		
		public function scrollGameObjects(playerMoveAmount:Number)
		{
			for (var i in gameObjects)
			{
				gameObjects[i].x += playerMoveAmount;
			}
			
			currGameStage.mcStartMarker.x += playerMoveAmount;
			currGameStage.mcEndMarker.x += playerMoveAmount;					
		}
	}	
}