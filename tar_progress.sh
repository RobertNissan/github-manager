#!/bien/bash

function tar_extrator_progress() {
    total=$(tar -tzf Busca-Palabras.tar.gz | wc -l)
    count=0

    tar -xvzf Busca-Palabras.tar.gz | while read -r line; do
        count=$((count + 1))
        percent=$((count * 100 / total))
        echo -ne "Progreso: $percent% [$count/$total] archivos extraídos...\r"
    done

    echo -e "\nExtracción completada."
    sleep 1
}