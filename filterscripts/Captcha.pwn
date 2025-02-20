#include <a_samp>
#include <text>

stock KickPlayer(playerid)
{
	SetTimerEx("stockkp", 1000, false, "i", playerid);
	return 1;
}

forward stockkp(playerid);

new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:Textdraw1[MAX_PLAYERS];
new PlayerText:Textdraw2[MAX_PLAYERS];
new PlayerText:Textdraw3[MAX_PLAYERS];
new PlayerText:Textdraw4[MAX_PLAYERS];
new PlayerText:Textdraw5[MAX_PLAYERS];
new PlayerText:Textdraw6[MAX_PLAYERS];

#define DIALOG_CAPTCHA 9259

new Captcha[MAX_PLAYERS];
new CaptchaDone[MAX_PLAYERS];
new StoreItDude[9999];

new RandomWord[] = // RANDOM WORDS SHOULDN'T BE TOO BIG
{
	"me-transfer25",
	"i-ampro",
	"watchnnlearn",
	"nooboots192",
	"2k15pro",
	"bangdang bee 9",
	"mafiapro hitler",
	"hitandkilljuba",
	"tormerfav",
	"2nsatws5hi"
};

public stockkp(playerid)
{
	Kick(playerid);
}


public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("MafiaOink(ZombieNest) Captcha System is now Loaded");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	print("\n--------------------------------------");
	print("MafiaOink(ZombieNest) Captcha System is now unloaded");
	print("--------------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
Textdraw0[playerid] = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, "LD_SPAC:white");
PlayerTextDrawLetterSize(playerid, Textdraw0[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw0[playerid], 640.000000, 448.000000);
PlayerTextDrawAlignment(playerid, Textdraw0[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw0[playerid], -5963521);
PlayerTextDrawSetShadow(playerid, Textdraw0[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw0[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw0[playerid], 4);

Textdraw1[playerid] = CreatePlayerTextDraw(playerid, 119.999961, 24.639997, "~b~HUMAN CAPTCHA~n~(PROVE YOURSELF)");
PlayerTextDrawLetterSize(playerid, Textdraw1[playerid], 1.194800, 12.344535);
PlayerTextDrawAlignment(playerid, Textdraw1[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw1[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw1[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw1[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw1[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw1[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw1[playerid], 1);

Textdraw2[playerid] = CreatePlayerTextDraw(playerid, 98.400009, 247.893203, "~g~PLEASE CLICK THE BUTTON AND TYPE IN THE WORD YOU SEE");
PlayerTextDrawLetterSize(playerid, Textdraw2[playerid], 0.437199, 4.295465);
PlayerTextDrawAlignment(playerid, Textdraw2[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw2[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw2[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw2[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw2[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw2[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw2[playerid], 1);

Textdraw3[playerid] = CreatePlayerTextDraw(playerid, 245.600006, 346.453399, "LD_BEAT:circle");
PlayerTextDrawLetterSize(playerid, Textdraw3[playerid], 0.028000, 0.350933);
PlayerTextDrawTextSize(playerid, Textdraw3[playerid], 117.599998, 83.626647);
PlayerTextDrawAlignment(playerid, Textdraw3[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw3[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw3[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw3[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw3[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw3[playerid], true);

Textdraw4[playerid] = CreatePlayerTextDraw(playerid, 202.399932, 297.920013, "randomword appears here");
PlayerTextDrawLetterSize(playerid, Textdraw4[playerid], 0.449999, 1.600000);
PlayerTextDrawAlignment(playerid, Textdraw4[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw4[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw4[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw4[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw4[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw4[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw4[playerid], 1);

Textdraw5[playerid] = CreatePlayerTextDraw(playerid, 450.000061, 295.686645, "usebox");
PlayerTextDrawLetterSize(playerid, Textdraw5[playerid], 0.000000, 2.489257);
PlayerTextDrawTextSize(playerid, Textdraw5[playerid], 197.199920, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw5[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw5[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw5[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw5[playerid], 102);
PlayerTextDrawSetShadow(playerid, Textdraw5[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw5[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw5[playerid], 0);

Textdraw6[playerid] = CreatePlayerTextDraw(playerid, 111.999893, 286.719879, "~g~Captcha >>~n~~r~Space is allowed+important");
PlayerTextDrawLetterSize(playerid, Textdraw6[playerid], 0.375599, 3.892264);
PlayerTextDrawAlignment(playerid, Textdraw6[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw6[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw6[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw6[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw6[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw6[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw6[playerid], 1);

PlayerTextDrawShow(playerid, Textdraw0[playerid]);
PlayerTextDrawShow(playerid, Textdraw1[playerid]);
PlayerTextDrawShow(playerid, Textdraw2[playerid]);
PlayerTextDrawShow(playerid, Textdraw3[playerid]);
PlayerTextDrawShow(playerid, Textdraw4[playerid]);
PlayerTextDrawShow(playerid, Textdraw5[playerid]);
PlayerTextDrawShow(playerid, Textdraw6[playerid]);

Captcha[playerid] = 1;
CaptchaDone[playerid] = 0;
SelectTextDraw(playerid, 0x00FF00FF);
SendClientMessage(playerid, -1, "PRESS 'YES(Y)' TO GET THE CURSOR BACK IF QUITED");
PlayerTextDrawSetString(playerid, Textdraw4[playerid], RandomWord[random(10)]);
return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_YES)
    {
        if(Captcha[playerid] == 1)
        {
        	SelectTextDraw(playerid, 0x00FF00FF);
		}
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
	if(CaptchaDone[playerid] == 0) return SendClientMessage(playerid, -1, "You have bypassed the security, Kicking player."), Kick(playerid);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(CaptchaDone[playerid] == 0) return SendClientMessage(playerid, -1, "You are not allowed to use commands if not done Captcha, Kicking player."), Kick(playerid);
	return 0;
}

public OnPlayerRequestSpawn(playerid)
{
    if(CaptchaDone[playerid] == 0) return SendClientMessage(playerid, -1, "You have bypassed the security, Kicking player."), Kick(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_CAPTCHA)
    {
        if(response)
        {
            if (!strcmp(inputtext, PlayerTextDrawGetText(Textdraw4[playerid]), true))
			{
                CaptchaDone[playerid] = 1;
                Captcha[playerid] = 0;
                PlayerTextDrawHide(playerid, Textdraw0[playerid]);
                PlayerTextDrawHide(playerid, Textdraw1[playerid]);
                PlayerTextDrawHide(playerid, Textdraw2[playerid]);
                PlayerTextDrawHide(playerid, Textdraw3[playerid]);
                PlayerTextDrawHide(playerid, Textdraw4[playerid]);
                PlayerTextDrawHide(playerid, Textdraw5[playerid]);
                PlayerTextDrawHide(playerid, Textdraw6[playerid]);
                SendClientMessage(playerid, -1, "CAPTCHA DONE - HUMAN STATUS VERIFIED!");
			}
			else
			{
			    SendClientMessage(playerid, -1, "CAPTCHA WRONG - HUMAN STATUS CANCELED! - KICKING PLAYER");
			    Kick(playerid);
			}
        }
        else
        {
            SendClientMessage(playerid, -1, "You MUST complete the captcha and now fuck off!");
            Kick(playerid);
        }
        return 1;
    }

    return 0; 
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == Textdraw3[playerid])
    {
         ShowPlayerDialog(playerid, DIALOG_CAPTCHA, DIALOG_STYLE_INPUT, "Server Captcha", "Please insert the words you see in the captcha box to verify as human!", "Try my luck", "Shi' Wanna quit");
         CancelSelectTextDraw(playerid);
    }
    return 1;
}
