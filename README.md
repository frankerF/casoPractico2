# casoPractico2
Código fuente del caso práctico 2.

En la carpeta terraform, se encuentra el despliegue de la arquitectura en azure.

## Despliegue de infraestructura en terraform
Una vez clonado el repositorio, ir a la carpeta terraform y ejecutar

`terraform apply`

Como salida devolverá lo siguiente:
```
acr_admin_password = <sensitive>
acr_podman_login = <sensitive>
conex_ssh = "ssh -i ~/.ssh/id_rsa.pub frankerFcp2@<ipservicioweb>"
ip_address = <<EOT
all:
  hosts:
    <ipservicioweb>:
EOT
ipaks = "MC_fran-cp2-tf-rg_fran-CP2-tf-k8s_uksouth"
```
Con el comando `terraform output conex_ssh` podremos tener el comando para conectarnos directamente a la máquina del servicio web.<br>
Con el comando `terraform output -raw ip_address` podremos tener la descripción del inventory.yaml<br>
Y la variable de salida `acr_podman_login` contendrá el password del container registry.
El usuario se pone en la configuración y es conocido.

## Despliegue de las aplicaciones en ansible
Los playbooks de ansible se desplegarán llamando al fichero `deploy.sh`.


Consta de 4 playbooks 

`00_pbcertificados.yaml` Genera certificados autofirmados para la aplicación web contenerizada.

`01_pbgenimagespush.yaml` Crea y sube al ACR las imágenes necesarias para desplegar las aplicaciones.

`02_preparaservicio.yaml` instala dependencias y carga la imagen del acr mediante un demonio para tener persistencia a los reinicios.

`03_playb_kube.yaml` Crea un namespace de kubernetes y lo configura a través de una plantilla yaml.


