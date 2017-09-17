package Game
{
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Player extends MovieClip
	{
		private var inAir:Boolean;
		private var speedX:Number;
		private var speedY:Number;
		private var standingOn:*;
		
		public function Player(xPos:Number, yPos:Number)
		{
			this.x = xPos;
			this.y = yPos;
			
			this.speedX = 0;
			this.speedY = 0;
			this.standingOn = null;
			
			//Init inAir to true since player starts off in mid air
			this.inAir = true;
			
			//animate
			this.gotoAndPlay(C.PLAYER_IDLE);  
		}
		
		public function update()
		{
			//Move Horizontally
			if (this.speedX < 0)
			{
				//Check if player should move
				if (MovieClip(root).playerShouldMoveLeft())
				{
					this.x += this.speedX;
				}
				else
				{
					MovieClip(root).scrollGameObjects(-this.speedX);
				}
			}
			else if (this.speedX > 0)
			{
				//Check if player should move
				if (MovieClip(root).playerShouldMoveRight())
				{
					this.x += this.speedX;
				}
				else
				{
					MovieClip(root).scrollGameObjects(-this.speedX);
				}
			}
			
			//Move Vertically
			if (this.speedY < C.MAX_SPEED)
				this.speedY += C.GRAVITY;
			
			if (this.inAir)
				this.y += this.speedY;
			else
			{
				//Move the player as its floor moves
				if (this.standingOn != null)
					this.y = standingOn.y;
			}
			
			if (standingOn != null)
			{
				//Check if player has moved off the floor it stands on
				if (!this.hitAreaFloor.hitTestObject(standingOn))
				{
					removeFloor();
				}
			}
			
			//Animate
			if (this.inAir)
			{
				if (this.currentLabel != C.PLAYER_JUMP)
					this.gotoAndPlay(C.PLAYER_JUMP);
			}
			else if (this.speedX > 0)
			{
				if (this.currentLabel != C.PLAYER_RIGHT)
					this.gotoAndPlay(C.PLAYER_RIGHT);
			}
			else if (this.speedX < 0)
			{
				if (this.currentLabel != C.PLAYER_LEFT)
					this.gotoAndPlay(C.PLAYER_LEFT);
			}
			else
			{
				if (this.currentLabel != C.PLAYER_IDLE)
					this.gotoAndPlay(C.PLAYER_IDLE);
			}
		}
		
		public function moveRight()
		{
			if (this.x <= C.PLAYER_RIGHT_BOUND)
				this.speedX = C.PLAYER_SPEED_X;
			else
				stopMoving();
		}
		
		public function moveLeft()
		{
			if (this.x >= C.PLAYER_LEFT_BOUND)
				this.speedX = -C.PLAYER_SPEED_X;
			else
				stopMoving();
		}
		
		public function jump()
		{
			this.speedY = C.PLAYER_SPEED_Y;
			this.inAir = true;
		}
		
		public function stopMoving()
		{
			this.speedX = 0;
		}
		
		public function removeFloor()
		{
			this.standingOn = null;
			this.inAir = true;
		}
		
		public function isInAir():Boolean
		{
			return this.inAir;
		}
		
		public function isFalling():Boolean
		{
			return this.speedY > 0;
		}
		
		public function hitFloor(platform:*)
		{
			this.inAir = false;
			this.standingOn = platform;
			this.y = platform.y;
		}
		
		public function notInScreen():Boolean
		{
			return this.y > C.PLAYER_DEATH_YPOS;
		}
	}
}