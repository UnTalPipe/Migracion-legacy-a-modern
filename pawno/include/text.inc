/* SA-MP Include GetText-Functions
 *
 * (c) by Kaliber, 2015
 *
 */
#if !defined _samp_included
    #include <a_samp>
#endif
#if defined _samp_getText
    #endinput
#endif
#define _samp_getText
#if !defined MAX_TEXT_DRAWS
	#define MAX_TEXT_DRAWS (512)
#endif
#if !defined MAX_TEXT
	#define MAX_TEXT (128)
#endif
#define A:: e_T_
/*
	native TextDrawGetText(Text:id);
	native PlayerTextDrawGetText(PlayerText:id);
*/
#if defined FILTERSCRIPT
	forward A::OnFilterScriptInit();
#else
	forward A::OnGameModeInit();
#endif
native Text:A::TextDrawCreate(Float:x, Float:y, text[]) = TextDrawCreate;
native A::TextDrawSetString(Text:text, string[]) = TextDrawSetString;
native A::TextDrawDestroy(Text:text) = TextDrawDestroy;

native PlayerText:A::CreatePlayerTextDraw(playerid,Float:x, Float:y, text[]) = CreatePlayerTextDraw;
native A::PlayerTextDrawSetString(playerid, PlayerText:text, string[]) = PlayerTextDrawSetString;
native A::PlayerTextDrawDestroy(playerid, PlayerText:text) = PlayerTextDrawDestroy;
enum A::e {
	A::t[MAX_TEXT char], A::flag, bool:A::n
};
static A::S[MAX_TEXT_DRAWS][A::e];

stock TextDrawGetText(Text:id) {
    new t = A::f1(_:id),tmp[MAX_TEXT] = "NaN";
	if(t == INVALID_TEXT_DRAW) return tmp;
	return strunpack(tmp,A::S[t][A::t],MAX_TEXT),tmp;
}
stock PlayerTextDrawGetText(PlayerText:id) {
    new t = A::f2(_:id),tmp[MAX_TEXT] = "NaN";
	if(t == INVALID_TEXT_DRAW) return tmp;
	return strunpack(tmp,A::S[t][A::t],MAX_TEXT),tmp;
}
stock Text:_TextDrawCreate(Float:x, Float:y, text[]) {
	new id = A::GetFree();
	if(id == -1) return Text:INVALID_TEXT_DRAW;
	A::S[id][A::flag] = _:A::TextDrawCreate(x,y,text),A::S[id][A::n]=false;
	return strpack(A::S[id][A::t],text,MAX_TEXT),Text:A::S[id][A::flag];
}
#if defined _ALS_TextDrawCreate
	#undef TextDrawCreate
#else
	#define _ALS_TextDrawCreate
#endif
#define TextDrawCreate _TextDrawCreate
stock PlayerText:_CreatePlayerTextDraw(playerid, Float:x, Float:y, text[]) {
	if(!IsPlayerConnected(playerid)) return PlayerText:INVALID_TEXT_DRAW;
	new id = A::GetFree();
	if(id == -1) return PlayerText:INVALID_TEXT_DRAW;
	A::S[id][A::flag] = _:A::CreatePlayerTextDraw(playerid,x,y,text),A::S[id][A::n]=true;
	return strpack(A::S[id][A::t],text,MAX_TEXT),PlayerText:A::S[id][A::flag];
}
#if defined _ALS_CreatePlayerTextDraw
	#undef CreatePlayerTextDraw
#else
	#define _ALS_CreatePlayerTextDraw
#endif
#define CreatePlayerTextDraw _CreatePlayerTextDraw
stock _TextDrawSetString(Text:text, string[]) {
	new t = A::f1(_:text);
	if(t == INVALID_TEXT_DRAW) return 0;
	return strpack(A::S[t][A::t],string,MAX_TEXT),A::TextDrawSetString(text,string);
}
#if defined _ALS_TextDrawSetString
	#undef TextDrawSetString
#else
	#define _ALS_TextDrawSetString
#endif
#define TextDrawSetString _TextDrawSetString
stock _PlayerTextDrawSetString(playerid, PlayerText:text, string[]) {
	new t = A::f2(_:text);
	if(t == INVALID_TEXT_DRAW) return 0;
	return strpack(A::S[t][A::t],string,MAX_TEXT),A::PlayerTextDrawSetString(playerid,text,string);
}
#if defined _ALS_PlayerTextDrawSetString
	#undef PlayerTextDrawSetString
#else
	#define _ALS_PlayerTextDrawSetString
#endif
#define PlayerTextDrawSetString _PlayerTextDrawSetString
stock _PlayerTextDrawDestroy(playerid, PlayerText:text) {
	new t = A::f2(_:text);
	if(t == INVALID_TEXT_DRAW) return 0;
	return A::S[t][A::flag] = -1,A::PlayerTextDrawDestroy(playerid,text);
}
#if defined _ALS_PlayerTextDrawDestroy
	#undef PlayerTextDrawDestroy
#else
	#define _ALS_PlayerTextDrawDestroy
#endif
#define PlayerTextDrawDestroy _PlayerTextDrawDestroy
stock _TextDrawDestroy(Text:text) {
	new t = A::f1(_:text);
	if(t == INVALID_TEXT_DRAW) return 0;
	return A::S[t][A::flag] = -1,A::TextDrawDestroy(text);
}
#if defined _ALS_TextDrawDestroy
	#undef TextDrawDestroy
#else
	#define _ALS_TextDrawDestroy
#endif
#define TextDrawDestroy _TextDrawDestroy

#if defined FILTERSCRIPT
	public OnFilterScriptInit() {
	    for(new i; i<sizeof(A::S); i++) A::S[i][A::flag] = -1;
		return CallLocalFunction("e_T_OnFilterScriptInit","");
	}
	#if defined _ALS_OnFilterScriptInit
	    #undef OnFilterScriptInit
	#else
	    #define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit e_T_OnFilterScriptInit
#else
    public OnGameModeInit() {
    	for(new i; i<sizeof(A::S); i++) A::S[i][A::flag] = -1;
		return CallLocalFunction("e_T_OnGameModeInit","");
	}
	#if defined _ALS_OnGameModeInit
	    #undef OnGameModeInit
	#else
	    #define _ALS_OnGameModeInit
	#endif
	#define OnGameModeInit e_T_OnGameModeInit
#endif
stock A::f1(const needle) {
	for(new i; i<sizeof(A::S); i++) if(A::S[i][A::flag] == needle && !A::S[i][A::n]) return i;
	return INVALID_TEXT_DRAW;
}
stock A::f2(const needle) {
	for(new i; i<sizeof(A::S); i++) if(A::S[i][A::flag] == needle && A::S[i][A::n]) return i;
	return INVALID_TEXT_DRAW;
}
stock A::GetFree() {
    for(new i; i<sizeof(A::S); i++) if(A::S[i][A::flag] == -1) return i;
	return INVALID_TEXT_DRAW;
}
