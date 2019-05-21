import php.NativeArray;

class Main {
	public static function main() {
		// register a shortcode
		WordpressHelper.addShortcode("haxe-plugin-demo", Main, "showHaxeDemo");
	}

	static function showHaxeDemo(nativeAttr:NativeArray, content:String, shortCode:String):String {
		var name:Null<String> = WordpressHelper.extractAttribute(nativeAttr, "name");
		return 'Hello $name from Haxe ${haxe.macro.Compiler.getDefine("haxe_ver")}';
	}
}
