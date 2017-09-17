package Game
{
	public class C
	{	
		//GENERAL
		public static const GAME_WIDTH:Number = 600;
		public static const GAME_HEIGHT:Number = 500;
		public static const GAME_FPS:Number = 30;
		
		//Player
		public static const PLAYER_START_X = 200;
		public static const PLAYER_START_Y = 100;
		public static const PLAYER_SPEED_X = 4;
		public static const PLAYER_SPEED_Y = -16.2;				
		public static const PLAYER_LEFT_BOUND = 20;
		public static const PLAYER_RIGHT_BOUND = 580;
		public static const PLAYER_DEATH_YPOS:Number = 600;
		
		public static const PLAYER_JUMP = "jump";
		public static const PLAYER_LEFT = "left";				
		public static const PLAYER_RIGHT = "right";
		public static const PLAYER_IDLE = "idle";
		
		//Bricks		
		public static const SPAWN_BRICK_FACTOR:Number = 70;
		public static const BRICK_SPEED:Number = 2;
		
		//Lifts
		public static const VERTICAL_LIFT_START_DIR:Number = -1;
		public static const VERTICAL_LIFT_SPEED:Number = 2;
		public static const VERTICAL_LIFT_MAX_DISTANCE:Number = 40;
				
		//Game
		public static const GRAVITY:Number = 1;
		public static const MAX_SPEED:Number = 10;
		public static const SCROLL_BOUND:Number = 200;
		
		//Scoring
		public static const PLAYER_START_SCORE:Number = 0;
		public static const SCORE_PER_COIN:Number = 10;
	}
}