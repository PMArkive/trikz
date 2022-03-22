/*
	GNU GENERAL PUBLIC LICENSE

	VERSION 2, JUNE 1991

	Copyright (C) 1989, 1991 Free Software Foundation, Inc.
	51 Franklin Street, Fith Floor, Boston, MA 02110-1301, USA

	Everyone is permitted to copy and distribute verbatim copies
	of this license document, but changing it is not allowed.

	GNU GENERAL PUBLIC LICENSE VERSION 3, 29 June 2007
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
	your programs, too.
*/
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <clientprefs>

#pragma semicolon 1
#pragma newdecls required
//#define MAXPLAYER = {MAXPLAYER}
#define MAXPLAYER MAXPLAYERS+1

int g_partner[MAXPLAYER];
float g_partnerInHold[MAXPLAYER];
bool g_partnerInHoldLock[MAXPLAYER];
float g_zoneStartOrigin[2][3];
float g_zoneEndOrigin[2][3];
Database g_mysql;
float g_timerTimeStart[MAXPLAYER];
float g_timerTime[MAXPLAYER];
bool g_state[MAXPLAYER];
char g_map[192];
bool g_mapFinished[MAXPLAYER];
bool g_dbPassed;
float g_originStart[3];
float g_boostTime[MAXPLAYER];
float g_skyVel[MAXPLAYER][3];
bool g_readyToStart[MAXPLAYER];

float g_cpPos[2][24][3];
bool g_cp[11][MAXPLAYER];
bool g_cpLock[11][MAXPLAYER];
float g_cpTimeClient[11][MAXPLAYER];
float gF_cpDiff[11][MAXPLAYER];
float g_cpTime[11];

float g_haveRecord[MAXPLAYER];
float g_ServerRecordTime;

//ConVar g_steamid; //https://wiki.alliedmods.net/ConVars_(SourceMod_Scripting)
ConVar g_urlTop;

bool g_menuOpened[MAXPLAYER];

int g_boost[MAXPLAYER];
int g_skyBoost[MAXPLAYER];
bool g_bouncedOff[2048 + 1];
bool g_groundBoost[MAXPLAYER];
int g_flash[MAXPLAYER];
int g_entityFlags[MAXPLAYER];
int g_devmapCount[2];
bool g_devmap;
float g_devmapTime;

float g_cpOrigin[MAXPLAYER][2][3];
float g_cpAng[MAXPLAYER][2][3];
float g_cpVel[MAXPLAYER][2][3];
bool g_cpToggled[MAXPLAYER][2];

bool g_zoneHave[3];

bool g_ServerRecord;
char g_date[64];
char g_time[64];

bool g_silentKnife;
float g_mateRecord[MAXPLAYER];
bool g_sourcetv;
bool g_block[MAXPLAYER];
//int g_wModelThrown;
//int g_class[MAXPLAYER];
//bool g_color[MAXPLAYER][2];
//int g_wModelPlayer[5];
//int g_pingModel[MAXPLAYER];
//int g_pingModelOwner[2048 + 1];
//Handle g_pingTimer[MAXPLAYER];

bool g_zoneFirst[3];

//char g_colorType[][] = {"255,255,255,white", "255,0,0,red", "255,165,0,orange", "255,255,0,yellow", "0,255,0,lime", "0,255,255,aqua", "0,191,255,deep sky blue", "0,0,255,blue", "255,0,255,magenta"}; //https://flaviocopes.com/rgb-color-codes/#:~:text=A%20table%20summarizing%20the%20RGB%20color%20codes%2C%20which,%20%20%28178%2C34%2C34%29%20%2053%20more%20rows%20
//int g_colorBuffer[MAXPLAYER][3][2];
//int g_colorCount[MAXPLAYER][2];

//int g_zoneModel[3];
//int g_laserBeam;
bool g_sourcetvchangedFileName = true;
float g_entityVel[MAXPLAYER][3];
float g_clientVel[MAXPLAYER][3];
int g_cpCount;
//ConVar g_turbophysics;
float g_afkTime;
bool g_afk[MAXPLAYER];
float g_center[12][3];
bool g_zoneDraw[MAXPLAYER];
//float g_engineTime;
//float g_pingTime[MAXPLAYER];
//bool g_pingLock[MAXPLAYER];
bool g_msg[MAXPLAYER];
int g_voters;
int g_afkClient;
bool g_hudVel[MAXPLAYER];
float g_hudTime[MAXPLAYER];
char g_clantag[MAXPLAYER][2][256];
//Handle g_clantagTimer[MAXPLAYER];
float g_mlsVel[MAXPLAYER][2][2];
int g_mlsCount[MAXPLAYER];
char g_mlsPrint[MAXPLAYER][100][256];
int g_mlsFlyer[MAXPLAYER];
bool g_mlstats[MAXPLAYER];
float g_mlsDistance[MAXPLAYER][2][3];
bool g_button[MAXPLAYER];
bool g_pbutton[MAXPLAYER];
float g_skyOrigin[MAXPLAYER];
int g_entityButtons[MAXPLAYER];
bool g_teleported[MAXPLAYER];
int g_points[MAXPLAYER];
Handle g_start;
Handle g_record;
int g_pointsMaxs = 1;
int g_queryLast;
Handle g_cookie[8];
float g_skyAble[MAXPLAYER];
native bool Trikz_GetEntityFilter(int client, int entity);
float g_restartInHold[MAXPLAYER];
bool g_restartInHoldLock[MAXPLAYER];
int g_smoke;
bool g_clantagOnce[MAXPLAYER];
//bool g_seperate[MAXPLAYER];
int g_projectileSoundLoud[MAXPLAYER];
bool g_readyToFix[MAXPLAYER];
ConVar gCV_trikz;
ConVar gCV_block;
ConVar gCV_partner;
ConVar gCV_color;
ConVar gCV_restart;
ConVar gCV_checkpoint;
ConVar gCV_afk;
ConVar gCV_noclip;
ConVar gCV_spec;
ConVar gCV_button;
ConVar gCV_pbutton;
ConVar gCV_bhop;
ConVar gCV_autoswitch;
ConVar gCV_autoflashbang;
bool g_autoflash[MAXPLAYER];
bool g_autoswitch[MAXPLAYER];
bool g_bhop[MAXPLAYER];
ConVar gCV_macro;
bool g_macroDisabled[MAXPLAYER];
float g_macroTime[MAXPLAYER];
bool g_macroOpened[MAXPLAYER];
#define debug false

public Plugin myinfo =
{
	name = "TrueExpert",
	author = "Niks Smesh Jurēvičs",
	description = "Allows to able make trikz more comfortable.",
	version = "3.9",
	url = "http://www.sourcemod.net/"
}

public void OnPluginStart()
{
	//g_steamid = CreateConVar("steamid", "", "Set steamid for control the plugin ex. 120192594. Use status to check your uniqueid, without 'U:1:'.", 0.0, false, 1.0, true);
	//g_urlTop = CreateConVar("topurl", "", "Set url for top for ex (http://www.fakeexpert.rf.gd/?start=0&map=). To open page, type in game chat !top", 0.0, false, 1.0, true);
	gCV_trikz = CreateConVar("trikz", "0.0", "Trikz menu.", 0, false, 0.0, true, 1.0);
	gCV_block = CreateConVar("block", "0.0", "Toggling block state.", 0, false, 0.0, true, 1.0);
	gCV_partner = CreateConVar("partner", "0.0", "Toggling partner menu.", 0, false, 0.0, true, 1.0);
	gCV_color = CreateConVar("color", "0.0", "Toggling color menu.", 0, false, 0.0, true, 1.0);
	gCV_restart = CreateConVar("restartZ", "0.0", "Allow player to restart timer.", 0, false, 0.0, true, 1.0);
	gCV_checkpoint = CreateConVar("checkpoint", "0.0", "Allow use checkpoint in dev mode.", 0, false, 0.0, true, 1.0);
	gCV_afk = CreateConVar("afk", "0.0", "Allow to use !afk command for players.", 0, false, 0.0, true, 1.0);
	gCV_noclip = CreateConVar("noclipZ", "0.0", "Allow to use noclip for players in dev mode.", 0, false, 0.0, true, 1.0);
	gCV_spec = CreateConVar("spec", "0.0", "Allow to use spectator command to swtich to the spectator team.", 0, false, 0.0, true, 1.0);
	gCV_button = CreateConVar("button", "0.0", "Allow to use text message for button announcments.", 0, false, 0.0, true, 1.0);
	gCV_pbutton = CreateConVar("pbutton", "0.0", "Allow to use text message for partner button announcments.", 0, false, 0.0, true, 1.0);
	gCV_bhop = CreateConVar("bhop", "0.0", "Autobhop.", 0, false, 0.0, true, 1.0);
	gCV_autoswitch = CreateConVar("autoswitch", "0.0", "Allow to switch to the flashbang automaticly.", 0, false, 0.0, true, 1.0);
	gCV_autoflashbang = CreateConVar("autoflashbang", "0.0", "Allow to give auto flashbangs.", 0, false, 0.0, true, 1.0);
	gCV_macro = CreateConVar("sm_te_macro", "0.0", "Allow to use macro for each player.", 0, false, 0.0, true, 1.0);
	
	AutoExecConfig(true); //https://sm.alliedmods.net/new-api/sourcemod/AutoExecConfig

	RegConsoleCmd("sm_t", cmd_trikz);
	RegConsoleCmd("sm_trikz", cmd_trikz);
	RegConsoleCmd("sm_bl", cmd_block);
	RegConsoleCmd("sm_block", cmd_block);
	RegConsoleCmd("sm_p", cmd_partner);
	RegConsoleCmd("sm_partner", cmd_partner);
	//RegConsoleCmd("sm_c", cmd_color);
	//RegConsoleCmd("sm_color", cmd_color);
	RegConsoleCmd("sm_r", cmd_restart);
	RegConsoleCmd("sm_restart", cmd_restart);
	RegConsoleCmd("sm_autoflash", cmd_autoflash);	
	RegConsoleCmd("sm_autoswitch", cmd_autoswitch);
	//RegConsoleCmd("sm_time", cmd_time);
	RegConsoleCmd("sm_cp", cmd_checkpoint);
	RegConsoleCmd("sm_devmap", cmd_devmap);
	RegConsoleCmd("sm_top", cmd_top);
	RegConsoleCmd("sm_afk", cmd_afk);
	RegConsoleCmd("sm_nc", cmd_noclip);
	RegConsoleCmd("sm_noclip", cmd_noclip);
	RegConsoleCmd("sm_sp", cmd_spec);
	RegConsoleCmd("sm_spec", cmd_spec);
	RegConsoleCmd("sm_hud", cmd_hud);
	RegConsoleCmd("sm_mls", cmd_mlstats);
	RegConsoleCmd("sm_button", cmd_button);
	RegConsoleCmd("sm_pbutton", cmd_pbutton);
	RegConsoleCmd("sm_macro", cmd_macro);
	RegConsoleCmd("sm_bhop", cmd_bhop);

	RegServerCmd("sm_createzones", cmd_createzones);
	RegServerCmd("sm_createusers", cmd_createusers);
	RegServerCmd("sm_createrecords", cmd_createrecords);
	RegServerCmd("sm_createcp", cmd_createcp);
	RegServerCmd("sm_createtier", cmd_createtier);

	RegConsoleCmd("sm_startmins", cmd_startmins);
	RegConsoleCmd("sm_startmaxs", cmd_startmaxs);
	RegConsoleCmd("sm_endmins", cmd_endmins);
	RegConsoleCmd("sm_endmaxs", cmd_endmaxs);
	RegConsoleCmd("sm_cpmins", cmd_cpmins);
	RegConsoleCmd("sm_cpmaxs", cmd_cpmaxs);
	RegConsoleCmd("sm_zones", cmd_zones);
	RegConsoleCmd("sm_maptier", cmd_maptier);
	RegConsoleCmd("sm_deleteallcp", cmd_deleteallcp);
	RegConsoleCmd("sm_test", cmd_test);

	AddNormalSoundHook(OnSound);

	HookUserMessage(GetUserMessageId("SayText2"), OnSayMessage, true); //thanks to VerMon idea. https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-chat.sp#L416
	
	HookEvent("player_spawn", OnSpawn);
	HookEntityOutput("func_button", "OnPressed", OnButton);
	HookEvent("player_jump", OnJump);
	HookEvent("player_death", OnDeath);

	AddCommandListener(joinclass, "joinclass");
	AddCommandListener(autobuy, "autobuy");
	AddCommandListener(rebuy, "rebuy");
	AddCommandListener(cheer, "cheer");
	AddCommandListener(showbriefing, "showbriefing");
	AddCommandListener(headtrack_reset_home_pos, "headtrack_reset_home_pos");

	char output[5][16] = {"OnStartTouch", "OnEndTouchAll", "OnTouching", "OnStartTouch", "OnTrigger"};

	for(int i = 0; i < sizeof(output); i++)
	{
		HookEntityOutput("trigger_teleport", output[i], output_teleport); //https://developer.valvesoftware.com/wiki/Trigger_teleport
		HookEntityOutput("trigger_teleport_relative", output[i], output_teleport); //https://developer.valvesoftware.com/wiki/Trigger_teleport_relative
	}

	LoadTranslations("trueexpert.phrases"); //https://wiki.alliedmods.net/Translations_(SourceMod_Scripting)

	g_start = CreateGlobalForward("Trikz_Start", ET_Hook, Param_Cell);
	g_record = CreateGlobalForward("Trikz_Record", ET_Hook, Param_Cell, Param_Float);

	RegPluginLibrary("trueexpert");

	g_cookie[0] = RegClientCookie("vel", "velocity in hint", CookieAccess_Protected);
	g_cookie[1] = RegClientCookie("mls", "mega long stats", CookieAccess_Protected);
	g_cookie[2] = RegClientCookie("button", "button", CookieAccess_Protected);
	g_cookie[3] = RegClientCookie("pbutton", "partner button", CookieAccess_Protected);
	g_cookie[4] = RegClientCookie("autoflash", "autoflash", CookieAccess_Protected);
	g_cookie[5] = RegClientCookie("autoswitch", "autoswitch", CookieAccess_Protected);
	g_cookie[6] = RegClientCookie("bhop", "bhop", CookieAccess_Protected);
	g_cookie[7] = RegClientCookie("macro", "macro", CookieAccess_Protected);

	CreateTimer(60.0, timer_clearlag);
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("Trikz_GetClientButtons", Native_GetClientButtons);
	CreateNative("Trikz_GetClientPartner", Native_GetClientPartner);
	CreateNative("Trikz_GetTimerState", Native_GetTimerState);
	CreateNative("Trikz_SetPartner", Native_SetPartner);
	CreateNative("Trikz_Restart", Native_Restart);
	CreateNative("Trikz_GetDevmap", Native_GetDevmap);

	MarkNativeAsOptional("Trikz_GetEntityFilter");

	return APLRes_Success;
}

public void OnMapStart()
{
	GetCurrentMap(g_map, sizeof(g_map));
	Database.Connect(SQLConnect, "trueexpert");

	for(int i = 0; i <= 2; i++)
	{
		g_zoneHave[i] = false;

		if(g_devmap == true)
		{
			g_zoneFirst[i] = false;
		}
	}

	ConVar CV_sourcetv = FindConVar("tv_enable");
	bool sourcetv = CV_sourcetv.BoolValue; //https://github.com/alliedmodders/sourcemod/blob/master/plugins/funvotes.sp#L280

	if(sourcetv == true)
	{
		if(g_sourcetvchangedFileName == false)
		{
			char filenameOld[256];
			Format(filenameOld, sizeof(filenameOld), "%s-%s-%s.dem", g_date, g_time, g_map);

			char filenameNew[256];
			Format(filenameNew, sizeof(filenameNew), "%s-%s-%s-ServerRecord.dem", g_date, g_time, g_map);

			RenameFile(filenameNew, filenameOld);

			g_sourcetvchangedFileName = true;
		}

		if(g_devmap == false)
		{
			PrintToServer("sourcetv start recording.");

			FormatTime(g_date, sizeof(g_date), "%Y-%m-%d", GetTime());
			FormatTime(g_time, sizeof(g_time), "%H-%M-%S", GetTime());

			ServerCommand("tv_record %s-%s-%s", g_date, g_time, g_map); //https://www.youtube.com/watch?v=GeGd4KOXNb8 https://forums.alliedmods.net/showthread.php?t=59474 https://www.php.net/strftime
		}
	}

	if(g_sourcetv == false && sourcetv == false)
	{
		g_sourcetv = true;

		ForceChangeLevel(g_map, "Turn on sourcetv");
	}

	//g_wModelThrown = PrecacheModel("models/trueexpert/models/weapons/w_eq_flashbang_thrown.mdl", true);

	//g_wModelPlayer[1] = PrecacheModel("models/trueexpert/player/ct_urban.mdl", true);
	//g_wModelPlayer[2] = PrecacheModel("models/trueexpert/player/ct_gsg9.mdl", true);
	//g_wModelPlayer[3] = PrecacheModel("models/trueexpert/player/ct_sas.mdl", true);
	//g_wModelPlayer[4] = PrecacheModel("models/trueexpert/player/ct_gign.mdl", true);

	//PrecacheSound("trueexpert/pingtool/click.wav", true); //https://forums.alliedmods.net/showthread.php?t=333211

	//g_zoneModel[0] = PrecacheModel("materials/trueexpert/zones/start.vmt", true);
	//g_zoneModel[1] = PrecacheModel("materials/trueexpert/zones/finish.vmt", true);
	//g_zoneModel[2] = PrecacheModel("materials/trueexpert/zones/check_point.vmt", true);

	//g_laserBeam = PrecacheModel("materials/sprites/laser.vmt", true);
	g_smoke = PrecacheModel("materials/sprites/smoke.vmt", true);

	PrecacheSound("weapons/flashbang/flashbang_explode1.wav", true);
	PrecacheSound("weapons/flashbang/flashbang_explode2.wav", true);

	//char path[12][PLATFORM_MAX_PATH] = {"models/trueexpert/flashbang/", "models/trueexpert/pingtool/", "models/trueexpert/player/", "materials/trueexpert/flashbang/", "materials/trueexpert/pingtool/", "sound/trueexpert/pingtool/", "materials/trueexpert/player/ct_gign/", "materials/trueexpert/player/ct_gsg9/", "materials/trueexpert/player/ct_sas/", "materials/trueexpert/player/ct_urban/", "materials/trueexpert/player/", "materials/trueexpert/zones/"};

	/*for(int i = 0; i < sizeof(path); i++)
	{
		PrintToServer("%i %i %i", i, PLATFORM_MAX_PATH, sizeof(path));
		DirectoryListing dir = OpenDirectory(path[i]);
		PrintToServer("01: %s", path[i]);

		//char filename[12][PLATFORM_MAX_PATH];
		//char filename[PLATFORM_MAX_PATH][12];
		char filename[12][PLATFORM_MAX_PATH];

		FileType type;
		char pathFull[12][PLATFORM_MAX_PATH];
		//char pathFull[PLATFORM_MAX_PATH][2];

		while(dir.GetNext(filename[i], PLATFORM_MAX_PATH, type))
		{
			if(type == FileType_File)
			{
				Format(pathFull[i], PLATFORM_MAX_PATH, "%s%s", path[i], filename[i]);

				if(StrContains(pathFull[i], ".mdl", false) != -1)
				{
					PrecacheModel(pathFull[i], true);
				}

				AddFileToDownloadsTable(pathFull[i]);

				PrintToServer("%s", pathFull[i]);
			}
		}

		delete dir;
	}*/

	//g_turbophysics = FindConVar("sv_turbophysics"); //thnaks to maru.

	RecalculatePoints();
}

public void RecalculatePoints()
{
	if(g_dbPassed == true)
	{
		g_mysql.Query(SQLRecalculatePoints_GetMap, "SELECT map FROM tier");
	}

	else if(g_dbPassed == false)
	{
		//PrintToServer("%T", "dbPassed", 0);
		//PrintToServer("%t", "dbPassed");
		//PrintToServer("%T", "dbPressed");
	}
}

public void SQLRecalculatePoints_GetMap(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLRecalculatePoints_GetMap: %s", error);
	}

	else if(strlen(error) == 0)
	{
		while(results.FetchRow() == true)
		{
			char map[192];
			results.FetchString(0, map, sizeof(map));
			char query[512];
			Format(query, sizeof(query), "SELECT (SELECT COUNT(*) FROM records WHERE map = '%s'), (SELECT tier FROM tier WHERE map = '%s'), id FROM records WHERE map = '%s' ORDER BY time", map, map, map); //https://stackoverflow.com/questions/38104018/select-and-count-rows-in-the-same-query
			g_mysql.Query(SQLRecalculatePoints, query);
		}
	}
}

public void SQLRecalculatePoints(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLRecalculatePoints: %s", error);
	}

	else if(strlen(error) == 0)
	{
		int place;
		char query[512];

		while(results.FetchRow() == true)
		{
			int points = results.FetchInt(1) * results.FetchInt(0) / ++place; //thanks to DeadSurfer //https://1drv.ms/u/s!Aq4KvqCyYZmHgpM9uKBA-74lYr2L3Q
			Format(query, sizeof(query), "UPDATE records SET points = %i WHERE id = %i LIMIT 1", points, results.FetchInt(2));
			g_queryLast++;
			g_mysql.Query(SQLRecalculatePoints2, query);
		}
	}
}

public void SQLRecalculatePoints2(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLRecalculatePoints2: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(g_queryLast-- && g_queryLast == 0)
		{
			g_mysql.Query(SQLRecalculatePoints3, "SELECT steamid FROM users");
		}
	}
}

public void SQLRecalculatePoints3(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLRecalculatePoints3: %s", error);
	}

	else if(strlen(error) == 0)
	{
		while(results.FetchRow() == true)
		{
			char query[512];
			Format(query, sizeof(query), "SELECT MAX(points) FROM records WHERE (playerid = %i OR partnerid = %i) GROUP BY map", results.FetchInt(0), results.FetchInt(0)); //https://1drv.ms/u/s!Aq4KvqCyYZmHgpFWHdgkvSKx0wAi0w?e=7eShgc
			g_mysql.Query(SQLRecalculateUserPoints, query, results.FetchInt(0));
		}
	}
}

public void SQLRecalculateUserPoints(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLRecalculateUserPoints: %s", error);
	}

	else if(strlen(error) == 0)
	{
		int points;

		while(results.FetchRow() == true)
		{
			points += results.FetchInt(0);
		}

		char query[512];
		Format(query, sizeof(query), "UPDATE users SET points = %i WHERE steamid = %i LIMIT 1", points, data);
		g_queryLast++;
		g_mysql.Query(SQLUpdateUserPoints, query);
	}
}

public void SQLUpdateUserPoints(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLUpdateUserPoints: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.HasResults == false)
		{
			if(g_queryLast-- && g_queryLast == 0)
			{
				g_mysql.Query(SQLGetPointsMaxs, "SELECT points FROM users ORDER BY points DESC LIMIT 1");
			}
		}
	}
}

public void SQLGetPointsMaxs(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLGetPointsMaxs: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.FetchRow() == true)
		{
			g_pointsMaxs = results.FetchInt(0);

			char query[512];

			for(int i = 1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) == true && IsFakeClient(i) == false)
				{
					int steamid = GetSteamAccountID(i);
					Format(query, sizeof(query), "SELECT points FROM users WHERE steamid = %i LIMIT 1", steamid);
					g_mysql.Query(SQLGetPoints, query, GetClientSerial(i));
				}
			}
		}
	}
}

public void OnMapEnd()
{
	ConVar CV_sourcetv = FindConVar("tv_enable");
	bool sourcetv = CV_sourcetv.BoolValue;

	if(sourcetv == true)
	{
		ServerCommand("tv_stoprecord");
		char filenameOld[256];
		Format(filenameOld, sizeof(filenameOld), "%s-%s-%s.dem", g_date, g_time, g_map);

		if(g_ServerRecord == true)
		{
			char filenameNew[256];
			Format(filenameNew, sizeof(filenameNew), "%s-%s-%s-ServerRecord.dem", g_date, g_time, g_map);
			RenameFile(filenameNew, filenameOld);
			g_ServerRecord = false;
		}

		else if(g_ServerRecord == false)
		{
			DeleteFile(filenameOld);
		}
	}
}

public Action OnSayMessage(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	int client = msg.ReadByte();

	msg.ReadByte();

	char msgBuffer[32];
	msg.ReadString(msgBuffer, sizeof(msgBuffer));

	char name[MAX_NAME_LENGTH];
	msg.ReadString(name, sizeof(name));

	char text[256];
	msg.ReadString(text, sizeof(text));

	if(g_msg[client] == false)
	{
		return Plugin_Handled;
	}

	g_msg[client] = false;

	char msgFormated[32];
	Format(msgFormated, sizeof(msgFormated), "%s", msgBuffer);

	char points[32];
	int precentage = g_points[client] / g_pointsMaxs * 100;

	char color[8];

	if(precentage >= 90)
	{
		Format(color, sizeof(color), "FF8000");
	}

	else if(precentage >= 70)
	{
		Format(color, sizeof(color), "A335EE");
	}

	else if(precentage >= 55)
	{
		Format(color, sizeof(color), "0070DD");
	}

	else if(precentage >= 40)
	{
		Format(color, sizeof(color), "1EFF00");
	}

	else if(precentage >= 15)
	{
		Format(color, sizeof(color), "FFFFFF");
	}

	else if(precentage >= 0)
	{
		Format(color, sizeof(color), "9D9D9D"); //https://wowpedia.fandom.com/wiki/Quality
	}

	if(g_points[client] < 1000)
	{
		Format(points, sizeof(points), "\x07%s%i\x01", color, g_points[client]);
	}

	else if(g_points[client] > 999)
	{
		Format(points, sizeof(points), "\x07%s%iK\x01", color, g_points[client] / 1000);
	}

	else if(g_points[client] > 999999)
	{
		Format(points, sizeof(points), "\x07%s%iM\x01", color, g_points[client] / 1000000);
	}

	if(StrEqual(msgBuffer, "Cstrike_Chat_AllSpec", false))
	{
		Format(text, sizeof(text), "\x01*SPEC* [%s] \x07CCCCCC%s \x01:  %s", points, name, text); //https://github.com/DoctorMcKay/sourcemod-plugins/blob/master/scripting/include/morecolors.inc#L566
	}

	else if(StrEqual(msgBuffer, "Cstrike_Chat_Spec", false))
	{
		Format(text, sizeof(text), "\x01(Spectator) [%s] \x07CCCCCC%s \x01:  %s", points, name, text);
	}

	else if(StrEqual(msgBuffer, "Cstrike_Chat_All", false))
	{
		if(GetClientTeam(client) == 2)
		{
			Format(text, sizeof(text), "\x01[%s] \x07FF4040%s \x01:  %s", points, name, text); //https://github.com/DoctorMcKay/sourcemod-plugins/blob/master/scripting/include/morecolors.inc#L638
		}

		else if(GetClientTeam(client) == 3)
		{
			Format(text, sizeof(text), "\x01[%s] \x0799CCFF%s \x01:  %s", points, name, text); //https://github.com/DoctorMcKay/sourcemod-plugins/blob/master/scripting/include/morecolors.inc#L513
		}
	}

	else if(StrEqual(msgBuffer, "Cstrike_Chat_AllDead", false))
	{
		if(GetClientTeam(client) == 2)
		{
			Format(text, sizeof(text), "\x01*DEAD* [%s] \x07FF4040%s \x01:  %s", points, name, text);
		}

		else if(GetClientTeam(client) == 3)
		{
			Format(text, sizeof(text), "\x01*DEAD* [%s] \x0799CCFF%s \x01:  %s", points, name, text);
		}
	}

	else if(StrEqual(msgBuffer, "Cstrike_Chat_CT", false))
	{
		Format(text, sizeof(text), "\x01(Counter-Terrorist) [%s] \x0799CCFF%s \x01:  %s", points, name, text);
	}

	else if(StrEqual(msgBuffer, "Cstrike_Chat_CT_Dead", false))
	{
		Format(text, sizeof(text), "\x01*DEAD*(Counter-Terrorist) [%s] \x0799CCFF%s \x01:  %s", points, name, text);
	}

	else if(StrEqual(msgBuffer, "Cstrike_Chat_T", false))
	{
		Format(text, sizeof(text), "\x01(Terrorist) [%s] \x07FF4040%s \x01:  %s", points, name, text); //https://forums.alliedmods.net/showthread.php?t=185016
	}

	else if(StrEqual(msgBuffer, "Cstrike_Chat_T_Dead", false))
	{
		Format(text, sizeof(text), "\x01*DEAD*(Terrorist) [%s] \x07FF4040%s \x01:  %s", points, name, text);
	}

	DataPack dp = new DataPack();

	dp.WriteCell(GetClientSerial(client));
	dp.WriteCell(StrContains(msgBuffer, "_All") != -1);
	dp.WriteString(text);

	RequestFrame(frame_SayText2, dp);

	return Plugin_Handled;
}

public void frame_SayText2(DataPack dp)
{
	dp.Reset();

	int client = GetClientFromSerial(dp.ReadCell());

	bool allchat = dp.ReadCell();

	char text[256];
	dp.ReadString(text, sizeof(text));

	if(IsClientInGame(client) == true)
	{
		int clients[MAXPLAYER];
		int count;
		int team = GetClientTeam(client);

		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) == true && (allchat == true || GetClientTeam(i) == team))
			{
				clients[count++] = i;
			}
		}

		Handle SayText2 = StartMessage("SayText2", clients, count, USERMSG_RELIABLE | USERMSG_BLOCKHOOKS);

		BfWrite bfmsg = UserMessageToBfWrite(SayText2);

		bfmsg.WriteByte(client);
		bfmsg.WriteByte(true);
		bfmsg.WriteString(text);

		EndMessage();

		g_msg[client] = true;
	}
}

public Action OnSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));

	/*char model[PLATFORM_MAX_PATH];
	GetClientModel(client, model, PLATFORM_MAX_PATH);

	if(StrEqual(model, "models/player/ct_urban.mdl", false))
	{
		g_class[client] = 1;
	}

	else if(StrEqual(model, "models/player/ct_gsg9.mdl", false))
	{
		g_class[client] = 2;
	}

	else if(StrEqual(model, "models/player/ct_sas.mdl", false))
	{
		g_class[client] = 3;
	}

	else if(StrEqual(model, "models/player/ct_gign.mdl", false))
	{
		g_class[client] = 4;
	}

	if(g_color[client][0] == true)
	{
		SetEntProp(client, Prop_Data, "m_nModelIndex", g_wModelPlayer[g_class[client]]);
		DispatchKeyValue(client, "skin", "2");
		SetEntityRenderColor(client, g_colorBuffer[client][0][0], g_colorBuffer[client][1][0], g_colorBuffer[client][2][0], 255);
	}

	else if(g_color[client][0] == false)
	{
		SetEntityRenderColor(client, 255, 255, 255, 255);
	}

	SetEntityRenderMode(client, RENDER_TRANSALPHA);*/ //maru is genius person who fix this bug. thanks maru for idea.

	if(g_devmap == false && g_clantagOnce[client] == false)
	{
		CS_GetClientClanTag(client, g_clantag[client][0], 256);
		g_clantagOnce[client] = true;
	}

	return Plugin_Continue;
}

public void OnButton(const char[] output, int caller, int activator, float delay)
{
	if(0 < activator <= MaxClients && IsClientInGame(activator) == true && GetClientButtons(activator) & IN_USE)
	{
		int convar = GetConVarInt(gCV_button);

		if(g_button[activator] == true && convar == 1)
		{
			//PrintToChat(activator, "You have pressed a button.");
			PrintToChat(activator, "\x01%T", "YouPressedButton", activator);
		}

		int convar2 = GetConVarInt(gCV_pbutton);

		if(g_pbutton[g_partner[activator]] == true && convar2 == 1)
		{
			//PrintToChat(g_partner[activator], "Your partner have pressed a button.");
			PrintToChat(g_partner[activator], "\x01%T", "YourPartnerPressedButton", g_partner[activator]);
		}
	}
}

public Action OnJump(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));

	g_skyOrigin[client] = GetGroundPos(client);
	g_skyAble[client] = GetGameTime();

	return Plugin_Continue;
}

public Action OnDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");

	RemoveEntity(ragdoll);

	return Plugin_Continue;
}

public Action joinclass(int client, const char[] command, int argc)
{
	CreateTimer(1.0, timer_respawn, client, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Continue;
}

public Action timer_respawn(Handle timer, int client)
{
	if(IsClientInGame(client) == true && GetClientTeam(client) != CS_TEAM_SPECTATOR && IsPlayerAlive(client) == false)
	{
		CS_RespawnPlayer(client);
	}

	return Plugin_Continue;
}

public Action autobuy(int client, const char[] command, int argc)
{
	Block(client);

	return Plugin_Continue;
}

public Action rebuy(int client, const char[] command, int argc)
{
	//ColorZ(client, true, -1);

	return Plugin_Continue;
}

public Action cheer(int client, const char[] command, int argc)
{
	if(g_partner[client] > 0)
	{
		Partner(client);
	}

	return Plugin_Continue; //happy holliday.
}

public Action showbriefing(int client, const char[] command, int argc)
{
	Menu menu = new Menu(menu_info_handler);

	menu.SetTitle("Control");

	menu.AddItem("top", "!top");
	menu.AddItem("js", "!js");
	menu.AddItem("bs", "!bs");
	menu.AddItem("hud", "!hud");
	menu.AddItem("button", "!button");
	menu.AddItem("pbutton", "!pbutton");
	menu.AddItem("spec", "!spec");
	menu.AddItem("trikz", "!trikz");

	menu.Display(client, 20);

	return Plugin_Continue;
}

public int menu_info_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
				{
					cmd_top(param1, 0);
				}

				case 1:
				{
					FakeClientCommandEx(param1, "sm_js"); //faster cooamnd respond
				}

				case 2:
				{
					FakeClientCommandEx(param1, "sm_bs"); //faster command respond
				}

				case 3:
				{
					cmd_hud(param1, 0);
				}

				case 4:
				{
					cmd_button(param1, 0);
				}

				case 5:
				{
					cmd_pbutton(param1, 0);
				}

				case 6:
				{
					cmd_spec(param1, 0);
				}

				case 7:
				{
					Trikz(param1);
				}
			}
		}
	}

	return 0;
}

public Action headtrack_reset_home_pos(int client, const char[] command, int argc)
{
	bool convar = GetConVarBool(gCV_color);
	
	if(convar == true)
	{
		//ColorFlashbang(client, true, -1);
	}

	return Plugin_Continue;
}

public void output_teleport(const char[] output, int caller, int activator, float delay)
{
	if(0 < activator <= MaxClients)
	{
		g_teleported[activator] = true;
	}
}

public Action cmd_checkpoint(int client, int args)
{
	bool convar = GetConVarBool(gCV_checkpoint);

	if(convar == true)
	{
		Checkpoint(client);
	}

	return Plugin_Handled;
}

public void Checkpoint(int client)
{
	if(g_devmap == true)
	{
		Menu menu = new Menu(checkpoint_handler);

		//menu.SetTitle("Checkpoint");
		menu.SetTitle("%T", "Checkpoint", client);

		//menu.AddItem("Save", "Save");
		char format[256];
		Format(format, sizeof(format), "%T", "CP-save", client);
		menu.AddItem("Save", format);
		Format(format, sizeof(format), "%T", "CP-teleport", client);
		menu.AddItem("Teleport", format, g_cpToggled[client][0] ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
		Format(format, sizeof(format), "%T", "CP-saveSecond", client);
		menu.AddItem("Save second", format);
		Format(format, sizeof(format), "%T", "CP-teleportSecond", client);
		menu.AddItem("Teleport second", format, g_cpToggled[client][1] ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);

		menu.ExitBackButton = true; //https://cc.bingj.com/cache.aspx?q=ExitBackButton+sourcemod&d=4737211702971338&mkt=en-WW&setlang=en-US&w=wg9m5FNl3EpqPBL0vTge58piA8n5NsLz#L49
		menu.Display(client, MENU_TIME_FOREVER);
	}

	else if(g_devmap == false)
	{
		//PrintToChat(client, "Turn on devmap.");
		PrintToChat(client, "\x01%T", "DevMapIsOFF", client);
	}
}

public int checkpoint_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
				{
					GetClientAbsOrigin(param1, g_cpOrigin[param1][0]);
					GetClientEyeAngles(param1, g_cpAng[param1][0]); //https://github.com/Smesh292/trikz/blob/main/checkpoint.sp#L101
					GetEntPropVector(param1, Prop_Data, "m_vecAbsVelocity", g_cpVel[param1][0]);

					if(g_cpToggled[param1][0] == false)
					{
						g_cpToggled[param1][0] = true;
					}
				}

				case 1:
				{
					TeleportEntity(param1, g_cpOrigin[param1][0], g_cpAng[param1][0], g_cpVel[param1][0]);
				}

				case 2:
				{
					GetClientAbsOrigin(param1, g_cpOrigin[param1][1]);
					GetClientEyeAngles(param1, g_cpAng[param1][1]);
					GetEntPropVector(param1, Prop_Data, "m_vecAbsVelocity", g_cpVel[param1][1]);

					if(g_cpToggled[param1][1] == false)
					{
						g_cpToggled[param1][1] = true;
					}
				}

				case 3:
				{
					TeleportEntity(param1, g_cpOrigin[param1][1], g_cpAng[param1][1], g_cpVel[param1][1]);
				}
			}

			Checkpoint(param1);
		}

		case MenuAction_Cancel: // trikz redux menuaction end
		{
			switch(param2)
			{
				case MenuCancel_ExitBack: //https://cc.bingj.com/cache.aspx?q=ExitBackButton+sourcemod&d=4737211702971338&mkt=en-WW&setlang=en-US&w=wg9m5FNl3EpqPBL0vTge58piA8n5NsLz#L125
				{
					Trikz(param1);
				}
			}
		}
	}

	return 0;
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, SDKOnTakeDamage);
	SDKHook(client, SDKHook_StartTouch, SDKSkyFix);
	SDKHook(client, SDKHook_PostThinkPost, SDKBoostFix); //idea by tengulawl/scripting/blob/master/boost-fix tengulawl github.com
	SDKHook(client, SDKHook_WeaponEquipPost, SDKWeaponEquip);
	SDKHook(client, SDKHook_WeaponDrop, SDKWeaponDrop);
	SDKHook(client, SDKHook_PreThinkPost, SDKThink);

	if(IsClientInGame(client) == true && g_dbPassed == true)
	{
		g_mysql.Query(SQLAddUser, "SELECT id FROM users LIMIT 1", GetClientSerial(client), DBPrio_High);

		char query[512];
		int steamid = GetSteamAccountID(client);
		Format(query, sizeof(query), "SELECT time FROM records WHERE (playerid = %i OR partnerid = %i) AND map = '%s' ORDER BY time LIMIT 1", steamid, steamid, g_map);
		g_mysql.Query(SQLGetPersonalRecord, query, GetClientSerial(client));
	}

	g_menuOpened[client] = false;

	for(int i = 0; i <= 1; i++)
	{
		g_cpToggled[client][i] = false;

		for(int j = 0; j <= 2; j++)
		{
			g_cpOrigin[client][i][j] = 0.0;
			g_cpAng[client][i][j] = 0.0;
			g_cpVel[client][i][j] = 0.0;
		}
	}

	g_block[client] = true;
	//g_timerTime[client] = 0.0;

	/*if(g_devmap == false && g_zoneHave[2] == true)
	{
		DrawZone(client, 0.0, 3.0, 10);
	}*/

	g_msg[client] = true;

	if(AreClientCookiesCached(client) == false)
	{
		g_hudVel[client] = false;
		g_mlstats[client] = false;
		g_button[client] = false;
		g_pbutton[client] = false;
		g_autoflash[client] = false;
		g_autoswitch[client] = false;
		g_bhop[client] = false;
	}

	ResetFactory(client);
	g_points[client] = 0;

	if(g_zoneHave[2] == false)
	{
		CancelClientMenu(client);
	}

	g_clantagOnce[client] = false;
	g_macroTime[client] = 0.0;
	g_macroOpened[client] = false;
}

public void OnClientCookiesCached(int client)
{
	char value[16];

	GetClientCookie(client, g_cookie[0], value, sizeof(value));
	g_hudVel[client] = view_as<bool>(StringToInt(value));

	GetClientCookie(client, g_cookie[1], value, sizeof(value));
	g_mlstats[client] = view_as<bool>(StringToInt(value));

	GetClientCookie(client, g_cookie[2], value, sizeof(value));
	g_button[client] = view_as<bool>(StringToInt(value));

	GetClientCookie(client, g_cookie[3], value, sizeof(value));
	g_pbutton[client] = view_as<bool>(StringToInt(value));
	
	GetClientCookie(client, g_cookie[4], value, sizeof(value));
	g_autoflash[client] = view_as<bool>(StringToInt(value));

	GetClientCookie(client, g_cookie[5], value, sizeof(value));
	g_autoswitch[client] = view_as<bool>(StringToInt(value));

	GetClientCookie(client, g_cookie[6], value, sizeof(value));
	g_bhop[client] = view_as<bool>(StringToInt(value));
}

public void OnClientDisconnect(int client)
{
	//ColorZ(client, false, -1);
	//ColorFlashbang(client, false, -1);

	//g_color[client][0] = false;
	//g_color[client][1] = false;
	//g_seperate[client] = false;

	int partner = g_partner[client];
	g_partner[g_partner[client]] = 0;

	if(partner > 0 && g_menuOpened[partner] == true)
	{
		Trikz(partner);
	}

	g_partner[client] = 0;
	CancelClientMenu(client);

	int entity;

	while((entity = FindEntityByClassname(entity, "weapon_*")) > 0) //https://github.com/shavitush/bhoptimer/blob/de1fa353ff10eb08c9c9239897fdc398d5ac73cc/addons/sourcemod/scripting/shavit-misc.sp#L1104-L1106
	{
		if(GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity") == client)
		{
			RemoveEntity(entity);
		}
	}

	if(g_devmap == false && partner > 0 && IsFakeClient(client) == false)
	{
		ResetFactory(partner);
		CS_SetClientClanTag(partner, g_clantag[partner][0]);
	}
}

public void SQLAddUser(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLAddUser: %s", error);
	}

	else if(strlen(error) == 0)
	{
		int client = GetClientFromSerial(data);
		//if(!client)
		//{
		//	return;
		//}
		if(client > 0 && IsClientInGame(client) == true)
		{
			char query[512]; //https://forums.alliedmods.net/showthread.php?t=261378
			int steamid = GetSteamAccountID(client);

			if(results.FetchRow() == true)
			{
				Format(query, sizeof(query), "SELECT steamid FROM users WHERE steamid = %i LIMIT 1", steamid);
				g_mysql.Query(SQLUpdateUsername, query, GetClientSerial(client), DBPrio_High);
			}

			else if(results.FetchRow() == false)
			{
				Format(query, sizeof(query), "INSERT INTO users (username, steamid, firstjoin, lastjoin) VALUES (\"%N\", %i, %i, %i)", client, steamid, GetTime(), GetTime());
				g_mysql.Query(SQLUserAdded, query);
			}
		}
	}
}

public void SQLUserAdded(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLUserAdded: %s", error);
	}
}

public void SQLUpdateUsername(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLUpdateUsername: %s", error);
	}

	else if(strlen(error) == 0)
	{
		int client = GetClientFromSerial(data);
		//if(!client)
		//	return
		if(client > 0 && IsClientInGame(client) == true)
		{
			char query[512];
			int steamid = GetSteamAccountID(client);

			if(results.FetchRow() == true)
			{
				Format(query, sizeof(query), "UPDATE users SET username = \"%N\", lastjoin = %i WHERE steamid = %i LIMIT 1", client, GetTime(), steamid);
			}

			else if(results.FetchRow() == false)
			{
				Format(query, sizeof(query), "INSERT INTO users (username, steamid, firstjoin, lastjoin) VALUES (\"%N\", %i, %i, %i)", client, steamid, GetTime(), GetTime());
			}

			g_mysql.Query(SQLUpdateUsernameSuccess, query, GetClientSerial(client), DBPrio_High);
		}
	}
}

public void SQLUpdateUsernameSuccess(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLUpdateUsernameSuccess: %s", error);
	}

	else if(strlen(error) == 0)
	{
		int client = GetClientFromSerial(data);
		//if(!client)
		//	return
		if(client > 0 && IsClientInGame(client) == true)
		{
			if(results.HasResults == false)
			{
				char query[512];
				int steamid = GetSteamAccountID(client);
				Format(query, sizeof(query), "SELECT points FROM users WHERE steamid = %i LIMIT 1", steamid);
				g_mysql.Query(SQLGetPoints, query, GetClientSerial(client), DBPrio_High);
			}
		}
	}
}

public void SQLGetPoints(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLGetPoints: %s", error);
	}

	else if(strlen(error) == 0)
	{
		int client = GetClientFromSerial(data);
		//if(!client)
		//	return
		if(client > 0 && results.FetchRow() == true)
		{
			g_points[client] = results.FetchInt(0);
		}
	}
}

public void SQLGetServerRecord(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLGetServerRecord: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.FetchRow() == true)
		{
			g_ServerRecordTime = results.FetchFloat(0);
		}

		else if(results.FetchRow() == false)
		{
			g_ServerRecordTime = 0.0;
		}
	}
}

public void SQLGetPersonalRecord(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLGetPersonalRecord: %s", error);
	}

	else if(strlen(error) == 0)
	{
		int client = GetClientFromSerial(data);

		if(client > 0 && IsClientInGame(client) == true)
		{
			if(results.FetchRow() == true)
			{
				g_haveRecord[client] = results.FetchFloat(0);
			}

			//else if(strlen(error) == 0)
			//{
			else if(results.FetchRow() == false)
			{
				g_haveRecord[client] = 0.0;
			}
			//}
		}
	}
}

public void SDKSkyFix(int client, int other) //client = booster; other = flyer
{
	if(0 < client <= MaxClients && 0 < other <= MaxClients && !(GetClientButtons(other) & IN_DUCK) && g_entityButtons[other] & IN_JUMP && GetEngineTime() - g_boostTime[client] > 0.15 && g_skyBoost[other] == 0)
	{
		float originBooster[3];
		GetClientAbsOrigin(client, originBooster);

		float originFlyer[3];
		GetClientAbsOrigin(other, originFlyer);

		float maxsBooster[3];
		GetClientMaxs(client, maxsBooster); //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L71

		float delta = originFlyer[2] - originBooster[2] - maxsBooster[2];

		if(0.0 < delta < 2.0) //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L75
		{
			float velBooster[3];
			GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velBooster);

			if(velBooster[2] > 0.0)
			{
				float velFlyer[3];

				GetEntPropVector(other, Prop_Data, "m_vecAbsVelocity", velFlyer);

				g_skyVel[other][0] = velFlyer[0];
				g_skyVel[other][1] = velFlyer[1];
			
				velBooster[2] *= 3.0;

				g_skyVel[other][2] = velBooster[2];

				if(velFlyer[2] >= -700.0)
				{
					if(g_entityFlags[client] & FL_INWATER)
					{
						if(velBooster[2] >= 300.0)
						{
							g_skyVel[other][2] = 500.0;
						}
					}

					else if(!(g_entityFlags[client] & FL_INWATER))
					{
						if(velBooster[2] >= 750.0)
						{
							g_skyVel[other][2] = 750.0;
						}
					}
				}

				else if(!(velFlyer[2] >= -700.0))
				{
					if(velBooster[2] >= 800.0)
					{
						g_skyVel[other][2] = 800.0;
					}
				}

				//if(g_entityFlags[client] & FL_INWATER ? g_skyBoost[other] == 0 : FloatAbs(g_skyOrigin[client] - g_skyOrigin[other]) > 0.04 || GetGameTime() - g_skyAble[other] > 0.5)
				//if(g_entityFlags[client] & FL_INWATER ? g_skyBoost[other] == 0 : FloatAbs(g_skyOrigin[client] - g_skyOrigin[other] ))
				//{
				//	g_skyBoost[other] = 1;
				//}
				//else if(g_entityFlags & FL_INWATER ? g_skyBoost[other] == 0 GetGameTime() - g_skyAble[other] > 0.5)

				if(g_entityFlags[client] & FL_INWATER && g_skyBoost[other] == 0 && FloatAbs(g_skyOrigin[client] - g_skyOrigin[other]) > 0.04)
				{
					g_skyBoost[other] = 1;
				}

				else if(g_entityFlags[client] & FL_INWATER && g_skyBoost[other] > 0 && GetGameTime() - g_skyAble[other] > 0.5)
				{
					g_skyBoost[other] = 1;
				}
				//}
				//}
			}
		}
	}
}

public void SDKBoostFix(int client)
{
	if(g_boost[client] == 1)
	{
		int entity = EntRefToEntIndex(g_flash[client]);
		PrintToServer("%i", entity);
		if(entity != INVALID_ENT_REFERENCE)
		{
			float velEntity[3];

			GetEntPropVector(entity, Prop_Data, "m_vecAbsVelocity", velEntity);

			if(velEntity[2] > 0.0)
			{
				velEntity[0] *= 0.135;
				velEntity[1] *= 0.135;
				velEntity[2] *= -0.135;

				TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, velEntity);
			}

			g_boost[client] = 2; //Trijās vietās kodā atrodas paātrināšana pēc Antona vārdiem.
			PrintToServer("1x");
		}
	}
	//PrintToServer("2x");
}

public Action cmd_trikz(int client, int args)
{
	bool convar = GetConVarBool(gCV_trikz);

	if(convar == true && g_menuOpened[client] == false)
	{
		Trikz(client);
	}

	return Plugin_Handled;
}

public void Trikz(int client)
{
	g_menuOpened[client] = true;

	Menu menu = new Menu(trikz_handler, MenuAction_Start | MenuAction_Select | MenuAction_Display | MenuAction_Cancel); //https://wiki.alliedmods.net/Menus_Step_By_Step_(SourceMod_Scripting)
	
	char format[128];
	Format(format, sizeof(format), "%T", "Trikz", client);
	//menu.SetTitle("Trikz");
	menu.SetTitle("%T", "Trikz", client);

	if(g_block[client] == true)
	{
		Format(format, sizeof(format), "%T", "BlockON", client);
		menu.AddItem("block", format);
	}

	if(g_block[client] == false)
	{
		Format(format, sizeof(format), "%T", "BlockOFF", client);
		//menu.AddItem("block", g_block[client] ? "Block [v]" : "Block [x]");
		menu.AddItem("block", format);
	}

	//if(g_partner[client] == true)
	if(g_partner[client] > 0)
	{
		//menu.AddItem("partner", g_partner[client] ? "Breakup" : "Partner", g_devmap ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
		Format(format, sizeof(format), "%T", "Breakup", client);
		if(g_devmap == true)
		{
			menu.AddItem("breakup", format, ITEMDRAW_DISABLED);
		}

		else if(g_devmap == false)
		{
			menu.AddItem("breakup", format, ITEMDRAW_DEFAULT);
		}
	}

	//if(g_partner[client] == false)
	if(g_partner[client] == 0)
	{
		Format(format, sizeof(format), "%T", "Partner", client);
		if(g_devmap == true)
		{
			menu.AddItem("partner", format, ITEMDRAW_DISABLED);
		}
	
		else if(g_devmap == false)
		{
			menu.AddItem("partner", format, ITEMDRAW_DEFAULT);
		}
	}
	//Format(format, sizeof(format), "%T", "Color", client);
	//if(g_devmap == true)
	//{
		//menu.AddItem("color", "Color");
		//menu.AddItem("color", format);
	//}

	else if(g_devmap == false)
	{
		//menu.AddItem("color", "Color", g_partner[client] ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
		//if(g_partner[client] == true)
		//if(g_partner[client] > 0)
		//{
		//	menu.AddItem("color", format, ITEMDRAW_DEFAULT);
		//}
		
		//else if(g_partner[client] == false)
		//else if(g_partner[client] == 0)
		//{
		//	menu.AddItem("color", format, ITEMDRAW_DISABLED);
		//}
	}
	Format(format, sizeof(format), "%T", "Restart", client);
	//menu.AddItem("restart", "Restart", g_partner[client] ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED); //shavit trikz githgub alliedmods net https://forums.alliedmods.net/showthread.php?p=2051806
	//if(g_partner[client] == true)
	if(g_partner[client] > 0)
	{
		menu.AddItem("restart", format, ITEMDRAW_DEFAULT);
	}
	
	//else if(g_partner[client] == false)
	else if(g_partner[client] == 0)
	{
		menu.AddItem("restart", format, ITEMDRAW_DISABLED);
	}

	if(g_devmap == true)
	{
		//menu.AddItem("checkpoint", "Checkpoint");
		Format(format, sizeof(format), "%T", "Checkpoint", client);
		menu.AddItem("checkpoint", format);
		if(GetEntityMoveType(client) & MOVETYPE_NOCLIP)
		{
			Format(format, sizeof(format), "%T", "NoclipON", client);
			menu.AddItem("noclip", format);
		}
		
		else if(!(GetEntityMoveType(client) & MOVETYPE_NOCLIP))
		{
			Format(format, sizeof(format), "%T", "NoclipOFF", client);
			menu.AddItem("noclip", format);
		}
		//menu.AddItem("noclip", GetEntityMoveType(client) & MOVETYPE_NOCLIP ? "Noclip [v]" : "Noclip [x]");
	}

	menu.Display(client, MENU_TIME_FOREVER);
}

public int trikz_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Start: //expert-zone idea. thank to ed, maru.
		{
			g_menuOpened[param1] = true;
		}

		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
				{
					Block(param1);
				}

				case 1:
				{
					g_menuOpened[param1] = false;
					Partner(param1);
				}

				//case 2:
				//{
					//ColorZ(param1, true, -1);
					//Trikz(param1);
				//}

				case 2:
				{
					Restart(param1);
					Restart(g_partner[param1]);
				}

				case 3:
				{
					g_menuOpened[param1] = false;
					Checkpoint(param1);
				}

				case 4:
				{
					Noclip(param1);
					Trikz(param1);
				}
			}
		}

		case MenuAction_Cancel:
		{
			g_menuOpened[param1] = false; //idea from expert zone.
		}

		case MenuAction_Display:
		{
			g_menuOpened[param1] = true;
		}
	}

	return 0;
}

public Action cmd_block(int client, int args)
{
	bool convar = GetConVarBool(gCV_block);

	if(convar == true)
	{
		Block(client);
	}

	return Plugin_Handled;
}

public Action Block(int client) //thanks maru for optimization.
{
	g_block[client] = !g_block[client];

	SetEntProp(client, Prop_Data, "m_CollisionGroup", g_block[client] ? 5 : 2);

	/*if(g_color[client][0] == true)
	{
		SetEntityRenderColor(client, g_colorBuffer[client][0][0], g_colorBuffer[client][1][0], g_colorBuffer[client][2][0], g_block[client] ? 255 : 125);
	}

	else if(g_color[client][0] == false)
	{
		SetEntityRenderColor(client, 255, 255, 255, g_block[client] ? 255 : 125);
	}*/

	if(g_menuOpened[client] == true)
	{
		Trikz(client);
	}

	//PrintToChat(client, g_block[client] ? "Block enabled." : "Block disabled.");
	if(g_block[client] == true)
	{
		PrintToChat(client, "\x01%T", "BlockChatON", client);
	}

	else if(g_block[client] == false)
	{
		PrintToChat(client, "\x01%T", "BlockChatOFF", client);
	}

	return Plugin_Handled;
}

public Action cmd_partner(int client, int args)
{
	bool convar = GetConVarBool(gCV_partner);

	if(convar == true)
	{
		Partner(client);
	}

	return Plugin_Handled;
}

public void Partner(int client)
{
	if(g_devmap == true)
	{
		//PrintToChat(client, "Turn off devmap.");
		PrintToChat(client, "\x01%T", "DevMapIsOFF", client);
	}

	else if(g_devmap == false)
	{
		//if(g_partner[client] == false)
		if(g_partner[client] == 0)
		{
			Menu menu = new Menu(partner_handler);

			//menu.SetTitle("Choose partner");
			//char format[128]
			//Format(format, sizeof(format), "%T", "ChoosePartner");
			menu.SetTitle("%T", "ChoosePartner", client);
			char name[MAX_NAME_LENGTH] = "";
			bool player = false;

			for(int i = 1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) == true && IsFakeClient(i) == false) //https://github.com/Figawe2/trikz-plugin/blob/master/scripting/trikz.sp#L635
				{
					//if(client != i && g_partner[i] == false)
					if(client != i && g_partner[i] == 0)
					{
						GetClientName(i, name, sizeof(name));

						char nameID[32] = "";
						IntToString(i, nameID, sizeof(nameID));
						menu.AddItem(nameID, name);

						player = true;
					}
				}
			}

			switch(player)
			{
				case false:
				{
					//PrintToChat(client, "No free player.");
					PrintToChat(client, "\x01%T", "NoFreePlayer", client);
				}

				case true:
				{
					menu.Display(client, 20);
				}
			}
			
		}

		//else if(g_partner[client] == true)
		else if(g_partner[client] > 0)
		{
			char partner[32] = "";
			IntToString(g_partner[client], partner, sizeof(partner)); //do global integer to string.
			
			Menu menu = new Menu(cancelpartner_handler);

			//menu.SetTitle("Cancel partnership with %N", g_partner[client]);
			char name[MAX_NAME_LENGTH] = "";
			GetClientName(g_partner[client], name, sizeof(name));
			menu.SetTitle("%T", "CancelPartnership", client, g_partner[client]);
			menu.AddItem(partner, "Yes");
			menu.AddItem("", "No");

			menu.Display(client, 20);
		}
	}
}

public int partner_handler(Menu menu, MenuAction action, int param1, int param2) //param1 = client; param2 = server -> partner
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char item[32] = "";
			menu.GetItem(param2, item, sizeof(item));
			
			int partner = StringToInt(item);
			
			Menu menu2 = new Menu(askpartner_handle);
			//menu2.SetTitle("Agree partner with %N?", param1);
			char name[MAX_NAME_LENGTH] = "";
			GetClientName(param1, name, sizeof(name));
			menu2.SetTitle("%T", "AgreePartner", partner, name);
			
			char buffer[32] = "";
			IntToString(param1, buffer, sizeof(buffer));

			menu2.AddItem(buffer, "Yes");
			menu2.AddItem(item, "No");

			menu2.Display(partner, 20);
		}
	}

	return 0;
}

public int askpartner_handle(Menu menu, MenuAction action, int param1, int param2) //param1 = client; param2 = server -> partner
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char item[32] = "";

			menu.GetItem(param2, item, sizeof(item));

			int partner = StringToInt(item);

			switch(param2)
			{
				case 0:
				{
					//if(g_partner[partner] == false)
					if(g_partner[partner] == 0)
					{
						g_partner[param1] = partner;
						g_partner[partner] = param1;

						//PrintToChat(param1, "Partnersheep agreed with %N.", partner); //reciever
						char name[MAX_NAME_LENGTH] = "";
						GetClientName(partner, name, sizeof(name));
						PrintToChat(param1, "\x01%T", "GroupAgreed", param1, name);
						//PrintToChat(partner, "You have %N as partner.", param1); //sender
						GetClientName(param1, name, sizeof(name));
						PrintToChat(partner, "\x01%T", "GetAgreed", partner, name);

						Restart(param1);
						Restart(partner); //Expert-Zone idea.

						if(g_menuOpened[partner])
						{
							Trikz(partner);
						}

						char query[512] = "";
						
						Format(query, sizeof(query), "SELECT time FROM records WHERE ((playerid = %i AND partnerid = %i) OR (playerid = %i AND partnerid = %i)) AND map = '%s' LIMIT 1", GetSteamAccountID(param1), GetSteamAccountID(partner), GetSteamAccountID(partner), GetSteamAccountID(param1), g_map);
						
						g_mysql.Query(SQLGetPartnerRecord, query, GetClientSerial(param1));
					}

					//else if(g_partner[partner] == true)
					else if(g_partner[partner] > 0)
					{
						//PrintToChat(param1, "A player already have a partner.");
						PrintToChat(param1, "\x01%T", "AlreadyHavePartner", param1);
					}
				}

				case 1:
				{
					char name[MAX_NAME_LENGTH] = "";
					GetClientName(param1, name, sizeof(name));
					//PrintToChat(param1, "Partnersheep declined with %N.", partner);
					PrintToChat(param1, "\x01%T", "PartnerDeclined", param1, name);
				}
			}
		}
	}

	return 0;
}

public int cancelpartner_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char item[32] = "";

			menu.GetItem(param2, item, sizeof(item));

			int partner = StringToInt(item);

			switch(param2)
			{
				case 0:
				{
					//ColorZ(param1, false, -1);
					//ColorFlashbang(param1, false, -1);

					g_partner[param1] = 0;
					g_partner[partner] = 0;

					ResetFactory(param1);
					ResetFactory(partner);
					
					//PrintToChat(param1, "Partnership is canceled with %N", partner);
					char name[MAX_NAME_LENGTH] = "";
					GetClientName(partner, name, sizeof(name));
					PrintToChat(param1, "\x01%T", "PartnerCanceled", param1, name);
					//PrintToChat(partner, "Partnership is canceled by %N", param1);
					GetClientName(param1, name, sizeof(name));
					PrintToChat(partner, "\x01%T", "PartnerCanceledBy", partner, name);
				}
			}
		}
	}

	return 0;
}

/*public Action cmd_color(int client, int args)
{
	bool convar = GetConVarBool(gCV_color);

	if(convar == false)
	{
		return Plugin_Handled;
	}

	char arg[512];

	GetCmdArgString(arg, sizeof(arg)); //https://www.sourcemod.net/new-api/console/GetCmdArgString

	int color = StringToInt(arg);

	if(StrEqual(arg, "white", false))
	{
		color = 0;
	}

	else if(StrEqual(arg, "red", false))
	{
		color = 1;
	}

	else if(StrEqual(arg, "orange", false))
	{
		color = 2;
	}

	else if(StrEqual(arg, "yellow", false))
	{
		color = 3;
	}

	else if(StrEqual(arg, "lime", false))
	{
		color = 4;
	}

	else if(StrEqual(arg, "aqua", false))
	{
		color = 5;
	}

	else if(StrEqual(arg, "deep sky blue", false))
	{
		color = 6;
	}

	else if(StrEqual(arg, "blue", false))
	{
		color = 7;
	}

	else if(StrEqual(arg, "magenta", false))
	{
		color = 8;
	}

	if(strlen(arg) && 0 <= color <= 8)
	{
		ColorZ(client, true, color);
	}

	else if(!color)
	{
		ColorZ(client, true, -1);
	}

	return Plugin_Handled;
}*/

/*public void ColorZ(int client, bool customSkin, int color)
{
	if(IsClientInGame(client) == true && IsFakeClient(client) == false)
	{
		//if(g_devmap == false && g_partner[client] == false)
		if(g_devmap == false && g_partner[client] == 0)
		{
			PrintToChat(client, "\x01%T", "YouMustHaveAPartner", client);
			//PrintToChat(client, "You must have a partner.");

			return;
		}

		if(customSkin == true)
		{
			g_color[client][0] = true;
			g_color[g_partner[client]][0] = true;

			SetEntProp(client, Prop_Data, "m_nModelIndex", g_wModelPlayer[g_class[client]]);
			SetEntProp(g_partner[client], Prop_Data, "m_nModelIndex", g_wModelPlayer[g_class[g_partner[client]]]);

			DispatchKeyValue(client, "skin", "2");
			DispatchKeyValue(g_partner[client], "skin", "2");

			char colorTypeExploded[32][4];

			if(g_colorCount[client][0] == 9)
			{
				g_colorCount[client][0] = 0;
				g_colorCount[g_partner[client]][0] = 0;
			}

			else if(0 <= color <= 8)
			{
				g_colorCount[client][0] = color;
				g_colorCount[g_partner[client]][0] = color;
			}

			ExplodeString(g_colorType[g_colorCount[client][0]], ",", colorTypeExploded, 4, sizeof(colorTypeExploded));

			for(int i = 0; i <= 2; i++)
			{
				g_colorBuffer[client][i][0] = StringToInt(colorTypeExploded[i]);
				g_colorBuffer[g_partner[client]][i][0] = StringToInt(colorTypeExploded[i]);
			}

			SetEntityRenderColor(client, g_colorBuffer[client][0][0], g_colorBuffer[client][1][0], g_colorBuffer[client][2][0], g_block[client] ? 255 : 125);
			SetEntityRenderColor(g_partner[client], g_colorBuffer[client][0][0], g_colorBuffer[client][1][0], g_colorBuffer[client][2][0], g_block[g_partner[client]] ? 255 : 125);

			g_colorCount[client][0]++;
			g_colorCount[g_partner[client]][0]++;

			SetHudTextParams(-1.0, -0.3, 3.0, g_colorBuffer[client][0][0], g_colorBuffer[client][1][0], g_colorBuffer[client][2][0], 255);

			if(g_seperate[client] == true)
			{
				ShowHudText(client, 5, "%s (F2)", colorTypeExploded[3]);

				if(g_partner[client] > 0)
				{
					ShowHudText(g_partner[client], 5, "%s (F2)", colorTypeExploded[3]);
				}
			}

			else if(g_seperate[client] == false)
			{
				g_color[client][1] = true;
				g_color[g_partner[client]][1] = true;

				g_colorCount[client][1] = g_colorCount[client][0];
				g_colorCount[g_partner[client]][1] = g_colorCount[g_partner[client]][0];

				for(int i = 0; i <= 2; i++)
				{
					g_colorBuffer[client][i][1] = g_colorBuffer[client][i][0];
					g_colorBuffer[g_partner[client]][i][1] = g_colorBuffer[client][i][0];
				}

				ShowHudText(client, 5, "%s (F2+)", colorTypeExploded[3]);

				if(g_partner[client] > 0)
				{
					ShowHudText(g_partner[client], 5, "%s (F2+)", colorTypeExploded[3]);
				}
			}
		}

		else
		{
			g_color[client][0] = false;
			g_color[g_partner[client]][0] = false;

			g_colorCount[client][0] = 0;
			g_colorCount[g_partner[client]][0] = 0;

			SetEntityRenderColor(client, 255, 255, 255, g_block[client] ? 255 : 125);
			SetEntityRenderColor(g_partner[client], 255, 255, 255, g_block[g_partner[client]] ? 255 : 125);
		}
	}

	return;
}

public void ColorFlashbang(int client, bool customSkin, int color)
{
	if(IsClientInGame(client) == true && IsFakeClient(client) == false)
	{
		//if(g_devmap == false && g_partner[client] == false)
		if(g_devmap == false && g_partner[client] == 0)
		{
			//PrintToChat(client, "You must have a partner.");
			PrintToChat(client, "\x01%T", "YouMustHaveAPartner", client);

			return;
		}

		if(customSkin == true)
		{
			g_color[client][1] = true;
			g_color[g_partner[client]][1] = true;

			g_seperate[client] = true;
			g_seperate[g_partner[client]] = true;

			//char colorTypeExploded[4][32];
			char colorTypeExploded[32][4];

			if(g_colorCount[client][1] == 9)
			{
				g_colorCount[client][1] = 0;
				g_colorCount[g_partner[client]][1] = 0;
			}

			else if(0 <= color <= 8)
			{
				g_colorCount[client][1] = color;
				g_colorCount[g_partner[client]][1] = color;
			}

			ExplodeString(g_colorType[g_colorCount[client][1]], ",", colorTypeExploded, 4, sizeof(colorTypeExploded));

			for(int i = 0; i <= 2; i++)
			{
				g_colorBuffer[client][i][1] = StringToInt(colorTypeExploded[i]);
				g_colorBuffer[g_partner[client]][i][1] = StringToInt(colorTypeExploded[i]);
			}

			g_colorCount[client][1]++;
			g_colorCount[g_partner[client]][1]++;

			SetHudTextParams(-1.0, -0.3, 3.0, g_colorBuffer[client][0][1], g_colorBuffer[client][1][1], g_colorBuffer[client][2][1], 255);

			ShowHudText(client, 5, "%s", colorTypeExploded[3]);

			if(g_partner[client] > 0)
			{
				ShowHudText(g_partner[client], 5, "%s", colorTypeExploded[3]);
			}
		}

		else if(customSkin == false)
		{
			g_color[client][1] = false;
			g_color[g_partner[client]][1] = false;

			g_seperate[client] = false;
			g_seperate[client] = false;

			g_colorCount[client][1] = 0;
			g_colorCount[g_partner[client]][1] = 0;
		}
	}

	return;
}*/

public void SQLGetPartnerRecord(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLGetPartnerRecord: %s", error);
	}

	else if(strlen(error) == 0)
	{
		int client = GetClientFromSerial(data);
		//if(!client)
		//	return
		if(client > 0 && IsClientInGame(client) == true && results.FetchRow() == true)
		{
			g_mateRecord[client] = results.FetchFloat(0);
			g_mateRecord[g_partner[client]] = results.FetchFloat(0);
		}

		else if(client > 0 && IsClientInGame(client) == true && results.FetchRow() == false)
		{
			g_mateRecord[client] = 0.0;
			g_mateRecord[g_partner[client]] = 0.0;
		}
	}
}

public Action cmd_restart(int client, int args)
{
	bool convar = GetConVarBool(gCV_restart);

	if(convar == false)
	{
		return Plugin_Handled;
	}

	Restart(client);

	if(g_partner[client] > 0)
	{
		Restart(g_partner[client]);
	}

	return Plugin_Handled;
}

public void Restart(int client)
{
	if(g_devmap == true)
	{
		//PrintToChat(client, "Turn off devmap.");
		PrintToChat(client, "\x01%T", "DevMapIsOFF", client);
	}

	else if(g_devmap == false)
	{
		if(g_zoneHave[0] == true && g_zoneHave[1] == true)
		{
			if(g_partner[client] > 0)
			{
				if(IsPlayerAlive(client) == true && IsPlayerAlive(g_partner[client]) == true)
				{
					CreateTimer(0.1, timer_resetfactory, client, TIMER_FLAG_NO_MAPCHANGE);

					Call_StartForward(g_start);
					Call_PushCell(client);

					Call_Finish();

					CS_RespawnPlayer(client);

					float velNull[3] = {0.0, 0.0, 0.0};

					TeleportEntity(client, g_originStart, NULL_VECTOR, velNull);

					if(g_menuOpened[client] == true)
					{
						Trikz(client);
					}
				}

				else if(IsPlayerAlive(client) == true)
				{
					int entity = 0;

					bool ct = false;
					bool t = false;

					while((entity = FindEntityByClassname(entity, "info_player_counterterrorist")) > 0)
					{
						ct = true;

						break;
					}

					while((entity = FindEntityByClassname(entity, "info_player_terrorist")) > 0)
					{
						if(ct == false)
						{
							t = true;
						}

						break;
					}

					if(ct == true)
					{
						CS_SwitchTeam(client, CS_TEAM_CT); //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-misc.sp#L2066
						CS_RespawnPlayer(client);

						if(IsPlayerAlive(g_partner[client]) == false)
						{
							CS_RespawnPlayer(g_partner[client]);
						}

						Restart(client);
						Restart(g_partner[client]);
					}

					if(t == true)
					{
						CS_SwitchTeam(client, CS_TEAM_T);
						CS_RespawnPlayer(client);

						if(IsPlayerAlive(g_partner[client]) == false)
						{
							CS_RespawnPlayer(g_partner[client]);
						}

						Restart(client);
						Restart(g_partner[client]);
					}
				}
			}

			else
			{
				//PrintToChat(client, "You must have a partner.");
				//PrintToChat(client, "\x01%T", "YMHP");
				PrintToChat(client, "\x01%T", "YouMustHaveAPartner", client);
			}
		}
	}

	return;
}

public Action cmd_autoflash(int client, int args)
{
	bool convar = GetConVarBool(gCV_autoflashbang);
	
	if(convar == false)
	{
		return Plugin_Handled;
	}

	g_autoflash[client] = !g_autoflash[client];

	char sValue[16] = "";
	IntToString(g_autoflash[client], sValue, sizeof(sValue));
	SetClientCookie(client, g_cookie[4], sValue);

	if(g_autoflash[client] == true)
	{
		//PrintToChat(client, "\x01%T", "AutoflashON", client);
		char format[256] = "";
		Format(format, sizeof(format), "AutoflashON", client);
		SendMessage(format, false, client);
	}

	else if(g_autoflash[client] == false)
	{
		//PrintToChat(client, "\x01%T", "AutoflashOFF", client);
		char format[256];
		Format(format, sizeof(format), "AutoflashOFF", client);
		SendMessage(format, false, client);
	}

	return Plugin_Handled;
}

public Action cmd_autoswitch(int client, int args)
{
	bool convar = GetConVarBool(gCV_autoswitch);
	
	if(convar ==false)
	{
		return Plugin_Handled;
	}
	
	g_autoswitch[client] = !g_autoswitch[client];

	char sValue[16];
	IntToString(g_autoswitch[client], sValue, sizeof(sValue));
	SetClientCookie(client, g_cookie[5], sValue);

	if(g_autoswitch[client] == true)
	{
		//PrintToChat(client, "\x01%T", "AutoswitchON", client);
		char format[256];
		Format(format, sizeof(format), "AutoswitchON", client);
		SendMessage(format, false, client);
	}
	
	else if(g_autoswitch[client] == false)
	{
		//PrintToChat(client, "\x01%T", "AutoswitchOFF", client);
		char format[256];
		Format(format, sizeof(format), "AutoswitchOFF", client);
		SendMessage(format, false, client);
	}

	return Plugin_Handled;
}

public Action cmd_bhop(int client, int args)
{
	bool convar = GetConVarBool(gCV_bhop);
	
	if(convar == false)
	{
		return Plugin_Handled;
	}

	g_bhop[client] = !g_bhop[client];
	
	char sValue[16] = "";
	IntToString(g_bhop[client], sValue, sizeof(sValue));
	SetClientCookie(client, g_cookie[6], sValue);
	
	if(g_bhop[client] == true)
	{
		//PrintToChat(client, "\x01%T", "BhopON", client);
		char format[256] = "";
		Format(format, sizeof(format), "BhopON", client);
		SendMessage(format, false, client);
	}

	else if(g_bhop[client] == false)
	{
		//PrintToChat(client, "\x01%T", "BhopOFF", client);
		//SendMessage(format, sizeof(format), "BhopOFF", client);
		char format[256] = "";
		Format(format, sizeof(format), "BhopOFF", client);
		SendMessage(format, false, client);
	}

	return Plugin_Handled;
}

public Action cmd_macro(int client, int args)
{
	int convar = GetConVarInt(gCV_macro);
	
	if(convar == 0)
	{
		return Plugin_Handled;
	}

	g_macroDisabled[client] = !g_macroDisabled[client];
	
	char value[16] = "";
	IntToString(g_macroDisabled[client], value, sizeof(value));
	
	if(g_macroDisabled[client] == false)
	{
		//PrintToChat(client, "\x01%T", "MacroON", client);
		char format[256] = "";
		Format(format, sizeof(format), "\x01%T", "MacroON", client);
		SendMessage(format, false, client);
	}
	
	else if(g_macroDisabled[client] == true)
	{
		//PrintToChat(client, "\x01%T", "MacroOFF", client);
		char format[256] = "";
		Format(format, sizeof(format), "\x01%T", "MacroOFF", client);
		SendMessage(format, false, client);
	}

	return Plugin_Handled;
}

public Action timer_resetfactory(Handle timer, int client)
{
	if(IsClientInGame(client) == true)
	{
		ResetFactory(client);
	}

	return Plugin_Continue;
}

public void CreateStart()
{
	int entity = CreateEntityByName("trigger_multiple", -1);

	DispatchKeyValue(entity, "spawnflags", "1"); //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0");
	DispatchKeyValue(entity, "targetname", "trueexpert_startzone");

	DispatchSpawn(entity);

	SetEntityModel(entity, "models/player/t_arctic.mdl");

	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	g_center[0][0] = (g_zoneStartOrigin[0][0] + g_zoneStartOrigin[1][0]) / 2.0;
	g_center[0][1] = (g_zoneStartOrigin[0][1] + g_zoneStartOrigin[1][1]) / 2.0;
	g_center[0][2] = (g_zoneStartOrigin[0][2] + g_zoneStartOrigin[1][2]) / 2.0;

	TeleportEntity(entity, g_center[0], NULL_VECTOR, NULL_VECTOR); //Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1

	g_originStart[0] = g_center[0][0];
	g_originStart[1] = g_center[0][1];
	g_originStart[2] = g_center[0][2] + 1.0;

	float mins[3] = {0.0, 0.0, 0.0};
	float maxs[3] = {0.0, 0.0, 0.0};

	for(int i = 0; i <= 1; i++)
	{
		mins[i] = (g_zoneStartOrigin[0][i] - g_zoneStartOrigin[1][i]) / 2.0;

		if(mins[i] > 0.0)
		{
			mins[i] *= -1.0;
		}

		maxs[i] = (g_zoneStartOrigin[0][i] - g_zoneStartOrigin[1][i]) / 2.0;

		if(maxs[i] < 0.0)
		{
			maxs[i] *= -1.0;
		}
	}

	maxs[2] = 124.0; // 62.0 * 2.0 - player hitbox is 62.0 units height. so make 2 player together.

	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins);
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs);

	SetEntProp(entity, Prop_Send, "m_nSolidType", 2);

	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch);
	SDKHook(entity, SDKHook_EndTouch, SDKEndTouch);
	SDKHook(entity, SDKHook_Touch, SDKTouch);

	PrintToServer("Start zone is successfuly setup.");

	g_zoneHave[0] = true;

	return;
}

public void CreateEnd()
{
	int entity = CreateEntityByName("trigger_multiple", -1);

	DispatchKeyValue(entity, "spawnflags", "1"); //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0");
	DispatchKeyValue(entity, "targetname", "trueexpert_endzone");

	DispatchSpawn(entity);

	SetEntityModel(entity, "models/player/t_arctic.mdl");

	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	g_center[1][0] = (g_zoneEndOrigin[0][0] + g_zoneEndOrigin[1][0]) / 2.0;
	g_center[1][1] = (g_zoneEndOrigin[0][1] + g_zoneEndOrigin[1][1]) / 2.0;
	g_center[1][2] = (g_zoneEndOrigin[0][2] + g_zoneEndOrigin[1][2]) / 2.0;

	TeleportEntity(entity, g_center[1], NULL_VECTOR, NULL_VECTOR); //Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1

	float mins[3] = {0.0, 0.0, 0.0};
	float maxs[3] = {0.0, 0.0, 0.0};

	for(int i = 0; i <= 1; i++)
	{
		mins[i] = (g_zoneEndOrigin[0][i] - g_zoneEndOrigin[1][i]) / 2.0;

		if(mins[i] > 0.0)
		{
			mins[i] *= -1.0;
		}

		maxs[i] = (g_zoneEndOrigin[0][i] - g_zoneEndOrigin[1][i]) / 2.0;

		if(maxs[i] < 0.0)
		{
			maxs[i] *= -1.0;
		}
	}

	maxs[2] = 124.0;

	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins); //https://forums.alliedmods.net/archive/index.php/t-301101.html
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs);

	SetEntProp(entity, Prop_Send, "m_nSolidType", 2);

	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch);

	PrintToServer("End zone is successfuly setup.");

	CPSetup(0);

	g_zoneHave[1] = true;

	return;
}

public Action cmd_startmins(int client, int args)
{
	//char steamidCurrent[64];
	//IntToString(GetSteamAccountID(client), steamidCurrent, sizeof(steamidCurrent));

	//char steamid[64];
	//GetConVarString(g_steamid, steamid, sizeof(steamid));

	//if(StrEqual(steamid, steamidCurrent, false))
	int flags = GetUserFlagBits(client);
	
	if(flags & ADMFLAG_CUSTOM1)
	{
		if(g_devmap == true)
		{
			GetClientAbsOrigin(client, g_zoneStartOrigin[0]);
			g_zoneFirst[0] = true;
		}

		else if(g_devmap == false)
		{
			//PrintToChat(client, "Turn on devmap.");
			//PrintToChat(client, "DevMapIsOFF", client);
			char format[256] = "";
			Format(format, sizeof(format), "DevMapIsOFF", client);
			SendMessage(format, false, client);
		}

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void SQLDeleteStartZone(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLDeleteStartZone: %s", error);
	}

	else if(strlen(error) == 0)
	{
		char query[512] = "";

		Format(query, sizeof(query), "INSERT INTO zones (map, type, possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2) VALUES ('%s', 0, %i, %i, %i, %i, %i, %i)", g_map, RoundFloat(g_zoneStartOrigin[0][0]), RoundFloat(g_zoneStartOrigin[0][1]), RoundFloat(g_zoneStartOrigin[0][2]), RoundFloat(g_zoneStartOrigin[1][0]), RoundFloat(g_zoneStartOrigin[1][1]), RoundFloat(g_zoneStartOrigin[1][2]));

		g_mysql.Query(SQLSetStartZones, query);
	}
}

public Action cmd_deleteallcp(int client, int args)
{
	//char steamidCurrent[64];
	//IntToString(GetSteamAccountID(client), steamidCurrent, sizeof(steamidCurrent));

	//char steamid[64];
	//GetConVarString(g_steamid, steamid, sizeof(steamid));

	//if(StrEqual(steamid, steamidCurrent, false)) //https://sm.alliedmods.net/new-api/

	int flags = GetUserFlagBits(client);

	if(flags & ADMFLAG_CUSTOM1)
	{
		if(g_devmap == true)
		{
			char query[512] = "";

			Format(query, sizeof(query), "DELETE FROM cp WHERE map = '%s'", g_map); //https://www.w3schools.com/sql/sql_delete.asp

			g_mysql.Query(SQLDeleteAllCP, query);
		}

		else if(g_devmap == false)
		{
			//PrintToChat(client, "Turn on devmap.");
			//PrintToChat(client, "DevMapIsOFF", client);
			char format[256] = "";
			Format(format, sizeof(format), "DevMapIsOFF", client);
			SendMessage(format, false, client);
		}
	}

	return Plugin_Continue;
}

public void SQLDeleteAllCP(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLDeleteAllCP: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.HasResults == false)
		{
			PrintToServer("All checkpoints are deleted on current map.");
		}

		else if(results.HasResults == true)
		{
			PrintToServer("No checkpoints to delete on current map.");
		}
	}

	return;
}

public Action OnClientCommandKeyValues(int client, KeyValues kv)
{
	if(g_devmap == false)
	{
		char cmd[64] = ""; //https://forums.alliedmods.net/showthread.php?t=270684
		kv.GetSectionName(cmd, sizeof(cmd));

		if(StrEqual(cmd, "ClanTagChanged", false))
		{
			CS_GetClientClanTag(client, g_clantag[client][0], 256);
		}
	}

	return Plugin_Continue;
}

public Action cmd_test(int client, int args)
{
	//char steamidCurrent[64];
	//IntToString(GetSteamAccountID(client), steamidCurrent, sizeof(steamidCurrent));

	//char steamid[64];
	//GetConVarString(g_steamid, steamid, sizeof(steamid));

	//if(StrEqual(steamid, steamidCurrent, false)) //https://sm.alliedmods.net/new-api/

	int flags = GetUserFlagBits(client);

	if(flags & ADMFLAG_CUSTOM1)
	{
		char arg[256] = "";

		GetCmdArgString(arg, sizeof(arg));

		int partner = StringToInt(arg);

		//if(partner <= MaxClients && g_partner[client] == false)
		if(partner <= MaxClients && g_partner[client] == 0)
		{
			g_partner[client] = partner;

			Call_StartForward(g_start);
			Call_PushCell(client);
			Call_Finish();

			Restart(client);
		}

		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) == true)
			{
				PrintToServer("(%i %N)", i, i);
				PrintToServer("CollisionGroup: %i %N", GetEntProp(i, Prop_Data, "m_CollisionGroup"), i);
				PrintToServer("%i %N", g_partner[i], i);
			}
		}

		PrintToServer("LibraryExists (trueexpert-entityfilter): %i", LibraryExists("expert-entityfilter"));

		//https://forums.alliedmods.net/showthread.php?t=187746
		int color = 0;
		color |= (5 & 255) << 24; //5 red
		color |= (200 & 255) << 16; // 200 green
		color |= (255 & 255) << 8; // 255 blue
		color |= (50 & 255) << 0; // 50 alpha

		PrintToChat(client, "\x08%08XCOLOR", color);

		char auth64[64] = "";
		GetClientAuthId(client, AuthId_SteamID64, auth64, sizeof(auth64));
		char authid3[64] = "";
		GetClientAuthId(client, AuthId_Steam3, authid3, sizeof(authid3));
		//PrintToChat(client, "Your SteamID64 is: %s = 76561197960265728 + %i (SteamID3)", auth64, steamid); //https://forums.alliedmods.net/showthread.php?t=324112 120192594
		PrintToChat(client, "Your SteamID64 is: %s = 76561197960265728 + %i (SteamID3 after 2nd semicolon)", auth64, authid3);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void SendMessage(const char[] text, bool all, int client)
{
	//char text[256];
	char name[MAX_NAME_LENGTH] = "";
	GetClientName(client, name, sizeof(name));

	int team = GetClientTeam(client);

	char teamName[32] = "";
	char teamColor[32] = "";

	switch(team)
	{
		case 1:
		{
			Format(teamName, sizeof(teamName), "\x01%T", "Spectator", client);
			Format(teamColor, sizeof(teamColor), "\x07CCCCCC");
		}

		case 2:
		{
			Format(teamName, sizeof(teamName), "\x01%T", "Terrorist", client);
			Format(teamColor, sizeof(teamColor), "\x07FF4040");
		}

		case 3:
		{
			Format(teamName, sizeof(teamName), "\x01%T", "Counter-Terrorist", client);
			Format(teamColor, sizeof(teamColor), "\x0799CCFF");
		}
	}

	//Format(text, 256, "\x01%T", "Hello", client, "FakeExpert", name, teamName);
	char textReplaced[256] = "";
	Format(textReplaced, sizeof(textReplaced), "\x01%s", text);
	ReplaceString(textReplaced, sizeof(textReplaced), ";#", "\x07");
	ReplaceString(textReplaced, sizeof(textReplaced), "{default}", "\x01");

	ReplaceString(textReplaced, sizeof(textReplaced), "{teamcolor}", teamColor);

	if(all == true)
	{
		PrintToChatAll("%s", textReplaced);
	}

	else if(all == false)
	{
		if(client > 0 && IsClientInGame(client) == true)
		{
			PrintToChat(client, "%s", textReplaced);
		}
	}

	return;
}

public Action cmd_endmins(int client, int args)
{
	//char steamidCurrent[64];
	//IntToString(GetSteamAccountID(client), steamidCurrent, sizeof(steamidCurrent));

	//char steamid[64];
	//GetConVarString(g_steamid, steamid, sizeof(steamid));

	//if(StrEqual(steamid, steamidCurrent, false))

	int flags = GetUserFlagBits(client);

	if(flags & ADMFLAG_CUSTOM1)
	{
		if(g_devmap == true)
		{
			GetClientAbsOrigin(client, g_zoneEndOrigin[0]);
			g_zoneFirst[1] = true;
		}

		else if(g_devmap == false)
		{
			//PrintToChat(client, "Turn on devmap.");
			//PrintToChat(client, "\x01%T", "DevMapIsOFF", client);
			char format[256] = "";
			Format(format, sizeof(format), "DevMapIsOFF", client);
			SendMessage(format, false, client);
		}

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void SQLDeleteEndZone(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLDeleteEndZone: %s", error);
	}

	else if(strlen(error) == 0)
	{
		char query[512] = "";

		Format(query, sizeof(query), "INSERT INTO zones (map, type, possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2) VALUES ('%s', 1, %i, %i, %i, %i, %i, %i)", g_map, RoundFloat(g_zoneEndOrigin[0][0]), RoundFloat(g_zoneEndOrigin[0][1]), RoundFloat(g_zoneEndOrigin[0][2]), RoundFloat(g_zoneEndOrigin[1][0]), RoundFloat(g_zoneEndOrigin[1][1]), RoundFloat(g_zoneEndOrigin[1][2]));

		g_mysql.Query(SQLSetEndZones, query);
	}
}

public Action cmd_maptier(int client, int args)
{
	//char steamidCurrent[64];
	//IntToString(GetSteamAccountID(client), steamidCurrent, sizeof(steamidCurrent));

	//char steamid[64];
	//GetConVarString(g_steamid, steamid, sizeof(steamid));

	//if(StrEqual(steamid, steamidCurrent, false))

	int flags = GetUserFlagBits(client);

	if(flags & ADMFLAG_CUSTOM1)
	{
		if(g_devmap == true)
		{
			char arg[512] = "";

			GetCmdArgString(arg, sizeof(arg)); //https://www.sourcemod.net/new-api/console/GetCmdArgString

			int tier = StringToInt(arg);

			if(tier > 0)
			{
				PrintToServer("[Args] Tier: %i", tier);

				char query[512] = "";

				Format(query, sizeof(query), "DELETE FROM tier WHERE map = '%s' LIMIT 1", g_map);

				g_mysql.Query(SQLTierRemove, query, tier);
			}
		}

		else if(g_devmap == false)
		{
			//PrintToChat(client, "\x01%T", "DevMapIsOFF", client);
			//PrintToChat(client, "Turn on devmap.");
			char format[256];
			Format(format, sizeof(format), "DevMapIsOFF", client);
			SendMessage(format, false, client);
		}

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void SQLTierRemove(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLTierRemove: %s", error);
	}

	else if(strlen(error) == 0)
	{
		char query[512] = "";

		Format(query, sizeof(query), "INSERT INTO tier (tier, map) VALUES (%i, '%s')", data, g_map);

		g_mysql.Query(SQLTierInsert, query, data);
	}

	return;
}

public void SQLTierInsert(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLTierInsert: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.HasResults == false)
		{
			PrintToServer("Tier %i is set for %s.", data, g_map);
		}
	}

	return;
}

public void SQLSetStartZones(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLSetStartZones: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.HasResults == false)
		{
			PrintToServer("Start zone successfuly created.");
		}

		else if(results.HasResults == true)
		{
			PrintToServer("Start zone failed to create.");
		}
	}

	return;
}

public void SQLSetEndZones(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLSetEndZones: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.HasResults == false)
		{
			PrintToServer("End zone successfuly created.");
		}

		else if(results.HasResults == true)
		{
			PrintToServer("End zone failed to create.");
		}
	}

	return;
}

public Action cmd_startmaxs(int client, int args)
{
	//char steamidCurrent[64];
	//IntToString(GetSteamAccountID(client), steamidCurrent, sizeof(steamidCurrent));

	//char steamid[64];
	//GetConVarString(g_steamid, steamid, steamid(steamid));

	//if(StrEqual(steamid, steamidCurrent, false) && g_zoneFirst[0] == true)

	int flags = GetUserFlagBits(client);

	if(flags & ADMFLAG_CUSTOM1 && g_zoneFirst[0] == true)
	{
		GetClientAbsOrigin(client, g_zoneStartOrigin[1]);

		char query[512] = "";
		Format(query, sizeof(query), "DELETE FROM zones WHERE map = '%s' AND type = 0 LIMIT 1", g_map);

		g_mysql.Query(SQLDeleteStartZone, query);

		g_zoneFirst[0] = false;

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public Action cmd_endmaxs(int client, int args)
{
	//char steamidCurrent[64];
	//IntToString(GetSteamAccountID(client), steamidCurrent, sizeof(steamidCurrent));

	//char steamid[64];
	//GetConVarString(g_steamid, steamid, sizeof(steamid));

	//if(StrEqual(steamid, steamidCurrent, false) && g_zoneFirst[1] == true)

	int flags = GetUserFlagBits(client);

	if(flags & ADMFLAG_CUSTOM1 && g_zoneFirst[1] == true)
	{
		GetClientAbsOrigin(client, g_zoneEndOrigin[1]);

		char query[512] = "";
		Format(query, sizeof(query), "DELETE FROM zones WHERE map = '%s' AND type = 1 LIMIT 1", g_map);

		g_mysql.Query(SQLDeleteEndZone, query);

		g_zoneFirst[1] = false;

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public Action cmd_cpmins(int client, int args)
{
	//char steamidCurrent[64];
	//IntToString(GetSteamAccountID(client), steamidCurrent, sizeof(steamidCurrent));

	//char steamid[64];
	//GetConVarString(g_steamid, steamid, sizeof(steamid));

	//if(StrEqual(steamid, steamidCurrent, false))

	int flags = GetUserFlagBits(client);

	if(flags & ADMFLAG_CUSTOM1)
	{
		if(g_devmap == true)
		{
			char cmd[512] = "";

			GetCmdArg(args, cmd, sizeof(cmd));

			int cpnum = StringToInt(cmd);

			if(cpnum > 0)
			{
				PrintToChat(client, "CP: No.%i", cpnum);

				GetClientAbsOrigin(client, g_cpPos[0][cpnum]);

				g_zoneFirst[2] = true;
			}
		}

		else if(g_devmap == false)
		{
			//PrintToChat(client, "Turn on devmap.");
			//PrintToChat(client, "\x01%T", "DevMapIsOFF", client);
			char format[256] = "";
			Format(format, sizeof(format), "DevMapIsOFF", client);
			SendMessage(format, false, client);
		}

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void SQLCPRemoved(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLCPRemoved: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.HasResults == false)
		{
			PrintToServer("Checkpoint zone no. %i successfuly deleted.", data);
		}

		else if(results.HasResults == true)
		{
			PrintToServer("Checkpoint zone no. %i failed to delete.", data);
		}

		char query[512] = "";

		Format(query, sizeof(query), "INSERT INTO cp (cpnum, cpx, cpy, cpz, cpx2, cpy2, cpz2, map) VALUES (%i, %i, %i, %i, %i, %i, %i, '%s')", data, RoundFloat(g_cpPos[0][data][0]), RoundFloat(g_cpPos[0][data][1]), RoundFloat(g_cpPos[0][data][2]), RoundFloat(g_cpPos[1][data][0]), RoundFloat(g_cpPos[1][data][1]), RoundFloat(g_cpPos[1][data][2]), g_map);

		g_mysql.Query(SQLCPInserted, query, data);
	}

	return;
}

public Action cmd_cpmaxs(int client, int args)
{
	//char steamidCurrent[64];
	//IntToString(GetSteamAccountID(client), steamidCurrent, sizeof(steamidCurrent));

	//char steamid[64];
	//GetConVarString(g_steamid, steamid, sizeof(steamid));

	//if(StrEqual(steamid, steamidCurrent, false) && g_zoneFirst[2] == true)

	int flags = GetUserFlagBits(client);

	if(flags & ADMFLAG_CUSTOM1 && g_zoneFirst[2] == true)
	{
		char cmd[512] = "";

		GetCmdArg(args, cmd, sizeof(cmd));

		int cpnum = StringToInt(cmd);

		if(cpnum > 0)
		{
			GetClientAbsOrigin(client, g_cpPos[1][cpnum]);

			char query[512] = "";
			Format(query, sizeof(query), "DELETE FROM cp WHERE cpnum = %i AND map = '%s'", cpnum, g_map);

			g_mysql.Query(SQLCPRemoved, query, cpnum);

			g_zoneFirst[2] = false;
		}

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void SQLCPInserted(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLCPInserted: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.HasResults == false)
		{
			PrintToServer("Checkpoint zone no. %i successfuly created.", data);
		}

		else if(results.HasResults == true)
		{
			PrintToServer("Checkpoint zone no. %i failed to create.");
		}
	}

	return;
}

public Action cmd_zones(int client, int args)
{
	//char steamidCurrent[64];
	//IntToString(GetSteamAccountID(client), steamidCurrent, sizeof(steamidCurrent));

	//char steamid[64];
	//GetConVarString(g_steamid, steamid, sizeof(steamidCurrent));

	//if(StrEqual(steamid, steamidCurrent, false))

	int flags = GetUserFlagBits(client);

	if(flags & ADMFLAG_CUSTOM1)
	{
		if(g_devmap == true)
		{
			ZoneEditor(client);

			return Plugin_Handled;
		}

		else if(g_devmap == false)
		{
			//PrintToChat(client, "Turn on devmap.");
			//PrintToChat(client, "\x01%T", "DevMapIsOFF", client);
			char format[256] = "";
			Format(format, sizeof(format), "DevMapIsOFF", client);
			SendMessage(format, false, client);

			return Plugin_Handled;
		}
	}

	return Plugin_Continue;
}

public void ZoneEditor(int client)
{
	CPSetup(client);

	return;
}

public void ZoneEditor2(int client)
{
	Menu menu = new Menu(zones_handler);

	menu.SetTitle("Zone editor");

	if(g_zoneHave[0] == true)
	{
		menu.AddItem("start", "Start zone");
	}

	if(g_zoneHave[1] == true)
	{
		menu.AddItem("end", "End zone");
	}

	char format[32];

	if(g_cpCount > 0)
	{
		for(int i = 1; i <= g_cpCount; i++)
		{
			Format(format, sizeof(format), "CP nr. %i zone", i);

			char cp[16] = "";

			Format(cp, sizeof(cp), "%i", i);

			menu.AddItem(cp, format);
		}
	}

	else if(g_zoneHave[0] == false && g_zoneHave[1] == false && g_cpCount == 0)
	{
		menu.AddItem("-1", "No zones are setup.", ITEMDRAW_DISABLED);
	}

	menu.Display(client, MENU_TIME_FOREVER);
}

public int zones_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char item[16] = "";
			menu.GetItem(param2, item, sizeof(item));

			Menu menu2 = new Menu(zones2_handler, MenuAction_Start | MenuAction_Select | MenuAction_Display | MenuAction_Cancel);

			if(StrEqual(item, "start", false))
			{
				menu2.SetTitle("Zone editor - Start zone");

				menu2.AddItem("starttp", "Teleport to start zone");
				menu2.AddItem("start+xmins", "+x/mins");
				menu2.AddItem("start-xmins", "-x/mins");
				menu2.AddItem("start+ymins", "+y/mins");
				menu2.AddItem("start-ymins", "-y/mins");
				menu2.AddItem("start+xmaxs", "+x/maxs");
				menu2.AddItem("start-xmaxs", "-x/maxs");
				menu2.AddItem("start+ymaxs", "+y/maxs");
				menu2.AddItem("start-ymaxs", "-y/maxs");
				menu2.AddItem("startupdate", "Update start zone");
			}

			else if(StrEqual(item, "end", false))
			{
				menu2.SetTitle("Zone editor - End zone");

				menu2.AddItem("endtp", "Teleport to end zone");
				menu2.AddItem("end+xmins", "+x/mins");
				menu2.AddItem("end-xmins", "-x/mins");
				menu2.AddItem("end+ymins", "+y/mins");
				menu2.AddItem("end-ymins", "-y/mins");
				menu2.AddItem("end+xmaxs", "+x/maxs");
				menu2.AddItem("end-xmaxs", "-x/maxs");
				menu2.AddItem("end+ymaxs", "+y/maxs");
				menu2.AddItem("end-ymaxs", "-y/maxs");
				menu2.AddItem("endupdate", "Update start zone");
			}

			for(int i = 1; i <= g_cpCount; i++)
			{
				char cp[16] = "";

				IntToString(i, cp, sizeof(cp));

				//Format(cp, sizeof(cp), "%i", i);

				if(StrEqual(item, cp, false))
				{
					menu2.SetTitle("Zone editor - CP nr. %i zone", i);

					char sButton[32] = "";

					Format(sButton, sizeof(sButton), "Teleport to CP nr. %i zone", i);

					char itemCP[16] = "";

					Format(itemCP, sizeof(itemCP), "%i;tp", i);

					menu2.AddItem(itemCP, sButton);

					Format(itemCP, sizeof(itemCP), "%i;1", i);

					menu2.AddItem(itemCP, "+x/mins");

					Format(itemCP, sizeof(itemCP), "%i;2", i);

					menu2.AddItem(itemCP, "-x/mins");

					Format(itemCP, sizeof(itemCP), "%i;3", i);

					menu2.AddItem(itemCP, "+y/mins");

					Format(itemCP, sizeof(itemCP), "%i;4", i);

					menu2.AddItem(itemCP, "-y/mins");

					Format(itemCP, sizeof(itemCP), "%i;5", i);

					menu2.AddItem(itemCP, "+x/maxs");

					Format(itemCP, sizeof(itemCP), "%i;6", i);

					menu2.AddItem(itemCP, "-x/maxs");

					Format(itemCP, sizeof(itemCP), "%i;7", i);

					menu2.AddItem(itemCP, "+y/maxs");

					Format(itemCP, sizeof(itemCP), "%i;8", i);

					menu2.AddItem(itemCP, "-y/maxs");

					Format(sButton, sizeof(sButton), "Update CP nr. %i zone", i);

					menu2.AddItem("cpupdate", sButton);
				}
			}

			menu2.ExitBackButton = true; //https://cc.bingj.com/cache.aspx?q=ExitBackButton+sourcemod&d=4737211702971338&mkt=en-WW&setlang=en-US&w=wg9m5FNl3EpqPBL0vTge58piA8n5NsLz#L49

			menu2.Display(param1, MENU_TIME_FOREVER);
		}
	}

	return 0;
}

public int zones2_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Start: //expert-zone idea. thank to ed, maru.
		{
			g_zoneDraw[param1] = true;
		}

		case MenuAction_Select:
		{
			char item[16] = "";

			menu.GetItem(param2, item, sizeof(item));

			if(StrEqual(item, "starttp", false))
			{
				TeleportEntity(param1, g_center[0], NULL_VECTOR, NULL_VECTOR);
			}

			else if(StrEqual(item, "start+xmins", false))
			{
				g_zoneStartOrigin[0][0] += 16.0;
			}

			else if(StrEqual(item, "start-xmins", false))
			{
				g_zoneStartOrigin[0][0] -= 16.0;
			}

			else if(StrEqual(item, "start+ymins", false))
			{
				g_zoneStartOrigin[0][1] += 16.0;
			}

			else if(StrEqual(item, "start-ymins", false))
			{
				g_zoneStartOrigin[0][1] -= 16.0;
			}

			else if(StrEqual(item, "start+xmaxs", false))
			{
				g_zoneStartOrigin[1][0] += 16.0;
			}

			else if(StrEqual(item, "start-xmaxs", false))
			{
				g_zoneStartOrigin[1][0] -= 16.0;
			}

			else if(StrEqual(item, "start+ymaxs", false))
			{
				g_zoneStartOrigin[1][1] += 16.0;
			}

			else if(StrEqual(item, "start-ymaxs", false))
			{
				g_zoneStartOrigin[1][1] -= 16.0;
			}

			else if(StrEqual(item, "endtp", false))
			{
				TeleportEntity(param1, g_center[1], NULL_VECTOR, NULL_VECTOR);
			}

			else if(StrEqual(item, "end+xmins", false))
			{
				g_zoneEndOrigin[0][0] += 16.0;
			}

			else if(StrEqual(item, "end-xmins", false))
			{
				g_zoneEndOrigin[0][0] -= 16.0;
			}

			else if(StrEqual(item, "end+ymins", false))
			{
				g_zoneEndOrigin[0][1] += 16.0;
			}

			else if(StrEqual(item, "end-ymins", false))
			{
				g_zoneEndOrigin[0][1] -= 16.0;
			}

			else if(StrEqual(item, "end+xmaxs", false))
			{
				g_zoneEndOrigin[1][0] += 16.0;
			}

			else if(StrEqual(item, "end-xmaxs", false))
			{
				g_zoneEndOrigin[1][0] -= 16.0;
			}

			else if(StrEqual(item, "end+ymaxs", false))
			{
				g_zoneEndOrigin[1][1] += 16.0;
			}

			else if(StrEqual(item, "end-ymaxs", false))
			{
				g_zoneEndOrigin[1][1] -= 16.0;
			}

			//char exploded[1][16];
			char exploded[16][1];

			ExplodeString(item, ";", exploded, 1, sizeof(exploded));

			int cpnum = StringToInt(exploded[0]);

			char cpFormated[16] = "";

			Format(cpFormated, sizeof(cpFormated), "%i;tp", cpnum);

			if(StrEqual(item, cpFormated, false))
			{
				TeleportEntity(param1, g_center[cpnum + 1], NULL_VECTOR, NULL_VECTOR);
			}

			Format(cpFormated, sizeof(cpFormated), "%i;1", cpnum);

			if(StrEqual(item, cpFormated, false))
			{
				g_cpPos[0][cpnum][0] += 16.0;
			}

			Format(cpFormated, sizeof(cpFormated), "%i;2", cpnum);

			if(StrEqual(item, cpFormated, false))
			{
				g_cpPos[0][cpnum][0] -= 16.0;
			}

			Format(cpFormated, sizeof(cpFormated), "%i;3", cpnum);

			if(StrEqual(item, cpFormated, false))
			{
				g_cpPos[0][cpnum][1] += 16.0;
			}

			Format(cpFormated, sizeof(cpFormated), "%i;4", cpnum);

			if(StrEqual(item, cpFormated, false))
			{
				g_cpPos[0][cpnum][1] -= 16.0;
			}

			Format(cpFormated, sizeof(cpFormated), "%i;5", cpnum);

			if(StrEqual(item, cpFormated, false))
			{
				g_cpPos[1][cpnum][0] += 16.0;
			}

			Format(cpFormated, sizeof(cpFormated), "%i;6", cpnum);

			if(StrEqual(item, cpFormated, false))
			{
				g_cpPos[1][cpnum][0] -= 16.0;
			}

			Format(cpFormated, sizeof(cpFormated), "%i;7", cpnum);

			if(StrEqual(item, cpFormated, false))
			{
				g_cpPos[1][cpnum][1] += 16.0;
			}

			Format(cpFormated, sizeof(cpFormated), "%i;8", cpnum);

			if(StrEqual(item, cpFormated, false))
			{
				g_cpPos[1][cpnum][1] -= 16.0;
			}

			char query[512] = "";

			if(StrEqual(item, "startupdate", false))
			{
				Format(query, sizeof(query), "UPDATE zones SET possition_x = %i, possition_y = %i, possition_z = %i, possition_x2 = %i, possition_y2 = %i, possition_z2 = %i WHERE type = 0 AND map = '%s'", RoundFloat(g_zoneStartOrigin[0][0]), RoundFloat(g_zoneStartOrigin[0][1]), RoundFloat(g_zoneStartOrigin[0][2]), RoundFloat(g_zoneStartOrigin[1][0]), RoundFloat(g_zoneStartOrigin[1][1]), RoundFloat(g_zoneStartOrigin[1][2]), g_map);

				g_mysql.Query(SQLUpdateZone, query, 0);
			}

			else if(StrEqual(item, "endupdate", false))
			{
				Format(query, sizeof(query), "UPDATE zones SET possition_x = %i, possition_y = %i, possition_z = %i, possition_x2 = %i, possition_y2 = %i, possition_z2 = %i WHERE type = 1 AND map = '%s'", RoundFloat(g_zoneEndOrigin[0][0]), RoundFloat(g_zoneEndOrigin[0][1]), RoundFloat(g_zoneEndOrigin[0][2]), RoundFloat(g_zoneEndOrigin[1][0]), RoundFloat(g_zoneEndOrigin[1][1]), RoundFloat(g_zoneEndOrigin[1][2]), g_map);

				g_mysql.Query(SQLUpdateZone, query, 1);
			}

			else if(StrEqual(item, "cpupdate", false))
			{
				Format(query, sizeof(query), "UPDATE cp SET cpx = %i, cpy = %i, cpz = %i, cpx2 = %i, cpy2 = %i, cpz2 = %i WHERE cpnum = %i AND map = '%s'", RoundFloat(g_cpPos[0][cpnum][0]), RoundFloat(g_cpPos[0][cpnum][1]), RoundFloat(g_cpPos[0][cpnum][2]), RoundFloat(g_cpPos[1][cpnum][0]), RoundFloat(g_cpPos[1][cpnum][1]), RoundFloat(g_cpPos[1][cpnum][2]), cpnum, g_map);

				g_mysql.Query(SQLUpdateZone, query, cpnum + 1);
			}

			menu.DisplayAt(param1, GetMenuSelectionPosition(), MENU_TIME_FOREVER); //https://forums.alliedmods.net/showthread.php?p=2091775
		}

		case MenuAction_Cancel: // trikz redux menuaction end
		{
			g_zoneDraw[param1] = false; //idea from expert zone.

			switch(param2)
			{
				case MenuCancel_ExitBack: //https://cc.bingj.com/cache.aspx?q=ExitBackButton+sourcemod&d=4737211702971338&mkt=en-WW&setlang=en-US&w=wg9m5FNl3EpqPBL0vTge58piA8n5NsLz#L125
				{
					ZoneEditor(param1);
				}
			}
		}

		case MenuAction_Display:
		{
			g_zoneDraw[param1] = true;
		}
	}

	return 0;
}

public void SQLUpdateZone(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLUpdateZone: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.HasResults == false)
		{
			if(data == 1)
			{
				PrintToServer("End zone successfuly updated.");
			}

			else if(data == 0)
			{
				PrintToServer("Start zone successfuly updated.");
			}

			else if(data > 1)
			{
				PrintToServer("CP zone nr. %i successfuly updated.", data - 1);
			}
		}

		else if(results.HasResults == true)
		{
			if(data == 1)
			{
				PrintToServer("End zone failed to update.");
			}

			else if(data == 0)
			{
				PrintToServer("Start zone failed to update.");
			}

			else if(data > 1)
			{
				PrintToServer("CP zone nr. %i failed to update", data - 1);
			}
		}
	}

	return;
}

//https://forums.alliedmods.net/showthread.php?t=261378

public Action cmd_createcp(int args)
{
	g_mysql.Query(SQLCreateCPTable, "CREATE TABLE IF NOT EXISTS cp (id INT AUTO_INCREMENT, cpnum INT, cpx INT, cpy INT, cpz INT, cpx2 INT, cpy2 INT, cpz2 INT, map VARCHAR(192), PRIMARY KEY(id))");

	return Plugin_Continue;
}

public void SQLCreateCPTable(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLCreateCPTable: %s", error);
	}

	else if(strlen(error) == 0)
	{
		PrintToServer("CP table successfuly created.");
	}

	return;
}

public Action cmd_createtier(int args)
{
	g_mysql.Query(SQLCreateTierTable, "CREATE TABLE IF NOT EXISTS tier (id INT AUTO_INCREMENT, tier INT, map VARCHAR(192), PRIMARY KEY(id))");

	return Plugin_Continue;
}

public void SQLCreateTierTable(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLCreateTierTable: %s", error);
	}

	else if(strlen(error) == 0)
	{
		PrintToServer("Tier table successfuly created.");
	}

	return;
}

public void CPSetup(int client)
{
	g_cpCount = 0;

	PrintToServer("must be 0, real number: %i", g_cpCount);

	char query[512] = "";

	for(int i = 1; i <= 10; i++)
	{
		Format(query, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = %i AND map = '%s' LIMIT 1", i, g_map);

		DataPack dp = new DataPack();

		dp.WriteCell(client ? GetClientSerial(client) : 0);
		dp.WriteCell(i);

		g_mysql.Query(SQLCPSetup, query, dp);
	}
}

public void SQLCPSetup(Database db, DBResultSet results, const char[] error, DataPack dp)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLCPSetup: %s", error);
	}

	else if(strlen(error) == 0)
	{
		dp.Reset();

		int client = GetClientFromSerial(dp.ReadCell());
		int cp = dp.ReadCell();

		if(results.FetchRow() == true)
		{
			g_cpPos[0][cp][0] = results.FetchFloat(0);
			g_cpPos[0][cp][1] = results.FetchFloat(1);
			g_cpPos[0][cp][2] = results.FetchFloat(2);

			g_cpPos[1][cp][0] = results.FetchFloat(3);
			g_cpPos[1][cp][1] = results.FetchFloat(4);
			g_cpPos[1][cp][2] = results.FetchFloat(5);

			if(g_devmap == false)
			{
				CreateCP(cp);
			}

			g_cpCount++;
		}

		if(cp == 10)
		{
			if(client > 0)
			{
				ZoneEditor2(client);
			}

			if(g_zoneHave[2] == false)
			{
				g_zoneHave[2] = true;
			}

			if(g_devmap == false)
			{
				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) == true)
					{
						OnClientPutInServer(i);
					}
				}
			}
		}
	}

	return;
}

public void CreateCP(int cpnum)
{
	char trigger[64] = "";

	Format(trigger, sizeof(trigger), "trueexpert_cp%i", cpnum);

	int entity = CreateEntityByName("trigger_multiple", -1);

	DispatchKeyValue(entity, "spawnflags", "1"); //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0");
	DispatchKeyValue(entity, "targetname", trigger);

	DispatchSpawn(entity);

	SetEntityModel(entity, "models/player/t_arctic.mdl");

	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	g_center[cpnum + 1][0] = (g_cpPos[1][cpnum][0] + g_cpPos[0][cpnum][0]) / 2.0;
	g_center[cpnum + 1][1] = (g_cpPos[1][cpnum][1] + g_cpPos[0][cpnum][1]) / 2.0;
	g_center[cpnum + 1][2] = (g_cpPos[1][cpnum][2] + g_cpPos[0][cpnum][2]) / 2.0;

	TeleportEntity(entity, g_center[cpnum + 1], NULL_VECTOR, NULL_VECTOR); //Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1

	float mins[3] = {0.0, 0.0, 0.0};
	float maxs[3] = {0.0, 0.0, 0.0};

	for(int i = 0; i <= 1; i++)
	{
		mins[i] = (g_cpPos[0][cpnum][i] - g_cpPos[1][cpnum][i]) / 2.0;

		if(mins[i] > 0.0)
		{
			mins[i] *= -1.0;
		}

		maxs[i] = (g_cpPos[0][cpnum][i] - g_cpPos[1][cpnum][i]) / 2.0;

		if(maxs[i] < 0.0)
		{
			maxs[i] *= -1.0;
		}
	}

	maxs[2] = 124.0;

	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins); //https://forums.alliedmods.net/archive/index.php/t-301101.html
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs);

	SetEntProp(entity, Prop_Send, "m_nSolidType", 2);

	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch);

	PrintToServer("Checkpoint number %i is successfuly setup.", cpnum);

	return;
}

public Action cmd_createusers(int args)
{
	g_mysql.Query(SQLCreateUserTable, "CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT, username VARCHAR(64), steamid INT, firstjoin INT, lastjoin INT, points INT, PRIMARY KEY(id))");

	return Plugin_Continue;
}

public void SQLCreateUserTable(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLCreateUserTable: %s", error);
	}

	else if(strlen(error) == 0)
	{
		PrintToServer("Successfuly created user table.");
	}

	return;
}

public Action cmd_createrecords(int args)
{
	g_mysql.Query(SQLRecordsTable, "CREATE TABLE IF NOT EXISTS records (id INT AUTO_INCREMENT, playerid INT, partnerid INT, time FLOAT, finishes INT, tries INT, cp1 FLOAT, cp2 FLOAT, cp3 FLOAT, cp4 FLOAT, cp5 FLOAT, cp6 FLOAT, cp7 FLOAT, cp8 FLOAT, cp9 FLOAT, cp10 FLOAT, points INT, map VARCHAR(192), date INT, PRIMARY KEY(id))");

	return Plugin_Continue;
}

public void SQLRecordsTable(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLRecordsTable: %s", error);
	}

	else if(strlen(error) == 0)
	{
		PrintToServer("Successfuly created records table.");
	}

	return;
}

public Action SDKEndTouch(int entity, int other)
{
	if(0 < other <= MaxClients && g_readyToStart[other] == true && g_partner[other] > 0 && IsFakeClient(other) == false)
	{
		g_state[other] = true;
		g_state[g_partner[other]] = true;

		g_mapFinished[other] = false;
		g_mapFinished[g_partner[other]] = false; //expert zone idea

		g_timerTimeStart[other] = GetEngineTime();
		g_timerTimeStart[g_partner[other]] = GetEngineTime();

		g_readyToStart[other] = false;
		g_readyToStart[g_partner[other]] = false;

		//g_clantagTimer[other] = CreateTimer(0.1, timer_clantag, other, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
		//g_clantagTimer[g_partner[other]] = CreateTimer(0.1, timer_clantag, g_partner[other], TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);

		CreateTimer(0.1, timer_clantag, other, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(0.1, timer_clantag, g_partner[other], TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);

		for(int i = 1; i <= g_cpCount; i++)
		{
			g_cp[i][other] = false;
			g_cp[i][g_partner[other]] = false;

			g_cpLock[i][other] = false;
			g_cpLock[i][g_partner[other]] = false;
		}
	}

	return Plugin_Continue;
}

public Action SDKTouch(int entity, int other)
{
	if(!(GetEntityFlags(other) & FL_ONGROUND))
	{
		SDKEndTouch(entity, other);
	}

	return Plugin_Continue;
}

public Action SDKStartTouch(int entity, int other)
{
	if(0 < other <= MaxClients && g_devmap == false && IsFakeClient(other) == false)
	{
		char trigger[32] = "";

		GetEntPropString(entity, Prop_Data, "m_iName", trigger, sizeof(trigger));

		if(StrEqual(trigger, "trueexpert_startzone", false) && g_mapFinished[g_partner[other]] == true)
		{
			Restart(other); //expert zone idea.
			Restart(g_partner[other]);
		}

		if(StrEqual(trigger, "trueexpert_endzone", false))
		{
			g_mapFinished[other] = true;

			if(g_mapFinished[g_partner[other]] == true && g_state[other] == true)
			{
				char query[512] = "";

				int playerid = GetSteamAccountID(other);
				int partnerid = GetSteamAccountID(g_partner[other]);

				int personalHour = (RoundToFloor(g_timerTime[other]) / 3600) % 24; //https://forums.alliedmods.net/archive/index.php/t-187536.html
				int personalMinute = (RoundToFloor(g_timerTime[other]) / 60) % 60;
				int personalSecond = RoundToFloor(g_timerTime[other]) % 60;

				char sPersonalHour[32] = "";
				FormatEx(sPersonalHour, sizeof(sPersonalHour), "%02.i", personalHour);

				char sPersonalMinute[32] = "";
				FormatEx(sPersonalMinute, sizeof(sPersonalMinute), "%02.i", personalMinute);

				char sPersonalSecond[32] = "";
				FormatEx(sPersonalSecond, sizeof(sPersonalSecond), "%02.i", personalSecond);

				if(g_ServerRecordTime > 0.0)
				{
					if(g_mateRecord[other] > 0.0)
					{
						if(g_ServerRecordTime > g_timerTime[other])
						{
							float timeDiff = g_ServerRecordTime - g_timerTime[other];

							int srHour = (RoundToFloor(timeDiff) / 3600) % 24;
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60;
							int srSecond = RoundToFloor(timeDiff) % 60;

							char sSRHour[32] = "";
							FormatEx(sSRHour, sizeof(sSRHour), "%02.i", srHour);

							char sSRMinute[32] = "";
							FormatEx(sSRMinute, sizeof(sSRMinute), "%02.i", srMinute);

							char sSRSecond[32] = "";
							Format(sSRSecond, sizeof(sSRSecond), "%02.i", srSecond);

							//PrintToChatAll("\x01\x077CFC00New server record!");
							//PrintToChatAll("\x01%T", "NewServerRecord");
							char format[256] = "";
							Format(format, sizeof(format), "NewServerRecord");
							SendMessage(format, true, other); //smth like shavit functions.
							//PrintToChatAll("\x01%N and %N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x077CFC00-%02.i:%02.i:%02.i\x01)", other, g_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							
							char sClient[MAX_NAME_LENGTH] = "";
							GetClientName(other, sClient, sizeof(sClient));

							char sOther[MAX_NAME_LENGTH] = "";
							GetClientName(g_partner[other], sOther, sizeof(sOther));

							//FormatEx(sClient, sizeof(sClient), "%N", clie
							//PrintToChatAll("\x01%T", "NewServerRecordDetail", sClient, sOther, sPersonalHour, sPersonalMinute, sPersonalSecond, sSRHour, sSRMinute, sSRSecond);

							char text2[256] = "";
							Format(text2, sizeof(text2), "%T", "NewServerRecordDetail", sClient, sOther, sPersonalHour, sPersonalMinute, sPersonalSecond, sSRHour, sSRMinute, sSRSecond);
							SendMessage(text2, true, other);
							//SendMessage(text2, true, g_partner[other]);
							FinishMSG(other, false, true, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);
							FinishMSG(g_partner[other], false, true, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);

							Format(query, sizeof(query), "UPDATE records SET time = %f, finishes = finishes + 1, cp1 = %f, cp2 = %f, cp3 = %f, cp4 = %f, cp5 = %f, cp6 = %f, cp7 = %f, cp8 = %f, cp9 = %f, cp10 = %f, date = %i WHERE ((playerid = %i AND partnerid = %i) OR (playerid = %i AND partnerid = %i)) AND map = '%s' ORDER BY time LIMIT 1", g_timerTime[other], g_cpTimeClient[1][other], g_cpTimeClient[2][other], g_cpTimeClient[3][other], g_cpTimeClient[4][other], g_cpTimeClient[5][other], g_cpTimeClient[6][other], g_cpTimeClient[7][other], g_cpTimeClient[8][other], g_cpTimeClient[9][other], g_cpTimeClient[10][other], GetTime(), playerid, partnerid, partnerid, playerid, g_map);

							g_mysql.Query(SQLUpdateRecord, query);

							g_haveRecord[other] = g_timerTime[other];
							g_haveRecord[g_partner[other]] = g_timerTime[other]; //logs help also expert zone ideas.

							g_mateRecord[other] = g_timerTime[other];
							g_mateRecord[g_partner[other]] = g_timerTime[other];

							g_ServerRecord = true;
							g_ServerRecordTime = g_timerTime[other];

							CreateTimer(60.0, timer_sourcetv, _, TIMER_FLAG_NO_MAPCHANGE);

							Call_StartForward(g_record);

							Call_PushCell(other);
							Call_PushFloat(g_timerTime[other]);

							Call_Finish();
						}

						else if(g_ServerRecordTime < g_timerTime[other] > g_mateRecord[other])
						{
							float timeDiff = g_timerTime[other] - g_ServerRecordTime;

							int srHour = (RoundToFloor(timeDiff) / 3600) % 24;
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60;
							int srSecond = RoundToFloor(timeDiff) % 60;
							
							char sSRHour[32] = "";
							Format(sSRHour, sizeof(sSRHour), "%02.i", srHour);
							char sSRMinute[32] = "";
							Format(sSRMinute, sizeof(sSRMinute), "%02.i", srMinute);
							char sSRSecond[32] = "";
							Format(sSRSecond, sizeof(sSRSecond), "%02.i", srSecond);
							
							/*//PrintToChatAll("\x01%N and %N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+%02.i:%02.i:%02.i\x01)", other, g_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);*/
							char text2[256] = "";
							char sName[MAX_NAME_LENGTH] = "";
							GetClientName(other, sName, sizeof(sName));
							char sPartner[MAX_NAME_LENGTH] = "";
							GetClientName(g_partner[other], sPartner, sizeof(sPartner));
							//char sPartner(g_partner[other], sPartner, sizeof(sPartner));
							Format(text2, sizeof(text2), "%T", "PassedImproved", sName, sPartner, sPersonalHour, sPersonalMinute, sPersonalSecond, sSRHour, sSRMinute, sSRSecond);
							SendMessage(text2, true, other);
							//SendMessage(text2, true, g_partner[other]);
							
							FinishMSG(other, false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);
							FinishMSG(g_partner[other], false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);

							Format(query, sizeof(query), "UPDATE records SET finishes = finishes + 1 WHERE ((playerid = %i AND partnerid = %i) OR (playerid = %i AND partnerid = %i)) AND map = '%s' LIMIT 1", playerid, partnerid, partnerid, playerid, g_map);

							g_mysql.Query(SQLUpdateRecord, query);
						}

						else if(g_ServerRecordTime < g_timerTime[other] < g_mateRecord[other])
						{
							float timeDiff = g_timerTime[other] - g_ServerRecordTime;

							int srHour = (RoundToFloor(timeDiff) / 3600) % 24;
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60;
							int srSecond = RoundToFloor(timeDiff) % 60;
							
							char sSRHour[32] = "";
							Format(sSRHour, sizeof(sSRHour), "%02.i", srHour);
							char sSRMinute[32] = "";
							Format(sSRMinute, sizeof(sSRMinute), "%02.i", srMinute);
							char sSRSecond[32] = "";
							Format(sSRSecond, sizeof(sSRSecond), "%02.i", srSecond);

							char text2[256] = "";
							char sName[MAX_NAME_LENGTH] = "";
							GetClientName(other, sName, sizeof(sName));
							char sPartner[MAX_NAME_LENGTH] = "";
							GetClientName(g_partner[other], sPartner, sizeof(sPartner));
							Format(text2, sizeof(text2), "%T", "Passed", sName, sPartner, sPersonalHour, sPersonalMinute, sPersonalSecond, sSRHour, sSRMinute, sSRSecond);
							SendMessage(text2, true, other);
							//SendMessage(text2, true, g_partner[other]);
							
							//PrintToChatAll("\x01%N and %N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+%02.i:%02.i:%02.i\x01)", other, g_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);

							FinishMSG(other, false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);
							FinishMSG(g_partner[other], false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);

							Format(query, sizeof(query), "UPDATE records SET time = %f, finishes = finishes + 1, cp1 = %f, cp2 = %f, cp3 = %f, cp4 = %f, cp5 = %f, cp6 = %f, cp7 = %f, cp8 = %f, cp9 = %f, cp10 = %f, date = %i WHERE ((playerid = %i AND partnerid = %i) OR (playerid = %i AND partnerid = %i)) AND map = '%s' LIMIT 1", g_timerTime[other], g_cpTimeClient[1][other], g_cpTimeClient[2][other], g_cpTimeClient[3][other], g_cpTimeClient[4][other], g_cpTimeClient[5][other], g_cpTimeClient[6][other], g_cpTimeClient[7][other], g_cpTimeClient[8][other], g_cpTimeClient[9][other], g_cpTimeClient[10][other], GetTime(), playerid, partnerid, partnerid, playerid, g_map);

							g_mysql.Query(SQLUpdateRecord, query);

							if(g_haveRecord[other] > g_timerTime[other])
							{
								g_haveRecord[other] = g_timerTime[other];
							}

							if(g_haveRecord[g_partner[other]] > g_timerTime[other])
							{
								g_haveRecord[g_partner[other]] = g_timerTime[other];
							}

							if(g_mateRecord[other] > g_timerTime[other])
							{
								g_mateRecord[other] = g_timerTime[other];
								g_mateRecord[g_partner[other]] = g_timerTime[other];
							}					
						}
					}

					else if(g_mateRecord[other] == 0.0)
					{
						if(g_ServerRecordTime > g_timerTime[other])
						{
							float timeDiff = g_ServerRecordTime - g_timerTime[other];

							int srHour = (RoundToFloor(timeDiff) / 3600) % 24;
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60;
							int srSecond = RoundToFloor(timeDiff) % 60;

							//PrintToChatAll("\x077CFC00New server record!");
							char format[256];
							Format(format, sizeof(format), "%T", "NewServerRecord");
							SendMessage(format, true, other); // all this plugin is based on expert zone ideas and log helps, so little bit ping from rumour and some alliedmodders code free and hlmod code free. and ws code free. entityfilter is made from george code. alot ideas i steal for leagal reason. gnu allows to copy codes if author accept it or public plugin.
							//PrintToChatAll("\x01%T", "NewServerRecord");
							//PrintToChatAll("\x01%N and %N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x077CFC00-%02.i:%02.i:%02.i\x01)", other, g_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);
							char sSRHour[32] = "";
							Format(sSRHour, sizeof(sSRHour), "%02.i", srHour);
							char sSRMinute[32] = "";
							Format(sSRMinute, sizeof(sSRMinute), "%02.i", srMinute);
							char sSRSecond[32] = "";
							Format(sSRSecond, sizeof(sSRSecond), "%02.i", srSecond);
							char sName[MAX_NAME_LENGTH] = "";
							GetClientName(other, sName, sizeof(sName));
							char sPartner[MAX_NAME_LENGTH] = "";
							GetClientName(g_partner[other], sPartner, sizeof(sPartner));
							char text2[256] = "";
							Format(text2, sizeof(text2), "%T", "NewServerRecordDetailNew", sName, sPartner, sPersonalHour, sPersonalMinute, sPersonalSecond, sSRHour, sSRMinute, sSRSecond);
							SendMessage(text2, true, other);
							//SendMessage(text2, true, g_partner[other]);

							FinishMSG(other, false, true, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);
							FinishMSG(g_partner[other], false, true, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);

							Format(query, sizeof(query), "INSERT INTO records (playerid, partnerid, time, finishes, tries, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %i, %f, 1, 1, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, partnerid, g_timerTime[other], g_cpTimeClient[1][other], g_cpTimeClient[2][other], g_cpTimeClient[3][other], g_cpTimeClient[4][other], g_cpTimeClient[5][other], g_cpTimeClient[6][other], g_cpTimeClient[7][other], g_cpTimeClient[8][other], g_cpTimeClient[9][other], g_cpTimeClient[10][other], g_map, GetTime());

							g_mysql.Query(SQLInsertRecord, query);

							g_haveRecord[other] = g_timerTime[other];
							g_haveRecord[g_partner[other]] = g_timerTime[other];

							g_mateRecord[other] = g_timerTime[other];
							g_mateRecord[g_partner[other]] = g_timerTime[other];

							g_ServerRecord = true;

							g_ServerRecordTime = g_timerTime[other];

							CreateTimer(60.0, timer_sourcetv, _, TIMER_FLAG_NO_MAPCHANGE);

							Call_StartForward(g_record);

							Call_PushCell(other);
							Call_PushFloat(g_timerTime[other]);

							Call_Finish();
						}

						else if(g_ServerRecordTime < g_timerTime[other])
						{
							float timeDiff = g_timerTime[other] - g_ServerRecordTime;

							int srHour = (RoundToFloor(timeDiff) / 3600) % 24;
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60;
							int srSecond = RoundToFloor(timeDiff) % 60;

							//PrintToChatAll("\x01%N and %N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+%02.i:%02.i:%02.i\x01)", other, g_partner[other], personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);
							char sSRHour[32] = "";
							Format(sSRHour, sizeof(sSRHour), "%02.i", srHour);
							char sSRMinute[32] = "";
							Format(sSRMinute, sizeof(sSRMinute), "%02.i", srMinute);
							char sSRSecond[32] = "";
							Format(sSRSecond, sizeof(sSRSecond), "%02.i", srSecond);
							char sName[MAX_NAME_LENGTH] = "";
							GetClientName(other, sName, sizeof(sName));
							char sPartner[MAX_NAME_LENGTH] = "";
							//Format(sPartner, sizeof(sPartner), ""
							GetClientName(g_partner[other], sPartner, sizeof(sPartner));
							char text2[256] = ""; //i got george code from github but before it i got it from george friends.
							Format(text2, sizeof(text2), "%T", "JustPassed", sName, sPartner, sPersonalHour, sPersonalMinute, sPersonalSecond, sSRHour, sSRMinute, sSRSecond);
							SendMessage(text2, true, other);

							FinishMSG(other, false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);
							FinishMSG(g_partner[other], false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond);

							Format(query, sizeof(query), "INSERT INTO records (playerid, partnerid, time, finishes, tries, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %i, %f, 1, 1, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, partnerid, g_timerTime[other], g_cpTimeClient[1][other], g_cpTimeClient[2][other], g_cpTimeClient[3][other], g_cpTimeClient[4][other], g_cpTimeClient[5][other], g_cpTimeClient[6][other], g_cpTimeClient[7][other], g_cpTimeClient[8][other], g_cpTimeClient[9][other], g_cpTimeClient[10][other], g_map, GetTime());

							g_mysql.Query(SQLInsertRecord, query);

							if(g_haveRecord[other] == 0.0)
							{
								g_haveRecord[other] = g_timerTime[other];
							}

							if(g_haveRecord[g_partner[other]] == 0.0)
							{
								g_haveRecord[g_partner[other]] = g_timerTime[other];
							}

							g_mateRecord[other] = g_timerTime[other];
							g_mateRecord[g_partner[other]] = g_timerTime[other];
						}
					}

					for(int i = 1; i <= g_cpCount; i++)
					{
						if(g_cp[i][other])
						{
							int srCPHour = (RoundToFloor(gF_cpDiff[i][other]) / 3600) % 24;
							int srCPMinute = (RoundToFloor(gF_cpDiff[i][other]) / 60) % 60;
							int srCPSecond = RoundToFloor(gF_cpDiff[i][other]) % 60;
							
							char sSRCPHour[32] = ""; //trikz solid code was perfect for me but i didnt got how to make measure generic last level anti cheat triggers.
							Format(sSRCPHour, sizeof(sSRCPHour), "%02.i", srCPHour);
							char sSRCPMinute[32] = "";
							Format(sSRCPMinute, sizeof(sSRCPMinute), "%02.i", srCPMinute);
							char sSRCPSecond[32] = "";
							Format(sSRCPSecond, sizeof(sSRCPSecond), "%02.i", srCPSecond);

							if(g_cpTimeClient[i][other] < g_cpTime[i])
							{
								//PrintToChatAll("\x01%i. Checkpoint: \x077CFC00-%02.i:%02.i:%02.i", i, srCPHour, srCPMinute, srCPSecond);
								//char sSRCPHour[32];
								char textCP[256] = "";
								Format(textCP, sizeof(textCP), "%T", "CPImprove", i, sSRCPHour, sSRCPMinute, sSRCPSecond);
								SendMessage(textCP, true, other);
							}

							else if(g_cpTimeClient[i][other] > g_cpTime[i])
							{
								//PrintToChatAll("\x01%i. Checkpoint: \x07FF0000+%02.i:%02.i:%02.i", i, srCPHour, srCPMinute, srCPSecond);
								char textCP[256];
								Format(textCP, sizeof(textCP), "%T", "CPDeprove", i, sSRCPHour, sSRCPMinute, sSRCPSecond);
								SendMessage(textCP, true, other);
							}
						}
					}
				}

				else if(g_ServerRecordTime == 0.0)
				{
					g_ServerRecordTime = g_timerTime[other];

					g_haveRecord[other] = g_timerTime[other];
					g_haveRecord[g_partner[other]] = g_timerTime[other];

					g_mateRecord[other] = g_timerTime[other];
					g_mateRecord[g_partner[other]] = g_timerTime[other];
					char format[256];
					Format(format, sizeof(format), "%T", "NewServerRecord");
					SendMessage(format, true, other);
					//PrintToChatAll("\x077CFC00New server record!");
					//PrintToChatAll("\x01%T", "NewServerRecord");
					//PrintToChatAll("\x01%N and %N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+00:00:00\x01)", other, g_partner[other], personalHour, personalMinute, personalSecond);
					//Format(format, sizeof(format), )
					char sName[MAX_NAME_LENGTH];
					GetClientName(other, sName, sizeof(sName));
					char sPartner[MAX_NAME_LENGTH];
					GetClientName(g_partner[other], sPartner, sizeof(sPartner));
					char text2[256];
					Format(text2, sizeof(text2), "%T", "NewServerRecordFirst", sName, sPartner, sPersonalHour, sPersonalMinute, sPersonalSecond);
					SendMessage(text2, true, other);

					FinishMSG(other, true, false, false, false, false, 0, personalHour, personalMinute, personalSecond, 0, 0, 0);
					FinishMSG(g_partner[other], true, false, false, false, false, 0, personalHour, personalMinute, personalSecond, 0, 0, 0);

					for(int i = 1; i <= g_cpCount; i++)
					{
						if(g_cp[i][other])
						{
							//PrintToChatAll("\x01%i. Checkpoint: \x07FF0000+00:00:00", i);
							char textCP[256] = "";
							Format(textCP, sizeof(textCP), "%T", "CPNEW", i);
							SendMessage(textCP, true, other);
						}
					}

					g_ServerRecord = true;

					CreateTimer(60.0, timer_sourcetv, _, TIMER_FLAG_NO_MAPCHANGE); //https://forums.alliedmods.net/showthread.php?t=191615

					Format(query, sizeof(query), "INSERT INTO records (playerid, partnerid, time, finishes, tries, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %i, %f, 1, 1, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, partnerid, g_timerTime[other], g_cpTimeClient[1][other], g_cpTimeClient[2][other], g_cpTimeClient[3][other], g_cpTimeClient[4][other], g_cpTimeClient[5][other], g_cpTimeClient[6][other], g_cpTimeClient[7][other], g_cpTimeClient[8][other], g_cpTimeClient[9][other], g_cpTimeClient[10][other], g_map, GetTime());

					g_mysql.Query(SQLInsertRecord, query);

					Call_StartForward(g_record);

					Call_PushCell(other);
					Call_PushFloat(g_timerTime[other]);

					Call_Finish();
				}

				g_state[other] = false;
				g_state[g_partner[other]] = false;
			}
		}

		for(int i = 1; i <= g_cpCount; i++)
		{
			char triggerCP[64] = "";

			Format(triggerCP, sizeof(triggerCP), "trueexpert_cp%i", i);

			if(StrEqual(trigger, triggerCP, false))
			{
				g_cp[i][other] = true;

				if(g_cp[i][other] == true && g_cp[i][g_partner[other]] == true && g_cpLock[i][other] == false)
				{
					char query[512]; //https://stackoverflow.com/questions/9617453 https://www.w3schools.com/sql/sql_ref_order_by.asp#:~:text=%20SQL%20ORDER%20BY%20Keyword%20%201%20ORDER,data%20returned%20in%20descending%20order.%20%20More%20

					int playerid = GetSteamAccountID(other);
					int partnerid = GetSteamAccountID(g_partner[other]);

					if(g_cpLock[1][other] == false && g_mateRecord[other] > 0.0)
					{
						Format(query, sizeof(query), "UPDATE records SET tries = tries + 1 WHERE ((playerid = %i AND partnerid = %i) OR (playerid = %i AND partnerid = %i)) AND map = '%s' LIMIT 1", playerid, partnerid, partnerid, playerid, g_map);
						g_mysql.Query(SQLSetTries, query);
					}

					g_cpLock[i][other] = true;
					g_cpLock[i][g_partner[other]] = true;

					g_cpTimeClient[i][other] = g_timerTime[other];
					g_cpTimeClient[i][g_partner[other]] = g_timerTime[other];

					Format(query, sizeof(query), "SELECT cp%i FROM records LIMIT 1", i);

					DataPack dp = new DataPack();

					dp.WriteCell(GetClientSerial(other));
					dp.WriteCell(i);

					g_mysql.Query(SQLCPSelect, query, dp);
				}
			}
		}
	}

	return Plugin_Continue;
}

public void FinishMSG(int client, bool firstServerRecord, bool serverRecord, bool onlyCP, bool firstCPRecord, bool cpRecord, int cpnum, int personalHour, int personalMinute, int personalSecond, int srHour, int srMinute, int srSecond)
{
	char sPersonalHour[32] = "";
	Format(sPersonalHour, sizeof(sPersonalHour), "%i", personalHour);
	char sPersonalMinute[32] = "";
	Format(sPersonalMinute, sizeof(sPersonalMinute), "%i", personalMinute);
	char sPersonalSecond[32] = "";
	Format(sPersonalSecond, sizeof(sPersonalSecond), "%i", personalSecond);
	
	char sSRHour[32] = "";
	Format(sSRHour, sizeof(sSRHour), "%i", srHour);
	char sSRMinute[32] = "";
	Format(sSRMinute, sizeof(sSRMinute), "%i", srMinute);
	char sSRSecond[32] = "";
	Format(sSRSecond, sizeof(sSRSecond), "%i", srSecond);

	char format[256] = "";

	if(onlyCP == true)
	{
		if(firstCPRecord == true)
		{
			SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255); //https://sm.alliedmods.net/new-api/halflife/SetHudTextParams
			//ShowHudText(client, 1, "%i. CHECKPOINT RECORD!", cpnum); //https://sm.alliedmods.net/new-api/halflife/ShowHudText
			Format(format, sizeof(format), "%T", "CP-record", client, cpnum);
			ShowHudText(client, 1, format);

			SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
			//ShowHudText(client, 2, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
			Format(format, sizeof(format), "%T", "CP-recordDetail", client, sPersonalHour, sPersonalMinute, sPersonalSecond);
			ShowHudText(client, 2, format);
			
			SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255);
			ShowHudText(client, 3, "+00:00:00");
			//Format(format, sizeof(format), "+00:00:00");
			//Show
			Format(format, sizeof(format), "%T", "CP-DetailZero", client);
			ShowHudText(client, 3, format);

			for(int i = 1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) == true && IsClientObserver(i) == true)
				{
					int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget");
					int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode");

					if(observerMode < 7 && observerTarget == client)
					{
						SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255);
						//ShowHudText(i, 1, "%i. CHECKPOINT RECORD!", cpnum);
						Format(format, sizeof(format), "%T", "CP-record", i, cpnum);
						ShowHudText(i, 1, format);

						SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
						//ShowHudText(i, 2, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
						Format(format, sizeof(format), "%T", "CP-recordDetail", i, sPersonalHour, sPersonalMinute, sPersonalSecond);

						SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255);
						Format(format, sizeof(format), "%T", "CP-DetailZero", i);
						ShowHudText(i, 3, format);
						//ShowHudText(i, 3, "+00:00:00");
						
					}
				}
			}
		}

		else if(firstCPRecord == false)
		{
			if(cpRecord == true)
			{
				SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255);
				//ShowHudText(client, 1, "%i. CHECKPOINT RECORD!", cpnum); //https://steamuserimages-a.akamaihd.net/ugc/1788470716362427548/185302157B3F4CBF4557D0C47842C6BBD705380A/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false
				Format(format, sizeof(format), "%T", "CP-recordNotFirst", client, cpnum);
				ShowHudText(client, 1, format);

				SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
				//ShowHudText(client, 2, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
				Format(format, sizeof(format), "%T", "CP-recordDetailNotFirst", client, sPersonalHour, sPersonalMinute, sPersonalSecond);
				ShowHudText(client, 2, format);

				SetHudTextParams(-1.0, -0.6, 3.0, 0, 255, 0, 255);
				Format(format, sizeof(format), "%T", "CP-recordImproveNotFirst", client, sSRHour, sSRMinute, sSRSecond);
				ShowHudText(client, 3, format);
				//ShowHudText(client, 3, "-%02.i:%02.i:%02.i", srHour, srMinute, srSecond);

				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) == true && IsClientObserver(i) == true)
					{
						int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget");
						int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode");

						if(observerMode < 7 && observerTarget == client)
						{
							SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255);
							Format(format, sizeof(format), "%T", "CP-recordNotFist", i, cpnum);
							//ShowHudText(i, 1, "%i. CHECKPOINT RECORD!", cpnum);
							ShowHudText(i, 1, format);

							SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
							//ShowHudText(i, 2, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
							Format(format, sizeof(format), "%T", "CP-recordDetailNotFirst", i, sPersonalHour, sPersonalMinute, sPersonalSecond);
							ShowHudText(i, 2, format);

							SetHudTextParams(-1.0, -0.6, 3.0, 0, 255, 0, 255);
							Format(format, sizeof(format), "%T", "CP-recordImproveNotFirst", i, sSRHour, sSRMinute, sSRSecond);
							ShowHudText(i, 3, format);
							//ShowHudText(i, 3, "-%02.i:%02.i:%02.i", srHour, srMinute, srSecond);
						}
					}
				}
			}

			else if(cpRecord == false)
			{
				SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
				//Format(format, sizeof(format), "%T", "CP-recordDeprove"
				Format(format, sizeof(format), "%T", "CP-recordNon", client, sPersonalHour, sPersonalMinute, sPersonalSecond);
				ShowHudText(client, 1, format);
				//ShowHudText(client, 1, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond); //https://steamuserimages-a.akamaihd.net/ugc/1788470716362384940/4DD466582BD1CF04366BBE6D383DD55A079936DC/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false

				SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255);
				//ShowHudText(client, 2, "+%02.i:%02.i:%02.i", srHour, srMinute, srSecond);
				Format(format, sizeof(format), "%T", "CP-recordDeprove", client, srHour, srMinute, srSecond);
				ShowHudText(client, 2, format);

				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) == true && IsClientObserver(i) == true)
					{
						int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget");
						int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode");

						if(observerMode < 7 && observerTarget == client)
						{
							SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
							//ShowHudText(i, 1, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
							Format(format, sizeof(format), "%T", "CP-recordNon", i, sPersonalHour, sPersonalMinute, sPersonalSecond);
							ShowHudText(i, 1, format);

							SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255);
							//ShowHudText(i, 2, "+%02.i:%02.i:%02.i", srHour, srMinute, srSecond);
							Format(format, sizeof(format), "%T", "CP-recordDeprove", i, sSRHour, sSRMinute, sSRSecond);
							ShowHudText(i, 2, format);
						}
					}
				}
			}
		}
	}

	else if(onlyCP == false)
	{
		if(firstServerRecord == true)
		{
			SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255); //https://sm.alliedmods.net/new-api/halflife/SetHudTextParams
			//ShowHudText(client, 1, "MAP FINISHED!"); //https://sm.alliedmods.net/new-api/halflife/ShowHudText
			Format(format, sizeof(format), "%T", "MapFinishedFirstRecord", client);
			ShowHudText(client, 1, format);

			SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255);
			//ShowHudText(client, 2, "NEW SERVER RECORD!");
			Format(format, sizeof(format), "%T", "NewServerRecordHud", client);
			ShowHudText(client, 2, format);

			SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
			//ShowHudText(client, 3, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
			Format(format, sizeof(format), "%T", "FirstRecordHud", client, sPersonalHour, sPersonalMinute, sPersonalSecond);
			ShowHudText(client, 3, format);

			SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255);
			ShowHudText(client, 4, "+00:00:00");
			Format(format, sizeof(format), "%T", "FirstRecordZeroHud", client);
			ShowHudText(client, 4, format);

			for(int i = 1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) == true && IsClientObserver(i) == true)
				{
					int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget");
					int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode");

					if(IsClientSourceTV(i) == true || (observerMode < 7 && observerTarget == client))
					{
						SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255);
						//ShowHudText(i, 1, "MAP FINISHED!");
						//Format(format, sizeof(format), "%T", "NewServerRecordHud", i);
						Format(format, sizeof(format), "%T", "MapFinishedFirstRecord", i);
						ShowHudText(i, 1, format);

						SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255);
						ShowHudText(i, 2, "NEW SERVER RECORD!");
						//ShowHudText(i, 2, "%T", ""
						Format(format, sizeof(format), "%T", "NewServerRecordHud", i);
						ShowHudText(i, 2, format);

						SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
						//ShowHudText(i, 3, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
						Format(format, sizeof(format), "%T", "FirstRecordHud", i, sPersonalHour, sPersonalMinute, sPersonalSecond);
						ShowHudText(i, 4, format);

						SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255);
						//ShowHudText(i, 4, "+00:00:00");
						Format(format, sizeof(format), "FirstRecordZeroHud", i);
						ShowHudText(i, 4, format);

					}
				}
			}
		}

		else if(firstServerRecord == false)
		{
			if(serverRecord == true)
			{
				SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255);
				ShowHudText(client, 1, "MAP FINISHED!");
				
				Format(format, sizeof(format), "%T", "NewServerRecordMapFinishedNotFirst", client);
				ShowHudText(client, 2, format);
				SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255);
				//ShowHudText(client, 2, "NEW SERVER RECORD!");
				Format(format, sizeof(format), "%T", "NewServerRecordNotFirst", client);
				ShowHudText(client, 2, format);

				SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
				//ShowHudText(client, 3, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
				Format(format, sizeof(format), "%T", "NewServerRecordDetailNotFirst", client, sPersonalHour, sPersonalMinute, sPersonalSecond);
				ShowHudText(client, 3, format);

				SetHudTextParams(-1.0, -0.6, 3.0, 0, 255, 0, 255);
				//ShowHudText(client, 4, "-%02.i:%02.i:%02.i", srHour, srMinute, srSecond); //https://youtu.be/j4L3YvHowv8?t=45
				Format(format, sizeof(format), "%T", "NewServerRecordImproveNotFirst", client);
				ShowHudText(client, 4, format);
				
				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) == true && IsClientObserver(i) == true)
					{
						int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget");
						int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode");

						if(IsClientSourceTV(i) == true || (observerMode < 7 && observerTarget == client))
						{
							SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255);
							//ShowHudText(i, 1, "MAP FINISHED!");
							Format(format, sizeof(format), "%T", "NewServerRecordMapFinishedNotFirst", i);
							ShowHudText(i, 1, format);
							
							SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255);
							//ShowHudText(i, 2, "NEW SERVER RECORD!");
							Format(format, sizeof(format), "%T", "NewServerRecordNotFirst", i);
							ShowHudText(i, 2, format);

							SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
							//ShowHudText(i, 3, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
							//ShowHudText(i
							//Format(sizeof
							Format(format, sizeof(format), "%T", "NewServerRecordDetailNotFirst", i);
							ShowHudText(i, 3, format);

							SetHudTextParams(-1.0, -0.6, 3.0, 0, 255, 0, 255);
							//ShowHudText(i, 4, "-%02.i:%02.i:%02.i", srHour, srMinute, srSecond);
							//ShowHudText(i, 4,
							Format(format, sizeof(format), "%T", "NewServerRecordImproveNotFirst", i);
							ShowHudText(i, 3, format);
						}
					}
				}
			}

			else if(serverRecord == false)
			{
				SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255);
				//ShowHudText(client, 1, "MAP FINISHED!");
				Format(format, sizeof(format), "%T", "MapFinishedDeprove", client);
				ShowHudText(client, 1, format);
				
				SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
				ShowHudText(client, 2, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
				Format(format, sizeof(format), "%T", "MapFinishedTimeDeprove", client, sPersonalHour, sPersonalMinute, sPersonalSecond);
				ShowHudText(client, 2, format);
				
				SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255);
				//ShowHudText(client, 3, "+%02.i:%02.i:%02.i", srHour, srMinute, srSecond);
				Format(format, sizeof(format), "%T", "MapFinishedTimeDeproveOwn", client, sSRHour, sSRMinute, sSRSecond);
				ShowHudText(client, 3, format);

				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) == true && IsClientObserver(i) == true)
					{
						int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget");
						int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode");

						if(observerMode < 7 && observerTarget == client)
						{
							SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255);
							//char format[256];
							Format(format, sizeof(format), "%T", "MapFinishedDeprove", i);
							//ShowHudText(i, 1, "MAP FINISHED!");
							ShowHudText(i, 1, format);

							SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255);
							
							//ShowHudText(i, 2, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond);
							Format(format, sizeof(format), "%T", "MapFinishedTimeDeprove", i, sPersonalHour, sPersonalMinute, sPersonalSecond);
							ShowHudText(i, 2, format);
							
							SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255);
							//ShowHudText(i, 3, "+%02.i:%02.i:%02.i", srHour, srMinute, srSecond);
							Format(format, sizeof(format), "%T", "MapFinishedTimeDeproveOwn", i, sSRHour, sSRMinute, sSRSecond);
							ShowHudText(i, 3, format);
						}
					}
				}
			}
		}
	}
}

public void SQLUpdateRecord(Database db, DBResultSet results, const char[] error, DataPack dp)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLUpdateRecord: %s", error);
	}

	else if(strlen(error) == 0)
	{
		#if debug
		PrintToServer("SQLUpdateRecord callback is finished.");
		#endif
	}
}

public void SQLInsertRecord(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLInsertRecord: %s", error);
	}

	else if(strlen(error) == 0)
	{
		#if debug
		PrintToServer("SQLInsertRecord callback finished.");
		#endif
	}
}

public Action timer_sourcetv(Handle timer)
{
	ConVar CV_sourcetv = FindConVar("tv_enable");
	bool sourcetv = CV_sourcetv.BoolValue; //https://sm.alliedmods.net/new-api/convars/__raw

	if(sourcetv == true)
	{
		ServerCommand("tv_stoprecord");

		g_sourcetvchangedFileName = false;

		CreateTimer(5.0, timer_runsourcetv, _, TIMER_FLAG_NO_MAPCHANGE);

		g_ServerRecord = false;
	}

	return Plugin_Continue;
}

public Action timer_runsourcetv(Handle timer)
{
	char filenameOld[256] = "";
	Format(filenameOld, sizeof(filenameOld), "%s-%s-%s.dem", g_date, g_time, g_map);

	char filenameNew[256] = "";
	Format(filenameNew, sizeof(filenameNew), "%s-%s-%s-ServerRecord.dem", g_date, g_time, g_map);

	RenameFile(filenameNew, filenameOld);
	ConVar CV_sourcetv = FindConVar("tv_enable");

	bool sourcetv = CV_sourcetv.BoolValue; //https://sm.alliedmods.net/new-api/convars/__raw

	if(sourcetv == true)
	{
		PrintToServer("SourceTV is start recording.");

		FormatTime(g_date, sizeof(g_date), "%Y-%m-%d", GetTime());
		FormatTime(g_time, sizeof(g_time), "%H-%M-%S", GetTime());

		ServerCommand("tv_record %s-%s-%s", g_date, g_time, g_map);

		g_sourcetvchangedFileName = true;
	}

	return Plugin_Continue;
}

public void SQLCPSelect(Database db, DBResultSet results, const char[] error, DataPack data)
{
	if(strlen(error))
	{
		PrintToServer("SQLCPSelect: %s", error);
	}

	else if(strlen(error) == 0)
	{
		data.Reset();

		int other = GetClientFromSerial(data.ReadCell());
		int cpnum = data.ReadCell();

		char query[512] = "";

		if(results.FetchRow() == true)
		{
			Format(query, sizeof(query), "SELECT cp%i FROM records WHERE map = '%s' ORDER BY time LIMIT 1", cpnum, g_map); //log help me alot with this stuff, logs palīdzēja atrast kodu un saprast kā tas strādā.

			DataPack dp = new DataPack();

			dp.WriteCell(GetClientSerial(other));
			dp.WriteCell(cpnum);

			g_mysql.Query(SQLCPSelect2, query, dp);
		}

		else if(results.FetchRow() == false)
		{
			int personalHour = (RoundToFloor(g_timerTime[other]) / 3600) % 24;
			int personalMinute = (RoundToFloor(g_timerTime[other]) / 60) % 60;
			int personalSecond = RoundToFloor(g_timerTime[other]) % 60;

			FinishMSG(other, false, false, true, true, false, cpnum, personalHour, personalMinute, personalSecond, 0, 0, 0);
			FinishMSG(g_partner[other], false, false, true, true, false, cpnum, personalHour, personalMinute, personalSecond, 0, 0, 0);
		}
	}
}

public void SQLCPSelect2(Database db, DBResultSet results, const char[] error, DataPack data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLCPSelect2: %s", error);
	}

	else if(strlen(error) == 0)
	{
		data.Reset();

		int other = GetClientFromSerial(data.ReadCell());
		int cpnum = data.ReadCell();

		int personalHour = (RoundToFloor(g_timerTime[other]) / 3600) % 24;
		int personalMinute = (RoundToFloor(g_timerTime[other]) / 60) % 60;
		int personalSecond = RoundToFloor(g_timerTime[other]) % 60;

		if(results.FetchRow() == true)
		{
			g_cpTime[cpnum] = results.FetchFloat(0);

			if(g_cpTimeClient[cpnum][other] < g_cpTime[cpnum])
			{
				gF_cpDiff[cpnum][other] = g_cpTime[cpnum] - g_cpTimeClient[cpnum][other];
				gF_cpDiff[cpnum][g_partner[other]] = g_cpTime[cpnum] - g_cpTimeClient[cpnum][other];

				int srCPHour = (RoundToFloor(gF_cpDiff[cpnum][other]) / 3600) % 24;
				int srCPMinute = (RoundToFloor(gF_cpDiff[cpnum][other]) / 60) % 60;
				int srCPSecond = RoundToFloor(gF_cpDiff[cpnum][other]) % 60;

				FinishMSG(other, false, false, true, false, true, cpnum, personalHour, personalMinute, personalSecond, srCPHour, srCPMinute, srCPSecond);
				FinishMSG(g_partner[other], false, false, true, false, true, cpnum, personalHour, personalMinute, personalSecond, srCPHour, srCPMinute, srCPSecond);
			}

			else
			{
				gF_cpDiff[cpnum][other] = g_cpTimeClient[cpnum][other] - g_cpTime[cpnum];
				gF_cpDiff[cpnum][g_partner[other]] = g_cpTimeClient[cpnum][other] - g_cpTime[cpnum];

				int srCPHour = (RoundToFloor(gF_cpDiff[cpnum][other]) / 3600) % 24;
				int srCPMinute = (RoundToFloor(gF_cpDiff[cpnum][other]) / 60) % 60;
				int srCPSecond = RoundToFloor(gF_cpDiff[cpnum][other]) % 60;

				FinishMSG(other, false, false, true, false, false, cpnum, personalHour, personalMinute, personalSecond, srCPHour, srCPMinute, srCPSecond);
				FinishMSG(g_partner[other], false, false, true, false, false, cpnum, personalHour, personalMinute, personalSecond, srCPHour, srCPMinute, srCPSecond);
			}
		}

		else if(results.FetchRow() == false)
		{
			FinishMSG(other, false, false, true, true, false, cpnum, personalHour, personalMinute, personalSecond, 0, 0, 0);
			FinishMSG(g_partner[other], false, false, true, true, false, cpnum, personalHour, personalMinute, personalSecond, 0, 0, 0);
		}
	}
}

public void SQLSetTries(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLSetTries: %s", error);
	}

	else if(strlen(error) == 0)
	{
		#if debug
		PrintToServer("SQLSetTries callback is finished.");
		#endif
	}
}

public Action cmd_createzones(int args)
{
	g_mysql.Query(SQLCreateZonesTable, "CREATE TABLE IF NOT EXISTS zones (id INT AUTO_INCREMENT, map VARCHAR(128), type INT, possition_x INT, possition_y INT, possition_z INT, possition_x2 INT, possition_y2 INT, possition_z2 INT, PRIMARY KEY (id))"); //https://stackoverflow.com/questions/8114535/mysql-1075-incorrect-table-definition-autoincrement-vs-another-key

	return Plugin_Continue;
}

public void SQLConnect(Database db, const char[] error, any data)
{
	if(db != INVALID_HANDLE)
	{
		PrintToServer("Successfuly connected to database."); //https://hlmod.ru/threads/sourcepawn-urok-13-rabota-s-bazami-dannyx-mysql-sqlite.40011/

		g_mysql = db;

		g_mysql.SetCharset("utf8"); //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-core.sp#L2883

		ForceZonesSetup(); //https://sm.alliedmods.net/new-api/dbi/__raw

		g_dbPassed = true; //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-stats.sp#L199

		char query[512] = "";

		Format(query, sizeof(query), "SELECT time FROM records WHERE map = '%s' ORDER BY time LIMIT 1", g_map);

		g_mysql.Query(SQLGetServerRecord, query);

		RecalculatePoints();
	}

	else if(db == INVALID_HANDLE)
	{
		PrintToServer("Failed to connect to database. (%s)", error);
	}
}

public void ForceZonesSetup()
{
	char query[512] = "";

	Format(query, sizeof(query), "SELECT possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2 FROM zones WHERE map = '%s' AND type = 0 LIMIT 1", g_map);

	g_mysql.Query(SQLSetZoneStart, query);
}

public void SQLSetZoneStart(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLSetZoneStart: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.FetchRow() == true)
		{
			g_zoneStartOrigin[0][0] = results.FetchFloat(0);
			g_zoneStartOrigin[0][1] = results.FetchFloat(1);
			g_zoneStartOrigin[0][2] = results.FetchFloat(2);

			g_zoneStartOrigin[1][0] = results.FetchFloat(3);
			g_zoneStartOrigin[1][1] = results.FetchFloat(4);
			g_zoneStartOrigin[1][2] = results.FetchFloat(5);

			CreateStart();

			char query[512];

			Format(query, sizeof(query), "SELECT possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2 FROM zones WHERE map = '%s' AND type = 1 LIMIT 1", g_map);

			g_mysql.Query(SQLSetZoneEnd, query);
		}
	}
}

public void SQLSetZoneEnd(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLSetZoneEnd: %s", error);
	}

	else if(strlen(error) == 0)
	{
		if(results.FetchRow() == true)
		{
			g_zoneEndOrigin[0][0] = results.FetchFloat(0);
			g_zoneEndOrigin[0][1] = results.FetchFloat(1);
			g_zoneEndOrigin[0][2] = results.FetchFloat(2);

			g_zoneEndOrigin[1][0] = results.FetchFloat(3);
			g_zoneEndOrigin[1][1] = results.FetchFloat(4);
			g_zoneEndOrigin[1][2] = results.FetchFloat(5);

			CreateEnd();
		}
	}
}

public void SQLCreateZonesTable(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error) > 0)
	{
		PrintToServer("SQLCreateZonesTable: %s", error);
	}

	else if(strlen(error) == 0)
	{
		PrintToServer("Zones table is successfuly created.");
	}
}

/*public void DrawZone(int client, float life, float size, int speed)
{
	float start[24][3];
	float end[24][3];

	start[0][0] = (g_zoneStartOrigin[0][0] < g_zoneStartOrigin[1][0]) ? g_zoneStartOrigin[0][0] : g_zoneStartOrigin[1][0]; //zones calculation from tengu (tengulawl)
	start[0][1] = (g_zoneStartOrigin[0][1] < g_zoneStartOrigin[1][1]) ? g_zoneStartOrigin[0][1] : g_zoneStartOrigin[1][1];
	start[0][2] = (g_zoneStartOrigin[0][2] < g_zoneStartOrigin[1][2]) ? g_zoneStartOrigin[0][2] : g_zoneStartOrigin[1][2];

	start[0][2] += size;

	end[0][0] = (g_zoneStartOrigin[0][0] > g_zoneStartOrigin[1][0]) ? g_zoneStartOrigin[0][0] : g_zoneStartOrigin[1][0];
	end[0][1] = (g_zoneStartOrigin[0][1] > g_zoneStartOrigin[1][1]) ? g_zoneStartOrigin[0][1] : g_zoneStartOrigin[1][1];
	end[0][2] = (g_zoneStartOrigin[0][2] > g_zoneStartOrigin[1][2]) ? g_zoneStartOrigin[0][2] : g_zoneStartOrigin[1][2];

	end[0][2] += size;

	start[1][0] = (g_zoneEndOrigin[0][0] < g_zoneEndOrigin[1][0]) ? g_zoneEndOrigin[0][0] : g_zoneEndOrigin[1][0];
	start[1][1] = (g_zoneEndOrigin[0][1] < g_zoneEndOrigin[1][1]) ? g_zoneEndOrigin[0][1] : g_zoneEndOrigin[1][1];
	start[1][2] = (g_zoneEndOrigin[0][2] < g_zoneEndOrigin[1][2]) ? g_zoneEndOrigin[0][2] : g_zoneEndOrigin[1][2];

	start[1][2] += size;

	end[1][0] = (g_zoneEndOrigin[0][0] > g_zoneEndOrigin[1][0]) ? g_zoneEndOrigin[0][0] : g_zoneEndOrigin[1][0];
	end[1][1] = (g_zoneEndOrigin[0][1] > g_zoneEndOrigin[1][1]) ? g_zoneEndOrigin[0][1] : g_zoneEndOrigin[1][1];
	end[1][2] = (g_zoneEndOrigin[0][2] > g_zoneEndOrigin[1][2]) ? g_zoneEndOrigin[0][2] : g_zoneEndOrigin[1][2];

	end[1][2] += size;

	//int zones = 1;
	int zones = 1;
	//PrintToServer("zones: %i", zones);

	if(g_cpCount > 0)
	{
		zones += g_cpCount;
		//PrintToServer("a g_cpCount: %i", zones)

		for(int i = 2; i < zones; i++)
		{
			int cpnum = i - 1;
			//int cpnum = i
			//PrintToServer("z %i", i)
			
			start[i][0] = (g_cpPos[0][cpnum][0] < g_cpPos[1][cpnum][0]) ? g_cpPos[0][cpnum][0] : g_cpPos[1][cpnum][0];
			start[i][1] = (g_cpPos[0][cpnum][1] < g_cpPos[1][cpnum][1]) ? g_cpPos[0][cpnum][1] : g_cpPos[1][cpnum][1];
			start[i][2] = (g_cpPos[0][cpnum][2] < g_cpPos[1][cpnum][2]) ? g_cpPos[0][cpnum][2] : g_cpPos[1][cpnum][2];

			start[i][2] += size;

			end[i][0] = (g_cpPos[0][cpnum][0] > g_cpPos[1][cpnum][0]) ? g_cpPos[0][cpnum][0] : g_cpPos[1][cpnum][0];
			end[i][1] = (g_cpPos[0][cpnum][1] > g_cpPos[1][cpnum][1]) ? g_cpPos[0][cpnum][1] : g_cpPos[1][cpnum][1];
			end[i][2] = (g_cpPos[0][cpnum][2] > g_cpPos[1][cpnum][2]) ? g_cpPos[0][cpnum][2] : g_cpPos[1][cpnum][2];

			end[i][2] += size;
		}
	}

	float corners[24][8][3]; //https://github.com/tengulawl/scripting/blob/master/include/tengu_stocks.inc

	for(int i = 0; i <= zones; i++)
	{
		//bottom left front
		corners[i][0][0] = start[i][0];
		corners[i][0][1] = start[i][1];
		corners[i][0][2] = start[i][2];

		//bottom right front
		corners[i][1][0] = end[i][0];
		corners[i][1][1] = start[i][1];
		corners[i][1][2] = start[i][2];

		//bottom right back
		corners[i][2][0] = end[i][0];
		corners[i][2][1] = end[i][1];
		corners[i][2][2] = start[i][2];

		//bottom left back
		corners[i][3][0] = start[i][0];
		corners[i][3][1] = end[i][1];
		corners[i][3][2] = start[i][2];

		int modelType = 0;

		if(i == 1)
		{
			modelType = 1;
		}

		else if(i > 1)
		{
			modelType = 2;
		}

		for(int j = 0; j <= 3; j++)
		{
			int k = j + 1;

			if(j == 3)
			{
				k = 0;
			}

			int color[4];
			
			TE_SetupBeamPoints(corners[i][j], corners[i][k], g_zoneModel[modelType], 0, 0, 0, life, size, size, 0, 0.0, color, speed); //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-zones.sp#L3050
			TE_SendToClient(client);
		}
	}
}*/

public void ResetFactory(int client)
{
	g_readyToStart[client] = true;
	//g_timerTime[client] = 0.0;
	g_state[client] = false;
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	if(IsFakeClient(client) == false)
	{
		g_entityFlags[client] = GetEntityFlags(client);

		g_entityButtons[client] = buttons;

		bool convar = GetConVarBool(gCV_bhop);

		if(convar == true && g_bhop[client] == true && buttons & IN_JUMP && IsPlayerAlive(client) == true && !(GetEntityFlags(client) & FL_ONGROUND) && GetEntProp(client, Prop_Data, "m_nWaterLevel") <= 1 && !(GetEntityMoveType(client) & MOVETYPE_LADDER)) //https://sm.alliedmods.net/new-api/entity_prop_stocks/GetEntityFlags https://forums.alliedmods.net/showthread.php?t=127948
		{
			buttons &= ~IN_JUMP; //https://stackoverflow.com/questions/47981/how-do-you-set-clear-and-toggle-a-single-bit https://forums.alliedmods.net/showthread.php?t=192163
			//return Plugin_Continue;
		}

		//Timer
		if(g_state[client] == true && g_partner[client] > 0)
		{
			g_timerTime[client] = GetEngineTime() - g_timerTimeStart[client];

			//https://forums.alliedmods.net/archive/index.php/t-23912.html ShAyA format OneEyed format second
			int hour = (RoundToFloor(g_timerTime[client]) / 3600) % 24; //https://forums.alliedmods.net/archive/index.php/t-187536.html
			int minute = (RoundToFloor(g_timerTime[client]) / 60) % 60;
			int second = RoundToFloor(g_timerTime[client]) % 60;

			Format(g_clantag[client][1], 256, "%02.i:%02.i:%02.i", hour, minute, second);

			if(IsPlayerAlive(client) == false)
			{
				ResetFactory(client);
				ResetFactory(g_partner[client]);
				//return Plugin_Continue;
			}
			//return Plugin_Continue;
		}

		if(g_skyBoost[client] > 0)
		{
			if(g_skyBoost[client] == 1)
			{
				g_skyBoost[client] = 2;
				//return Plugin_Continue;
			}

			else if(g_skyBoost[client] == 2)
			{
				TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, g_skyVel[client]);

				g_skyBoost[client] = 0;
				//return Plugin_Continue;
			}
			//return Plugin_Continue;
		}

		if(g_boost[client] > 0)
		{
			//float velocity[3];
			float velocity[3];

			if(g_boost[client] == 2)
			{
				velocity[0] = g_clientVel[client][0] - g_entityVel[client][0];
				velocity[1] = g_clientVel[client][1] - g_entityVel[client][1];
				velocity[2] = g_entityVel[client][2];

				TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, velocity);

				g_boost[client] = 3;

				//return Plugin_Continue;
			}

			else if(g_boost[client] == 3) //Let make loop finish and come back to here.
			{
				GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velocity);

				if(g_groundBoost[client] == true)
				{
					velocity[0] += g_entityVel[client][0];
					velocity[1] += g_entityVel[client][1];
					velocity[2] += g_entityVel[client][2];
					//return Plugin_Continue;
				}

				else
				{
					velocity[0] += g_entityVel[client][0] * 0.135;
					velocity[1] += g_entityVel[client][1] * 0.135;
					//return Plugin_Continue;
				}

				TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, velocity); //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L171-L192

				g_boost[client] = 0;

				g_mlsVel[client][1][0] = velocity[0];
				g_mlsVel[client][1][1] = velocity[1];

				MLStats(client, false);
				//return Plugin_Continue;
			}
		}
		/*if(IsPlayerAlive(client) == true && (g_partner[client] > 0 || g_devmap == true))
		{
			if(buttons & IN_USE)
			{
				if(GetEntProp(client, Prop_Data, "m_afButtonPressed") & IN_USE)
				{
					g_pingTime[client] = GetEngineTime();
					g_pingLock[client] = false;
					//return Plugin_Continue;
				}
				//return Plugin_Continue;
			}

			else if(!(buttons & IN_USE))
			{
				if(g_pingLock[client] == false)
				{
					g_pingLock[client] = true;
					//return Plugin_Continue;
				}
				//return Plugin_Continue;
			}

			if(g_pingLock[client] == false && GetEngineTime() - g_pingTime[client] > 0.7)
			{
				g_pingLock[client] = true;

				if(g_pingModel[client] > 0)
				{
					if(IsValidEntity(g_pingModel[client]))
					{
						RemoveEntity(g_pingModel[client]);
						//return Plugin_Continue;
					}

					g_pingModel[client] = 0;

					KillTimer(g_pingTimer[client]);
				}

				g_pingModel[client] = CreateEntityByName("prop_dynamic_override"); //https://www.bing.com/search?q=prop_dynamic_override&cvid=0babe0a3c6cd43aa9340fa9c3c2e0f78&aqs=edge..69i57.409j0j1&pglt=299&FORM=ANNTA1&PC=U531

				SetEntityModel(g_pingModel[client], "models/trueexpert/pingtool/pingtool.mdl");

				DispatchSpawn(g_pingModel[client]);

				SetEntProp(g_pingModel[client], Prop_Data, "m_fEffects", 16); //https://pastebin.com/SdNC88Ma https://developer.valvesoftware.com/wiki/Effect_flags

				float start[3];
				float angle[3];
				float end[3];

				GetClientEyePosition(client, start);

				GetClientEyeAngles(client, angle);

				GetAngleVectors(angle, angle, NULL_VECTOR, NULL_VECTOR);

				for(int i = 0; i <= 2; i++)
				{
					angle[i] *= 8192.0;
					end[i] = start[i] + angle[i]; //Thanks to rumour for pingtool original code.
				}

				TR_TraceRayFilter(start, end, MASK_SOLID, RayType_EndPoint, TraceEntityFilterPlayer, client);

				if(TR_DidHit(null))
				{
					TR_GetEndPosition(end);

					float normal[3];

					TR_GetPlaneNormal(null, normal); //https://github.com/alliedmodders/sourcemod/commit/1328984e0b4cb2ca0ee85eaf9326ab97df910483

					GetVectorAngles(normal, normal);

					GetAngleVectors(normal, angle, NULL_VECTOR, NULL_VECTOR);

					for(int i = 0; i <= 2; i++)
					{
						end[i] += angle[i];
					}

					normal[0] -= 270.0;

					SetEntPropVector(g_pingModel[client], Prop_Data, "m_angRotation", normal);
					//return Plugin_Continue;
				}

				if(g_color[client][1] == true)
				{
					SetEntityRenderColor(g_pingModel[client], g_colorBuffer[client][0][1], g_colorBuffer[client][1][1], g_colorBuffer[client][2][1], 255);
					//return Plugin_Continue;
				}

				TeleportEntity(g_pingModel[client], end, NULL_VECTOR, NULL_VECTOR);

				//https://forums.alliedmods.net/showthread.php?p=1080444
				if(g_color[client][1] == true)
				{
					int color[4];

					for(int i = 0; i <= 2; i++)
					{
						color[i] = g_colorBuffer[client][i][1];
						//return Plugin_Continue
					}

					color[3] = 255;

					TE_SetupBeamPoints(start, end, g_laserBeam, 0, 0, 0, 0.5, 1.0, 1.0, 0, 0.0, color, 0);
					//return Plugin_Continue;
				}

				else if(g_color[client][1] == false)
				{
					int color[4];

					for(int i = 0; i < 4; i++)
					{
						color[i] = 255;
					}

					TE_SetupBeamPoints(start, end, g_laserBeam, 0, 0, 0, 0.5, 1.0, 1.0, 0, 0.0, color, 0);
					//return Plugin_Continue;
				}

				if(LibraryExists("trueexpert-entityfilter") == true)
				{
					SDKHook(g_pingModel[client], SDKHook_SetTransmit, SDKSetTransmitPing);

					g_pingModelOwner[g_pingModel[client]] = client;

					int clients[MAXPLAYER]; // 64 + 1
					int count = 0;

					for(int i = 1; i <= MaxClients; i++)
					{
						if(IsClientInGame(i) == true)
						{
							int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget");

							if(g_partner[client] == g_partner[g_partner[i]] || i == client || observerTarget == client)
							{
								clients[count++] = i;
								//return Plugin_Continue;
							}
							//return Plugin_Continue;
						}
						//return Plugin_Continue;
					}

					TE_Send(clients, count);

					EmitSound(clients, count, "trueexpert/pingtool/click.wav", client);
					//return Plugin_Continue;
				}

				else if(LibraryExists("trueepxert-entityfilter") == false)
				{
					TE_SendToAll();

					EmitSoundToAll("trueexpert/pingtool/click.wav", client);
					//return Plugin_Continue;
				}

				g_pingTimer[client] = CreateTimer(3.0, timer_removePing, client, TIMER_FLAG_NO_MAPCHANGE);
				//return Plugin_Continue;
			}
		}*/
		ConVar cvPhysics = FindConVar("sv_turbophysics");
		//int physics = g_turbophysics.IntValue;
		//int physics = cvPhysics = FindConVar("sv_turbophysics");
		int physics = cvPhysics.IntValue;
		//if(g_turbophysics.IntValue == 0)
		//if(GetConVarInt(g_turbophysics) == 0)
		if(physics == 0)
		{
			if(IsPlayerAlive(client) == true)
			{
				if(g_block[client] == true && GetEntProp(client, Prop_Data, "m_CollisionGroup") != 5)
				{
					SetEntProp(client, Prop_Data, "m_CollisionGroup", 5);
					//return Plugin_Continue;
				}

				else if(g_block[client] == false && GetEntProp(client, Prop_Data, "m_CollisionGroup") != 2)
				{
					SetEntProp(client, Prop_Data, "m_CollisionGroup", 2);
					//return Plugin_Continue;
				}
				//return Plugin_Continue;
			}
		}

		/*if(g_zoneDraw[client] == true)
		{
			if(GetEngineTime() - g_engineTime >= 0.1)
			{
				g_engineTime = GetEngineTime();

				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) == true)
					{
						DrawZone(i, 0.1, 3.0, 10);
						//return Plugin_Continue;
					}
					//return Plugin_Continue;
				}
				//return Plugin_Continue;
			}
			//return Plugin_Continue;
		}*/

		if(IsClientObserver(client) == true && GetEntProp(client, Prop_Data, "m_afButtonPressed") & IN_USE) //Make able to swtich wtih E to the partner via spectate.
		{
			int observerTarget = GetEntPropEnt(client, Prop_Data, "m_hObserverTarget");
			int observerMode = GetEntProp(client, Prop_Data, "m_iObserverMode");

			if(0 < observerTarget <= MaxClients && g_partner[observerTarget] > 0 && IsPlayerAlive(g_partner[observerTarget]) == true && observerMode < 7)
			{
				SetEntPropEnt(client, Prop_Data, "m_hObserverTarget", g_partner[observerTarget]);
				//return Plugin_Continue;
			}
			//return Plugin_Continue;
		}

		if(GetEngineTime() - g_hudTime[client] >= 0.1)
		{
			g_hudTime[client] = GetEngineTime();

			Hud(client);
			//return Plugin_Continue;
		}

		if(GetEntityFlags(client) & FL_ONGROUND)
		{
			if(g_mlsCount[client] > 0)
			{
				int groundEntity = GetEntPropEnt(client, Prop_Data, "m_hGroundEntity");

				char class[32];

				if(IsValidEntity(groundEntity) == true)
				{
					GetEntityClassname(groundEntity, class, sizeof(class));
					//return Plugin_Continue;
				}

				if(StrEqual(class, "flashbang_projectile", false) == false)
				{
					GetClientAbsOrigin(client, g_mlsDistance[client][1]);

					MLStats(client, true);

					g_mlsCount[client] = 0;

					//return Plugin_Continue;
				}

				//return Plugin_Continue;
			}
		}

		int other = Stuck(client);

		if(0 < other <= MaxClients && IsPlayerAlive(client) == true && g_block[other] == true)
		{
			if(GetEntProp(other, Prop_Data, "m_CollisionGroup") == 5)
			{
				SetEntProp(other, Prop_Data, "m_CollisionGroup", 2);

				//if(g_color[other][0] == true)
				//{
					//SetEntityRenderColor(other, g_colorBuffer[other][0][0], g_colorBuffer[other][1][0], g_colorBuffer[other][2][0], 125);
				SetEntityRenderColor(other, 255, 255, 255, 125);
					//return Plugin_Continue;
				//}

				//else if(g_color[other][0] == false)
				//{
					//SetEntityRenderColor(other, 255, 255, 255, 125);
					//return Plugin_Continue;
				//}
				//return Plugin_Continue;
			}
		}

		else if(IsPlayerAlive(client) == true && other == -1 && g_block[client] == true)
		{
			if(GetEntProp(client, Prop_Data, "m_CollisionGroup") == 2)
			{
				SetEntProp(client, Prop_Data, "m_CollisionGroup", 5);

				//if(g_color[client][0] == true)
				//{
					//SetEntityRenderColor(client, g_colorBuffer[client][0][0], g_colorBuffer[client][1][0], g_colorBuffer[client][2][0], 255);
				SetEntityRenderColor(client, 255, 255, 255, 255);
					//return Plugin_Continue;
				//}

				//else if(g_color[client][0] == false)
				//{
					//SetEntityRenderColor(client, 255, 255, 255, 255);
					//return Plugin_Continue;
				//}
				//return Plugin_Continue;
			}
			//return Plugin_Continue;
		}

		if(g_devmap == false)
		{
			//if(IsPlayerAlive(client) == true && g_partner[client] == false)
			if(IsPlayerAlive(client) == true && g_partner[client] == 0)
			{
				if(buttons & IN_USE)
				{
					if(GetEntProp(client, Prop_Data, "m_afButtonPressed") & IN_USE)
					{
						g_partnerInHold[client] = GetEngineTime();
						g_partnerInHoldLock[client] = false;
						//return Plugin_Continue;
					}
					//return Plugin_Continue;
				}

				else if(!(buttons & IN_USE))
				{
					if(g_partnerInHoldLock[client] == false)
					{
						g_partnerInHoldLock[client] = true;
						//return Plugin_Continue;
					}
					//return Plugin_Continue;
				}

				if(g_partnerInHoldLock[client] == false && GetEngineTime() - g_partnerInHold[client] > 0.7)
				{
					g_partnerInHoldLock[client] = true;

					Partner(client);

					//return Plugin_Continue;
				}
				//return Plugin_Continue;
			}

			if(buttons & IN_RELOAD)
			{
				if(GetEntProp(client, Prop_Data, "m_afButtonPressed") & IN_RELOAD)
				{
					g_restartInHold[client] = GetEngineTime();

					g_restartInHoldLock[client] = false;

					//return Plugin_Continue;
				}
				//return Plugin_Continue;
			}

			else if(!(buttons & IN_RELOAD))
			{
				if(g_restartInHoldLock[client] == false)
				{
					g_restartInHoldLock[client] = true;
					//return Plugin_Continue;
				}
				//return Plugin_Continue;
			}

			if(g_restartInHoldLock[client] == false && GetEngineTime() - g_restartInHold[client] > 0.7)
			{
				g_restartInHoldLock[client] = true;

				if(g_partner[client] > 0)
				{
					Restart(client);
					Restart(g_partner[client]);
					//return Plugin_Continue;
				}

				else if(g_partner[client] == 0)
				{
					Partner(client);
					//return Plugin_Continue;
				}
				//return Plugin_Continue;
			}
			//return Plugin_Continue;
		}

		float convarMacro = GetConVarFloat(gCV_macro);

		if(convarMacro == 1.0)
		{
			if(buttons & IN_ATTACK2)
			{
				char classname[32];
				GetClientWeapon(client, classname, sizeof(classname));

				if(StrEqual(classname, "weapon_flashbang", false))
				{
					if(g_macroOpened[client] == false && (g_macroTime[client] == 0.0 || GetEngineTime() - g_macroTime[client] >= 0.34))
					{
						g_macroTime[client] = GetEngineTime();
						g_macroOpened[client] = true;
					}
	
					if(g_macroOpened[client] == true && GetEngineTime() - g_macroTime[client] <= 0.02)
					{
						buttons |= IN_ATTACK;
					}
				}
			}
			
			if(g_macroOpened[client] == true && GetEngineTime() - g_macroTime[client] >= 0.11)
			{
				buttons |= IN_JUMP;
				g_macroTime[client] = GetEngineTime();
				g_macroOpened[client] = false;
			}
		}

		return Plugin_Continue;
	}

	else if(IsFakeClient(client) == true)
	{
		return Plugin_Continue;
	}

	return Plugin_Continue;
}

public Action ProjectileBoostFix(int entity, int other)
{
	if(0 < other <= MaxClients && IsClientInGame(other) == true && g_boost[other] == 0 && !(g_entityFlags[other] & FL_ONGROUND))
	{
		float originOther[3];
		GetClientAbsOrigin(other, originOther);

		float originEntity[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", originEntity);

		float maxsEntity[3];
		GetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxsEntity);

		float delta = originOther[2] - originEntity[2] - maxsEntity[2];
		PrintToServer("%f", delta);
		//Thanks to extremix/hornet for idea from 2019 year summer. Extremix version (if(!(clientOrigin[2] - 5 <= entityOrigin[2] <= clientOrigin[2])) //Calculate for Client/Flash - Thanks to extrem)/tengu code from github https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L231 //https://forums.alliedmods.net/showthread.php?t=146241
		if(0.0 < delta < 2.0) //Tengu code from github https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L231
		{
			GetEntPropVector(entity, Prop_Data, "m_vecAbsVelocity", g_entityVel[other]);
			GetEntPropVector(other, Prop_Data, "m_vecAbsVelocity", g_clientVel[other]);

			g_boostTime[other] = GetEngineTime();
			g_groundBoost[other] = g_bouncedOff[entity];

			SetEntProp(entity, Prop_Send, "m_nSolidType", 0); //https://forums.alliedmods.net/showthread.php?t=286568 non model no solid model Gray83 author of solid model types.

			g_flash[other] = EntIndexToEntRef(entity); //Thats should never happen.
			g_boost[other] = 1;

			float vel[3];
			GetEntPropVector(other, Prop_Data, "m_vecAbsVelocity", vel);

			g_mlsVel[other][0][0] = vel[0];
			g_mlsVel[other][0][1] = vel[1];

			g_mlsCount[other]++;

			if(g_mlsCount[other] == 1)
			{
				GetClientAbsOrigin(other, g_mlsDistance[other][0]);
				//return Plugin_Continue;
			}

			g_mlsFlyer[other] = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity");
			//return Plugin_Continue;
		}
		//return Plugin_Continue;
	}
	//else
	//{
	return Plugin_Continue;
	//}
}

public Action cmd_devmap(int client, int args)
{
	if(GetEngineTime() - g_devmapTime > 35.0 && GetEngineTime() - g_afkTime > 30.0)
	{
		g_voters = 0;

		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) == true && IsClientSourceTV(i) == false && IsFakeClient(i) == false)
			{
				g_voters++;

				if(g_devmap == true)
				{
					Menu menu = new Menu(devmap_handler);

					menu.SetTitle("Turn off dev map?");

					menu.AddItem("yes", "Yes");
					menu.AddItem("no", "No");

					menu.Display(i, 20);
				}

				else if(g_devmap == false)
				{
					Menu menu = new Menu(devmap_handler);

					menu.SetTitle("Turn on dev map?");

					menu.AddItem("yes", "Yes");
					menu.AddItem("no", "No");
					menu.Display(i, 20);

					//return Plugin_Continue;
				}
			}
		}

		g_devmapTime = GetEngineTime();

		CreateTimer(20.0, timer_devmap, TIMER_FLAG_NO_MAPCHANGE);

		//PrintToChatAll("Devmap vote started by %N", client);
		char name[MAX_NAME_LENGTH];
		GetClientName(client, name, sizeof(name));

		PrintToChatAll("\x01%T", "DevMapStart", client, name);

		//return Plugin_Handled;
	}

	else if(GetEngineTime() - g_devmapTime <= 35.0 || GetEngineTime() - g_afkTime <= 30.0)
	{
		//PrintToChat(client, "Devmap vote is not allowed yet.");
		PrintToChat(client, "\x01%T", "DevMapNotAllowed", client);

		//return Plugin_Handled;
	}

	return Plugin_Handled;
}

public int devmap_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
				{
					g_devmapCount[1]++;

					g_voters--;

					Devmap(false);
					//return param2;
				}

				case 1:
				{
					g_devmapCount[0]++;

					g_voters--;

					Devmap(false);
					//return param2;
				}
				//return param2;
			}
			return param2;
		}
		//return param2;
	}
	return param2;
}

public Action timer_devmap(Handle timer)
{
	//devmap idea by expert zone. thanks to ed and maru. thanks to lon to give tp idea for server i could made it like that "profesional style".
	Devmap(true);

	return Plugin_Continue;
}

public void Devmap(bool force)
{
	if(force == true || g_voters == 0)
	{
		if((g_devmapCount[1] > 0 || g_devmapCount[0] > 0) && g_devmapCount[1] >= g_devmapCount[0])
		{
			if(g_devmap == true)
			{
				PrintToChatAll("Devmap will be disabled. \"Yes\" %i%%% or %i of %i players.", (g_devmapCount[1] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[1], g_devmapCount[0] + g_devmapCount[1]);
			}

			else if(g_devmap == false)
			{
				PrintToChatAll("Devmap will be enabled. \"Yes\" %i%%% or %i of %i players.", (g_devmapCount[1] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[1], g_devmapCount[0] + g_devmapCount[1]);
			}

			CreateTimer(5.0, timer_changelevel, g_devmap ? false : true);
		}

		else if((g_devmapCount[1] || g_devmapCount[0]) && g_devmapCount[1] <= g_devmapCount[0])
		{
			if(g_devmap == true)
			{
				//PrintToChatAll("Devmap will be continue. \"No\" chose %i%%% or %i of %i players.", (g_devmapCount[0] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[0], g_devmapCount[0] + g_devmapCount[1]); //google translate russian to english.
				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i))
					{
						PrintToChat(i, "\x01%T", "DevMapContinue", i, (g_devmapCount[0] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[0], g_devmapCount[0] + g_devmapCount[1]);
					}
				}
			}

			else if(g_devmap == false)
			{
				//char format[256];
				//Format(format, sizeof(format), "\x01%T", "DevMapWillNotBe", (g_devmapCount[0] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[0], g_devmapCount[0] + g_devmapCount[1]);
				//PrintToChatAll(format);
				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i))
					{
						PrintToChat(i, "\x01%T", "DevMapWillNotBe", i, (g_devmapCount[0] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[0], g_devmapCount[0] + g_devmapCount[1]);
					}
				}
				//PrintToChatAll("Devmap will not be enabled. \"No\" chose %i%%% or %i of %i players.", (g_devmapCount[0] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[0], g_devmapCount[0] + g_devmapCount[1]);
			}
		}

		for(int i = 0; i <= 1; i++)
		{
			g_devmapCount[i] = 0;
		}
	}

	return;
}

public Action timer_changelevel(Handle timer, bool value)
{
	g_devmap = value;

	ForceChangeLevel(g_map, "Reason: Devmap");

	return Plugin_Continue;
}

public Action cmd_top(int client, int args)
{
	CreateTimer(0.1, timer_motd, client, TIMER_FLAG_NO_MAPCHANGE); //OnMapStart() is not work from first try.

	return Plugin_Handled;
}

public Action timer_motd(Handle timer, int client)
{
	if(IsClientInGame(client) == true)
	{
		ConVar hostname = FindConVar("hostname");

		char hostnameBuffer[256];

		hostname.GetString(hostnameBuffer, sizeof(hostnameBuffer));

		char url[192];

		g_urlTop.GetString(url, sizeof(url));

		Format(url, sizeof(url), "%s%s", url, g_map);

		ShowMOTDPanel(client, hostnameBuffer, url, MOTDPANEL_TYPE_URL); //https://forums.alliedmods.net/showthread.php?t=232476

		//return Plugin_Continue;
	}

	else if(IsClientInGame(client) == false)
	{
		PrintToServer("Player %N (ID: %i) is not in-game.", client, client);

		//return Plugin_Continue;
	}

	return Plugin_Continue;
}

public Action cmd_afk(int client, int args)
{
	bool convar = GetConVarBool(gCV_afk);

	if(convar == true && (GetEngineTime() - g_afkTime > 30.0 && GetEngineTime() - g_devmapTime > 35.0))
	{
		g_voters = 0;

		g_afkClient = client;

		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) == true && IsClientSourceTV(i) == false && IsFakeClient(i) == false && IsPlayerAlive(i) == false && client != i)
			{
				g_afk[i] = false;

				g_voters++;

				Menu menu = new Menu(afk_handler);
				//c
				//menu.SetTitle("Are you here?");
				menu.SetTitle("%T", "AreYouHere?", client);

				//menu.AddItem("yes", "Yes");
				char format[256];
				Format(format, sizeof(format), "%T", "Yes", client);
				menu.AddItem("yes", format);
				char format2[256];
				Format(format, sizeof(format), "%T", "No", client);
				menu.AddItem("no", format2);

				menu.Display(i, 20);
				//return Plugin_Continue;
			}
			//return Plugin_Continue;
		}

		g_afkTime = GetEngineTime();

		CreateTimer(20.0, timer_afk, client, TIMER_FLAG_NO_MAPCHANGE);

		//PrintToChatAll("Afk check - vote started by %N", client);
		char name[MAX_NAME_LENGTH];
		GetClientName(client, name, sizeof(name));
		PrintToChatAll("\x01%T", "AFKCHECK", name, client);

		//return Plugin_Handled;
	}
	else if(GetEngineTime() - g_afkTime <= 30.0 || GetEngineTime() - g_devmapTime <= 35.0)
	{
		//PrintToChat(client, "Afk vote is not allowed yet.");
		//PrintToChatAll("\x01%T");
		PrintToChat(client, "\x01%T", "AFKCHECK2", client);

		//return Plugin_Handled;
	}

	return Plugin_Handled;
}

public int afk_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
				{
					g_afk[param1] = true;

					g_voters--;

					AFK(g_afkClient, false);

					//return param2;
				}

				case 1:
				{
					g_voters--;

					AFK(g_afkClient, false);

					//return param2;
				}
				//return param2;
			}
			return param2;
		}
		//return param2;
	}
	return param2;
}

public Action timer_afk(Handle timer, int client)
{
	//afk idea by expert zone. thanks to ed and maru. thanks to lon to give tp idea for server i could made it like that "profesional style".
	AFK(client, true);

	return Plugin_Continue;
}

public void AFK(int client, bool force)
{
	if(force == true || g_voters == 0)
	{
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) == true && IsPlayerAlive(i) == false && IsClientSourceTV(i) == false && g_afk[i] == false && client != i)
			{
				//KickClient(i, "Away from keyboard");
				KickClient(i, "%T", "AwayFromKeyboard", i);
			}
		}
		//return Plugin_Continue;
	}
}

public Action cmd_noclip(int client, int args)
{
	bool convar = GetConVarBool(gCV_noclip);

	if(convar == true)
	{
		Noclip(client);
	}

	return Plugin_Handled;
}

public void Noclip(int client)
{
	if(0 < client <= MaxClients)
	{
		if(g_devmap == true)
		{
			SetEntityMoveType(client, GetEntityMoveType(client) & MOVETYPE_NOCLIP ? MOVETYPE_WALK : MOVETYPE_NOCLIP);

			//PrintToChat(client, GetEntityMoveType(client) & MOVETYPE_NOCLIP ? "Noclip enabled." : "Noclip disabled.");

			if(GetEntityMoveType(client) & MOVETYPE_NOCLIP)
			{
				PrintToChat(client, "\x01%T", "NoClipEnabled", client);
			}

			else if(!(GetEntityMoveType(client) & MOVETYPE_NOCLIP))
			{
				PrintToChat(client, "\x01%T", "NoClipDisabled", client);
			}
		}

		else if(g_devmap == false)
		{
			//PrintToChat(client, "Turn on devmap.");
			PrintToChat(client, "\x01%T", "DevMapIsOFF", client);
		}
	}
}

public Action cmd_spec(int client, int args)
{
	bool convar = GetConVarBool(gCV_spec);

	if(convar == true)
	{
		ChangeClientTeam(client, CS_TEAM_SPECTATOR);
	}

	return Plugin_Handled;
}

public Action cmd_hud(int client, int args)
{
	Menu menu = new Menu(hud_handler, MenuAction_Start | MenuAction_Select | MenuAction_Display | MenuAction_Cancel);

	menu.SetTitle("Hud");

	menu.AddItem("vel", g_hudVel[client] ? "Velocity [v]" : "Velocity [x]");
	menu.AddItem("mls", g_mlstats[client] ? "ML stats [v]" : "ML stats [x]");

	menu.Display(client, 20);

	return Plugin_Handled;
}

public int hud_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Start: //expert-zone idea. thank to ed, maru.
		{
			g_menuOpened[param1] = true;

			//return param1;
		}

		case MenuAction_Select:
		{
			char value[16];

			switch(param2)
			{
				case 0:
				{
					g_hudVel[param1] = !g_hudVel[param1];

					IntToString(g_hudVel[param1], value, sizeof(value));

					SetClientCookie(param1, g_cookie[0], value);
					//return param1;
				}

				case 1:
				{
					g_mlstats[param1] = !g_mlstats[param1];

					IntToString(g_mlstats[param1], value, sizeof(value));

					SetClientCookie(param1, g_cookie[1], value);
					//return param1;
				}
			}

			cmd_hud(param1, 0);

			//return param2;
		}
		case MenuAction_Cancel:
		{
			g_menuOpened[param1] = false; //Idea from expert zone.
			//return param1;
		}

		case MenuAction_Display:
		{
			g_menuOpened[param1] = true;
			//return param1;
		}
	}

	return param2;
}

public void Hud(int client)
{
	float vel[3];

	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vel);

	float velXY = SquareRoot(Pow(vel[0], 2.0) + Pow(vel[1], 2.0));

	if(g_hudVel[client] == true)
	{
		PrintHintText(client, "%.0f", velXY);
	}

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) == true && IsPlayerAlive(i) == false)
		{
			int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget");
			int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode");

			if(observerMode < 7 && observerTarget == client && g_hudVel[i] == true)
			{
				PrintHintText(i, "%.0f", velXY);
			}
		}
	}

	return;
}

public Action cmd_mlstats(int client, int args)
{
	g_mlstats[client] = !g_mlstats[client];

	char value[16];

	IntToString(g_mlstats[client], value, sizeof(value));

	SetClientCookie(client, g_cookie[1], value);

	//PrintToChat(client, g_mlstats[client] ? "ML stats is on." : "ML stats is off.");

	if(g_mlstats[client] == true)
	{
		PrintToChat(client, "\x01%T", "MLStatsON", client);
	}

	else if(g_mlstats[client] == false)
	{
		PrintToChat(client, "\x01%T", "MLStatsOFF", client);
	}

	return Plugin_Handled;
}

public Action cmd_button(int client, int args)
{
	g_button[client] = !g_button[client];

	char value[16];

	IntToString(g_button[client], value, sizeof(value));

	SetClientCookie(client, g_cookie[2], value);

	//PrintToChat(client, g_button[client] ? "Button announcer is on." : "Button announcer is off.");

	if(g_button[client] == true)
	{
		PrintToChat(client, "\x01%T", "ButtonAnnounserON", client);
	}

	else if(g_button[client] == false)
	{
		PrintToChat(client, "\x01%T", "ButtonAnnonserOFF", client);
	}

	return Plugin_Handled;
}

public Action cmd_pbutton(int client, int args)
{
	g_pbutton[client] = !g_pbutton[client]; //toggling

	char value[16];

	IntToString(g_pbutton[client], value, sizeof(value));

	SetClientCookie(client, g_cookie[3], value);

	//PrintToChat(client, g_pbutton[client] ? "Partner button announcer is on." : "Partner button announcer is off.");

	if(g_pbutton[client] == true)
	{
		PrintToChat(client, "\x01%T", "ButtonAnnouncerPartnerON", client);
	}

	else if(g_pbutton[client] == false)
	{
		PrintToChat(client, "\x01%T", "ButtonAnnouncerPartnerOFF", client);
	}

	return Plugin_Handled;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
	if(IsChatTrigger() == false)
	{
		if(StrEqual(sArgs, "t", false) || StrEqual(sArgs, "trikz", false))
		{
			if(g_menuOpened[client] == false)
			{
				Trikz(client);

				return Plugin_Continue;
			}

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "bl", false) || StrEqual(sArgs, "block", false))
		{
			Block(client);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "p", false) || StrEqual(sArgs, "partner", false))
		{
			Partner(client);

			return Plugin_Continue;
		}

		/*else if(StrEqual(sArgs, "c", false) || StrEqual(sArgs, "color", false)) //white, red, orange, yellow, lime, aqua, deep sky blue, blue, magenta
		{
			ColorZ(client, true, -1);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "c 0", false) || StrEqual(sArgs, "c white", false) || StrEqual(sArgs, "color 0", false) || StrEqual(sArgs, "color white", false))
		{
			ColorZ(client, true, 0);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "c 1", false) || StrEqual(sArgs, "c red", false) || StrEqual(sArgs, "color 1", false) || StrEqual(sArgs, "color red", false))
		{
			ColorZ(client, true, 1);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "c 2", false) || StrEqual(sArgs, "c orange", false) || StrEqual(sArgs, "color 2", false) || StrEqual(sArgs, "color orange", false))
		{
			ColorZ(client, true, 2);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "c 3", false) || StrEqual(sArgs, "c yellow", false) || StrEqual(sArgs, "color 3", false) || StrEqual(sArgs, "color yellow", false))
		{
			ColorZ(client, true, 3);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "c 4", false) || StrEqual(sArgs, "c lime", false) || StrEqual(sArgs, "color 4", false) || StrEqual(sArgs, "color lime", false))
		{
			ColorZ(client, true, 4);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "c 5", false) || StrEqual(sArgs, "c aqua", false) || StrEqual(sArgs, "color 5", false) || StrEqual(sArgs, "color aqua", false))
		{
			ColorZ(client, true, 5);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "c 6", false) || StrEqual(sArgs, "c deep sky blue", false) || StrEqual(sArgs, "color 6", false) || StrEqual(sArgs, "color deep sky blue", false))
		{
			ColorZ(client, true, 6);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "c 7", false) || StrEqual(sArgs, "c blue", false) || StrEqual(sArgs, "color 7", false) || StrEqual(sArgs, "color blue", false))
		{
			ColorZ(client, true, 7);

			return Plugin_Continue;
		}
		else if(StrEqual(sArgs, "c 8", false) || StrEqual(sArgs, "c magenta", false) || StrEqual(sArgs, "color 8", false) || StrEqual(sArgs, "color magenta", false))
		{
			ColorZ(client, true, 8);

			return Plugin_Continue;
		}*/

		else if(StrEqual(sArgs, "r", false) || StrEqual(sArgs, "restart", false))
		{
			Restart(client);

			//if(g_partner[client] == true)
			if(g_partner[client] == 0)
			{
				Restart(g_partner[client]);

				return Plugin_Continue;
			}

			return Plugin_Continue;
		}
		//else if(StrEqual(sArgs, "time"))
		//	cmd_time(client, 0)
		else if(StrEqual(sArgs, "devmap", false))
		{
			cmd_devmap(client, 0);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "top", false))
		{
			cmd_top(client, 0);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "cp", false))
		{
			Checkpoint(client);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "afk", false))
		{
			cmd_afk(client, 0);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "nc", false) || StrEqual(sArgs, "noclip", false))
		{
			Noclip(client);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "sp", false) || StrEqual(sArgs, "spec", false))
		{
			cmd_spec(client, 0);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "hud", false))
		{
			cmd_hud(client, 0);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "mls", false))
		{
			cmd_mlstats(client, 0);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "button", false))
		{
			cmd_button(client, 0);

			return Plugin_Continue;
		}

		else if(StrEqual(sArgs, "pbutton", false))
		{
			cmd_pbutton(client, 0);

			return Plugin_Continue;
		}

		return Plugin_Continue;
	}

	return Plugin_Continue;
}

public Action ProjectileBoostFixEndTouch(int entity, int other)
{
	if(other == 0)
	{
		g_bouncedOff[entity] = true; //Get from Tengu github "tengulawl" scriptig "boost-fix.sp".

		return Plugin_Continue;
	}

	else if(other > 0)
	{
		return Plugin_Continue;
	}

	return Plugin_Continue;
}

public Action cmd_time(int client, int args)
{
	if(IsPlayerAlive(client))
	{
		//https://forums.alliedmods.net/archive/index.php/t-23912.html //ShAyA format OneEyed format second
		int hour = (RoundToFloor(g_timerTime[client]) / 3600) % 24; //https://forums.alliedmods.net/archive/index.php/t-187536.html
		int minute = (RoundToFloor(g_timerTime[client]) / 60) % 60;
		int second = RoundToFloor(g_timerTime[client]) % 60;

		PrintToChat(client, "Time: %02.i:%02.i:%02.i", hour, minute, second);

		if(g_partner[client])
		{
			PrintToChat(g_partner[client], "Time: %02.i:%02.i:%02.i", hour, minute, second);
			return Plugin_Handled;
		}

		return Plugin_Handled;
	}
	else
	{
		int observerTarget = GetEntPropEnt(client, Prop_Data, "m_hObserverTarget");
		int observerMode = GetEntProp(client, Prop_Data, "m_iObserverMode");

		if(observerMode < 7)
		{
			//https://forums.alliedmods.net/archive/index.php/t-23912.html //ShAyA format OneEyed format second
			int hour = (RoundToFloor(g_timerTime[observerTarget]) / 3600) % 24; //https://forums.alliedmods.net/archive/index.php/t-187536.html
			int minute = (RoundToFloor(g_timerTime[observerTarget]) / 60) % 60;
			int second = RoundToFloor(g_timerTime[observerTarget]) % 60;

			PrintToChat(client, "Time: %02.i:%02.i:%02.i", hour, minute, second);

			return Plugin_Handled;
		}

		return Plugin_Handled;
	}
	//return Plugin_Handled;
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if(StrEqual(classname, "flashbang_projectile", false))
	{
		g_bouncedOff[entity] = false; //"Tengulawl" "boost-fix.sp".

		SDKHook(entity, SDKHook_StartTouch, ProjectileBoostFix);
		SDKHook(entity, SDKHook_EndTouch, ProjectileBoostFixEndTouch);
		SDKHook(entity, SDKHook_SpawnPost, SDKProjectile);
		SDKHook(entity, SDKHook_StartTouch, SDKStopSpam);
	}
}

public void SDKProjectile(int entity)
{
	int client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");

	if(IsValidEntity(entity) == true && IsValidEntity(client) == true)
	{
		bool convar = GetConVarBool(gCV_autoflashbang);

		if(convar == true && g_autoflash[client] == true)
		{
			SetEntData(client, FindDataMapInfo(client, "m_iAmmo") + 12 * 4, 2); //https://forums.alliedmods.net/showthread.php?t=114527 https://forums.alliedmods.net/archive/index.php/t-81546.html
		}

		RequestFrame(frame_blockExplosion, entity);

		CreateTimer(1.5, timer_deleteProjectile, entity, TIMER_FLAG_NO_MAPCHANGE);

		/*if(g_color[client][1] == true)
		{
			SetEntProp(entity, Prop_Data, "m_nModelIndex", g_wModelThrown);
			SetEntProp(entity, Prop_Data, "m_nSkin", 1);

			SetEntityRenderColor(entity, g_colorBuffer[client][0][1], g_colorBuffer[client][1][1], g_colorBuffer[client][2][1], 255);
			//return Plugin_Continue;
		}*/
		//return Plugin_Continue;
	}
}

public Action SDKStopSpam(int entity, int other)
{
	if(0 < other <= MaxClients && IsClientInGame(other) == true)
	{
		float originOther[3];
		GetClientAbsOrigin(other, originOther);

		float originEntity[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", originEntity);

		float maxsEntity[3];
		GetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxsEntity);

		float delta = originOther[2] - originEntity[2] - maxsEntity[2];

		if(delta == -66.015251)
		{
			int owner = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity");
			//if(owner < 0)
			//{
				//owner = 0;
				//return Plugin_Continue;
			//}
			g_projectileSoundLoud[owner > 0 ? owner : 0] = entity;

			//return Plugin_Continue;
		}

		//return Plugin_Continue;
	}

	return Plugin_Continue;
}

public void frame_blockExplosion(int entity)
{
	if(IsValidEntity(entity) == true)
	{
		SetEntProp(entity, Prop_Data, "m_nNextThinkTick", 0); //https://forums.alliedmods.net/showthread.php?t=301667 avoid random blinds.
	}

	return;
}

public Action timer_deleteProjectile(Handle timer, int entity)
{
	if(IsValidEntity(entity) == true)
	{
		FlashbangEffect(entity);

		RemoveEntity(entity);

		//return Plugin_Continue;
	}

	return Plugin_Continue;
}

public void FlashbangEffect(const int entity)
{
	bool filter = LibraryExists("trueexpert-entityfilter");

	float origin[3];
	GetEntPropVector(entity, Prop_Send, "m_vecOrigin", origin);

	TE_SetupSmoke(origin, g_smoke, GetRandomFloat(0.5, 1.5), 100); //https://forums.alliedmods.net/showpost.php?p=2552543&postcount=5

	int clients[MAXPLAYER];
	int count = 0;

	if(filter == true)
	{
		int owner = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity");

		if(owner == -1)
		{
			owner = 0;
		}

		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) == true)
			{
				int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget");

				if(g_partner[owner] == g_partner[g_partner[i]] || i == owner || observerTarget == owner)
				{
					clients[count++] = i;
				}
			}
		}

		TE_Send(clients, count);
	}

	else if(filter == false)
	{
		TE_SendToAll();
	}

	float dir[3]; //https://forums.alliedmods.net/showthread.php?t=274452

	dir[0] = GetRandomFloat(-1.0, 1.0);
	dir[1] = GetRandomFloat(-1.0, 1.0);
	dir[2] = GetRandomFloat(-1.0, 1.0);

	TE_SetupSparks(origin, dir, 1, GetRandomInt(1, 2));

	if(filter == true)
	{
		TE_Send(clients, count);
	}

	else if(filter == false)
	{
		TE_SendToAll(); //Idea from "Expert-Zone". So, we just made non empty event.
	}

	char sample[2][PLATFORM_MAX_PATH] = {"weapons/flashbang/flashbang_explode1.wav", "weapons/flashbang/flashbang_explode2.wav"};

	if(filter == true)
	{
		EmitSound(clients, count, sample[GetRandomInt(0, 1)], entity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.1, SNDPITCH_NORMAL);
	}

	else if(filter == false)
	{
		EmitSoundToAll(sample[GetRandomInt(0, 1)], entity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.1, SNDPITCH_NORMAL); //https://www.youtube.com/watch?v=0Dep7RXhetI&list=PL_2MB6_9kLAHnA4mS_byUpgpjPgETJpsV&index=171 https://github.com/Smesh292/Public-SourcePawn-Plugins/blob/master/trikz.sp#L23 So via "GCFScape" we can found "sound/weapons/flashbang", there we can use 2 sounds as random. flashbang_explode1.wav and flashbang_explode2.wav. These sound are similar, so, better to mix via random. https://forums.alliedmods.net/showthread.php?t=167638 https://world-source.ru/forum/100-2357-1 https://sm.alliedmods.net/new-api/sdktools_sound/__raw
	}
}

public Action SDKOnTakeDamage(int victim, int& attacker, int& inflictor, float& damage, int& damagetype)
{
	SetEntPropVector(victim, Prop_Send, "m_vecPunchAngle", NULL_VECTOR); //https://forums.alliedmods.net/showthread.php?p=1687371
	SetEntPropVector(victim, Prop_Send, "m_vecPunchAngleVel", NULL_VECTOR);

	return Plugin_Handled; //Full god-mode.
}

public void SDKWeaponEquip(int client, int weapon) //https://sm.alliedmods.net/new-api/sdkhooks/__raw Thanks to Lon for gave this idea. (aka trikz_failtime)
{
	int convar = GetConVarInt(gCV_autoflashbang);
	
	if(convar == 1 && g_autoflash[client] == true && GetEntData(client, FindDataMapInfo(client, "m_iAmmo") + 12 * 4) == 0)
	{
		GivePlayerItem(client, "weapon_flashbang");
		GivePlayerItem(client, "weapon_flashbang");
	}
}

public Action SDKWeaponDrop(int client, int weapon)
{
	if(IsValidEntity(weapon) == true)
	//if()
	{
		RemoveEntity(weapon);

		return Plugin_Continue;
	}

	else if(IsValidEntity(weapon) == false)
	{
		PrintToServer("Weapon %i is not valid.", weapon);

		return Plugin_Continue;
	}

	return Plugin_Continue;
}

public void SDKThink(int client)
{
	if(IsFakeClient(client) == false)
	{
		if(GetClientButtons(client) & IN_ATTACK)
		{
			g_readyToFix[client] = true;
		}

		if(g_readyToFix[client] == true)
		{
			char classname[32];

			GetClientWeapon(client, classname, sizeof(classname));

			if(StrEqual(classname, "weapon_flashbang", false))
			{
				bool convar = GetConVarBool(gCV_autoswitch);
				
				if(convar == true && g_autoswitch[client] == true && GetEntPropFloat(GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon"), Prop_Send, "m_fThrowTime") > 0.0 && GetEntPropFloat(GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon"), Prop_Send, "m_fThrowTime") < GetGameTime())
				{
					SetEntProp(client, Prop_Data, "m_bDrawViewmodel", false); //Thanks to "Alliedmodders". (2019 year https://forums.alliedmods.net/archive/index.php/t-287052.html)

					g_readyToFix[client] = false;

					g_silentKnife = true;

					FakeClientCommandEx(client, "use weapon_knife");

					RequestFrame(frame_fix, client);
				}
			}
		}
	}
}

public void frame_fix(int client)
{
	if(IsClientInGame(client) == true)
	{
		RequestFrame(frame_fix2, client);
	}
}

public void frame_fix2(int client)
{
	if(IsClientInGame(client) == true)
	{
		RequestFrame(frame_fix3, client);
	}
}

public void frame_fix3(int client)
{
	if(IsClientInGame(client) == true)
	{
		RequestFrame(frame_fix4, client);
	}
}

public void frame_fix4(int client)
{
	if(IsClientInGame(client) == true)
	{
		RequestFrame(frame_fix5, client);
	}
}

public void frame_fix5(int client)
{
	if(IsClientInGame(client) == true)
	{
		FakeClientCommandEx(client, "use weapon_flashbang");

		SetEntProp(client, Prop_Data, "m_bDrawViewmodel", true);
	}
}

public bool TraceEntityFilterPlayer(int entity, int contentMask, int client)
{
	if(LibraryExists("trueexpert-entityfilter") == true)
	{
		if(Trikz_GetEntityFilter(client, entity) == false)
		{
			if(entity > MaxClients)
			{
				return true;
			}
			//return entity > MaxClients;
		}

		else if(Trikz_GetEntityFilter(client, entity) == true)
		{
			//return 0;
			return false;
		}
		
		return false;
	}

	else if(LibraryExists("trueexpert-entityfilter") == false)
	{
		if(entity > MaxClients)
		{
			return true;
		}
		else if(entity <= MaxClients)
		{
			return false;
		}

		return false;
		//;return entity > MaxClients;
	}

	return false;
	//else
	//{
	//	return 0;
	//}
}

/*public Action timer_removePing(Handle timer, int client)
{
	if(g_pingModel[client] > 0)
	{
		RemoveEntity(g_pingModel[client]);

		g_pingModel[client] = 0;

		return Plugin_Continue;
	}

	else if(g_pingModel[client] == 0)
	{
		PrintToServer("Ping model for removing is not valid (%i) for player %N.", g_pingModel[client], client);

		return Plugin_Continue;
	}

	return Plugin_Continue;
}

public Action SDKSetTransmitPing(int entity, int client)
{
	if(IsPlayerAlive(client) == true && g_pingModelOwner[entity] != client && g_partner[g_pingModelOwner[entity]] != g_partner[g_partner[client]])
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}*/

public Action OnSound(int clients[MAXPLAYERS], int& numClients, char sample[PLATFORM_MAX_PATH], int& entity, int& channel, float& volume, int& level, int& pitch, int& flags, char soundEntry[PLATFORM_MAX_PATH], int& seed) //https://github.com/alliedmodders/sourcepawn/issues/476
{
	if(StrEqual(sample, "weapons/knife/knife_deploy1.wav", false) && g_silentKnife == true)
	{
		g_silentKnife = false;

		return Plugin_Handled;
	}

	if(StrEqual(sample, "weapons/flashbang/grenade_hit1.wav", false))
	{
		int owner = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity");

		//if(owner < 0)
		//{
			//owner = 0;
			//return Plugin_Continue;
		//}

		if(g_projectileSoundLoud[owner > 0 ? owner : 0] == entity)
		{
			return Plugin_Handled;
		}
	}

	return Plugin_Continue;
}

public Action timer_clantag(Handle timer, int client)
{
	if(0 < client <= MaxClients && IsClientInGame(client) == true)
	{
		if(g_state[client] == true)
		{
			CS_SetClientClanTag(client, g_clantag[client][1]);

			return Plugin_Continue;
		}

		else if(g_state[client] == false)
		{
			CS_SetClientClanTag(client, g_clantag[client][0]);

			return Plugin_Stop;
		}
	}

	return Plugin_Stop;
}

public void MLStats(const int client, bool ground)
{
	float velPre = SquareRoot(Pow(g_mlsVel[client][0][0], 2.0) + Pow(g_mlsVel[client][0][1], 2.0));
	float velPost = SquareRoot(Pow(g_mlsVel[client][1][0], 2.0) + Pow(g_mlsVel[client][1][1], 2.0));

	Format(g_mlsPrint[client][g_mlsCount[client]], 256, "%i. %.1f - %.1f\n", g_mlsCount[client], velPre, velPost);

	char print[256];

	for(int i = 1; i <= g_mlsCount[client] <= 10; i++)
	{
		Format(print, sizeof(print), "%s%s", print, g_mlsPrint[client][i]);
	}

	if(g_mlsCount[client] > 10)
	{
		Format(print, sizeof(print), "%s...\n%s", print, g_mlsPrint[client][g_mlsCount[client]]);
	}

	if(ground == true)
	{
		float x = g_mlsDistance[client][1][0] - g_mlsDistance[client][0][0];
		float y = g_mlsDistance[client][1][1] - g_mlsDistance[client][0][1];

		Format(print, sizeof(print), "%s\nDistance: %.1f units%s", print, SquareRoot(Pow(x, 2.0) + Pow(y, 2.0)) + 32.0, g_teleported[client] ? " [TP]" : ""); //player hitbox xy size is 32.0 units. Distance measured from player middle back point. My long jump record on Velo++ server is 279.24 units per 2017 winter. I used logitech g303 for my father present. And smooth mouse pad from glorious gaming. map was trikz_measuregeneric longjump room at 240 block. i grown weed and use it for my self also. 20 januarty.

		g_teleported[client] = false;
	}

	if(g_mlstats[g_mlsFlyer[client]] == true)
	{
		Handle KeyHintText = StartMessageOne("KeyHintText", g_mlsFlyer[client]);

		BfWrite bfmsg = UserMessageToBfWrite(KeyHintText);

		bfmsg.WriteByte(true);

		bfmsg.WriteString(print);

		EndMessage();
	}

	if(g_mlstats[client] == true)
	{
		Handle KeyHintText = StartMessageOne("KeyHintText", client);

		BfWrite bfmsg = UserMessageToBfWrite(KeyHintText);

		bfmsg.WriteByte(true);

		bfmsg.WriteString(print);

		EndMessage();
	}

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) == true && IsClientObserver(i) == true)
		{
			int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget");
			int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode");

			if(observerMode < 7 && (observerTarget == client || observerTarget == g_mlsFlyer[client]) && g_mlstats[i] == true)
			{
				Handle KeyHintText = StartMessageOne("KeyHintText", i);

				BfWrite bfmsg = UserMessageToBfWrite(KeyHintText);

				bfmsg.WriteByte(true);

				bfmsg.WriteString(print);

				EndMessage();
			}
		}
	}
}

public int Stuck(int client)
{
	float mins[3];
	float maxs[3];
	float origin[3];

	GetClientMins(client, mins);
	GetClientMaxs(client, maxs);

	GetClientAbsOrigin(client, origin);

	TR_TraceHullFilter(origin, origin, mins, maxs, MASK_PLAYERSOLID, TR_donthitself, client); //Skiper, Gurman idea, plugin 2020 year.

	return TR_GetEntityIndex();
}

public bool TR_donthitself(int entity, int mask, int client)
{
	if(LibraryExists("trueexpert-entityfilter") == true)
	{
		if(entity != client && 0 < entity <= MaxClients && g_partner[entity] == g_partner[g_partner[client]])
		{
			return true;
		}
	}

	else if(LibraryExists("trueexpert-entityfilter") == false)
	{
		if(entity != client && 0 < entity <= MaxClients)
		{
			return true;
		}
	}

	return false;
}

public int Native_GetClientButtons(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	return g_entityButtons[client];
}

public int Native_GetClientPartner(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	return g_partner[client];
}

public int Native_GetTimerState(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	if(IsFakeClient(client) == false)
	{
		if(g_state[client] == true)
		{
			return true;
		}
	}

	else if(IsFakeClient(client) == true)
	{
		return 0;
	}

	return 0;
}

public int Native_SetPartner(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	int partner = GetNativeCell(2);

	g_partner[client] = partner;
	g_partner[partner] = client;

	return partner;
}

public int Native_Restart(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	Restart(client);
	Restart(g_partner[client]);

	if(0 < client <= MaxClients)
	{
		int value = g_partner[client];
		//if(g_partner[client] == true)
		//{
		return value;
		//}
	}

	else if(!(0 < client <= MaxClients))
	{
		return 0;
	}

	return 0;
}

public int Native_GetDevmap(Handle plugin, int numParams)
{
	return g_devmap;
}

public Action timer_clearlag(Handle timer)
{
	ServerCommand("mat_texture_list_txlod_sync reset");

	return Plugin_Continue;
}

float GetGroundPos(int client) //https://forums.alliedmods.net/showpost.php?p=1042515&postcount=4
{
	float origin[3];
	GetClientAbsOrigin(client, origin);

	float originDir[3];
	GetClientAbsOrigin(client, originDir);

	originDir[2] -= 90.0;

	float mins[3];
	GetClientMins(client, mins);

	float maxs[3];
	GetClientMaxs(client, maxs);

	float pos[3];
	TR_TraceHullFilter(origin, originDir, mins, maxs, MASK_PLAYERSOLID, TraceEntityFilterPlayer, client);
	TR_GetEndPosition(pos);
	//PrintToServer("%f", pos[2])
	return pos[2];
	//bool didHit = TR_DitHit(null);
	//if(TR_DitHit(INVALID_HANDLE) == true)
	//{
	//}
	//if(didHit == true)
	//{
	//}
		//TR_GetEndPosition(pos);

		//return pos[2];
	//else if(TR_DitHit(null) == false)
	//{
		//PrintToServer("Is not hited ground for player %N", client);

		//return pos[2];
	//}

	//return pos[2];
	//if(TR_DidHit(null) != true) //sweeden information
	//else if(TR_DitHit(null) == false)
}

public int GetColour(const int r, const int g, const int b, const int a)
{
	int color = 0;

	color |= (r & 255) << 24;
	color |= (g & 255) << 16;
	color |= (b & 255) << 8;
	color |= (a & 255) << 0;

	return color;
}