#!/bin/bash

# Distancia total a recorrer en km
total_km=36000
speed=300  # Velocidad constante en km/h

# Ancho de la barra de progreso
bar_width=9

# Marca de tiempo inicial
start_time=$(date +%s)

# Calcular tiempo total estimado basado en velocidad y distancia
estimated_total_time=$(( (total_km * 3600) / speed ))

format_time() {
    local seconds=$1
    local days=$((seconds / 86400))
    local hours=$(( (seconds % 86400) / 3600 ))
    local minutes=$(( (seconds % 3600) / 60 ))
    local secs=$((seconds % 60))

    if (( days > 0 )); then
        printf "%d días, %02d:%02d:%02d" "$days" "$hours" "$minutes" "$secs"
    else
        printf "%02d:%02d:%02d" "$hours" "$minutes" "$secs"
    fi
}

while true; do
    # Tiempo transcurrido
    elapsed=$(( $(date +%s) - start_time ))

    # Calcular distancia recorrida según el tiempo real transcurrido
    current_km=$(awk "BEGIN {print $speed * $elapsed / 3600}")

    # Limitar current_km a total_km
    if (( $(awk "BEGIN {print ($current_km >= $total_km)}") )); then
        current_km=$total_km
    fi

    # Calcula porcentaje de progreso
    percent=$(awk "BEGIN {print int($current_km * 100 / $total_km)}")

    # Calcula la barra de progreso
    filled=$(awk "BEGIN {print int($percent * $bar_width / 100)}")
    bar=$(printf "%-${bar_width}s" "#" | sed "s/ /#/g")
    bar=${bar:0:filled}$(printf "%$((bar_width - filled))s")

    # Calcular tiempo restante real
    remaining_time=$(( estimated_total_time - elapsed ))

    # Evitar valores negativos
    if (( remaining_time < 0 )); then
        remaining_time=0
    fi

    # Muestra la barra de progreso 🚗
    printf "\r\033[K[%s] %3d%% %6.2fkm/%dkm %3dkm/h | ⏳ %s" \
        "$bar" "$percent" "$current_km" "$total_km" "$speed" "$(format_time "$remaining_time")"

    # Romper el bucle si hemos llegado al destino
    if (( $(awk "BEGIN {print ($current_km >= $total_km)}") )); then
        break
    fi

    sleep 0.2  # Simula el tiempo real de actualización
done

# Tiempo total transcurrido
total_time=$(( $(date +%s) - start_time ))

# Imprimir mensaje final con el tiempo total
echo -e "\n🚗🏁 Viaje completado en $(format_time "$total_time")."
