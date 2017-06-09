package {	import flash.display.MovieClip;	import flash.events.TimerEvent;	import flash.utils.Timer;	import MainTimer;	import flash.events.Event;	import flash.ui.Keyboard;	import flash.events.KeyboardEvent;	import flash.sensors.Accelerometer;	import flash.events.AccelerometerEvent;
	import flash.events.AccelerometerEvent;	import flash.events.MouseEvent;	import flash.system.Capabilities;
	import flash.geom.Point;	public class DocumentMain extends MovieClip	{		//initial variables		private var currentNumberOfEnemiesOnstage:int;		private var initialNumberOfEnemiesToCreate:int = 2;		private var maxNumberOfEnemiesOnstage:int = 2;		private var tiltValueFromAcc:Number = 0;		private var numChildrenInBoundaries:int;		private var ninjaKills:int;		private var childToRemove:int;		private var level:int = 1;		private var e:int = 0;		private var minute:int = 0;		private var second:int = 59;		private var gameTimer:MainTimer;		private var childrenOnStage:int;		private var lastX:int;// variable to determine where the last x of the player was.
		private var theCart:Cart;
				private var thePlayer:Player;
		private var theCart1:Player;
				private var theEnemy:Enemy;		private var doesTheWorldNeedToScroll:Boolean;		private var isMobileDevice:Boolean;		private var makeNewEnemyTimer:Timer = new Timer(3000,1);		private var finishOffEnemy:Timer = new Timer(500,1);		private var theAcc:Accelerometer =  new Accelerometer();				private var theSoundLibrary:SoundLibrary = new SoundLibrary();
		
		private var trackState:String;
		private var isOnTrack:Boolean;
		
		public var yPosArray = new Array();
		public var xPosArray = new Array();
		public var rotatePosArray = new Array();
		public function DocumentMain()		{			// constructor code						trace("document main initiated");			//paul edit			//makeNewEnemyTimer.addEventListener(TimerEvent.TIMER_COMPLETE,makeNewEnemyHandler);			//makeNewEnemyTimer.start();			gameTimer = new MainTimer(minute,second);			addChild(gameTimer);			gameTimer.x = 60;			gameTimer.y = -400;			thePlayer = new Player();			addChild(thePlayer);			thePlayer.x = stage.stageWidth * 0.5;// halfway across the stage			thePlayer.y = 180;			thePlayer.name = "player";
			theCart1 = new Player();
			addChild(theCart1);					/* PAUL EDIT			while (e < initialNumberOfEnemiesToCreate)			{				createEnemy();				e++;			}			*/
						ninjaKills = 0;			lastX = thePlayer.x;			childrenOnStage = this.numChildren;//make sure you assign this value after adding children			this.addEventListener(Event.ENTER_FRAME,mainGameLoop);			stage.focus = stage;			/// chooses between using the Accelerometer or the Keyboard for controls...						stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);			isMobileDevice = false;		}		private function makePlayerJump():void		{
			
			//trace("");
			//trace("isOnTrack:"+isOnTrack);
		
			if(isOnTrack == true){
				
				trace("jump");
				thePlayer.startJumping();
				isOnTrack = false;
				
			}
					}		private function makePlayerAttack(e:MouseEvent):void		{			thePlayer.attack();					}		private function keyDownHandler(e:KeyboardEvent):void		{			switch (e.keyCode)			{				case 37 ://left					//thePlayer.moveLeft();					break;				case 38 ://up
										//thePlayer.startJumping();					makePlayerJump();
									break;				case 39 ://right					//thePlayer.moveRight();					break;				case 40 ://down to attack					//thePlayer.attack();										break;			}		}		private function keyUpHandler(e:KeyboardEvent):void		{			switch (e.keyCode)			{				case 37 ://left				case 39 ://right					break;				case 40 ://down to attack					//as a reminder, you COULD do something when you finish attacking.					break;				default :					//anything			}		}		private function mainGameLoop(event:Event):void		{
			thePlayer.moveRight();
						gameResets();			removeOrCreateNewEnemies();			processCollisions();
			processCollisionsB();
						scrollStage();			// ends  mainGameLoop		}		private function createEnemy():void		{			theEnemy = new Enemy( (Math.random() * 5 ) + 1  )  ;			addChild(theEnemy);			theEnemy.x = Math.random() * stage.stageWidth + stage.stageWidth / 2;// anywhere across the stage			theEnemy.y = 0;			theEnemy.name = "enemy";			childrenOnStage = this.numChildren;		}		private function removeOrCreateNewEnemies():void		{			for (var c:int = 0; c < childrenOnStage; c++)			{				if (getChildAt(c).name == "enemy" && getChildAt(c).y > stage.stageHeight)				{					removeChildAt(c);					createEnemy();				}				if (getChildAt(c).name == "enemy" && getChildAt(c).x < thePlayer.x - stage.stageWidth)				{					removeChildAt(c);					createEnemy();				}			}		}		private function makeNewEnemyHandler(event:TimerEvent):void		{			currentNumberOfEnemiesOnstage = 0;			for (var c:int = 0; c < childrenOnStage; c++)			{				if (getChildAt(c).name == "enemy")				{					currentNumberOfEnemiesOnstage++;				}			}			if (currentNumberOfEnemiesOnstage < maxNumberOfEnemiesOnstage)			{				trace("not enough enemies onstage, make more");				createEnemy();			}			makeNewEnemyTimer.start();		}		public function finishOffEnemyComplete(event:TimerEvent):void		{			ninjaKills++;			killScoreBox.text = String(ninjaKills) + " KILLS";			removeChildAt( childToRemove);			childrenOnStage = this.numChildren;		}		
		private function processCollisionsB():void
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
				private function processCollisions():void		{			//trace("isOnTrack:"+isOnTrack);
			
			//this moves rc on curved path
			var rotationIncrament = 12;
			if(thePlayer.isDirection == "down"){
				rotationIncrament = 5;
			} 
			
						for (var c:int = 0; c < childrenOnStage; c++)			{								if (getChildAt(c).name == "player")				{
				
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
					
					
										if (_boundaries.hitTestPoint(getChildAt(c).x,getChildAt(c).y,true))					{//if the boundary collides with the player or enemy						while (_boundaries.hitTestPoint(getChildAt(c).x,getChildAt(c).y,true))						{
							
							if (getChildAt(c).name == "player")
							{
								isOnTrack = true;
							}							BoundaryObject(getChildAt(c)).incrementUpward();							//bump up the object until it isn't hitting the boundary;							if (_boundaries.hitTestPoint(getChildAt(c).x,getChildAt(c).y,true))							{								// do nothing							}							else							{// once it isn't hitting the boundary, do this function for keeping the object on the boundary								BoundaryObject(getChildAt(c)).keepOnBoundary();							}						}						//  ends while (  _boundaries.hitTestPoint ( getChildAt(c).x , getChildAt(c).y, true) ) {;					}// ends if ( _boundaries.hitTestPoint ( getChildAt(c).x , getChildAt(c).y, true) )				}//ends if ( getChildAt(c).name == "player") 				////////////////////////////////////////////////////////////////////////				////////////////////////////////////////////////////////////////////////				////////////////////////Collision with ENEMIES////////////////				if (getChildAt(c).name == "enemy")				{					if (getChildAt(c).hitTestPoint(thePlayer.x,thePlayer.y,true))					{						if (thePlayer.isAttacking == false)						{							// we are being attacked (and not defending)							health.width = health.width - 2;							Enemy(getChildAt(c)).makeEnemyAttack();						}						else						{							// we are attacking that enemy							childToRemove = c;							Enemy(getChildAt(c)).makeEnemyDie();							finishOffEnemy.start();							finishOffEnemy.addEventListener(TimerEvent.TIMER_COMPLETE, finishOffEnemyComplete);						}					}					else if ( Enemy(getChildAt(c)).enemyIsAttacking == true )					{						//if there isn't a collision between player and enemy, BUT the enemy is attacking						Enemy(getChildAt(c)).makeEnemyStopAttacking();					}				}				//if (getChildAt(c).name == "enemy") ;			
			}//ends childrenOnStage  for loop			//////////////////////////////////////////////////////////// new for loop for coin  collision detection			numChildrenInBoundaries = _boundaries.numChildren;			for (var d:int = 0; d < numChildrenInBoundaries; d++)			{				if (_boundaries.getChildAt(d).hasOwnProperty("isACoin") && _boundaries.getChildAt(d).visible == true)				{					if (thePlayer.hitTestObject(_boundaries.getChildAt(d)))					{						//trace("hit coin");												theSoundLibrary.coin();						//_boundaries.getChildAt(d).visible = false;						//_boundaries.getChildAt(d).y = stage.stageHeight + 300;						_boundaries.removeChildAt( d );						numChildrenInBoundaries = _boundaries.numChildren;					}				}			}// ends for			//ends processCollisions		}		private function gameResets()		{			if (gameTimer.timerHasStopped == true)			{				resetBoard();			}			else if (thePlayer.y > stage.stageHeight)			{				resetBoard();			}			else if (_boundaries.pole.hitTestPoint(thePlayer.x,thePlayer.y,true) && doesTheWorldNeedToScroll == false)			{				level++;				if (level == 2){										_boundaries.gotoAndStop ("lvl1");				} else if (level == 3){										_boundaries.gotoAndStop ("lvl2");				}								//_boundaries.nextFrame();								trace("win");				resetBoard();			}			else if (health.width <= 2)			{				resetBoard();			}			// ends  gameResets		}		private function resetBoard():void		{			health.width = 300;			thePlayer.x = stage.stageWidth * 0.5;			_boundaries.x = stage.stageWidth * 0.5;			sky.x = stage.stageWidth * 0.5;			thePlayer.y = 180;			//_boundaries.y = 0;
			_boundaries.y = 112;
			_boundaries.x = -40;
						sky.y = 0;			ninjaKills = 0;			gameTimer.resetTimer(0,40);		}		private function scrollStage():void		{			if (thePlayer.x != lastX)			{				doesTheWorldNeedToScroll = true;			}			else if (thePlayer.x == lastX)			{				doesTheWorldNeedToScroll = false;			}			if (doesTheWorldNeedToScroll == true)			{				sky.x +=  stage.stageWidth * 0.5 - thePlayer.x * 1.002;				for (var b:int = 0; b < childrenOnStage; b++)				{					if (getChildAt(b).name == "enemy")					{						getChildAt(b).x +=  stage.stageWidth * 0.5 - thePlayer.x;					}				}				_boundaries.x +=  stage.stageWidth * 0.5 - thePlayer.x;			}			else			{				sky.x -=  0.5;			}			// RUN THIS FOLLOWING LINE LAST			thePlayer.x = stage.stageWidth * 0.5;			lastX = thePlayer.x;

			theCart1.x = thePlayer.xPosArray[3] - 135;//thePlayer.x - 110;
			theCart1.y = thePlayer.yPosArray[3] -4;
			theCart1.rotation =  thePlayer.rotatePosArray[3];
			
			/*trace("");
			trace("theCart1.y:" + theCart1.y);
			trace("theCart1.y::" + thePlayer.yPosArray[3]);
			trace("");*/		}	}}