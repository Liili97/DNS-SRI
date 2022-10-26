# Lineas del docker-compose explicada

```
services:
  bind9:
    container_name: asir_bind9
    image: internetsystemsconsortium/bind9:9.11
    ports:
      - 530:53/tcp
      - 530:53/udp
    networks:
        bind9_subnet:
          ipv4_address: 10.1.0.224
    volumes:
      - /home/asir2a/Escritorio/SRI/DNS/conf:/etc/bind
      - /home/asir2a/Escritorio/SRI/DNS/zonas:/var/lib/bind
  asir_cliente:
    container_name: asir_cliente
    image: alpine
    networks:
      bind9_subnet:
          ipv4_address: 10.1.0.220
    stdin_open: true #docker run -i
    tty: true
    dns:
      - 10.1.0.224
networks:
  bind9_subnet:
    external: true      
```


### DNS
#### Configuración principal
* **Image**

  Tendremos que poner que imagen queremos levantar con esta configuracion, pondremos la version con :xx.xx
* **Ports**

  Aquí podremos decir por que puertos queremos que entren desde el servicio a los puertos desde la maquina.



#### Configuración de red

* **Networks**
  Tenemos una subred llamada bind_subnet, y ip_address la ip estatica de la maquina.

#### Volumenes
  En la linea de los volumenes, veremos como juntamos dos direcciones, una de la maquina real, y otra dentro del servicio de BIND, es tan facil como que todo lo que guardemos dentro de la carpeta en la maquina real, se guardara automaticamente en la maquina. 
Asi si el servicio se cae, o lo borramos, nunca nos deharemos de la configuración.


### Cliente
#### Configuración principal

  Muy similar a la de la maquina del DNS.
#### Conectividad con DNS
  Simplemente le daremos una configuración para que se conecte directamente a la IP de nuestro DNS ya levantado y configurado.


# Procedimiento de creación de servicios (contenedor)


# Ficheros de configuración

Yo he creado una carpeta llamada conf, y otra llamada zonas, en ellas guardaremos los ficheros db.elisasir.com, named.conf, named.conf.local y named.conf.local
## ZONAS
Un fichero llamado en mi caso db.elisair.com:

```
$TTL    3600
@       IN      SOA     ns.elisasir.com. some.email.address. (
                        2000000005  ;   Serial
                        3600        ;   Refresh [1h]
                        600         ;   Retry   [10m]
                        86400       ;   Expire  [1d]
                        86400       ;   minimum [1m]
                        )

@       IN      NS      ns.elisasir.com.
ns      IN      A       10.1.0.224
test    IN      A       10.1.0.2
alias   IN      CNAME   test

```

##### Terminos de zonas
* **TTL**
  o tiempo de vida (en inglés, time to live, abreviado TTL) es un concepto usado para indicar por cuántos nodos puede pasar un paquete antes de morir.
* **NS**
  (Name server), se traduce en la ip que queramos traducir por un nombre.
* **A**
   se refiere a la parte de IP
* **CNAME**
  es un ALIAS, pero en la base el concepto es parecido con NS

## named.conf

```
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";

```
Es una redireccion a dos ficheros de configuración para no hacer uno demasiado largo, y desordenado.

## named.conf.local
```
zone "elisasir.com." {
        type master;
        file "/var/lib/bind/db.elisasir.com";
        notify explicit;
};
```
Hacemos referencia a la ZONA y al fichero de configuración del mismo.


## named.conf.options
```
options{
    directory "/var/cache/bind";
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
    forward only;

    listen-on { any; };
    listen-on-v6 { any; };
    allow-query { any; };
};
```
Aqui configuramos los forwarderds, que es una forma para resolver la IP.


### Levantar el sercicio 

```
docker-compose up
```
