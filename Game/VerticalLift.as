package Game
{
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class VerticalLift extends MovieClip
	{
		private var dirY:Number;
		private var startPosY:Number;
		
		public function VerticalLift()
		{
			//Start by moving according to the value specified in C.as
			this.dirY = C.VERTICAL_LIFT_START_DIR;
			
			//Remember where it started off from
			this.startPosY = this.y
		}
		
		public function update()
		{
			this.y += this.dirY * C.VERTICAL_LIFT_SPEED;
			if ((this.y <= this.startPosY - C.VERTICAL_LIFT_MAX_DISTANCE) ||
				(this.y >= this.startPosY + C.VERTICAL_LIFT_MAX_DISTANCE))
			{
				this.dirY *= -1;
			}
		}
	}
}