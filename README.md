# Haxe Wordpress Plugin Demo

Small demo project demonstrating how to write a Wordpress plugin in Haxe.

## Compilation and Installation

Plugin compiles with Haxe 3 and Haxe 4 and uses `haxe-wordpress-plugin-demo` as output folder.

- Place a symlink or copy `haxe-wordpress-plugin-demo` into your Wordpress as `<Wordpress-Root>/wp-content/plugins/haxe-wordpress-plugin-demo`.
- Log into your Wordpress admin, go to plugins and activate `Haxe-Wordpress-Plugin-Demo`
- Edit a Wordpress Post or Page and add `[haxe-plugin-demo name="<your name>"]`. Save Page or Post.
- Visit frontend version of page or post and which should contain `Hello <your name> from Haxe <version>` in place of the shortcode added in previous step.

## Things to note and issues you might encounter with your own plugin

### Plugin main entry point

Wordpress requires plugins to have a main entry point named exactly like its folder. Further more `haxe-wordpress-plugin-demo.php` needs to contain a comment providing some metadata for Wordpress to show in its Plugins page. Since you have no control over Haxe's frontend file or more specific its contents, you have manually add a main entry point for your plugin which will then `require` / `include` your Haxe frontend file.

### I want to add multiple plugins

You will probably run into problems if you try to add two or more Haxe generated plugins to a single Wordpress, because of duplicate types in both plugins. e.g. there might be two Date classes, which is not necessarily an issue unless dead code elimination comes into play. Suddenly only one plugins finds all functions it needs, while the other errors out.

When you want to add more than one Haxe based plugin to your Wordpress installation, then you should use a unique prefix for each one, e.g. `-D php-prefix=pluginA` and `-D php-prefix=pluginB`. That way all Haxe generated classes reside in their own "namespace" where they don't clash with other plugins.

For Haxe 3 use `--php-prefix=plugin`. 

> Please note: when using `--php-prefix=plugin` alongside `-resource` in Haxe 3 that PHP does not correctly detect your `res` folder, you need to manually move your `res` folder alongside `plugin` subfolder. Haxe 4 does not have that issue.

### Plugin works fine locally, but breaks live site, Wordpress shows a white page

There are probably plenty of reasons for a Wordpress to stop working after activating a plugin. But if your plugin works locally and breaks on your live site, then there is a chance your hoster has installed some PEAR or other libraries that produce name clashes with your Haxe generated classes. 
e.g. the PEAR Date library comes with a `\Date` class that clashes with Haxe's `\Date` class. When you try to use e.g. `Date.now()` you will get a message saying something like `Date` has no `now()` function.

When your hosting has preinstalled libraries in your global include path, then you will have to use `-D php-prefix=plugin` to move your plugin into a unique "namespace" (see section on multiple plugins above).

### Media uploads are broken when I enable my plugins

Needs more research to figure out a better solution, but it seems the ajax uploader does play along well with our plugin code. To fix this you can add an `if` to your generated `plugin.php` file, to only call it when run through regular Wordpress page visits, e.g. `if (basename($_SERVER['PHP_SELF']) == "index.php") {` (see `haxe-wordpress-plugin-demo/plugin.php`).
Since a normal compilation through `build.hxml` would overwrite your `plugin.php`, it is necessary to disable generating `plugin.php` when compiling. You can do so by replacing `-main Main` with a simple `Main` after your first compilation.
That way Haxe knows your main class and it will build everything but a fresh frontend file.

There might be a better solution, but that one works.

### WordpressHelper

`WordpressHelper` is not complete and there are many more API calls that you might want to use in your plugins, e.g. you might want to register custom post types, you might want to add javascripts or stylesheets, etc. 
It should be fairly easy to expand `WordpressHelper`, since you only have to add what you need.
