#include <openmp>  
#include <YSI_Data\y_iterate>  
#include <streamer> // Para veh?culos din?micos  

#define MAX_VEHICULOS 2000  
#define VEHICULO_RESPAWN_TIME 30000 // 30 segundos (como en el c?digo antiguo)  

enum E_VEHICULO {  
    vehModelo,  
    Float:vehPosX,  
    Float:vehPosY,  
    Float:vehPosZ,  
    Float:vehAngulo,  
    vehColor1,  
    vehColor2,  
    vehID  
};  

static Iterator:Vehiculos<MAX_VEHICULOS>;  
static VehiculoInfo[MAX_VEHICULOS][E_VEHICULO];  

// Callbacks del sistema antiguo adaptados  
public OnGameModeInit() {  
    Iter_Init(Vehiculos);  
    CargarVehiculosDesdeDB(); // Funci?n original adaptada  
    return 1;  
}  

public OnVehicleDeath(vehicleid, killerid) {  
    // Sistema de respawn original mejorado  
    defer RespawnVehiculo(vehicleid);  
    return 1;  
}  

// Comandos originales adaptados  
CMD:crearvehiculo(playerid, params[]) {  
    new modelo, color1, color2;  
    if(sscanf(params, "dD(0)D(0)", modelo, color1, color2))  
        return SendClientMessage(playerid, 0xFF0000FF, "USO: /crearvehiculo [modelo] [color1] [color2]");  

    new Float:x, Float:y, Float:z, Float:angulo;  
    GetPlayerPos(playerid, x, y, z);  
    GetPlayerFacingAngle(playerid, angulo);  

    new vid = CrearVehiculo(modelo, x, y, z, angulo, color1, color2);  
    SendClientMessage(playerid, 0x00FF00FF, sprintf("Veh?culo creado (ID: %d)", vid));  

    // Guardar en DB (fiel al sistema antiguo pero seguro)  
    GuardarVehiculoEnDB(vid);  
    return 1;  
}  

// Funciones originales adaptadas  
static CrearVehiculo(modelo, Float:x, Float:y, Float:z, Float:angulo, color1, color2) {  
    new vid = Iter_Alloc(Vehiculos);  

    VehiculoInfo[vid][vehModelo] = modelo;  
    VehiculoInfo[vid][vehPosX] = x;  
    VehiculoInfo[vid][vehPosY] = y;  
    VehiculoInfo[vid][vehPosZ] = z;  
    VehiculoInfo[vid][vehAngulo] = angulo;  
    VehiculoInfo[vid][vehColor1] = color1;  
    VehiculoInfo[vid][vehColor2] = color2;  
    VehiculoInfo[vid][vehID] = CreateDynamicVehicle(modelo, x, y, z, angulo, color1, color2, -1, 0);  

    return vid;  
}  

static GuardarVehiculoEnDB(vid) {  
    new query[512];  
    mysql_format(g_SQL, query, sizeof(query),  
        "INSERT INTO vehiculos (modelo, posx, posy, posz, angulo, color1, color2) \  
        VALUES (%d, %f, %f, %f, %f, %d, %d)",  
        VehiculoInfo[vid][vehModelo],  
        VehiculoInfo[vid][vehPosX],  
        VehiculoInfo[vid][vehPosY],  
        VehiculoInfo[vid][vehPosZ],  
        VehiculoInfo[vid][vehAngulo],  
        VehiculoInfo[vid][vehColor1],  
        VehiculoInfo[vid][vehColor2]  
    );  
    mysql_async_query(g_SQL, query);  
}  

// Sistema de carga inicial desde DB (como en el antiguo)  
static CargarVehiculosDesdeDB() {  
    mysql_async_query(g_SQL, "SELECT * FROM vehiculos", "OnVehiculosCargados");  
}  

public OnVehiculosCargados() {  
    new count;  
    for(new i = 0; i < cache_num_rows(); i++) {  
        new vid = Iter_Alloc(Vehiculos);  

        VehiculoInfo[vid][vehModelo] = cache_get_field_int(i, "modelo");  
        VehiculoInfo[vid][vehPosX] = cache_get_field_float(i, "posx");  
        VehiculoInfo[vid][vehPosY] = cache_get_field_float(i, "posy");  
        VehiculoInfo[vid][vehPosZ] = cache_get_field_float(i, "posz");  
        VehiculoInfo[vid][vehAngulo] = cache_get_field_float(i, "angulo");  
        VehiculoInfo[vid][vehColor1] = cache_get_field_int(i, "color1");  
        VehiculoInfo[vid][vehColor2] = cache_get_field_int(i, "color2");  

        VehiculoInfo[vid][vehID] = CreateDynamicVehicle(  
            VehiculoInfo[vid][vehModelo],  
            VehiculoInfo[vid][vehPosX],  
            VehiculoInfo[vid][vehPosY],  
            VehiculoInfo[vid][vehPosZ],  
            VehiculoInfo[vid][vehAngulo],  
            VehiculoInfo[vid][vehColor1],  
            VehiculoInfo[vid][vehColor2], -1, 0  
        );  

        count++;  
    }  
    printf("Veh?culos cargados: %d", count);  
}  

// Timer de respawn fiel al original  
timer RespawnVehiculo[VEHICULO_RESPAWN_TIME](vehicleid) {  
    new vid = Iter_Get(Vehiculos, vehicleid);  
    if(vid != -1) {  
        SetDynamicVehicleToRespawn(vehicleid);  
        RepairDynamicVehicle(vehicleid);  
    }  
}  

// Comando /misvehiculos original adaptado  
CMD:misvehiculos(playerid) {  
    new count, mensaje[128];  
    foreach(new vid : Vehiculos) {  
        if(EsPropietarioVehiculo(playerid, vid)) { // Implementar esta funci?n seg?n DB  
            count++;  
        }  
    }  
    format(mensaje, sizeof(mensaje), "Tienes %d veh?culos registrados", count);  
    SendClientMessage(playerid, 0x00FF00FF, mensaje);  
    return 1;  
}