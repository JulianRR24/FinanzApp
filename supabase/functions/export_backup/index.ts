/**
 * Supabase Edge Function - Export Backup Complete
 * 
 * Esta función recibe todos los datos de la aplicación FinanzApp
 * y genera un archivo JSON descargable compatible con iOS Safari.
 * 
 * Resuelve el problema de descarga en iOS donde WebKit sandbox
 * bloquea las descargas directas desde el DOM.
 */

import { serve } from "jsr:@supabase/functions"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Max-Age': '86400',
}

serve(async (req) => {
  // Manejar solicitudes CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Validar método HTTP
    if (req.method !== 'POST') {
      return new Response(
        JSON.stringify({ error: 'Method not allowed' }),
        { 
          status: 405, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Validar Content-Type
    const contentType = req.headers.get('content-type')
    if (!contentType || !contentType.includes('application/json')) {
      return new Response(
        JSON.stringify({ error: 'Content-Type must be application/json' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Leer y validar el body del request
    const body = await req.text()
    if (!body.trim()) {
      return new Response(
        JSON.stringify({ error: 'Request body cannot be empty' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    let datosExportacion: Record<string, unknown>
    try {
      datosExportacion = JSON.parse(body)
    } catch (error) {
      return new Response(
        JSON.stringify({ 
          error: 'Invalid JSON format',
          details: error instanceof Error ? error.message : 'Unknown parsing error'
        }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Validar estructura esperada de datos
    const cajasEsperadas = [
      'debitos', 'bancos', 'movimientos', 'notas', 'ajustes', 'metas',
      'metasHogar', 'cuentasUVT', 'uvtValoresIniciales', 'bienesUVT', 
      'fechaDeclaracionUVT', 'categorias', 'uvt', 'recordatorios',
      'finanzasHogar', 'historialHogarEditable'
    ]

    // Validar que sea un objeto
    if (typeof datosExportacion !== 'object' || datosExportacion === null) {
      return new Response(
        JSON.stringify({ error: 'Invalid data format: expected object' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Generar timestamp para el nombre del archivo
    const ahora = new Date()
    const timestamp = ahora.toISOString().replace(/[:.]/g, '-').slice(0, 19)
    const nombreArchivo = `finanzas_respaldo_${timestamp}.json`

    // Convertir JSON a string con formato legible
    const jsonString = JSON.stringify(datosExportacion, null, 2)
    
    // Convertir a Uint8Array (bytes)
    const encoder = new TextEncoder()
    const jsonBytes = encoder.encode(jsonString)

    // Configurar headers para descarga compatible con iOS Safari
    const headers = new Headers({
      ...corsHeaders,
      'Content-Type': 'application/json',
      'Content-Disposition': `attachment; filename="${nombreArchivo}"`,
      'Content-Length': jsonBytes.length.toString(),
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Pragma': 'no-cache',
      'Expires': '0',
      // Headers adicionales para compatibilidad iOS
      'X-Content-Type-Options': 'nosniff',
      'X-Download-Options': 'noopen',
      'X-Permitted-Cross-Domain-Policies': 'none',
    })

    // Crear respuesta con streaming para mejor compatibilidad
    return new Response(jsonBytes, {
      status: 200,
      headers,
    })

  } catch (error) {
    console.error('Error en export_backup:', error)
    
    return new Response(
      JSON.stringify({ 
        error: 'Internal server error',
        details: error instanceof Error ? error.message : 'Unknown error'
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
})
