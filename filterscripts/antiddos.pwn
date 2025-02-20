#include <a_samp>
#include <a_http>

forward BanCheck(index, response_code, data[]);
forward KickTimer();

new BANNED[MAX_PLAYERS];
new CHECKED[MAX_PLAYERS];


//Do not modify
#define CP_VERSION "2.4"

public OnPlayerConnect(playerid)
{
    new plrIP[16];
    GetPlayerIp(playerid, plrIP, sizeof(plrIP));
        new string[128];
    format(string, sizeof(string), "creamystuff.tk/creamyprotection/index.php?ip=%s",plrIP);
        HTTP(playerid, HTTP_GET, string, "", "BanCheck");
        BANNED[playerid] = 0;
        return 1;
}

public BanCheck(index, response_code, data[])
{
        new plrIP[16];
        GetPlayerIp(index, plrIP, sizeof(plrIP));
    new buffer[ 128 ];
    if(response_code == 200)
    {
        if(strfind(data, "Ban Code:01", true) != -1)
                {
                        new string[500];
                        format(string, sizeof(string), "{00FFFF}Vos estás {00FF00}baneado{00FFFF} del servidor!\n\n{FF6600}Razón: {FFFFFF}Proxy Server\n{FF6600}Admin: {FFFFFF}Anti-Cheats\n{FF6600}IP Address: {FFFFFF}%s\n{FF6600}Ban Code: {FFFFFF}01\n\n{00FFFF}Si crees que este baneo fue incorrecto por favor\nVisita nuestra página. {00FF00}https://www.facebook.com/groups/GameZoneFree/ {00FFFF}y sube pruebas\npara el desbaneo, gracias.",plrIP);
                ShowPlayerDialog(index, 149, DIALOG_STYLE_MSGBOX, "{FF0000}Anti{FFFFFF}Cheats {FF0000}P{FFFFFF}rotección", string, "Close", "");
                        BANNED[index] = 1;
                        SetTimer("KickTimer", 1, false);
                }
        }
        else
        {
                format(buffer, sizeof(buffer), "{00FF00}[Anti-Cheats]: {00FFFF}Eres bueno para jugar aquí, gracias por jugar limpio.", data);
                SendClientMessage(index, 0xFFFFFFFF, buffer);
                new pname[MAX_PLAYER_NAME], string2[110 + MAX_PLAYER_NAME];
                GetPlayerName(index, pname, sizeof(pname));
                format(string2, sizeof(string2), "{00FF00}[Anti-Cheats]: {FFFFFF}%s[%d] {669999}entró al servidor limpiamente.", pname, index);
                SendClientMessageToAll(0xAAAAAAAA, string2);
                CHECKED[index] = 1;
        }
}

public KickTimer()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(BANNED[i] == 1)
            {
                Kick(i);
        }
        }
}

