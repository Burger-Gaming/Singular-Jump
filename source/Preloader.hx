import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.Font;
import flixel.addons.display.FlxBackdrop;
import flixel.system.FlxBasePreloader;

@:font('assets/fonts/SHOWG.ttf') class DaFont extends Font {}

class Preloader extends FlxBasePreloader{
    var text:TextField;

    override public function create(){
        super.create();
        Font.registerFont(DaFont);
        text = new TextField();
        text.defaultTextFormat = new TextFormat("Showcard Gothic", 48, 0xffff6600);
        text.embedFonts = true;
        text.text = "Loading";
        text.width = 203;
        text.x = 814;
        text.y = 906;
        addChild(text);
    }
}