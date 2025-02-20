//==============================================================================//
/* ================================||
|| FS Creado Por [KOTS]loquendo[2] ||
||        © Copyright 2014         ||
||        Revolucion Latina        ||
||=================================||*/
//==============================================================================//
#define FILTERSCRIPT
#include <a_samp>
#pragma tabsize 0
//==============================================================================//
new Text:textdeabajo;
new Text:cara1;
new Text:cara2;
new Text:cara3;
new Text:cara4;
new Text:cara5;
new Text:Box1;
new Text:Box2;
new Text:Box3;
new Text:comandos2;
new Text:nave;
new Text:exbum;
new Text:mode;
//==============================================================================//
new bum[][] =
{
	"ld_dual:ex1",
	"ld_dual:ex2",
	"ld_dual:ex3",
	"ld_dual:ex4"
};
forward Timerbum(playerid);

//==============================================================================//
new MR[][] =
{
	"~r~[INFO]: ~w~Si eres nuevo puedes usar ~r~/cmds ~b~/ayuda ~y~/pregunta ~w~Tambien puedes preguntar",
	"~r~[INFO]: ~w~Tienes dudas habla con nuestros ~r~administradores ~w~usa /admins",
	"~r~[INFO]: ~w~Puedes ver la lista de Users ~y~Vips ~w~con ~w~/vips",
	"~r~[INFO]: ~w~Visita Nuestra Nueva WEB ~r~PRONTO",
	"~r~[INFO]: ~w~Puedes crear clanes con ~g~/clan ~w~y invitar a tus amigos y conquista ~r~zonas",
	"~r~[INFO]: ~w~Quieres ponerle un precio a la cabeza de alguien? Usa ~y~/recompensa",
	"~r~[INFO]: ~w~No tomes muchas ~r~/drogas ~w~por que te cagaran el cerebro y quedaras loco",
	"~r~[INFO]: ~w~Nuevo en SA:MP? Mira el cmd ~p~/sampinfo ~w~orientate mas sobre el ~r~SAMP",
	"~r~[INFO]: ~w~Quieres poner ~b~objetos ~w~a tu personaje y verte bien ~w~usa ~g~/items",
	"~r~[INFO]: ~w~Usa Nuestro Chat exclusivo para ~b~vips ~w~habla con ~r~$texto",
	"~r~[INFO]: ~w~Puedes ver los users en AFK (Away From Keyboard) con ~r~/afks",
	"~r~[INFO]: ~w~Nueva Forma De Ver Nuestro Menu Apretando La Tecla ~w~N",
	"~r~[INFO]: ~w~Mira a los mas ~r~PRO ~w~del servidor y el ranking~w~ usa ~p~/TOP",
	"~r~[INFO]: ~w~Cambia el clima del servidor si no te gusta con ~y~/dia, ~b~/noche y ~r~/tiempo"
};
forward TimerMR(playerid);
//==============================================================================//
new RDTX[][] =
{
	"/CMDS",
	"/CREDITOS",
	"/REPORTAR",
	"/AYUDA",
	"/MINIJUEGOS",
	"/STATS ID",
	"/REGALAR",
	"/PAIS ID",
	"/VOZ",
	"/REGLAS",
    "/VIPS",
    "/CLAN",
	"/TELES",
	"/TOP",
	"/RADIO",
	"/COLORES",
	"/ARMAS",
	"/RANGOS",
	"/CONTEO",
    "/AFKS",
	"/RW Y /WW",
	"/AUTOS",
	"/NEONES",
    "/ITEMS",
    "/PELEAS",
    "/CAMINAR",
    "/SKIN",
    "/DARDINERO",
	"/AFK",
	"/DROGAS",
	"/TIEMPO",
	"/LUCES",
	"/ADMINS",
	"/SAMPINFO",
    "/ACCIONES",
    "/EVENTOS",
    "/INTERIORES",
    "NO INSULTES",
    "NO USES HACK"
};
forward TimerRDTX(playerid);
//==============================================================================//
public OnFilterScriptInit()
{
	print("||===================================||");
	print("||© Copyright 2014 [KOTS]loquendo[2] ||");
    print("||    Revolucion Latina Freeroam     ||");
	print("||===================================||");
	//SetTimer("TimerMR",10000,true);
	//SetTimer("TimerRDTX",10000,true);
	//SetTimer("Timerbum",1000,1);

//==============================================================================//
    // TEXTDRAW BY [KOTS]loquendo[2]
    textdeabajo = TextDrawCreate(163.000000, 430.000000, "~r~[INFO]: ~w~Si eres nuevo puedes usar ~r~/cmds ~b~/ayuda ~y~/pregunta ~w~Tambien puedes preguntar");
    TextDrawBackgroundColor(textdeabajo, 255);
    TextDrawFont(textdeabajo, 2);
    TextDrawLetterSize(textdeabajo, 0.220000, 1.400000);
    TextDrawColor(textdeabajo, -1);
    TextDrawSetOutline(textdeabajo, 1);
    TextDrawSetProportional(textdeabajo, 1);
    TextDrawSetSelectable(textdeabajo, 0);
//==============================================================================//
    cara1 = TextDrawCreate(161.000000, 425.000000, "ld_chat:badchat");
    TextDrawBackgroundColor(cara1, 255);
    TextDrawFont(cara1, 4);
    TextDrawLetterSize(cara1, 0.500000, 1.000000);
    TextDrawColor(cara1, -1);
    TextDrawSetOutline(cara1, 0);
    TextDrawSetProportional(cara1, 1);
    TextDrawSetShadow(cara1, 1);
    TextDrawUseBox(cara1, 1);
    TextDrawBoxColor(cara1, 255);
    TextDrawTextSize(cara1, -23.000000, 23.000000);
    TextDrawSetSelectable(cara1, 0);
//==============================================================================//
    Box1 = TextDrawCreate(140.000000, 427.000000, "-");
    TextDrawBackgroundColor(Box1, 255);
    TextDrawFont(Box1, 1);
    TextDrawLetterSize(Box1, 1.880000, 5.300000);
    TextDrawColor(Box1, -1);
    TextDrawSetOutline(Box1, 0);
    TextDrawSetProportional(Box1, 1);
    TextDrawSetShadow(Box1, 1);
    TextDrawUseBox(Box1, 1);
    TextDrawBoxColor(Box1, -16777186);
    TextDrawTextSize(Box1, 795.000000, 40.000000);
    TextDrawSetSelectable(Box1, 0);
//==============================================================================//
    cara2 = TextDrawCreate(-1.000000, 426.000000, "hud:radar_race");
    TextDrawBackgroundColor(cara2, 255);
    TextDrawFont(cara2, 4);
    TextDrawLetterSize(cara2, 0.500000, 1.000000);
    TextDrawColor(cara2, -1);
    TextDrawSetOutline(cara2, 0);
    TextDrawSetProportional(cara2, 1);
    TextDrawSetShadow(cara2, 1);
    TextDrawUseBox(cara2, 1);
    TextDrawBoxColor(cara2, 255);
    TextDrawTextSize(cara2, 25.000000, 20.000000);
    TextDrawSetSelectable(cara2, 0);
//==============================================================================//
    comandos2 = TextDrawCreate(26.000000, 429.000000, "/Comandos");
    TextDrawBackgroundColor(comandos2, 65535);
    TextDrawFont(comandos2, 2);
    TextDrawLetterSize(comandos2, 0.390000, 1.700000);
    TextDrawColor(comandos2, 16711935);
    TextDrawSetOutline(comandos2, 1);
    TextDrawSetProportional(comandos2, 1);
    TextDrawSetSelectable(comandos2, 0);
//==============================================================================//
    Box2 = TextDrawCreate(-7.000000, 427.000000, "-");
    TextDrawBackgroundColor(Box2, 255);
    TextDrawFont(Box2, 1);
    TextDrawLetterSize(Box2, 0.500000, 3.000000);
    TextDrawColor(Box2, -1);
    TextDrawSetOutline(Box2, 0);
    TextDrawSetProportional(Box2, 1);
    TextDrawSetShadow(Box2, 1);
    TextDrawUseBox(Box2, 1);
    TextDrawBoxColor(Box2, -16777186);
    TextDrawTextSize(Box2, 132.000000, 0.000000);
    TextDrawSetSelectable(Box2, 0);
//==============================================================================//
    cara3 = TextDrawCreate(489.000000, 407.000000, "hud:radar_enemyattack");
    TextDrawBackgroundColor(cara3, 255);
    TextDrawFont(cara3, 4);
    TextDrawLetterSize(cara3, 0.480000, 0.799999);
    TextDrawColor(cara3, -1);
    TextDrawSetOutline(cara3, 0);
    TextDrawSetProportional(cara3, 1);
    TextDrawSetShadow(cara3, 1);
    TextDrawUseBox(cara3, 1);
    TextDrawBoxColor(cara3, 255);
    TextDrawTextSize(cara3, 15.000000, 16.000000);
    TextDrawSetSelectable(cara3, 0);
//==============================================================================//
    cara4 = TextDrawCreate(507.000000, 391.000000, "ld_chat:thumbup");
    TextDrawBackgroundColor(cara4, 255);
    TextDrawFont(cara4, 4);
    TextDrawLetterSize(cara4, 0.500000, 1.000000);
    TextDrawColor(cara4, -1);
    TextDrawSetOutline(cara4, 0);
    TextDrawSetProportional(cara4, 1);
    TextDrawSetShadow(cara4, 1);
    TextDrawUseBox(cara4, 1);
    TextDrawBoxColor(cara4, 255);
    TextDrawTextSize(cara4, -18.000000, 15.000000);
    TextDrawSetSelectable(cara4, 0);
//==============================================================================//
    cara5 = TextDrawCreate(486.000000, 368.000000, "hud:radar_gangn");
    TextDrawBackgroundColor(cara5, 255);
    TextDrawFont(cara5, 4);
    TextDrawLetterSize(cara5, 0.500000, 1.000000);
    TextDrawColor(cara5, -1);
    TextDrawSetOutline(cara5, 0);
    TextDrawSetProportional(cara5, 1);
    TextDrawSetShadow(cara5, 1);
    TextDrawUseBox(cara5, 1);
    TextDrawBoxColor(cara5, 255);
    TextDrawTextSize(cara5, 20.000000, 20.000000);
    TextDrawSetSelectable(cara5, 0);
//==============================================================================//
    Box3 = TextDrawCreate(657.000000, 371.000000, "-");
    TextDrawBackgroundColor(Box3, 255);
    TextDrawFont(Box3, 1);
    TextDrawLetterSize(Box3, 0.500000, 5.499999);
    TextDrawColor(Box3, -1);
    TextDrawSetOutline(Box3, 0);
    TextDrawSetProportional(Box3, 1);
    TextDrawSetShadow(Box3, 1);
    TextDrawUseBox(Box3, 1);
    TextDrawBoxColor(Box3, -16777186);
    TextDrawTextSize(Box3, 484.000000, 0.000000);
    TextDrawSetSelectable(Box3, 0);
//==============================================================================//
	nave = TextDrawCreate(122.000000, 285.000000, "ld_none:force");
    TextDrawBackgroundColor(nave, 255);
    TextDrawFont(nave, 4);
    TextDrawLetterSize(nave, 0.500000, 1.000000);
    TextDrawColor(nave, -1);
    TextDrawSetOutline(nave, 0);
    TextDrawSetProportional(nave, 1);
    TextDrawSetShadow(nave, 1);
    TextDrawUseBox(nave, 1);
    TextDrawBoxColor(nave, 255);
    TextDrawTextSize(nave, 37.000000, 23.000000);
    TextDrawSetSelectable(nave, 0);
//==============================================================================//
    exbum = TextDrawCreate(-1.000000, 295.000000, "ld_none:explm04");
    TextDrawBackgroundColor(exbum, 255);
    TextDrawFont(exbum, 4);
    TextDrawLetterSize(exbum, 0.500000, 1.000000);
    TextDrawColor(exbum, -1);
    TextDrawSetOutline(exbum, 0);
    TextDrawSetProportional(exbum, 1);
    TextDrawSetShadow(exbum, 1);
    TextDrawUseBox(exbum, 1);
    TextDrawBoxColor(exbum, 255);
    TextDrawTextSize(exbum, 33.000000, 29.000000);
    TextDrawSetSelectable(exbum, 0);
//==============================================================================//
    mode = TextDrawCreate(460.000000, 102.000000, "~y~Stunt~w~/~r~Drift~w~/~p~Parkour~w~/~g~Race");
    TextDrawBackgroundColor(mode, 255);
    TextDrawFont(mode, 3);
    TextDrawLetterSize(mode, 0.380000, 1.200000);
    TextDrawColor(mode, -1);
    TextDrawSetOutline(mode, 1);
    TextDrawSetProportional(mode, 1);
    TextDrawSetSelectable(mode, 0);
	}
//==============================================================================//
public OnPlayerSpawn(playerid)
{
	PlayerStats2(playerid);
	return 1;
}
//==============================================================================//
forward PlayerStats2(playerid);
public PlayerStats2(playerid)
{
	TextDrawSetString(textdeabajo, MR[random(sizeof(MR))]);
	TextDrawShowForPlayer(playerid, textdeabajo);
	TextDrawSetString(comandos2, RDTX[random(sizeof(RDTX))]);
	TextDrawShowForPlayer(playerid, comandos2);
	TextDrawSetString(exbum, bum[random(sizeof(bum))]);
	TextDrawShowForPlayer(playerid, exbum);
	TextDrawShowForPlayer(playerid, cara1);
	TextDrawShowForPlayer(playerid, cara2);
	TextDrawShowForPlayer(playerid, cara3);
	TextDrawShowForPlayer(playerid, cara4);
	TextDrawShowForPlayer(playerid, cara5);
	TextDrawShowForPlayer(playerid, Box1);
	TextDrawShowForPlayer(playerid, Box2);
	TextDrawShowForPlayer(playerid, Box3);
	TextDrawShowForPlayer(playerid, nave);
	TextDrawShowForPlayer(playerid, mode);
	return 1;
}
//==============================================================================//
