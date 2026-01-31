/**
 * 🔒 CONFIGURACIÓN DE SEGURIDAD SUPABASE
 * --------------------------------------
 * Esta configuración centraliza la conexión para asegurar consistencia.
 * 
 * NOTA DE SEGURIDAD:
 * La 'anon key' es pública por diseño y segura de exponer en el navegador
 * SI Y SOLO SI las políticas RLS (Row Level Security) en la base de datos
 * están correctamente configuradas.
 */

// 1. CONSTANTES DE CONEXIÓN
const SUPABASE_PROJECT_URL = 'https://aldwcqpgsjfjcttxfecp.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_OvQYw50Cs8sM21AJGg21zg_v3LunT3J'; // Reemplazar si cambia

// 2. INICIALIZACIÓN SEGURA
let _supabase = null;

if (typeof supabase !== 'undefined') {
    _supabase = supabase.createClient(SUPABASE_PROJECT_URL, SUPABASE_ANON_KEY);
    console.log("✅ Supabase Security Client Initialized");
} else {
    console.error("❌ Error Crítico: Librería Supabase no cargada antes de la configuración.");
}

// 3. EXPORTAR PARA USO GLOBAL (Compatible con scripts no-módulo)
window.supabaseInstance = _supabase;
