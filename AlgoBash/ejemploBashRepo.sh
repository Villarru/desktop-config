#! /bin/bash
ruta=$(pwd)
name=$1
nombreRepo=""
reenviarSolicitud=false
leeme=$ruta"/README.md"
token="n"
fail=false
ad="\033[0;33mAdvertencia: \033[0m":
err="\033[1;31mError: \033[0m"

# Busca archivo local encriptado con token de acceso
obtenerToken(){
    cd ~
    pass=".pss"
    clave=$pass".gpg"
    
    if [ -f $clave  ]; then
        gpg -o $pass -d $clave
        if [ -f $pass  ]; then
            token=$(head -n 1 $pass)
            rm $pass
        fi
    else
        echo -e "$err Archivo '$clave' no fue encontrado."
    fi
}


recibirNombreRepo(){
    read -r -p $'Nombre: ' name 
    nombreRepo=$(echo $name | tr ' ' -)
}

# Le pide a la api de github crear un repositorio con el nombre introducido
solicitud(){
    curl -u Villarru:$token https://api.github.com/user/repos -d '{"name": "'"$nombreRepo"'", "private":false}' > ./mensaje   
    respuesta=$(cat ./mensaje)
    rm ./mensaje
    if echo "$respuesta" | grep -q "already exists"; then
        reenviarSolicitud=true
        echo -e "$ad Ya hay un repositorio con ese nombre"
        recibirNombreRepo
    elif echo "$respuesta" | grep -q "Repository creation failed."; then
        echo -e "$err Hubo un error al realizar la peticiíon a la API de git hub"
        echo "$respuesta"
        fail=true
        reenviarSolicitud=false
    else
        reenviarSolicitud=false
    fi

}

# Esto es porque las funciones acá no retornan valores
enviarSolicitud(){
    solicitud
    while $reenviarSolicitud
    do
        solicitud
    done
}


prepararCarpeta(){
    # Si estoy en Docs seguramente ya inicié mi proyecto
    # Si no, entonces se va a mi carpeta /repos para iniciar proyecto desde 0
    if echo "$ruta" | grep -q "Docs"; then
        echo "Creando repositorio en carpeta acutal..."
        cd $ruta
    else
        echo "El repositprio se creará en ~/repos"   
        cd ~/repos

        # Verifica que no exista una carpeta con el nombre
        if [ -d "$nombreRepo" ]; then 
             while [ -d "$nombreRepo" ]
            do   
                echo -e "$ad Ya existe un Archivo en /repos con el nombre '$nombreRepo'" 
                recibirNombreRepo
            done
        else
            mkdir $nombreRepo
            cd ./$nombreRepo
        fi
    fi
}

# Crea archivo README.me y prepara un mensaje en caso de que ya hubiese uno
crearReadme(){
    if [ -f $leeme ]; then
        msg="$ad Había un archivo readme en esta carpeta, se le  ha concatenado: '# $nombreRepo'"
    fi
    echo "# $nombreRepo" >> README.md
}

crearRepositorio(){
    enviarSolicitud

    # Igual esto es porque enviarSolicitud no retorna nada
    if $fail; then
        echo ""
    else
        GIT_URL="git@github.com:Villarru/"$nombreRepo".git"
        git init
        msg=""
        crearReadme
        git add .
        git commit -m "Creación de repositorio"
        git branch -M main
        git remote add origin $GIT_URL
        git push -u origin main
        echo ""
        echo -e "$msg"
    fi
}

main(){
    if [ -d "$ruta""/.git/" ]; then
        echo -e "$err Parece que ya existe un '.git' en esta carpeta"
    else
        obtenerToken
        if [ "$token" == "n" ]; then
            echo -e "$err Problema al desencriptar token de acceso a github"
        else
            echo "Introduce el nombre del repositorio"
            while [ -z "$name" ]
            do
                recibirNombreRepo
            done
            prepararCarpeta
            crearRepositorio
        fi
    fi
}

main
