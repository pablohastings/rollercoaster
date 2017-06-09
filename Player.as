package  {		import flash.events.Event;	import flash.events.TimerEvent;	import flash.utils.Timer;		public class Player extends BoundaryObject {		
		 private var previousY:Number;		 private var xMovement:Number;		 public var isAttacking:Boolean;		 public var isSliding:Boolean;
		 public var isDirection:String;		 private var attackTimer:Timer = new Timer (500, 1);		 private var theSoundLibrary:SoundLibrary = new SoundLibrary();
		
		 //public var yPosArray = new Array();
		 //public var xPosArray = new Array();
		 //public var rotatePosArray = new Array();
		
		public var playerTrackState:String;
				public function Player() {						trace ("i am a player" );						// constructor code						isSliding = false;			isAttacking = false;
			isDirection = "flat";			xMovement = 0;
			
			previousY = this.y;						addEventListener(Event.ENTER_FRAME, enterFrameHandler );		}				private function enterFrameHandler (event:Event ) :void {		
			
			//setPosArray();
						this.x += xMovement;
			
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
			
					}		
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
				public function attack() 		{						isAttacking = true;			this.gotoAndStop("attack");			attackTimer.addEventListener(TimerEvent.TIMER_COMPLETE, doneAttacking);			attackTimer.start();						theSoundLibrary.sword();					}		public function startJumping() 		{						if (isJumping == false) {				
				this.rotation = -15;							theSoundLibrary.jump();				isJumping = true;				this.gotoAndStop("jump");				downwardVelocity = -45; // -40 -> downwardVelocity += 5;			}					}						public function doneAttacking (event:TimerEvent):void {						isAttacking = false;			this.gotoAndStop("stop");		}						public function moveRight () :void {			xMovement = 25;			this.scaleX = 1;			this.gotoAndStop("run");			isRunning = true;				}				/*public function slideLeft( passTilt:int ) :void {						xMovement = passTilt;			this.scaleX = -1;			this.gotoAndStop("slide");			isSliding = true;					}		public function slideRight( passTilt:int ) :void {						xMovement = passTilt;			this.scaleX = 1;			this.gotoAndStop("slide");			isSliding = true;								}				public function standStill() :void {						xMovement = 0;			isRunning = false;			isSliding = false;				}*/						override public function positionOnLand() {						isJumping = false;						if (isAttacking == true){								// do nothing 			}			else if (isSliding == true ) {								this.gotoAndStop("slide");							}						else if (isRunning == true ) {								this.gotoAndStop("run");							}  else {						this.gotoAndStop("stop");						}					}	}	}