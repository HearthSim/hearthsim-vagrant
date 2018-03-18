#!/bin/bash

basedir="."

if [[ ! -e "$basedir/HSReplay.net" ]]; then
	git clone "git@github.com:HearthSim/HSReplay.net" "$basedir/HSReplay.net"
fi

if [[ ! -e "$basedir/stripe-mock" ]]; then
	git clone "git@github.com:stripe/stripe-mock.git" "$basedir/stripe-mock"
fi

if [[ ! -e "$basedir/HSReplay.net/hsreplaynet/local_settings.py" ]]; then
	echo "Generating new local_settings.py"
	cp "$basedir/scripts/local_settings.py" "$basedir/HSReplay.net/hsreplaynet/local_settings.py"
fi

echo "Running build"
docker-compose build
docker-compose pull

docker-compose run django /opt/hsreplay.net/source/scripts/get_vendor_static.sh
docker-compose run django django-admin.py migrate
docker-compose run django python /opt/hsreplay.net/initdb.py

echo
echo "All done. Run the following command to start:"
echo "    $ docker-compose up"
