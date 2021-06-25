<?php

return \StubsGenerator\Finder::create()
	->in(
		[
			'wp-all-import-pro',
		]
	)
	->notPath(
		[
			'classes/PHPExcel/Shared/PCLZip',
			'helpers/backward.php',
			'libraries/pclzip.lib.php',
		]
	)
	->sortByName();
