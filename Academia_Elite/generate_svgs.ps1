# Function to write SVG to file
function New-Svg {
    param($Id, $Content)
    $path = "c:\Users\visitante\Desktop\academia-app\Academia_Elite\images\trivia\$Id.svg"
    Set-Content -Path $path -Value $Content
}

# 1. PARE (Octagono Rojo)
New-Svg -Id 1 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path d="M30,5 L70,5 L95,30 L95,70 L70,95 L30,95 L5,70 L5,30 Z" fill="#b71c1c" stroke="white" stroke-width="2"/><text x="50" y="55" font-family="Arial" font-size="20" font-weight="bold" fill="white" text-anchor="middle">PARE</text></svg>'

# 2. Semaforo ROJO
New-Svg -Id 2 -Content '<svg width="200" height="400" viewBox="0 0 100 200" xmlns="http://www.w3.org/2000/svg"><rect x="10" y="10" width="80" height="180" rx="10" fill="#222"/><circle cx="50" cy="40" r="25" fill="#ff0000"/><circle cx="50" cy="100" r="25" fill="#550000"/><circle cx="50" cy="160" r="25" fill="#003300"/></svg>'

# 3. Curva Izquierda (Rombo Amarillo)
New-Svg -Id 3 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="50" y="7.5" width="60" height="60" transform="rotate(45 50 50)" fill="#fdd835" stroke="black" stroke-width="2"/><path d="M50,75 V50 A20,20 0 0,0 30,30 H20" fill="none" stroke="black" stroke-width="8" stroke-linecap="round"/><path d="M15,30 L35,20 L35,40 Z" fill="black"/></svg>'

# 4. Prohibido Girar U (Circulo Rojo tachado)
New-Svg -Id 4 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="45" fill="white" stroke="#b71c1c" stroke-width="10"/><path d="M30,35 A20,20 0 1,0 70,35 V60" fill="none" stroke="black" stroke-width="6"/><path d="M60,60 L80,60 L70,75 Z" fill="black"/><line x1="20" y1="20" x2="80" y2="80" stroke="#b71c1c" stroke-width="8"/></svg>'

# 5. Prohibido Parquear (Circulo Rojo P tachada)
New-Svg -Id 5 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="45" fill="white" stroke="#b71c1c" stroke-width="10"/><text x="50" y="70" font-family="Arial" font-size="60" font-weight="bold" fill="black" text-anchor="middle">P</text><line x1="20" y1="20" x2="80" y2="80" stroke="#b71c1c" stroke-width="8"/></svg>'

# 6. Cinturon Seguridad (Icono)
New-Svg -Id 6 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect width="100" height="100" fill="#eee"/><path d="M20,20 L80,80" stroke="#333" stroke-width="15"/><circle cx="50" cy="50" r="20" fill="#333"/></svg>'

# 7. Zona Escolar (Rombo Amarillo Ninos)
New-Svg -Id 7 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="50" y="7.5" width="60" height="60" transform="rotate(45 50 50)" fill="#fdd835" stroke="black" stroke-width="2"/><circle cx="40" cy="40" r="5" fill="black"/><rect x="35" y="45" width="10" height="15" fill="black"/><circle cx="60" cy="35" r="6" fill="black"/><rect x="54" y="42" width="12" height="18" fill="black"/></svg>'

# 8. Primeros Auxilios (Azul Cruz Roja)
New-Svg -Id 8 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect width="100" height="100" fill="#0277bd"/><rect x="40" y="20" width="20" height="60" fill="white"/><rect x="20" y="40" width="60" height="20" fill="white"/><rect x="45" y="25" width="10" height="50" fill="#b71c1c"/><rect x="25" y="45" width="50" height="10" fill="#b71c1c"/></svg>'

# 9. Semaforo AMARILLO
New-Svg -Id 9 -Content '<svg width="200" height="400" viewBox="0 0 100 200" xmlns="http://www.w3.org/2000/svg"><rect x="10" y="10" width="80" height="180" rx="10" fill="#222"/><circle cx="50" cy="40" r="25" fill="#550000"/><circle cx="50" cy="100" r="25" fill="#fdd835"/><circle cx="50" cy="160" r="25" fill="#003300"/></svg>'

# 10. Contravia (Flecha Roja Tachada - SR-02 es Circulo rojo fondo blanco)
New-Svg -Id 10 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="45" fill="white" stroke="#b71c1c" stroke-width="10"/><path d="M50,20 V80 M40,30 L50,20 L60,30" fill="none" stroke="black" stroke-width="8"/><line x1="20" y1="20" x2="80" y2="80" stroke="#b71c1c" stroke-width="8"/></svg>'

# 11. Velocidad 30
New-Svg -Id 11 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="45" fill="white" stroke="#b71c1c" stroke-width="10"/><text x="50" y="65" font-family="Arial" font-size="50" font-weight="bold" fill="black" text-anchor="middle">30</text></svg>'

# 12. Doble Linea Amarilla
New-Svg -Id 12 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect width="100" height="100" fill="#555"/><line x1="45" y1="0" x2="45" y2="100" stroke="#fdd835" stroke-width="6"/><line x1="55" y1="0" x2="55" y2="100" stroke="#fdd835" stroke-width="6"/></svg>'

# 13. Ceda el Paso
New-Svg -Id 13 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path d="M5,5 L95,5 L50,90 Z" fill="white" stroke="#b71c1c" stroke-width="10"/><text x="50" y="35" font-family="Arial" font-size="14" font-weight="bold" fill="black" text-anchor="middle">CEDA</text><text x="50" y="50" font-family="Arial" font-size="14" font-weight="bold" fill="black" text-anchor="middle">EL PASO</text></svg>'

# 14. Solo Derecha
New-Svg -Id 14 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="48" fill="#0277bd"/><path d="M30,70 V50 A20,20 0 0,1 50,30 H60" fill="none" stroke="white" stroke-width="8"/><path d="M60,20 L80,30 L60,40 Z" fill="white"/></svg>'

# 15. Resalto
New-Svg -Id 15 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="50" y="7.5" width="60" height="60" transform="rotate(45 50 50)" fill="#fdd835" stroke="black" stroke-width="2"/><path d="M25,60 Q35,40 50,60 Q65,40 75,60" fill="none" stroke="black" stroke-width="5"/></svg>'

# 16. Celular
New-Svg -Id 16 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect width="100" height="100" fill="white"/><rect x="35" y="20" width="30" height="60" rx="3" stroke="black" stroke-width="2" fill="none"/><line x1="20" y1="20" x2="80" y2="80" stroke="#b71c1c" stroke-width="8"/></svg>'

# 17. Gasolina
New-Svg -Id 17 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect width="100" height="100" fill="#0277bd"/><rect x="30" y="30" width="30" height="40" fill="white"/><path d="M60,30 L70,30 L70,50 L60,40" stroke="white" stroke-width="3" fill="none"/></svg>'

# 18. Cebra Peatonal
New-Svg -Id 18 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="50" y="7.5" width="60" height="60" transform="rotate(45 50 50)" fill="#fdd835" stroke="black" stroke-width="2"/><circle cx="50" cy="35" r="5" fill="black"/><rect x="45" y="40" width="10" height="20" fill="black"/><line x1="30" y1="70" x2="70" y2="70" stroke="black" stroke-width="5" stroke-dasharray="10,5"/></svg>'

# 19. Preventiva Semaforo
New-Svg -Id 19 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="50" y="7.5" width="60" height="60" transform="rotate(45 50 50)" fill="#fdd835" stroke="black" stroke-width="2"/><rect x="40" y="30" width="20" height="40" fill="black"/><circle cx="50" cy="38" r="4" fill="#b71c1c"/><circle cx="50" cy="50" r="4" fill="#fdd835"/><circle cx="50" cy="62" r="4" fill="#4caf50"/></svg>'

# 20. Casco Moto
New-Svg -Id 20 -Content '<svg width="400" height="400" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect width="100" height="100" fill="white"/><circle cx="50" cy="50" r="30" fill="#333"/><rect x="40" y="40" width="30" height="20" fill="#888"/></svg>'

Write-Host "SVGs Generated."
