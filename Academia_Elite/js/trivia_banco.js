/**
 * TRIVIA ACADEMIA ÉLITE - BANCO DE PREGUNTAS COMPLETO
 * Niveles: 1 (Fácil), 2 (Medio), 3 (Difícil)
 * Reglas: Nivel 1 (3 opciones), Niveles 2 y 3 (4 opciones).
 */

const TRIVIA_DATA = {
    // =========================================================================
    // NIVEL 1: FÁCIL (3 Opciones) - Señales básicas y Semáforos
    // =========================================================================
    // =========================================================================
    // NIVEL 1: FÁCIL (3 Opciones) - Señales básicas y Semáforos
    // =========================================================================
    1: [
        {
            id: 1,
            q: "Llegas a una intersección y ves esta señal (PARE). ¿Qué debes hacer?",
            img: "images/trivia/1.svg",
            options: ["Disminuir velocidad", "Detenerte por completo (0 km/h)", "Pitar antes de pasar"],
            correct: 1,
            feedback: "¡Exacto! PARE significa CERO velocidad. Detención total obligatoria. 🛑"
        },
        {
            id: 2,
            q: "¿Qué indica la luz ROJA fija en el semáforo?",
            img: "images/trivia/2.svg",
            options: ["Giro permitido con precaución", "Detención obligatoria", "Acelerar a fondo"],
            correct: 1,
            feedback: "¡Bien! El rojo no es negociable. Detente siempre. 🚦"
        },
        {
            id: 3,
            q: "Vas en carretera y ves esta señal. ¿Qué te espera?",
            img: "images/trivia/3.svg",
            options: ["Curva peligrosa a la izquierda", "Desvío obligatorio", "Zona de derrumbes"],
            correct: 0,
            feedback: "¡Correcto! Reduce velocidad antes de entrar a la curva. ↩️"
        },
        {
            id: 4,
            q: "Ves la señal 'Prohibido Girar en U'. ¿Puedes devolverte en este punto?",
            img: "images/trivia/4.svg",
            options: ["Sí, si es rápido", "No, está prohibido", "Solo motos"],
            correct: 1,
            feedback: "¡Así es! Busca un retorno autorizado más adelante. 🔄"
        },
        {
            id: 5,
            q: "¿Puedes estacionar donde está esta señal?",
            img: "images/trivia/5.svg",
            options: ["No, Prohibido Parquear", "Solo 5 minutos", "Sí, si me quedo dentro"],
            correct: 0,
            feedback: "¡Muy bien! Evita multas y grúas. 🏗️"
        },
        {
            id: 6,
            q: "¿Quiénes deben usar el cinturón de seguridad?",
            img: "images/trivia/6.svg",
            options: ["Solo el conductor", "Conductor y copiloto", "Todos los ocupantes"],
            correct: 2,
            feedback: "¡Excelente! La seguridad es para todos, adelante y atrás. 🛡️"
        },
        {
            id: 7,
            q: "Ves la señal 'Zona Escolar'. ¿Límite de velocidad usual?",
            img: "images/trivia/7.svg",
            options: ["30 km/h", "60 km/h", "80 km/h"],
            correct: 0,
            feedback: "¡Responsable! Los niños son impredecibles, baja la velocidad. 🚸"
        },
        {
            id: 8,
            q: "¿Qué servicio indica esta señal azul con Cruz Roja?",
            img: "images/trivia/8.svg",
            options: ["Taller mecánico", "Puesto de Primeros Auxilios", "Restaurante"],
            correct: 1,
            feedback: "¡Correcto! Ayuda médica cercana si la necesitas. 🚑"
        },
        {
            id: 9,
            q: "El semáforo pasa a AMARILLO. ¿Acción correcta?",
            img: "images/trivia/9.svg",
            options: ["Acelerar para pasar", "Prepararse para detenerse", "Pitar"],
            correct: 1,
            feedback: "¡Prudente! Amarillo significa 'Precaución, va a cambiar a Rojo'. ⚠️"
        },
        {
            id: 10,
            q: "Señal de Flecha Tachada (Contravía). ¿Qué significa?",
            img: "images/trivia/10.svg",
            options: ["Vía cerrada por obras", "Dirección prohibida (Contravía)", "Siga con cuidado"],
            correct: 1,
            feedback: "¡Salvado! Entrar ahí es accidente seguro. ⛔"
        },
        {
            id: 11,
            q: "Señal de velocidad máxima '30'. ¿Regla?",
            img: "images/trivia/11.svg",
            options: ["Mínimo 30 km/h", "Máximo 30 km/h", "Sugerido 30 km/h"],
            correct: 1,
            feedback: "¡Bien leído! No excedas el límite indicado. 📸"
        },
        {
            id: 12,
            q: "¿Puedes adelantar sobre doble línea amarilla?",
            img: "images/trivia/12.svg",
            options: ["Sí, con cuidado", "Nunca, prohibido adelantar", "Solo motos"],
            correct: 1,
            feedback: "¡Excelente! Esa línea es un muro imaginario. 🛣️"
        },
        {
            id: 13,
            q: "Señal 'Ceda el Paso' (Triángulo invertido). Acción:",
            img: "images/trivia/13.svg",
            options: ["Entrar rápido", "Ceder paso a la otra vía", "Pitar"],
            correct: 1,
            feedback: "¡Correcto! La cortesía y la norma evitan choques. 🤝"
        },
        {
            id: 14,
            q: "Señal 'Solo Derecha'. ¿Hacia dónde puedes ir?",
            img: "images/trivia/14.svg",
            options: ["De frente o Derecha", "Únicamente a la derecha", "Izquierda"],
            correct: 1,
            feedback: "¡Bien! Sigue la obligación de la flecha. ➡️"
        },
        {
            id: 15,
            q: "¿Qué indica la señal amarilla de 'Resalto'?",
            img: "images/trivia/15.svg",
            options: ["Bache en la vía", "Reductor de velocidad", "Fin de la vía"],
            correct: 1,
            feedback: "¡Ojo a la suspensión! Reduce velocidad. 📉"
        },
        {
            id: 16,
            q: "¿Hablar por celular sin manos libres?",
            img: "images/trivia/16.svg",
            options: ["Sí, rápido", "Prohibido y peligroso", "Solo en semáforos"],
            correct: 1,
            feedback: "¡Responsable! Manual al volante, celular guardado. 📱🚫"
        },
        {
            id: 17,
            q: "Buscas gasolina. ¿Señal que te sirve?",
            img: "images/trivia/17.svg",
            options: ["Cruz Roja", "Surtidor de Gasolina", "Tenedor y Cuchillo"],
            correct: 1,
            feedback: "¡Tanque lleno! Puedes recargar ahí. ⛽"
        },
        {
            id: 18,
            q: "Prelación en la cebra peatonal:",
            img: "images/trivia/18.svg",
            options: ["El vehículo", "El peatón SIEMPRE", "El más rápido"],
            correct: 1,
            feedback: "¡Caballero/Dama! El peatón es el más vulnerable, respétalo. 🚶"
        },
        {
            id: 19,
            q: "Señal preventiva de Semáforo. Significa:",
            img: "images/trivia/19.svg",
            options: ["Venta de luces", "Aproximación a semáforo", "Pare inmediato"],
            correct: 1,
            feedback: "¡Atento! Se acerca un control semafórico. 🚦"
        },
        {
            id: 20,
            q: "Uso correcto del casco en moto:",
            img: "images/trivia/20.svg",
            options: ["Puesto y abrochado", "En el codo", "Desabrochado"],
            correct: 0,
            feedback: "¡Motero seguro! El casco salva vidas solo si está bien puesto. 🏍️"
        }
    ],

    // =========================================================================
    // NIVEL 2: MEDIO (4 Opciones) - Normas y Mecánica Básica
    // =========================================================================
    2: [
        {
            id: 101,
            q: "En una intersección en 'T' sin señalización, ¿quién tiene la prelación?",
            img: "images/trivia/101.svg",
            options: ["El vehículo que va a girar", "El vehículo que transita por la vía recta (continua)", "El que llegue más rápido", "El vehículo más grande"],
            correct: 1,
            feedback: "¡Correcto! Quien circula por la vía continua tiene prioridad sobre quien va a ingresar a ella. 🛣️"
        },
        {
            id: 102,
            q: "En una glorieta, ¿quién lleva la prelación (vía)?",
            img: "images/trivia/102.svg",
            options: ["El que va a entrar a la glorieta", "El que ya está circulando dentro de ella", "El que va a salir inmediatamente", "Cualquiera, depende del afán"],
            correct: 1,
            feedback: "¡Así es! Debes ceder el paso a los que ya están girando dentro. 🔄"
        },
        {
            id: 103,
            q: "¿Qué indican las señales de tránsito de color NARANJA?",
            img: "images/trivia/103.svg",
            options: ["Sitios turísticos", "Zonas escolares permanentes", "Obras o trabajos temporales en la vía", "Información de servicios"],
            correct: 2,
            feedback: "¡Ojo a las obras! Naranja significa transitoriedad y precaución por trabajos. 🚧"
        },
        {
            id: 104,
            q: "Si la línea central de la carretera es discontinua (punteada), ¿puedes adelantar?",
            img: "images/trivia/104.svg",
            options: ["Sí, siempre que sea seguro y no venga nadie", "No, nunca está permitido", "Solo si es de noche", "Solo si conduces una moto"],
            correct: 0,
            feedback: "¡Luz verde! Discontinua permite adelantamiento bajo condiciones seguras. 🚗"
        },
        {
            id: 105,
            q: "¿Qué distancia de seguridad debes mantener a 60 km/h en pavimento seco?",
            img: "images/trivia/105.svg",
            options: ["5 metros", "Al menos 20-30 metros (regla de 3 segundos)", "Pegado al de adelante", "1 metro para que no se metan"],
            correct: 1,
            feedback: "¡Responsable! La distancia da tiempo de reacción. 📏"
        },
        {
            id: 106,
            q: "En el tablero se enciende una luz roja con símbolo de BATERÍA. ¿Significado?",
            img: "images/trivia/106.svg",
            options: ["Batería 100% cargada", "Falla en el sistema de carga (Alternador)", "Es hora de cambiar las pilas del control", "El motor necesita aceite"],
            correct: 1,
            feedback: "¡Atención! El auto está funcionando solo con la reserva eléctrica. Al taller. ⚡"
        },
        {
            id: 107,
            q: "¿Qué cubre el SOAT (Seguro Obligatorio)?",
            img: "images/trivia/107.svg",
            options: ["Los golpes de latonería de mi carro", "Los daños materiales al otro vehículo", "Atención médica a víctimas (humanos) en accidente", "Robo del vehículo"],
            correct: 2,
            feedback: "¡Bien! El SOAT es para la VIDA y la salud de las personas involucradas. 🚑"
        },
        {
            id: 108,
            q: "¿Cuándo es correcto usar las luces estacionarias (parqueo)?",
            img: "images/trivia/108.svg",
            options: ["Cuando está lloviendo fuerte", "Para parquear donde está prohibido", "Solo en detención de emergencia o parqueo temporal legítimo", "Para cruzar intersecciones rápido"],
            correct: 2,
            feedback: "¡Correcto! No las uses para moverte, son para advertir detención. 🅿️"
        },
        {
            id: 109,
            q: "En una pendiente estrecha donde solo pasa un carro, ¿quién tiene prelación?",
            img: "images/trivia/109.svg",
            options: ["El vehículo que baja", "El vehículo que sube", "El vehículo más pesado", "El que pite más fuerte"],
            correct: 1,
            feedback: "¡Solidario! Es más difícil arrancar subiendo, por eso tienen la vía. ⛰️"
        },
        {
            id: 110,
            q: "Pasarse un semáforo en rojo o una señal de PARE es infracción tipo:",
            img: "images/trivia/110.svg",
            options: ["A (Leve)", "B (Multa moderada)", "D (Muy costosa y riesgo inmovilización)", "No tiene multa si no hay policía"],
            correct: 2,
            feedback: "¡Cuida tu bolsillo y tu vida! Es una de las infracciones más graves (D04). 💸"
        },
        {
            id: 111,
            q: "Las señales de fondo CAFÉ indican:",
            img: "images/trivia/111.svg",
            options: ["Zonas de derrumbe", "Sitios turísticos, culturales o de interés", "Restaurantes obligatorios", "Vías sin pavimentar"],
            correct: 1,
            feedback: "¡Turista experto! Café te guía a lo interesante. 📷"
        },
        {
            id: 112,
            q: "¿Está permitido adelantar en una curva?",
            img: "images/trivia/112.svg",
            options: ["Sí, si tocas la bocina", "Sí, si el de adelante va muy lento", "Nunca, es prohibido por falta de visibilidad", "Solo si es una recta pequeña"],
            correct: 2,
            feedback: "¡Peligro de muerte! En curva no ves quién viene. Prohibido. 🚫"
        },
        {
            id: 113,
            q: "Se prende el testigo de ACEITE (Aladino rojo). ¿Qué haces?",
            img: "images/trivia/113.svg",
            options: ["Conducir rápido a casa", "Detener el motor INMEDIATAMENTE", "Echarle agua al motor", "Esperar que se apague solo"],
            correct: 1,
            feedback: "¡Salvaste el motor! Sin presión de aceite, el motor se funde en segundos. 🛢️"
        },
        {
            id: 114,
            q: "¿Cuál es la tolerancia de alcohol para conductores en Colombia?",
            img: "images/trivia/114.svg",
            options: ["Una cerveza es permitida", "Grado 0 (Tolerancia casi nula)", "Dos copas de vino", "Depende de lo que comas"],
            correct: 1,
            feedback: "¡Ley seca al volante! Colombia tiene sanciones durísimas desde el primer trago. 🍺🚫"
        },
        {
            id: 115,
            q: "¿Quién tiene la prelación en un cruce ferrovial (tren)?",
            img: "images/trivia/115.svg",
            options: ["El automóvil porque es más ágil", "El tren SIEMPRE", "El transporte público de pasajeros", "El que llegue primero a la carrilera"],
            correct: 1,
            feedback: "¡Física pura! El tren no puede frenar rápido. Él gana. 🚂"
        },
        {
            id: 116,
            q: "¿Qué significa una doble línea central continua amarilla?",
            img: "images/trivia/116.svg",
            options: ["Se puede adelantar con precaución", "Prohibido adelantar en ambos sentidos", "Carril exclusivo para emergencias", "División de carril bici"],
            correct: 1,
            feedback: "¡Muro infranqueable! No la pises. 🛑"
        },
        {
            id: 117,
            q: "¿Cuál es la distancia mínima para parquear respecto a una intersección?",
            img: "images/trivia/117.svg",
            options: ["1 metro", "5 metros", "10 metros", "Justo en la esquina"],
            correct: 1,
            feedback: "¡Bien! Deja espacio para que otros giren. (Norma general 5m). 📏"
        },
        {
            id: 118,
            q: "Si vas a girar a la izquierda en una vía de doble sentido, ¿dónde te ubicas?",
            img: "images/trivia/118.svg",
            options: ["En el carril derecho", "En el centro, pegado a la línea central", "En la berma", "En el carril contrario"],
            correct: 1,
            feedback: "¡Técnica correcta! Pégate al eje sin invadirlo. ⬅️"
        },
        {
            id: 119,
            q: "¿Qué luces debes usar en carretera de noche si no hay tráfico en contra?",
            img: "images/trivia/119.svg",
            options: ["Luces bajas", "Luces plenas (altas)", "Luces de parqueo", "Solo cocuyos"],
            correct: 1,
            feedback: "¡Visión lejana! Usa las altas para ver más, pero bájalas si ves otro carro. 🔦"
        },
        {
            id: 120,
            q: "El extintor del vehículo debe ser...",
            img: "images/trivia/120.svg",
            options: ["Color rojo solamente", "Recargado anualmente y vigente", "De agua", "Opcional"],
            correct: 1,
            feedback: "¡Seguridad! Un extintor vencido no sirve de nada. 🔥"
        }
    ],

    // =========================================================================
    // NIVEL 3: DIFÍCIL (4 Opciones) - Experto Vial
    // =========================================================================
    3: [
        {
            id: 201,
            q: "En un accidente con heridos, el protocolo universal P.A.S. significa:",
            img: "images/trivia/201.svg",
            options: ["Primero Ayudar Siempre", "Proteger, Avisar, Socorrer", "Parar, Analizar, Salir", "Preguntar, Asistir, Sanar"],
            correct: 1,
            feedback: "¡Vital! 1. Protege la zona. 2. AVISA a emergencias. 3. Socorre si sabes cómo. 🚑"
        },
        {
            id: 202,
            q: "Si se rompe la correa de REPARTICIÓN (distribución) con el motor en marcha:",
            img: "images/trivia/202.svg",
            options: ["El motor se apaga suavemente sin daños", "Se genera un daño catastrófico interno (válvulas vs pistones)", "Solo falla el aire acondicionado", "Se descarga la batería"],
            correct: 1,
            feedback: "¡Conocimiento Pro! Es una de las averías más costosas. Cambiala a tiempo. 💸"
        },
        {
            id: 203,
            q: "Frenada de pánico (a fondo) en carro con ABS. El pedal vibra fuerte. ¿Qué haces?",
            img: "images/trivia/203.svg",
            options: ["Soltar el freno inmediatamente", "Mantener pisado a fondo sin miedo", "Bombear el pedal rítmicamente", "Apagar el motor"],
            correct: 1,
            feedback: "¡Sin miedo! La vibración es el sistema trabajando para que no derrapes. 🛑"
        },
        {
            id: 204,
            q: "En Colombia, ¿cuál es el horario exacto obligatorio para encender las luces bajas?",
            img: "images/trivia/204.svg",
            options: ["De 6:30 PM a 6:30 AM", "De 6:00 PM a 6:00 AM", "Cuando el conductor no vea bien", "Solo en carreteras nacionales"],
            correct: 1,
            feedback: "¡Puntualidad legal! A las 6:00 PM, luces prendidas sin excusa. 🕕"
        },
        {
            id: 205,
            q: "Humo AZUL constante por el tubo de escape indica:",
            img: "images/trivia/205.svg",
            options: ["Exceso de gasolina", "Paso de agua a la combustión", "Consumo de aceite (Motor desgastado)", "Motor afinado correctamente"],
            correct: 2,
            feedback: "¡Diagnóstico preciso! El vehículo está quemando aceite. Reparación mayor cerca. 💨"
        },
        {
            id: 206,
            q: "El fenómeno de 'Hidroplaneo' o 'Aquaplaning' ocurre cuando:",
            img: "images/trivia/206.svg",
            options: ["El carro flota en un río", "Las llantas pierden contacto con el asfalto por una capa de agua", "Los frenos se mojan", "El motor aspira agua"],
            correct: 1,
            feedback: "¡Peligro invisible! Si sientes la dirección suave en lluvia, suelta el acelerador. 🌧️"
        },
        {
            id: 207,
            q: "¿Debes quitarle el casco a un motociclista inconsciente tras un accidente?",
            img: "images/trivia/207.svg",
            options: ["Sí, para que respire mejor inmediatamente", "NUNCA (Riesgo de lesión medular irreversible)", "Sí, pero solo si no sangra", "Solo si el casco está roto"],
            correct: 1,
            feedback: "¡Regla de oro! Si mueves el cuello mal, podrías dejarlo tetrapléjico. Espera a los paramédicos. ⛑️"
        },
        {
            id: 208,
            q: "Líquido de frenos: El nivel baja un poco con el tiempo. ¿Causa normal?",
            img: "images/trivia/208.svg",
            options: ["Fuga grave", "Evaporación natural", "Desgaste de las pastillas de freno", "Mala calidad del líquido"],
            correct: 2,
            feedback: "¡Mecánica aplicada! Al gastarse la pastilla, el pistón sale más y el líquido baja. Rellena con cuidado. 🔧"
        },
        {
            id: 209,
            q: "Placa de vehículo con fondo BLANCO. Servicio:",
            img: "images/trivia/209.svg",
            options: ["Particular", "Público", "Diplomático", "Clásico o Antiguo"],
            correct: 1,
            feedback: "¡Correcto! Taxis, buses y transporte especial usan blanca. 🚕"
        },
        {
            id: 210,
            q: "Punto Ciego: Antes de cambiar de carril, además del espejo, debes:",
            img: "images/trivia/210.svg",
            options: ["Acelerar a fondo", "Mirar rápidamente sobre tu hombro (Girar cabeza)", "Pitar tres veces", "Encender los limpiaparabrisas"],
            correct: 1,
            feedback: "¡Visión total! El espejo no lo muestra todo. El giro de cabeza salva vidas. 👀"
        },
        {
            id: 211,
            q: "En una vía rural con berma pavimentada. ¿Puedes circular por la berma?",
            img: "images/trivia/211.svg",
            options: ["Sí, si voy despacio", "Sí, para adelantar", "No, es para peatones y detenciones de emergencia", "Solo las motos"],
            correct: 2,
            feedback: "¡Respeto! La berma no es un carril adicional. 🚶‍♂️"
        },
        {
            id: 212,
            q: "¿Qué efecto produce la velocidad en el campo visual del conductor?",
            img: "images/trivia/212.svg",
            options: ["Mejora la visión periférica", "Produce Efecto Túnel (se reduce la visión lateral)", "No afecta la visión", "Permite ver más detalles lejanos"],
            correct: 1,
            feedback: "¡Ciencia vial! A mayor velocidad, menos ves a los lados. Cuidado en intersecciones. 👁️"
        },
        {
            id: 213,
            q: "Líquido VERDE fosforescente bajo el motor suele ser:",
            img: "images/trivia/213.svg",
            options: ["Aceite de motor", "Líquido refrigerante (Coolant)", "Líquido de frenos", "Agua del limpiabrisas"],
            correct: 1,
            feedback: "¡Alerta térmica! Tienes una fuga en el sistema de refrigeración. Riesgo de recalentamiento. 🌡️"
        },
        {
            id: 214,
            q: "Reincidencia en conducción bajo embriaguez (grado alto) puede causar:",
            img: "images/trivia/214.svg",
            options: ["Multa de dos salarios mínimos", "Suspensión por 1 año", "Cancelación definitiva de la licencia de por vida", "Curso pedagógico solamente"],
            correct: 2,
            feedback: "¡Consecuencia fatal! Jugar con alcohol al volante te puede costar el pase para siempre. 🚫"
        },
        {
            id: 215,
            q: "Carril izquierdo en vía de tres carriles (mismo sentido). Uso exclusivo:",
            img: "images/trivia/215.svg",
            options: ["Para ir observando el paisaje", "Para adelantar o circular a mayor velocidad (hasta el límite)", "Para tráfico pesado", "Para detenerse"],
            correct: 1,
            feedback: "¡Flujo vial! Si no vas a adelantar, conserva tu derecha. No bloquees el izquierdo. 🚀"
        }
    ]
};

// Exportar
if (typeof window !== 'undefined') {
    window.TRIVIA_DATA = TRIVIA_DATA;
}
