/**
 * Academia Élite - Motor Interno
 */

document.addEventListener('DOMContentLoaded', () => {
    initApp();
});

const STATE = {
    currentQuestionIndex: 0,
    score: 0,
    // Aquí guardamos los cursos directamente
    services: [
        { id: 1, name: "Manejo Defensivo Pro", price: 450, level: "Nivel Intermedio", duration: "20 Horas", description: "Técnicas avanzadas para evitar colisiones.", image: "https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=400" },
        { id: 2, name: "Drift & Control Élite", price: 850, level: "Nivel Experto", duration: "15 Horas", description: "Control total sobre superficies deslizantes.", image: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=400" }
    ],
    // Aquí guardamos las preguntas directamente
    questions: [
        {
            question: "¿Cuál es la técnica correcta para frenar en una superficie con hielo?",
            options: [
                {id: "a", text: "Frenar a fondo de golpe", isCorrect: false},
                {id: "b", text: "Frenado intermitente o usar ABS", isCorrect: true},
                {id: "c", text: "Poner el auto en neutro", isCorrect: false}
            ],
            explanation: "El frenado intermitente evita el bloqueo de las ruedas."
        },
        {
            question: "En una curva, ¿cuándo se debe acelerar para mantener la tracción?",
            options: [
                {id: "a", text: "Justo al entrar", isCorrect: false},
                {id: "b", text: "Al pasar el ápice y enderezar", isCorrect: true},
                {id: "c", text: "En el punto más cerrado", isCorrect: false}
            ],
            explanation: "Acelerar después del ápice mejora la salida."
        }
    ]
};

function initApp() {
    console.log('Sistema Élite Conectado');
    initNavbarEffect();
    initMobileMenu();
    initSmoothScroll();
    renderServices();

    const startBtn = document.querySelector('a[href="#trivia"]');
    if (startBtn) {
        startBtn.addEventListener('click', (e) => {
            e.preventDefault();
            document.querySelector('#trivia').scrollIntoView({ behavior: 'smooth' });
            renderStartScreen();
        });
    }
}

function initNavbarEffect() {
    const navbar = document.getElementById('navbar');
    if (!navbar) return;
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) navbar.classList.add('nav-scrolled');
        else navbar.classList.remove('nav-scrolled');
    });
}

function initMobileMenu() {
    const menuBtn = document.getElementById('mobile-menu-btn');
    const navLinks = document.querySelector('.nav-links');
    
    if (menuBtn && navLinks) {
        menuBtn.addEventListener('click', () => {
            menuBtn.classList.toggle('active');
            navLinks.classList.toggle('active');
            
            // Bloquear scroll cuando el menú está abierto
            document.body.style.overflow = navLinks.classList.contains('active') ? 'hidden' : '';
        });

        // Cerrar menú al hacer click en un link
        navLinks.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                menuBtn.classList.remove('active');
                navLinks.classList.remove('active');
                document.body.style.overflow = '';
            });
        });
    }
}

function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) target.scrollIntoView({ behavior: 'smooth' });
        });
    });
}

function renderServices() {
    const grid = document.getElementById('services-grid');
    if (!grid) return;
    grid.innerHTML = STATE.services.map(s => `
        <div class="card fade-in">
            <h3 class="text-gold">${s.name}</h3>
            <p><strong>$${s.price}</strong> | ${s.duration}</p>
            <p style="font-size: 0.9rem; color: #ccc;">${s.description}</p>
            <button class="btn btn-secondary btn-sm" style="margin-top:10px">RESERVAR</button>
        </div>
    `).join('');
}

function renderStartScreen() {
    const container = document.querySelector('#trivia .container');
    container.innerHTML = `
        <div class="trivia-container fade-in">
            <h2 class="text-gold">Test de Aptitud</h2>
            <p>Responda para validar su nivel Élite.</p>
            <button id="btn-start-quiz" class="btn btn-primary" style="margin-top:20px">Arrancar Motores</button>
        </div>
    `;
    document.getElementById('btn-start-quiz').addEventListener('click', () => {
        STATE.currentQuestionIndex = 0;
        STATE.score = 0;
        renderQuestion();
    });
}

function renderQuestion() {
    const container = document.querySelector('#trivia .container');
    const q = STATE.questions[STATE.currentQuestionIndex];
    if (!q) { renderResults(); return; }

    container.innerHTML = `
        <div class="trivia-container fade-in">
            <h3>${q.question}</h3>
            <div class="options-grid" style="margin-top:20px">
                ${q.options.map(o => `<div class="option-card" onclick="checkAnswer('${o.id}')">${o.text}</div>`).join('')}
            </div>
            <div id="feedback"></div>
        </div>
    `;
}

window.checkAnswer = (id) => {
    const q = STATE.questions[STATE.currentQuestionIndex];
    const isCorrect = id === q.options.find(o => o.isCorrect).id;
    if (isCorrect) STATE.score++;
    
    document.getElementById('feedback').innerHTML = `
        <p style="margin-top:20px; color: ${isCorrect ? '#10b981' : '#ef4444'}">
            ${isCorrect ? '¡Correcto!' : 'Incorrecto.'} ${q.explanation}
        </p>
        <button class="btn btn-secondary btn-sm" onclick="nextQ()" style="margin-top:10px">Siguiente</button>
    `;
};

window.nextQ = () => {
    STATE.currentQuestionIndex++;
    renderQuestion();
};

function renderResults() {
    const container = document.querySelector('#trivia .container');
    const pct = Math.round((STATE.score / STATE.questions.length) * 100);
    container.innerHTML = `
        <div class="trivia-container fade-in">
            <h2>Resultado: ${pct}%</h2>
            <p>${pct >= 80 ? '¡Nivel Piloto Élite!' : 'Sigue practicando.'}</p>
            <button onclick="location.reload()" class="btn btn-primary" style="margin-top:20px">Reiniciar</button>
        </div>
    `;
}