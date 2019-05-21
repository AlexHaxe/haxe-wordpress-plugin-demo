import haxe.macro.Compiler;
import php.Lib;
import php.NativeArray;

class WordpressHelper {
	private static function getPrefix():String {
		var prefix:Null<String> = Compiler.getDefine("php-prefix");
		if (prefix == null) {
			return "";
		}
		return prefix + ".";
	}

	private static function getClassName(clazz:Class<Dynamic>):String {
		#if (haxe_ver < 4.0)
		var className:String = getPrefix() + Type.getClassName(clazz);
		return className;
		#else
		return php.Syntax.nativeClassName(clazz);
		#end
	}

	public static function addShortcode(shortCode:String, clazz:Class<Dynamic>, callback:String):Void {
		var className:String = getClassName(clazz);
		className = StringTools.replace(className, ".", "\\");
		#if (haxe_ver < 4.0)
		var classArray = untyped __call__("array", className, callback);
		untyped __call__("add_shortcode", shortCode, classArray);
		#else
		php.Syntax.code("add_shortcode ({0}, array ({1}, {2}))", shortCode, className, callback);
		#end
	}

	public static function extractAttribute(nativeAttr:NativeArray, name:String):Null<String> {
		if ((nativeAttr == null) || (Std.string(nativeAttr) == "")) {
			return null;
		}
		var attr:Map<String, String> = Lib.hashOfAssociativeArray(nativeAttr);
		return attr.get(name);
	}
}
