﻿package 
	import flash.events.AccelerometerEvent;
	import flash.geom.Point;
		private var theCart:Cart;
		
		private var theCart1:Player;
		
		
		private var trackState:String;
		private var isOnTrack:Boolean;
		
		public var yPosArray = new Array();
		public var xPosArray = new Array();
		public var rotatePosArray = new Array();
		
	

			theCart1 = new Player();
			addChild(theCart1);
			
			
			//trace("");
			//trace("isOnTrack:"+isOnTrack);
		
			if(isOnTrack == true){
				
				trace("jump");
				thePlayer.startJumping();
				isOnTrack = false;
				
			}
			
					
				
			thePlayer.moveRight();
			
			processTrackSection();
			
		private function processTrackSection():void
		{
			trackState = '';
			
			if(_boundaries.bg.flat){
				if (thePlayer.hitTestObject(_boundaries.bg.flat))
				  {
					  //trace("on flat::::::::::::::::::::::::::");
					  trackState = 'flat';
				  }
			}
			
			if(_boundaries.bg.up12){
				if (thePlayer.hitTestObject(_boundaries.bg.up12))
				  {
					  //trace("on up12::::::::::::::::::::::::::");
					  trackState = 'up12';
				  }
			}
			
			if(_boundaries.bg.up20){
				if (thePlayer.hitTestObject(_boundaries.bg.up20))
				  {
					  //trace("on up12::::::::::::::::::::::::::");
					  trackState = 'up20';
				  }
			}
			
		}
		
			
			//this moves rc on curved path
			var rotationIncrament = 14;//12;
			if(thePlayer.isDirection == "down"){
				rotationIncrament = 5;
			} 
			
			
					//calculate slope for player
					if(thePlayer.isDirection == "flat"){
						thePlayer.rotation = 0;
						
					//these are fixed angles.  figure out way to make dynamic
					} else if (trackState == 'up12'){
						thePlayer.rotation = -12;
					} else if (trackState == 'up20'){
						thePlayer.rotation = -20;
					} else {
						//rc on a curved section.  rotate rc
						var leftPoint:Point = thePlayer.localToGlobal(new Point(thePlayer.leftCorner.x, thePlayer.leftCorner.y));
						var rightPoint:Point = thePlayer.localToGlobal(new Point(thePlayer.rightCorner.x, thePlayer.rightCorner.y));
				
						if (_boundaries.hitTestPoint(leftPoint.x ,leftPoint.y,true))
						{					
							thePlayer.rotation = thePlayer.rotation + rotationIncrament;
						
						}
						
						if (_boundaries.hitTestPoint(rightPoint.x ,rightPoint.y,true))
						{					
							
							thePlayer.rotation = thePlayer.rotation - rotationIncrament;
							//trace("Local  Kid coords : " + (new Point(theCart.leftCorner.x, theCart.leftCorner.y)));
							//trace("Global Kid coords : " + theCart.localToGlobal(new Point(theCart.leftCorner.x, theCart.leftCorner.y)));
						}
					}
					
					
					//check if player is falling off end of track
					if (getChildAt(c).name == "player")
					{
						if (_boundaries.hitTestPoint(getChildAt(c).x,getChildAt(c).y,true))
						{
							
						} else {
							
							if(thePlayer.isDirection == 'down'){
								isOnTrack = false;
							}
							
						}
					}
					
					
					
						if (getChildAt(c).name == "player")
						{
							isOnTrack = true;
						}
						
						
						
						while (_boundaries.hitTestPoint(getChildAt(c).x,getChildAt(c).y,true))
							//bump up the object until it isn't hitting the boundary;
							// once it isn't hitting the boundary, do this function for keeping the object on the boundary
			}//ends the for loop
			thePlayer.x = stage.stageWidth * 0.5;
			thePlayer.y = 90;
			
			sky.y = 0;
			//_boundaries.x = stage.stageWidth * 0.5;
			_boundaries.y = 112;
			_boundaries.x = -40;
			
			yPosArray.length = 0;
			xPosArray.length = 0;
			rotatePosArray.length = 0; 
			
			
			
			postionCart();
			
			
		
		private function postionCart():void
		{
			
			xPosArray.unshift(thePlayer.x);
			if(xPosArray.length == 8){
				xPosArray.pop();
			}
			yPosArray.unshift(thePlayer.y);
			if(yPosArray.length == 8){
				yPosArray.pop();
			}
			rotatePosArray.unshift(thePlayer.rotation);
			if(rotatePosArray.length == 8){
				rotatePosArray.pop();
			}
			
	
			
			theCart1.x = xPosArray[4] - 110;//thePlayer.xPosArray[3] - 135;//thePlayer.x - 110;
			theCart1.y = yPosArray[4];//thePlayer.yPosArray[3];// - 4;
			theCart1.rotation =  rotatePosArray[4];
			
			//trace("");
			//trace("thePlayer.y:" + thePlayer.y);
			//trace("theCart1.y:" + theCart1.y);
			//trace("theCart1.y::" + thePlayer.yPosArray[3]);
			//trace("");
		}