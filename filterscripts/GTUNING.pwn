#include <a_samp>

forward Starting();
forward LoadComponents(vehicleid);
forward LoadMods();
forward SaveMods();
forward split(const strsrc[], strdest[][], delimiter);

new VehiclesMod[MAX_VEHICLES][11];

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

public OnFilterScriptInit()
{
    LoadMods();
	Starting();
	return 1;
}

public Starting()
{
    for(new v = 0; v < MAX_VEHICLES; v++)
    {
        LoadComponents(v);
    }
}

public OnVehicleSpawn(vehicleid)
{
    LoadMods();
    LoadComponents(vehicleid);
	return 1;
}

public OnVehicleMod(playerid,vehicleid,componentid)
{

	SaveMods();

	if(VehiclesMod[vehicleid][0] == 0)
	{
	    VehiclesMod[vehicleid][0] = componentid;
	}
	else if(VehiclesMod[vehicleid][1] == 0)
	{
	    VehiclesMod[vehicleid][1] = componentid;
	}
	else if(VehiclesMod[vehicleid][2] == 0)
	{
	    VehiclesMod[vehicleid][2] = componentid;
	}
	else if(VehiclesMod[vehicleid][3] == 0)
	{
	    VehiclesMod[vehicleid][3] = componentid;
	}
	else if(VehiclesMod[vehicleid][4] == 0)
	{
	    VehiclesMod[vehicleid][4] = componentid;
	}
	else if(VehiclesMod[vehicleid][5] == 0)
	{
	    VehiclesMod[vehicleid][5] = componentid;
	}
	else if(VehiclesMod[vehicleid][6] == 0)
	{
	    VehiclesMod[vehicleid][6] = componentid;
	}
	else if(VehiclesMod[vehicleid][7] == 0)
	{
	    VehiclesMod[vehicleid][7] = componentid;
	}
	else if(VehiclesMod[vehicleid][8] == 0)
	{
	    VehiclesMod[vehicleid][8] = componentid;
	}
	else if(VehiclesMod[vehicleid][9] == 0)
	{
	    VehiclesMod[vehicleid][9] = componentid;
	}
	else
	{
		SendClientMessage(playerid,0xFFFFFF96,"[ERROR]: Tus vehículos están llenos de modificaciones.");
	}
    return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    VehiclesMod[vehicleid][10] = paintjobid;
    SaveMods();
	return 1;
}

public LoadComponents(vehicleid)
{
    if(VehiclesMod[vehicleid][0] >= 1000 && VehiclesMod[vehicleid][0] <= 1193)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][0])) != VehiclesMod[vehicleid][0])
        {
            AddVehicleComponent(vehicleid,VehiclesMod[vehicleid][0]);
        }
	}
	if(VehiclesMod[vehicleid][1] >= 1000 && VehiclesMod[vehicleid][1] <= 1193)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][1])) != VehiclesMod[vehicleid][1])
        {
            AddVehicleComponent(vehicleid,VehiclesMod[vehicleid][1]);
        }
	}
	if(VehiclesMod[vehicleid][2] >= 1000 && VehiclesMod[vehicleid][2] <= 1193)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][2])) != VehiclesMod[vehicleid][2])
        {
            AddVehicleComponent(vehicleid,VehiclesMod[vehicleid][2]);
        }
	}
	if(VehiclesMod[vehicleid][3] >= 1000 && VehiclesMod[vehicleid][3] <= 1193)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][3])) != VehiclesMod[vehicleid][3])
        {
            AddVehicleComponent(vehicleid,VehiclesMod[vehicleid][3]);
        }
	}
	if(VehiclesMod[vehicleid][4] >= 1000 && VehiclesMod[vehicleid][4] <= 1193)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][4])) != VehiclesMod[vehicleid][4])
        {
            AddVehicleComponent(vehicleid,VehiclesMod[vehicleid][4]);
        }
	}
	if(VehiclesMod[vehicleid][5] >= 1000 && VehiclesMod[vehicleid][5] <= 1193)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][5])) != VehiclesMod[vehicleid][5])
        {
            AddVehicleComponent(vehicleid,VehiclesMod[vehicleid][5]);
        }
	}
	if(VehiclesMod[vehicleid][6] >= 1000 && VehiclesMod[vehicleid][6] <= 1193)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][6])) != VehiclesMod[vehicleid][6])
        {
            AddVehicleComponent(vehicleid,VehiclesMod[vehicleid][6]);
        }
	}
	if(VehiclesMod[vehicleid][7] >= 1000 && VehiclesMod[vehicleid][7] <= 1193)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][7])) != VehiclesMod[vehicleid][7])
        {
            AddVehicleComponent(vehicleid,VehiclesMod[vehicleid][7]);
        }
	}
	if(VehiclesMod[vehicleid][8] >= 1000 && VehiclesMod[vehicleid][8] <= 1193)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][8])) != VehiclesMod[vehicleid][8])
        {
            AddVehicleComponent(vehicleid,VehiclesMod[vehicleid][8]);
        }
	}
	if(VehiclesMod[vehicleid][9] >= 1000 && VehiclesMod[vehicleid][9] <= 1193)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][9])) != VehiclesMod[vehicleid][9])
        {
            AddVehicleComponent(vehicleid,VehiclesMod[vehicleid][9]);
        }
	}
    if(VehiclesMod[vehicleid][10] > 0)
	{
	    if(GetVehicleComponentInSlot(vehicleid,GetVehicleComponentType(VehiclesMod[vehicleid][10])) != VehiclesMod[vehicleid][10])
        {
	    ChangeVehiclePaintjob(vehicleid,VehiclesMod[vehicleid][10]);
	    }
	}
	return 1;
}
public LoadMods()
{
	new arrCoords[11][64];
	new strFromFile2[256];
	new File: file = fopen("carmods.cfg", io_read);
	if (file)
	{
		new idx;
		while((idx < MAX_VEHICLES))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			VehiclesMod[idx][0] = strval(arrCoords[0]);
		    VehiclesMod[idx][1] = strval(arrCoords[1]);
		    VehiclesMod[idx][2] = strval(arrCoords[2]);
		    VehiclesMod[idx][3] = strval(arrCoords[3]);
		    VehiclesMod[idx][4] = strval(arrCoords[4]);
		    VehiclesMod[idx][5] = strval(arrCoords[5]);
		    VehiclesMod[idx][6] = strval(arrCoords[6]);
		    VehiclesMod[idx][7] = strval(arrCoords[7]);
		    VehiclesMod[idx][8] = strval(arrCoords[8]);
		    VehiclesMod[idx][9] = strval(arrCoords[9]);
		    VehiclesMod[idx][10] = strval(arrCoords[10]);
			idx++;
		}
		fclose(file);
	}
	return 1;
}

public SaveMods()
{
	new idx;
	new File: file2;
	while((idx < MAX_VEHICLES))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d\n",
		VehiclesMod[idx][0],
		VehiclesMod[idx][1],
		VehiclesMod[idx][2],
		VehiclesMod[idx][3],
		VehiclesMod[idx][4],
		VehiclesMod[idx][5],
		VehiclesMod[idx][6],
		VehiclesMod[idx][7],
		VehiclesMod[idx][8],
		VehiclesMod[idx][9],
		VehiclesMod[idx][10]);
		if(idx == 0)
		{
			file2 = fopen("carmods.cfg", io_write);
		}
		else
		{
			file2 = fopen("carmods.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}

stock PointOverString(string[], argument, schar)
{
	new length = strlen(string), arg, result[128], index;
	for (new i = 0; i < length; i++)
	{
		if (string[i] == schar || i == length || string[i + 1] == 10)
		{
			arg++;
			if (arg == argument + 1)
			{
				result[i-index] = EOS;
				return result;
			}
			else if (arg == argument)
			index = i+1;
		}
		else if (arg == argument)
		result[i - index] = string[i];
	}
	return result;
}

public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}
