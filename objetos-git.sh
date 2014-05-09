#!/usr/bin/env bash

# Comprobación de parámetros
if [ "$#" -ne 1 ]
then
  echo -e "\n\tUso: objetos-git.sh <ruta al repositorio Git>\n"
  exit 1
fi

echo "Cambiando al repositorio..."
cd $1

# Determina el SHA1 del HEAD
#head=$(cat .git/"$(cat .git/HEAD | cut -d' ' -f2)")
head=$(git rev-parse --verify HEAD)

# Forma una lista de los SHA1 de los objetos (excluyendo el subdirectorio 'pack')
objectos=$(find .git/objects -type f | cut -d/ -f3-4 | grep '^[^p]')

# Forma correctamente el SHA1 de cada objeto y lo procesa.
# El SHA1 se compone del nombre del directorio más el nombre del archivo:
# Ej: 07/abcdef12345....
for objeto in ${objectos}
  do
    # Elimina la barra invertida
    objeto=${objeto/\//}

    info='Objeto: '$objeto
    echo $info

    # Imprime el tipo de objeto
    echo -e "\t"$(git cat-file -t $objeto)

    # Se trata del HEAD
    if [ $objeto == $head ]; then
      echo -e "\t***** HEAD! *****\n"
    fi

  done

echo "Dejando el repositorio..."
cd -
