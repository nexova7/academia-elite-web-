/**
 * 🛡️ SISTEMA DE ACCESO V2.1 - ACADEMIA ÉLITE
 * Lógica robusta para validación de formularios y conexión Supabase.
 */

// --- VARIABLES GLOBALES ---
const ACADEMIA_WA = "573133482932";
const VALID_PINS = ["A123", "B123", "C123"];
let _supabase = null;

// --- INICIALIZACIÓN ---
document.addEventListener('DOMContentLoaded', () => {
    console.log("🚀 Sistema de Acceso V2.0 Iniciado");

    // 1. Cargar Supabase
    initSupabase();

    // 2. Eventos de Tabs
    setupTabs();

    // 3. Eventos de Ojo (Contraseña)
    setupEyeIcons();

    // 4. Validaciones en tiempo real (Password Strength)
    setupPasswordValidation();

    // 5. Botones Principales
    document.getElementById('btnLogin').addEventListener('click', handleLogin);
    document.getElementById('btnRegisterFinish').addEventListener('click', handleRegister);
    document.getElementById('btnRequestPin').addEventListener('click', handleWhatsAppRequest);
    document.getElementById('btnRecover').addEventListener('click', handleRecovery);
});

// --- FUNCIONES CORE ---

function initSupabase() {
    try {
        if (window.supabaseInstance) {
            _supabase = window.supabaseInstance;
        } else if (typeof supabase !== 'undefined') {
            const SUPABASE_PROJECT_URL = 'https://aldwcqpgsjfjcttxfecp.supabase.co';
            const SUPABASE_ANON_KEY = 'sb_publishable_OvQYw50Cs8sM21AJGg21zg_v3LunT3J';
            _supabase = supabase.createClient(SUPABASE_PROJECT_URL, SUPABASE_ANON_KEY);
        }

        if (_supabase) console.log("✅ Conexión DB establecida.");
        else console.error("❌ Fallo al cargar librería Supabase.");

    } catch (e) {
        console.error("Critical Error:", e);
    }
}

function setupTabs() {
    document.getElementById('tab-login').addEventListener('click', () => toggleSection('login'));
    document.getElementById('tab-register').addEventListener('click', () => toggleSection('register'));
}

function toggleSection(section) {
    // Hide all
    document.querySelectorAll('.form-section').forEach(el => el.classList.remove('active'));
    document.querySelectorAll('.tab').forEach(el => el.classList.remove('active'));

    // Show active
    document.getElementById(`tab-${section}`).classList.add('active');
    document.getElementById(`${section}-form`).classList.add('active');
}

function setupEyeIcons() {
    document.querySelectorAll('.eye-icon').forEach(icon => {
        icon.addEventListener('click', (e) => {
            const input = icon.previousElementSibling;
            if (input && input.tagName === 'INPUT') {
                const isPass = input.type === 'password';
                input.type = isPass ? 'text' : 'password';
                icon.style.opacity = isPass ? '1' : '0.6';
            }
        });
    });
}

function setupPasswordValidation() {
    const input = document.getElementById('regPass');
    const box = document.getElementById('passRequirements');

    // UI Elements
    const reqLen = document.getElementById('req-length');
    const reqUpper = document.getElementById('req-upper');
    const reqNum = document.getElementById('req-number');
    const reqSpec = document.getElementById('req-special');

    input.addEventListener('focus', () => box.classList.add('visible'));

    input.addEventListener('input', () => {
        const val = input.value;

        // 1. Length
        updateReq(reqLen, val.length >= 8);
        // 2. Uppercase
        updateReq(reqUpper, /[A-Z]/.test(val));
        // 3. Number
        updateReq(reqNum, /[0-9]/.test(val));
        // 4. Special Char
        updateReq(reqSpec, /[!@#$%^&*(),.?":{}|<>]/.test(val));
    });
}

function updateReq(el, isValid) {
    el.className = 'req-item ' + (isValid ? 'valid' : 'invalid');
    el.innerHTML = (isValid ? '✅ ' : '⚪ ') + el.innerText.substring(2);
}

// --- HANDLERS ---

async function handleLogin() {
    if (!_supabase) return alert("⚠️ Error de conexión. Refresca la página.");

    const email = document.getElementById('logEmail').value.trim();
    const pass = document.getElementById('logPass').value;

    if (!email || !pass) return alert("⚠️ Ingresa correo y contraseña.");

    // Loading State
    const btn = document.getElementById('btnLogin');
    const originalText = btn.innerText;
    btn.innerText = "Verificando...";
    btn.disabled = true;

    try {
        const { data, error } = await _supabase.auth.signInWithPassword({
            email: email,
            password: pass
        });

        if (error) throw error;

        // Auto-fix profile check
        if (data.user) {
            await ensureProfile(data.user, email); // Ensure DB record exists
            window.location.href = "dashboard-alumno.html";
        }

    } catch (err) {
        console.error("Login fail:", err);
        alert("❌ Credenciales incorrectas.");
        btn.innerText = originalText;
        btn.disabled = false;
    }
}

async function handleRegister() {
    if (!_supabase) return alert("⚠️ Error de conexión.");

    const name = document.getElementById('regName').value.trim();
    const email = document.getElementById('regEmail').value.trim();
    const category = document.getElementById('regCategory').value;
    const pass = document.getElementById('regPass').value;
    const passConfirm = document.getElementById('regPassConfirm').value;
    const pin = document.getElementById('regPin').value.trim().toUpperCase();

    // 1. Validaciones Básicas
    if (!name || !email || !category || !pass || !pin) {
        return alert("⚠️ Por favor completa todos los campos.");
    }

    // 2. Validaciones de Texto (User rules)
    if (name.length > 100) return alert("❌ El nombre no puede exceder 100 caracteres.");
    if (email.length > 80) return alert("❌ El correo no puede exceder 80 caracteres.");
    if (pass.length > 80) return alert("❌ La contraseña es demasiado larga.");

    // 3. Validación Password Regex
    const secureRegex = /^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$/;
    if (!secureRegex.test(pass)) {
        return alert("⚠️ La contraseña no cumple los requisitos de seguridad.");
    }

    if (pass !== passConfirm) return alert("❌ Las contraseñas no coinciden.");

    // 4. Validación PIN
    if (!VALID_PINS.includes(pin)) {
        return alert("❌ PIN DE ACTIVACIÓN INVÁLIDO.\nSi no tienes uno, solicítalo por WhatsApp.");
    }

    // --- PROCESO DE REGISTRO ---
    const btn = document.getElementById('btnRegisterFinish');
    btn.innerText = "Creando Cuenta...";
    btn.disabled = true;

    try {
        // A. Auth Supabase
        const { data: authData, error: authError } = await _supabase.auth.signUp({
            email: email,
            password: pass,
            options: { data: { full_name: name, category: category } }
        });

        if (authError) throw authError;

        if (authData.user) {
            // B. Crear Registro DB
            const { error: dbError } = await _supabase.from('alumnos').insert([{
                id: authData.user.id,
                email: email,
                nombre: name,
                categoria: category,
                activo: true
            }]);

            if (dbError && dbError.code !== '23505') throw dbError; // Ignorar duplicado si ya existía el ID

            alert(`✅ ¡BIENVENIDO ${name.toUpperCase()}!\nTu matrícula para categoría ${category} ha sido registrada.`);
            window.location.reload(); // Reload to show login or auto-login
        }

    } catch (err) {
        console.error("Reg Error:", err);
        alert("❌ Error en el registro: " + err.message);
        btn.innerText = "INTENTAR DE NUEVO";
        btn.disabled = false;
    }
}

function handleWhatsAppRequest() {
    const name = document.getElementById('regName').value.trim() || "[MI NOMBRE]";
    const cat = document.getElementById('regCategory').value || "[CATEGORÍA]";

    let msg = `Hola 👋, soy ${name}. Estoy matriculado para la licencia ${cat}. `;
    msg += `Necesito acceso a la plataforma para agendar mis clases prácticas 🚗. Solicitud de PIN.`;

    const url = `https://wa.me/${ACADEMIA_WA}?text=${encodeURIComponent(msg)}`;
    window.open(url, '_blank');
}

function handleRecovery() {
    window.open(`https://wa.me/${ACADEMIA_WA}?text=Hola, olvidé mi contraseña. Ayuda soporte técnico.`, '_blank');
}

// --- UTILS ---
async function ensureProfile(user, email) {
    // Si el usuario entra pero no está en la tabla 'alumnos', lo creamos.
    const { data } = await _supabase.from('alumnos').select('id').eq('id', user.id).single();
    if (!data) {
        await _supabase.from('alumnos').insert([{
            id: user.id,
            email: email,
            nombre: user.user_metadata.full_name || "Alumno Nuevo",
            categoria: user.user_metadata.category || 'B1',
            activo: true
        }]);
    }
}
