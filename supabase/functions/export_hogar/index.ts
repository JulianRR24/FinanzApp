/**
 * Supabase Edge Function - Export Home Finance Movements
 * 
 * Esta función recibe los movimientos del hogar de FinanzApp
 * y genera un archivo JSON descargable compatible con iOS Safari.
 * 
 * Es específica para la exportación mensual de movimientos del hogar
 * que se realiza desde la pantalla "Finanzas del Hogar".
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

    let datosRequest: { movimientos: unknown[]; mes: string }
    try {
      datosRequest = JSON.parse(body)
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

    // Validar estructura esperada
    if (!datosRequest || typeof datosRequest !== 'object') {
      return new Response(
        JSON.stringify({ error: 'Invalid request format' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    const { movimientos, mes } = datosRequest

    // Validar que movimientos sea un array
    if (!Array.isArray(movimientos)) {
      return new Response(
        JSON.stringify({ error: 'movimientos must be an array' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Validar que mes sea un string
    if (typeof mes !== 'string' || !mes.trim()) {
      return new Response(
        JSON.stringify({ error: 'mes must be a non-empty string' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Validar estructura de cada movimiento (opcional, pero recomendado)
    for (let i = 0; i < movimientos.length; i++) {
      const movimiento = movimientos[i]
      if (!movimiento || typeof movimiento !== 'object') {
        return new Response(
          JSON.stringify({ 
            error: `Invalid movement at index ${i}: must be an object` 
          }),
          { 
            status: 400, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      // Validar campos requeridos del movimiento
      const camposRequeridos = ['date', 'amount', 'type', 'description']
      for (const campo of camposRequeridos) {
        if (!(campo in movimiento)) {
          return new Response(
            JSON.stringify({ 
              error: `Missing required field '${campo}' in movement at index ${i}` 
            }),
            { 
              status: 400, 
              headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
            }
          )
        }
      }
    }

    // Generar nombre del archivo usando el mes proporcionado
    // Formato esperado: "movimientos_hogar_MMMMM_yyyy.json"
    const nombreArchivo = `movimientos_hogar_${mes}.json`

    // Convertir JSON a string con formato legible (indentación de 2 espacios)
    const jsonString = JSON.stringify(movimientos, null, 2)
    
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
    console.error('Error en export_hogar:', error)
    
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
