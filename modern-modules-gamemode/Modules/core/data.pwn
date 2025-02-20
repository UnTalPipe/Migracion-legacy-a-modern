#include <open.mp>
#include <sqlite>

new DB:database;

// Crea la conexi?n al iniciar el GameMode 
public OnGameModeInit() 
{
	database = db_open("players.db");
	
	// Crear tabla si no existe 
	db_query(database,
		"CREATE TABLE IF NOT EXISTS players (\
		name TEXT PRIMARY KEY,\
		password TEXT,\
		salt TEXT,\
		muted INTEGER DEFAULT 0,\
		score INTEGER DEFAULT 0,\
		kills INTEGER DEFAULT 0,\
		deaths INTEGER DEFAULT 0,\
		admin INTEGER DEFAULT 0,\
		")
	);
	return 1
}

public OnPlayerConnect(playerid) {
    new name[MAX_PLAYER_NAME], query[256];
    GetPlayerName(playerid, name, sizeof(name));
    
    format(query, sizeof(query), "SELECT * FROM players WHERE name = '%q'", name);
    new DBResult:result = db_query(database, query);
    
    if(db_num_rows(result) > 0) {
        PlayerInfo[playerid][pScore] = db_get_field_int(result, "score");
        PlayerInfo[playerid][pKills] = db_get_field_int(result, "kills");
        PlayerInfo[playerid][pDeaths] = db_get_field_int(result, "deaths");
        PlayerInfo[playerid][pAdmin] = db_get_field_int(result, "admin");
    } else {
        // Opcional: Auto-registro si no existe
        SendClientMessage(playerid, 0xFFFFFFAA, "?Bienvenido! Registrate con /register.");
    }
    db_free_result(result);
    return 1;
}

// Cierra la conexion al finalizar
public OnGameModeExit()
{
	db_close(database);
	return 1;
}

// algunos comandos
CMD:setadmin(playerid, params[]) {
    new targetid, level, name[MAX_PLAYER_NAME], query[256];
    if(sscanf(params, "ui", targetid, level)) 
        return SendClientMessage(playerid, 0xFFFFFFFF, "Uso: /setadmin [id] [nivel]");
    
    GetPlayerName(targetid, name, sizeof(name));
    format(query, sizeof(query), 
        "UPDATE players SET admin = %d WHERE name = '%q'", 
        level, name
    );
    db_query(database, query);
    
    PlayerInfo[targetid][pAdmin] = level; // Actualizar en memoria
    SendClientMessage(playerid, 0x00FF00AA, "Rango admin actualizado.");
    return 1;
}
CMD:eliminarcuenta(playerid, params[]) {
    new name[24], query[128];
    if(sscanf(params, "s[24]", name)) 
        return SendClientMessage(playerid, 0xFFFFFFFF, "Uso: /eliminarcuenta [nombre]");
    
    format(query, sizeof(query), "DELETE FROM players WHERE name = '%q'", name);
    db_query(database, query);
    
    // Verificar si se elimin?
    new DBResult:result = db_query(database, "SELECT changes() AS affected_rows");
    new rows = db_get_field_int(result);
    db_free_result(result);
    
    if(rows > 0) SendClientMessage(playerid, 0xFF0000AA, "Cuenta eliminada.");
    else SendClientMessage(playerid, 0xFF0000AA, "Cuenta no encontrada.");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == DIALOG_REGISTER) {
        new name[MAX_PLAYER_NAME], query[256];
        GetPlayerName(playerid, name, sizeof(name));

        // Hash de contrase?a con bcrypt (Open.mp lo recomienda)
        bcrypt_hash(playerid, "OnPasswordHash", inputtext, name);
        
        SendClientMessage(playerid, COLOR_WHITE, "Registrando cuenta...");
    }
}
{
	if(dialogid == DIALOG_LOGIN) {
        new name[MAX_PLAYER_NAME], query[256];
        GetPlayerName(playerid, name, sizeof(name));
        
        // Buscar usuario en la base de datos
        format(query, sizeof(query), "SELECT password FROM players WHERE name = '%q'", name);
        new DBResult:result = db_query(database, query);
        
        if(db_num_rows(result) > 0) {
            new stored_hash[BCRYPT_HASH_LENGTH];
            db_get_field_assoc(result, "password", stored_hash, sizeof(stored_hash));
            
            // Verificar contrase?a
            bcrypt_verify(playerid, "OnPasswordVerify", inputtext, stored_hash);
        } else {
            SendClientMessage(playerid, COLOR_RED, "?Usuario no registrado!");
        }
        db_free_result(result);
    } 
	return 1;
}

// Callback cuando el hash est? listo
forward OnPasswordHash(playerid, hashid, const name[]);
public OnPasswordHash(playerid, hashid, const name[]) {
    new hash[BCRYPT_HASH_LENGTH], query[512];
    bcrypt_get_hash(hash, sizeof(hash));

    // Insertar en la base de datos
    format(query, sizeof(query), 
        "INSERT INTO players (name, password, score, kills, deaths, admin) \
        VALUES ('%q', '%q', 0, 0, 0, 0)",
        name, hash
    );
    
    db_query(database, query);
    SendClientMessage(playerid, COLOR_GREEN, "?Registro exitoso!");
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason) {
    new name[MAX_PLAYER_NAME], query[256];
    
    // Actualizar muertes del jugador
    GetPlayerName(playerid, name, sizeof(name));
    format(query, sizeof(query), 
        "UPDATE players SET deaths = deaths + 1 WHERE name = '%q'", 
        name
    );
    db_query(database, query);
    
    // Actualizar kills del asesino
    if(killerid != INVALID_PLAYER_ID) {
        GetPlayerName(killerid, name, sizeof(name));
        format(query, sizeof(query), 
            "UPDATE players SET kills = kills + 1 WHERE name = '%q'", 
            name
        );
        db_query(database, query);
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    new name[MAX_PLAYER_NAME], query[512];
    GetPlayerName(playerid, name, sizeof(name));
    
    format(query, sizeof(query), 
        "UPDATE players SET \
            score = %d, \
            kills = %d, \
            deaths = %d, \
            admin = %d \
        WHERE name = '%q'",
        PlayerInfo[playerid][pScore],
        PlayerInfo[playerid][pKills],
        PlayerInfo[playerid][pDeaths],
        PlayerInfo[playerid][pAdmin],
        name
    );
    
    db_query(database, query);
    return 1;
}