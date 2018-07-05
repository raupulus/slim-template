.PHONY: all test tests install db dbload psql clean permisos perm p \
requeriments req dbf dbfull dbh dbheroku dbc dbcreate apache

all: requeriments install dbfull permisos

test tests:
	tests/main.sh

install:
	composer install
	composer run-script post-create-project-cmd

db dbload:
	db/load.sh

dbc dbcreate:
	db/create.sh

dbf dbfull: dbcreate dbload

dbh dbheroku:
	heroku psql < db/plantilla.sql
	heroku psql < db/plantilla_datos.sql

psql:
	db/psql.sh

clean:
	find 'runtime' -not -path 'runtime' -not -name ".gitignore" -exec rm -Rf {} \; || echo ''
	find 'tmp' -not -path 'tmp' -not -name ".gitignore" -exec rm -Rf {} \; || echo ''

permisos perm p:
	echo 'Aplicando permisos para desarrollo. No usar en producción, son inseguros'
	sudo chmod -R 760 .
	sudo chmod -R 775 v1
	sudo chmod -R 777 tmp/*
	bash -c 'yo=$(shell whoami) && sudo chown -R $${yo}:www-data .'

requeriments req:
	echo 'Instalando dependencias'

apache:
	./desplegar.sh
