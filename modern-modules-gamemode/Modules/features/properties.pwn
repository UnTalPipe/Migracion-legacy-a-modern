// modules/features/properties.pwn
#include <openmp>
#include <YSI_Data\y_iterate>
#include <streamer>

#define MAX_PROPIEDADES        500
#define MAX_PROP_NOMBRE        32
#define DISTANCIA_COMPRA       3.0
#define PRECIO_BASE_PROP       100000

enum E_PROP_DATA {
    propID,
    propNombre[MAX_PROP_NOMBRE],
    propPrecio,
    propDue?o[MAX_PLAYER_NAME],
    Float:propEntradaX,
    Float:propEntradaY,
    Float:propEntradaZ,
    propInterior,
    propWorld,
    propCerrada,
    propPickup,
    Text3D:propText
};
static PropertyData[MAX_PROPIEDADES][E_PROP_DATA];
static Iterator:Props<MAX_PROPIEDADES>;

public OnGameModeInit() {
    Iter_Init(Props);
    CargarTodasPropiedades(); // Funci?n original adaptada
    return 1;
}

stock CargarTodasPropiedades() {
    mysql_async_query(g_SQL, "SELECT * FROM propiedades", "OnPropiedadesCargadas");
}

public OnPropiedadesCargadas() {
    new count;
    if(cache_num_rows()) {
        for(new i = 0; i < cache_num_rows(); i++) {
            new idx = Iter_Alloc(Props);
            
            cache_get_field_content(i, "nombre", PropertyData[idx][propNombre], MAX_PROP_NOMBRE);
            PropertyData[idx][propPrecio] = cache_get_field_int(i, "precio");
            cache_get_field_content(i, "due?o", PropertyData[idx][propDue?o], MAX_PLAYER_NAME);
            PropertyData[idx][propEntradaX] = cache_get_field_float(i, "entrada_x");
            PropertyData[idx][propEntradaY] = cache_get_field_float(i, "entrada_y");
            PropertyData[idx][propEntradaZ] = cache_get_field_float(i, "entrada_z");
            PropertyData[idx][propInterior] = cache_get_field_int(i, "interior");
            PropertyData[idx][propWorld] = cache_get_field_int(i, "world");
            PropertyData[idx][propCerrada] = cache_get_field_int(i, "cerrada");

            ActualizarPropiedadEnMapa(idx);
            count++;
        }
    }
    printf("[PROPIEDADES] Cargadas %d propiedades", count);
}

stock ActualizarPropiedadEnMapa(idx) {
    // Mantener estilo visual original con mejoras de streamer
    if(IsValidDynamicPickup(PropertyData[idx][propPickup])) {
        DestroyDynamicPickup(PropertyData[idx][propPickup]);
    }
    if(IsValidDynamic3DTextLabel(PropertyData[idx][propText])) {
        DestroyDynamic3DTextLabel(PropertyData[idx][propText]);
    }

    new texto[256];
    if(strlen(PropertyData[idx][propDue?o]) > 0) {
        format(texto, sizeof(texto), "[Casa] %s\nDue?o: %s\nPrecio: $%d\nUsa /entrar",
            PropertyData[idx][propNombre], 
            PropertyData[idx][propDue?o], 
            PropertyData[idx][propPrecio]
        );
    } else {
        format(texto, sizeof(texto), "[Casa] %s\nEn Venta!\nPrecio: $%d\nUsa /comprar",
            PropertyData[idx][propNombre], 
            PropertyData[idx][propPrecio]
        );
    }

    PropertyData[idx][propPickup] = CreateDynamicPickup(
        strlen(PropertyData[idx][propDue?o]) > 0 ? 1273 : 1272, // Iconos originales
        1,
        PropertyData[idx][propEntradaX], 
        PropertyData[idx][propEntradaY], 
        PropertyData[idx][propEntradaZ],
        .worldid = PropertyData[idx][propWorld]
    );

    PropertyData[idx][propText] = CreateDynamic3DTextLabel(
        texto,
        0xFFFFFFFF,
        PropertyData[idx][propEntradaX], 
        PropertyData[idx][propEntradaY], 
        PropertyData[idx][propEntradaZ],
        10.0,
        .testlos = 1,
        .worldid = PropertyData[idx][propWorld]
    );
}

// Comandos originales adaptados
CMD:comprar(playerid) {
    new propid = PropiedadCercana(playerid);
    if(propid == -1) return SendClientMessage(playerid, 0xFF0000FF, "No est?s cerca de una propiedad en venta");
    
    if(strlen(PropertyData[propid][propDue?o]) > 0) {
        return SendClientMessage(playerid, 0xFF0000FF, "?Esta propiedad ya tiene due?o!");
    }
    
    if(GetPlayerMoney(playerid) < PropertyData[propid][propPrecio]) {
        return SendClientMessage(playerid, 0xFF0000FF, "No tienes suficiente dinero");
    }

    new nombre[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nombre, MAX_PLAYER_NAME);
    strcpy(PropertyData[propid][propDue?o], nombre, MAX_PLAYER_NAME);
    
    GivePlayerMoney(playerid, -PropertyData[propid][propPrecio]);
    GuardarPropiedad(propid);
    
    new mensaje[128];
    format(mensaje, sizeof(mensaje), "?Has comprado la propiedad '%s' por $%d!", 
        PropertyData[propid][propNombre], 
        PropertyData[propid][propPrecio]
    );
    SendClientMessage(playerid, 0x00FF00FF, mensaje);
    return 1;
}

CMD:mispropiedades(playerid) {
    new count, mensaje[128];
    foreach(new i : Props) {
        if(!strcmp(PropertyData[i][propDue?o], GetPlayerName(playerid), true)) {
            count++;
        }
    }
    format(mensaje, sizeof(mensaje), "Tienes %d propiedades registradas", count);
    SendClientMessage(playerid, 0x00FF00FF, mensaje);
    return 1;
}

// Funci?n original mejorada
stock GuardarPropiedad(idx) {
    new query[1024];
    mysql_format(g_SQL, query, sizeof(query),
        "UPDATE propiedades SET \
            due?o = '%e', \
            cerrada = %d \
        WHERE id = %d",
        PropertyData[idx][propDue?o],
        PropertyData[idx][propCerrada],
        PropertyData[idx][propID]
    );
    mysql_async_query(g_SQL, query);
}

// Sistema de entrada/salida original adaptado
CMD:entrar(playerid) {
    new propid = PropiedadCercana(playerid);
    if(propid == -1) return 0;

    if(strlen(PropertyData[propid][propDue?o]) > 0 && 
       strcmp(PropertyData[propid][propDue?o], GetPlayerName(playerid), true) != 0) {
        return SendClientMessage(playerid, 0xFF0000FF, "?Esta propiedad no es tuya!");
    }

    SetPlayerInterior(playerid, PropertyData[propid][propInterior]);
    SetPlayerVirtualWorld(playerid, PropertyData[propid][propWorld]);
    SetPlayerPos(playerid, PropertyData[propid][propEntradaX], PropertyData[propid][propEntradaY], PropertyData[propid][propEntradaZ]);
    return 1;
}

// Funci?n de ayuda original
stock PropiedadCercana(playerid) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    foreach(new i : Props) {
        if(IsPlayerInRangeOfPoint(playerid, DISTANCIA_COMPRA, 
            PropertyData[i][propEntradaX], 
            PropertyData[i][propEntradaY], 
            PropertyData[i][propEntradaZ])) {
            return i;
        }
    }
    return -1;
}
