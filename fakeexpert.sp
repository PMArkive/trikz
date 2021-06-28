/*GNU GENERAL PUBLIC LICENSE

VERSION 2, JUNE 1991

Copyright (C) 1989, 1991 Free Software Foundation, Inc.
51 Franklin Street, Fith Floor, Boston, MA 02110-1301, USA

Everyone is permitted to copy and distribute verbatim copies
of this license document, but changing it is not allowed.*/

/*GNU GENERAL PUBLIC LICENSE VERSION 3, 29 June 2007
Copyright (C) 2007 Free Software Foundation, Inc. {http://fsf.org/}
Everyone is permitted to copy and distribute verbatim copies
of this license document, but changing it is not allowed.

						Preamble

	The GNU General Public License is a free, copyleft license for
software and other kinds of works.

	The licenses for most software and other practical works are designed
	to take away your freedom to share and change the works. By contrast,
	the GNU General Public license is intended to guarantee your freedom to 
	share and change all versions of a progrm--to make sure it remins free
	software for all its users. We, the Free Software Foundation, use the
	GNU General Public license for most of our software; it applies also to
	any other work released this way by its authors. You can apply it to
	your programs, too.*/
#include <sdktools>
#include <sdkhooks>
//#include <dhooks>

//bool gB_block[MAXPLAYERS + 1]
int gI_partner[MAXPLAYERS + 1]
float gF_vec1[2][3]
float gF_vec2[2][3]
//int gI_beam
//int gI_halo
//#pragma dynamic 3000000 //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-zones.sp#L35
//int gI_trigger
//int gI_entity
//Handle gH_mysql //https://forums.alliedmods.net/archive/index.php/t-260008.html
Database gD_mysql
float gF_TimeStart[MAXPLAYERS + 1]
float gF_Time[MAXPLAYERS + 1]
int gI_hour
int gI_minute
int gI_second
bool gB_state[MAXPLAYERS + 1]
char gS_map[192]
//int gI_zonetype
bool gB_mapfinished[MAXPLAYERS + 1]
bool gB_pass
//bool gB_insideZone[MAXPLAYERS + 1]
bool gB_passzone[MAXPLAYERS + 1]
float gF_vecStart[3]
//bool gB_newpass
//bool gB_runcmd[MAXPLAYERS + 1]
//int gI_other[MAXPLAYERS + 1]
float gF_boostTime[MAXPLAYERS + 1]
//float gF_vecAbs[MAXPLAYERS + 1][3]
//int gI_sky[MAXPLAYERS + 1]
//int gI_frame[MAXPLAYERS + 1]
float gF_fallVelBooster[MAXPLAYERS + 1][3]
float gF_fallVel[MAXPLAYERS + 1][3]
//bool gB_onGround[MAXPLAYERS + 1]
bool gB_readyToStart[MAXPLAYERS + 1]
//float gF_bestTime
//float gF_personalBest[MAXPLAYERS + 1]
//bool gB_trigger[2048 + 1][MAXPLAYERS + 1]

/*bool gB_stateDefaultDisabled[2048 + 1]
bool gB_stateDisabled[MAXPLAYERS + 1][2048 + 1]
float gF_buttonDefaultDelay[2048 + 1]
float gF_buttonReady[MAXPLAYERS + 1][2048 + 1]*/

float gF_vec1cp[11][3]
float gF_vec2cp[11][3]
//int gI_cpCount
bool gB_cp[11][MAXPLAYERS + 1]
bool gB_cpLock[11][MAXPLAYERS + 1]
float gF_TimeCP[11][MAXPLAYERS + 1]
float gF_timeDiffCPWin[11][MAXPLAYERS + 1]
float gF_srCPTime[11][MAXPLAYERS + 1]
//bool gB_CPprint[10]

float gF_haveRecord[MAXPLAYERS + 1]
float gF_ServerRecord

ConVar gCV_steamid //https://wiki.alliedmods.net/ConVars_(SourceMod_Scripting)

int gI_type
int gI_cpnum

bool gB_menuIsOpen[MAXPLAYERS + 1]
bool gB_menuIsTrikz[MAXPLAYERS + 1]

//bool gB_isEndTouchBoost[MAXPLAYERS + 1][2048 + 1]
float gF_vecVelBoostFix[MAXPLAYERS + 1][3]
int gI_boost[MAXPLAYERS + 1]
//float gF_boostTime[MAXPLAYERS + 1]
int gI_skyStep[MAXPLAYERS + 1]
bool gB_bouncedOff[2048 + 1]
bool gB_groundBoost[MAXPLAYERS + 1]
float gF_currentVelBooster[MAXPLAYERS + 1][3]
int gI_flash[MAXPLAYERS + 1]
int gI_skyFrame[MAXPLAYERS + 1]
int gI_entityFlags[MAXPLAYERS + 1]

public Plugin myinfo =
{
	name = "trikz + timer",
	author = "Smesh(Nick Yurevich)",
	description = "Allows to able make trikz more comfortable",
	version = "2.0",
	url = "http://www.sourcemod.net/"
}

public void OnPluginStart()
{
	gCV_steamid = CreateConVar("steamid", "", "Set steamid for control the plugin ex. 120192594. Use status to check your uniqueid, without 'U:1:'.")
	//https://sm.alliedmods.net/new-api/sourcemod/AutoExecConfig
	AutoExecConfig(true)
	//PrintToServer("%i", GetConVarInt(gCV_steamid))
	RegConsoleCmd("sm_t", cmd_trikz)
	RegConsoleCmd("sm_tr", cmd_trikz)
	RegConsoleCmd("sm_tri", cmd_trikz)
	RegConsoleCmd("sm_trik", cmd_trikz)
	RegConsoleCmd("sm_trikz", cmd_trikz)
	RegConsoleCmd("sm_b", cmd_block)
	RegConsoleCmd("sm_bl", cmd_block)
	RegConsoleCmd("sm_blo", cmd_block)
	RegConsoleCmd("sm_bloc", cmd_block)
	RegConsoleCmd("sm_block", cmd_block)
	RegConsoleCmd("sm_p", cmd_partner)
	RegConsoleCmd("sm_pa", cmd_partner)
	RegConsoleCmd("sm_par", cmd_partner)
	RegConsoleCmd("sm_part", cmd_partner)
	RegConsoleCmd("sm_partn", cmd_partner)
	RegConsoleCmd("sm_partne", cmd_partner)
	RegConsoleCmd("sm_partner", cmd_partner)
	for(int i = 1; i <= MaxClients; i++)
		if(IsClientInGame(i))
			OnClientPutInServer(i)
	//RegConsoleCmd("sm_createstart", cmd_createstart)
	//RegConsoleCmd("sm_createend", cmd_createend)
	//RegConsoleCmd("sm_1", cmd_create)
	RegConsoleCmd("sm_vecmins", cmd_vecmins)
	//RegConsoleCmd("sm_2", cmd_vecmins)
	RegConsoleCmd("sm_vecmaxs", cmd_vecmaxs)
	//RegConsoleCmd("sm_3", cmd_vecmaxs)
	//RegConsoleCmd("sm_starttouch", cmd_starttouch)
	//RegConsoleCmd("sm_4", cmd_starttouch)
	//RegConsoleCmd("sm_sum", cmd_sum)
	//RegConsoleCmd("sm_getid", cmd_getid)
	RegConsoleCmd("sm_tptrigger", cmd_tp)
	RegServerCmd("sm_createtable", cmd_createtable)
	RegConsoleCmd("sm_time", cmd_time)
	RegServerCmd("sm_createusertable", cmd_createuser)
	RegServerCmd("sm_createrecordstable", cmd_createrecords)
	//RegServerCmd("sm_setup", cmd_setup)
	RegConsoleCmd("sm_vecminsend", cmd_vecminsend)
	RegConsoleCmd("sm_vecmaxsend", cmd_vecmaxsend)
	RegConsoleCmd("sm_maptier", cmd_maptier)
	//RegServerCmd("sm_manualinsert", cmd_manualinsert)
	//RegConsoleCmd("sm_manualinsert", cmd_manualinsert)
	//RegConsoleCmd("sm_gent", cmd_gent)
	//RegConsoleCmd("sm_vectest", cmd_vectest)
	//RegConsoleCmd("sm_vectest2", cmd_vectest2)
	//RegConsoleCmd("sm_getenginetime", cmd_getenginetime)
	//RegServerCmd("sm_fakerecord", cmd_fakerecord)
	//RegConsoleCmd("sm_testtext", cmd_testtext)
	RegConsoleCmd("sm_cpmins", cmd_cpmins)
	RegConsoleCmd("sm_cpmaxs", cmd_cpmaxs)
	RegConsoleCmd("sm_tp1", cmd_tp1)
	RegServerCmd("sm_manualcp", cmd_manualcp)
	RegConsoleCmd("sm_deleteallcp", cmd_deleteallcp)
	AddCommandListener(listenerf1, "autobuy") //https://sm.alliedmods.net/new-api/console/AddCommandListener
	AddNormalSoundHook(SoundHook)
	AddCommandListener(specchat, "say")
	//Database.Connect(SQLConnect, "fakeexpert")
	/*HookEvent("roundstart", roundstart)
	Handle hGamedata = LoadGameConfigFile("sdktools.games")
	if(hGamedata == null)
	{
		SetFailState("Failed to load \"sdktools.games\" gamedata.")
		delete hGamedata
	}
	int offset = GameConfGetOffset(hGamedata, "AcceptInput")
	if(offset == 0)
	{
		SetFailState("Failed to load \"AcceptInput\", invalid offset.")
		delete hGamedata
	}
	gH_AcceptInput = DHookCreate(offset, HookType_Entity, ReturnType_Bool, ThisPointer_CBaseEntity, AcceptInput)
	DHookAddParam(gH_AcceptInput, HookParamType_CharPtr)
	DHookAddParam(gH_AcceptInput, HookParamType_CBaseEntity)
	DHookAddParam(gH_AcceptInput, HookParamType_CBaseEntity)
	DHookAddParam(gH_AcceptInput, HookParamType_Object, 20, DHookPass_ByVal|DHookPass_ODTOR|DHookPass_OCTOR|DHookPass_OASSIGNOP) //varaint_t is a union of 12 (float[3]) plus two int type params 12 + 8 = 20
	DHookAddParam(gH_AcceptInput, HookParamType_Int)
	//HookEvent("round_start", Event_RoundStart)
	hGamedata = LoadGameConfigFile("collisionhook")
	if(hGamedata == null)
	{
		SetFailState("Failed to load \"collisionhook.txt\" gamedata.")
		delete hGamedata
		delete gH_PassServerEntityFilter
	}
	gH_PassServerEntityFilter = DHookCreateFromConf(hGamedata, "PassServerEntityFilter")
	if(!gH_PassServerEntityFilter)
	{
		SetFailState("Failed to setup detour PassServerEntityFilter.")
		delete hGamedata
		delete gH_PassServerEntityFilter
	}
	if(!DHookEnableDetour(gH_PassServerEntityFilter, false, PassServerEntityFilter))
	{
		SetFailState("Failed to load detour PassServerEntityFilter.")
		delete hGamedata
		delete gH_PassServerEntityFilter
	}
	delete hGamedata
	delete gH_PassServerEntityFilter*/
	//CreateForward("Trikz_OnPartner", ET_Hook, Param_Cell, Param_Cell)
	//CreateForward("Trikz_OnBreakPartner", ET_Hook, Param_Cell, Param_Cell)
	//CreateForward("Trikz_OnStartTimer", ET_Hook, Param_Cell, Param_Cell)
}

/*Action roundstart(Event event, const char[] name, bool dontBoardcast)
{
	int entity = -1
	while((entity = FindEntityByClassname(entity, "func_brush")) != -1)
	{
		DHookEntity(gH_AcceptInput, false, entity)
		SDKHook(entity, SDKHook_SetTransmit, EntityVisibleTransmit)
		if(GetEntProp(entity, Prop_Data, "m_iDisabled") == 0)
		{
			gB_stateDefaultDisabled[entity] = false
		}
		else
		{
			AcceptEntityInput(entity, "Enable")
			gB_stateDefaultDisabled[entity] = true
		}
	}
	while((entity = FindEntityByClassname(entity, "func_wall_toggle")) != -1)
	{
		DHookEntity(gH_AcceptInput, false, entity)
		SDKHook(entity, SDKHook_SetTransmit, EntityVisibleTransmit)
		if(GetEntProp(entity, Prop_Data, "m_spawnflags") == 0)
		{
			gB_stateDefaultDisabled[entity] = false
		}
		else
		{
			AcceptEntityInput(entity, "Toggle")
			gB_stateDefaultDisabled[entity] = true
		}
	}
	while((entity = FindEntityByClassname(entity, "trigger_multiple")) != -1)
	{
		DHookEntity(gH_AcceptInput, false, entity)
		SDKHook(entity, SDKHook_Touch, TouchTrigger)
		if(GetEntProp(entity, Prop_Data, "m_bDisabled") == 0)
		{
			gB_stateDefaultDisabled[entity] = false
		}
		else
		{
			AcceptEntityInput(entity, "Enable")
			gB_stateDefaultDisabled[entity] = true
		}
	}
	while((entity = FindEntityByClassname(entity, "trigger_teleport")) != -1)
	{
		DHookEntity(gH_AcceptInput, false, entity)
		SDKHook(entity, SDKHook_Touch, TouchTrigger)
		if(GetEntProp(entity, Prop_Data, "m_bDisabled") == 0)
		{
			gB_stateDefaultDisabled[entity] = false
		}
		else
		{
			AcceptEntityInput(entity, "Enable")
			gB_stateDefaultDisabled[entity] = true
		}
	}
	while((entity = FindEntityByClassname(entity, "trigger_teleport_relative")) != -1)
	{
		DHookEntity(gH_AcceptInput, false, entity)
		SDKHook(entity, SDKHook_Touch, TouchTrigger)
		if(GetEntProp(entity, Prop_Data, "m_bDisabled") == 0)
		{
			gB_stateDefaultDisabled[entity] = false
		}
		else
		{
			AcceptEntityInput(entity, "Enable")
			gB_stateDefaultDisabled[entity] = true
		}
	}
	while((entity = FindEntityByClassname(entity, "trigger_push")) != -1)
	{
		DHookEntity(gH_AcceptInput, false, entity)
		SDKHook(entity, SDKHook_Touch, TouchTrigger)
		if(GetEntProp(entity, Prop_Data, "m_bDisabled") == 0)
		{
			gB_stateDefaultDisabled[entity] = false
		}
		else
		{
			AcceptEntityInput(entity, "Enable")
			gB_stateDefaultDisabled[entity] = true
		}
	}
	while((entity = FindEntityByClassname(entity, "trigger_gravity")) != -1)
	{
		DHookEntity(gH_AcceptInput, false, entity)
		SDKHook(entity, SDKHook_Touch, TouchTrigger)
		if(GetEntProp(entity, Prop_Data, "m_bDisabled") == 0)
		{
			gB_stateDefaultDisabled[entity] = false
		}
		else
		{
			AcceptEntityInput(entity, "Enable")
			gB_stateDefaultDisabled[entity] = true
		}
	}
	while((entity = FindEntityByClassname(entity, "func_button")) != -1)
	{
		DHookEntity(gH_AcceptInput, false, entity, INVALID_FUNCTION, AcceptInputButton)
		SDKHook(entity, SDKHook_Use, HookButton)
		SDKHook(entity, SDKHook_OnTakeDamage, HookOnTakeDamage);
		gF_buttonDefaultDelay[entity] = GetEntPropFloat(entity, Prop_Data, "m_flWait")
		SetEntPropFloat(entity, Prop_Data, "m_flWait", 0.1)
		if(GetEntProp(entity, Prop_Data, "m_bLocked") == 0)
		{
			gB_stateDefaultDisabled[entity] = false
		}
		else
		{
			gB_stateDefaultDisabled[entity] = true
		}
	}
	for(int i = 1; i <= 2048; i++)
		gB_stateDisabled[0][i] = gB_stateDefaultDisabled[i]
	HookEntityOutput("trigger_multiple", "OnStartTouch", TriggerOutputHook) //make able to work !self
	HookEntityOutput("trigger_teleport", "OnStartTouch", TriggerOutputHook) //make able to work !self
	HookEntityOutput("trigger_teleport_relative", "OnStartTouch", TriggerOutputHook) //make able to work !self
	HookEntityOutput("trigger_push", "OnStartTouch", TriggerOutputHook) //make able to work !self
	HookEntityOutput("trigger_gravity", "OnStartTouch", TriggerOutputHook) //make able to work !self
	HookEntityOutput("trigger_multiple", "OnEndTouch", TriggerOutputHook) //make able to work !self
	HookEntityOutput("trigger_teleport", "OnEndTouch", TriggerOutputHook) //make able to work !self
	HookEntityOutput("trigger_teleport_relative", "OnEndTouch", TriggerOutputHook) //make able to work !self
	HookEntityOutput("trigger_push", "OnEndTouch", TriggerOutputHook) //make able to work !self
	HookEntityOutput("trigger_gravity", "OnEndTouch", TriggerOutputHook) //make able to work !self
}*/

/*Action Trigger(int entity, int other)
{
	if(GetEntProp(entity, Prop_Data, "m_bDisabled"))
		gB_trigger[entity][other] = true
	else
		gB_trigger[entity][other] = false
	if(GetEntProp(entity, Prop_Data, "m_bDisabled"))
		gB_trigger[entity][other] = true
	else
		gB_trigger[entity][other] = false
	return Plugin_Handled
}

Action Button(int entity, int activator, int caller, UseType type, float value)
{
	//if(GetEntProp(entity, Prop
}*/

/*MRESReturn AcceptInput(int pThis, Handle hReturn, Handle hParams)
{
	//if(pThis < 0)
	//	pThis = EntRefToEntIndex(pThis)
	char sInput[32]
	DHookGetParamString(hParams, 1, sInput, 32)
	if(DHookIsNullParam(hParams, 2))
		return MRES_Ignored
	int activator = DHookGetParam(hParams, 2)
	if(1 > activator || activator > MaxClients)
		return MRES_Ignored
	//int caller = DHookGetParam(hParams, 3)
	int partner = Trikz_FindPartner(activator)
	//int outputid = DHookGetParam(hParams, 5)
	if(StrEqual(sInput, "Enable"))
		if(partner != -1)
		{
			gB_stateDisabled[activator][pThis] = false
			gB_stateDisabled[partner][pThis] = false
		}
		else
		{
			gB_stateDisabled[0][pThis] = false
			for(int i = 1; i <= MaxClients; i++)
				if(IsClientInGame(i) && Trikz_FindPartner(i) == -1)
					gB_stateDisabled[i][pThis] = false
		}
	if(StrEqual(sInput, "Disable"))
		if(partner != -1)
		{
			gB_stateDisabled[activator][pThis] = true
			gB_stateDisabled[partner][pThis] = true
		}
		else
		{
			gB_stateDisabled[0][pThis] = true
			for(int i = 1; i <= MaxClients; i++)
				if(IsClientInGame(i) && Trikz_FindPartner(i) == -1)
					gB_stateDisabled[i][pThis] = true
		}
	char sClassname[32]
	char sName[32]
	char sCClassname[32]
	char sCName[32]
	GetEntPropString(pThis, Prop_Data, "m_iClassname", sClassname, 32)
	GetEntPropString(pThis, Prop_Data, "m_iName", sName, 32)
	GetEntPropString(caller, Prop_Data, "m_iClassname", sCClassname, 32)
	GetEntPropString(caller, Prop_Data, "m_iName", sCName, 32)
	PrintToServer("AcceptInput (%s | %s) pThis: %i input: %s activator: %N (%i) caller: %i (%s | %s) outputid: %i", sClassname, sName, pThis, sInput, activator, activator, caller, sCClassname, sCName, outputid)
	DHookSetReturn(hReturn, false)
	return MRES_Supercede
}

MRESReturn AcceptInputButton(int pThis, Handle hReturn, Handle hParams)
{
	//if(pThis < 0)
	//	pThis = EntRefToEntIndex(pThis)
	char sInput[32]
	DHookGetParamString(hParams, 1, sInput, 32)
	if(DHookIsNullParam(hParams, 2))
		return MRES_Ignored
	int activator = DHookGetParam(hParams, 2)
	if(activator < 1)
		return MRES_Ignored
	//int caller = DHookGetParam(hParams, 3)
	int partner = Trikz_FindPartner(activator)
	//int outputid = DHookGetParam(hParams, 5)
	if(StrEqual(sInput, "Unlock"))
		if(partner != -1)
		{
			gB_stateDisabled[activator][pThis] = false
			gB_stateDisabled[partner][pThis] = false
		}
		else
		{
			gB_stateDisabled[0][pThis] = false
			for(int i = 1; i <= MaxClients; i++)
				if(IsClientInGame(i) && Trikz_FindPartner(i) == -1)
					gB_stateDisabled[i][pThis] = false
		}
	if(StrEqual(sInput, "Lock"))
		if(partner != -1)
		{
			gB_stateDisabled[activator][pThis] = true
			gB_stateDisabled[partner][pThis] = true
		}
		else
		{
			gB_stateDisabled[0][pThis] = true
			for(int i = 1; i <= MaxClients; i++)
				if(IsClientInGame(i) && Trikz_FindPartner(i) == -1)
					gB_stateDisabled[i][pThis] = true
		}
	return MRES_Ignored
}

Action TouchTrigger(int entity, int other)
{
	if(0 < other <= MaxClients && gB_stateDisabled[other][entity])
		return Plugin_Handled
	
	
	if(0 < ent2 <= MaxClients && !gB_stateDisabled[ent2][ent1])
		return Plugin_Continue
	char classname[32]
	GetEntPropString(ent2, Prop_Data, "m_iClassname", classname, 32)
	if(StrContains(classname, "projectile") != -1)
	{
		int ent2owner = GetEntPropEnt(ent2, Prop_Send, "m_hOwnerEntity")
		if(0 < ent2owner <= MaxClients && !gB_stateDisabled[ent2owner][ent1])
			return Plugin_Continue
	}
	return Plugin_Continue
}

Action EntityVisibleTransmit(int entity, int client)
{
	if(gB_stateDisabled[client][entity])
		return Plugin_Handled
	return Plugin_Continue
}

Action HookButton(int entity, int activator, int caller, UseType type, float value)
{
	if(0.0 < gF_buttonReady[activator][entity] > GetGameTime())
		return Plugin_Handled
	if(gB_stateDisabled[activator][entity])
		return Plugin_Handled
	gF_buttonReady[activator][entity] = GetGameTime() + gF_buttonDefaultDelay[entity]
	int partner = Trikz_FindPartner(activator)
	if(partner != -1)
		gF_buttonReady[partner][entity] = gF_buttonReady[activator][entity]
	else
		for(int i = 1; i <= MaxClients; i++)
			if(IsClientInGame(i) && Trikz_FindPartner(i) == -1)
				gF_buttonReady[i][entity] = gF_buttonReady[activator][entity]
	if(GetEntProp(entity, Prop_Data, "m_bLocked") == 1)
		AcceptEntityInput(entity, "Unlock")
	return Plugin_Continue
}

Action HookOnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype) 
{
	SetEntPropEnt(victim, Prop_Data, "m_hActivator", attacker)
}

Action TriggerOutputHook(const char[] output, int caller, int activator, float delay)
{
	if(gB_stateDisabled[activator][caller])
		return Plugin_Handled
	return Plugin_Continue
}*/

/*MRESReturn PassServerEntityFilter(Handle hReturn, Handle hParams)
{
	if(DHookIsNullParam(hParams, 1) || DHookIsNullParam(hParams, 2))
		return MRES_Ignored
	int ent1 = DHookGetParam(hParams, 1) //touch reciever
	int ent2 = DHookGetParam(hParams, 2) //touch sender
	Action result
	Call_StartForward(gH_PassServerEntityFilter)
	Call_PushCell(ent1)
	Call_PushCell(ent2)
	Call_Finish(result)
	if(result > Plugin_Continue)
	{
		DHookSetReturn(hReturn, false)
		return MRES_Supercede
	}
	if(0 < ent2 <= MaxClients && !gB_stateDisabled[ent2][ent1])
		return MRES_Ignored
	char classname[32]
	GetEntPropString(ent2, Prop_Data, "m_iClassname", classname, 32)
	if(StrContains(classname, "projectile") != -1)
	{
		int ent2owner = GetEntPropEnt(ent2, Prop_Send, "m_hOwnerEntity")
		if(0 < ent2owner <= MaxClients && !gB_stateDisabled[ent2owner][ent1])
			return MRES_Ignored
	}
	//PrintToServer("ent1 %i, ent2 %i", ent1, ent2)
	DHookSetReturn(hReturn, false)
	return MRES_Supercede
}*/

public void OnMapStart()
{
	//gI_beam = PrecacheModel("materials/sprites/tp_beam001")
	//gI_beam = PrecacheModel("sprites/laserbeam.vmt", true) //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-zones.sp#L657-L658
	//gI_halo = PrecacheModel("sprites/glow01.vmt", true)
	GetCurrentMap(gS_map, 192)
	//gI_cpCount = 0
	Database.Connect(SQLConnect, "fakeexpert")
	//gI_cpCount = 0
	//GetCurrentMap(gS_map, 192)
}

//Action eventJump(Event event, const char[] name, bool dontBroadcast) //dontBroadcast = radit vair neradit.
//{
//}

Action listenerf1(int client, const char[] commnd, int argc) //extremix idea.
{
	//Trikz(client)
	//PrintToServer("autobuy")
}

Action specchat(int client, const char[] command, int argc)
{
	if(MaxClients >= client > 0 && GetClientTeam(client) == 1)
	{
		char sName[MAX_NAME_LENGTH]
		GetClientName(client, sName, MAX_NAME_LENGTH)
		char sChat[256]
		//GetCmdArgString(sChat, 256)
		GetCmdArg(argc, sChat, 256)
		//GetCmdArgs(
		//GetCmdReplySource(
		//PrintToChatAll("%s", sChat)
		PrintToChatAll("(Spectator) %s: %s", sName, sChat) //sourcemod.net arg
		return Plugin_Handled
	}
	return Plugin_Continue
}

//Action cmd_setup(int args)
/*void setup()
{
	char sQuery[512]
	Format(sQuery, 512, "SELECT possition_x, possition_y, possition_z, type, possition_x2, possition_y2, possition_z2 WHERE map = %s", gS_map)
	gD_mysql.Query(SQLSetupZones, sQuery)
}

void SQLSetupZones(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		gF_vec1[0] = results.FetchFloat(0)
		gF_vec1[1] = results.FetchFloat(0)
		gF_vec1[2] = results.FetchFloat(0)
		gI_zonetype = results.FetchInt(0)
		gF_vec2[0] = results.FetchFloat(0)
		gF_vec2[1] = results.FetchFloat(0)
		gF_vec2[2] = results.FetchFloat(0)
	}
	PrintToServer("[%f] [%f] [%f] [%i]", gF_vec1[0], gF_vec1[1], gF_vec1[2], gI_zonetype)
	PrintToServer("[%f] [%f] [%f] [%i]", gF_vec2[0], gF_vec2[1], gF_vec2[2], gI_zonetype)
}*/

public void OnClientPutInServer(int client)
{
	gI_partner[client] = 0
	gI_partner[gI_partner[client]] = 0
	SDKHook(client, SDKHook_SpawnPost, SDKPlayerSpawn)
	SDKHook(client, SDKHook_OnTakeDamage, SDKOnTakeDamage)
	//SDKHook(client, SDKHook_OnTakeDamagePost, SDKOnTakeDamagePost)
	//SDKHook(client, SDKHooks_TakeDamage, SDKHooksTakeDamage)
	SDKHook(client, SDKHook_StartTouch, SDKSkyFix)
	SDKHook(client, SDKHook_PostThinkPost, SDKBoostFix) //idea by tengulawl/scripting/blob/master/boost-fix tengulawl github.com
	char sQuery[512]
	//int steamid = GetSteamAccountID(client)
	//PrintToServer("%i", steamid)
	if(IsClientInGame(client) && gB_pass)
	{
		int steamid = GetSteamAccountID(client)
		//Format(sQuery, 512, "SELECT steamid FROM users WHERE steamid = %i", steamid)
		Format(sQuery, 512, "SELECT * FROM users")
		gD_mysql.Query(SQLAddUser, sQuery, GetClientSerial(client))
		//Format(sQuery, 512, "SELECT MIN(time) FROM records WHERE (playerid = %i OR partnerid = %i) AND map = '%s'", steamid, steamid, gS_map)
		//gD_mysql.Query(SQLGetRecord, sQuery, GetClientSerial(client))
		Format(sQuery, 512, "SELECT MIN(time) FROM records WHERE (playerid = %i OR partnerid = %i) AND map = '%s'", steamid, steamid, gS_map)
		gD_mysql.Query(SQLGetPersonalRecord, sQuery, GetClientSerial(client))
	}
	/*for(int i = 1; i <= 2048; i++)
	{
		gB_stateDisabled[client][i] = gB_stateDisabled[0][i]
		gF_buttonReady[client][i] = 0.0
	}*/
}

//public void OnDissconnectClient(
public void OnClientDisconnect(int client)
{
	//PrintToServer("%i %i", gI_partner[client], gI_partner[gI_partner[client]])
	//gI_partner[client] = 0
	gI_partner[gI_partner[client]] = 0
	gI_partner[client] = 0
	gB_menuIsOpen[client] = false
	//PrintToServer("%i %i", gI_partner[client], gI_partner[gI_partner[client]])
}

void SQLGetServerRecord(Database db, DBResultSet results, const char[] error, any data)
{
	gF_ServerRecord = 0.0
	if(results.FetchRow())
	{
		gF_ServerRecord = results.FetchFloat(0)
	}
}

void SQLGetPersonalRecord(Database db, DBResultSet results, const char[] error, any data)
{
	int client = GetClientFromSerial(data)
	gF_haveRecord[client] = 0.0
	if(results.FetchRow())
	{
		gF_haveRecord[client] = results.FetchFloat(0)
	}
}

/*void SQLGetRecord(Database db, DBResultSet results, const char[] error, any data)
{
	int client = GetClientFromSerial(data)
	if(results.FetchRow())
	{
		float time = results.FetchFloat(0)
		gF_personalBest[client] = time
	}
	else
	{
		//gF_
	}
}*/

/*public void OnClinetConnected(int client)
{
	char sQuery[512]
	int steamid = GetSteamAccountID(client)
	if(IsClientInGame(client) && gB_pass)
	{
		Format(sQuery, 512, "SELECT steamid FROM users WHERE steamid = %i", steamid)
		gD_mysql.Query(SQLAddUser, sQuery, GetClientSerial(client))
	}
}*/

void SQLUpdateUsername(Database db, DBResultSet results, const char[] error, any data)
{
	if(data == 0)
		return
	int client = GetClientFromSerial(data)
	if(client == 0)
		return
	if(IsClientInGame(client))
	{
		char sName[64]
		GetClientName(client, sName, 64)
		char sQuery[512]
		int steamid = GetSteamAccountID(client)
		if(results.FetchRow())
		{
			PrintToServer("%s %i", sName, steamid)
			//Format(sQuery, 512, "SET NAMES 'utf8'; UPDATE users SET username = '%s' WHERE steamid = %i", sName, steamid)
			Format(sQuery, 512, "UPDATE users SET username = '%s' WHERE steamid = %i", sName, steamid)
			//Format(sQuery, 512, "SELECT steamid FROM users WHERE steamid = %i")
			gD_mysql.Query(SQLUpdateUsernameSuccess, sQuery)
		}
		else
		{
			//Format(sQuery, 512, "SET NAMES 'utf8'; INSERT INTO users (username, steamid) VALUES ('%s', %i)", sName, steamid)
			Format(sQuery, 512, "INSERT INTO users (username, steamid) VALUES ('%s', %i)", sName, steamid)
			gD_mysql.Query(SQLUpdateUsernameSuccess, sQuery)
		}
	}
}

void SQLUpdateUsernameSuccess(Database db, DBResultSet results, const char[] error, any data)
{
}

//void Updateusername(int client)
//{
//}

void SQLAddUser(Database db, DBResultSet results, const char[] error, any data)
{
	int client = GetClientFromSerial(data)
	if(client == 0)
		return
	int steamid = GetSteamAccountID(client)
	if(IsClientInGame(client))
	{
		char sName[64]
		GetClientName(client, sName, 64)
		char sQuery[512] //https://forums.alliedmods.net/showthread.php?t=261378
		if(!results.FetchRow())
		{
			//Format(sQuery, 512, "SET NAMES 'utf8'; INSERT INTO users (username, steamid) VALUES ('%s', %i)", sName, steamid)
			Format(sQuery, 512, "INSERT INTO users (username, steamid) VALUES ('%s', %i)", sName, steamid)
			gD_mysql.Query(SQLUserAdded, sQuery)
		}
		else
		{
			//char sName[64]
			//GetClientName(client, sName, 64)
			PrintToServer("%s", sName)
			//Format(sQuery, 512, "SET NAMES 'utf8'; UPDATE users SET username = '%s' WHERE steamid = %i", sName, steamid)
			Format(sQuery, 512, "SELECT steamid FROM users WHERE steamid = %i", steamid)
			gD_mysql.Query(SQLUpdateUsername, sQuery, GetClientSerial(client))
		}
	}
	//gB_newpass = true
}

void SQLUserAdded(Database db, DBResultSet results, const char[] error, any data)
{
	//int steamid = GetSteamAccountID(GetClientFromSerial(data))
	/*int client = GetClientFromSerial(data)
	int steamid = GetSteamAccountID(client)
	if(IsClientInGame(client))
	{
		char sName[64]
		GetClientName(client, sName, 64)
		char sQuery[512]
		int steamid = GetSteamAccountID(client)
		Format(sQuery, 512, "UPDATE users SET username = '%s' WHERE steamid = %i", sName, steamid)
		gD_mysql.Query(SQLUpdateUsername, sQuery)
	}*/
}

//void SQLUserAdded2(Database db, DBResultSet results, const char[] error, any data)
//{
//}
bool IsClientValid(int client)
{
	return (client > 0 && client <= MaxClients && IsClientInGame(client))
}
void SDKSkyFix(int client, int other) //client = booster; other = flyer
{
	//if(0 < other <= MaxClients)
		//return
	PrintToServer("SDKSkyFix: %i %i", client, other)
	if(!IsClientValid(other) || gI_entityFlags[other] & FL_ONGROUND || gI_boost[client] || GetGameTime() - gF_boostTime[client] < 0.15)
		return
	//if(0 < other <= MaxClients && 0 < client <= MaxClients)
	{
		/*float vecAbsClient[3]
		GetEntPropVector(client, Prop_Data, "m_vecOrigin", vecAbsClient)
		float vecAbsOther[3]
		GetEntPropVector(other, Prop_Data, "m_vecOrigin", vecAbsOther)
		float vecClientMaxs[3]
		GetEntPropVector(client, Prop_Data, "m_vecMaxs", vecClientMaxs)
		//PrintToServer("delta1: %f %f %f", vecAbsClient[2], vecAbsOther[2], vecClientMaxs[2])
		//PrintToServer("vecMaxs: %f %f %f", vecClientMaxs[0], vecClientMaxs[1], vecClientMaxs[2])
		float delta = vecAbsOther[2] - vecAbsClient[2] - vecClientMaxs[2]
		//SetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", vecAbsOther)
		//PrintToServer("delta: %f", delta)
		//PrintToServer("delta2: %f %f %f", vecAbsClient[2], vecAbsOther[2], vecClientMaxs[2])
		//if(0.0 < delta < 2.0) //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L75
		if(delta > 0.0 && delta < 2.0)
		{
			//PrintToServer("%i %i ..", client, other)
			//PrintToServer("SDKSkyFix")
			float vecAbs[3]
			GetEntPropVector(other, Prop_Data, "m_vecAbsVelocity", vecAbs)
			gF_fallVel[other][0] = vecAbs[0]
			gF_fallVel[other][1] = vecAbs[1]
			vecAbs[2] = FloatAbs(vecAbs[2]) //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L84
			//if(vecAbs[2] > 0.0)
			gF_fallVel[other][2] = vecAbs[2] //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L84
			//https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-hud.sp#L918
			//	gI_sky[other] = 1 //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L121
		}*/
		
		float vecAbsBooster[3]
		GetEntPropVector(client, Prop_Data, "m_vecOrigin", vecAbsBooster)
		float vecAbsFlyer[3]
		GetEntPropVector(other, Prop_Data, "m_vecOrigin", vecAbsFlyer)
		float vecMaxs[3]
		GetEntPropVector(client, Prop_Data, "m_vecMaxs", vecMaxs)
		float delta = vecAbsFlyer[2] - vecAbsBooster[2] - vecMaxs[2] //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L71
		//PrintToServer("delta: %f", delta)
		//if(-62.031250 <= delta <= 62.031250)
		//if(-64.0 <= delta <= -64.0)
		//if(delta)
		//if(vecAbsFlyer[2] >= vecAbsBooster[2] && GetGameTime() - gF_boostTime[other] < 0.15 && gI_skyStep[other] == 0)
		//if(vecAbsFlyer[2] >= vecAbsBooster[2] && gI_skyStep[other] == 0)
		//gI_skyStep[other] 
		if(0.0 <= delta <= 2.0) //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L75
		{
			float getCurrentVel[3]
			GetEntPropVector(other, Prop_Data, "m_vecVelocity", getCurrentVel)
			gF_currentVelBooster[other][2] = getCurrentVel[2]
			if(GetEntityFlags(client) & FL_ONGROUND && GetEntityFlags(other) & FL_ONGROUND)
				gI_skyStep[other] = 0
			//if(GetClientButtons(other) & IN_JUMP && !(GetEntityFlags(other) & IN_DUCK) && !(GetEntityFlags(client) & FL_ONGROUND) && gI_skyStep[other] == 0)
			//if(!(GetEntityFlags(client) & FL_ONGROUND) && !(GetEntityFlags(other) & IN_DUCK) && gI_skyStep[other] == 0 && GetGameTime() - gF_boostTime[other] < 0.15) //gF_boostTime[other] < 0.15 and GetGameTime() is from tengu lawl github.com scripting boost-fix.sp https://www.github.com/tengulawl/scripting/main/blob/boost-fix.sp
			if(!(GetEntityFlags(client) & FL_ONGROUND) && !(GetClientButtons(other) & IN_DUCK) && gI_skyStep[other] == 0)
			{
				//if(GetEntityFlags(client) & IN_JUMP)
				//	PrintToServer("c: %i", GetEntityFlags(client))
				//if(GetEntityFlags(client) & IN_JUMP)
				//	PrintToServer("o: %i", GetEntityFlags(other))
				float vecVelBooster[3]
				GetEntPropVector(client, Prop_Data, "m_vecVelocity", vecVelBooster)
				//gF_fallVelBooster[client][2] = vecVelBooster[2]
				gF_fallVelBooster[other][2] = vecVelBooster[2]
				PrintToServer("vecVelBooster: %f", vecVelBooster[2])
				if(vecVelBooster[2] > 0.0)
				{
					float vecVelFlyer[3]
					GetEntPropVector(other, Prop_Data, "m_vecVelocity", vecVelFlyer)
					gF_fallVel[other][0] = vecVelFlyer[0]
					gF_fallVel[other][1] = vecVelFlyer[1]				
					gF_fallVel[other][2] = FloatAbs(vecVelFlyer[2])
					gI_skyStep[other] = 1
					gI_skyFrame[other] = 1
					//gI_skyBooster[
					//gF_boostTime[client] = GetGameTime()
					//SetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", view_as<float>({0.0, 0.0, 0.0}))
					//PrintToServer("x: %f y: %f z: %f", vecVelFlyer[0], vecVelFlyer[1], vecVelFlyer[2])
					//PrintToServer("%f", delta)
					/*int groundEntity = GetEntPropEnt(other, Prop_Data, "m_hGroundEntity") //Skipper idea. 2020 (2019)
					if(0 < groundEntity <= MaxClients && IsPlayerAlive(groundEntity)) //client - flyer, booster - groundEntity
					{
						//if(++gI_frame[client] >= 5) //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L91
						float fallVel[3]
						fallVel[0] = gF_fallVel[client][0]
						fallVel[1] = gF_fallVel[client][1]
						//fallVel[2] = gF_fallVel[client][2] * 4.0
						//gF_fallVel[client][2] += gF_fallVel[client][2]
						//fallVel[2] = gF_fallVel[client][2] / 4.0
						//fallVel[2] = fallVel[2] += gF_fallVel[client][2]
						//if(gF_fallVel[client][2] < 500.0)
						gF_fallVel[client][2] += 300.0
						//PrintToServer("JumpTime: %f", GetEntPropFloat(client, Prop_Data, "m_flJumpTime")) //https://forums.alliedmods.net/showthread.php?t=249353
						fallVel[2] = gF_fallVel[client][2]
						if(buttons & IN_JUMP)
						{
							if(fallVel[2] > 800.0)
								fallVel[2] = 800.0
							if(fallVel[2] <= 800.0 && !(GetEntityFlags(groundEntity) & FL_ONGROUND) && !(buttons & IN_DUCK))
							{
								if(gB_onGround[client])
								{
									//if(!(GetEntProp(client, Prop_Data, "m_bDucked", 4) > ||  //Log's idea.
									TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, fallVel)
									//PrintToServer("%f", fallVel[2])
								}
								if(groundEntity == 0)
									gB_onGround[client] = false
								if(groundEntity > 0) // expert zone idea.
									gB_onGround[client] = true
							}
						}
					}*/
					
					//float vecVelFlyer[3]
					//GetEntPropVector(client, Prop_Data, "m_vecVelocity", vecVelFlyer)
					//int groundEntity = GetEntPropEnt(client, Prop_Data, "m_hGroundEntity")
					//if(0 < groundEntity <= MaxClients)
					//{
					//	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vecVelFlyer)
					//}
				}
			}
		}
	}
}

void SDKBoostFix(int client)
{
	/*if(gI_boost[client] == 1 || 0 < gI_boost[client] <= 6)
	{
		gI_boost[client]++
		//PrintToChatAll("boost step 1 -> 2")
	}
	if(gI_boost[client] == 7)
	{
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		gI_boost[client] = 8
		//gI_boost[client] = 0
	}*/
	//if(gI_boost[client] == 1)
	//{
	//	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
	//	gI_boost[client] = 2
	//}
	//if(gI_boost[client] == 1 && EntRefToEntIndex(gI_flash[client]) != INVALID_ENT_REFERENCE)
	{
		//float vecZero[3]
		//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vecZero)
		//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		//if(gB_groundBoost[client])
		//	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		//gI_boost[client] = 2
		//gI_skyStep[client] = 0
		//PrintToServer("debug1")
	}
	//if(gI_boost[client] == 1 && EntRefToEntIndex(gI_flash[client]) != INVALID_ENT_REFERENCE && !(GetEntityFlags(client) & FL_ONGROUND))
	if(gI_boost[client] == 1 && EntRefToEntIndex(gI_flash[client]) != INVALID_ENT_REFERENCE)
	{
		if(!gB_groundBoost[client])
		{
			float nullVel[3]
		//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, nullVec)
		//else
			//for(int i = 0; i <= 2; i++)
			nullVel[0] = gF_vecVelBoostFix[client][1]
			nullVel[1] = gF_vecVelBoostFix[client][1]
			nullVel[2] = gF_vecVelBoostFix[client][2] * -1.0
			//nullVel[2] = gF_vecVelBoostFix[client][2] * -1000000000.0
			//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, nullVel)
		//for(int i = 0; i <= 2; i++)
			//gF_vecVelBoostFix[client][i] = 0.0
		}
		gI_boost[client] = 2
		gI_skyStep[client] = 0
		PrintToServer("debug")
		//gI_boost[client] = 2
	}
}

Action cmd_trikz(int client, int args)
{
	//gB_menuIsOpen[client] = true
	Trikz(client)
}

void Trikz(int client)
{
	gB_menuIsOpen[client] = true
	gB_menuIsTrikz[client] = true
	Menu menu = new Menu(trikz_handler, MENU_ACTIONS_ALL) //https://wiki.alliedmods.net/Menus_Step_By_Step_(SourceMod_Scripting)
	menu.SetTitle("Trikz")
	char sDisplay[32]
	//Format(sDisplay, 32, gB_block[client] ? "Block [v]" : "Block [x]")
	Format(sDisplay, 32, GetEntProp(client, Prop_Data, "m_CollisionGroup") == 5 ? "Block [v]" : "Block [x]")
	menu.AddItem("block", sDisplay)
	Format(sDisplay, 32, gI_partner[client] ? "Cancel partnership" : "Select partner")
	menu.AddItem("partner", sDisplay)
	menu.AddItem("restart", "Restart")
	menu.Display(client, 20)
}

int trikz_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
				{
					Block(param1)
					Trikz(param1)
				}
				case 1:
				{
					Partner(param1)
					gB_menuIsOpen[param1] = false
				}
				case 2:
					Restart(param1)
			}
		}
		case MenuAction_Cancel:
		{
			//if(param2 == -2)
			//{
				//char sGetItem[32]
				//menu.GetItem(param2, sGetItem, 32)
				//PrintToServer("sGetItem: %s", sGetItem)
			//}
			//if(param2 == -3 || param2 == -5)
			//{
				//char sItem[32]
				//menu.GetItem(param2, sItem, 32)
				//char sTitle[32]
				//menu.GetTitle(sTitle, 32)
				//PrintToServer("sItem: %s sTitle: %s", sItem, sTitle)
				gB_menuIsOpen[param1] = false //idea from expert zone.
				PrintToServer("Client %d's menu was cancelled. Reason: %d", param1, param2) //https://wiki.alliedmods.net/Menu_API_(SourceMod)
			//}
		}
		case MenuAction_Start:
		{
			PrintToServer("menu start trikz.")
			gB_menuIsOpen[param1] = true
		}
		//case MenuAction_Display:
		//{
			//PrintToServer("menu display trikz.")
			//gB_menuIsOpen[param1] = true
		//}
		//case MenuAction_End:
		//{
			//PrintToServer("Client %d's menu was end. Reason: %d", param1, param2) //https://wiki.alliedmods.net/Menu_API_(SourceMod)
		//}
	}
}

//https://forums.alliedmods.net/showthread.php?t=302374

Action cmd_block(int client, int args)
{
	//if(gB_menuIsOpen[client])
	//{
		//Trikz(client)
		//Block(client)
	//}
	//else
	Block(client)
}

Action Block(int client)
{
	if(GetEntProp(client, Prop_Data, "m_CollisionGroup") == 5)
	{
		SetEntProp(client, Prop_Data, "m_CollisionGroup", 2)
		SetEntityRenderMode(client, RENDER_TRANSALPHA)
		SetEntityRenderColor(client, 255, 255, 255, 100)
		//gB_block[client] = false
		if(gB_menuIsOpen[client])
			Trikz(client)
		PrintToChat(client, "Block disabled.")
		return Plugin_Handled
	}
	if(GetEntProp(client, Prop_Data, "m_CollisionGroup") == 2)
	{
		SetEntProp(client, Prop_Data, "m_CollisionGroup", 5)
		SetEntityRenderMode(client, RENDER_NORMAL)
		//gB_block[client] = true
		if(gB_menuIsOpen[client])
			Trikz(client)
		PrintToChat(client, "Block enabled.")
		return Plugin_Handled
	}
	return Plugin_Continue
}

Action cmd_partner(int client, int args)
{
	Partner(client)
}

void Partner(int client)
{
	if(gI_partner[client] == 0)
	{
		Menu menu = new Menu(partner_handler)
		menu.SetTitle("Choose partner")
		char sName[MAX_NAME_LENGTH]
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && IsPlayerAlive(i) && !IsFakeClient(i) && client != i) //https://github.com/Figawe2/trikz-plugin/blob/master/scripting/trikz.sp#L635
			{
				GetClientName(i, sName, MAX_NAME_LENGTH)
				char sNameID[32]
				IntToString(i, sNameID, 32)
				menu.AddItem(sNameID, sName)
			}
		}
		menu.Display(client, 20)
	}
	else
	{
		Menu menu = new Menu(cancelpartner_handler)
		menu.SetTitle("Cancel partnership with %N", gI_partner[client])
		char sName[MAX_NAME_LENGTH]
		GetClientName(gI_partner[client], sName, MAX_NAME_LENGTH)
		char sPartner[32]
		IntToString(gI_partner[client], sPartner, 32)
		menu.AddItem(sPartner, "Yes")
		menu.AddItem("", "No")
		menu.Display(client, 20)
	}
}

int partner_handler(Menu menu, MenuAction action, int param1, int param2) //param1 = client; param2 = server -> partner
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sItem[32]
			menu.GetItem(param2, sItem, 32)
			int partner = StringToInt(sItem)
			Menu menu2 = new Menu(askpartner_handle)
			menu2.SetTitle("Agree partner with %N?", param1)
			char sParam1[32]
			IntToString(param1, sParam1, 32)
			menu2.AddItem(sParam1, "Yes")
			menu2.AddItem(sItem, "No")
			menu2.Display(partner, 20)
		}
	}
}

int askpartner_handle(Menu menu, MenuAction action, int param1, int param2) //param1 = client; param2 = server -> partner
{
	switch(action)
	{
		case MenuAction_Select:
		{
			//int param2x = param2
			char sItem[32]
			menu.GetItem(param2, sItem, 32)
			int partner = StringToInt(sItem)
			switch(param2)
			{
				case 0:
				{
					if(gI_partner[partner] == 0)
					{
						//PrintToServer("%i %N, %i %N", param1, param1, param2x, param2x)
						gI_partner[param1] = partner
						gI_partner[partner] = param1
						//PrintToServer("p1: %i %N p2: %i %N", partner, partner, param1, param1)
						PrintToChat(param1, "Partnersheep agreed with %N.", partner)
						PrintToChat(partner, "You have %N as partner.", param1)
						//Reseta
						Restart(param1)
						Restart(partner) //Expert-Zone idea.
						PrintToServer("partner1: %i %N, partner2: %i %N", gI_partner[param1], gI_partner[param1], gI_partner[partner], gI_partner[partner])

						/*for(int i = 1; i <= 2048; i++)
						{
							gB_stateDisabled[param1][i] = gB_stateDefaultDisabled[i]
							gB_stateDisabled[partner][i] = gB_stateDefaultDisabled[i]
							gF_buttonReady[param1][i] = 0.0
							gF_buttonReady[partner][i] = 0.0
						}*/
					}
					else
						PrintToChat(param1, "A player already have a partner.")
				}
				case 1:
				{
					PrintToChat(param1, "Partnersheep declined with %N.", partner)
				}
			}
		}
	}
}

int cancelpartner_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sItem[32]
			menu.GetItem(param2, sItem, 32)
			int partner = StringToInt(sItem)
			switch(param2)
			{
				case 0:
				{
					gI_partner[param1] = 0
					gI_partner[partner] = 0
					PrintToChat(param1, "Partnership is canceled with %N", partner)
					PrintToChat(partner, "Partnership is canceled by %N", param1)

					/*for(int i = 1; i <= 2048; i++)
					{
						gB_stateDisabled[gI_partner[param1]][i] = gB_stateDefaultDisabled[i]
						gB_stateDisabled[gI_partner[partner]][i] = gB_stateDefaultDisabled[i]
						gF_buttonReady[gI_partner[param1]][i] = 0.0
						gF_buttonReady[gI_partner[partner]][i] = 0.0
					}*/
				}
			}
		}
	}
}

void Restart(int client)
{
	if(gI_partner[client] != 0)
	{
		//gB_insideZone[client] = true
		//gB_insideZone[gI_partner[client]] = true
		gB_readyToStart[client] = true
		gB_readyToStart[gI_partner[client]] = true
		gF_Time[client] = 0.0
		gF_Time[gI_partner[client]] = 0.0
		gB_state[client] = false
		gB_state[gI_partner[client]] = false
		float vecVel[3]
		//vecVel[0] = 30.0
		//vecVel[1] = 30.0
		//vecVel[2] = 0.0
		TeleportEntity(client, gF_vecStart, NULL_VECTOR, vecVel)
		TeleportEntity(gI_partner[client], gF_vecStart, NULL_VECTOR, vecVel)
		SetEntProp(client, Prop_Data, "m_CollisionGroup", 2)
		SetEntityRenderMode(client, RENDER_TRANSALPHA)
		SetEntityRenderColor(client, 255, 255, 255, 100)
		SetEntProp(gI_partner[client], Prop_Data, "m_CollisionGroup", 2)
		SetEntityRenderColor(gI_partner[client], 255, 255, 255, 100)
		SetEntityRenderMode(gI_partner[client], RENDER_TRANSALPHA)
		CreateTimer(3.0, Timer_BlockToggle, client)
	}
	else
		PrintToChat(client, "You must have a partner.")
}

Action Timer_BlockToggle(Handle timer, int client)
{
	if(IsValidEntity(client) && IsValidEntity(gI_partner[client]))
	{
		SetEntProp(client, Prop_Data, "m_CollisionGroup", 5)
		SetEntityRenderMode(client, RENDER_NORMAL)
		SetEntProp(gI_partner[client], Prop_Data, "m_CollisionGroup", 5)
		//SetEntityRenderColor(gI_partner[client], 255, 255, 255, 75)
		SetEntityRenderMode(gI_partner[client], RENDER_NORMAL)
	}
	return Plugin_Stop
}

//Action cmd_createstart(int client, int args)
void createstart()
{
	char sTriggerName2[64]
	int index
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_startzone"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_startzone")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2[0][0] + gF_vec1[0][0]) / 2.0
	center[1] = (gF_vec2[0][1] + gF_vec1[0][1]) / 2.0
	center[2] = (gF_vec2[0][2] + gF_vec1[0][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = gF_vec[0]
	//mins[1] = gF_vec[1]
	//mins[2] = gF_vec[2]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0 + 128.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	//mins[0] = FloatAbs(gF_vec1[0] - gF_vec2[0])
	mins[0] = (gF_vec1[0][0] - gF_vec2[0][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//mins[1] = FloatAbs(gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1[0][1] - gF_vec2[0][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0	
	//mins[2] = FloatAbs(gF_vec1[2] - gF_vec2[2])
	//if(mins[
	//mins[2] = mins[2] += 128.0
	//mins[2] = mins[2] += 128.0
	mins[2] = -128.0
	PrintToServer("Mins: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMins", maxs) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", gF_vec1)
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", gF_vec2)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", gF_vec1)
	float maxs[3]
	//maxs[0] = FloatAbs(gF_vec1[0] - gF_vec2[0]) / 2.0
	maxs[0] = (gF_vec1[0][0] - gF_vec2[0][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1[0][1] - gF_vec2[0][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = gF_vec1[0][2] - gF_vec2[0][2]
	if(maxs[2] < 0.0)
		maxs[2] = maxs[2] * -1.0
	//maxs[2] = maxs[2] -= 128.0
	//maxs[2] = maxs[2] -= -128.0
	maxs[2] = 128.0
	PrintToServer("Maxs: %f %f %f", maxs[0], maxs[1], maxs[2])
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins)
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Send, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	SDKHook(entity, SDKHook_EndTouch, SDKEndTouch)
	//PrintToServer("entity start: %i created", entity)
	//return Plugin_Handled
}

Action cmd_tp1(int client, int args)
{
	float maxs[3]
	//maxs[0] = FloatAbs(gF_vec1[0] - gF_vec2[0]) / 2.0
	maxs[0] = gF_vec1[0][0] - gF_vec2[0][0]
	if(maxs[0] > 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = gF_vec1[0][1] - gF_vec2[0][1]
	if(maxs[1] > 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = gF_vec1[0][2] - gF_vec2[0][2]
	if(maxs[2] > 0.0)
		maxs[2] = maxs[2] * -1.0
	//maxs[2] = maxs[2] -= 128.0
	maxs[2] = maxs[2] -= -128.0
	PrintToServer("%f %f %f", maxs[0], maxs[1], maxs[2])
	TeleportEntity(client, maxs, NULL_VECTOR, NULL_VECTOR)
	return Plugin_Handled
}

//Action cmd_createend(int client, int args)
void createend()
{
	char sTriggerName2[64]
	int index
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_endzone"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_endzone")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2[1][0] + gF_vec1[1][0]) / 2
	center[1] = (gF_vec2[1][1] + gF_vec1[1][1]) / 2
	center[2] = (gF_vec2[1][2] + gF_vec1[1][2]) / 2
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1[1][0] - gF_vec2[1][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1[1][1] - gF_vec2[1][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1[1][0] - gF_vec2[1][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1[1][1] - gF_vec2[1][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
	CPSetup()
}

Action cmd_vecmins(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	PrintToServer("%i", GetConVarInt(gCV_steamid))
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	PrintToServer("string: %s", sSteamID)
	//if(steamid == GetConVarInt(gCV_steamid))
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		//float vec[3]
		GetClientAbsOrigin(client, gF_vec1[0])
		//gF_vec1[0][0] = vec[0]
		//gF_vec1[0][1] = vec[1]
		//gF_vec1[0][2] = vec[2]
		PrintToServer("vec1: %f %f %f", gF_vec1[0][0], gF_vec1[0][1], gF_vec1[0][2])
		char sQuery[512]
		args = 0 //https://www.w3schools.com/sql/sql_delete.asp
		gI_type = args
		//gI_zonetype = 0
		//Format(sQuery, 512, "UPDATE zones SET map = '%s', type = '%i', possition_x = '%f', possition_y = '%f', possition_z = '%f' WHERE map = '%s' AND type = '%i';", gS_map, args, gF_vec1[0][0], gF_vec1[0][1], gF_vec1[0][2], gS_map, args)
		//gD_mysql.Query(SQLSetZones, sQuery)
		Format(sQuery, 512, "DELETE FROM zones WHERE map = '%s' AND type = %i", gS_map, args)
		gD_mysql.Query(SQLDeleteZone, sQuery)
		//Format(sQuery, 512, "SELECT
	}
	return Plugin_Handled
}

void SQLDeleteZone(Database db, DBResultSet results, const char[] error, any data)
{
	char sQuery[512]
	//Format(sQuery, 512, "UPDATE zones SET map = '%s', type = '%i', possition_x = '%f', possition_y = '%f', possition_z = '%f' WHERE map = '%s' AND type = '%i';", gS_map, gI_type, gF_vec1[0][0], gF_vec1[0][1], gF_vec1[0][2], gS_map, gI_type)
	Format(sQuery, 512, "INSERT INTO zones (map, type, possition_x, possition_y, possition_z) VALUES ('%s', %i, %f, %f, %f)", gS_map, gI_type, gF_vec1[0][0], gF_vec1[0][1], gF_vec1[0][2])
	gD_mysql.Query(SQLSetZones, sQuery)
}

Action cmd_deleteallcp(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	PrintToServer("%i", GetConVarInt(gCV_steamid))
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	PrintToServer("string: %s", sSteamID)
	//if(steamid == GetConVarInt(gCV_steamid))
	if(StrEqual(sSteamID, sCurrentSteamID)) //https://sm.alliedmods.net/new-api/
	{
		char sQuery[512]
		Format(sQuery, 512, "DELETE FROM cp WHERE map = '%s'", gS_map)
		gD_mysql.Query(SQLDeleteAllCP, sQuery)
	}
}

void SQLDeleteAllCP(Database db, DBResultSet results, const char[] error, any data)
{
}

Action cmd_vecminsend(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	PrintToServer("%i", GetConVarInt(gCV_steamid))
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	PrintToServer("string: %s", sSteamID)
	//if(steamid == GetConVarInt(gCV_steamid))
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		//float vec[3]
		GetClientAbsOrigin(client, gF_vec1[1])
		//gF_vec1[1][0] = vec[0]
		//gF_vec1[1][1] = vec[1]
		//gF_vec1[1][2] = vec[2]
		//PrintToServer("vec1: %f %f %f", gF_vec1[0], gF_vec1[1], gF_vec1[2])
		char sQuery[512]
		args = 1
		gI_type = args
		//Format(sQuery, 512, "UPDATE zones SET map = '%s', type = %i, possition_x = %f, possition_y = %f, possition_z = %f WHERE map = '%s' AND type = %i", gS_map, args, gF_vec1[1][0], gF_vec1[1][1], gF_vec1[1][2], gS_map, args)
		//gD_mysql.Query(SQLSetZones, sQuery)
		Format(sQuery, 512, "DELETE FROM zones WHERE map = '%s' AND type = %i", gS_map, args)
		gD_mysql.Query(SQLDeleteZone2, sQuery)
	}
	return Plugin_Handled
}

void SQLDeleteZone2(Database db, DBResultSet results, const char[] error, any data)
{
	char sQuery[512]
	//Format(sQuery, 512, "UPDATE zones SET map = '%s', type = %i, possition_x = %f, possition_y = %f, possition_z = %f WHERE map = '%s' AND type = %i", gS_map, gI_type, gF_vec1[1][0], gF_vec1[1][1], gF_vec1[1][2], gS_map, gI_type)
	Format(sQuery, 512, "INSERT INTO zones (map, type, possition_x, possition_y, possition_z) VALUES ('%s', %i, %f, %f, %f)", gS_map, gI_type, gF_vec1[1][0], gF_vec1[1][1], gF_vec1[1][2])
	gD_mysql.Query(SQLSetZones, sQuery)
}

Action cmd_maptier(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	PrintToServer("%i", GetConVarInt(gCV_steamid))
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	PrintToServer("string: %s", sSteamID)
	//if(steamid == GetConVarInt(gCV_steamid))
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		char sArgString[512]
		GetCmdArgString(sArgString, 512) //https://www.sourcemod.net/new-api/console/GetCmdArgString
		int tier = StringToInt(sArgString)
		PrintToServer("Args: %i", tier)
		char sQuery[512]
		Format(sQuery, 512, "UPDATE zones SET tier = %i WHERE map = '%s' AND type = 0", tier, gS_map)
		gD_mysql.Query(SQLTier, sQuery)
	}
	return Plugin_Handled
}

void SQLTier(Database db, DBResultSet results, const char[] error, any data)
{
}

void SQLSetZones(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("Zone successfuly updated.")
}

Action cmd_vecmaxs(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	PrintToServer("%i", GetConVarInt(gCV_steamid))
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	PrintToServer("string: %s", sSteamID)
	//if(steamid == GetConVarInt(gCV_steamid))
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		//float vec[3]
		GetClientAbsOrigin(client, gF_vec2[0])
		//gF_vec2[0][0] = vec[0]
		//gF_vec2[0][1] = vec[1]
		//gF_vec2[0][2] = vec[2]
		//PrintToServer("vec2: %f %f %f", gF_vec2[0], gF_vec2[1], gF_vec2[2])
		char sQuery[512]
		args = 0
		gI_type = args
		//PrintToServer("%s", gS_map)
		Format(sQuery, 512, "UPDATE zones SET map = '%s', type = '%i', possition_x2 = '%f', possition_y2 = '%f', possition_z2 = '%f' WHERE map = '%s' AND type = '%i'", gS_map, args, gF_vec2[0][0], gF_vec2[0][1], gF_vec2[0][2], gS_map, args)
		gD_mysql.Query(SQLSetZones, sQuery)
		//Format(sQuery, 512, "DELETE FROM zones WHERE map = '%s' AND type = %i", gS_map, args)
		//gD_mysql.Query(SQLDeleteZone3, sQuery)
	}
	return Plugin_Handled
}

/*void SQLDeleteZone3(Database db, DBResultSet results, const char[] error, any data)
{
	Format(sQuery, 512, "UPDATE zones SET map = '%s', type = '%i', possition_x2 = '%f', possition_y2 = '%f', possition_z2 = '%f' WHERE map = '%s' AND type = '%i'", gS_map, gI_type, gF_vec2[0][0], gF_vec2[0][1], gF_vec2[0][2], gS_map, gI_type)
	gD_mysql.Query(SQLSetZones, sQuery)
}*/

Action cmd_vecmaxsend(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	PrintToServer("%i", GetConVarInt(gCV_steamid))
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	PrintToServer("string: %s", sSteamID)
	//if(steamid == GetConVarInt(gCV_steamid))
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		//float vec[3]
		GetClientAbsOrigin(client, gF_vec2[1])
		//gF_vec2[1][0] = vec[0]
		//gF_vec2[1][1] = vec[1]
		//gF_vec2[1][2] = vec[2]
		//PrintToServer("vec2: %f %f %f", gF_vec2[0], gF_vec2[1], gF_vec2[2])
		char sQuery[512]
		args = 1
		Format(sQuery, 512, "UPDATE zones SET map = '%s', type = %i, possition_x2 = %f, possition_y2 = %f, possition_z2 = %f WHERE map = '%s' AND type = %i", gS_map, args, gF_vec2[1][0], gF_vec2[1][1], gF_vec2[1][2], gS_map, args)
		gD_mysql.Query(SQLSetZones, sQuery)
	}
	return Plugin_Handled
}

Action cmd_cpmins(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	PrintToServer("%i", GetConVarInt(gCV_steamid))
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	PrintToServer("string: %s", sSteamID)
	//if(steamid == GetConVarInt(gCV_steamid))
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		char sCmd[512]
		GetCmdArgString(sCmd, 512)
		int cpnum = StringToInt(sCmd)
		PrintToChat(client, "%i", cpnum)
		GetClientAbsOrigin(client, gF_vec1cp[cpnum])
		char sQuery[512]
		//Format(sQuery, 512, "UPDATE cp SET cpx = %f, cpy = %f, cpz = %f WHERE map = '%s'", sCmd, gF_vec1cp[0], gF_vec1cp[1], gF_vec1cp[2], gS_map)
		gI_cpnum = cpnum
		Format(sQuery, 512, "DELETE FROM cp WHERE cpnum = %i AND map = '%s'", gI_cpnum, gS_map)
		gD_mysql.Query(SQLCPRemove, sQuery)
	}
	return Plugin_Handled
}

void SQLCPRemove(Database db, DBResultSet results, const char[] error, any data)
{
	char sQuery[512]
	Format(sQuery, 512, "INSERT INTO cp (cpnum, cpx, cpy, cpz, map) VALUES (%i, %f, %f, %f, '%s')", gI_cpnum, gF_vec1cp[gI_cpnum][0], gF_vec1cp[gI_cpnum][1], gF_vec1cp[gI_cpnum][2], gS_map)
	gD_mysql.Query(SQLCPUpdate, sQuery)
	PrintToServer("CP is inserted.")
}

Action cmd_cpmaxs(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	PrintToServer("%i", GetConVarInt(gCV_steamid))
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	PrintToServer("string: %s", sSteamID)
	//if(steamid == GetConVarInt(gCV_steamid))
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		char sCmd[512]
		GetCmdArgString(sCmd, 512)
		int cpnum = StringToInt(sCmd)
		GetClientAbsOrigin(client, gF_vec2cp[cpnum])
		char sQuery[512]
		Format(sQuery, 512, "UPDATE cp SET cpx2 = %f, cpy2 = %f, cpz2 = %f WHERE cpnum = %i AND map = '%s'", gF_vec2cp[cpnum][0], gF_vec2cp[cpnum][1], gF_vec2cp[cpnum][2], cpnum, gS_map)
		//Format(sQuery, 512, "INSERT INTO cp (
		gD_mysql.Query(SQLCPUpdate, sQuery)
	}
	return Plugin_Handled
}

void SQLCPUpdate(Database db, DBResultSet results, const char[] error, any data)
{
}
//https://forums.alliedmods.net/showthread.php?t=261378
Action cmd_manualcp(int args)
{
	char sQuery[512]
	Format(sQuery, 512, "CREATE TABLE IF NOT EXISTS `cp` (`id` INT AUTO_INCREMENT, `cpnum` INT, `cpx` FLOAT, `cpy` FLOAT, `cpz` FLOAT, `cpx2` FLOAT, `cpy2` FLOAT, `cpz2` FLOAT, `map` VARCHAR(192),  PRIMARY KEY(id))")
	gD_mysql.Query(SQLCreateCPTable, sQuery)
}

void SQLCreateCPTable(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("CP table successfuly created.")
}

void CPSetup()
{
	for(int i = 1; i <= 10; i++)
	{
		char sQuery[512]
		Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = %i AND map = '%s'", i, gS_map)
		gD_mysql.Query(SQLCPSetup, sQuery, i)
	}
}

void SQLCPSetup(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		/*float cpx = results.FetchFloat(0)
		float cpy = results.FetchFloat(1)
		float cpz = results.FetchFloat(2)
		float cpx2 = results.FetchFloat(3)
		float cpy2 = results.FetchFloat(4)
		float cpz2 = results.FetchFloat(5)*/
		gF_vec1cp[data][0] = results.FetchFloat(0)
		gF_vec1cp[data][1] = results.FetchFloat(1)
		gF_vec1cp[data][2] = results.FetchFloat(2)
		gF_vec2cp[data][0] = results.FetchFloat(3)
		gF_vec2cp[data][1] = results.FetchFloat(4)
		gF_vec2cp[data][2] = results.FetchFloat(5)
		//gI_cpCount++
		//if(gI_cpCount == 1)
		//{
		createcp(data)
		//PrintToServer("123x123cp1")
		//}
		//char sQuery[512]
		//Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = 2 AND map = '%s'", gS_map)
		//gD_mysql.Query(SQLCPSetup2, sQuery)
	}
}

/*void SQLCPSetup2(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		//float cpx = results.FetchFloat(0)
		float cpy = results.FetchFloat(1)
		float cpz = results.FetchFloat(2)
		float cpx2 = results.FetchFloat(3)
		float cpy2 = results.FetchFloat(4)
		float cpz2 = results.FetchFloat(5)
		gF_vec1cp[2][0] = results.FetchFloat(0)
		gF_vec1cp[2][1] = results.FetchFloat(1)
		gF_vec1cp[2][2] = results.FetchFloat(2)
		gF_vec2cp[2][0] = results.FetchFloat(3)
		gF_vec2cp[2][1] = results.FetchFloat(4)
		gF_vec2cp[2][2] = results.FetchFloat(5)
		PrintToServer("SQLCPSetup2: %f %f %f %f %f %f", gF_vec1cp[2][0], gF_vec1cp[2][1], gF_vec1cp[2][2], gF_vec2cp[2][0], gF_vec2cp[2][1], gF_vec2cp[2][2])
		gI_cpCount++
		if(gI_cpCount == 2)
			createcp(2)
		char sQuery[512]
		Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = 3 AND map = '%s'", gS_map)
		gD_mysql.Query(SQLCPSetup3, sQuery)
	}
}

void SQLCPSetup3(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		float cpx = results.FetchFloat(0)
		float cpy = results.FetchFloat(1)
		float cpz = results.FetchFloat(2)
		float cpx2 = results.FetchFloat(3)
		float cpy2 = results.FetchFloat(4)
		float cpz2 = results.FetchFloat(5)
		gF_vec1cp[3][0] = results.FetchFloat(0)
		gF_vec1cp[3][1] = results.FetchFloat(1)
		gF_vec1cp[3][2] = results.FetchFloat(2)
		gF_vec2cp[3][0] = results.FetchFloat(3)
		gF_vec2cp[3][1] = results.FetchFloat(4)
		gF_vec2cp[3][2] = results.FetchFloat(5)
		gI_cpCount++
		if(gI_cpCount == 3)
			createcp(3)
		char sQuery[512]
		Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = 4 AND map = '%s'", gS_map)
		gD_mysql.Query(SQLCPSetup4, sQuery)
	}
}

void SQLCPSetup4(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		float cpx = results.FetchFloat(0)
		float cpy = results.FetchFloat(1)
		float cpz = results.FetchFloat(2)
		float cpx2 = results.FetchFloat(3)
		float cpy2 = results.FetchFloat(4)
		float cpz2 = results.FetchFloat(5)
		gF_vec1cp[4][0] = results.FetchFloat(0)
		gF_vec1cp[4][1] = results.FetchFloat(1)
		gF_vec1cp[4][2] = results.FetchFloat(2)
		gF_vec2cp[4][0] = results.FetchFloat(3)
		gF_vec2cp[4][1] = results.FetchFloat(4)
		gF_vec2cp[4][2] = results.FetchFloat(5)
		gI_cpCount++
		if(gI_cpCount == 4)
			createcp(4)
		char sQuery[512]
		Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = 5 AND map = '%s'", gS_map)
		gD_mysql.Query(SQLCPSetup5, sQuery)
	}
}

void SQLCPSetup5(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		float cpx = results.FetchFloat(0)
		float cpy = results.FetchFloat(1)
		float cpz = results.FetchFloat(2)
		float cpx2 = results.FetchFloat(3)
		float cpy2 = results.FetchFloat(4)
		float cpz2 = results.FetchFloat(5)
		gF_vec1cp[5][0] = results.FetchFloat(0)
		gF_vec1cp[5][1] = results.FetchFloat(1)
		gF_vec1cp[5][2] = results.FetchFloat(2)
		gF_vec2cp[5][0] = results.FetchFloat(3)
		gF_vec2cp[5][1] = results.FetchFloat(4)
		gF_vec2cp[5][2] = results.FetchFloat(5)
		gI_cpCount++
		if(gI_cpCount == 5)
			createcp(5)
		char sQuery[512]
		Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = 6 AND map = '%s'", gS_map)
		gD_mysql.Query(SQLCPSetup6, sQuery)
	}
}

void SQLCPSetup6(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		float cpx = results.FetchFloat(0)
		float cpy = results.FetchFloat(1)
		float cpz = results.FetchFloat(2)
		float cpx2 = results.FetchFloat(3)
		float cpy2 = results.FetchFloat(4)
		float cpz2 = results.FetchFloat(5)
		gF_vec1cp[6][0] = results.FetchFloat(0)
		gF_vec1cp[6][1] = results.FetchFloat(1)
		gF_vec1cp[6][2] = results.FetchFloat(2)
		gF_vec2cp[6][0] = results.FetchFloat(3)
		gF_vec2cp[6][1] = results.FetchFloat(4)
		gF_vec2cp[6][2] = results.FetchFloat(5)
		gI_cpCount++
		if(gI_cpCount == 6)
			createcp(6)
		char sQuery[512]
		Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = 7 AND map = '%s'", gS_map)
		gD_mysql.Query(SQLCPSetup7, sQuery)
	}
}

void SQLCPSetup7(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		float cpx = results.FetchFloat(0)
		float cpy = results.FetchFloat(1)
		float cpz = results.FetchFloat(2)
		float cpx2 = results.FetchFloat(3)
		float cpy2 = results.FetchFloat(4)
		float cpz2 = results.FetchFloat(5)
		gF_vec1cp[7][0] = results.FetchFloat(0)
		gF_vec1cp[7][1] = results.FetchFloat(1)
		gF_vec1cp[7][2] = results.FetchFloat(2)
		gF_vec2cp[7][0] = results.FetchFloat(3)
		gF_vec2cp[7][1] = results.FetchFloat(4)
		gF_vec2cp[7][2] = results.FetchFloat(5)
		gI_cpCount++
		if(gI_cpCount == 7)
			createcp(7)
		char sQuery[512]
		Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = 8 AND map = '%s'", gS_map)
		gD_mysql.Query(SQLCPSetup8, sQuery)
	}
}

void SQLCPSetup8(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		float cpx = results.FetchFloat(0)
		float cpy = results.FetchFloat(1)
		float cpz = results.FetchFloat(2)
		float cpx2 = results.FetchFloat(3)
		float cpy2 = results.FetchFloat(4)
		float cpz2 = results.FetchFloat(5)
		gF_vec1cp[8][0] = results.FetchFloat(0)
		gF_vec1cp[8][1] = results.FetchFloat(1)
		gF_vec1cp[8][2] = results.FetchFloat(2)
		gF_vec2cp[8][0] = results.FetchFloat(3)
		gF_vec2cp[8][1] = results.FetchFloat(4)
		gF_vec2cp[8][2] = results.FetchFloat(5)
		gI_cpCount++
		if(gI_cpCount == 8)
			createcp(8)
		char sQuery[512]
		Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = 9 AND map = '%s'", gS_map)
		gD_mysql.Query(SQLCPSetup9, sQuery)
	}
}

void SQLCPSetup9(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		float cpx = results.FetchFloat(0)
		float cpy = results.FetchFloat(1)
		float cpz = results.FetchFloat(2)
		float cpx2 = results.FetchFloat(3)
		float cpy2 = results.FetchFloat(4)
		float cpz2 = results.FetchFloat(5)
		gF_vec1cp[9][0] = results.FetchFloat(0)
		gF_vec1cp[9][1] = results.FetchFloat(1)
		gF_vec1cp[9][2] = results.FetchFloat(2)
		gF_vec2cp[9][0] = results.FetchFloat(3)
		gF_vec2cp[9][1] = results.FetchFloat(4)
		gF_vec2cp[9][2] = results.FetchFloat(5)
		gI_cpCount++
		if(gI_cpCount == 9)
			createcp(9)
		char sQuery[512]
		Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = 10 AND map = '%s'", gS_map)
		gD_mysql.Query(SQLCPSetup10, sQuery)
	}
}

void SQLCPSetup10(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		float cpx = results.FetchFloat(0)
		float cpy = results.FetchFloat(1)
		float cpz = results.FetchFloat(2)
		float cpx2 = results.FetchFloat(3)
		float cpy2 = results.FetchFloat(4)
		float cpz2 = results.FetchFloat(5)
		gF_vec1cp[10][0] = results.FetchFloat(0)
		gF_vec1cp[10][1] = results.FetchFloat(1)
		gF_vec1cp[10][2] = results.FetchFloat(2)
		gF_vec2cp[10][0] = results.FetchFloat(3)
		gF_vec2cp[10][1] = results.FetchFloat(4)
		gF_vec2cp[10][2] = results.FetchFloat(5)
		gI_cpCount++
		if(gI_cpCount == 10)
			createcp(10)
	}
}*/

/*void createcp1()
{
	char sTriggerName2[64]
	int index
	//int gI_cpCount
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_cp1"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_cp1")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2cp[1][0] + gF_vec1cp[1][0]) / 2.0
	center[1] = (gF_vec2cp[1][1] + gF_vec1cp[1][1]) / 2.0
	center[2] = (gF_vec2cp[1][2] + gF_vec1cp[1][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1cp[1][0] - gF_vec2cp[1][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1cp[1][1] - gF_vec2cp[1][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1cp[1][0] - gF_vec2cp[1][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1cp[1][1] - gF_vec2cp[1][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
}

void createcp2()
{
	char sTriggerName2[64]
	int index
	//int gI_cpCount
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_cp2"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_cp2")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2cp[2][0] + gF_vec1cp[2][0]) / 2.0
	center[1] = (gF_vec2cp[2][1] + gF_vec1cp[2][1]) / 2.0
	center[2] = (gF_vec2cp[2][2] + gF_vec1cp[2][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1cp[2][0] - gF_vec2cp[2][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1cp[2][1] - gF_vec2cp[2][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1cp[2][0] - gF_vec2cp[2][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1cp[2][1] - gF_vec2cp[2][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
}

void createcp3()
{
	char sTriggerName2[64]
	int index
	//int gI_cpCount
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_cp3"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_cp3")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2cp[3][0] + gF_vec1cp[3][0]) / 2.0
	center[1] = (gF_vec2cp[3][1] + gF_vec1cp[3][1]) / 2.0
	center[2] = (gF_vec2cp[3][2] + gF_vec1cp[3][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1cp[3][0] - gF_vec2cp[3][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1cp[3][1] - gF_vec2cp[3][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1cp[3][0] - gF_vec2cp[3][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1cp[3][1] - gF_vec2cp[3][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
}

void createcp4()
{
	char sTriggerName2[64]
	int index
	//int gI_cpCount
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_cp4"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_cp4")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2cp[4][0] + gF_vec1cp[4][0]) / 2.0
	center[1] = (gF_vec2cp[4][1] + gF_vec1cp[4][1]) / 2.0
	center[2] = (gF_vec2cp[4][2] + gF_vec1cp[4][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1cp[4][0] - gF_vec2cp[4][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1cp[4][1] - gF_vec2cp[4][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1cp[4][0] - gF_vec2cp[4][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1cp[4][1] - gF_vec2cp[4][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
}

void createcp5()
{
	char sTriggerName2[64]
	int index
	//int gI_cpCount
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_cp5"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_cp5")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2cp[5][0] + gF_vec1cp[5][0]) / 2.0
	center[1] = (gF_vec2cp[5][1] + gF_vec1cp[5][1]) / 2.0
	center[2] = (gF_vec2cp[5][2] + gF_vec1cp[5][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1cp[5][0] - gF_vec2cp[5][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1cp[5][1] - gF_vec2cp[5][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1cp[5][0] - gF_vec2cp[5][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1cp[5][1] - gF_vec2cp[5][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
}

void createcp6()
{
	char sTriggerName2[64]
	int index
	//int gI_cpCount
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_cp6"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_cp6")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2cp[6][0] + gF_vec1cp[6][0]) / 2.0
	center[1] = (gF_vec2cp[6][1] + gF_vec1cp[6][1]) / 2.0
	center[2] = (gF_vec2cp[6][2] + gF_vec1cp[6][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1cp[6][0] - gF_vec2cp[6][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1cp[6][1] - gF_vec2cp[6][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1cp[6][0] - gF_vec2cp[6][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1cp[6][1] - gF_vec2cp[6][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
}

void createcp7()
{
	char sTriggerName2[64]
	int index
	//int gI_cpCount
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_cp7"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_cp7")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2cp[7][0] + gF_vec1cp[7][0]) / 2.0
	center[1] = (gF_vec2cp[7][1] + gF_vec1cp[7][1]) / 2.0
	center[2] = (gF_vec2cp[7][2] + gF_vec1cp[7][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1cp[7][0] - gF_vec2cp[7][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1cp[7][1] - gF_vec2cp[7][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1cp[7][0] - gF_vec2cp[7][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1cp[7][1] - gF_vec2cp[7][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
}

void createcp8()
{
	char sTriggerName2[64]
	int index
	//int gI_cpCount
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_cp8"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_cp8")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2cp[8][0] + gF_vec1cp[8][0]) / 2.0
	center[1] = (gF_vec2cp[8][1] + gF_vec1cp[8][1]) / 2.0
	center[2] = (gF_vec2cp[8][2] + gF_vec1cp[8][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1cp[8][0] - gF_vec2cp[8][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1cp[8][1] - gF_vec2cp[8][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1cp[8][0] - gF_vec2cp[8][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1cp[8][1] - gF_vec2cp[8][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
}

void createcp9()
{
	char sTriggerName2[64]
	int index
	//int gI_cpCount
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, "fakeexpert_cp9"))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_cp9")
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2cp[9][0] + gF_vec1cp[9][0]) / 2.0
	center[1] = (gF_vec2cp[9][1] + gF_vec1cp[9][1]) / 2.0
	center[2] = (gF_vec2cp[9][2] + gF_vec1cp[9][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1cp[9][0] - gF_vec2cp[9][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1cp[9][1] - gF_vec2cp[9][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1cp[9][0] - gF_vec2cp[9][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1cp[9][1] - gF_vec2cp[9][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
}*/

void createcp(int cpnum)
{
	char sTriggerName[64]
	Format(sTriggerName, 64, "fakeexpert_cp%i", cpnum)
	char sTriggerName2[64]
	int index
	//int gI_cpCount
	while((index = FindEntityByClassname(index, "trigger_multiple")) != -1) //https://forums.alliedmods.net/showthread.php?t=290655
	{
		GetEntPropString(index, Prop_Data, "m_iName", sTriggerName2, 64)
		if(StrEqual(sTriggerName2, sTriggerName))
			return
	}
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", sTriggerName)
	//ActivateEntity(entity)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//SetEntProp(entity, Prop_Send, "m_fEffects", 32)
	//GetEntPropVector(client, Prop_Send, "m_vecOrigin", vec)
	//SetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec)
	float center[3]
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	center[0] = (gF_vec2cp[cpnum][0] + gF_vec1cp[cpnum][0]) / 2.0
	center[1] = (gF_vec2cp[cpnum][1] + gF_vec1cp[cpnum][1]) / 2.0
	center[2] = (gF_vec2cp[cpnum][2] + gF_vec1cp[cpnum][2]) / 2.0
	TeleportEntity(entity, center, NULL_VECTOR, NULL_VECTOR) ////Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//TeleportEntity(client, center, NULL_VECTOR, NULL_VECTOR)
	float mins[3]
	//mins[0] = FloatAbs((gF_vec1[0] - gF_vec2[0]) / 2.0)
	//mins[1] = FloatAbs((gF_vec1[1] - gF_vec2[1]) / 2.0)
	//mins[2] = FloatAbs((gF_vec1[2] - gF_vec2[2]) / 2.0)
	//mins[0] = mins[0] * 2.0
	//mins[0] = -mins[0]
	//mins[1] = mins[1] * 2.0
	//mins[1] = -mins[1]
	//mins[2] = -128.0
	//PrintToServer("mins: %f %f %f", mins[0], mins[1], mins[2])
	mins[0] = (gF_vec1cp[cpnum][0] - gF_vec2cp[cpnum][0]) / 2.0
	if(mins[0] > 0.0)
		mins[0] = mins[0] * -1.0
	//if(mins[1] = gF_vec1[1] - gF_vec2[1])
	mins[1] = (gF_vec1cp[cpnum][1] - gF_vec2cp[cpnum][1]) / 2.0
	if(mins[1] > 0.0)
		mins[1] = mins[1] * -1.0
	mins[2] = -128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	//mins[0] = mins[0] * -1.0
	//mins[1] = mins[1] * -1.0
	//mins[2] = 128.0
	//PrintToServer("maxs: %f %f %f", mins[0], mins[1], mins[2])
	//SetEntPropVector(entity, Prop_Send, "m_vecMaxs", mins)
	float maxs[3]
	maxs[0] = (gF_vec1cp[cpnum][0] - gF_vec2cp[cpnum][0]) / 2.0
	if(maxs[0] < 0.0)
		maxs[0] = maxs[0] * -1.0
	maxs[1] = (gF_vec1cp[cpnum][1] - gF_vec2cp[cpnum][1]) / 2.0
	if(maxs[1] < 0.0)
		maxs[1] = maxs[1] * -1.0
	maxs[2] = 128.0
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMins", maxs)
	//SetEntPropVector(entity, Prop_Data, "m_vecMaxs", mins)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	//PrintToServer("entity end: %i created", entity)
	//return Plugin_Handled
}

/*Action cmd_starttouch(int client, int args)
{
	SDKHook(gI_trigger, SDKHook_StartTouch, SDKStartTouch)
	SDKHook(gI_trigger, SDKHook_EndTouch, SDKEndTouch)
	if(IsValidEntity(gI_trigger) && ActivateEntity(gI_trigger) && DispatchSpawn(gI_trigger))
	{
		PrintToServer("Trigger is valid.")
	}
	return Plugin_Handled
}*/

Action cmd_createuser(int args)
{
	char sQuery[512]
	Format(sQuery, 512, "CREATE TABLE IF NOT EXISTS `users` (`id` INT AUTO_INCREMENT, `username` VARCHAR(64), `steamid` INT, `points` INT, PRIMARY KEY(id))")
	gD_mysql.Query(SQLCreateUserTable, sQuery)
}

void SQLCreateUserTable(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("Successfuly created user table.")
	char sQuery[512]
	Format(sQuery, 512, "INSERT INTO user (points) VALUES (0)")
	gD_mysql.Query(SQLAddFakePoints, sQuery)
}

void SQLAddFakePoints(Database db, DBResultSet results, const char[] error, any data)
{
}

Action cmd_createrecords(int args)
{
	char sQuery[512]
	Format(sQuery, 512, "CREATE TABLE IF NOT EXISTS `records` (`id` INT AUTO_INCREMENT, `playerid` INT, `partnerid` INT, `time` FLOAT, `cp1` FLOAT, `cp2` FLOAT, `cp3` FLOAT, `cp4` FLOAT, `cp5` FLOAT, `cp6` FLOAT, `cp7` FLOAT, `cp8` FLOAT, `cp9` FLOAT, `cp10` FLOAT, `map` VARCHAR(192), `date` INT, PRIMARY KEY(id))")
	gD_mysql.Query(SQLRecordsTable, sQuery)
}

void SQLRecordsTable(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("Successfuly created records table.")
}

/*Action cmd_vectest(int client, int args)
{
	//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, {-6843.03, 4143.97, 1808.03})
	//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, {-7471.97, 3241.55, 1408.03})
	//TeleportEntity(client, {-6843.03, 4143.97, 1808.03}, NULL_VECTOR, NULL_VECTOR)
	//TeleportEntity(client, {-7471.97, 3241.55, 1408.03}, NULL_VECTOR, NULL_VECTOR)
	return Plugin_Handled
}*/

Action SDKEndTouch(int entity, int other)
{
	//gB_insideZone[other] = false
	//gB_insideZone[other] = false
	//char sTrigger[32]
	//GetEntPropString(entity, Prop_Data, "m_iName", sTrigger, 32)
	//if(StrEqual(sTrigger, "fakeexpert_startzone"))
	{
		//PrintToServer("preStart endtouch.")
		//if(gB_insideZone[other] && gB_insideZone[gI_partner[other]])
		if(0 < other <= MaxClients && gB_readyToStart[other])
		{
			gB_state[other] = true
			gB_state[gI_partner[other]] = true
			gB_mapfinished[other] = false
			gB_mapfinished[gI_partner[other]] = false
			gF_TimeStart[other] = GetEngineTime()
			gF_TimeStart[gI_partner[other]] = GetEngineTime()
			//PrintToServer("EndTouch")
			gB_passzone[other] = true
			gB_passzone[gI_partner[other]] = true
			gB_readyToStart[other] = false
			//gB_readyToStart[gI_other[other
			gB_readyToStart[gI_partner[other]] = false
			for(int i = 1; i <= 10; i++)
			{
				gB_cp[i][other] = false
				gB_cp[i][gI_partner[other]] = false
				gB_cpLock[i][other] = false
				gB_cpLock[i][gI_partner[other]] = false
			}
			/*for(int i = 1; i <= 2048; i++)
			{
				gB_stateDisabled[other][i] = gB_stateDefaultDisabled[i]
				gB_stateDisabled[gI_partner[other]][i] = gB_stateDefaultDisabled[i]
				gF_buttonReady[other][i] = 0.0
				gF_buttonReady[gI_partner[other]][i] = 0.0
			}*/
		}
		//gB_insideZone[other] = false
		//gB_insideZone[gI_partner[other]] = false
	}
}

//void SDKStartTouch(int entity, int other)
Action SDKStartTouch(int entity, int other)
{
	//PrintToServer("%i %i", entity, other)
	//if(0 < other <= MaxClients && !gB_state[other])
		//Restart(other)
	if(0 < other <= MaxClients && gB_passzone[other])
	{
		//if(!gB_state[other])
		//	Restart(other)
		//gB_insideZone[other] = true //Expert-Zone idea.
		//gB_passzone[other] = false
		//PrintToServer("%i", other)
		PrintToServer("SDKStartTouch %i %i", entity, other)
		PrintToServer("ifcp1_startTouch")
		char sTrigger[32]
		
		GetEntPropString(entity, Prop_Data, "m_iName", sTrigger, 32)
		//if(StrEqual(strigger
		
		if(StrEqual(sTrigger, "fakeexpert_startzone") && gB_mapfinished[other])
		{
			//gB_readyToStart[other] = true //expert zone idea.
			//gB_readyToStart[gI_partner[other]] = true
		}
		if(StrEqual(sTrigger, "fakeexpert_endzone"))
		{
			gB_mapfinished[other] = true
			gB_passzone[other] = false
			//gB_zonepass[other
			if(gB_mapfinished[other] && gB_mapfinished[gI_partner[other]])
			{
				int hour = RoundToFloor(gF_Time[other])
				hour = (hour / 3600) % 24
				int minute = RoundToFloor(gF_Time[other])
				minute = (minute / 60) % 60
				int second = RoundToFloor(gF_Time[other])
				second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				//PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])
				char sQuery[512]
				//Format(sQuerySR, 512, "SELECT time FROM records WHERE ")
				//Format(sQuery, 512, "INSERT
				//Format(sQuery, 512, "SELECT map FROM records")
				//DataPack dp3.WriteCell(gF_Time[other])
				//DataPack dp3.WriteCell
				//DataPack dp = new DataPack()
				//dp.WriteFloat(gF_Time[other])
				//dp.WriteCell(GetClientSerial(other))
				//gD_mysql.Query(SQLSR, sQuery, dp)
				int playerid = GetSteamAccountID(other)
				int partnerid = GetSteamAccountID(gI_partner[other])
				char sCPnum[32]
				if(gF_ServerRecord > 0.0)
				{
					if(gF_haveRecord[other] > 0.0 && gF_haveRecord[gI_partner[other]] > 0.0)
					{
						if(gF_ServerRecord > gF_Time[other])
						{
							float timeDiff = gF_ServerRecord - gF_Time[other]
							int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
							int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
							int personalSecond = RoundToFloor(gF_Time[other]) % 60
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR -%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(sQuery, 512, "UPDATE records SET time = %f, cp1 = %f, cp2 = %f, cp3 = %f, cp4 = %f, cp5 = %f, cp6 = %f, cp7 = %f, cp8 = %f, cp9 = %f, cp10 = %f, date = %i WHERE ((playerid = %i AND partnerid = %i) OR (partnerid = %i AND playerid = %i)) AND map = '%s'", gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], GetTime(), playerid, partnerid, playerid, partnerid, gS_map)
							gD_mysql.Query(SQLUpdateRecord, sQuery)
							gF_haveRecord[other] = gF_Time[other]
							gF_haveRecord[gI_partner[other]] = gF_Time[other]
						}
						else
						{
							float timeDiff = gF_Time[other] - gF_ServerRecord
							int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
							int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
							int personalSecond = RoundToFloor(gF_Time[other]) % 60
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR +%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(sQuery, 512, "UPDATE records SET time = %f, cp1 = %f, cp2 = %f, cp3 = %f, cp4 = %f, cp5 = %f, cp6 = %f, cp7 = %f, cp8 = %f, cp9 = %f, cp10 = %f, date = %i WHERE ((playerid = %i AND partnerid = %i) OR (partnerid = %i AND playerid = %i)) AND map = '%s'", gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], GetTime(), playerid, partnerid, playerid, partnerid, gS_map)
							gD_mysql.Query(SQLUpdateRecord, sQuery)
							if(gF_haveRecord[other] > gF_Time[other])
								gF_haveRecord[other] = gF_Time[other]
							if(gF_haveRecord[gI_partner[other]] > gF_Time[other])
								gF_haveRecord[gI_partner[other]] = gF_Time[other]
						}
					}
					if(gF_haveRecord[other] == 0.0 || gF_haveRecord[gI_partner[other]] == 0.0)
					{
						//float timeDiff
						if(gF_ServerRecord > gF_Time[other])
						{
							float timeDiff = gF_ServerRecord - gF_Time[other]
							int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
							int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
							int personalSecond = RoundToFloor(gF_Time[other]) % 60
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR -%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(sQuery, 512, "INSERT INTO records (playerid, partnerid, time, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %i, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, partnerid, gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], gS_map, GetTime())
							gD_mysql.Query(SQLInsertRecord, sQuery)
							//if(gF_haveRecord[other] == 0.0)
							gF_haveRecord[other] = gF_Time[other]
							gF_haveRecord[gI_partner[other]] = gF_Time[other]
							//if(gF_haveRecord[gI_partner[other]] == 0.0)
								
						}
						else
						{
							float timeDiff = gF_Time[other] - gF_ServerRecord
							int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
							int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
							int personalSecond = RoundToFloor(gF_Time[other]) % 60
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR +%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(sQuery, 512, "INSERT INTO records (playerid, partnerid, time, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %i, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, partnerid, gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], gS_map, GetTime())
							gD_mysql.Query(SQLInsertRecord, sQuery)
							if(gF_haveRecord[other] == 0.0)
								gF_haveRecord[other] = gF_Time[other]
							if(gF_haveRecord[gI_partner[other]] == 0.0)
								gF_haveRecord[gI_partner[other]] = gF_Time[other]
						}
					}
					/*if(gF_ServerRecord > gF_Time[other] < gF_haveRecord[other])
					{
						float timeDiff = gF_ServerRecord - gF_Time[other]
						int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
						int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
						int personalSecond = RoundToFloor(gF_Time[other]) % 60
						int srHour = (RoundToFloor(timeDiff) / 3600) % 24
						int srMinute = (RoundToFloor(timeDiff) / 60) % 60
						int srSecond = RoundToFloor(timeDiff) % 60
						PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR -%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						Format(sQuery, 512, "UPDATE records SET time = %f, cp1 = %f, cp2 = %f, cp3 = %f, cp4 = %f, cp5 = %f, cp6 = %f, cp7 = %f, cp8 = %f, cp9 = %f, cp10 = %f, date = %i WHERE ((playerid = %i AND partnerid = %i) OR (partnerid = %i AND playerid = %i)) AND map = '%s'", gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], GetTime(), playerid, partnerid, playerid, partnerid, gS_map)
						gD_mysql.Query(SQLUpdateRecord, sQuery)
						if(gF_ServerRecord > gF_Time[other])
							gF_ServerRecord = gF_Time[other]
						if(gF_haveRecord[other] > gF_Time[other])
						{
							gF_haveRecord[other] = gF_Time[other]
							gF_haveRecord[gI_partner[other]] = gF_Time[other]
						}
					}
					if(gF_ServerRecord < gF_Time[other] > gF_haveRecord[other])
					{
						PrintToServer("12348h394")
						//float timeDiff = FloatAbs(srTime - timeClient)
						//PrintToServer("2x2x2: %f", timeDiff)
						//float timeDiff = FloatAbs(timeClient - srTime)
						//float timeDiff = gF_ServerRecord - gF_Time[other]
						float timeDiff = gF_Time[other] - gF_ServerRecord
						int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
						int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
						int personalSecond = RoundToFloor(gF_Time[other]) % 60
						int srHour = (RoundToFloor(timeDiff) / 3600) % 24
						int srMinute = (RoundToFloor(timeDiff) / 60) % 60
						int srSecond = RoundToFloor(timeDiff) % 60
						PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR +%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
					}
					if(gF_ServerRecord < gF_Time[other] < gF_haveRecord[other])
					{
						PrintToServer("12348h394")
						//float timeDiff = FloatAbs(srTime - timeClient)
						//PrintToServer("2x2x2: %f", timeDiff)
						//float timeDiff = FloatAbs(timeClient - srTime)
						//float timeDiff = gF_ServerRecord - gF_Time[other]
						float timeDiff = gF_Time[other] - gF_ServerRecord
						int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
						int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
						int personalSecond = RoundToFloor(gF_Time[other]) % 60
						int srHour = (RoundToFloor(timeDiff) / 3600) % 24
						int srMinute = (RoundToFloor(timeDiff) / 60) % 60
						int srSecond = RoundToFloor(timeDiff) % 60
						PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR +%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						Format(sQuery, 512, "UPDATE records SET time = %f, cp1 = %f, cp2 = %f, cp3 = %f, cp4 = %f, cp5 = %f, cp6 = %f, cp7 = %f, cp8 = %f, cp9 = %f, cp10 = %f, date = %i WHERE ((playerid = %i AND partnerid = %i) OR (partnerid = %i AND playerid = %i)) AND map = '%s'", gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], GetTime(), playerid, partnerid, playerid, partnerid, gS_map)
						gD_mysql.Query(SQLUpdateRecord, sQuery)
						//if(gF_ServerRecord > gF_Time[other])
						//	gF_ServerRecord = gF_Time[other]
						//if(gF_haveRecord[other] > gF_Time[other])
						//{
						if(gF_haveRecord[other] > gF_Time[other])
							gF_haveRecord[other] = gF_Time[other]
						if(gF_haveRecord[gI_partner[other]] > gF_Time[other])
							gF_haveRecord[gI_partner[other]] = gF_Time[other]
						//}
					}
					//if(gF_haveRecord[other] == 0.0 || gF_haveRecord[gI_partner] == 0.0)
					if(gF_ServerRecord > gF_Time[other] && (gF_haveRecord[other] == 0.0 || gF_haveRecord[gI_partner[other]] == 0.0))
					{
						float timeDiff = gF_ServerRecord - gF_Time[other]
						int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
						int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
						int personalSecond = RoundToFloor(gF_Time[other]) % 60
						int srHour = (RoundToFloor(timeDiff) / 3600) % 24
						int srMinute = (RoundToFloor(timeDiff) / 60) % 60
						int srSecond = RoundToFloor(timeDiff) % 60
						PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR -%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						Format(sQuery, 512, "INSERT INTO records (playerid, partnerid, time, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %i, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, partnerid, gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], gS_map, GetTime())
						gD_mysql.Query(SQLInsertRecord, sQuery)
						if(gF_haveRecord[other] == 0.0)
							gF_haveRecord[other] = gF_Time[other]
						if(gF_haveRecord[gI_partner[other]] == 0.0)
							gF_haveRecord[gI_partner[other]] = gF_Time[other]
					}
					//if(gF_ServerRecord < gF_Time[other] && gF_haveRecord[other] == 0.0)
					if(gF_ServerRecord < gF_Time[other] && (gF_haveRecord[other] == 0.0 || gF_haveRecord[gI_partner[other]] == 0.0))
					{
						float timeDiff = gF_Time[other] - gF_ServerRecord
						int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
						int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
						int personalSecond = RoundToFloor(gF_Time[other]) % 60
						int srHour = (RoundToFloor(timeDiff) / 3600) % 24
						int srMinute = (RoundToFloor(timeDiff) / 60) % 60
						int srSecond = RoundToFloor(timeDiff) % 60
						PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR +%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						Format(sQuery, 512, "INSERT INTO records (playerid, partnerid, time, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %i, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, partnerid, gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], gS_map, GetTime())
						gD_mysql.Query(SQLInsertRecord, sQuery)
						if(gF_haveRecord[other] == 0.0)
							gF_haveRecord[other] = gF_Time[other]
						if(gF_haveRecord[gI_partner[other]] == 0.0)
							gF_haveRecord[gI_partner[other]] = gF_Time[other]
					}*/
					/*if(gF_ServerRecord > gF_Time[gI_partner[other]] && gF_haveRecord[gI_partner[other]] == 0.0)
					{
						float timeDiff = gF_ServerRecord - gF_Time[other]
						int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
						int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
						int personalSecond = RoundToFloor(gF_Time[other]) % 60
						int srHour = (RoundToFloor(timeDiff) / 3600) % 24
						int srMinute = (RoundToFloor(timeDiff) / 60) % 60
						int srSecond = RoundToFloor(timeDiff) % 60
						PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR -%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						Format(sQuery, 512, "INSERT INTO records (playerid, partnerid, time, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %i, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, partnerid, gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], gS_map, GetTime())
						gD_mysql.Query(SQLInsertRecord, sQuery)
						gF_haveRecord[gI_partner[other]] = gF_Time[other]
					}
					if(gF_ServerRecord < gF_Time[gI_partner[other]] && gF_haveRecord[gI_partner[other]] == 0.0)
					{
						float timeDiff = gF_ServerRecord - gF_Time[other]
						int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
						int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
						int personalSecond = RoundToFloor(gF_Time[other]) % 60
						int srHour = (RoundToFloor(timeDiff) / 3600) % 24
						int srMinute = (RoundToFloor(timeDiff) / 60) % 60
						int srSecond = RoundToFloor(timeDiff) % 60
						PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR +%02.i:%02.i:%02.i)", other, gI_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						Format(sQuery, 512, "INSERT INTO records (playerid, partnerid, time, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %i, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, partnerid, gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], gS_map, GetTime())
						gD_mysql.Query(SQLInsertRecord, sQuery)
						gF_haveRecord[gI_partner[other]] = gF_Time[other]
					}*/
					for(int i = 1; i <= 10; i++)
					{
						IntToString(i, sCPnum, 32)
						if(gB_cp[i][other])
						{
							if(gF_TimeCP[i][other] < gF_srCPTime[i][other])
							{
								//gF_timeDiffCPWin[i][other] = gF_srCPTime[i][other] - gF_TimeCP[i][other]
								PrintToServer("%f", gF_timeDiffCPWin[i][other])
								//gF_timeDiffCPWin[i][gI_partner[other]] = gF_srCPTime[i][gI_partner[other]] - gF_TimeCP[gI_partner[other]][i]
								//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
								//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
								//int personalSecond = RoundToFloor(timeClient) % 60
								int srCPHour = (RoundToFloor(gF_timeDiffCPWin[i][other]) / 3600) % 24
								int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[i][other]) / 60) % 60
								int srCPSecond = RoundToFloor(gF_timeDiffCPWin[i][other]) % 60
								//IntToString(i, sPlace, 32)
								//PrintToChat(other, "%s. Checkpoint: -%02.i:%02.i:%02.i", sPlace, srCPHour, srCPMinute, srCPSecond)
								PrintToChatAll("%s. Checkpoint: -%02.i:%02.i:%02.i", sCPnum, srCPHour, srCPMinute, srCPSecond)
								//PrintToChat(gI_partner[other], "%s. Checkpoint: -%02.i:%02.i:%02.i", sPlace, srCPHour, srCPMinute, srCPSecond)
							}
							else
							{
								//gF_timeDiffCPWin[i][other] = gF_TimeCP[i][other] - gF_srCPTime[i][other]
								//gF_timeDiffCPWin[i][other] = gF_srCPTime[i][other] - gF_TimeCP[i][other]
								//gF_timeDiffCPWin[i][other] = gF_TimeCP[i][other] - gF_srCPTime[i][other]
								//PrintToServer("%f d33:", gF_timeDiffCPWin[i][other])
								//gF_timeDiffCPWin[i][gI_partner[other]] = gF_TimeCP[gI_partner[other]][i] - gF_srCPTime[i][other]
								//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
								//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
								//int personalSecond = RoundToFloor(timeClient) % 60
								int srCPHour = (RoundToFloor(gF_timeDiffCPWin[i][other]) / 3600) % 24
								int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[i][other]) / 60) % 60
								int srCPSecond = RoundToFloor(gF_timeDiffCPWin[i][other]) % 60
								//PrintToChat(other, "%s. Checkpoint: +%02.i:%02.i:%02.i", sPlace, srCPHour, srCPMinute, srCPSecond)
								PrintToChatAll("%s. Checkpoint: +%02.i:%02.i:%02.i", sCPnum, srCPHour, srCPMinute, srCPSecond)
								//PrintToChat(gI_partner[other], "%s. Checkpoint: +%02.i:%02.i:%02.i", sPlace, srCPHour, srCPMinute, srCPSecond)
							}
						}
					}
				}
				else if(gF_ServerRecord == 0.0)
				{
					PrintToServer("x123x")
					gF_ServerRecord = gF_Time[other]
					gF_haveRecord[other] = gF_Time[other]
					gF_haveRecord[gI_partner[other]] = gF_Time[other]
					int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
					int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
					int personalSecond = RoundToFloor(gF_Time[other]) % 60
					PrintToChatAll("%N and %N finished map in %02.i:%02.i:%02.i. (SR +00:00:00)", other, gI_partner[other], personalHour, personalMinute, personalSecond)
					for(int i = 1; i <= 10; i++)
					{
						//char sPlace[32]
						IntToString(i, sCPnum, 32)
						if(gB_cp[i][other])
						{
							//if(gF_TimeCP[i][other] < gF_srCPTime[i][other])
							{
								//gF_timeDiffCPWin[i][other] = gF_srCPTime[i][other] - gF_TimeCP[i][other]
								//PrintToServer("%f", gF_timeDiffCPWin[i][other])
								//gF_timeDiffCPWin[i][gI_partner[other]] = gF_srCPTime[i][other] - gF_TimeCP[gI_partner[other]][i]
								//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
								//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
								//int personalSecond = RoundToFloor(timeClient) % 60
								//int srCPHour = (RoundToFloor(gF_timeDiffCPWin[i][other]) / 3600) % 24
								//int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[i][other]) / 60) % 60
								//int srCPSecond = RoundToFloor(gF_timeDiffCPWin[i][other]) % 60
								//IntToString(i, sPlace, 32)
								//PrintToChat(other, "%s. Checkpoint: -%02.i:%02.i:%02.i", sPlace, srCPHour, srCPMinute, srCPSecond)
								PrintToChatAll("%s. Checkpoint: +00:00:00", sCPnum)
								//PrintToChat(gI_partner[other], "%s. Checkpoint: -%02.i:%02.i:%02.i", sPlace, srCPHour, srCPMinute, srCPSecond)
							}
							/*else
							{
								gF_timeDiffCPWin[i][other] = gF_TimeCP[i][other] - gF_srCPTime[i][other]
								PrintToServer("%f d33:", gF_timeDiffCPWin[i][other])
								gF_timeDiffCPWin[i][gI_partner[other]] = gF_TimeCP[gI_partner[other]][i] - gF_srCPTime[i][other]
								//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
								//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
								//int personalSecond = RoundToFloor(timeClient) % 60
								int srCPHour = (RoundToFloor(gF_timeDiffCPWin[i][other]) / 3600) % 24
								int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[i][other]) / 60) % 60
								int srCPSecond = RoundToFloor(gF_timeDiffCPWin[i][other]) % 60
								PrintToChat(other, "%s. Checkpoint: +%02.i:%02.i:%02.i", sPlace, srCPHour, srCPMinute, srCPSecond)
								PrintToChat(gI_partner[other], "%s. Checkpoint: +%02.i:%02.i:%02.i", sPlace, srCPHour, srCPMinute, srCPSecond)
							}*/
						}
					}
					//PrintToServer("2")
					//DataPack dp2 = new DataPack()
					//dp2.WriteCell(GetClientSerial(other))
					//dp2.WriteFloat(gF_Time[other])
					Format(sQuery, 512, "INSERT INTO records (playerid, partnerid, time, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %i, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, partnerid, gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], gS_map, GetTime())
					gD_mysql.Query(SQLInsertRecord, sQuery)
				}
				
				//Format(sQuery, 512, "SELECT MIN(time) FROM records1 WHERE map = '%s'", gS_map)
				//gD_mysql.Query(SQL123x, sQuery)
				//PrintTo
				//int clientid = GetSteamAccountID(other)
				//int partnerid = GetSteamAccountID(gI_partner[other])
				//PrintToServer("%i %i", clientid, partnerid)
				//shavit - datapack
				//DataPack dp = new DataPack()
				//dp.WriteCell(GetClientSerial(other))
				//dp.WriteCell(other[)
				//dp.WriteCell(GetClientSerial(gI_partner[other]))
				//PrintToServer("client: %i %N, partner: %i %N", other, other, gI_partner[other], gI_partner[other])
				//dp.WriteFloat(gF_Time[other]) //https://sm.alliedmods.net/new-api/datapack/DataPack
				//char sQuery[512]
				//Format(sQuery, 512, "SELECT time FROM records WHERE ((playerid = %i AND partnerid = %i) OR (partnerid = %i AND playerid = %i)) AND map = '%s'", clientid, partnerid, partnerid, clientid, gS_map)
				//gD_mysql.Query(SQLRecords, sQuery, dp)
				//DataPack dp2 = new DataPack()
				//dp2.WriteCell(clientid)
				//dp2.WriteCell(partnerid)
				//dp2.WriteCell(GetClientSerial(other))
				//PrintToServer("%i other", other)
				Format(sQuery, 512, "SELECT tier FROM zones WHERE map = '%s' AND type = 0", gS_map)
				gD_mysql.Query(SQLGetMapTier, sQuery, GetClientSerial(other))
			}
			gB_state[other] = false
			gB_state[gI_partner[other]] = false
		}
		if(StrEqual(sTrigger, "fakeexpert_cp1"))
		{
			//gB_cp[1][other] = true
			//if(gB_cp[1][other] && gB_cp[1][gI_partner[other]] && !gB_cpLock[1][other])
			//if(!gB_cpLock[1][other])
			gB_cp[1][other] = true
			if(gB_cp[1][other] && gB_cp[1][gI_partner[other]] && !gB_cpLock[1][other])
			{
				//int hour = RoundToFloor(gF_Time[other])
				//hour = (hour / 3600) % 24
				//int minute = RoundToFloor(gF_Time[other])
				//minute = (minute / 60) % 60
				//int second = RoundToFloor(gF_Time[other])
				//second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				//PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])
				//gB_cp[1][other] = true
				gB_cpLock[1][other] = true
				gB_cpLock[1][gI_partner[other]] = true
				gF_TimeCP[1][other] = gF_Time[other]
				//gF_TimeCP[1][gI_partner[other]] = gF_Time[gI_partner[other]]
				gF_TimeCP[1][gI_partner[other]] = gF_Time[other]
				PrintToServer("%f 2x2", gF_Time[other])
				char sQuery[512] //https://stackoverflow.com/questions/9617453 //https://www.w3schools.com/sql/sql_ref_order_by.asp#:~:text=%20SQL%20ORDER%20BY%20Keyword%20%201%20ORDER,data%20returned%20in%20descending%20order.%20%20More%20
				//Format(sQuery, 512, "SELECT MIN(time), cp1 FROM records WHERE map = '%s' HAVING MIN(time)", gS_map) //https://www.encodedna.com/sqlserver/using-sql-server-min-function-inside-where-clause.htm#:~:text=How%20to%20use%20MIN%20function%20inside%20Where%20Clause,use%20the%20MIN%20function%20in%20a%20WHERE%20clause. //https://www.encodedna.com/sqlserver/using-sql-server-min-function-inside-where-clause.htm
				//Format(sQuery, 512, "SELECT cp1 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)  //log help me alot with this stuff
				Format(sQuery, 512, "SELECT cp1 FROM records")
				DataPack dp = new DataPack()
				dp.WriteCell(GetClientSerial(other))
				dp.WriteCell(1)
				gD_mysql.Query(SQLCPSelect, sQuery, dp)
				PrintToServer("cp1")
			}
			PrintToServer("cp1pre")
			//gB_cp[1][other] = true
			//gB_cp[1][gI_partner[other]] = true
		}
		if(StrEqual(sTrigger, "fakeexpert_cp2"))
		{
			PrintToServer("cp2pre")
			gB_cp[2][other] = true
			if(gB_cp[2][other] && gB_cp[2][gI_partner[other]] && !gB_cpLock[2][other])
			{
				/*int hour = RoundToFloor(gF_Time[other])
				hour = (hour / 3600) % 24
				int minute = RoundToFloor(gF_Time[other])
				minute = (minute / 60) % 60
				int second = RoundToFloor(gF_Time[other])
				second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])*/
				gB_cpLock[2][other] = true
				gB_cpLock[2][gI_partner[other]] = true
				gF_TimeCP[2][other] = gF_Time[other]
				gF_TimeCP[2][gI_partner[other]] = gF_Time[other]
				char sQuery[512]
				//Format(sQuery, 512, "SELECT MIN(time), cp2 FROM records WHERE map = '%s'", gS_map)
				//Format(sQuery, 512, "SELECT cp2 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
				Format(sQuery, 512, "SELECT cp2 FROM records")
				DataPack dp = new DataPack()
				dp.WriteCell(GetClientSerial(other))
				dp.WriteCell(2)
				gD_mysql.Query(SQLCPSelect, sQuery, dp)
			}
			//gB_cp[2][other] = true
			//gB_cp[2][gI_partner[other]] = true
		}
		if(StrEqual(sTrigger, "fakeexpert_cp3"))
		{
			gB_cp[3][other] = true
			if(gB_cp[3][other] && gB_cp[3][gI_partner[other]] && !gB_cpLock[3][other])
			{
				/*int hour = RoundToFloor(gF_Time[other])
				hour = (hour / 3600) % 24
				int minute = RoundToFloor(gF_Time[other])
				minute = (minute / 60) % 60
				int second = RoundToFloor(gF_Time[other])
				second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])*/
				gB_cpLock[3][other] = true
				gB_cpLock[3][gI_partner[other]] = true
				gF_TimeCP[3][other] = gF_Time[other]
				gF_TimeCP[3][gI_partner[other]] = gF_Time[other]
				char sQuery[512]
				//Format(sQuery, 512, "SELECT MIN(time), cp3 FROM records WHERE map = '%s'", gS_map)
				//Format(sQuery, 512, "SELECT cp3 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
				Format(sQuery, 512, "SELECT cp3 FROM records")
				DataPack dp = new DataPack()
				dp.WriteCell(GetClientSerial(other))
				dp.WriteCell(3)
				gD_mysql.Query(SQLCPSelect, sQuery, dp)
			}
			//gB_cp[3][other] = true
			//gB_cp[3][gI_partner[other]] = true
		}
		if(StrEqual(sTrigger, "fakeexpert_cp4"))
		{
			gB_cp[4][other] = true
			if(gB_cp[4][other] && gB_cp[4][gI_partner[other]] && !gB_cpLock[4][other])
			{
				/*int hour = RoundToFloor(gF_Time[other])
				hour = (hour / 3600) % 24
				int minute = RoundToFloor(gF_Time[other])
				minute = (minute / 60) % 60
				int second = RoundToFloor(gF_Time[other])
				second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])*/
				gB_cpLock[4][other] = true
				gB_cpLock[4][gI_partner[other]] = true
				gF_TimeCP[4][other] = gF_Time[other]
				gF_TimeCP[4][gI_partner[other]] = gF_Time[other]
				char sQuery[512]
				//Format(sQuery, 512, "SELECT MIN(time), cp4 FROM records WHERE map = '%s'", gS_map)
				//Format(sQuery, 512, "SELECT cp4 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
				Format(sQuery, 512, "SELECT cp4 FROM records")
				DataPack dp = new DataPack()
				dp.WriteCell(GetClientSerial(other))
				dp.WriteCell(4)
				gD_mysql.Query(SQLCPSelect, sQuery, dp)
			}
			//gB_cp[4][other] = true
			//gB_cp[4][gI_partner[other]] = true
		}
		if(StrEqual(sTrigger, "fakeexpert_cp5"))
		{
			gB_cp[5][other] = true
			if(gB_cp[5][other] && gB_cp[5][gI_partner[other]] && !gB_cpLock[5][other])
			{
				/*int hour = RoundToFloor(gF_Time[other])
				hour = (hour / 3600) % 24
				int minute = RoundToFloor(gF_Time[other])
				minute = (minute / 60) % 60
				int second = RoundToFloor(gF_Time[other])
				second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])*/
				gB_cpLock[5][other] = true
				gB_cpLock[5][gI_partner[other]] = true
				gF_TimeCP[5][other] = gF_Time[other]
				gF_TimeCP[5][gI_partner[other]] = gF_Time[other]
				char sQuery[512]
				//Format(sQuery, 512, "SELECT MIN(time), cp5 FROM records WHERE map = '%s'", gS_map)
				//Format(sQuery, 512, "SELECT cp5 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
				Format(sQuery, 512, "SELECT cp5 FROM records")
				DataPack dp = new DataPack()
				dp.WriteCell(GetClientSerial(other))
				dp.WriteCell(5)
				gD_mysql.Query(SQLCPSelect, sQuery, dp)
			}
			//gB_cp[5][other] = true
			//gB_cp[5][gI_partner[other]] = true
		}
		if(StrEqual(sTrigger, "fakeexpert_cp6"))
		{
			gB_cp[6][other] = true
			if(gB_cp[6][other] && gB_cp[6][gI_partner[other]] && !gB_cpLock[6][other])
			{
				/*int hour = RoundToFloor(gF_Time[other])
				hour = (hour / 3600) % 24
				int minute = RoundToFloor(gF_Time[other])
				minute = (minute / 60) % 60
				int second = RoundToFloor(gF_Time[other])
				second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])*/
				gB_cpLock[6][other] = true
				gB_cpLock[6][gI_partner[other]] = true
				gF_TimeCP[6][other] = gF_Time[other]
				gF_TimeCP[6][gI_partner[other]] = gF_Time[other]
				char sQuery[512]
				//Format(sQuery, 512, "SELECT MIN(time), cp6 FROM records WHERE map = '%s'", gS_map)
				//Format(sQuery, 512, "SELECT cp6 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
				Format(sQuery, 512, "SELECT cp6 FROM records")
				DataPack dp = new DataPack()
				dp.WriteCell(GetClientSerial(other))
				dp.WriteCell(6)
				gD_mysql.Query(SQLCPSelect, sQuery, dp)
			}
			//gB_cp[6][other] = true
			//gB_cp[6][gI_partner[other]] = true
		}
		if(StrEqual(sTrigger, "fakeexpert_cp7"))
		{
			gB_cp[7][other] = true
			if(gB_cp[7][other] && gB_cp[7][gI_partner[other]] && !gB_cpLock[7][other])
			{
				/*int hour = RoundToFloor(gF_Time[other])
				hour = (hour / 3600) % 24
				int minute = RoundToFloor(gF_Time[other])
				minute = (minute / 60) % 60
				int second = RoundToFloor(gF_Time[other])
				second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])*/
				gB_cpLock[7][other] = true
				gB_cpLock[7][gI_partner[other]] = true
				gF_TimeCP[7][other] = gF_Time[other]
				gF_TimeCP[7][gI_partner[other]] = gF_Time[other]
				char sQuery[512]
				//Format(sQuery, 512, "SELECT MIN(time), cp7 FROM records WHERE map = '%s'", gS_map)
				//Format(sQuery, 512, "SELECT cp7 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
				Format(sQuery, 512, "SELECT cp7 FROM records")
				DataPack dp = new DataPack()
				dp.WriteCell(GetClientSerial(other))
				dp.WriteCell(7)
				gD_mysql.Query(SQLCPSelect, sQuery, dp)
			}
			//gB_cp[7][other] = true
			//gB_cp[7][gI_partner[other]] = true
		}
		if(StrEqual(sTrigger, "fakeexpert_cp8"))
		{
			gB_cp[8][other] = true
			if(gB_cp[8][other] && gB_cp[8][gI_partner[other]] && !gB_cpLock[8][other])
			{
				/*int hour = RoundToFloor(gF_Time[other])
				hour = (hour / 3600) % 24
				int minute = RoundToFloor(gF_Time[other])
				minute = (minute / 60) % 60
				int second = RoundToFloor(gF_Time[other])
				second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])*/
				gB_cpLock[8][other] = true
				gB_cpLock[8][gI_partner[other]] = true
				gF_TimeCP[8][other] = gF_Time[other]
				gF_TimeCP[8][gI_partner[other]] = gF_Time[other]
				char sQuery[512]
				//Format(sQuery, 512, "SELECT MIN(time), cp8 FROM records WHERE map = '%s'", gS_map)
				//Format(sQuery, 512, "SELECT cp8 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
				Format(sQuery, 512, "SELECT cp8 FROM records")
				DataPack dp = new DataPack()
				dp.WriteCell(GetClientSerial(other))
				dp.WriteCell(8)
				gD_mysql.Query(SQLCPSelect, sQuery, dp)
			}
			//gB_cp[8][other] = true
			//gB_cp[8][gI_partner[other]] = true
		}
		if(StrEqual(sTrigger, "fakeexpert_cp9"))
		{
			gB_cp[9][other] = true
			if(gB_cp[9][other] && gB_cp[9][gI_partner[other]] && !gB_cpLock[9][other])
			{
				/*int hour = RoundToFloor(gF_Time[other])
				hour = (hour / 3600) % 24
				int minute = RoundToFloor(gF_Time[other])
				minute = (minute / 60) % 60
				int second = RoundToFloor(gF_Time[other])
				second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])*/
				gB_cpLock[9][other] = true
				gB_cpLock[9][gI_partner[other]] = true
				gF_TimeCP[9][other] = gF_Time[other]
				gF_TimeCP[9][gI_partner[other]] = gF_Time[other]
				char sQuery[512]
				//Format(sQuery, 512, "SELECT MIN(time), cp9 FROM records WHERE map = '%s'", gS_map)
				//Format(sQuery, 512, "SELECT cp9 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
				Format(sQuery, 512, "SELECT cp9 FROM records")
				DataPack dp = new DataPack()
				dp.WriteCell(GetClientSerial(other))
				dp.WriteCell(9)
				gD_mysql.Query(SQLCPSelect, sQuery, dp)
			}
			//gB_cp[9][other] = true
			//gB_cp[9][gI_partner[other]] = true
		}
		if(StrEqual(sTrigger, "fakeexpert_cp10"))
		{
			gB_cp[10][other] = true
			if(gB_cp[10][other] && gB_cp[10][gI_partner[other]] && !gB_cpLock[10][other])
			{
				/*int hour = RoundToFloor(gF_Time[other])
				hour = (hour / 3600) % 24
				int minute = RoundToFloor(gF_Time[other])
				minute = (minute / 60) % 60
				int second = RoundToFloor(gF_Time[other])
				second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				PrintToChat(other, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				PrintToChat(gI_partner[other], "Time: %f [%02.i:%02.i:%02.i]", gF_Time[other], hour, minute, second)
				//PrintToChatAll("Time: %02.i:%02.i:%02.i %N and %N finished map.", hour, minute, second, other, gI_partner[other])*/
				gB_cpLock[10][other] = true
				gB_cpLock[10][gI_partner[other]] = true
				gF_TimeCP[10][other] = gF_Time[other]
				gF_TimeCP[10][gI_partner[other]] = gF_Time[other]
				char sQuery[512]
				//Format(sQuery, 512, "SELECT MIN(time), cp10 FROM records WHERE map = '%s'", gS_map)
				//Format(sQuery, 512, "SELECT cp10 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
				Format(sQuery, 512, "SELECT cp10 FROM records")
				DataPack dp = new DataPack()
				dp.WriteCell(GetClientSerial(other))
				dp.WriteCell(10)
				gD_mysql.Query(SQLCPSelect, sQuery, dp)
			}
			//gB_cp[10][other] = true
			//gB_cp[10][gI_partner[other]] = true
		}
	}
	//gB_passzone[other] = false
}

/*void SQL123x(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		PrintToServer("123x32maps is lol")
	}
	else
	{
		PrintToServer("paitisnaodsfjslndfkljsdbnflkjn")
	}
}*/

void SQLUpdateRecord(Database db, DBResultSet results, const char[] error, DataPack dp)
{
	PrintToServer("Record updated.")
}

void SQLInsertRecord(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("Record inserted.")
}

/*void SQLUpdateRecordCompelete(Database db, DBResultSet results, const char[] error, DataPack dp)
{
}*/

/*Action cmd_testtext(int client, int args)
{
	PrintToChat(client, "%N and %N finished map in 05:04:22. (SR -00:00:00)", client, client)
	PrintToChat(client, "%N and %N finished map in 05:04:22. (SR +00:00:00)", client, client)
	return Plugin_Handled
}*/

void SQLGetMapTier(Database db, DBResultSet results, const char[] error, any data)
{
	//dp.Reset()
	//int clientid = dp.ReadCell()
	//int partnerid = dp.ReadCell()
	//int other = dp.ReadCell()
	if(data == 0)
		return
	int other = GetClientFromSerial(data)
	int clientid = GetSteamAccountID(other)
	int partnerid = GetSteamAccountID(other)
	if(results.FetchRow())
	{
		int tier = results.FetchInt(0)
		int points = tier * 20
		DataPack dp2 = new DataPack()
		dp2.WriteCell(points)
		dp2.WriteCell(clientid)
		dp2.WriteCell(other)
		char sQuery[512]
		Format(sQuery, 512, "SELECT points FROM users WHERE steamid = %i", clientid)
		gD_mysql.Query(SQLGetPoints, sQuery, dp2)
		DataPack dp3 = new DataPack()
		dp3.WriteCell(points)
		dp3.WriteCell(partnerid)
		Format(sQuery, 512, "SELECT points FROM users WHERE steamid = %i", partnerid)
		gD_mysql.Query(SQLGetPointsPartner, sQuery, dp2)
	}
}

void SQLGetPoints(Database db, DBResultSet results, const char[] error, DataPack dp2)
{
	//PrintToServer("Debug")
	dp2.Reset()
	int earnedpoints = dp2.ReadCell()
	int clientid = dp2.ReadCell()
	//int other = GetClientFromSerial(dp2.ReadCell())
	//PrintToServer("SQLGetPoints: %i [%N]", other, other)
	if(results.FetchRow())
	{
		int points = results.FetchInt(0)
		char sQuery[512]
		Format(sQuery, 512, "UPDATE users SET points = %i + %i WHERE steamid = %i", points, earnedpoints, clientid)
		gD_mysql.Query(SQLEarnedPoints, sQuery)
		//PrintToChat(other, "You recived %i points. You have %i points.", earnedpoints, points + earnedpoints)
		//PrintToChat(gI_partner[other], "You recived %i points. You have %i points.", earnedpoints, points + earnedpoints)
	}
}

void SQLGetPointsPartner(Database db, DBResultSet results, const char[] error, DataPack dp3)
{
	dp3.Reset()
	int earnedpoints = dp3.ReadCell()
	int partnerid = dp3.ReadCell()
	if(results.FetchRow())
	{
		int points = results.FetchInt(0)
		char sQuery[512]
		Format(sQuery, 512, "UPDATE users SET points = %i + %i WHERE steamid = %i", points, earnedpoints, partnerid)
		gD_mysql.Query(SQLEarnedPoints, sQuery)
	}
}

void SQLEarnedPoints(Database db, DBResultSet results, const char[] error, any data)
{
}

void SQLCPSelect(Database db, DBResultSet results, const char[] error, DataPack data)
{
	//int other = GetClientFromSerial(data)
	data.Reset()
	int other = GetClientFromSerial(data.ReadCell())
	int cpnum = data.ReadCell()
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp%i FROM records WHERE map = '%s' ORDER BY time LIMIT 1", cpnum, gS_map)
		DataPack dp = new DataPack()
		dp.WriteCell(GetClientSerial(other))
		dp.WriteCell(cpnum)
		gD_mysql.Query(SQLCPSelect_2, sQuery, dp)
	}
	else
	{
		PrintToChat(other, "%i. Checkpoint: +00:00:00", cpnum)
		PrintToChat(gI_partner[other], "%i. Checkpoint: +00:00:00", cpnum)
	}
}

void SQLCPSelect_2(Database db, DBResultSet results, const char[] error, DataPack data)
{
	//int other = GetClientFromSerial(data)
	data.Reset()
	int other = GetClientFromSerial(data.ReadCell())
	int cpnum = data.ReadCell()
	if(results.FetchRow())
	{
		//float srTime = results.FetchFloat(0)
		gF_srCPTime[cpnum][other] = results.FetchFloat(0)
		//PrintToServer("srCPTime: %f srTime: %f", gF_srCPTime[1][other], srTime)
		PrintToServer("srCPTime %i: %f", cpnum, gF_srCPTime[cpnum][other])
		if(gF_TimeCP[cpnum][other] < gF_srCPTime[cpnum][other])
		{
			gF_timeDiffCPWin[cpnum][other] = gF_srCPTime[cpnum][other] - gF_TimeCP[cpnum][other]
			gF_timeDiffCPWin[cpnum][gI_partner[other]] = gF_srCPTime[cpnum][other] - gF_TimeCP[cpnum][other]
			//gF_timeDiffCPWin[1][other] = gF_Time[other]
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[cpnum][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[cpnum][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[cpnum][other]) % 60
			PrintToChat(other, "%i. Checkpoint: -%02.i:%02.i:%02.i", cpnum, srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "%i. Checkpoint: -%02.i:%02.i:%02.i", cpnum, srCPHour, srCPMinute, srCPSecond)
			//char sQuery[512]
			//Format(sQuery, 512, "
		}
		else
		{
			gF_timeDiffCPWin[cpnum][other] = gF_TimeCP[cpnum][other] - gF_srCPTime[cpnum][other]
			gF_timeDiffCPWin[cpnum][gI_partner[other]] = gF_TimeCP[cpnum][other] - gF_srCPTime[cpnum][other]
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[cpnum][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[cpnum][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[cpnum][other]) % 60
			PrintToChat(other, "%i. Checkpoint: +%02.i:%02.i:%02.i", cpnum, srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "%i. Checkpoint: +%02.i:%02.i:%02.i", cpnum, srCPHour, srCPMinute, srCPSecond)
		}
		//gB_cp[1] = true
	}
	else
	{
		PrintToChat(other, "%i. Checkpoint: +00:00:00", cpnum)
		PrintToChat(gI_partner[other], "%i. Checkpoint: +00:00:00", cpnum)
		//PrintToServer("123j298bh3testcpfisrtt is goding uyp to tyhe sky and seek dontn make me cry.")
	}
}

/*void SQLCPSelect2(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp2 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
		gD_mysql.Query(SQLCPSelect2_2, sQuery, GetClientSerial(other))
	}
	else
	{
		PrintToChat(other, "2. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "2. Checkpoint: +00:00:00")
	}
}

void SQLCPSelect2_2(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	if(results.FetchRow())
	{
		//float srTime = results.FetchFloat(0)
		gF_srCPTime[2][other] = results.FetchFloat(0)
		PrintToServer("srCPTime 2: %f", gF_srCPTime[2][other])
		if(gF_TimeCP[2][other] < gF_srCPTime[2][other])
		{
			gF_timeDiffCPWin[2][other] = gF_srCPTime[2][other] - gF_TimeCP[2][other]
			gF_timeDiffCPWin[2][gI_partner[other]] = gF_srCPTime[2][other] - gF_TimeCP[2][other]
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[2][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[2][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[2][other]) % 60
			PrintToChat(other, "2. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "2. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		else
		{
			gF_timeDiffCPWin[2][other] = gF_TimeCP[2][other] - gF_srCPTime[2][other]
			gF_timeDiffCPWin[2][gI_partner[other]] = gF_TimeCP[2][other] - gF_srCPTime[2][other]
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[2][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[2][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[2][other]) % 60
			PrintToChat(other, "2. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "2. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		//gB_CP[2] = true
	}
	else
	{
		PrintToChat(other, "2. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "2. Checkpoint: +00:00:00")
		//PrintToServer("123j298bh3testcpfisrtt is goding uyp to tyhe sky and seek dontn make me cry.")
	}
}

void SQLCPSelect3(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp3 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
		gD_mysql.Query(SQLCPSelect3_2, sQuery, GetClientSerial(other))
	}
	else
	{
		PrintToChat(other, "3. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "3. Checkpoint: +00:00:00")
	}
}

void SQLCPSelect3_2(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	if(results.FetchRow())
	{
		//float srTime = results.FetchFloat(0)
		gF_srCPTime[3][other] = results.FetchFloat(0)
		PrintToServer("srCPTime 3: %f", gF_srCPTime[3][other])
		if(gF_TimeCP[3][other] < gF_srCPTime[3][other])
		{
			gF_timeDiffCPWin[3][other] = gF_srCPTime[3][other] - gF_TimeCP[3][other]
			gF_timeDiffCPWin[3][gI_partner[other]] = gF_srCPTime[3][other] - gF_TimeCP[3][other]
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[3][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[3][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[3][other]) % 60
			PrintToChat(other, "3. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "3. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		else
		{
			gF_timeDiffCPWin[3][other] = gF_TimeCP[3][other] - gF_srCPTime[3][other]
			gF_timeDiffCPWin[3][gI_partner[other]] = gF_TimeCP[3][other] - gF_srCPTime[3][other]
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[3][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[3][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[3][other]) % 60
			PrintToChat(other, "3. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "3. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		//gB_CP[3] = true
	}
	else
	{
		PrintToChat(other, "3. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "3. Checkpoint: +00:00:00")
		//PrintToServer("123j298bh3testcpfisrtt is goding uyp to tyhe sky and seek dontn make me cry.")
	}
}

void SQLCPSelect4(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp4 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
		gD_mysql.Query(SQLCPSelect4_2, sQuery, GetClientSerial(other))
	}
	else
	{
		PrintToChat(other, "4. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "4. Checkpoint: +00:00:00")
	}
}

void SQLCPSelect4_2(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	if(results.FetchRow())
	{
		//float srTime = results.FetchFloat(0)
		gF_srCPTime[4][other] = results.FetchFloat(0)
		PrintToServer("srCPTime 4: %f", gF_srCPTime[4][other])
		if(gF_TimeCP[4][other] < gF_srCPTime[4][other])
		{
			gF_timeDiffCPWin[4][other] = gF_srCPTime[4][other] - gF_TimeCP[4][other]
			gF_timeDiffCPWin[4][gI_partner[other]] = gF_srCPTime[4][other] - gF_TimeCP[4][other]
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[4][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[4][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[4][other]) % 60
			PrintToChat(other, "4. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "4. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		else
		{
			gF_timeDiffCPWin[4][other] = gF_TimeCP[4][other] - gF_srCPTime[4][other]
			gF_timeDiffCPWin[4][gI_partner[other]] = gF_TimeCP[4][other] - gF_srCPTime[4][other]
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[4][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[4][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[4][other]) % 60
			PrintToChat(other, "4. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "4. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		//gB_CP[4] = true
	}
	else
	{
		PrintToChat(other, "4. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "4. Checkpoint: +00:00:00")
		//PrintToServer("123j298bh3testcpfisrtt is goding uyp to tyhe sky and seek dontn make me cry.")
	}
}

void SQLCPSelect5(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp5 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
		gD_mysql.Query(SQLCPSelect5_2, sQuery, GetClientSerial(other))
	}
	else
	{
		PrintToChat(other, "5. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "5. Checkpoint: +00:00:00")
	}
}

void SQLCPSelect5_2(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	if(results.FetchRow())
	{
		//float srTime = results.FetchFloat(0)
		gF_srCPTime[5][other] = results.FetchFloat(0)
		PrintToServer("srCPTime 5: %f", gF_srCPTime[5][other])
		if(gF_TimeCP[5][other] < gF_srCPTime[5][other])
		{
			gF_timeDiffCPWin[5][other] = gF_srCPTime[5][other] - gF_TimeCP[5][other]
			gF_timeDiffCPWin[5][gI_partner[other]] = gF_srCPTime[5][other] - gF_TimeCP[5][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[5][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[5][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[5][other]) % 60
			PrintToChat(other, "5. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "5. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		else
		{
			gF_timeDiffCPWin[5][other] = gF_TimeCP[5][other] - gF_srCPTime[5][other]
			gF_timeDiffCPWin[5][gI_partner[other]] = gF_TimeCP[5][other] - gF_srCPTime[5][other]
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[5][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[5][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[5][other]) % 60
			PrintToChat(other, "5. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "5. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		//gB_CP[5] = true
	}
	else
	{
		PrintToChat(other, "5. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "5. Checkpoint: +00:00:00")
		//PrintToServer("123j298bh3testcpfisrtt is goding uyp to tyhe sky and seek dontn make me cry.")
	}
}

void SQLCPSelect6(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp6 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
		gD_mysql.Query(SQLCPSelect6_2, sQuery, GetClientSerial(other))
	}
	else
	{
		PrintToChat(other, "6. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "6. Checkpoint: +00:00:00")
	}
}

void SQLCPSelect6_2(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	if(results.FetchRow())
	{
		//float srTime = results.FetchFloat(0)
		gF_srCPTime[6][other] = results.FetchFloat(0)
		PrintToServer("srCPTime 6: %f", gF_srCPTime[6][other])
		if(gF_TimeCP[6][other] < gF_srCPTime[6][other])
		{
			gF_timeDiffCPWin[6][other] = gF_srCPTime[6][other] - gF_TimeCP[6][other]
			gF_timeDiffCPWin[6][gI_partner[other]] = gF_srCPTime[6][other] - gF_TimeCP[6][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[6][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[6][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[6][other]) % 60
			PrintToChat(other, "6. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "6. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		else
		{
			gF_timeDiffCPWin[6][other] = gF_TimeCP[6][other] - gF_srCPTime[6][other]
			gF_timeDiffCPWin[6][gI_partner[other]] = gF_TimeCP[6][other] - gF_srCPTime[6][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[6][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[6][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[6][other]) % 60
			PrintToChat(other, "6. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "6. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		//gB_CP[6] = true
	}
	else
	{
		PrintToChat(other, "6. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "6. Checkpoint: +00:00:00")
		//PrintToServer("123j298bh3testcpfisrtt is goding uyp to tyhe sky and seek dontn make me cry.")
	}
} 

void SQLCPSelect7(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp7 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
		gD_mysql.Query(SQLCPSelect7_2, sQuery, GetClientSerial(other))
	}
	else
	{
		PrintToChat(other, "7. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "7. Checkpoint: +00:00:00")
	}
}

void SQLCPSelect7_2(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	if(results.FetchRow())
	{
		//float srTime = results.FetchFloat(0)
		gF_srCPTime[7][other] = results.FetchFloat(0)
		PrintToServer("srCPTime 7: %f", gF_srCPTime[7][other])
		if(gF_TimeCP[7][other] < gF_srCPTime[7][other])
		{
			gF_timeDiffCPWin[7][other] = gF_srCPTime[7][other] - gF_TimeCP[7][other]
			gF_timeDiffCPWin[7][gI_partner[other]] = gF_srCPTime[7][other] - gF_TimeCP[7][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[7][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[7][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[7][other]) % 60
			PrintToChat(other, "7. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "7. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		else
		{
			gF_timeDiffCPWin[7][other] = gF_TimeCP[7][other] - gF_srCPTime[7][other]
			gF_timeDiffCPWin[7][gI_partner[other]] = gF_TimeCP[7][other] - gF_srCPTime[7][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[7][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[7][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[7][other]) % 60
			PrintToChat(other, "7. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "7. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		//gB_CP[7] = true
	}
	else
	{
		PrintToChat(other, "7. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "7. Checkpoint: +00:00:00")
		//PrintToServer("123j298bh3testcpfisrtt is goding uyp to tyhe sky and seek dontn make me cry.")
	}
}

void SQLCPSelect8(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp8 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
		gD_mysql.Query(SQLCPSelect8_2, sQuery, GetClientSerial(other))
	}
	else
	{
		PrintToChat(other, "8. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "8. Checkpoint: +00:00:00")
	}
}

void SQLCPSelect8_2(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	if(results.FetchRow())
	{
		//float srTime = results.FetchFloat(0)
		gF_srCPTime[8][other] = results.FetchFloat(0)
		PrintToServer("srCPTime 8: %f", gF_srCPTime[8][other])
		if(gF_TimeCP[8][other] < gF_srCPTime[8][other])
		{
			gF_timeDiffCPWin[8][other] = gF_srCPTime[8][other] - gF_TimeCP[8][other]
			gF_timeDiffCPWin[8][gI_partner[other]] = gF_srCPTime[8][other] - gF_TimeCP[8][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[8][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[8][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[8][other]) % 60
			PrintToChat(other, "8. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "8. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		else
		{
			gF_timeDiffCPWin[8][other] = gF_TimeCP[8][other] - gF_srCPTime[8][other]
			gF_timeDiffCPWin[8][gI_partner[other]] = gF_TimeCP[8][other] - gF_srCPTime[8][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[8][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[8][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[8][other]) % 60
			PrintToChat(other, "8. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "8. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		//gB_CP[8] = true
	}
	else
	{
		PrintToChat(other, "8. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "8. Checkpoint: +00:00:00")
		//PrintToServer("123j298bh3testcpfisrtt is goding uyp to tyhe sky and seek dontn make me cry.")
	}
}

void SQLCPSelect9(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp9 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
		gD_mysql.Query(SQLCPSelect9_2, sQuery, GetClientSerial(other))
	}
	else
	{
		PrintToChat(other, "9. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "9. Checkpoint: +00:00:00")
	}
}

void SQLCPSelect9_2(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	if(results.FetchRow())
	{
		//float srTime = results.FetchFloat(0)
		gF_srCPTime[9][other] = results.FetchFloat(0)
		PrintToServer("srCPTime 9: %f", gF_srCPTime[9][other])
		if(gF_TimeCP[9][other] < gF_srCPTime[9][other])
		{
			gF_timeDiffCPWin[9][other] = gF_srCPTime[9][other] - gF_TimeCP[9][other]
			gF_timeDiffCPWin[9][gI_partner[other]] = gF_srCPTime[9][other] - gF_TimeCP[9][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[9][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[9][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[9][other]) % 60
			PrintToChat(other, "9. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "9. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		else
		{
			gF_timeDiffCPWin[9][other] = gF_TimeCP[9][other] - gF_srCPTime[9][other]
			gF_timeDiffCPWin[9][gI_partner[other]] = gF_TimeCP[9][other] - gF_srCPTime[9][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[9][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[9][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[9][other]) % 60
			PrintToChat(other, "9. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "9. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		//gB_CP[9] = true
	}
	else
	{
		PrintToChat(other, "9. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "9. Checkpoint: +00:00:00")
		//PrintToServer("123j298bh3testcpfisrtt is goding uyp to tyhe sky and seek dontn make me cry.")
	}
}

void SQLCPSelect10(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp10 FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
		gD_mysql.Query(SQLCPSelect10_2, sQuery, GetClientSerial(other))
	}
	else
	{
		PrintToChat(other, "10. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "10. Checkpoint: +00:00:00")
	}
}

void SQLCPSelect10_2(Database db, DBResultSet results, const char[] error, any data)
{
	int other = GetClientFromSerial(data)
	if(results.FetchRow())
	{
		//float srTime = results.FetchFloat(0)
		gF_srCPTime[10][other] = results.FetchFloat(0)
		PrintToServer("srCPTime 10: %f", gF_srCPTime[10][other])
		if(gF_TimeCP[10][other] < gF_srCPTime[10][other])
		{
			gF_timeDiffCPWin[10][other] = gF_srCPTime[10][other] - gF_TimeCP[10][other]
			gF_timeDiffCPWin[10][gI_partner[other]] = gF_srCPTime[10][other] - gF_TimeCP[10][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[10][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[10][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[10][other]) % 60
			PrintToChat(other, "10. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "10. Checkpoint: -%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		else
		{
			gF_timeDiffCPWin[10][other] = gF_TimeCP[10][other] - gF_srCPTime[10][other]
			gF_timeDiffCPWin[10][gI_partner[other]] = gF_TimeCP[10][other] - gF_srCPTime[10][other] //idea from Expert-Zone.
			//int personalHour = (RoundToFloor(timeClient) / 3600) % 24
			//int personalMinute = (RoundToFloor(timeClient) / 60) % 60
			//int personalSecond = RoundToFloor(timeClient) % 60
			int srCPHour = (RoundToFloor(gF_timeDiffCPWin[10][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCPWin[10][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCPWin[10][other]) % 60
			PrintToChat(other, "10. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
			PrintToChat(gI_partner[other], "10. Checkpoint: +%02.i:%02.i:%02.i", srCPHour, srCPMinute, srCPSecond)
		}
		//gB_CP[10] = true
	}
	else
	{
		PrintToChat(other, "10. Checkpoint: +00:00:00")
		PrintToChat(gI_partner[other], "10. Checkpoint: +00:00:00")
		//PrintToServer("123j298bh3testcpfisrtt is goding uyp to tyhe sky and seek dontn make me cry.")
	}
}*/

/*Action cmd_sum(int client, int args)
{
	float vec[3]
	float vec2[3]
	//DispatchKeyValueVector(trigger, "origin", vec) //Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	//DispatchSpawn(trigger)
	//GetClientAbsOrigin
	GetEntPropVector(client, Prop_Data, "m_vecOrigin", vec)
	GetEntPropVector(client, Prop_Data, "m_vecOrigin", vec2)
	vec2[1] = vec2[1] += 256.0
	TE_SetupBeamPoints(vec, vec2, gI_beam, gI_halo, 0, 0, 0.1, 1.0, 1.0, 0, 0.0, {255, 255, 255, 75}, 0) //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-zones.sp#L2612 //Exception reported: Stack leak detected: sp:42876 should be 25228!
	TE_SendToAll(0.0)
	return Plugin_Handled
}*/

Action cmd_createtable(int args)
{
	char sQuery[512]
	Format(sQuery, 512, "CREATE TABLE IF NOT EXISTS `zones` (`id` INT AUTO_INCREMENT, `map` VARCHAR(128), `type` INT, `possition_x` FLOAT, `possition_y` FLOAT, `possition_z` FLOAT, `possition_x2` FLOAT, `possition_y2` FLOAT, `possition_z2` FLOAT, `tier` INT, PRIMARY KEY (id))") //https://stackoverflow.com/questions/8114535/mysql-1075-incorrect-table-definition-autoincrement-vs-another-key
	gD_mysql.Query(SQLCreateZonesTable, sQuery)
}

void SQLConnect(Database db, const char[] error, any data)
{
	if(!db)
	{
		PrintToServer("Failed to connect to database")
		return
	}
	PrintToServer("Successfuly connected to database.") //https://hlmod.ru/threads/sourcepawn-urok-13-rabota-s-bazami-dannyx-mysql-sqlite.40011/
	gD_mysql = db
	gD_mysql.SetCharset("utf8") //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-core.sp#L2883
	ForceZonesSetup() //https://sm.alliedmods.net/new-api/dbi/__raw
	gB_pass = true //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-stats.sp#L199
	char sQuery[512]
	Format(sQuery, 512, "SELECT MIN(time) FROM records WHERE map = '%s'", gS_map)
	gD_mysql.Query(SQLGetServerRecord, sQuery)
}

/*Action cmd_manualinsert(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	if(steamid == GetConVarInt(gCV_steamid))
	{
		char sQuery[512]
		Format(sQuery, 512, "INSERT INTO zones (map, type) VALUES ('%s', 0)", gS_map)
		gD_mysql.Query(SQLManualInsert, sQuery)
		Format(sQuery, 512, "INSERT INTO zones (map, type) VALUES ('%s', 1)", gS_map)
		gD_mysql.Query(SQLManualInsert, sQuery)
	}
	return Plugin_Handled
}*/

//void SQLManualInsert(Database db, DBResultSet results, const char[] error, any data)
//{
//}

//void SQLForceZonesSetup(Database db, DBResultSet results, const char[] error, any data)
void ForceZonesSetup()
{
	//shavit results null
	//if(results == null)
	//{
		//PrintToServer("Error with mysql connection %s", error)
		//return
	//}
	char sQuery[512]
	Format(sQuery, 512, "SELECT possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2 FROM zones WHERE map = '%s' AND type = 0", gS_map)
	gD_mysql.Query(SQLSetZonesEntity, sQuery)
}

void SQLSetZonesEntity(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		gF_vec1[0][0] = results.FetchFloat(0)
		gF_vec1[0][1] = results.FetchFloat(1)
		gF_vec1[0][2] = results.FetchFloat(2)
		gF_vec2[0][0] = results.FetchFloat(3)
		gF_vec2[0][1] = results.FetchFloat(4)
		gF_vec2[0][2] = results.FetchFloat(5)
		//cmd_createstart(0, 0)
		createstart()
		//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
		float center[3]
		center[0] = (gF_vec2[0][0] + gF_vec1[0][0]) / 2.0
		center[1] = (gF_vec2[0][1] + gF_vec1[0][1]) / 2.0
		center[2] = (gF_vec2[0][2] + gF_vec1[0][2]) / 2.0
		//gF_vecStart[0] = gF_vec1[0]
		//gF_vecStart[1] = gF_vec1[1]
		gF_vecStart[0] = center[0]
		gF_vecStart[1] = center[1]
		gF_vecStart[2] = center[2]
		PrintToServer("SQLSetZonesEntity successfuly.")
		char sQuery[512]
		Format(sQuery, 512, "SELECT possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2 FROM zones WHERE map = '%s' AND type = 1", gS_map)
		gD_mysql.Query(SQLSetZoneEnd, sQuery)
	}
}

void SQLSetZoneEnd(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		gF_vec1[1][0] = results.FetchFloat(0)
		gF_vec1[1][1] = results.FetchFloat(1)
		gF_vec1[1][2] = results.FetchFloat(2)
		gF_vec2[1][0] = results.FetchFloat(3)
		gF_vec2[1][1] = results.FetchFloat(4)
		gF_vec2[1][2] = results.FetchFloat(5)
		PrintToServer("SQLSetZoneEnd: %f %f %f", gF_vec2[1][0], gF_vec2[1][1], gF_vec2[1][2])
		//cmd_createend(0, 0)
		createend()
	}
}

public void SQLCreateZonesTable(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("Success")
}

Action cmd_tp(int client, int args)
{
	//TeleportEntity(client, gI_trigger, NULL_VECTOR, NULL_VECTOR)
	float vecBase[3]
	GetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", vecBase)
	PrintToServer("cmd_tp: vecbase: %f %f %f", vecBase[0], vecBase[1], vecBase[2])
	return Plugin_Handled
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	gI_entityFlags[client] = GetEntityFlags(client)
	if(buttons & IN_JUMP && !(GetEntityFlags(client) & FL_ONGROUND) && !(GetEntityFlags(client) & FL_INWATER) && !(GetEntityMoveType(client) & MOVETYPE_LADDER) && IsPlayerAlive(client)) //https://sm.alliedmods.net/new-api/entity_prop_stocks/GetEntityFlags https://forums.alliedmods.net/showthread.php?t=127948
		buttons &= ~IN_JUMP //https://stackoverflow.com/questions/47981/how-do-you-set-clear-and-toggle-a-single-bit https://forums.alliedmods.net/showthread.php?t=192163
	if(buttons & IN_LEFT || buttons & IN_RIGHT)//https://sm.alliedmods.net/new-api/entity_prop_stocks/__raw Expert-Zone idea.
		KickClient(client, "Don't use joystick") //https://sm.alliedmods.net/new-api/clients/KickClient
	//Timer
	//if(gB_state[client] && gB_mapfinished[client] && gB_mapfinished[gI_partner[client]])
	if(gB_state[client])
	{
		//gF_Time[client] = GetEngineTime()
		gF_Time[client] = GetEngineTime() - gF_TimeStart[client]
		//if(!gB_mapfinished[client])
			//gB_state[client] = false
	}
	//if(gI_skyStep[client] >= 1)
		//gI_skyStep[client]++
	//int groundEntity = GetEntPropEnt(client, Prop_Data, "m_hGroundEntity") //Skipper idea. 2020 (2019)
	//if(0 < groundEntity <= MaxClients && IsPlayerAlive(groundEntity)) //client - flyer, booster - groundEntity
	//{
		//if(++gI_frame[client] >= 5) //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L91
		/*float fallVel[3]
		fallVel[0] = gF_fallVel[client][0]
		fallVel[1] = gF_fallVel[client][1]
		//fallVel[2] = gF_fallVel[client][2] * 4.0
		//gF_fallVel[client][2] += gF_fallVel[client][2]
		//fallVel[2] = gF_fallVel[client][2] / 4.0
		//fallVel[2] = fallVel[2] += gF_fallVel[client][2]
		//if(gF_fallVel[client][2] < 500.0)
		gF_fallVel[client][2] += 300.0
		//PrintToServer("JumpTime: %f", GetEntPropFloat(client, Prop_Data, "m_flJumpTime")) //https://forums.alliedmods.net/showthread.php?t=249353
		fallVel[2] = gF_fallVel[client][2]
		if(buttons & IN_JUMP)
		{
			if(fallVel[2] > 800.0)
				fallVel[2] = 800.0
			if(fallVel[2] <= 800.0 && !(GetEntityFlags(groundEntity) & FL_ONGROUND) && !(buttons & IN_DUCK))
			{
				float vecVelBooster[3]
				GetEntPropVector(groundEntity, Prop_Data, "m_vecVelocity", vecVelBooster)
				if(gB_onGround[client] && gF_fallVelBooster[groundEntity][2] >= 0.0)
				{
					PrintToServer("gF_fallVelBooster runcmd: %f", gF_fallVelBooster[groundEntity][2])
					//if(!(GetEntProp(client, Prop_Data, "m_bDucked", 4) > ||  //Log's idea.
					TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, fallVel)
					//PrintToServer("%f", fallVel[2])
				}
				if(groundEntity == 0)
					gB_onGround[client] = false
				if(groundEntity > 0) // expert zone idea.
					gB_onGround[client] = true
			}
		}*/
		//float fallVel[3]
		//gF_fallVel[client][2] = gF_fallVel[client][2] + gF_fallVelBooster[groundEntity][2]
		/*if(gF_fallVelBooster[groundEntity][2] <= 75.0) //289.993377
			gF_fallVel[client][2] = 550.0
		else if(gF_fallVelBooster[groundEntity][2] <= 100.0)
			gF_fallVel[client][2] = 600.0
		else if(gF_fallVelBooster[groundEntity][2] <= 150.0)
			gF_fallVel[client][2] = 650.0*/
		/*else if(gF_fallVelBooster[groundEntity][2] <= 200.0) //289.993377
			gF_fallVel[client][2] = 700.0
		else if(gF_fallVelBooster[groundEntity][2] <= 250.0)
			gF_fallVel[client][2] = 750.0
		else if(gF_fallVelBooster[groundEntity][2] <= 300.0)
			gF_fallVel[client][2] = 800.0*/
		/*if(gF_fallVelBooster[groundEntity][2] >= 5.0) //289.993377
			gF_fallVel[client][2] = 600.0
		else if(gF_fallVelBooster[groundEntity][2] >= 50.0)
			gF_fallVel[client][2] = 650.0
		else if(gF_fallVelBooster[groundEntity][2] >= 100.0)
			gF_fallVel[client][2] = 700.0
		else if(gF_fallVelBooster[groundEntity][2] >= 150.0) //289.993377
			gF_fallVel[client][2] = 750.0
		else if(gF_fallVelBooster[groundEntity][2] >= 200.0)
			gF_fallVel[client][2] = 800.0*/
		//else if(gF_fallVelBooster[groundEntity][2] <= 250.0)
			//gF_fallVel[client][2] = 800.0
	//if(2 >= gI_skyStep[client] >= 1)
	//	gI_skyStep[client] ++
	//int groundEntity = GetEntPropEnt(client, Prop_Data, "m_hGroundEntity")
	//if(0 < groundEntity <= MaxClients && gF_curretVelBooster[groundEntity][2] > 0.0 && gI_skyStep[client] == 1)
		//gI_skyStep[client] = 2
	//if(gF_currentVelBooster[client][2] > 0.0 && gI_skyStep[client] == 1 && GetEntityFlags(client) & FL_ONGROUND)
	//if(gF_currentVelBooster[client][2] > 0.0 && !(GetEntProp(client, Prop_Data, "m_nOldButtons") & IN_JUMP) && gI_skyStep[client] == 1 && GetEntityFlags(client) & FL_ONGROUND)
	float baseVel[3]
	//if((gI_boost[client] && gI_skyStep[client]) || (gI_boost[client] || gI_skyStep[client]))
	if(gI_boost[client])
	{
		//if(GetGameTime() - gF_boostTime[client] < 0.15)
		//gI_boost[client]++
		//SetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", baseVel)
		//return Plugin_Continue
	}
	if(gI_skyStep[client])
		//SetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", baseVel)
	//if(GetGameTime() - gF_boostTime[client] > 0.15 && gI_boost[client])
	//if(GetGameTime() - gF_boostTime[client] < 0.15)
		//SetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", baseVel)
	SetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", baseVel)
	if(gI_boost[client] >= 1)
	{
		//SetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", view_as<float>({0.0, 0.0, 0.0}))
		gI_boost[client]++
		//gI_skyStep[client] = 0
	}
	//if(gI_boost[client] == 2)
	//{
		//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, baseVel)
		//gI_boost[client] = 3
	//}
	//else if(gI_boost[client] == 3)
	//if(gI_boost[client] == 2 && !(GetEntityFlags(client) & FL_ONGROUND) && EntRefToEntIndex(gI_flash[client]) != INVALID_ENT_REFERENCE && GetGameTime() - gF_boostTime[client] < 0.15)
	//if(gI_boost[client] == 2 && GetGameTime() - gF_boostTime[client] > 0.15)
	//if(gI_boost[client)
	if(gI_boost[client] == 15)
	{
		//if(gB_groundBoost[client])
			//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		//else
			//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		for(int i = 0; i <= 2; i++)
			gF_vecVelBoostFix[client][i] = 0.0
		gI_boost[client] = 0
		gI_skyStep[client] = 0
		PrintToServer("debug")
	}
	if(gI_boost[client] == 7 && EntRefToEntIndex(gI_flash[client]) != INVALID_ENT_REFERENCE)
	{
		//if(gB_groundBoost[client])
			//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		if(!gB_groundBoost[client])
		{
			float zVelMinus[3]
			//for(int i = 0; i <= 2; i++)
			zVelMinus[0] = gF_vecVelBoostFix[client][0]
			zVelMinus[1] = gF_vecVelBoostFix[client][1]
			zVelMinus[2] = gF_vecVelBoostFix[client][2] * -1.0
			//zVelMinus[1] = gF_vecVelBoostFix[client][1] * -1.0
			//zVelMinus[2] = gF_vecVelBoostFix[client][1] * -1.0
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, zVelMinus)
			//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		}
		//for(int i = 0; i <= 2; i++)
			//gF_vecVelBoostFix[client][i] = 0.0
		//gI_boost[client] = 8
		gI_skyStep[client] = 0
		PrintToServer("debug")
		//gI_boost[client] = 2
	}
	if(gI_boost[client] == 8 && EntRefToEntIndex(gI_flash[client]) != INVALID_ENT_REFERENCE)
	{
		if(gB_groundBoost[client])
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		else
		{
			//float zVelMinus[3]
			//zVelMinus[0] = gF_vecVelBoostFix[client][0] * -1.0
			//zVelMinus[1] = gF_vecVelBoostFix[client][1] * -1.0
			//zVelMinus[2] = -10000000000.0
			//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, zVelMinus)
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		}
		for(int i = 0; i <= 2; i++)
			gF_vecVelBoostFix[client][i] = 0.0
		gI_boost[client] = 0
		gI_skyStep[client] = 0
		PrintToServer("debug")
		//gI_boost[client] = 2
	}
	//if(gI_skyStep[client] >= 1)
	//{
		//gI_skyStep[client]++
		//SetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", view_as<float>({0.0, 0.0, 0.0}))
	//}
	//if(gI_skyStep[client] == 1 && GetEntityFlags(client) & FL_ONGROUND && !(GetEntityFlags(client) & IN_DUCK))
	if(1 <= gI_skyFrame[client] <= 5)
		gI_skyFrame[client]++
	if(gI_skyFrame[client] >= 5)
	{
		gI_skyFrame[client] = 0
		gI_skyStep[client] = 0
	}
	if(gI_boost[client] && gI_skyStep[client])
	{
		gI_skyFrame[client] = 0
		gI_skyStep[client] = 0
	}
	if(gI_skyStep[client] == 1 && GetEntityFlags(client) & FL_ONGROUND && GetGameTime() - gF_boostTime[client] > 0.15)
	{
		PrintToServer("skyboost")
		/*if(gF_fallVel[client][2] > 800.0)
			gF_fallVel[client][2] = 800.0
		else if(gF_fallVel[client][2] < 750.0)
			gF_fallVel[client][2] = 750.0*/
		/*if(gF_fallVelBooster[client][2] >= 5.0) //289.993377
			gF_fallVel[client][2] = 600.0
		if(gF_fallVelBooster[client][2] >= 50.0)
			gF_fallVel[client][2] = 650.0
		if(gF_fallVelBooster[client][2] >= 100.0)
			gF_fallVel[client][2] = 700.0
		if(gF_fallVelBooster[client][2] >= 150.0) //289.993377
			gF_fallVel[client][2] = 750.0
		if(gF_fallVelBooster[client][2] >= 200.0)
		{
			gF_fallVel[client][2] = 800.0
			PrintToServer("success")
		}*/
		gF_fallVelBooster[client][2] = gF_fallVelBooster[client][2] * 4.0
		gF_fallVel[client][2] = gF_fallVelBooster[client][2]
		if(gF_fallVelBooster[client][2] > 800.0)
			gF_fallVel[client][2] = 800.0
		if(buttons & IN_JUMP)
		{
			//PrintToServer("elastisity: %f", GetEntPropFloat(client, Prop_Send, "m_flElasticity"))
			//if(!(GetEntityFlags(groundEntity) & FL_ONGROUND) && !(buttons & IN_DUCK))
			{
				//if(groundEntity == 0) //groundentity 0 = onground, ground entity > 0 = on player, groundentity -1 = in air.
					//gB_onGround[client] = false
				//if(groundEntity > 0)
					//gB_onGround[client] = true //thanks for this idea expert-zone (ed, maru)
				//if(gB_onGround[client] && gF_fallVelBooster[groundEntity][2] >= 0.0)
				{
					TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_fallVel[client])
					//if(gI_skyStep[client] == 10)
					gI_skyStep[client] = 0
					gF_fallVel[client][2] = 0.0
					gI_skyFrame[client] = 0
					PrintToServer("yes")
				}
				//if(groundEntity == 0)
				//	gB_onGround[client] = false
				//if(groundEntity > 0)
				//	gB_onGround[client] = true
				//if(groundEntity == -1)
					//gI_skyStep[client] = 0
			}
		}
	}
	//}
	//if(GetEntityFlags(client) & FL_ONGROUND && gI_boost[client] != 0)
	/*if(groundEntity == 0 && GetEntityFlags(client) & FL_ONGROUND && gI_boost[client] != 0)
	{
		gI_boost[client] = 0
		PrintToChatAll("boost step: 0")
	}*/
	//if(gI_boost[client] == 2 && !(GetEntityFlags(client) & FL_ONGROUND))
	//if(gI_boost[client] == 2 && groundEntity > MAXPLAYERS && !(GetEntityFlags(client) & FL_ONGROUND))
	//if(gI_boost[client] == 2 && groundEntity > MaxClients)
	/*if(gI_boost[client] == 8)
	{
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		gI_boost[client] = 0
		//PrintToChatAll("boost step 2 -> 0")
	}*/
	/*if(gI_boost[client] == 1 || gI_boost[client] == 2 || gI_boost[client] == 3)
	{
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		gI_boost[client]++
		//gI_boost[client] = 0
	}
	if(gI_boost[client] == 3)
		gI_boost[client] = 0*/
	/*if(1 <= gI_boost[client] <= 8)
	{
		//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		gI_boost[client]++
	}
	if(gI_boost[client] == 9)
	{
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		gI_boost[client] = 0
	}*/
	//if(1 <= gI_boost[client] <= 3)
	//{
		//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		//SetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", view_as<float>({0.0, 0.0, 0.0}))
		//SetEntPropVector(client, Prop_Data, "m_vecVelocity", view_as<float>({0.0, 0.0, 0.0}))
		//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, view_as<float>({0.0, 0.0, 0.0}))
		//gI_boost[client]++
	//}
	//if(gI_boost[client] == 4)
	//{
		//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[client])
		//gI_boost[client] = 0
		//if(gB_groundBoost[client])
			//TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, view_as<float>({0.0, 0.0, 500.0}))
	//}
	//return Plugin_Continue
}

/*Action cmd_gent(int client, int args)
{
	int gEnt = GetEntPropEnt(client, Prop_Data, "m_hGroundEntity")
	PrintToServer("%i", gEnt)
	return Plugin_Handled
}*/

/*Action ProjectileBoostFix1(int entity, int other)
{
	float vecOriginClient[3]
	GetEntPropVector(other, Prop_Data, "m_vecOrigin", vecOriginClient)
	float vecOriginEntity[3]
	GetEntPropVector(entity, Prop_Data, "m_vecOrigin", vecOriginEntity)
	float deltaOrigin = vecOriginClient[2] - vecOriginEntity[2]
	//PrintToServer("1. %f", deltaOrigin)
	float vecMaxsEntity[3]
	GetEntPropVector(entity, Prop_Data, "m_vecMaxs", vecMaxsEntity)
	PrintToServer("%f", deltaOrigin - vecMaxsEntity[2])
	//if(deltaOrigin - vecMaxsEntity[2] == 0.031250 && deltaOrigin - vecMaxsEntity[2] == 2.031250)
	//if(deltaOrigin - vecMaxsEntity[2] == 0.031250)
	if(0.031250 <= (deltaOrigin - vecMaxsEntity[2]) <= 2.031250)
	{
		float vecVelClient[3]
		GetEntPropVector(other, Prop_Data, "m_vecVelocity", vecVelClient)
		float vecVelEntity[3]
		GetEntPropVector(entity, Prop_Data, "m_vecVelocity", vecVelEntity)
		PrintToChatAll("vecVelClient: x: %f, y: %f, z: %f", vecVelClient[0], vecVelClient[1], vecVelClient[2])
		PrintToChatAll("vecVelEntity: x: %f, y: %f, z: %f", vecVelEntity[0], vecVelEntity[1], vecVelEntity[2])
		//if(vecVelClient[2] < 0.0)
		//	vecVelClient[2] = vecVelClient[2] * -1.0
		//if(vecVelEntity[2] < 0.0)
		//	vecVelEntity[2] = vecVelEntity[2] * -1.0
		float correctVel[3]
		correctVel[0] = 0.0
		correctVel[1] = 0.0
		correctVel[2] = vecVelClient[2] + vecVelEntity[2]
		if(vecVelClient[0] < 0.0 && vecVelEntity[0] < 0.0)
			vecVelClient[0] = vecVelClient[0] + vecVelEntity[0]
		if(vecVelClient[0] > 0.0 && vecVelEntity[0] > 0.0)
			vecVelClient[0] = vecVelClient[0] - vecVelEntity[0]
		if(vecVelClient[0] < 0.0 && vecVelEntity[0] > 0.0)
			vecVelClient[0] = vecVelClient[0] - vecVelEntity[0] * -1.0
		if(vecVelClient[0] > 0.0 && vecVelEntity[0] < 0.0)
			vecVelClient[0] = vecVelClient[0] + vecVelEntity[0] * -1.0

		if(vecVelClient[1] < 0.0 && vecVelEntity[1] < 0.0)
			vecVelClient[1] = vecVelClient[1] + vecVelEntity[1]
		if(vecVelClient[1] > 0.0 && vecVelEntity[1] > 0.0)
			vecVelClient[1] = vecVelClient[1] - vecVelEntity[1]
		if(vecVelClient[1] < 0.0 && vecVelEntity[1] > 0.0)
			vecVelClient[1] = vecVelClient[1] - vecVelEntity[1] * -1.0
		if(vecVelClient[1] > 0.0 && vecVelEntity[1] < 0.0)
			vecVelClient[1] = vecVelClient[1] + vecVelEntity[1] * -1.0
			
		//if(vecVelClient[2] < 0.0 && vecVelEntity[2] < 0.0)
		//	vecVelClient[2] = vecVelEntity[2]
		//if(vecVelClient[2] > 0.0 && vecVelEntity[2] > 0.0)
		//	vecVelClient[2] = vecVelEntity[2]
		//if(vecVelClient[2] < 0.0 && vecVelEntity[2] > 0.0)
		//	vecVelClient[2] = vecVelEntity[2] * -1.0
		//if(vecVelClient[2] > 0.0 && vecVelEntity[2] < 0.0)
		//	vecVelClient[2] = vecVelEntity[2] * -1.0
		//if(vecVelEntity[2] < 0.0)
		//	vecVelClient[2] = vecVelClient[2]
		//if(vecVelEntity[2] < 0.0)
		//	vecVelEntity[2] = vecVel
		//if(vecVelEntity[2] < 0.0)
		//	vecVelClient[2] = vecEntity
		if(vecVelEntity[2] < 0.0)
			vecVelClient[2] = vecVelEntity[2] * -1.0
		else
			vecVelClient[2] = vecVelEntity[2]
		//vecVelClient[2] = 
		//vecVelClient[2] = 
		//gB_getBoost[other] = true
		//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, correctVel)
		TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, vecVelClient)
		//PrintToServer("feet collide.")
	}
}*/
//int count
//void SDKHooks_TakeDamage(int entity, int inflictor, int attacker, float damage, int damageType, int weapon, const float damageForce[3], const float damagePosition[3])
//{
	//PrintToServer("%i %i %i", entity, inflictor, attacker)
//}
//void SDKOnTakeDamagePost(int victim, int attacker, int inflictor, float damage, int damagetype)
//{
	//int entity = inflictor
	//int other = victim
	//int count
	//PrintToServer("starttocuh1 %i %i %i", entity, other, count)
	//count++
	//if(!(0 < other <= MaxClients)) //if 0 < other <= MaxClients continue code. If false stop code.
	//{
		//float baseVel[3]
		//PrintToServer("yes2")
		//SetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", baseVel)
		//return Plugin_Continue
		//return
	//}
	//if(gI_boost[other] || GetEntityFlags(other) & FL_ONGROUND || GetGameTime() - gF_boostTime[other] < 0.15)
	//{
		//PrintToServer("yes1")
		//return Plugin_Continue
	//}
	//float vecOriginOther[3]
	//GetEntPropVector(other, Prop_Data, "m_vecOrigin", vecOriginOther)
	//float vecOriginEntity[3]
	//GetEntPropVector(entity, Prop_Data, "m_vecOrigin", vecOriginEntity)
	//float deltaOrigin = vecOriginOther[2] - vecOriginEntity[2]
	//float deltaOrigin = vecOriginOther[2] - vecOriginEntity[2]
	//float vecMaxs[3]
	//GetEntPropVector(entity, Prop_Data, "m_vecMaxs", vecMaxs)
	//PrintToServer("%f %i %i %N", deltaOrigin - vecMaxs[2], entity, other, other)
	//if(4.031250 >= (deltaOrigin - vecMins[2]) >= 2.031250)
	//if(-2.0 <= (deltaOrigin - vecMaxs[2]) <= 6.0)
	//if(-6.0 > (deltaOrigin - vecMaxs[2]) <= -4.031250)
	//if(deltaOrigin - vecMaxs[2] > -6.0 && deltaOrigin - vecMaxs[2] <= -2.0)
	//if(vecOriginOther[2] >= vecOriginEntity[2]) //Thanks to extremix/hornet for idea from 2019 year summer. Extremix version (if(!(clientOrigin[2] - 5 <= entityOrigin[2] <= clientOrigin[2])) //Calculate for Client/Flash - Thanks to extrem)
	//if(vecOriginOther[2] - 5 <= vecOriginEntity[2] <= vecOriginOther[2])
	//if(vecOriginOther[2] >= vecOriginEntity[2])
	//if(0.0 < deltaOrigin - vecMaxs[2] < 2.0) //tengu code from github https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L231
	//{
		//float vecVelClient[3]
		//GetEntPropVector(other, Prop_Data, "m_vecVelocity", vecVelClient)
		//float vecVelEntity[3]
		//GetEntPropVector(entity, Prop_Data, "m_vecVelocity", vecVelEntity)
		//PrintToChatAll("vecVelClient: x: %f, y: %f, z: %f", vecVelClient[0], vecVelClient[1], vecVelClient[2])
		//PrintToChatAll("vecVelEntity: x: %f, y: %f, z: %f", vecVelEntity[0], vecVelEntity[1], vecVelEntity[2])
		/*if(vecVelClient[0] < 0.0 && vecVelEntity[0] < 0.0)
			vecVelClient[0] = vecVelClient[0] - vecVelEntity[0]
		if(vecVelClient[0] > 0.0 && vecVelEntity[0] > 0.0)
			vecVelClient[0] = vecVelClient[0] + vecVelEntity[0]
		if(vecVelClient[0] < 0.0 && vecVelEntity[0] > 0.0)
			vecVelClient[0] = vecVelClient[0] - vecVelEntity[0] * -1.0
		if(vecVelClient[0] > 0.0 && vecVelEntity[0] < 0.0)
			vecVelClient[0] = vecVelClient[0] + vecVelEntity[0] * -1.0

		if(vecVelClient[1] < 0.0 && vecVelEntity[1] < 0.0)
			vecVelClient[1] = vecVelClient[1] - vecVelEntity[1]
		if(vecVelClient[1] > 0.0 && vecVelEntity[1] > 0.0)
			vecVelClient[1] = vecVelClient[1] + vecVelEntity[1]
		if(vecVelClient[1] < 0.0 && vecVelEntity[1] > 0.0)
			vecVelClient[1] = vecVelClient[1] - vecVelEntity[1] * -1.0
		if(vecVelClient[1] > 0.0 && vecVelEntity[1] < 0.0)
			vecVelClient[1] = vecVelClient[1] + vecVelEntity[1] * -1.0
		
		//if(vecVelEntity[2] < 0.0)
		//	vecVelClient[2] = vecVelEntity[2] * -1.0
		//else
		//	vecVelClient[2] = vecVelEntity[2]
		if(vecVelClient[2] < 0.0 && vecVelEntity[2] < 0.0)
			vecVelClient[2] = vecVelEntity[2]
		if(vecVelClient[2] > 0.0 && vecVelEntity[2] > 0.0)
			vecVelClient[2] = vecVelEntity[2]
		if(vecVelClient[2] < 0.0 && vecVelEntity[2] > 0.0)
			vecVelClient[2] = vecVelEntity[2] * -1.0
		if(vecVelClient[2] > 0.0 && vecVelEntity[2] < 0.0)
			vecVelClient[2] = vecVelEntity[2] * -1.0
			
		if(vecVelClient[0] == 0.0 && vecVelClient[1] == 0.0 && vecVelClient[2] == 0.0)
		{
			vecVelClient[0] = vecVelEntity[0] * -1.0
			vecVelClient[1] = vecVelEntity[1] * -1.0
			vecVelClient[2] = vecVelEntity[2]
		}*/
		//gB_isEndTouchBoost[other][entity] = true
		//int groundEntity = GetEntPropEnt(other, Prop_Data, "m_hGroundEntity")
		//PrintToChatAll("groundEntity: %i", groundEntity)
		//if(gB_isEndTouchBoost[other][entity] && gI_boost[other] == 0 && groundEntity == entity)
		//if(gI_boost[other] == 0)
		//{
			//return Plugin_Handled
			//for(int i = 0; i <= 1; i++)
				//if(vecVelEntity[i] >= 0.0)
					//vecVelClient[i] = (FloatAbs(vecVelEntity[i]) * 0.8 + FloatAbs(vecVelClient[i])) * -1.0
				//else if(vecVelEntity[i] < 0.0)
					//vecVelClient[i] = FloatAbs(vecVelEntity[i]) * 0.8 + FloatAbs(vecVelClient[i])
			//for(int i = 0; i <= 2; i++)
			//if(vecVelClient[2] >= 0.0)
			//vecVelClient[2] = FloatAbs(vecVelEntity[2])
			/*for(int i = 0; i <= 1; i++)
				if(vecVelClient[i] >= 0.0)
					vecVelClient[i] = FloatAbs(vecVelClient[i]) * -0.135
				else if(vecVelClient[i] < 0.0)
					vecVelClient[i] = FloatAbs(vecVelClient[i]) * 0.135
			//else if(vecVelClient[2] < 0.0)
				//vecVelClient[2] = -vecVelEntity[2]
			//for()
			vecVelClient[2] = FloatAbs(vecVelClient[2]) * 0.135*/
			//for(int i = 0; i <= 2; i++)
				//gF_vecVelBoostFix[other][i] = vecVelClient[i]
			//gI_boost[other] = 1
			//gI_skyStep[other] = 0
			//gF_boostTime[other] = GetGameTime()
			//gB_groundBoost[other] = gB_bouncedOff[entity]
			//PrintToChatAll("start touch %i", count)
			//SetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", view_as<float>({0.0, 0.0, 0.0}))
			//SetEntPropVector(other, Prop_Data, "m_vecVelocity", view_as<float>({0.0, 0.0, 0.0}))
			//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, view_as<float>({0.0, 0.0, 0.0}))
			//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[other])
			//if(gB_groundBoost[other])
			//{
				//float vecVelClient[3]
				//GetEntPropVector(other, Prop_Data, "m_vecVelocity", vecVelClient)
				//float vecVelEntity[3]
				//GetEntPropVector(entity, Prop_Data, "m_vecVelocity", vecVelEntity)
				//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, view_as<float>({0.0, 0.0, 0.0}))
				//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, vecVelClient)
			//}
			//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, vecVelClient)
			//PrintToChatAll("boost step 0 -> 1")
			//PrintToChatAll("success boost fix")
			//PrintToChatAll("elastisity of nade: %f", GetEntPropFloat(entity, Prop_Data, "m_flElasticity")) //https://forums.alliedmods.net/showthread.php?t=146241
			//PrintToChatAll("player elasticity: %f", GetEntPropFloat(other, Prop_Data, "m_flElasticity"))
			//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, vecVelClient)
		//}
		//return Plugin_Continue
	//}
	//else
	//{
		//float vecBase[3]
		//SetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", vecBase)
	//}
	//return Plugin_Continue
//}
int count
Action ProjectileBoostFix(int entity, int other)
{
	if(!IsClientValid(other))
		return Plugin_Continue
	//int count
	//PrintToServer("starttocuh1 %i %i %i", entity, other, count)
	//count++
	//if(other == 0)
	//{
		//SetEntProp(entity, Prop_Data, "m_nSolidType", 2)
		//return Plugin_Handled
	//}
	//if(GetGameTime() - gF_boostTime[other] < 0.15)
		//return Plugin_Handled
	//PrintToServer("%i other", other)
	//if(other == 0)
		//return Plugin_Continue
	//if(!IsClientInGame(other) && !IsPlayerAlive(other))
	//	return Plugin_Continue
	//if(gI_boost[other] || GetEntityFlags(other) & FL_ONGROUND)
	if(gI_boost[other] || gI_entityFlags[other] & FL_ONGROUND)
		return Plugin_Continue
	//if(0 < other <= MaxClients && IsClientInGame(other) && IsPlayerAlive(other)) //if 0 < other <= MaxClients continue code. If false stop code.
	{
		//if(gI_boost[other] || GetEntityFlags(other) & FL_ONGROUND || GetGameTime() - gF_boostTime[other] < 0.15)
		//{
			//PrintToServer("yes1")
			//return Plugin_Continue
		//}
		PrintToServer("%i %N [%i]", other, other, count)
		count++
		float vecOriginOther[3]
		//GetEntPropVector(other, Prop_Send, "m_vecOrigin", vecOriginOther)
		GetClientAbsOrigin(other, vecOriginOther)
		float vecOriginEntity[3]
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", vecOriginEntity)
		//GetEntityAbsOrigin
		//float deltaOrigin = vecOriginOther[2] - vecOriginEntity[2]
		//float deltaOrigin = vecOriginOther[2] - vecOriginEntity[2]
		float vecMaxs[3]
		GetEntPropVector(entity, Prop_Send, "m_vecMaxs", vecMaxs)
		//PrintToServer("%f %i %i %N", deltaOrigin - vecMaxs[2], entity, other, other)
		//if(4.031250 >= (deltaOrigin - vecMins[2]) >= 2.031250)
		//if(-2.0 <= (deltaOrigin - vecMaxs[2]) <= 6.0)
		//if(-6.0 > (deltaOrigin - vecMaxs[2]) <= -4.031250)
		//if(deltaOrigin - vecMaxs[2] > -6.0 && deltaOrigin - vecMaxs[2] <= -2.0)
		//if(vecOriginOther[2] >= vecOriginEntity[2]) //Thanks to extremix/hornet for idea from 2019 year summer. Extremix version (if(!(clientOrigin[2] - 5 <= entityOrigin[2] <= clientOrigin[2])) //Calculate for Client/Flash - Thanks to extrem)
		//if(vecOriginOther[2] - 5 <= vecOriginEntity[2] <= vecOriginOther[2])
		//if(vecOriginOther[2] >= vecOriginEntity[2])
		//if(0.0 < (deltaOrigin - vecMaxs[2]) < 2.0) //tengu code from github https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L231
		//if(vecOriginOther[2] >= vecOriginEntity[2])
		float delta = vecOriginOther[2] - vecOriginEntity[2] - vecMaxs[2]
		//if(0.0 < (vecOriginOther[2] - vecOriginEntity[2] - vecMaxs[2]) < 2.0)
		if(0.0 < delta && delta < 2.0)
		{
			float vecVelClient[3]
			GetEntPropVector(other, Prop_Data, "m_vecAbsVelocity", vecVelClient)
			float vecVelEntity[3]
			GetEntPropVector(entity, Prop_Data, "m_vecAbsVelocity", vecVelEntity)
			//PrintToChatAll("vecVelClient: x: %f, y: %f, z: %f", vecVelClient[0], vecVelClient[1], vecVelClient[2])
			//PrintToChatAll("vecVelEntity: x: %f, y: %f, z: %f", vecVelEntity[0], vecVelEntity[1], vecVelEntity[2])
			/*if(vecVelClient[0] < 0.0 && vecVelEntity[0] < 0.0)
				vecVelClient[0] = vecVelClient[0] - vecVelEntity[0]
			if(vecVelClient[0] > 0.0 && vecVelEntity[0] > 0.0)
				vecVelClient[0] = vecVelClient[0] + vecVelEntity[0]
			if(vecVelClient[0] < 0.0 && vecVelEntity[0] > 0.0)
				vecVelClient[0] = vecVelClient[0] - vecVelEntity[0] * -1.0
			if(vecVelClient[0] > 0.0 && vecVelEntity[0] < 0.0)
				vecVelClient[0] = vecVelClient[0] + vecVelEntity[0] * -1.0

			if(vecVelClient[1] < 0.0 && vecVelEntity[1] < 0.0)
				vecVelClient[1] = vecVelClient[1] - vecVelEntity[1]
			if(vecVelClient[1] > 0.0 && vecVelEntity[1] > 0.0)
				vecVelClient[1] = vecVelClient[1] + vecVelEntity[1]
			if(vecVelClient[1] < 0.0 && vecVelEntity[1] > 0.0)
				vecVelClient[1] = vecVelClient[1] - vecVelEntity[1] * -1.0
			if(vecVelClient[1] > 0.0 && vecVelEntity[1] < 0.0)
				vecVelClient[1] = vecVelClient[1] + vecVelEntity[1] * -1.0
			
			//if(vecVelEntity[2] < 0.0)
			//	vecVelClient[2] = vecVelEntity[2] * -1.0
			//else
			//	vecVelClient[2] = vecVelEntity[2]
			if(vecVelClient[2] < 0.0 && vecVelEntity[2] < 0.0)
				vecVelClient[2] = vecVelEntity[2]
			if(vecVelClient[2] > 0.0 && vecVelEntity[2] > 0.0)
				vecVelClient[2] = vecVelEntity[2]
			if(vecVelClient[2] < 0.0 && vecVelEntity[2] > 0.0)
				vecVelClient[2] = vecVelEntity[2] * -1.0
			if(vecVelClient[2] > 0.0 && vecVelEntity[2] < 0.0)
				vecVelClient[2] = vecVelEntity[2] * -1.0
				
			if(vecVelClient[0] == 0.0 && vecVelClient[1] == 0.0 && vecVelClient[2] == 0.0)
			{
				vecVelClient[0] = vecVelEntity[0] * -1.0
				vecVelClient[1] = vecVelEntity[1] * -1.0
				vecVelClient[2] = vecVelEntity[2]
			}*/
			//gB_isEndTouchBoost[other][entity] = true
			//int groundEntity = GetEntPropEnt(other, Prop_Data, "m_hGroundEntity")
			//PrintToChatAll("groundEntity: %i", groundEntity)
			//if(gB_isEndTouchBoost[other][entity] && gI_boost[other] == 0 && groundEntity == entity)
			//if(gI_boost[other] == 0)
			{
				//return Plugin_Handled
				/*for(int i = 0; i <= 1; i++)
					if(vecVelClient[i] >= 0.0)
						vecVelClient[i] = FloatAbs(vecVelEntity[i]) * 0.8 + FloatAbs(vecVelClient[i])
					else if(vecVelClient[i] < 0.0)
						vecVelClient[i] = (FloatAbs(vecVelEntity[i]) * 0.8 + FloatAbs(vecVelClient[i])) * -1.0*/
				gI_boost[other] = 1
				vecVelClient[0] -= vecVelEntity[0] * (GetEntPropFloat(other, Prop_Data, "m_flElasticity") - (GetEntPropFloat(entity, Prop_Data, "m_flElasticity") * 0.1)) //player elasticity always is 1.0, other is player.
				vecVelClient[1] -= vecVelEntity[1] * (GetEntPropFloat(other, Prop_Data, "m_flElasticity") - (GetEntPropFloat(entity, Prop_Data, "m_flElasticity") * 0.1)) //player elasticity always is 1.0, other is player.
				//for(int i = 0; i <= 2; i++)
				//if(vecVelClient[2] >= 0.0)
				vecVelClient[2] = FloatAbs(vecVelEntity[2]) * (GetEntPropFloat(other, Prop_Data, "m_flElasticity") - (GetEntPropFloat(entity, Prop_Data, "m_flElasticity") * 0.1)) //player elasticity always is 1.0 , other is player.
				//vecVelClient[2] += vecVelEntity[2] * 0.97
				//vecVelClient[2] -= vecVelEntity[2] * 0.9
				/*for(int i = 0; i <= 1; i++)
					if(vecVelClient[i] >= 0.0)
						vecVelClient[i] = FloatAbs(vecVelClient[i]) * -0.135
					else if(vecVelClient[i] < 0.0)
						vecVelClient[i] = FloatAbs(vecVelClient[i]) * 0.135
				//else if(vecVelClient[2] < 0.0)
					//vecVelClient[2] = -vecVelEntity[2]
				//for()
				vecVelClient[2] = FloatAbs(vecVelClient[2]) * 0.135*/
				for(int i = 0; i <= 2; i++)
					gF_vecVelBoostFix[other][i] = vecVelClient[i]
				
				//gI_skyStep[other] = 0
				gF_boostTime[other] = GetGameTime()
				gB_groundBoost[other] = gB_bouncedOff[entity]
				SetEntProp(entity, Prop_Send, "m_nSolidType", 0) //https://forums.alliedmods.net/showthread.php?t=286568 non model no solid model Gray83 author of solid model types.
				gI_flash[other] = EntIndexToEntRef(entity) //check this for postthink post to correct set first telelportentity speed. starttouch have some outputs only one of them is coorect wich gives correct other(player) id.
				//PrintToChatAll("start touch %i", count)//Whe just make filter for 0 other id.
				//SetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", view_as<float>({0.0, 0.0, 0.0}))
				//SetEntPropVector(other, Prop_Data, "m_vecVelocity", view_as<float>({0.0, 0.0, 0.0}))
				//float zVelMinus[3]
				//zVelMinus[2] = vecVelClient[2] * -1.0
				//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, zVelMinus)
				//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, gF_vecVelBoostFix[other])
				//if(gB_groundBoost[other])
				//{
					//float vecVelClient[3]
					//GetEntPropVector(other, Prop_Data, "m_vecVelocity", vecVelClient)
					//float vecVelEntity[3]
					//GetEntPropVector(entity, Prop_Data, "m_vecVelocity", vecVelEntity)
					//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, view_as<float>({0.0, 0.0, 0.0}))
					//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, vecVelClient)
				//}
				//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, vecVelClient)
				//PrintToChatAll("boost step 0 -> 1")
				//PrintToChatAll("success boost fix")
				//PrintToChatAll("elastisity of nade: %f", GetEntPropFloat(entity, Prop_Data, "m_flElasticity")) //https://forums.alliedmods.net/showthread.php?t=146241
				//PrintToChatAll("player elasticity: %f", GetEntPropFloat(other, Prop_Data, "m_flElasticity"))
				//TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, vecVelClient)
			}
			//float baseVel[3]
			//SetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", baseVel)
			//return Plugin_Continue
		}
	}
	//else
	//{
	//	float vecBase[3]
		//SetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", vecBase)
	//}
	//if(GetGameTime() - gF_boostTime[other] < 0.15)
	//{
		//float vecBase[3]
		//SetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", vecBase)
		//return Plugin_Handled
	//}
	return Plugin_Continue
}

Action ProjectileBoostFixEndTouch(int entity, int other)
{
	if(!other)
		gB_bouncedOff[entity] = true //get from tengu github tengulawl scriptig boost-fix.sp
}

/*Action cmd_vectest2(int client, int args)
{
	PrintToServer("%f", 2.0 * -1.0 - 1.0)
	return Plugin_Handled
}*/

Action cmd_time(int client, int args)
{
	//char sTime[32]
	//FormatTime(sTime, 32, NULL_STRING, )
	//if(gF_Time[client] > 59.9)
	//Format(sTime, 32, "" //https://forums.alliedmods.net/archive/index.php/t-23912.html //ShAyA format OneEyed format second
	int hour = RoundToFloor(gF_Time[client])
	gI_hour = (hour / 3600) % 24
	int minute = RoundToFloor(gF_Time[client])
	gI_minute = (minute / 60) % 60
	int second = RoundToFloor(gF_Time[client])
	gI_second = second % 60 //https://forums.alliedmods.net/archive/index.php/t-187536.html
	PrintToChat(client, "Time: %f [%02.i:%02.i:%02.i]", gF_Time[client], gI_hour, gI_minute, gI_second)
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if(StrEqual(classname, "flashbang_projectile"))
	{
		gB_bouncedOff[entity] = false //tengu lawl boost fix .sp
		SDKHook(entity, SDKHook_Spawn, SDKProjectile)
		SDKHook(entity, SDKHook_StartTouch, ProjectileBoostFix)
		SDKHook(entity, SDKHook_EndTouch, ProjectileBoostFixEndTouch)
	}
}

Action SDKProjectile(int entity)
{
	int client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity")
	
	if(!IsValidEntity(entity) || !IsPlayerAlive(client))
		return
	//if(GetEntData(client, FindDataMapInfo(client, "m_iAmmo"),
	//GivePlayerItem(client, "weapon_flashbang")
	SetEntData(client, FindDataMapInfo(client, "m_iAmmo") + 12 * 4, 2)
	//GivePlayerAmmo(client, 2, 48, true)
	FakeClientCommand(client, "use weapon_knife")
	SetEntProp(client, Prop_Data, "m_bDrawViewmodel", 0) //thanks to alliedmodders. 2019 //https://forums.alliedmods.net/archive/index.php/t-287052.html
	ClientCommand(client, "lastinv") //hornet, log idea, main idea Nick Yurevich since 2019, hornet found ClientCommand - lastinv
	SetEntProp(client, Prop_Data, "m_bDrawViewmodel", 1)
	CreateTimer(1.5, timer_delete, EntIndexToEntRef(entity)) //sometimes flashbang going to flash, entindextoentref must fix it.
}

Action timer_delete(Handle timer, int entity)
{
	entity = EntRefToEntIndex(entity)
	if(IsValidEntity(entity))
		RemoveEntity(entity)
	return Plugin_Stop
}

void SDKPlayerSpawn(int client)
{
	//if(GetEntProp(client, Prop_Data, "m_iAmmo", 
	if(GetEntData(client, FindDataMapInfo(client, "m_iAmmo") + 12 * 4) == 0)
	{
		//PrintToServer("%i", GetEntData(client, FindDataMapInfo(client, "m_iAmmo") + 12 * 4))
		GivePlayerItem(client, "weapon_flashbang")
		//PrintToServer("%i", GetEntData(client, FindDataMapInfo(client, "m_iAmmo") + 12 * 4))
		GivePlayerItem(client, "weapon_flashbang")
		//PrintToServer("%i", GetEntData(client, FindDataMapInfo(client, "m_iAmmo") + 12 * 4))
	}
	SetEntData(client, FindDataMapInfo(client, "m_iAmmo") + 12 * 4, 2) //https://forums.alliedmods.net/showthread.php?t=114527 https://forums.alliedmods.net/archive/index.php/t-81546.html
	//GivePlayerAmmo(client, 2, 48, true)
}

Action SDKOnTakeDamage(int victim, int& attacker, int& inflictor, float& damage, int& damagetype)
{
	SetEntPropVector(victim, Prop_Send, "m_vecPunchAngle", NULL_VECTOR) //https://forums.alliedmods.net/showthread.php?p=1687371
	SetEntPropVector(victim, Prop_Send, "m_vecPunchAngleVel", NULL_VECTOR)
	return Plugin_Handled
}

Action SoundHook(int clients[MAXPLAYERS], int& numClients, char sample[PLATFORM_MAX_PATH], int& entity, int& channel, float& volume, int& level, int& pitch, int& flags, char soundEntry[PLATFORM_MAX_PATH], int& seed) //https://github.com/alliedmodders/sourcepawn/issues/476
{
	if(StrEqual(sample, "weapons/knife/knife_deploy1.wav"))
		return Plugin_Handled
	return Plugin_Continue
}
