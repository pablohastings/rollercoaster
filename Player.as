﻿package  {
		 private var previousY:Number;
		 public var isDirection:String;
		
		 //public var yPosArray = new Array();
		 //public var xPosArray = new Array();
		 //public var rotatePosArray = new Array();
		
		public var playerTrackState:String;
		
			isDirection = "flat";
			
			previousY = this.y;
			
			//setPosArray();
			
			
			if(this.y > previousY){
				//trace("down:"+ this.rotation);
				isDirection = "down";
			} else if (this.y < previousY){
				//trace("up:"+ this.rotation);
				isDirection = "up";
			} else {
				//trace("flat");
				isDirection = "flat";
			}
			
			previousY = this.y;
			
			
		/*public function setPosArray() 
		{
			xPosArray.unshift(this.x);
			yPosArray.unshift(this.y);
			rotatePosArray.unshift(this.rotation);
			
			if(yPosArray.length == 5){
				yPosArray.pop();
			}
			if(xPosArray.length == 5){
				xPosArray.pop();
			}
			if(rotatePosArray.length == 5){
				rotatePosArray.pop();
			}
		}*/
		
				this.rotation = -15;