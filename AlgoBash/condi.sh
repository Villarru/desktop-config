#! /bin/bash
entrada=$1
ruta=""
aqui=$(pwd)
proyecto="Cargo.toml"

debug(){
    echo "entrada: $entrada"
    echo "ruta: $ruta"
    echo "estamos en: $aqui"
    echo "variable proyecto: $proyecto"
}

buscarEjecutar(){
    ruta=$(find $aqui -name "$proyecto" | head -n 1)
    if [ "$ruta" == "" ]; then
	echo "No encontre $proyecto"
    else
	if echo "$ruta" | grep -q "Cargo.toml"; then
	    ruta=$(dirname "$ruta")
	fi
	cd "$ruta"
	echo ""
	cargo run
    fi
}

if  [ -z "$entrada" ]; then
    if ! echo "$aqui" | grep -q "projects/\|repos/"; then
	echo "Solo puedo ejecutar archivos de /projects o /repos"
    else
	buscarEjecutar
    fi
else
    if echo "$entrada" | grep -q "/"; then
	if echo "$entrada" | grep -q "projects/\|repos/"; then	    
	    if echo "$entrada" | grep -q "/src/"; then
		aqui=$(dirname "$entrada" "src")
		buscarEjecutar
	    else
		entrada=$(basename $entrada)
		proyecto=$entrada
		echo "buscando archivo $entrada"
		cd ~
		if [ -d "$proyecto" ]; then
		    if echo "$proyecto" | grep -q "src|.rs|"; then
			echo "No puedo ejecutar $proyecto"
		    else
			buscarEjecutar
		    fi
		else
		    echo "No puedo ejecutar $entrada"
		fi
	    fi
	else
	    echo "Solo puedo ejecutar archivos de /projects o /repos"
	fi
    else
	proyecto="$entrada"
	buscarEjecutar
    fi
fi
	
