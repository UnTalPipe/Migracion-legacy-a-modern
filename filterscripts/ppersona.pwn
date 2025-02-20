#include <a_samp>



/*.........Variáveis.........*/
new ObjetoCarro[MAX_VEHICLES];
new VeiculoValido[MAX_VEHICLES];
new NovaCamera[MAX_PLAYERS];
/*...........................*/
public OnFilterScriptExit()
{
    print("[FS] Câmera em 1ª pessoa descarregado••");
        return 1;
}
public OnPlayerConnect(playerid)
{
    SetTimerEx("AttachObject", 5000, 0,"i",playerid);
    return 1;
}

forward AttachObject(playerid);
public AttachObject(playerid)
{
			new carro = GetPlayerVehicleID(playerid);
            if(GetVehicleModel(carro) == 560)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.5, 0.0, 0.0+0.5, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
                if(GetVehicleModel(carro) == 458)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.4, 0.0, 0.0+0.4, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;}
                if(GetVehicleModel(carro) == 490)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.4, 0.0+0.3, 0.0+0.7, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
                if(GetVehicleModel(carro) == 599)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.4, 0.0-0.2, 0.0+0.7, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 596 || GetVehicleModel(carro) == 597 || GetVehicleModel(carro) == 420){
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.5, 0.0-0.1, 0.0+0.5, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 411)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.3, 0.0-0.1, 0.0+0.4, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;}
        if(GetVehicleModel(carro) == 559)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.4, 0.0-0.4, 0.0+0.4, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 442)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.4, 0.0+0.2, 0.0+0.4, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 480)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.4, 0.0-0.4, 0.0+0.5, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 567)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.5, 0.0+0.1, 0.0+0.5, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 462)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.0, 0.0-0.0, 0.0+0.9, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 522 || GetVehicleModel(carro) == 521)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.0, 0.0+0.1, 0.0+1.0, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 463)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.0, 0.0-0.3, 0.0+0.8, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 470)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.6, 0.0-0.2, 0.0+0.7, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 500)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.4, 0.0-0.3, 0.0+0.6, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 431)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.1, 0.0+4.3, 0.0+1.2, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 523 || GetVehicleModel(carro) == 468)
                {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.0, 0.0-0.0, 0.0+0.9, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 562)
            {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.3, 0.0-0.2, 0.0+0.5, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 579)
            {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.5, 0.0-0.4, 0.0+0.8, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 418)
            {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.5, 0.0+0.3, 0.0+0.5, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
                }
        if(GetVehicleModel(carro) == 586)
            {
                        ObjetoCarro[carro] = CreateObject(1927,0.0,0.0,0.0,0.0,0.0,0.0);
                        SetObjectMaterialText(ObjetoCarro[carro], "-",0, OBJECT_MATERIAL_SIZE_256x128, "Arial", 24,1, 0xFFFFFFFF, 0, 0);
                        AttachObjectToVehicle(ObjetoCarro[carro], carro, 0.0-0.0, 0.0-0.2, 0.0+0.9, 0.0, 0.0, 0.0);
                        VeiculoValido[carro] = 1;
         }
        print("[FS] Câmera em 1ª pessoa carregado com sucesso.");
        print("[FS] Feito por ForT/dimmy_••");
        return true;
}
public OnGameModeInit()
{
        print("Aguardando 5 segundos..•");
        return 1;
}

public OnGameModeExit()
{
        for(new _@x = 1; _@x < MAX_VEHICLES; _@x++)
        {
            if(VeiculoValido[_@x] == 1)
            {
                        DestroyObject(ObjetoCarro[_@x]);
                }
        }
        return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    NovaCamera[playerid] = 0;
        return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && newkeys & KEY_YES)
        {
                new carro = GetPlayerVehicleID(playerid);
                       if(NovaCamera[playerid] == 0)
                    {
                        GameTextForPlayer(playerid, "~w~camera~g~ ligada", 5000, 6);
                           AttachCameraToObject(playerid, ObjetoCarro[carro]);
                                NovaCamera[playerid] = 1;
                        }
                    else if(NovaCamera[playerid] == 1)
                    {
                        GameTextForPlayer(playerid, "~w~camera~r~ desligada", 5000, 6);
                SetCameraBehindPlayer(playerid);
                                NovaCamera[playerid] = 0;
                        }
                }
         return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
        if(newstate == PLAYER_STATE_ONFOOT)
        {
            SetCameraBehindPlayer(playerid);
        }
        if(newstate == PLAYER_STATE_DRIVER && VeiculoValido[GetPlayerVehicleID(playerid)] == 1)
        {
            SendClientMessage(playerid, 0xFF0000, "[FS] Você pode ativar a câmera em 1ª pessoa apertando a letra Y.");
        }
        return true;
}
