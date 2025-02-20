/*
Include hecho por losrivarola98
Include made by losrivarola98
*/
#if defined L_SPEC
	#endinput
#endif
#define L_SPEC

native IsValidVehicle(vehicleid);

stock L_PlayerSpectatePlayer(playerid,targetplayerid,mode = SPECTATE_MODE_NORMAL)
{
	SetPVarInt(playerid,"L_Spectating",1);
	SetPVarInt(playerid,"L_ID_Spectating",targetplayerid+1);
	SetPVarInt(playerid,"L_SpectatingP",1);
	return PlayerSpectatePlayer(playerid,targetplayerid,mode);
}

#if defined _ALS_PlayerSpectatePlayer
	#undef PlayerSpectatePlayer
#else
	#define _ALS_PlayerSpectatePlayer
#endif
#define PlayerSpectatePlayer L_PlayerSpectatePlayer

stock L_PlayerSpectateVehicle(playerid,targetvehicleid,mode = SPECTATE_MODE_NORMAL)
{
	SetPVarInt(playerid,"L_Spectating",1);
	SetPVarInt(playerid,"L_VEH_Spectating",targetvehicleid);
	SetPVarInt(playerid,"L_SpectatingV",1);
	return PlayerSpectateVehicle(playerid,targetvehicleid,mode);
}

#if defined _ALS_PlayerSpectateVehicle
	#undef PlayerSpectateVehicle
#else
	#define _ALS_PlayerSpectateVehicle
#endif
#define PlayerSpectateVehicle L_PlayerSpectateVehicle

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(oldstate == PLAYER_STATE_SPECTATING)
	{
	    DeletePVar(playerid,"L_Spectating");
		DeletePVar(playerid,"L_VEH_Spectating");
		DeletePVar(playerid,"L_ID_Spectating");
		DeletePVar(playerid,"L_SpectatingP");
		DeletePVar(playerid,"L_SpectatingV");
	}
	#if defined L_OnPlayerRequestClass
		return L_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange L_OnPlayerStateChange
#if defined L_OnPlayerStateChange
	forward L_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    DeletePVar(playerid,"L_Spectating");
	DeletePVar(playerid,"L_VEH_Spectating");
	DeletePVar(playerid,"L_ID_Spectating");
	DeletePVar(playerid,"L_SpectatingP");
	DeletePVar(playerid,"L_SpectatingV");
	#if defined L_OnPlayerDisconnect
		return L_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect L_OnPlayerDisconnect
#if defined L_OnPlayerDisconnect
	forward L_OnPlayerDisconnect(playerid, reason);
#endif

stock IsPlayerSpectating(playerid)
{
	if(!IsPlayerConnected(playerid)) return -1;
	if(GetPVarInt(playerid,"L_Spectating") == 1) return true;
	else return false;
}

stock IsPlayerSpectatingAnyPlayer(playerid)
{
	if(!IsPlayerConnected(playerid)) return -1;
	if(GetPVarInt(playerid,"L_SpectatingP") == 1) return true;
	else return false;
}

stock IsPlayerSpectatingAnyVehicle(playerid)
{
	if(!IsPlayerConnected(playerid)) return -1;
	if(GetPVarInt(playerid,"L_SpectatingV") == 1) return true;
	else return false;
}

stock IsPlayerSpectatingPlayer(playerid,targetplayerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetplayerid)) return -1;
    if(GetPlayerSpectatedForPlayer(playerid) == targetplayerid) return true;
    else return false;
}

stock IsPlayerSpectatingVehicle(playerid,targetvehicleid)
{
	if(!IsPlayerConnected(playerid) || !IsValidVehicle(targetvehicleid)) return -1;
	if(GetVehicleSpectatedForPlayer(playerid) == targetvehicleid) return true;
	else return false;
}

stock GetVehicleSpectatedByPlayer(playerid)
{
	new result;
	if(!IsPlayerSpectating(playerid)) return INVALID_VEHICLE_ID;
	result = GetPVarInt(playerid,"L_VEH_Spectating");
	return result;
}

stock GetPlayerSpectatedByPlayer(playerid)
{
	new result;
	if(!IsPlayerSpectating(playerid)) return INVALID_PLAYER_ID;
	result = GetPVarInt(playerid,"L_ID_Spectating");
	return result-1;
}

stock GetPlayersSpectatingPlayerCount(playerid)
{
	new count;
    if(!IsPlayerConnected(playerid)) return -1;
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(GetPlayerSpectatedForPlayer(i) == playerid) count++;
		}
	}
	return count;
}

stock GetPlayersSpectatingVehicleCount(vehicleid)
{
	new count;
	if(!IsValidVehicle(vehicleid)) return -1;
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(GetVehicleSpectatedForPlayer(i) == vehicleid) count++;
		}
	}
	return count;
}
