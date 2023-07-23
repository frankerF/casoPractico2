# Obtiene a partir de un output de terraform un yaml de inventory dejándolo en la carpeta principal de ansible.
terraform -chdir=../terraform/ output -raw ip_address > ./inventory.yaml
# Obtiene a partir de un output de terraform la contraseña del administrador de acr dejándola en un fichero regpass.
terraform -chdir=../terraform/ output -raw acr_admin_password > ./files/regpass

# Genera certificados autofirmados que se utilizarán en el servicio web.
ansible-playbook 00_pbcertificados.yaml
# Descarga las imágenes necesarias para la práctica, las etiqueta y las sube al container registry
ansible-playbook 01_pbgenimagespush.yaml
# Parte del servicio web. Sobre la máquina del inventario, instala los paquetes necesarios, descarga imágenes y las prepara para que se ejecuten al arrancar.
ansible-playbook -i inventory.yaml 02_preparaservicio.yaml

# Paso manual, actualizamos las credenciales del aks para poder trabajar en azure.
az aks get-credentials --name fran-CP2-tf-k8s --resource-group fran-cp2-tf-rg

# Crea un namespace y le pasa un yaml con la definición del despliegue a realizar sobre kubernetes.
ansible-playbook 03_playb_kube.yaml