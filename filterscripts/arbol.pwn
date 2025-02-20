/*------------------------------------------------------------------------------
                                        Xmas Tree[FS] Created by Killa[DGZ]
This Christmas Tree [FS] Uses Fallout's Object Streamer Created by: Fallout v0.5
Double-O-Icons by Double-O-Seven for file size reduction from 1Mb to 156K?,
and i have no idea what else it does but it seems works better with it!
------------------------------------------------------------------------------*/
#define FILTERSCRIPT

#include <a_samp>
#include <Double-O-Icons> // < dont ask why this is here but leave it

#define GREY 0xAFAFAFAA
#define LIGHTGREEN 0x9ACD32AA
#if defined FILTERSCRIPT

#define F_MAX_OBJECTS   1000
#define UpdateTime      300             //update time in ms (milliseconds).
#define ObjectsToStream 300
#define StreamRange     300.0
#pragma dynamic 30000
#define MAX_XMASTREES 100

forward F_ObjectUpdate(bool:DontCheckDistance);
forward F_StartUpdate();

enum XmasTrees
{
        XmasTreeX,
    Float:XmasX,
    Float:XmasY,
    Float:XmasZ,
    XmasObject1,
    XmasObject2,
    XmasObject3,
    XmasObject4,
    XmasObject5,
    XmasObject6,
    XmasObject7,
    XmasObject8,
    XmasObject9,
    XmasObject10,

};
new Treepos[MAX_XMASTREES][XmasTrees];

enum OInfo
{
        ModelID,
        ObjectID[MAX_PLAYERS],
        Float:ox,
        Float:oy,
        Float:oz,
        Float:orox,
        Float:oroy,
        Float:oroz,
        Float:ovdist,
        bool:ObjectCreated[MAX_PLAYERS],
};
new ObjectInfo[F_MAX_OBJECTS][OInfo];
new bool:ObjectUpdatetRunning;
new bool:CantCreateMore;
new bool:RefreshObjects[MAX_PLAYERS];
new Float:OldX[MAX_PLAYERS], Float:OldY[MAX_PLAYERS], Float:OldZ[MAX_PLAYERS];

public OnFilterScriptInit()
{
        print("\n--------------------------------------");
        print("                 Xmas Trees By Killa[DGZ]       ");
        print("--------------------------------------\n");
        return 1;
}

public OnFilterScriptExit()
{
        return 1;
}

public OnPlayerConnect(playerid)
{
        SendClientMessage(playerid, LIGHTGREEN," ");
        SendClientMessage(playerid, GREY,"* {FF0000}M{FFFFFF}E{008000}R{FF0000}R{FFFFFF}Y {008000}X{FF0000}M{FFFFFF}A{008000}S{FFFFFF} *");
        SendClientMessage(playerid, LIGHTGREEN,"*  Type: /xmastreeinfo for more info  *");
        return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
        if (strcmp(cmdtext,"/xmastreeinfo",true) == 0)
        {
        SendClientMessage(playerid, LIGHTGREEN,"                        *   Christmas Trees   *");
        SendClientMessage(playerid, GREY,"*  Type: /xmastree to place a Christmas Tree  *");
        SendClientMessage(playerid, GREY,"*  Type: /delcxmastree to delete the Christmas Tree closest to you  *");
//        SendClientMessage(playerid, GREY,"*  Type: /delallxmastree to delete all Christmas Trees  *");// not unless you want ppl deleting your trees
        SendClientMessage(playerid, GREY,"*  Type: /xmastreecredits for the Filterscript credits  *");
            return 1;
        }
        if (strcmp(cmdtext,"/xmastreecredits",true) == 0)
        {
        SendClientMessage(playerid, LIGHTGREEN,"                        *   Christmas Tree Credits   *");
        SendClientMessage(playerid, GREY,"*  A Special Thanks Out To The To SA-MP Team For The New Objects  *");
        SendClientMessage(playerid, GREY,"*  Christmas Trees[FS] Was Created By Killa[DGZ] 11-12-2010  *");
        SendClientMessage(playerid, GREY,"*  This [FS] uses Fallout's Object Streamer Created by Fallout  *");
        SendClientMessage(playerid, GREY,"*  This [FS] also uses Double-O-Icons by Double-O-Seven  *");
            return 1;
        }
        if(strcmp(cmdtext, "/xmastree", true) == 0)
        {
            new Float:plocx,Float:plocy,Float:plocz;
        GetPlayerPos(playerid, plocx, plocy, plocz);
        SetXmasTree(plocx,plocy,plocz);
                SetPlayerPos(playerid, plocx-2.5, plocy+2.5, plocz);//so you dont get stuck in the presents

            return 1;
        }
        if(strcmp(cmdtext, "/delcxmastree", true) == 0)
        {
                DeleteClosestXmasTree(playerid);
            return 1;
        }
        if(strcmp(cmdtext, "/delallxmastree", true) == 0)
        {
            DeleteAllXmasTree();
            return 1;
        }
        return 0;
}

public F_StartUpdate()
{
    SetTimer("F_ObjectUpdate", UpdateTime, 1);
}

stock F_CreateObject(modelid, Float:x, Float:y, Float:z, Float:rox, Float:roy, Float:roz, Float:vdist=0.0)
{
        if(ObjectUpdatetRunning == false)
        {
            SetTimer("F_StartUpdate", F_MAX_OBJECTS/2, 0);
            ObjectUpdatetRunning = true;
    }

        new objectid;

        if(CantCreateMore == false)
        {
                for(new i; i<F_MAX_OBJECTS; i++)
                {
                    if(i == F_MAX_OBJECTS-1)
                    {
                        printf("Only the first %i objects could be created - object limit exceeded.", F_MAX_OBJECTS);
                                CantCreateMore = true;
                    }
                    if(ObjectInfo[i][ModelID] == 0)
                    {
                        objectid = i;
                        break;
                    }
                }
        }
        else
        {
            return -1;
        }

        if(modelid == 0)
        {
            printf("Invalid modelid for object %i", objectid);
            return -1;
        }

    ObjectInfo[objectid][ModelID] = modelid;
    ObjectInfo[objectid][ox] = x;
    ObjectInfo[objectid][oy] = y;
    ObjectInfo[objectid][oz] = z;
    ObjectInfo[objectid][orox] = rox;
    ObjectInfo[objectid][oroy] = roy;
    ObjectInfo[objectid][oroz] = roz;
    ObjectInfo[objectid][ovdist] = vdist;
        return objectid;
}

stock F_IsValidObject(objectid)
{
        if(ObjectInfo[objectid][ModelID] == 0 || objectid == -1)
        {
            return 0;
        }
        return 1;
}

stock F_DestroyObject(objectid)
{
        if(F_IsValidObject(objectid))
        {
                for(new playerid; playerid<MAX_PLAYERS; playerid++)
                {
                    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid) && ObjectInfo[objectid][ObjectCreated][playerid] == true)
                    {
                                DestroyPlayerObject(playerid, ObjectInfo[objectid][ObjectID][playerid]);
                                ObjectInfo[objectid][ObjectCreated][playerid] = false;
                        }
                }
                ObjectInfo[objectid][ModelID] = 0;
                return 1;
        }
        return 0;
}

stock F_MoveObject(objectid, Float:x, Float:y, Float:z, Float:speed)
{
        if(F_IsValidObject(objectid))
        {
                new time;
                for(new playerid; playerid<MAX_PLAYERS; playerid++)
                {
                    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid) && ObjectInfo[objectid][ObjectCreated][playerid] == true)
                    {
                                time = MovePlayerObject(playerid, ObjectInfo[objectid][ObjectID][playerid], x, y, z, speed);
                        }
                }
                return time;
        }
        return 0;
}

stock F_StopObject(objectid)
{
        if(F_IsValidObject(objectid))
        {
                for(new playerid; playerid<MAX_PLAYERS; playerid++)
                {
                    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid) && ObjectInfo[objectid][ObjectCreated][playerid] == true)
                    {
                        StopPlayerObject(playerid,  ObjectInfo[objectid][ObjectID][playerid]);
                        }
                }
                return 1;
        }
        return 0;
}

stock F_SetObjectPos(objectid, Float:x, Float:y, Float:z)
{
        if(F_IsValidObject(objectid))
        {
            ObjectInfo[objectid][ox] = x;
            ObjectInfo[objectid][oy] = y;
            ObjectInfo[objectid][oz] = z;
                for(new playerid; playerid<MAX_PLAYERS; playerid++)
                {
                    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid) && ObjectInfo[objectid][ObjectCreated][playerid] == true)
                    {
                                SetPlayerObjectPos(playerid, ObjectInfo[objectid][ObjectID][playerid], x, y, z);
                        }
                }
                return 1;
        }
        return 0;
}

stock F_GetObjectPos(objectid, &Float:x, &Float:y, &Float:z)
{
        if(F_IsValidObject(objectid))
        {
            x = ObjectInfo[objectid][ox];
            y = ObjectInfo[objectid][oy];
            z = ObjectInfo[objectid][oz];
            return 1;
        }
        else
        {
                return 0;
        }
}

stock F_SetObjectRot(objectid, Float:rox, Float:roy, Float:roz)
{
        if(F_IsValidObject(objectid))
        {
            ObjectInfo[objectid][orox] = rox;
            ObjectInfo[objectid][oroy] = roy;
            ObjectInfo[objectid][oroz] = roz;
                for(new playerid; playerid<MAX_PLAYERS; playerid++)
                {
                    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid) && ObjectInfo[objectid][ObjectCreated][playerid] == true)
                    {
                                SetPlayerObjectRot(playerid, ObjectInfo[objectid][ObjectID][playerid], rox, roy, roz);
                        }
                }
                return 1;
        }
        return 0;
}

stock F_GetObjectRot(objectid, &Float:rox, &Float:roy, &Float:roz)
{
        if(F_IsValidObject(objectid))
        {
            rox = ObjectInfo[objectid][orox];
            roy = ObjectInfo[objectid][oroy];
            roz = ObjectInfo[objectid][oroz];
            return 1;
        }
        else
        {
                return 0;
        }
}

stock F_RefreshObjects(playerid)
{
        if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
        {
                RefreshObjects[playerid] = true;
                new Float:x, Float:y, Float:z;
                GetPlayerPos(playerid, x, y, z);
                F_PlayerObjectUpdate(playerid, x, y, z);
                return 1;
        }
        return 0;
}

stock F_Streamer_OnPlayerConnect(playerid)
{
        for(new objectid; objectid<F_MAX_OBJECTS; objectid++)
        {
        ObjectInfo[objectid][ObjectCreated][playerid] = false;
        }
        OldX[playerid] = 999999999.99;
        OldY[playerid] = 999999999.99;
        OldZ[playerid] = 999999999.99;
        RefreshObjects[playerid] = false;
        return 1;
}

public F_ObjectUpdate(bool:DontCheckDistance)
{
        new Float:ObjDistance[F_MAX_OBJECTS];
        new Closest[ObjectsToStream];
        new ObjectArr[F_MAX_OBJECTS];
        new nr;
        new bool:Firstloop;
        new bool:DontDestroy[F_MAX_OBJECTS];

        for(new playerid; playerid<MAX_PLAYERS; playerid++)
        {
            if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
            {
                if(!IsPlayerInRangeOfPoint(playerid, 1.0, OldX[playerid], OldY[playerid], OldZ[playerid]) || DontCheckDistance)
                        {
                        GetPlayerPos(playerid, OldX[playerid], OldY[playerid], OldZ[playerid]);

                                nr = 0;
                        for(new objectid; objectid<F_MAX_OBJECTS; objectid++)
                        {
                            if(F_IsValidObject(objectid))
                            {
                                ObjDistance[objectid] = floatsqroot(floatpower(floatsub(ObjectInfo[objectid][ox],OldX[playerid]),2)+floatpower(floatsub(ObjectInfo[objectid][oy],OldY[playerid]),2)+floatpower(floatsub(ObjectInfo[objectid][oz],OldZ[playerid]),2));
                                                if(floatcmp(ObjDistance[objectid], StreamRange) == -1)
                                                {
                                                    ObjectArr[nr] = objectid;
                                                    nr++;
                                                }
                                        }
                                }

                Closest = "";

                                if(nr > ObjectsToStream)
                                {
                                for(new loop; loop<ObjectsToStream; loop++)
                                {
                                    Firstloop = true;
                                    for(new objectid; objectid<nr; objectid++)
                                    {
                                        if((ObjDistance[ObjectArr[objectid]] != 999999999.99) && ((floatcmp(ObjDistance[ObjectArr[objectid]], ObjDistance[Closest[loop]]) == -1) || Firstloop))
                                        {
                                                Firstloop = false;
                                            Closest[loop] = ObjectArr[objectid];
                                        }
                                    }
                                    ObjDistance[Closest[loop]] = 999999999.99;
                                }
                                }
                                else
                                {
                                for(new objectid; objectid<nr; objectid++)
                                {
                                                Closest[objectid] = ObjectArr[objectid];
                                }
                                }

                    for(new objectid; objectid<F_MAX_OBJECTS; objectid++) { DontDestroy[objectid] = false; }
                                for(new objectid; objectid<ObjectsToStream && objectid<nr; objectid++)
                                {
                                        DontDestroy[Closest[objectid]] = true;
                                }

                    for(new objectid; objectid<F_MAX_OBJECTS; objectid++)
                    {
                                    if(ObjectInfo[objectid][ObjectCreated][playerid] == true && DontDestroy[objectid] == false)
                                    {
                                        DestroyPlayerObject(playerid, ObjectInfo[objectid][ObjectID][playerid]);
                                                ObjectInfo[objectid][ObjectCreated][playerid] = false;
                                    }
                                }

                                for(new loop; loop<ObjectsToStream && loop<nr; loop++)
                                {
                                    if(ObjectInfo[Closest[loop]][ObjectCreated][playerid] == false)
                                    {
                                                ObjectInfo[Closest[loop]][ObjectID][playerid] = CreatePlayerObject(playerid, ObjectInfo[Closest[loop]][ModelID], ObjectInfo[Closest[loop]][ox], ObjectInfo[Closest[loop]][oy], ObjectInfo[Closest[loop]][oz], ObjectInfo[Closest[loop]][orox], ObjectInfo[Closest[loop]][oroy], ObjectInfo[Closest[loop]][oroz], ObjectInfo[Closest[loop]][ovdist]);
                                                ObjectInfo[Closest[loop]][ObjectCreated][playerid] = true;
                                    }
                                }
                        }
                }
        }
}

stock F_ObjectUpdateForAll()
{
    F_ObjectUpdate(true);
}

stock F_PlayerObjectUpdate(playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
    {
                OldX[playerid] = x;
                OldY[playerid] = y;
                OldZ[playerid] = z;

                new nr;
                new Float:ObjDistance[F_MAX_OBJECTS];
                new ObjectArr[F_MAX_OBJECTS];
        for(new objectid; objectid<F_MAX_OBJECTS; objectid++)
        {
                        if(F_IsValidObject(objectid))
            {
                ObjDistance[objectid] = floatsqroot(floatpower(floatsub(ObjectInfo[objectid][ox],x),2)+floatpower(floatsub(ObjectInfo[objectid][oy],y),2)+floatpower(floatsub(ObjectInfo[objectid][oz],z),2));
                                if(floatcmp(ObjDistance[objectid], StreamRange) == -1)
                                {
                                    ObjectArr[nr] = objectid;
                                    nr++;
                                }
                        }
                }

                new Closest[ObjectsToStream];

                if(nr > ObjectsToStream)
                {
                for(new loop; loop<ObjectsToStream; loop++)
                {
                                new bool:Firstloop = true;
                                for(new objectid; objectid<nr; objectid++)
                                {
                                        if((ObjDistance[ObjectArr[objectid]] != 999999999.99) && ((floatcmp(ObjDistance[ObjectArr[objectid]], ObjDistance[Closest[loop]]) == -1) || Firstloop))
                        {
                                Firstloop = false;
                            Closest[loop] = ObjectArr[objectid];
                        }
                    }
                    ObjDistance[Closest[loop]] = 999999999.99;
                }
                }
                else
                {
                for(new objectid; objectid<nr; objectid++)
                {
                                Closest[objectid] = ObjectArr[objectid];
                }
                }

                new bool:DontDestroy[F_MAX_OBJECTS];
                for(new objectid; objectid<ObjectsToStream && objectid<nr; objectid++)
                {
                        DontDestroy[Closest[objectid]] = true;
                }

                for(new objectid; objectid<F_MAX_OBJECTS; objectid++)
                {
                    if(ObjectInfo[objectid][ObjectCreated][playerid] == true && (DontDestroy[objectid] == false || RefreshObjects[playerid] == true))
                    {
                        DestroyPlayerObject(playerid, ObjectInfo[objectid][ObjectID][playerid]);
                                ObjectInfo[objectid][ObjectCreated][playerid] = false;
                    }
                }
                RefreshObjects[playerid] = false;

                for(new loop; loop<ObjectsToStream && loop<nr; loop++)
                {
                    if(ObjectInfo[Closest[loop]][ObjectCreated][playerid] == false)
                    {
                                ObjectInfo[Closest[loop]][ObjectID][playerid] = CreatePlayerObject(playerid, ObjectInfo[Closest[loop]][ModelID], ObjectInfo[Closest[loop]][ox], ObjectInfo[Closest[loop]][oy], ObjectInfo[Closest[loop]][oz], ObjectInfo[Closest[loop]][orox], ObjectInfo[Closest[loop]][oroy], ObjectInfo[Closest[loop]][oroz], ObjectInfo[Closest[loop]][ovdist]);
                                ObjectInfo[Closest[loop]][ObjectCreated][playerid] = true;
                    }
                }
        }
}
#define SetPlayerPos F_SetPlayerPos
stock F_SetPlayerPos(playerid, Float:x, Float:y, Float:z)
{
        F_PlayerObjectUpdate(playerid, x, y, z);
        SetPlayerPos(playerid, x, y, z);
}

stock SetXmasTree(Float:x,Float:y,Float:z)
{
    for(new i = 0; i < sizeof(Treepos); i++)
        {
            if(Treepos[i][XmasTreeX] == 0)
            {
            Treepos[i][XmasTreeX]=1;
            Treepos[i][XmasX]=x;
            Treepos[i][XmasY]=y;
            Treepos[i][XmasZ]=z;
            Treepos[i][XmasObject1] = F_CreateObject(19076, x, y, z-1.0,0,0,300);//xmas tree
            Treepos[i][XmasObject2] = F_CreateObject(19054, x, y+1.0, z-0.4,0,0,300);//XmasBox1
            Treepos[i][XmasObject3] = F_CreateObject(19058, x+1.0, y, z-0.4,0,0,300);//XmasBox5
            Treepos[i][XmasObject4] = F_CreateObject(19056, x, y-1.0, z-0.4,0,0,300);//XmasBox3
            Treepos[i][XmasObject5] = F_CreateObject(19057, x-1.0, y, z-0.4,0,0,300);//XmasBox4
            Treepos[i][XmasObject6] = F_CreateObject(19058, x-1.5, y+1.5, z-1.0,0,0,300);//XmasBox5
            Treepos[i][XmasObject7] = F_CreateObject(19055, x+1.5, y-1.5, z-1.0,0,0,300);//XmasBox2
            Treepos[i][XmasObject8] = F_CreateObject(19057, x+1.5, y+1.5, z-1.0,0,0,300);//XmasBox4
            Treepos[i][XmasObject9] = F_CreateObject(19054, x-1.5, y-1.5, z-1.0,0,0,300);//XmasBox1
            Treepos[i][XmasObject10] = F_CreateObject(3526, x, y, z-1.0,0,0,300);//Airportlight - for flashing affect
                return 1;
            }
        }
        return 0;
}

stock DeleteAllXmasTree()
{
    for(new i = 0; i < sizeof(Treepos); i++)
        {
            if(Treepos[i][XmasTreeX] == 1)
            {
                Treepos[i][XmasTreeX]=0;
            Treepos[i][XmasX]=0.0;
            Treepos[i][XmasY]=0.0;
            Treepos[i][XmasZ]=0.0;
            F_DestroyObject(Treepos[i][XmasObject1]);
            F_DestroyObject(Treepos[i][XmasObject2]);
            F_DestroyObject(Treepos[i][XmasObject3]);
            F_DestroyObject(Treepos[i][XmasObject4]);
            F_DestroyObject(Treepos[i][XmasObject5]);
            F_DestroyObject(Treepos[i][XmasObject6]);
            F_DestroyObject(Treepos[i][XmasObject7]);
            F_DestroyObject(Treepos[i][XmasObject8]);
            F_DestroyObject(Treepos[i][XmasObject9]);
            F_DestroyObject(Treepos[i][XmasObject10]);
            }
        }
    return 0;
}

stock DeleteClosestXmasTree(playerid)
{
    for(new i = 0; i < sizeof(Treepos); i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, Treepos[i][XmasX], Treepos[i][XmasY], Treepos[i][XmasZ]))
        {
                if(Treepos[i][XmasTreeX] == 1)
            {
                Treepos[i][XmasTreeX]=0;
                Treepos[i][XmasX]=0.0;
                Treepos[i][XmasY]=0.0;
                Treepos[i][XmasZ]=0.0;
                F_DestroyObject(Treepos[i][XmasObject1]);
                F_DestroyObject(Treepos[i][XmasObject2]);
                F_DestroyObject(Treepos[i][XmasObject3]);
                F_DestroyObject(Treepos[i][XmasObject4]);
                F_DestroyObject(Treepos[i][XmasObject5]);
                F_DestroyObject(Treepos[i][XmasObject6]);
                F_DestroyObject(Treepos[i][XmasObject7]);
                F_DestroyObject(Treepos[i][XmasObject8]);
                F_DestroyObject(Treepos[i][XmasObject9]);
                F_DestroyObject(Treepos[i][XmasObject10]);
                return 1;
                }
            }
        }
    return 0;
}
#endif
