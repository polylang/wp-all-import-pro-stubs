<?php
/**
 * The class `PMXI_Plugin` and the function `wp_all_import_pro_updater()` are "hidden" behind a `if` statement:
 * `if ( is_plugin_active( 'wp-all-import/plugin.php' ) ) {`
 * This prevents the php parser to do its job.
 * This script removes the `if` statement, allowing the parser to find these nodes.
 */
namespace Polylang\WP_All_Import_Pro_Stubs;

use Symfony\Component\Console\Input\ArgvInput;
use Symfony\Component\Console\Output\ConsoleOutput;
use Symfony\Component\Console\Style\SymfonyStyle;

if ( file_exists( __DIR__ . '/vendor/autoload.php' ) ) {
	require __DIR__ . '/vendor/autoload.php';
}

function remove_if_else_statement() {
	$rel_path  = "wp-all-import-pro/wp-all-import-pro.php";
	$full_path = __DIR__ . '/' . $rel_path;
	$io        = new SymfonyStyle( new ArgvInput(), new ConsoleOutput() );

	$io->title( 'Replacements in original main file' );

	if ( ! file_exists( $full_path ) ) {
		$io->error( "Failed to locate file $rel_path." );
		return;
	}

	try {
		$contents = file_get_contents( $full_path );

		if ( ! is_string( $contents ) ) {
			$io->error( "Failed to open file $rel_path." );
			return;
		}
	} catch( Exception $e ) {
		$io->error( "Failed to open file $rel_path." );
		return;
	}

	$pattern = "@if\s*\(\s*is_plugin_active\(\s*'wp-all-import/plugin.php'\s*\)\s*\)\s*\{.+\}\s*else\s*\{(?<code>.*)\}\s*$@Us";

	if ( ! preg_match( $pattern, $contents, $matches ) ) {
		$io->error( "Could not find the part to remove in file $rel_path." );
		return;
	}

	$contents = str_replace( $matches[0], $matches['code'] . "\n", $contents );
	$result   = file_put_contents( $full_path, $contents );

	if ( false === $result ) {
		$io->error( "Failed to perform replacements in file $rel_path." );
	} else {
		$io->success( "Replacements done in file $rel_path." );
	}
}

remove_if_else_statement();
