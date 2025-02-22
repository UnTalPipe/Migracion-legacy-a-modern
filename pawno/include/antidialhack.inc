/*
	Anti-DialogHack
	Creado por iDarkRain
	
	Es posible cambiar la ID del dialog actual editando la memoria del cliente, a�n en SA-MP 0.3d
	Con este include no se podr� cambiar.
*/

#include <a_samp>

forward OnPlayerHackDialog(playerid,dialogid,dialoghackedid);

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid != GetPVarInt(playerid,"DialogID")) OnPlayerHackDialog(playerid,GetPVarInt(playerid,"DialogID"),dialogid);
    CuandoRespondenDialog(playerid, GetPVarInt(playerid,"DialogID"), response, listitem, inputtext);
    return 1;
}

stock MostrarDialog(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	SetPVarInt(playerid, "DialogID", dialogid);
	return ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
}

forward CuandoRespondenDialog(playerid, dialogid, response, listitem, inputtext[]);

#define OnDialogResponse CuandoRespondenDialog
#define ShowPlayerDialog MostrarDialog