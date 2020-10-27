# Vagrant LAMP

Entorno Vagrant LAMP para Desarrollo basado en Ubuntu Server 20.04 con Apache 2.4.41, PHP 7.4, MariaDB 10.3.22, Composer, NPM y Git.

Es una construcción pensada para desarrollar y aprender a programar en PHP y que no contempla requerimientos de seguridad como firewall, contraseñas de BD, etc.
El script de provisionamiento se basa en muchos otros que ya existen en Internet, por lo que es mejorable. Para aprender a desarrollar en PHP durante la primera evaluación puede resultar válida.

## Requisitos 📋

- VirtualBox  <http://www.virtualbox.org>
- Vagrant <http://www.vagrantup.com>
- Git <http://git-scm.com/>

## Qué está instalado 🚀

- Ubuntu Server 20.04 LTS (box generic/ubuntu2004)
- Apache 2.4 con mod rewrite enabled
- PHP 7.4
- MariaDB 10.3.22
- Git
- NPM
- Composer
- Locale 'es_ES.UTF-8 UTF-8'
- Teclado español

## Paquetes PHP incluidos

- php-pdo
- php-mysql
- php-mbstring
- php-bcmath
- php-xml
- php-intl
- php-common
- php-readline
- php-tokenizer
- php-gd
- php-imagick
- php-curl
- php-zip
- php-xdebug
- php-json
- php-opcache
- php-fpm

## Uso 🔧

```bash
mkdir dirtrabajo
cd dirtrabajo
git clone https://github.com/mlls2014/vagrant-lamp-t2.git .
vagrant up
```

Después de que la máquina virtual se instale y termine de provisionarse, puedes ir con tu navegador favorito a <http:\\192.168.250.254>.

Para acceder por _ssh_ utilizando _vagrant_ puedes teclear desde el directorio de trabajo

```bash
vagrant ssh
```

El acceso con otros clientes como _winscp_ o _putty_ es posible utilizando el _usuario_: *vagrant* _contraseña_: *vagrant*.

## Sobre la base de datos 📦

Para asegurar la instalación de MariaDB debemos ejecutar, la primera vez que entremos en la máquina virtual, el siguiente comando

```bash
sudo mysql_secure_installation
```

Con esto, verá una serie de solicitudes mediante las cuales podrá realizar cambios en las opciones de seguridad de su instalación de MariaDB. En la primera solicitud se pedirá que introduzca la contraseña root de la base de datos actual. Debido a que no configuramos una aún, pulse ENTER para indicar “none” (ninguna).

En la siguiente solicitud se pregunta si desea configurar una contraseña root de base de datos. En Ubuntu, la cuenta root para MariaDB está estrechamente vinculada al mantenimiento del sistema automatizado. Por lo tanto, no deberíamos cambiar los métodos de autenticación configurados para esa cuenta. Hacer esto permitiría que una actualización de paquetes dañara el sistema de bases de datos eliminando el acceso a la cuenta administrativa. Escriba N y pulse ENTER.

Desde allí, puede pulsar Y y luego ENTER para aceptar los valores predeterminados para todas las preguntas siguientes. Con esto, se eliminarán algunos usuarios anónimos y la base de datos de prueba, se deshabilitarán las credenciales de inicio de sesión remoto de root y se cargarán estas nuevas reglas para que MariaDB aplique de inmediato los cambios que realizó.

### Crear un usuario administrativo que emplea la autenticación por contraseña

En los sistemas Ubuntu con MariaDB 10.03, el root user de MariaDB se configura para autenticar usando el complemento _unix_socket_ por defecto en vez de con una contraseña. Esto proporciona una mayor seguridad y utilidad en muchos casos, pero también puede generar complicaciones cuando necesita otorgar derechos administrativos a un programa externo (por ejemplo, phpMyAdmin).

Debido a que el servidor utiliza la cuenta root para tareas como la rotación de registros y el inicio y la deteneción del servidor, es mejor no cambiar los detalles de autenticación root de la cuenta. La modificación de las credenciales del archivo de configuración en /etc/mysql/debian.cnf puede funcionar al principio, pero las actualizaciones de paquetes pueden sobrescribir esos cambios. En vez de modificar la cuenta root, los mantenedores de paquetes recomiendan crear una cuenta administrativa independiente para el acceso basado en contraseña.

Para hacerlo, crearemos una nueva cuenta llamada admin con las mismas capacidades que la cuenta root, pero configurada para la autenticación por contraseña. Abra la línea de comandos de MariaDB desde su terminal:

```bash
sudo mariadb
```

A continuación, cree un nuevo usuario con privilegios root y acceso basado en contraseña, que nos permita acceder a la base de datos desde cualquier host. Asegúrese de cambiar el nombre de usuario y la contraseña para que se adapten a sus preferencias:

```bash
MariaDB [(none)]> GRANT ALL ON *.* TO 'admin'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
```

> Con el _%_ conseguimos que el usuario _admin_ pueda acceder con HeidiSQL desde la máquina anfitrión. Para acceder a la base de datos desde los scripts php o desde _phpmyadmin_ el % no sería necesario, se podría poner _localhost_.

Vacíe los privilegios para garantizar que se guarden y estén disponibles en la sesión actual:

```bash
MariaDB [(none)]> FLUSH PRIVILEGES;
```

Después de esto, cierre el shell de MariaDB:

```bash
MariaDB [(none)]> exit
```

Ahora podemos gestionar la BD desde el anfitrión con un programa tipo HeidiSQL o MySQL WorkBench. Utilizamos el usuario _admin_ creado más arriba.

## Si queremos instalar phpmyadmin en la máquina

Por simplicidad no hemos incluido la instalación desatentida de phpmyadmin en el script _bootstrap.sh_, por lo que esta instalación la tendremos que hacer de forma manual.

Ejecutamos la instalación de phpmyadmin:

```bash
sudo apt install phpmyadmin
```

- Selecciomos el servidor web apache2

- Configuramos la base de datos para phpmyadmin con dbconfig-common tal y como nos pide el asistente

- Proporcionamos la contraseña para el usuario phpmyadmin

Y ya podremos acceder a la interfaz web de phpmyadmin en la url http://192.168.250.254/phpmyadmin

Deberíamos poder entrar con el usario _admin_ creado anteriormente.

## Sobre la depuración de código PHP. Instalación de XDebug 🛠️

El paquete _php-xdebug_ ya se encuentra instalado en nuestra máquina virtual y configurado para permitir la depuración en máquina remota (nuestro Windows anfitrión).

La configuración realizada sobre el Ubuntu Server ha sido:

Fichero **/etc/php/7.4/mods-available**

```bash
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_autostart = 1
xdebug.remote_connect_back = 1
xdebug.remote_port = 9000
xdebug.idekey = VSCODE
xdebug.max_nesting_level = 512
```

Fichero **/etc/php/7.4/apache2/php.ini**

Se agregan al final las siguientes líneas

```bash
[XDebug]
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
```

Queda pendiente la configuración en el Entorno de Desarrollo Integrado (IDE) elegido para programar en PHP.

## Depurar código PHP en IDE Visual Code 🛠️

- El primer paso sería instalar la extensión _PHP Debug_ de Felix Becker.

![PHP Debug Felix Becker](./img/phpdebug.png)

- Teniendo abierto el directorio raíz desde el que se va a ejecutar el código php que deseamos depurar (_Open Folder_) vamos a pinchar en el botón de depuración (símbolo play + bug). Creamos un fichero json de depuración (_create a launch.json file_). En este ejemplo tenemos abierto el directorio de trabajo del repositorio _dirtrabajo_.

![Crear json](./img/createjson.png)

- Seleccionamos el _Enviroment PHP_ y dejamos el fichero _launch.json_ de esta forma:

![Json file](./img/jsonfile.png)

La directiva _pathMappings_ mapea los directorios del server al host.

La variable de entorno de VSCode _${workspaceFolder}_ representa el directorio de trabajo abierto en VSCode.

En este ejemplo indicamos que el proyecto a depurar se encuentra en el servidor en la ruta _/vagrant/source_, y en el host cliente en la ruta _${workspaceFolder}_. (El directorio abierto en VSCode es el _source_).

- A continuación ponemos los puntos de interrupción deseados en el código php, pinchamos en _Run - Start Debugging F5_ y abrimos la página php en el navegador. La depuración debería comenzar.

## Datos 📖

- Dirección IP de la nueva máquina *192.168.250.254*
- Document root es */vagrant/source*
- Directorio compartido con Host OS es /vagrant
- mod rewritee enabled
- XDebug idekey = VCode
- Puerto remoto para XDebug es 9000

## Más datos 📌

Añade la siguiente línea a tu archivo hosts:

```bash
192.168.250.254   somehost.dev
```

y podrás usar *somehost.dev* en tu navegador en vez de la IP.
