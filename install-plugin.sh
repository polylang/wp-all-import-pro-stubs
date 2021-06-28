#!/usr/bin/env bash

TMPDIR=${TMPDIR-/tmp}
TMPDIR=$(echo $TMPDIR | sed -e "s/\/$//")

get_license() {
	grep -Eo '[a-f0-9]+' $PWD/LICENSE-CODE
}

get_package_url() {
	local URL=$(echo "$1" | grep -Eo '"package":.*?[^\\]"' | grep -Eo 'http.+[^"]')
	echo ${URL//\\\//\/}
}

get_package_version() {
	echo "$1" | grep -Eo '"stable_version":"[0-9.]+"' | grep -Eo '[0-9.]+'
}

download() {
	if [ `which curl` ]; then
		curl -s "$1" > "$2";
	elif [ `which wget` ]; then
		wget -nv -O "$2" "$1"
	fi
}

download_plugin() {
	if [[ -f "$PWD/$1/$1.php" ]]; then
		# The plugin exists.
		echo "* $1 already installed."
		return
	fi

	if [[ ! -f "$PWD/LICENSE-CODE" ]]; then
		# No license code.
		echo "* $1's license not provided. Please create a file named LICENSE-CODE containing it."
		return
	fi

	local LICENSE=$(get_license)

	if [ ! $LICENSE ]; then
		# No license key.
		echo "* No license key found in the file LICENSE-CODE."
		return
	fi

	local INFOURL='https://www.wpallimport.com'
	local PARAMS="edd_action=get_version&license=$LICENSE&item_name=WP%20All%20Import&version=4.6.6"
	local HEADERS='Content-Type: application/x-www-form-urlencoded;Cache-Control: no-cache;Accept: application/json;Connection: keep-alive'

	if [ `which curl` ]; then
		local INFO=$(curl -d "$PARAMS" -H "$HADERS" -X POST -s "$INFOURL")
	elif [ `which wget` ]; then
		local INFO=$(wget --post-data "$PARAMS" --header "$HADERS" "$INFOURL" -q -O -)
	fi

	local URL=$(get_package_url "$INFO")

	if [ ! $URL ]; then
		# Could not get the package URL.
		echo "* Could not get $1's package URL."
		return
	fi

	# Download the plugin.
	mkdir -p $TMPDIR/downloads
	download $URL $TMPDIR/downloads/$1.zip
	unzip -q $TMPDIR/downloads/$1.zip -d $PWD

	local VERSION=$(get_package_version $INFO)

	if [[ $? == 0 ]] ; then
		echo "* $1 $VERSION installed successfully."
	else
		echo "* $1 $VERSION installation failure."
	fi ;
}

# Download WP All Import Pro
download_plugin wp-all-import-pro

php fix-main-file.php
