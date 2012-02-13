package
{
  import flash.display.Sprite;
  import flash.display.Bitmap;
  import flash.display.BitmapData;  
  import flash.display.BlendMode;  
  
  import flash.events.*;
  import flash.display.StageQuality;
  import flash.utils.*;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.TextFieldAutoSize;

  [SWF(backgroundColor="#000000", frameRate="24", width="800", height="800")]
  public class Maze extends Sprite
  {   
    [Embed(source="maze.png")]
    private var Picture:Class;
    private var pic:Bitmap;
    private var sprite:Sprite;
    private var offsetX:int = 0;
    private var offsetY:int = 0;
    private var scale:int = 3;
    private var children:Array;
    private var playerX:int = 1;
    private var playerY:int = 1;
    
    [Embed(source='char.png')]
  	private var sheetClass:Class;
  	private var sheet:Bitmap = new sheetClass();
  	public var charSprite:SpriteSheet;
    
    private var started:Boolean = false;
    
    [Embed(source="FFFHARMO.TTF", fontFamily="Harmony")]
    private var _arial_str:String;
    
    private var _arial_fmt:TextFormat;
    private var _text_txt:TextField;
    private var _text_interval:int;
    
    public function Maze(): void{
      
      _arial_fmt = new TextFormat();
      _arial_fmt.font = "Harmony";
      _arial_fmt.size = 40;
      _text_txt = new TextField();
      _text_txt.embedFonts = true;
      _text_txt.autoSize = TextFieldAutoSize.LEFT;
      _text_txt.defaultTextFormat = _arial_fmt;
      _text_txt.text = "wasd to move \n\narrows to move map \n\nclick to start";
      _text_txt.x = (stage.stageWidth  / 2 - _text_txt.width / 2);
      _text_txt.y = (stage.stageHeight / 2 - _text_txt.height / 2) - 100;
      _text_txt.textColor = 0xffffffff;
      _text_txt.embedFonts = true
      _text_txt.alpha = 2.0
      addChild(_text_txt);
      stage.addEventListener(MouseEvent.CLICK, myClick);
      stage.addEventListener(KeyboardEvent.KEY_DOWN, keypress);
    }
    
    public function start():void{
      children = new Array();
      pic = new Picture();
      pic.scaleX = scale;
      pic.scaleY = scale;
      
      pic.x = 0//stage.stageWidth / 2 - pic.width / 2;
      pic.y = 0//stage.stageHeight / 2 - pic.height / 2;
      //pic.smoothing = true;
      addChild(pic)
      sprite = new Sprite()
      sprite.graphics.beginFill(0x0011ff11);
      sprite.graphics.drawRect(0, 0, 4, 4);
      sprite.graphics.endFill();
      sprite.scaleX = scale;
      sprite.scaleY = scale;
      sprite.x = scale * 4;
      sprite.y = scale * 4;
      addChild(sprite)
      var random:int = 0
      var currentPixel:int = 0
    }
    
    public function myClick(eventObject:MouseEvent):void {
      if(!started){
        stage.focus=stage
        started = true
        start()
        removeChild(_text_txt)
      }
    }
    
    public function finish():void {
      removeChild(sprite)
      removeChild(pic)
      
      _arial_fmt = new TextFormat();
      _arial_fmt.font = "Harmony";
      _arial_fmt.size = 40;
      _text_txt = new TextField();
      _text_txt.embedFonts = true;
      _text_txt.autoSize = TextFieldAutoSize.LEFT;
      _text_txt.defaultTextFormat = _arial_fmt;
      _text_txt.text = "FINISHED!";
      _text_txt.x = (stage.stageWidth  / 2 - _text_txt.width / 2);
      _text_txt.y = (stage.stageHeight / 2 - _text_txt.height / 2) - 100;
      _text_txt.textColor = 0xffffffff;
      _text_txt.embedFonts = true
      _text_txt.alpha = 2.0
      addChild(_text_txt);
    }
    
    public function newSprite():void{
      var newSprite:Sprite = new Sprite()
      newSprite.graphics.beginFill(0x00aa0000);
      newSprite.graphics.drawRect(0, 0, 4, 4);
      newSprite.graphics.endFill();
      newSprite.scaleX = scale;
      newSprite.scaleY = scale;
      newSprite.x = sprite.x
      newSprite.y = sprite.y
      addChild(newSprite)
      children.push(newSprite)
    }
    
    public function moveChildren(addX:int, addY:int):void{
      for(var i:int; i < children.length; i++){
        children[i].x += addX
        children[i].y += addY
      }
    }
    
    public function keypress(keyEvent:KeyboardEvent):void {
      if(started){
        var keyPressed:int;
        keyPressed = keyEvent.keyCode;
        trace(keyPressed)  
        if(keyPressed == 87){ //up
            if(pic.bitmapData.getPixel((sprite.x + offsetX) / scale, ((sprite.y + offsetY) - (scale * 4)) / scale) != 0){
              playerY -= 1
              newSprite()
              sprite.y -= (scale * 4)
          }
         } else if(keyPressed == 83){ //down
            if(pic.bitmapData.getPixel((sprite.x + offsetX) / scale, ((sprite.y + offsetY) + (scale * 4)) / scale) != 0){
              playerY += 1
              newSprite()
              sprite.y += (scale * 4)
            }
         } else if(keyPressed == 65){ //left
            if(pic.bitmapData.getPixel(((sprite.x + offsetX) - (scale * 4)) / scale, (sprite.y + offsetY) / scale) != 0){
              playerX -= 1
              newSprite()
              sprite.x -= (scale * 4)
            }
        } else if(keyPressed == 68){ //right
            if(pic.bitmapData.getPixel(((sprite.x + offsetX) + (scale * 4)) / scale, (sprite.y + offsetY) / scale) != 0){
              playerX += 1
              newSprite()
              sprite.x += (scale * 4)
            }
        }
        if(keyPressed == 38){ //up
          //if(pic.y > 0){
            sprite.y += (scale * 8)
            pic.y += (scale * 8)
            offsetY -= (scale * 8)
            moveChildren(0, scale * 8)
          //}
        } else if(keyPressed ==  40){ //down
          sprite.y -= (scale * 8)
          pic.y -= (scale * 8)
          offsetY += (scale * 8)
          moveChildren(0, -scale * 8)
          
        } else if(keyPressed ==  37){ //left
          //if(pic.x > 0){
            sprite.x += (scale * 8)
            pic.x += (scale * 8)
            offsetX -= (scale * 8)
            moveChildren(scale * 8, 0)
            
          //}
        } else if(keyPressed ==  39){ //right
          sprite.x -= (scale * 8)
          pic.x -= (scale * 8)
          offsetX += (scale * 8)
          moveChildren(-scale * 8, 0)
          
        }
        setChildIndex(sprite, numChildren - 1);
        
        //if(keyPressed == 189){ //-
        //  if(scale > 1){
        //    scale -= 1
        //    pic.scaleX = scale;
        //    pic.scaleY = scale;
        //    sprite.scaleX = scale;
        //    sprite.scaleY = scale;
        //    sprite.x -= scale * 2
        //    //sprite.y -= scale * 2
        //    //((sprite.x / (scale + 1)) - offsetX) * scale
        //    //sprite.y = //((sprite.y / (scale + 1)) - offsetY) * scale
        //    if(sprite.y > 0){
        //      sprite.y -= scale * 8
        //    }
        //  }
        //} else if(keyPressed == 187){ //+
        //  if(scale < 3){
        //    scale += 1
        //    pic.scaleX = scale;
        //    pic.scaleY = scale;
        //    sprite.scaleX = scale;
        //    sprite.scaleY = scale;
        //    sprite.x += (scale - 1) * 2
        //    //sprite.x = ((sprite.x / (scale - 1))) * scale
        //    if(sprite.y > 0){
        //      sprite.y += scale * 4
        //    }
        //  }
        //}
        if((sprite.x / scale) == 7184 && (sprite.y / scale) == 7192){
          finish()
        }
      } 
    }
  }
}
