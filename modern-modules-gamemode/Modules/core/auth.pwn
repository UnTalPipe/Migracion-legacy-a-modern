#include <openmp>
#include <YSI_Storage\y_ini>
#include <YSI_Data\y_iterate>
#include <YSI_Extra\y_inline_mysql>
#include <sqlitei>
#include <bcrypt>

// Configuraci?n
#define MAX_LOGIN_ATTEMPTS 3
#define MAX_BAN_ATTEMPTS 5
#define DIALOG_LOGIN 1000
#define DIALOG_REGISTER 1001
#define COLOR_ADMIN 0xFF00FFFF

enum E_PLAYER_DATA {
	pID,
    pName[MAX_PLAYER_NAME],
    pPassword[65],      // Hash bcrypt
    pSalt[11],          // Salt para bcrypt
    pAdmin,             // Nivel de admin (0 = usuario, 1 = admin b?sico, 2 = superadmin)
    pMuted,             // 0 = no muteado, 1 = muteado
    pKills,
    pDeaths,
    pScore,
	// ... (otros campos del legacy)
};
new PlayerInfo[MAX_PLAYERS][E_PLAYER_DATA];	

// Enumeraci?n mejorada con todos los campos necesarios
enum E_PLAYER_AUTH {
    bool:p_LoggedIn,
    p_LoginAttempts,
    p_BanAttempts,
    p_PasswordHash[BCRYPT_HASH_LENGTH],
    p_AdminLevel,
    p_SessionID,
    p_IP[16],
    p_RegistroTimestamp
};
static PlayerAuthInfo[MAX_PLAYERS][E_PLAYER_AUTH];

forward OnPasswordHashed(playerid);
forward OnPasswordVerified(playerid, bool:success);
forward OnPlayerDataLoaded(playerid);

public OnPlayerConnect(playerid) {
    // Resetear variables
    PlayerAuthInfo[playerid][p_LoggedIn] = false;
    PlayerAuthInfo[playerid][p_LoginAttempts] = 0;
    PlayerAuthInfo[playerid][p_BanAttempts] = 0;
    PlayerAuthInfo[playerid][p_SessionID] = random(999999) + 100000;
    GetPlayerIp(playerid, PlayerAuthInfo[playerid][p_IP], 16);

    // Congelar jugador (OpenMP)
    FreezePlayer(playerid, true);
    SetPlayerVirtualWorld(playerid, 0);

    // Verificar IP baneada
    new query[256];
    mysql_format(g_SQL, query, sizeof(query),
        "SELECT motivo FROM banned_ips WHERE ip = '%e'",
        PlayerAuthInfo[playerid][p_IP]
    );
    mysql_async_query(g_SQL, query, "OnIPChecked", "d", playerid);

    return 1;
}

public OnIPChecked(playerid) {
    if(cache_num_rows() > 0) {
        new motivo[128];
        cache_get_field_content(0, "motivo", motivo);
        KickPlayer(playerid, "Tu IP est? baneada: %s", motivo);
        return;
    }

    // Cargar datos del jugador desde DB (c?digo original adaptado)
    new nombre[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nombre, MAX_PLAYER_NAME);

    new query[512];
    mysql_format(g_SQL, query, sizeof(query),
        "SELECT password, admin_level, registro FROM cuentas WHERE nombre = '%e'",
        nombre
    );
    mysql_async_query(g_SQL, query, "OnPlayerDataLoaded", "d", playerid);

    ShowAuthDialog(playerid);
}

ShowAuthDialog(playerid) {
    if(!PlayerAuthInfo[playerid][p_LoggedIn]) {
        new titulo[64], mensaje[256];
        
        // Mantener estilo visual original
        format(titulo, sizeof(titulo), "Bienvenido a %s", GetServerName());
        
        if(PlayerAuthInfo[playerid][p_LoginAttempts] > 0) {
            format(mensaje, sizeof(mensaje),
                "{FFFFFF}Intento: %d/%d\nIngrese su contrase?a:",
                PlayerAuthInfo[playerid][p_LoginAttempts],
                MAX_LOGIN_ATTEMPTS
            );
            Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, titulo, mensaje, "Ingresar", "Salir");
        } else {
            Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, titulo,
                "{FFFFFF}Registro de nueva cuenta\nIngrese una contrase?a segura (min. 6 caracteres):",
                "Registrar", "Cancelar"
            );
        }
    }
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case DIALOG_LOGIN, DIALOG_REGISTER: {
            if(!response) {
                KickPlayer(playerid, "Saliste del servidor");
                return 1;
            }

            // Mantener validaci?n de contrase?a original
            if(strlen(inputtext) < 6) {
                SendClientMessage(playerid, 0xFF0000FF, "?Contrase?a muy corta! (M?nimo 6 caracteres)");
                ShowAuthDialog(playerid);
                return 1;
            }

            if(dialogid == DIALOG_REGISTER) {
                // Registro con BCrypt (mejorado)
                bcrypt_hash(inputtext, BCRYPT_COST, "OnPasswordHashed", "d", playerid);
            } else {
                // Login con verificaci?n BCrypt
                bcrypt_verify(playerid, "OnPasswordVerified", inputtext, PlayerAuthInfo[playerid][p_PasswordHash]);
            }
        }
    }
    return 1;
}

public OnPasswordHashed(playerid) {
    new hash[BCRYPT_HASH_LENGTH], nombre[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nombre, MAX_PLAYER_NAME);
    bcrypt_get_hash(hash);
	GenerateSalt(salt, sizeof(salt)); // Funcion para generar salt aleatorio

	// Insertar nuevo usuario en la base de datos
    format(query, sizeof(query), 
        "INSERT INTO players (name, password, salt, admin, muted, kills, deaths, score) \
        VALUES ('%q', '%q', '%q', 0, 0, 0, 0, 0)",
        name, hash, salt
    );
    db_query(database, query);

    PlayerInfo[playerid][pAdmin] = 0; // Por defecto no es admin
    PlayerInfo[playerid][pMuted] = 0;
    SendClientMessage(playerid, COLOR_GREEN, "?Registro exitoso!");

    // Mantener estructura original de la query con mejoras
    new query[512], fecha_registro[24];
    format(fecha_registro, sizeof(fecha_registro), "%d-%02d-%02d", 
        getdate_year(), getdate_month(), getdate_day());

    mysql_format(g_SQL, query, sizeof(query),
        "INSERT INTO cuentas (nombre, password, ip, registro, session_id) \
        VALUES ('%e', '%e', '%e', '%e', %d)",
        nombre, hash, PlayerAuthInfo[playerid][p_IP], fecha_registro, 
        PlayerAuthInfo[playerid][p_SessionID]
    );
    mysql_async_query(g_SQL, query, "OnPlayerRegistered", "d", playerid);
}

public OnPlayerRegistered(playerid) {
    // Mensaje original de bienvenida
    SendClientMessage(playerid, 0x00FF00FF, "?Registro exitoso! Bienvenido.");

    // Actualizar sistema de logs heredado
    new log[128];
    format(log, sizeof(log), "[REGISTRO] %s se ha registrado (IP: %s)", 
        GetPlayerName(playerid), PlayerAuthInfo[playerid][p_IP]);
    Logger_Write(LOG_REGISTROS, log);

    // Autenticaci?n autom?tica
    PlayerAuthInfo[playerid][p_LoggedIn] = true;
    FreezePlayer(playerid, false);
    SpawnPlayer(playerid);
}

public OnPasswordVerified(playerid, bool:success) {
    if(!success) {
        if(++PlayerAuthInfo[playerid][p_LoginAttempts] >= MAX_LOGIN_ATTEMPTS) {
            if(++PlayerAuthInfo[playerid][p_BanAttempts] >= MAX_BAN_ATTEMPTS) {
                // Sistema de auto-ban original mejorado
                new query[256];
                mysql_format(g_SQL, query, sizeof(query),
                    "INSERT INTO banned_ips (ip, motivo) VALUES ('%e', 'Muchos intentos fallidos')",
                    PlayerAuthInfo[playerid][p_IP]
                );
                mysql_async_query(g_SQL, query);
                
                KickPlayer(playerid, "IP baneada por intentos fallidos");
                return;
            }
            
            SendClientMessage(playerid, 0xFF0000FF, "Demasiados intentos fallidos. ?Cuidado con el ban!");
            ShowAuthDialog(playerid);
            return;
        }
        
        SendClientMessage(playerid, 0xFF0000FF, "Contrase?a incorrecta");
        ShowAuthDialog(playerid);
        return;
    }

    // Mantener mensaje de staff original
    if(PlayerAuthInfo[playerid][p_AdminLevel] > 0) {
        SendClientMessage(playerid, COLOR_ADMIN, "Bienvenido al equipo de staff!");
        SendClientMessage(playerid, COLOR_ADMIN, sprintf("Nivel Admin: %d", PlayerAuthInfo[playerid][p_AdminLevel]));
    }

	new name[MAX_PLAYER_NAME], query[256];
    GetPlayerName(playerid, name, sizeof(name));

    // Cargar datos del jugador desde SQL
    format(query, sizeof(query), "SELECT * FROM players WHERE name = '%q'", name);
    new DBResult:result = db_query(database, query);

    if(db_num_rows(result) > 0) {
        // Campos b?sicos
        PlayerInfo[playerid][pAdmin] = db_get_field_int(result, "admin");
        PlayerInfo[playerid][pMuted] = db_get_field_int(result, "muted");
        PlayerInfo[playerid][pKills] = db_get_field_int(result, "kills");
        PlayerInfo[playerid][pDeaths] = db_get_field_int(result, "deaths");
        PlayerInfo[playerid][pScore] = db_get_field_int(result, "score");
        
        // Cargar otros campos del legacy aqu?...
        
        SendClientMessage(playerid, COLOR_GREEN, "?Login exitoso!");
    } else {
        SendClientMessage(playerid, COLOR_YELLOW, "?Bienvenido! Registrate con /register.");

    // Sistema de spawn original adaptado
    FreezePlayer(playerid, false);
    SetPlayerSpawnInfo(playerid); // Funci?n que implementar?s seg?n tu sistema antiguo
    
    // Actualizar ?ltima IP
    new query[256];
    mysql_format(g_SQL, query, sizeof(query),
        "UPDATE cuentas SET ultima_ip = '%e' WHERE nombre = '%e'",
        PlayerAuthInfo[playerid][p_IP], GetPlayerName(playerid)
    );
    mysql_async_query(g_SQL, query);
	db_free_result(result);
}

stock KickPlayer(playerid, const reason[], va_args<>) {
    new mensaje[128];
    va_format(mensaje, sizeof(mensaje), reason, va_start<2>);
    
    // Mantener formato original de kick
    SendClientMessage(playerid, 0xFF0000FF, mensaje);
    defer DelayedKick(playerid);
}

timer DelayedKick[1000](playerid) {
    Kick(playerid);
}

// Sistema de logs fiel al original pero mejorado
stock Logger_Write(type, const message[]) {
    new log_entry[256], timestamp[24];
    format(timestamp, sizeof(timestamp), "[%02d:%02d:%02d]", gettime_hour(), gettime_minute(), gettime_second());
    
    switch(type) {
        case LOG_REGISTROS: format(log_entry, sizeof(log_entry), "%s [REGISTRO] %s", timestamp, message);
        case LOG_LOGINS: format(log_entry, sizeof(log_entry), "%s [LOGIN] %s", timestamp, message);
    }
    
    new File:archivo = fopen("logs/auth.log", io_append);
    if(archivo) {
        fwrite(archivo, sprintf("%s\r\n", log_entry));
        fclose(archivo);
    }
}

public OnPlayerDisconnect(playerid, reason) {
    new name[MAX_PLAYER_NAME], query[512];
    GetPlayerName(playerid, name, sizeof(name));

    // Guardar datos del jugador en SQL
    format(query, sizeof(query), 
        "UPDATE players SET \
            admin = %d, \
            muted = %d, \
            kills = %d, \
            deaths = %d, \
            score = %d \
        WHERE name = '%q'",
        PlayerInfo[playerid][pAdmin],
        PlayerInfo[playerid][pMuted],
        PlayerInfo[playerid][pKills],
        PlayerInfo[playerid][pDeaths],
        PlayerInfo[playerid][pScore],
        name
    );
    db_query(database, query);

    // Resetear variables
    PlayerInfo[playerid][pAdmin] = 0;
    PlayerInfo[playerid][pMuted] = 0;
    return 1;
}

// Generar salt para bcrypt
stock GenerateSalt(salt[], size = sizeof(salt)) {
    static const charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for(new i = 0; i < size - 1; i++) {
        salt[i] = charset[random(sizeof(charset) - 1)];
    }
    salt[size - 1] = '\0';
}

// kick seguro
stock KickPlayer(playerid, const message[]) {
    SendClientMessage(playerid, COLOR_RED, message);
    defer DelayedKick(playerid);
}

timer DelayedKick[500](playerid) {
    Kick(playerid);
}
