/*
    M?dulo de Administraci?n para Open.mp
    Autor: Tyr
    Versi?n: 1.0
    Descripci?n: Sistema de comandos administrativos y moderaci?n.
    Dependencias: data.pwn (SQLite), auth.pwn (PlayerInfo)
*/

// Includes necesarios
// Funciones b?sicas de Open.mp
#include <open.mp>          
// SQLite integrado
#include <sqlitei>          
// Hashing de contrase?as (si es necesario)
#include <bcrypt>           

// Configuraci?n
#define COLOR_RED           0xFF0000AA
#define COLOR_GREEN         0x00FF00AA
#define COLOR_WHITE         0xFFFFFFFF
#define COLOR_YELLOW        0xFFFF00AA

// Variables globales
new bool:PlayerFrozen[MAX_PLAYERS];  // Para el comando /freeze

// Forward declarations
forward LogAdminAction(adminid, const action[], targetid = INVALID_PLAYER_ID);
forward bool:IsPlayerAdmin(playerid);
forward SendAdminMessage(color, const message[], va_args<>);
forward SendErrorMessage(playerid, const message[]);
forward SendUsage(playerid, const usage[]);

/* -----------------------------------------------------------------------------
    Funciones Esenciales
----------------------------------------------------------------------------- */

/**
 * Verifica si un jugador es administrador.
 * @param playerid ID del jugador.
 * @return true si es admin, false en caso contrario.
 */
stock bool:IsPlayerAdmin(playerid) {
    return PlayerInfo[playerid][pAdmin] >= 1; // Nivel 1 o superior
}

/**
 * Loggea una acci?n administrativa en la base de datos.
 * @param adminid ID del administrador.
 * @param action Acci?n realizada (ej: "Ban", "Kick").
 * @param targetid ID del objetivo (opcional).
 */
stock LogAdminAction(adminid, const action[], targetid = INVALID_PLAYER_ID) {
    new admin_name[MAX_PLAYER_NAME], target_name[MAX_PLAYER_NAME], query[256];
    GetPlayerName(adminid, admin_name, sizeof(admin_name));
    
    if(targetid != INVALID_PLAYER_ID) {
        GetPlayerName(targetid, target_name, sizeof(target_name));
    } else {
        target_name = "N/A";
    }
    
    format(query, sizeof(query), 
        "INSERT INTO admin_logs (admin, action, target, timestamp) VALUES ('%q', '%q', '%q', %d)",
        admin_name, action, target_name, gettime()
    );
    db_query(GetDatabaseHandle(), query);
}

/**  Sistema de mensajes administrativos
 * Env?a un mensaje a todos los administradores en l?nea.
 * @param color Color del mensaje.
 * @param message Mensaje con formato.
 */
stock SendAdminMessage(color, const message[], va_args<>) {
    new str[144];
    va_format(str, sizeof(str), message, va_start<2>);
    
    foreach(new i : Player) {
        if(PlayerInfo[i][pAdmin] >= 1) {
            SendClientMessage(i, color, str);
        }
    }
}

/* -----------------------------------------------------------------------------
    Comandos de Administraci?n
----------------------------------------------------------------------------- */
// Banear IP y Nombre
CMD:ban(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos de administrador.");
    
    new targetid, reason[128], hours;
    if(sscanf(params, "uiS()[128]", targetid, hours, reason))
        return SendUsage(playerid, "/ban [ID] [Horas] [Raz?n]");
    
    new ip[16], name[MAX_PLAYER_NAME], admin_name[MAX_PLAYER_NAME], query[512];
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerIp(targetid, ip, sizeof(ip));
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    
    // Insertar en la tabla de bans
    format(query, sizeof(query), 
        "INSERT INTO bans (name, ip, reason, admin, timestamp, unban_time) \
        VALUES ('%q', '%q', '%q', '%q', %d, %d)",
        name, ip, reason, admin_name, gettime(), gettime() + (hours * 3600)
    );
    db_query(GetDatabaseHandle(), query);
    
    // Bloquear IP y echar al jugador
    BlockIpAddress(ip, hours * 3600);
    KickPlayer(targetid, "Has sido baneado.");
    
    // Loggear acci?n
    LogAdminAction(playerid, "Ban", targetid);
    SendAdminMessage(COLOR_RED, "[ADMIN] %s bane? a %s. Raz?n: %s", admin_name, name, reason);
    return 1;
}

// expulsar jugador
CMD:kick(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid, reason[128];
    if(sscanf(params, "uS()[128]", targetid, reason))
        return SendUsage(playerid, "/kick [ID] [Raz?n]");
    
    new name[MAX_PLAYER_NAME], admin_name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    
	// Guardar en logs y expulsar
    LogAdminAction(playerid, "Kick", targetid);
    KickPlayer(targetid, "Has sido expulsado.");
    SendAdminMessage(COLOR_RED, "[ADMIN] %s expuls? a %s. Raz?n: %s", admin_name, name, reason);
    return 1;
}

// congelar jugador
CMD:freeze(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendUsage(playerid, "/freeze [ID]");
    
    TogglePlayerControllable(targetid, 0);
    PlayerFrozen[targetid] = true;
    
    LogAdminAction(playerid, "Freeze", targetid);
    SendAdminMessage(COLOR_RED, "[ADMIN] %s congel? a %s.", GetPlayerName(playerid), GetPlayerName(targetid));
    return 1;
}

// Advertir a un jugador
CMD:warn(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid, reason[128];
    if(sscanf(params, "uS()[128]", targetid, reason))
        return SendUsage(playerid, "/warn [ID] [Raz?n]");
    
    new name[MAX_PLAYER_NAME], admin_name[MAX_PLAYER_NAME], query[256];
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    
    format(query, sizeof(query), 
        "INSERT INTO warnings (name, admin, reason, timestamp) \
        VALUES ('%q', '%q', '%q', %d)",
        name, admin_name, reason, gettime()
    );
    db_query(database, query);
    
    // Notificar al jugador
    SendClientMessage(targetid, COLOR_YELLOW, "[ADVERTENCIA] Raz?n: %s", reason);
    LogAdminAction(playerid, "Warn", targetid);
    return 1;
}

// Ver advertencias
CMD:checkwarns(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendUsage(playerid, "/checkwarns [ID]");
    
    new name[MAX_PLAYER_NAME], query[256];
    GetPlayerName(targetid, name, sizeof(name));
    
    format(query, sizeof(query), "SELECT * FROM warnings WHERE name = '%q'", name);
    new DBResult:result = db_query(database, query);
    
    if(db_num_rows(result) > 0) {
        SendClientMessage(playerid, COLOR_WHITE, "=== Advertencias de %s ===", name);
        for(new i = 0; i < db_num_rows(result); i++) {
            new reason[128], admin[24], timestamp;
            db_get_field_assoc(result, "reason", reason, sizeof(reason));
            db_get_field_assoc(result, "admin", admin, sizeof(admin));
            timestamp = db_get_field_int(result, "timestamp");
            
            SendClientMessage(playerid, COLOR_WHITE, "%s - Por: %s (%s)", reason, admin, TimestampToDate(timestamp));
            db_next_row(result);
        }
    } else {
        SendClientMessage(playerid, COLOR_WHITE, "Este jugador no tiene advertencias.");
    }
    db_free_result(result);
    return 1;
}

// golpear jugador
CMD:slap(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid, Float:health;
    if(sscanf(params, "u", targetid))
        return SendUsage(playerid, "/slap [ID]");
    
    GetPlayerHealth(targetid, health);
    SetPlayerHealth(targetid, health - 10.0);
    
    LogAdminAction(playerid, "Slap", targetid);
    SendAdminMessage(COLOR_RED, "[ADMIN] %s golpe? a %s.", GetPlayerName(playerid), GetPlayerName(targetid));
    return 1;
}

// mutear jugador
CMD:mute(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid, reason[128], minutes;
    if(sscanf(params, "uiS()[128]", targetid, minutes, reason))
        return SendUsage(playerid, "/mute [ID] [Minutos] [Raz?n]");
    
    new name[MAX_PLAYER_NAME], admin_name[MAX_PLAYER_NAME], query[256];
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    
    // Insertar en la tabla "mutes"
    format(query, sizeof(query), 
        "INSERT INTO mutes (name, admin, reason, timestamp, unmute_time) \
        VALUES ('%q', '%q', '%q', %d, %d)",
        name, admin_name, reason, gettime(), gettime() + (minutes * 60)
    );
    db_query(database, query);
    
    // Aplicar muteo en tiempo real
    PlayerInfo[targetid][pMuted] = 1;
    SendClientMessage(targetid, COLOR_RED, "[MUTEO] Raz?n: %s | Duraci?n: %d minutos", reason, minutes);
    LogAdminAction(playerid, "Mute", targetid);
    return 1;
}

// desmutear jugador
CMD:unmute(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid, query[128], name[MAX_PLAYER_NAME];
    if(sscanf(params, "u", targetid))
        return SendUsage(playerid, "/unmute [ID]");
    
    GetPlayerName(targetid, name, sizeof(name));
    format(query, sizeof(query), "DELETE FROM mutes WHERE name = '%q'", name);
    db_query(database, query);
    
    PlayerInfo[targetid][pMuted] = 0;
    SendClientMessage(targetid, COLOR_GREEN, "[ADMIN] ?Has sido desmuteado!");
    LogAdminAction(playerid, "Unmute", targetid);
    return 1;
}

// congelar jugador
CMD:freeze(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendUsage(playerid, "/freeze [ID]");
    
    TogglePlayerControllable(targetid, 0); // 0 = congelado
    PlayerFrozen[targetid] = true;
    
    LogAdminAction(playerid, "Freeze", targetid);
    SendAdminMessage(COLOR_RED, "[ADMIN] %s congel? a %s.", GetPlayerName(playerid), GetPlayerName(targetid));
    return 1;
}

// descongelar jugador
CMD:unfreeze(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendUsage(playerid, "/unfreeze [ID]");
    
    TogglePlayerControllable(targetid, 1); // 1 = descongelado
    PlayerFrozen[targetid] = false;
    
    LogAdminAction(playerid, "Unfreeze", targetid);
    SendAdminMessage(COLOR_RED, "[ADMIN] %s descongel? a %s.", GetPlayerName(playerid), GetPlayerName(targetid));
    return 1;
}

// Ir a un jugador
CMD:goto(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendUsage(playerid, "/goto [ID]");
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(playerid, x + 1.0, y, z);
    
    LogAdminAction(playerid, "Goto", targetid);
    return 1;
}

// Traer a un jugador
CMD:gethere(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    new targetid, Float:x, Float:y, Float:z;
    if(sscanf(params, "u", targetid))
        return SendUsage(playerid, "/gethere [ID]");
    
    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(targetid, x + 1.0, y, z);
    
    LogAdminAction(playerid, "Gethere", targetid);
    return 1;
}

// comando de alto impacto (Explosion masiva)
CMD:nuke(playerid, params[]) {
    if(!IsPlayerAdmin(playerid)) 
        return SendErrorMessage(playerid, "No tienes permisos.");
    
    foreach(new i : Player) {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(i, x, y, z);
        CreateExplosion(x, y, z, 7, 10.0);
        SetPlayerHealth(i, 0.0);
    }
    
    LogAdminAction(playerid, "Nuke");
    SendAdminMessage(COLOR_RED, "[ADMIN] %s lanz? una explosi?n masiva.", GetPlayerName(playerid));
    return 1;
}
// ... (Agrega aqu? otros comandos como /unfreeze, /slap, etc.)

/* -----------------------------------------------------------------------------
    Callbacks y Sincronizaci?n
----------------------------------------------------------------------------- */

public OnPlayerConnect(playerid) {
    // Verificar muteos pendientes al conectar
    new query[128], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    
    format(query, sizeof(query), "SELECT * FROM mutes WHERE name = '%q'", name);
    new DBResult:result = db_query(GetDatabaseHandle(), query);
    
    if(db_num_rows(result) > 0) {
        new unmute_time = db_get_field_int(result, "unmute_time");
        if(gettime() < unmute_time) {
            PlayerInfo[playerid][pMuted] = 1;
            SendClientMessage(playerid, COLOR_RED, "[AVISO] Sigues muteado. Tiempo restante: %d minutos", (unmute_time - gettime()) / 60);
        } else {
            format(query, sizeof(query), "DELETE FROM mutes WHERE name = '%q'", name);
            db_query(GetDatabaseHandle(), query);
        }
    }
    db_free_result(result);
    return 1;
}

public OnPlayerText(playerid, text[]) {
    if(PlayerInfo[playerid][pMuted]) {
        SendClientMessage(playerid, COLOR_RED, "[ERROR] Est?s muteado.");
        return 0;
    }
    return 1;
}

/* -----------------------------------------------------------------------------
    Notas Finales
----------------------------------------------------------------------------- */
/**
 * Dependencias:
 * - data.pwn: Proporciona GetDatabaseHandle() y las tablas SQL.
 * - auth.pwn: Proporciona PlayerInfo[pAdmin] y PlayerInfo[pMuted].
 * 
 * Funciones no incluidas aqu? (deben estar en otros m?dulos):
 * - SendErrorMessage, SendUsage: Manejo de mensajes de error (core.pwn).
 * - KickPlayer: Funci?n para expulsar jugadores (utils.pwn).
 */
